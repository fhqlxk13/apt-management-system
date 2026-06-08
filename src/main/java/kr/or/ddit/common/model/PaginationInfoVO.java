package kr.or.ddit.common.model;

import lombok.Data;

import java.util.List;

@Data
public class PaginationInfoVO<T> {
	private int totalRecord;		// 총 게시글 수
	private int totalPage;			// 총 페이지 수
	private int currentPage;		// 현재 페이지
	private int screenSize = 10;	// 페이지 당 게시글 수
	private int blockSize = 5;		// 페이지 블록 수
	private int startRow;			// 시작 row
	private int endRow;				// 끝 row
	private int startPage;			// 시작 페이지
	private int endPage;			// 끝 페이지
	private List<T> dataList; 		// 결과를 담을 데이터 리스트
	private String searchType;		// 검색 타입
	private String searchWord ;		// 검색 단어
	private T searchVO;

	public PaginationInfoVO() {
		super();
	}

	// PaginationInfoVO 객체를 만들 때, 한 페이지당 게시글 수와 페이지 블록 수를 원하는 값으로
	// 초기화 할 수 있습니다.
	public PaginationInfoVO(int screenSize, int blockSize) {
		super();
		this.screenSize = screenSize;
		this.blockSize = blockSize;
	}

	public void setTotalRecord(int totalRecord) {
		// 총 게시글 수를 저장하고, 총 게시글수를 페이지 당 나타낼 게시글 수로 나눠 총 페이지수를 구합니다.
		this.totalRecord = totalRecord;
		// 총 페이지 수 = 총 게시글 수 / 1페이지당 보여줄 게시글 수
		// ceil은 올림
		totalPage = (int)Math.ceil(totalRecord / (double)screenSize);
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage; // 현재 페이지 저장
		// startRow, endRow, startRow, endPage를 currentPage 값을 활용해 자동 설정
		// startRow, endRow는 screenSize의 값을 활용해서 공식화
		endRow = currentPage * screenSize; // 끝 row = 현재 페이지 * 한 페이지당 게시글 수
		startRow = endRow - (screenSize - 1); // 시작 row = 끝 row - (한 페이지당 게시글 수 - 1)

		// startPage, endPage는 blockSize의 값을 활용해서 공식화
		// 마지막 페이지 = (현재 페이지 + (블록 사이즈 - 1)) / 블록 사이즈 * 블록 사이즈
		// / blockSize * blockSize는 1,2,3,4,5... 페이지마다 실수계산이 아닌 정수 계산을 이용해
		// endPage를 구하기 위함
		endPage = (currentPage + (blockSize - 1)) / blockSize * blockSize;

		if (totalPage > 0 && endPage > totalPage) {
			endPage = totalPage;
		}

		startPage = ((currentPage - 1) / blockSize) * blockSize + 1;

		if(startPage < 1){
			 startPage = 1;
		}
	}

	public String getPagingHTML() {
		StringBuffer html = new StringBuffer();
		html.append("<ul class='pagination pagination-sm m-0'>");

		// prev 1 2 3 4 5 next
		// 'Prev' 버튼은 현재 페이지가 blockSize(현재 5)를 넘었을 때 나타나야 합니다
		// 현재 페이지가 1-5 사이의 범위에 있다면 startPage는 무조건 1이 됩니다.
		// 현재 페이지가 blockSize 보다 큰 6~ 범위에 있을때부터 startPage는 blockSize 보다 큰 6부터
		// 시작합니다. 그런 점을 고려한다면, 현재 페이지 1보다 무조건 다음 페이지에 있어야만 'Prev' 버튼을
		// 활용할 수 있으므로 조건식을 아래와 작성할 수 있습니다.
		if(startPage > 1) {
			html.append("<li class='page-item'><a href='' class='page-link' data-page='"
					+ (startPage - blockSize) + "'>Prev</a></li>");
		}
		// 반복문 내 조건은 총 페이지가 있고 현재 페이지에 따라서 endPage값이 결정됩니다.
		// 총 페이지가 14개고 현재 페이지가 9페이지라면 넘어가야할 페이지가 남아 있는 것이기 때문에 endPage
		// 만큼 반복되고 넘어가야할 페이지가 존재하지 않는 상태라면 마지막 페이지가 포함되어 있는 block영역
		// 이므로 totalPage 만큼 반복하면 됩니다.
		int realEndPage = (endPage < totalPage) ? endPage : totalPage;

		for (int i = startPage; i <= realEndPage; i++) {
			if (i == currentPage) {
				html.append("<li class='page-item active'><span class='page-link'>" + i + "</span></li>");
			} else {
				html.append("<li class='page-item'><a href='' class='page-link' data-page='" + i + "'>" + i + "</a></li>");
			}
		}

		if (endPage < totalPage) {
			// 더 있다는 표시로 '...' 추가 (클릭 안되는 스타일)
			html.append("<li class='page-item disabled'><span class='page-link' style='border:none; background:none;'>...</span></li>");
			// Next 버튼
			html.append("<li class='page-item'><a href='' class='page-link' data-page='"
					+ (endPage + 1) + "'>Next</a></li>");
		}

		html.append("</ul>");
		return html.toString();
	}

}


