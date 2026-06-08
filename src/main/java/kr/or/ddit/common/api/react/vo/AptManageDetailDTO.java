package kr.or.ddit.common.api.react.vo;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.apt.main.vo.AptUnitVO;
import lombok.Data;

import java.util.List;

@Data
public class AptManageDetailDTO {
    private boolean registered;
    private AptComplexVO complex;
    private List<AptUnitVO> unitList;
}