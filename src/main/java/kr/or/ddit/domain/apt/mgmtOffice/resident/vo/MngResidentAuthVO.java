package kr.or.ddit.domain.apt.mgmtOffice.resident.vo;

import kr.or.ddit.domain.apt.mgmtOffice.move.vo.MngResidentMoveVO;
import lombok.Data;

import java.util.Date;

@Data
public class MngResidentAuthVO extends MngResidentMoveVO {

    // RESIDENT_RQST
    private String rqstNo;
    private String rqstTyCd;

    private String rcptDt;
    private String mvinPrdDt;
    private String mvoutPrdDt;

    private String aprvDt;

    private String mvoutRsnCn;
    private String rjctRsnCn;

    private String mngNo;
    private String spclCn;

    // 계산 상태
    private String rqstSttsCd;

    // AUTH
    private String userRoleCd;
    private String userNo;
    private String hoNo;

}