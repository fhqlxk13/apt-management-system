import requestApi from '../requestApi';

/**
 * 시도 조회
 */
export const getSidoList = async () => {

  const res = await requestApi.get(
    '/api/react/adm/sales/sido.do'
  );

  return res.data;
};

/**
 * 시군구 조회
 */
export const getSigunguList = async (sidoNm) => {

  const res = await requestApi.get(
    '/api/react/adm/sales/sigungu.do',
    {
      params: {
        sidoNm
      }
    }
  );

  return res.data;
};

/**
 * 읍면동 조회
 */
export const getDongList = async (
  sidoNm,
  sigunguNm
) => {

  const res = await requestApi.get(
    '/api/react/adm/sales/dong.do',
    {
      params: {
        sidoNm,
        sigunguNm
      }
    }
  );

  return res.data;
};

/**
 * 아파트 검색
 */
export const searchApartmentList = async (
  searchForm,
  currentPage = 1
) => {

  const res = await requestApi.get(
    '/api/react/adm/sales/apt/list',
    {
      params: {
        ...searchForm,
        currentPage
      }
    }
  );

  return res.data;
};

/**
 * 동 리스트 조회
 */
export const getBuildingList = async (
  aptCmplexNo
) => {

  const res = await requestApi.get(
    '/api/react/adm/sales/building/list',
    {
      params: {
        aptCmplexNo
      }
    }
  );

  return res.data;
};

export const getHoList = async (
  aptCmplexNo,
  dongNm
) => {

  const res = await requestApi.get(
    '/api/react/adm/sales/ho.do',
    {
      params: {
        aptCmplexNo,
        dongNm
      }
    }
  );

  return res.data;
};

/**
 * 매물 등록
 */
export const registerRentListing =
  async (payload) => {

    const res =
      await requestApi.post(
        '/api/react/adm/sales/rent/register',
        payload
      );

    return res.data;
};

export const deleteRentListing = async (
    hoNos
) => {

    const res = await requestApi.post(
        '/api/react/adm/sales/rent/delete',
        hoNos
    );

    return res.data;
};