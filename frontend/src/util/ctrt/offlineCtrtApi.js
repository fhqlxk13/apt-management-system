import requestApi
    from '../api/requestApi';

/* 아파트 검색 */
export const searchApartment =
    async (keyword, page = 1, size = 10) => {
        const response = await requestApi.get(
            '/api/react/adm/offlineCtrt/apt/search',
            {
                params: {
                    keyword,
                    page,
                    size
                }
            }
        );

        return response.data;
    };

/* 동 목록 조회 */
export const getDongList =
    async (aptCmplexNo) => {
        const response = await requestApi.get(
            '/api/react/adm/offlineCtrt/apt/dong-list',
            {
                params: {
                    aptCmplexNo
                }
            }
        );

        return response.data;
    };

/* 호 목록 조회 */
export const getHoList =
    async (aptCmplexNo, dongNo) => {

        const response =
            await requestApi.get(
                '/api/react/adm/offlineCtrt/apt/ho-list',
                {
                    params: {
                        aptCmplexNo,
                        dongNo
                    }
                }
            );

        return response.data;
    };

/* 활성 임대매물 상세 조회 */
export const getRentListingDetail =
    async (hoNo) => {

        const response =
            await requestApi.get(
                '/api/react/adm/offlineCtrt/apt/rent-detail',
                {
                    params: {
                        hoNo
                    }
                }
            );

        return response.data;
    };

/* 제출서류 목록 조회 */
export const getRequiredDocs =
    async (rentLstgNo) => {

        const response =
            await requestApi.get(
                '/api/react/adm/offlineCtrt/apt/required-docs',
                {
                    params: {
                        rentLstgNo
                    }
                }
            );

        return response.data;
    };



export const assignResident = async (formData) => {

    const response = await requestApi.post(
        '/api/react/adm/offlineCtrt/apt/assign',
        formData,
        {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        }
    );

    return response.data;
};