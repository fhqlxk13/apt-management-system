package kr.or.ddit.domain.main.controller;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.apt.mgmtOffice.main.service.IMgmtOfficeService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Slf4j
@Controller
public class HomeController {

	@Autowired
	private IMgmtOfficeService mgmtOfficeService;

	@Autowired
	private IAptComplexService aptComplexService;

	@GetMapping("/")
	public String main(
			@RequestParam(required = false) String sidoNm,
			@RequestParam(required = false) String keyword,
			@RequestParam(required = false, defaultValue = "1") int currentPage,
			Model model) {

		log.info("메인 아파트 검색 요청 sidoNm = {}, keyword = {}, currentPage = {}",
				sidoNm, keyword, currentPage);

		// 지역 select 박스에 사용할 시도 목록
		List<String> sidoList = aptComplexService.selectSidoList();
		model.addAttribute("sidoList", sidoList);

		/*
		 * 검색 버튼을 누르지 않은 최초 진입인지 구분하기 위한 값
		 * - sidoNm이 들어온 경우에만 실제 검색이 수행된 것으로 본다.
		 */
		boolean searched = sidoNm != null && !sidoNm.isBlank();
		model.addAttribute("searched", searched);

		// 화면에서 검색 조건을 유지하기 위해 다시 model에 담아준다.
		model.addAttribute("sidoNm", sidoNm);
		model.addAttribute("keyword", keyword);

		/*
		 * 최초 메인 진입 시에는 검색 결과 영역을 띄우지 않고 main.jsp만 반환
		 */
		if (!searched) {
			return "main";
		}

		/*
		 * 기존 프로젝트에서 사용하던 PaginationInfoVO 방식으로 페이징 처리
		 * 카드형 리스트이므로 한 화면에 6개씩 노출되도록 설정
		 * 필요하면 10개 등으로 변경 가능
		 */
		PaginationInfoVO<AptComplexVO> pagingVO = new PaginationInfoVO<>();
		pagingVO.setScreenSize(10);
		pagingVO.setCurrentPage(currentPage);

		// 검색 조건에 맞는 전체 건수 조회
		int totalRecord = aptComplexService.selectMainAptCount(sidoNm, keyword);
		pagingVO.setTotalRecord(totalRecord);

		// 실제 현재 페이지 목록 조회
		List<AptComplexVO> aptList =
				aptComplexService.selectMainAptList(pagingVO, sidoNm, keyword);

		pagingVO.setDataList(aptList);

		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("aptList", aptList);

		return "main";
	}

	// 접근 거부 핸들러에서 오는 컨트롤러
	@GetMapping("/accessError")
	public String accessError(
			@RequestParam(required = false) String msg,
			@RequestParam(required = false) String prevPage ,Model model) {

		model.addAttribute("msg", msg);
		model.addAttribute("prevPage", prevPage);

		return "accessError";
	}

	@GetMapping("/error")
	public String error(
			@RequestParam(required = false) String msg,
			@RequestParam(required = false) String prevPage ,Model model) {

		model.addAttribute("msg", msg);
		model.addAttribute("prevPage", prevPage);

		return "accessError";
	}

	@PreAuthorize("hasRole('MEMBER')")
	@GetMapping("/react/test01")
	public String react(){
		return "ztestview/react_link";
	}
}
