package kr.or.ddit.domain.central.admin.dto;

import kr.or.ddit.domain.central.admin.vo.SbmsnDocVO;
import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class AplctDTO {

    private String aplctNo;
    private String annNo;
    private String userNo;
    private String userId;
    private String userNm;
    private Date regDt;
    private Date mdfDt;
    private String aplctSttsCd;
    private String aptCmplexNo;
    private String hoTyNo;
    private String tyNm;
    private String exclusiveSize;
    private int roomCnt;
    private int bathroomCnt;
    private String ttl;
    private List<SbmsnDocVO> docList;
}
