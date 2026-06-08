package kr.or.ddit.domain.member.service;

import kr.or.ddit.common.enums.ServiceResult;
import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.util.AESUtil;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.member.mapper.IMemberMapper;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;
import java.util.UUID;

@Slf4j
@Service
public class MemberServiceImpl implements IMemberService {

    @Autowired
    private IMemberMapper memberMapper;

    @Autowired
    private IAttachFileMapper attachFileMapper;

    @Autowired
    private PasswordEncoder pe;

    @Autowired
    private AESUtil aes;

    @Autowired
    private GoogleDriveService googleDriveService;

    @Transactional(rollbackFor = Exception.class)   // encrypt(암호화)에러와 insert에러 모두 트랜잭션 적용
    @Override
    public ServiceResult joinMember(MemberVO member, MultipartFile profFile) {
        ServiceResult res = ServiceResult.FAILED;

        try{
            if(member.getUserPw() != null) {
                member.setUserPw(pe.encode(member.getUserPw()));    // 비밀번호 암호화
            }

            if(member.getUserRrno() != null){       // 주민번호 암호화
                member.setUserRrno(aes.encrypt(member.getUserRrno()));
                log.info("암호화된 주민번호 {}",member.getUserRrno());
            }

            // 프로필 파일 업로드 처리
            AttachFileVO attachFile = null;
            if(profFile != null && !profFile.isEmpty()){

                String originalFilename = profFile.getOriginalFilename();
                String uuid = UUID.randomUUID().toString().replace("-", "");

                // -------------- 필수 커스텀 지정 부분 -------------------
                // 저장 될 파일명
                String savedFileName = uuid + "_" +  originalFilename;
                // 경로 설정
                String folderPath = "member/prof_img/" + member.getUserId();
                String fullPath = folderPath + "/" + savedFileName;
                String cat = "mem_prof";
                // ------------- 필수 커스텀 지정 부분 end -----------------

                // 구글 드라이브에 업로드
                String googleId = googleDriveService.uploadFile(profFile, folderPath, savedFileName);

                // 데이터베이스에 인서트
                long seq = attachFileMapper.getSeqFileGroupNo();

                attachFile = AttachFileVO.fileSettings(profFile, seq, cat, savedFileName, googleId,
                    fullPath,1 );
                int cnt = attachFileMapper.insertAttachFile(attachFile);

                if(cnt > 0){    // 파일 인서트 성공시
                    // 매핑되는 테이블 컬럼(member의 profFileId)에  인서트
                    member.setProfFileId(attachFile.getFileGroupNo() + "_" + savedFileName);
                }
            }

            int status = memberMapper.joinMember(member);     // 회원 등록

            if(status > 0){
                memberMapper.addAuth(member.getUserNo());
                res = ServiceResult.OK;
            }else{
                res = ServiceResult.FAILED;
            }
        }catch (Exception e){
            log.error("회원가입 실패: {}", e.getMessage());   // 에러 원인 로그
            throw new RuntimeException("회원가입 처리 중 오류 발생", e);   // 트랜잭션 롤백 유도
        }

        return res;
    }

    @Override
    public ServiceResult idCheck(@Param("userId") String userId) {
        int count = memberMapper.idCheck(userId);
        if(count > 0){
            return ServiceResult.EXIST;
        }else{
            return ServiceResult.NOTEXIST;
        }
    }

    @Override
    public ServiceResult updateMember(MemberVO member) {
        try {
            // 🔥 로그 먼저 찍어
            log.info("🔥 userNo = [{}]", member.getUserNo());
            log.info("🔥 userNm = [{}]", member.getUserNm());
            log.info("🔥 userTelno = [{}]", member.getUserTelno());
            log.info("🔥 userEml = [{}]", member.getUserEml());

            // 🔥 주민번호 암호화
            if(member.getUserRrno() != null && !member.getUserRrno().isEmpty()) {
                member.setUserRrno(aes.encrypt(member.getUserRrno()));
            }

            int status = memberMapper.updateMember(member);

            // 🔥 결과 로그
            log.info("🔥 update 결과 = {}", status);

            return status > 0 ? ServiceResult.OK : ServiceResult.FAILED;

        } catch (Exception e) {
            log.error("회원정보 수정 실패", e);
            return ServiceResult.FAILED;
        }
    }

    @Override
    public MemberVO getMemberByUserNo(String userNo) {
        return memberMapper.getMemberByUserNo(userNo);
    }

    @Override
    public void updateAlarm(Map<String, Object> param) {
        memberMapper.updateAlarm(param);
    }
    }


