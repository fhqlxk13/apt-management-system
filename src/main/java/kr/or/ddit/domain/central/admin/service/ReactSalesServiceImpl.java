package kr.or.ddit.domain.central.admin.service;

import kr.or.ddit.domain.apt.main.vo.AptDetailVO;
import kr.or.ddit.domain.central.admin.mapper.IReactSalesMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ReactSalesServiceImpl implements IReactSalesService {

    @Autowired
    private IReactSalesMapper reactSalesMapper;

    @Override
    public List<String> selectBuildingList(String aptCmplexNo) {
        return reactSalesMapper.selectBuildingList(aptCmplexNo);
    }

    @Override
    public List<AptDetailVO> selectHoList(String aptCmplexNo, String dongNm) {
        return reactSalesMapper.selectHoList(aptCmplexNo, dongNm);
    }

    @Override
    @Transactional
    public void registerRentListing(
            Map<String, Object> param
    ) {

        List<String> hoNos = (List<String>) param.get("hoNos");


        /*가져온 Map 에 담긴 정보 꺼내서 담고 insert 진행하기*/
        for (String hoNo : hoNos) {

            Map<String, Object> map = new HashMap<>();

            map.put("hoNo", hoNo);

            map.put("rentTtl", param.get("rentTtl"));

            map.put("rentTypeCd", param.get("rentTypeCd"));

            map.put("dpstAmt", param.get("dpstAmt"));

            Object monthlyRentAmt = param.get("mthlyRentAmt");

            map.put("mthlyRentAmt", monthlyRentAmt == null || monthlyRentAmt.toString().isBlank()
                    ? null
                    : monthlyRentAmt
            );

            map.put("rentLstgCn", param.get("rentLstgCn"));

            map.put("rcrtLstgSttsCd", param.get("rcrtLstgSttsCd"));

            List<String> docTyCdList = (List<String>) param.get("docTyCdList");

            String existRentLstgNo = reactSalesMapper.selectExistRentListing(hoNo);

            Map<String, Object> contractInfo = reactSalesMapper.selectCurrentContractInfo(hoNo);

            map.put("dealSttsCd", "AVL");

            if (contractInfo != null) {
                map.put("mvinPsblDt", contractInfo.get("MVOUT_DT"));
            } else {
                map.put("mvinPsblDt", new Date());
            }

            String rentLstgNo;

            if (existRentLstgNo != null) {
                rentLstgNo = existRentLstgNo;
                map.put("rentLstgNo", rentLstgNo);

                reactSalesMapper.updateRentListing(map);

                reactSalesMapper.deleteRentContractDoc(rentLstgNo);

            } else {
                reactSalesMapper.insertRentListing(map);
                rentLstgNo = (String) map.get("rentLstgNo");
            }


            if (docTyCdList != null && !docTyCdList.isEmpty()) {
                for (String docTyCd : docTyCdList) {

                    Map<String, Object> docMap = new HashMap<>();

                    docMap.put("rentLstgNo", rentLstgNo);

                    docMap.put("sbmsnDocTyCd", docTyCd);

                    reactSalesMapper.insertRentContractDoc(docMap);
                }
            }
        }
    }

    @Transactional
    @Override
    public void deleteRentListing(
            List<String> hoNos
    ) {

        for (String hoNo : hoNos) {

            String rentLstgNo =
                    reactSalesMapper
                            .selectExistRentListing(
                                    hoNo
                            );

            if (rentLstgNo == null) {
                continue;
            }

            reactSalesMapper.deleteRentContractDoc(rentLstgNo);

            reactSalesMapper.deleteRentListing(rentLstgNo);
        }
    }
}
