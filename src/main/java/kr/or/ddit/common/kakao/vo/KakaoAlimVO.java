package kr.or.ddit.common.kakao.vo;

import lombok.Data;

/**
 * 카카오 알림 VO
 *
 * VO란?
 * DB 조회/저장 데이터를 Java 객체로 담는 클래스입니다.
 *
 * 왜 사용?
 * Controller, Service, Mapper 사이에서 알림 데이터를 깔끔하게 전달하기 위해 사용합니다.
 */
@Data
public class KakaoAlimVO {

    /** 알림번호 */
    private String alimNo;

    /** 수신회원번호 */
    private String userNo;

    /** 알림유형코드 */
    private String alimTyCd;

    /** 알림제목 */
    private String alimTtl;

    /** 알림내용 */
    private String alimCn;

    /** 이동 URL */
    private String linkUrl;

    /** 읽음여부 */
    private String readYn;

    /** 발송일시 */
    private String sndDttm;

    /** 등록자 */
    private String rgtrId;
}