package kr.or.ddit.domain.central.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.central.dto.RentListingMapDTO;
import kr.or.ddit.domain.central.mapper.IRentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class RentServiceImpl implements IRentService {

    @Autowired
    private IRentMapper rentMapper;

    // 매물 목록/지도 표시용 매물 리스트 조회
    @Override
    public List<RentListingMapDTO> selectRentListingMapList() {
        List<RentListingMapDTO> list =
                rentMapper.selectRentListingMapList();

        for (RentListingMapDTO dto : list) {

            filterComplexImages(dto);
        }
        return list;
    }

    // 매물 상세 조회
    @Override
    public RentListingMapDTO selectRentListingDetail(String rentLstgNo) {
        RentListingMapDTO dto = rentMapper.selectRentListingDetail(rentLstgNo);

        filterComplexImages(dto);

        return dto;
    }

    @Override
    public int selectRentListingCount(PaginationInfoVO<RentListingMapDTO> pagingVO) {
        return rentMapper.selectRentListingCount(pagingVO);
    }

    @Override
    public List<RentListingMapDTO> selectRentListingPagingList(
            PaginationInfoVO<RentListingMapDTO> pagingVO
    ) {
        List<RentListingMapDTO> list = rentMapper.selectRentListingPagingList(pagingVO);

        for(RentListingMapDTO dto : list){filterComplexImages(dto);}

        return list;
    }

    /**
     * 특정 단지의 매물 목록 조회
     *
     * 지도 마커 클릭 시 좌측 목록/상세 패널에 표시할 데이터.
     */
    @Override
    public List<RentListingMapDTO> selectRentListByComplexNo(String aptCmplexNo) {
        List<RentListingMapDTO> list = rentMapper.selectRentListByComplexNo(aptCmplexNo);

        for (RentListingMapDTO dto : list) {
            filterComplexImages(dto);

            System.out.println("googleIds = " + dto.getRprsntImgGoogleIds());
            System.out.println("cats      = " + dto.getRprsntImgCats());
        }

        return list;
    }

    @Override
    public List<RentListingMapDTO> selectRentMapComplexList() {
        return rentMapper.selectRentMapComplexList();
    }

    private void filterComplexImages(
            RentListingMapDTO dto
    ) {
        if (dto == null) {return;
        }
        String googleIds = dto.getRprsntImgGoogleIds();
        String cats = dto.getRprsntImgCats();
        if (googleIds == null || cats == null) {
            dto.setRprsntImgGoogleIds("");
            return;
        }
        String[] idArr = googleIds.split(",");
        String[] catArr = cats.split(",");
        List<String> filtered = new ArrayList<>();

        int len = Math.min(
                idArr.length,
                catArr.length
        );

        for (int i = 0; i < len; i++) {
            if ("complexImage".equals(catArr[i])) {
                filtered.add(idArr[i]);
            }
        }
        dto.setRprsntImgGoogleIds(
                String.join(",", filtered)
        );
    }
}
