package kr.or.ddit.domain.apt.apiApartment.service;

import kr.or.ddit.common.util.AESUtil;
import kr.or.ddit.domain.apt.apiApartment.mapper.IApiMemberMapper;
import kr.or.ddit.domain.apt.apiApartment.mapper.IAptApiMapper;
import kr.or.ddit.domain.apt.apiApartment.vo.AptComplexEntity;
import kr.or.ddit.domain.apt.apiApartment.vo.HshldHeadEntity;
import kr.or.ddit.domain.apt.apiApartment.vo.HshldMemberEntity;
import kr.or.ddit.domain.apt.main.vo.AptDetailVO;
import kr.or.ddit.domain.member.vo.AuthVO;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.Random;

@Service
@Slf4j
public class AptMemberApiServiceImpl implements IAptMemberApiService {

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private IAptApiMapper aptMapper;

    @Autowired
    private IApiMemberMapper memberMapper;

    AESUtil aesUtil = new AESUtil();

    @Override
    public List<String> getSidoList() {
        return aptMapper.selectSidoList();
    }

    @Override
    public List<String> getSigunguList(String sido) {
        return aptMapper.selectSigunguList(sido);
    }

    @Override
    public List<String> getEmdList(String sido, String sigungu) {
        return aptMapper.selectEmdList(sido, sigungu);
    }

    @Override
    public List<AptComplexEntity> getAptList(String sido, String sigungu, String emd) {
        return aptMapper.selectAptList(sido, sigungu, emd);
    }

    @Override
    public void createDummyUsers(int count) {
        for (int i = 0; i < count; i++) {

            MemberVO member = new MemberVO();
            AuthVO auth = new AuthVO();
            String encodedPw = passwordEncoder.encode("1234");

            member.setUserId(generateUniqueUserId());
            member.setUserPw(encodedPw);
            member.setUserNm(generateRandomName());
            member.setUserTelno(generatePhoneNumber());
            try {
                member.setUserRrno(aesUtil.encrypt(generateRrn()));
            } catch (Exception e) {
                throw new RuntimeException(e);
            }

            memberMapper.insertMember(member);
            auth.setUserNo(member.getUserNo());
            auth.setAuth("ROLE_MEMBER");
            memberMapper.insertMemberAuth(auth);
        }

    }


    @Override
    public int getNotAssignedUserCount() {
        return memberMapper.selectNotAssignedUserCount();
    }

    @Override
    public void assignResidents(List<String> aptList, int count) {

        Random random = new Random();

        List<AptDetailVO> units = aptMapper.selectAvailableUnits(aptList);

        List<MemberVO> users = memberMapper.selectNotAssignedTestUsers();

        if (users.isEmpty()) {
            throw new RuntimeException("유저 없음");
        }

        if (units.isEmpty()) {
            throw new RuntimeException("호실 없음");
        }

        Collections.shuffle(units);
        Collections.shuffle(users);

        int assigned = 0;
        int userIndex = 0;

        for (AptDetailVO unit : units) {

            if (assigned >= count) break;

            int peopleCnt = 1 + random.nextInt(3);

            for (int i = 0; i < peopleCnt; i++) {

                if (assigned >= count || userIndex >= users.size()) break;

                MemberVO user = users.get(userIndex);

                HshldHeadEntity hshldHeadEntity = new HshldHeadEntity();
                HshldMemberEntity hshldMember = new HshldMemberEntity();

                String userNo = user.getUserNo();

                hshldHeadEntity.setUserNo(userNo);
                hshldHeadEntity.setHeadYn(i == 0 ? "Y" : "N");
                hshldHeadEntity.setHoNo(unit.getHoNo());
                hshldHeadEntity.setInoutCd("LIVE");

                hshldMember.setHoNo(unit.getHoNo());
                hshldMember.setHshldMbrNm(user.getUserNm());
                log.info("이름 : {}", user.getUserNm());

                // 세대주만 HSHLD_HEAD insert
                if (i == 0) {

                    memberMapper.insertMemberAssign(hshldHeadEntity);

                    memberMapper.updateMemberAuth(userNo);

                    aptMapper.updateEmpty(unit.getHoNo());

                    assigned++;
                }

// 세대원은 전부 insert
                memberMapper.insertHshldMember(hshldMember);

                userIndex++;
            }
        }
    }

    private static final String[] LAST_NAMES = {
            "김", "이", "박", "최", "정", "강", "조", "윤", "장", "임", "한", "오", "서", "신", "권",
            "황", "안", "송", "전", "홍", "유", "고", "문", "양", "손", "배", "백", "허", "남", "심",
            "노", "하", "곽", "성", "차", "주", "우", "구", "민", "류", "진", "엄", "채", "원", "천",
            "방", "공", "강", "현", "변", "염", "여", "추", "도", "소", "석", "선", "설", "마", "길",
            "연", "위", "표", "명", "기", "반", "왕", "금", "옥", "육", "인", "맹", "제", "모", "남궁"
    };

    private static final String[] FIRST_NAMES = {
            "민수", "서연", "지훈", "지우", "도윤", "하은", "지민", "수현", "예준", "서준",
            "하윤", "지아", "건우", "유진", "현우", "소율", "은우", "나연", "준호", "다은",

            "서진", "서현", "지호", "주원", "시우", "하린", "예원", "지안", "태현", "동현",
            "민재", "수아", "채원", "다윤", "지유", "은서", "가은", "유나", "서우", "아린",

            "승현", "재윤", "정우", "민호", "성민", "준영", "태윤", "시윤", "지후", "건호",
            "예빈", "소연", "채은", "유빈", "수빈", "예린", "하율", "연우", "나은", "다인",

            "태민", "영준", "동훈", "진우", "광수", "철수", "영희", "미영", "정희", "순자",
            "은정", "혜진", "경민", "성훈", "병철", "상현", "명수", "지숙", "선영", "지영",

            "지혁", "도현", "시현", "민성", "준서", "태경", "상민", "동욱", "정민", "진호",
            "아영", "소희", "지은", "혜원", "수진", "유리", "보람", "은지", "나영", "서영",

            "준혁", "태호", "민석", "지성", "우진", "기현", "상훈", "종현", "현준", "동건",
            "수경", "유정", "소영", "혜린", "채린", "은별", "다혜", "지혜", "유미", "보미"
    };

    private String generateRandomName() {
        Random random = new Random();

        String lastName = LAST_NAMES[random.nextInt(LAST_NAMES.length)];
        String firstName = FIRST_NAMES[random.nextInt(FIRST_NAMES.length)];

        return lastName + firstName;
    }

    private String generateRrn() {

        Random random = new Random();

        int year = 1970 + random.nextInt(40);
        int month = 1 + random.nextInt(12);
        int day = 1 + random.nextInt(28);

        String birth = String.format("%02d%02d%02d",
                year % 100, month, day);

        boolean isMale = random.nextBoolean();

        int genderCode;
        if (year < 2000) {
            genderCode = isMale ? 1 : 2;
        } else {
            genderCode = isMale ? 3 : 4;
        }

        int back = 100000 + random.nextInt(900000);

        return birth + genderCode + back;
    }

    private String generateUserId() {

        Random random = new Random();

        String prefix = PREFIX[random.nextInt(PREFIX.length)];
        String suffix = SUFFIX[random.nextInt(SUFFIX.length)];

        int pattern = random.nextInt(5);

        switch (pattern) {
            case 0:
                return prefix + suffix;
            case 1:
                return prefix + suffix + String.format("%02d", random.nextInt(100));
            case 2:
                return prefix + suffix + (100 + random.nextInt(900));
            case 3:
                return prefix + String.format("%02d", random.nextInt(100));
            default:
                return suffix + String.format("%02d", random.nextInt(100));
        }
    }

    private static final String[] PREFIX = {
            "smart", "happy", "cool", "blue", "green", "red", "yellow",
            "white", "black", "silver", "gold", "nova", "alpha", "beta",
            "gamma", "delta", "omega", "prime", "urban", "metro",
            "seoul", "busan", "daejeon", "ulsan", "jeju", "incheon",
            "river", "mountain", "forest", "ocean", "lake", "sky",
            "cloud", "rain", "snow", "wind", "storm", "sun", "moon",
            "star", "galaxy", "cosmos", "planet", "earth", "mars",
            "venus", "jupiter", "saturn", "tiger", "lion", "eagle",
            "hawk", "falcon", "wolf", "bear", "fox", "cat", "dog",
            "rabbit", "panda", "koala", "otter", "deer", "horse",
            "dragon", "phoenix", "legend", "magic", "hero", "king",
            "queen", "knight", "master", "boss", "captain", "ace",
            "rapid", "fast", "super", "ultra", "mega", "hyper",
            "power", "energy", "fresh", "young", "bright", "lucky",
            "peace", "dream", "future", "vision", "digital", "cyber"
    };

    private static final String[] SUFFIX = {
            "kim", "lee", "park", "choi", "jung", "kang", "yoon",
            "stone", "river", "tree", "wood", "leaf", "flower",
            "ocean", "wave", "wind", "storm", "cloud", "rain",
            "snow", "light", "star", "moon", "sun", "planet",
            "tiger", "lion", "fox", "wolf", "eagle", "hawk",
            "bear", "dragon", "rabbit", "cat", "dog", "horse",
            "master", "player", "gamer", "user", "member", "people",
            "family", "house", "home", "villa", "town", "city",
            "korea", "seoul", "busan", "jeju", "asia", "world",
            "tech", "soft", "code", "java", "react", "spring",
            "data", "cloud", "server", "system", "manager", "admin",
            "power", "energy", "dream", "future", "vision", "leader",
            "smart", "best", "good", "nice", "happy", "lucky",
            "hero", "legend", "champ", "winner", "ace", "king",
            "queen", "captain", "pilot", "doctor", "teacher", "artist"
    };

    private String generatePhoneNumber() {

        Random random = new Random();

        return String.format(
                "010-%04d-%04d",
                random.nextInt(10000),
                random.nextInt(10000)
        );
    }

    private String generateUniqueUserId() {

        int retry = 0;

        while (retry < 100) {

            String userId = generateUserId();

            if (memberMapper.countUserId(userId) == 0) {
                return userId;
            }

            retry++;
        }

        throw new RuntimeException("아이디 생성 실패");
    }

}
