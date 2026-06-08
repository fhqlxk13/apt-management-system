import requestApi from '../requestApi';

/**
 * 일반 회원 목록 조회 (서버 페이징)
 * @param {Object} searchForm - role, status, userId, name, sort
 * @param {number} currentPage
 */
export const searchMemberList = async (searchForm, currentPage = 1) => {
  const res = await requestApi.get('/api/react/adm/member', {
    params: {
      ...searchForm,
      currentPage,
    },
  });
  return res.data;
};

/**
 * 회원 상세 조회
 */
export const getMemberDetail = async (userNo) => {
  const res = await requestApi.get(`/api/react/adm/member/${userNo}`);
  return res.data;
};
