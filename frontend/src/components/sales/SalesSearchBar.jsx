import { useEffect, useState } from 'react';

import { getDongList, getSidoList, getSigunguList } from '../../util/api/sales/salesApi';

function SalesSearchBar({ onSearch }) {

  /**
   * 시도 리스트
   */
  const [sidoList, setSidoList] =
    useState([]);

  /**
   * 시군구 리스트
   */
  const [sigunguList, setSigunguList] =
    useState([]);

  /**
   * 읍면동 리스트
   */
  const [dongList, setDongList] =
    useState([]);

  /**
   * 검색 폼
   */
  const [searchForm, setSearchForm] =
    useState({
      sidoNm: '',
      sigunguNm: '',
      emdNm: '',
      keyword: ''
    });

  /**
   * 최초 시도 조회
   */
  useEffect(() => {

    const fetchSido = async () => {

      try {

        const data =
          await getSidoList();

        console.log(data);
        console.log(Array.isArray(data));


        setSidoList(data);

      } catch (err) {

        console.error(err);

      }
    };

    fetchSido();

  }, []);

  /**
   * 시도 변경 시
   * 시군구 조회
   */
  useEffect(() => {

    if (!searchForm.sidoNm) {

      setSigunguList([]);
      setDongList([]);

      return;
    }

    const fetchSigungu = async () => {

      try {

        const data =
          await getSigunguList(
            searchForm.sidoNm
          );

        setSigunguList(data);

      } catch (err) {

        console.error(err);

      }
    };

    fetchSigungu();

  }, [searchForm.sidoNm]);

  /**
   * 시군구 변경 시
   * 읍면동 조회
   */
  useEffect(() => {

    if (
      !searchForm.sidoNm ||
      !searchForm.sigunguNm
    ) {

      setDongList([]);

      return;
    }

    const fetchDong = async () => {

      try {

        const data =
          await getDongList(
            searchForm.sidoNm,
            searchForm.sigunguNm
          );

        setDongList(data);

      } catch (err) {

        console.error(err);

      }
    };

    fetchDong();

  }, [
    searchForm.sidoNm,
    searchForm.sigunguNm
  ]);

  /**
   * 값 변경
   */
  const handleChange = (e) => {

    const { name, value } = e.target;

    setSearchForm(prev => ({

      ...prev,

      [name]: value

    }));
  };

  /**
   * 검색
   */
  const handleSearch = () => {

    if (onSearch) {

      onSearch(searchForm);

    }
  };

  return (
    <div
      style={{
        display: 'flex',
        gap: '12px',
        alignItems: 'center'
      }}
    >

      {/* 시도 */}
      <select
        name="sidoNm"
        value={searchForm.sidoNm}
        onChange={handleChange}
        style={{
          height: '42px',
          minWidth: '160px',
          border: '1px solid var(--outline)',
          borderRadius: '8px',
          padding: '0 12px',
          background: '#fff'
        }}
      >

        <option value="">
          시 · 도 선택
        </option>

        {sidoList.map((sido) => (

          <option
            key={sido}
            value={sido}
          >
            {sido}
          </option>

        ))}

      </select>

      {/* 시군구 */}
      <select
        name="sigunguNm"
        value={searchForm.sigunguNm}
        onChange={handleChange}
        style={{
          height: '42px',
          minWidth: '160px',
          border: '1px solid var(--outline)',
          borderRadius: '8px',
          padding: '0 12px',
          background: '#fff'
        }}
      >

        <option value="">
          시 · 군 · 구 선택
        </option>

        {sigunguList.map((sigungu) => (

          <option
            key={sigungu}
            value={sigungu}
          >
            {sigungu}
          </option>

        ))}

      </select>

      {/* 읍면동 */}
      <select
        name="emdNm"
        value={searchForm.emdNm}
        onChange={handleChange}
        style={{
          height: '42px',
          minWidth: '160px',
          border: '1px solid var(--outline)',
          borderRadius: '8px',
          padding: '0 12px',
          background: '#fff'
        }}
      >

        <option value="">
          읍 · 면 · 동 선택
        </option>

        {dongList.map((dong) => (

          <option
            key={dong}
            value={dong}
          >
            {dong}
          </option>

        ))}

      </select>

      {/* 검색어 */}
      <input
        type="text"

        name="keyword"

        value={searchForm.keyword}

        onChange={handleChange}

        onKeyDown={(e) => {

          if (e.key === 'Enter') {

            handleSearch();

          }
        }}

        placeholder="아파트 이름 검색"

        style={{
          flex: 1,
          height: '42px',
          border: '1px solid var(--outline)',
          borderRadius: '8px',
          padding: '0 14px',
          background: '#fff'
        }}
      />

      {/* 검색 버튼 */}
      <button
        onClick={handleSearch}
        className="btn btn-primary"
      >
        검색
      </button>

    </div>
  );
}

export default SalesSearchBar;