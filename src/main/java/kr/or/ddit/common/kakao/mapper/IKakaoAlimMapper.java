package kr.or.ddit.common.kakao.mapper;

import kr.or.ddit.common.kakao.vo.KakaoAlimVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 카카오 알림 Mapper
 *
 * Mapper란?
 * Java 메서드와 SQL(XML)을 연결하는 인터페이스입니다.
 *
 * 왜 사용?
 * Controller, Service에서 직접 SQL을 작성하지 않고
 * DB 처리 역할을 분리하기 위해 사용합니다.
 *
 * MyBatis가 이 인터페이스와 XML을 자동으로 연결해줍니다.
 */
@Mapper
public interface IKakaoAlimMapper {

    /**
     * 다음 알림번호 조회
     *
     * 예)
     * ALIM000001
     * ALIM000002
     */
    String selectNextAlimNo();

    /**
     * 카카오 알림 저장
     *
     * KAKAO_ALIM 테이블에
     * 알림 정보를 INSERT 합니다.
     */
    int insertKakaoAlim(KakaoAlimVO vo);

    /**
     * 내 알림 목록 조회
     *
     * userNo 회원의
     * 전체 알림 목록을 조회합니다.
     */
    List<KakaoAlimVO> selectMyKakaoAlimList(String userNo);

    /**
     * 알림 읽음 처리
     *
     * READ_YN 값을
     * N → Y 로 변경합니다.
     *
     * @Param 이란?
     * Mapper XML에서 파라미터 이름을
     * 그대로 사용하기 위해 붙입니다.
     */
    int updateReadYn(
            @Param("alimNo") String alimNo,
            @Param("userNo") String userNo
    );

    /**
     * 읽지 않은 알림 개수 조회
     *
     * 상단 종모양(🔔) 배지 숫자에
     * 표시할 값을 조회할 때 사용합니다.
     *
     * 예)
     * 3 → 안 읽은 알림 3건
     */
    int selectUnreadCount(String userNo);
}