package kr.or.ddit.domain.apt.apiApartment.vo;

import lombok.Data;

@Data
public class AptListResponseWrapper {
    private Header header;
    private AptListBody body;
}