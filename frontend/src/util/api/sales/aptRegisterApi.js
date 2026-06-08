import requestApi from "../requestApi";

const API_URL = '/api/react/adm/aptCmplex';

// =========================
// 시도 조회
// =========================
export const getSidoList = async () => {

    return requestApi.get(
        `${API_URL}/sido`
    );
};

// =========================
// 시군구 조회
// =========================
export const getSigunguList = async (
    sido
) => {

    return requestApi.get(
        `${API_URL}/sigungu`,
        {
            params: { sido }
        }
    );
};

// =========================
// 법정동 조회
// =========================
export const getDongList = async ({
    sido,
    sigungu
}) => {

    return requestApi.get(
        `${API_URL}/emd`,
        {
            params: {
                sido,
                sigungu
            }
        }
    );
};

// =========================
// 공공 API 아파트 조회
// =========================
export const getApartmentList = async ({
    sido,
    sigungu,
    emd
}) => {

    return requestApi.post(
        `${API_URL}/apt/checkBaseInfo`,
        {
            sido,
            sigungu,
            emd
        }
    );
};

// =========================
// 선택 아파트 등록
// =========================
export const registerApartment = async (
    kaptCodeList
) => {

    return requestApi.post(
        `${API_URL}/apt/register`,
        {
            kaptCodeList
        }
    );
};

// =========================
// 좌표 업데이트
// =========================
export const updateLatLng = async () => {

    return requestApi.post(
        `${API_URL}/updateLatLng.do`
    );
};

export const getApartmentDetail = async (
    kaptCode
) => {

    return requestApi.get(
        `${API_URL}/apt/detail/${kaptCode}`
    );
};

export const saveApartment = async (
    data
) => {

    return requestApi.post(
        `${API_URL}/apt/save`,
        data
    );
};