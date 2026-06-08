package kr.or.ddit.domain.apt.apiApartment.mapper;

import kr.or.ddit.domain.apt.apiApartment.vo.AptComplexEntity;
import kr.or.ddit.domain.apt.apiApartment.vo.AptHoTyDTO;
import kr.or.ddit.domain.apt.apiApartment.vo.AptInfraEntity;
import kr.or.ddit.domain.apt.apiApartment.vo.MgmtOfficeEntity;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.apt.main.vo.AptDetailVO;
import kr.or.ddit.domain.apt.main.vo.AptUnitVO;
import kr.or.ddit.domain.member.manager.vo.ManagerVO;
import kr.or.ddit.domain.member.vo.AuthVO;
import kr.or.ddit.domain.member.vo.MemberVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IAptApiMapper {

    List<String> selectLawdCdList(
            String sido,
            String sigungu,
            String emd
    );

    // =========================
    // 단건 등록
    // =========================
    int existsApt(String kaptCode);

    void insertApt(AptComplexEntity apt);

    void insertMgmtOffice(MgmtOfficeEntity mgmt);

    void insertMember(MemberVO member);

    void insertManager(ManagerVO manager);

    void insertAuth(AuthVO auth);

    // =========================
    // batch
    // =========================
    void insertAptBatch(
            List<AptComplexEntity> list
    );

    void insertMgmtOfficeBatch(
            List<MgmtOfficeEntity> list
    );

    void insertMemberBatch(
            List<MemberVO> list
    );

    void insertManagerBatch(
            List<ManagerVO> list
    );

    void insertAuthBatch(
            List<AuthVO> list
    );

    void insertAptUnitBatch(
            List<AptUnitVO> list
    );

    void insertAptDetailBatch(
            List<AptDetailVO> list
    );

    void insertAptHoTyBatch(
            List<AptHoTyDTO> list
    );

    // =========================
    // infra
    // =========================
    void insertInfraOne(
            AptInfraEntity infra
    );

    // =========================
    // sequence
    // =========================
    long getMemberSeq();

    long getMgmtOfcNoSeq();

    // =========================
    // 지역 조회
    // =========================
    List<String> selectSidoList();

    List<String> selectSigunguList(
            String sido
    );

    List<String> selectEmdList(
            String sido,
            String sigungu
    );

    // =========================
    // 단지 조회
    // =========================
    List<AptComplexEntity> selectAptList(
            String sido,
            String sigungu,
            String emd
    );

    // =========================
    // 좌표
    // =========================
    List<AptComplexEntity> selectNoCoordList();

    void updateLatLng(
            AptComplexEntity apt
    );

    // =========================
    // 입주민 배정
    // =========================
    List<AptDetailVO> selectAvailableUnits(
            List<String> aptList
    );

    void updateEmpty(String hoNo);

    AptComplexVO selectAptComplex(String kaptCode);

    List<AptUnitVO> selectAptUnitList(String kaptCode);

    int updateComplex(AptComplexVO complex);

    int updateUnit(AptUnitVO unit);

    void insertMgmtOfficeBank(MgmtOfficeEntity mgmt);

    void insertAptHoTy(AptHoTyDTO hoType);
}