package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface IResidentVhclService {
    List<RsidVhclVO> selectMyVhclList(String userNo, String aptCmplexNo);

    void registerVhcl(String userNo, String aptCmplexNo, String vhclNm, String vhclNo, String hoNo, MultipartFile file) throws IOException;

    boolean isExtraRequired(String userNo, String aptCmplexNo, String hoNo);

    void deleteVhcl(String rsidVhclNo, String userNo);
}
