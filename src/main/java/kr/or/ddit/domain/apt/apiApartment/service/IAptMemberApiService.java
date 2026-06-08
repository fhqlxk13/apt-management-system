package kr.or.ddit.domain.apt.apiApartment.service;

import kr.or.ddit.domain.apt.apiApartment.vo.AptComplexEntity;

import java.util.List;

public interface IAptMemberApiService {
    List<String> getSidoList();

    List<String> getSigunguList(String sido);

    List<String> getEmdList(String sido, String sigungu);

    List<AptComplexEntity> getAptList(String sido, String sigungu, String emd);

    void createDummyUsers(int count);

    int getNotAssignedUserCount();

    void assignResidents(List<String> aptList, int count);
}
