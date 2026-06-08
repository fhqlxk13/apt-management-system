package kr.or.ddit.domain.apt.mgmtOffice.resident.dto;

import lombok.Data;

@Data
public class MngResidentListSearchDTO {

    private String mgmtOfcNo;
    private String complexName;
    private String dong;
    private String ho;
    private String householdType;
    private String moveStatus;
    private String keyword;
    private String moveInStart;
    private String moveInEnd;
}
