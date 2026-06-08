
import { useEffect, useState } from 'react';
import { useOutletContext } from 'react-router-dom';
import SalesBuildingMap from '../../components/sales/SalesBuildingMap';
import SalesExplorer from '../../components/sales/SalesExplorer';
import SalesSearchBar from '../../components/sales/SalesSearchBar';
import { searchApartmentList } from '../../util/api/sales/salesApi';
import SalesGrid from '../../components/sales/SalesGrid';

function SalesList() {

  const [selectedRooms, setSelectedRooms] = useState([]);

  const { setPageInfo } = useOutletContext();

  const [selectedBuilding, setSelectedBuilding] = useState(null);

  const [pagingVO, setPagingVO] = useState(null);

  const [searchForm, setSearchForm] = useState(null);

  const [selectedDong, setSelectedDong] = useState(null);

  const [selectedAptNm, setSelectedAptNm] = useState(null);

  const [hoList, setHoList] = useState([]);

  useEffect(() => {
    setPageInfo({
      parent: '건물 · 매물',
      current: '임대 매물 관리'
    });
  }, []);

  /**
   * 검색
   */
  const handleSearch = async (
    form,
    currentPage = 1
  ) => {

    try {

      setSearchForm(form);

      const data =
        await searchApartmentList(
          form,
          currentPage
        );

      setPagingVO(data);

    } catch (err) {

      console.error(err);

    }
  };

  const groupedMap = {};

  hoList.forEach((item) => {

    const floorKey =
      `${item.floor}F`;

    if (!groupedMap[floorKey]) {

      groupedMap[floorKey] = [];

    }

    groupedMap[floorKey].push({
      ho: item.ho,
      status: item.hoSttsCd
    });

  });

  const floorData = Object.entries(
    groupedMap
  )
    .map(([floor, rooms]) => ({

      floor,

      rooms: rooms.sort(
        (a, b) => Number(a.ho) - Number(b.ho)
      )

    }))
    .sort(
      (a, b) =>
        Number(b.floor.replace('F', '')) -
        Number(a.floor.replace('F', ''))
    );

  return (
    <div className="content-wrapper">
      <SalesSearchBar
        onSearch={handleSearch}
      />
      {/* 메인 레이아웃 */}
      <div
        style={{
          display: 'flex',
          gap: '20px',
          height: 'calc(100vh - 220px)',
          marginTop: '20px'
        }}
      >
        {/* 좌측 */}
        <div
          style={{
            width: '280px',
            display: 'flex',
            flexDirection: 'column',
            gap: '20px'
          }}
        >
          <SalesExplorer
            selectedAptNm={selectedAptNm}
            setSelectedAptNm={setSelectedAptNm}

            selectedDongNm={selectedDong?.dongNm}

            onSelectDong={setSelectedDong}

            pagingVO={pagingVO}

            onPageChange={(page) =>
              handleSearch(searchForm, page)
            }
          />
        </div>
        <div
          style={{
            flex: 1,
            display: 'grid',
            gridTemplateColumns: '1fr 420px',
            gap: '20px'
          }}
        >

          {/* 가운데 */}
          <SalesGrid
            aptCmplexNo={selectedDong?.aptCmplexNo}

            selectedAptNm={selectedAptNm}

            selectedDongNm={selectedDong?.dongNm}

            selectedRooms={selectedRooms}
            setSelectedRooms={setSelectedRooms}

            setHoList={setHoList}
          />

          {/* 우측 배치도 */}
          <SalesBuildingMap
            floorData={floorData}
            selectedRooms={selectedRooms}
            setSelectedRooms={setSelectedRooms}
          />

        </div>
      </div>
    </div>
  );
}

export default SalesList;