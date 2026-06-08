package kr.or.ddit.domain.central.admin.vo;

import kr.or.ddit.common.file.vo.AttachFileVO;
import lombok.Data;

import java.util.Date;

@Data
public class SbmsnDocVO {
    private String sbmsnDocNo;
    private String sbmsnDocTyCd;
    private Date regDt;
    private Date mdfcnDt;
    private String atchFileId;
    private String aplctNo;

    private AttachFileVO fileInfo;
}
