package kr.or.ddit.domain.central.board.vo;

import lombok.Data;

import java.util.Date;

@Data
public class NoticeVO {


    private String annNo;
    private String boardNo;
    private String ttl;
    private String cn;
    private String wrtrId;

    private String topFxdYn;

    private Date pblancBgngDt;
    private Date pblancEndDt;

    private Date rcrtBgngDt;
    private Date rcrtEndDt;

    private Date regDttm;
    private Date mdfDttm;

    private Integer inqCnt;

    private String delYn;

    private String atchFileId;




}
