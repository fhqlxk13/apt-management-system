package kr.or.ddit.domain.central.mapper;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.central.dto.RentListingMapDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IRentMapper {

    List<RentListingMapDTO> selectRentListingMapList();

    RentListingMapDTO selectRentListingDetail(@Param("rentLstgNo") String rentLstgNo);

    int selectRentListingCount(PaginationInfoVO<RentListingMapDTO> pagingVO);

    List<RentListingMapDTO> selectRentListingPagingList(PaginationInfoVO<RentListingMapDTO> pagingVO);

    List<RentListingMapDTO> selectRentListByComplexNo(String aptCmplexNo);

    List<RentListingMapDTO> selectRentMapComplexList();
}
