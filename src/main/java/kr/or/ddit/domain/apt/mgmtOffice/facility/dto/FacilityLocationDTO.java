package kr.or.ddit.domain.apt.mgmtOffice.facility.dto;

import lombok.Data;

/**
 * 시설 위치 선택용 DTO
 *
 * 사용 목적
 * - APT_UNIT 동 목록 조회
 * - APT_DETAIL 층 목록 조회
 * - APT_DETAIL 호 목록 조회
 * - 시설 등록/수정 화면의 위치 select 옵션 출력
 */
@Data
public class FacilityLocationDTO {

    /** 동번호, APT_UNIT.DONG_NO */
    private String dongNo;

    /** 동명, APT_UNIT.DONG_NM */
    private String dongNm;

    /** 층, APT_DETAIL.FLOOR */
    private String floor;

    /** 호번호 PK, APT_DETAIL.HO_NO */
    private String hoNo;

    /** 호 표시값, APT_DETAIL.HO */
    private String ho;
}