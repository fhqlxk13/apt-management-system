import requestApi from '../requestApi';

const API_URL = '/api/react/adm/mngrRqstAprv';

/** 신청 계정 목록 (keyword, status) */
export const getRequestList = async (searchForm = {}) => {
  const res = await requestApi.get(`${API_URL}/requestList`, {
    params: searchForm,
  });
  return res.data;
};

/** 관리자 계정 목록 (keyword, status, role) */
export const getAccountList = async (searchForm = {}) => {
  const res = await requestApi.get(`${API_URL}/accountList`, {
    params: searchForm,
  });
  return res.data;
};

/** 신청 승인 */
export const approveRequest = async (rqstNo) => {
  const res = await requestApi.post(`${API_URL}/approve/${rqstNo}`);
  return res.data;
};

/** 신청 반려 */
export const rejectRequest = async (rqstNo, rjctRsnCn) => {
  const res = await requestApi.post(`${API_URL}/reject/${rqstNo}`, {
    rjctRsnCn,
  });
  return res.data;
};

/** 계정 사용/미사용 (userYn: Y | N) */
export const updateAccountUse = async (userNo, userYn) => {
  const res = await requestApi.put(`${API_URL}/accountUse/${userNo}`, {
    userYn,
  });
  return res.data;
};
