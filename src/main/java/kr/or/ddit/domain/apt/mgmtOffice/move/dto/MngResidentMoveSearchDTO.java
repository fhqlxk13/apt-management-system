package kr.or.ddit.domain.apt.mgmtOffice.move.dto;

import lombok.Data;

@Data
public class MngResidentMoveSearchDTO {

    private String mgmtOfcNo;
    private String dong;
    private String ho;
    private String moveStatus;
    private String headYn;
    private String keyword;
    private String moveInStart;
    private String moveInEnd;
    private String moveOutStart;
    private String moveOutEnd;

    private int currentPage;
    private int startRow;
    private int endRow;

}
