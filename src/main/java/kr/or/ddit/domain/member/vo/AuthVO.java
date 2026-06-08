package kr.or.ddit.domain.member.vo;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@Data
public class AuthVO {
    private String userNo;
    private String auth;
}
