import requestApi from '../requestApi';

const API_URL = '/api/react/adm/annList';

/** 공고 목록 (검색: searchTtl, searchAptCmplexNo, searchFrom, searchTo, searchStatus) */
export const getAnnList = async (params = {}) => {
  const res = await requestApi.get(`${API_URL}/annList`, { params });
  return res.data;
};

/** 검색 필터용 단지 목록 */
export const getAptOptions = async () => {
  const res = await requestApi.get(`${API_URL}/aptComplexList`);
  return res.data;
};

/** 공고 상세 */
export const getAnnDetail = async (annNo) => {
  const res = await requestApi.get(`${API_URL}/${annNo}`);
  return res.data;
};

/** 공고 삭제 (del_yn = Y) */
export const deleteAnn = async (annNo) => {
  const res = await requestApi.delete(`${API_URL}/${annNo}`);
  return res.data;
};

/** 공고 수정 (React용 JSON API) */
export const updateAnn = async (annNo, payload) => {
  const res = await requestApi.put(`${API_URL}/${annNo}`, payload);
  return res.data;
};
