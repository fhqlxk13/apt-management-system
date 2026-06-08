package kr.or.ddit.domain.member.vo;

import lombok.Getter;
import lombok.Setter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.Collection;
import java.util.stream.Collectors;

@Getter
@Setter
public class CustomUser extends User {
    private static final long serialVersionUID = 1L;
    private MemberVO member;

    // User 객체인 부모에게 전달
    public CustomUser(String username, String password, Collection<? extends GrantedAuthority> auth){
        super(username, password, auth);
    }

    public CustomUser(MemberVO member) {
        // Java 스트림을 사용한 경우(람다 표현식)
        //	- 자바 버전 9부터 추가된 기능
        //  - map : 컬렉션(List, Map, Set 등), 배열 등의 설정되어 있는 각 타입의 값들을 하나씩 참조하여 람다식으로 반복 처리할 수 있게 해준다.
        //  - collect : Stream()을 돌려 발생되는 데이터를 가공 처리하고 원하는 형태의 자료형으로 변환을 돕는다.
        super(member.getUserId(), member.getUserPw(),
                member.getAuthList().stream().map(auth -> new SimpleGrantedAuthority(auth.getAuth())).collect(Collectors.toList()));

        this.member = member;
    }
}
