package kr.or.ddit.domain.apt.apiApartment.vo;

import lombok.Data;

@Data
public class AptDetailResponseWrapper {
    private Header header;
    private AptDetailBody body;
}
