package kr.or.ddit.domain.central.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.central.dto.RentListingMapDTO;

import java.util.List;

public interface IRentService {
    List<RentListingMapDTO> selectRentListingMapList();

    RentListingMapDTO selectRentListingDetail(String rentLstgNo);

    int selectRentListingCount(PaginationInfoVO<RentListingMapDTO> pagingVO);

    List<RentListingMapDTO> selectRentListingPagingList(PaginationInfoVO<RentListingMapDTO> pagingVO);

    List<RentListingMapDTO> selectRentListByComplexNo(String aptCmplexNo);

    List<RentListingMapDTO> selectRentMapComplexList();
}
