import { useState } from 'react';

import { getBuildingList } from '../../util/api/sales/salesApi';


function SalesExplorer({
  pagingVO,
  selectedAptNm,
  setSelectedAptNm,
  selectedDongNm,
  onSelectDong,
  onPageChange
}) {


  const [mode, setMode] = useState('APT');

  const [selectedAptNo, setSelectedAptNo] = useState(null);

  const [currentApt, setCurrentApt] = useState(null);

  const [buildingList, setBuildingList] = useState([]);


  const handleAptEnter = async (apt) => {

    try {

      const data =
        await getBuildingList(
          apt.aptCmplexNo
        );

      setCurrentApt(apt);

      setSelectedAptNm(
        apt.aptCmplexNm
      );

      setSelectedAptNo(
        apt.aptCmplexNo
      );

      setBuildingList(data);

      setMode('DONG');

    } catch (err) {

      console.error(err);

    }
  };

  const handleDongEnter = (dongNm) => {

    onSelectDong({
      dongNm,
      aptCmplexNo: selectedAptNo
    });

  };

  const handleBack = () => {

    if (mode === 'DONG') {

      setMode('APT');

      return;
    }
  };

  return (
    <div
      style={{
        flex: 1,

        background: '#fff',

        border:
          '1px solid var(--outline-variant)',

        borderRadius: '16px',

        overflow: 'hidden',

        display: 'flex',
        flexDirection: 'column'
      }}
    >

      {/* 헤더 */}
      <div
        style={{
          height: '56px',

          borderBottom: '1px solid #eee',

          display: 'flex',
          alignItems: 'center',

          padding: '0 20px',

          fontWeight: '700',
          fontSize: '15px'
        }}
      >
        매물 탐색기
      </div>

      {/* 리스트 */}
      <div
        style={{
          flex: 1,
          overflowY: 'auto'
        }}
      >

        {/* 아파트 목록 */}
        {mode === 'APT' && (

          pagingVO?.dataList
            .map((apt) => (

              <div
                key={apt.aptCmplexNo}

                onClick={() =>
                  handleAptEnter(apt)
                }

                style={{
                  height: '42px',

                  background:
                    selectedAptNo === apt.aptCmplexNo
                      ? '#eff6ff'
                      : '#fff',

                  color:
                    selectedAptNo === apt.aptCmplexNo
                      ? '#2563eb'
                      : '#374151',

                  fontWeight:
                    selectedAptNo === apt.aptCmplexNo
                      ? '600'
                      : '400',

                  transition: '0.15s',

                  display: 'flex',
                  alignItems: 'center',

                  padding: '0 14px',

                  borderBottom:
                    '1px solid #f3f4f6',

                  cursor: 'pointer',

                  fontSize: '13px'
                }}
              >

                📁 {apt.aptCmplexNm}

              </div>

            ))

        )}

        {/* 동 목록 */}
        {mode === 'DONG' && (

          <>
            <div
              onClick={handleBack}

              style={{
                height: '42px',

                display: 'flex',
                alignItems: 'center',

                padding: '0 14px',

                borderBottom:
                  '1px solid #f3f4f6',

                cursor: 'pointer',

                fontSize: '13px',

                fontWeight: '600',

                background: '#f8fafc',

                color: '#374151'
              }}
            >
              ← 상위 목록
            </div>

            {buildingList
              .map((dongNm) => (

                <div
                  key={dongNm}

                  onClick={() =>
                    handleDongEnter(dongNm)
                  }

                  style={{
                    height: '42px',

                    background:
                      selectedDongNm === dongNm
                        ? '#eff6ff'
                        : '#fff',

                    color:
                      selectedDongNm === dongNm
                        ? '#2563eb'
                        : '#374151',

                    fontWeight:
                      selectedDongNm === dongNm
                        ? '600'
                        : '400',

                    transition: '0.15s',

                    display: 'flex',
                    alignItems: 'center',

                    padding: '0 14px',

                    borderBottom:
                      '1px solid #f3f4f6',

                    cursor: 'pointer',

                    fontSize: '13px'
                  }}
                >

                  📁 {dongNm} 동

                </div>

              ))}

          </>

        )}

      </div>
      {/* 페이지네이션 */}
      {mode === 'APT' &&
        pagingVO?.totalPage > 1 && (
          <div
            style={{
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
              gap: '6px',
              padding: '12px',
              borderTop: '1px solid #eee',
              background: '#fafafa'
            }}
          >

            {pagingVO.startPage > 1 && (

              <button
                onClick={() =>
                  onPageChange(
                    pagingVO.startPage -
                    pagingVO.blockSize
                  )
                }

                style={{
                  height: '30px',
                  padding: '0 10px',

                  borderRadius: '8px',

                  border: '1px solid #d1d5db',

                  background: '#fff',

                  cursor: 'pointer'
                }}
              >
                Prev
              </button>

            )}

            {Array.from(
              {
                length:
                  pagingVO.endPage -
                  pagingVO.startPage + 1
              },

              (_, i) =>
                pagingVO.startPage + i

            ).map((page) => (

              <button
                key={page}

                onClick={() =>
                  onPageChange(page)
                }

                style={{
                  width: '30px',
                  height: '30px',

                  borderRadius: '8px',

                  border:
                    page === pagingVO.currentPage
                      ? '1px solid #2563eb'
                      : '1px solid #d1d5db',

                  background:
                    page === pagingVO.currentPage
                      ? '#2563eb'
                      : '#fff',

                  color:
                    page === pagingVO.currentPage
                      ? '#fff'
                      : '#374151',

                  fontWeight: '600',

                  cursor: 'pointer'
                }}
              >
                {page}
              </button>

            ))}

            {pagingVO.endPage <
              pagingVO.totalPage && (

                <button
                  onClick={() =>
                    onPageChange(
                      pagingVO.endPage + 1
                    )
                  }

                  style={{
                    height: '30px',
                    padding: '0 10px',

                    borderRadius: '8px',

                    border: '1px solid #d1d5db',

                    background: '#fff',

                    cursor: 'pointer'
                  }}
                >
                  Next
                </button>

              )}

          </div>
        )}
    </div>
  );
}

export default SalesExplorer;