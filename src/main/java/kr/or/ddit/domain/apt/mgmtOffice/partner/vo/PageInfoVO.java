package kr.or.ddit.domain.apt.mgmtOffice.partner.vo;

import lombok.Data;

/**
 * 페이지 정보 VO
 * - JSP 페이지네이션에서 필요한 값 보관
 */
@Data
public class PageInfoVO {

    /** 현재 페이지 */
    private int currentPage;

    /** 시작 페이지 */
    private int startPage;

    /** 끝 페이지 */
    private int endPage;

    /** 전체 페이지 */
    private int totalPage;

    /** 전체 건수 */
    private int totalCount;

    /** 페이지당 행 수 */
    private int size;

    /** 페이지 정보 생성 */
    public static PageInfoVO of(int currentPage, int totalCount, int size) {
        PageInfoVO pageInfo = new PageInfoVO();

        // 기본값 보정
        if (currentPage < 1) {
            currentPage = 1;
        }
        if (size < 1) {
            size = 10;
        }

        // 전체 페이지 계산
        int totalPage = (int) Math.ceil((double) totalCount / size);
        if (totalPage < 1) {
            totalPage = 1;
        }

        // 현재 페이지 보정
        if (currentPage > totalPage) {
            currentPage = totalPage;
        }

        // 페이지 블록 계산
        int blockSize = 5;
        int startPage = ((currentPage - 1) / blockSize) * blockSize + 1;
        int endPage = Math.min(startPage + blockSize - 1, totalPage);

        // 결과값 보관
        pageInfo.setCurrentPage(currentPage);
        pageInfo.setStartPage(startPage);
        pageInfo.setEndPage(endPage);
        pageInfo.setTotalPage(totalPage);
        pageInfo.setTotalCount(totalCount);
        pageInfo.setSize(size);

        return pageInfo;
    }
}
