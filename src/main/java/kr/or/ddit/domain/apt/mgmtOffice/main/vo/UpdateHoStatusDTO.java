package kr.or.ddit.domain.apt.mgmtOffice.main.vo;

import lombok.Data;

import java.util.List;

@Data
public class UpdateHoStatusDTO {
    private List<String> hoNoList;
    private String hoSttsCd;
    private String mgmtOfcNo;

    private String aptCmplexNo;
}