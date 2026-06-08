package kr.or.ddit.domain.apt.apiApartment.vo;

import lombok.Data;

@Data
public class AptBassResponseWrapper {
    private Header header;
    private AptBassBody body;
}
