package kr.or.ddit.domain.apt.mgmtOffice.main.vo;

import lombok.Data;

import java.util.List;

@Data
public class UpdateBuildingStructureDTO {

    private String mgmtOfcNo;

    private String aptCmplexNo;

    private String dongNm;

    private String dongNo;

    private int totalFloor;

    private int hoPerFloor;


}