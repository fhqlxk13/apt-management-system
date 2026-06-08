/**
 * 공고등록 - 공급 정보 섹션
 * - 지역(시도/시군구/읍면동) → 단지 선택 → 매물 테이블·체크박스
 * - 매물 목록은 클라이언트 페이징(10건/페이지, 번호는 최대 5개 표시)
 */
import { useEffect, useMemo, useState } from 'react';
import { LR, SUPPLY_LABELS, annStyles } from './formBits';

const L = SUPPLY_LABELS;
/** 매물 테이블: 한 페이지에 보여줄 행 수 */
const RENT_PAGE_SIZE = 10;
/** 페이징 UI: 동시에 노출할 페이지 번호 개수 (6페이지면 6~10 표시) */
const RENT_PAGE_BLOCK = 5;

/** 매물 PK (API 응답 키 대소문자 혼용 대비) */
const getRentNo = (row) => row.RENT_LSTG_NO ?? row.rent_lstg_no;

/** 보증금·월임대료 표시: 0/빈값은 '-', 그 외 원 단위 콤마 */
export const formatWon = (value, { zeroAsDash = true } = {}) => {
  if (value == null || value === '') return '-';
  const n = Number(value);
  if (!Number.isFinite(n)) return '-';
  if (zeroAsDash && n === 0) return '-';
  return `${n.toLocaleString('ko-KR')}원`;
};

/** 동/호 라벨: 이미 '동'·'호'가 붙어 있으면 중복 접미사 방지 */
export const withSuffix = (value, suffix) => {
  const s = String(value ?? '').trim();
  if (!s) return '-';
  return s.endsWith(suffix) ? s : `${s}${suffix}`;
};

export default function SupplyInfoSection({
  sido,
  setsido,
  sigungu,
  setsigungu,
  emd,
  setemd,
  aptCmplexNo,
  setAptCmplexNo,
  setAddr,
  addr,
  sidoOptions = [],
  sigunguOptions = [],
  emdOptions = [],
  aptOptions = [],
  setSubmitDocOptions,
  handleAptChange,
  resetBelow,
  rentList = [],
  selectedRentList = [],
  setSelectedRentList,
}) {
  // ── 매물 테이블 페이징 (단지·목록 바뀌면 1페이지로) ──
  const [rentPage, setRentPage] = useState(1);

  useEffect(() => {
    setRentPage(1);
  }, [aptCmplexNo, rentList.length]);

  /** 현재 페이지에 해당하는 매물 slice + 전체 건수/페이지 수 */
  const rentPagination = useMemo(() => {
    const totalRecord = rentList.length;
    const totalPage = totalRecord === 0 ? 0 : Math.ceil(totalRecord / RENT_PAGE_SIZE);
    const curPage = totalPage === 0 ? 1 : Math.min(rentPage, totalPage);
    const start = (curPage - 1) * RENT_PAGE_SIZE;
    return {
      totalRecord,
      totalPage,
      curPage,
      pagedList: rentList.slice(start, start + RENT_PAGE_SIZE),
    };
  }, [rentList, rentPage]);

  // 목록 줄어들 때 rentPage가 전체 페이지 수를 넘지 않도록 보정
  useEffect(() => {
    if (rentPagination.curPage !== rentPage) {
      setRentPage(rentPagination.curPage);
    }
  }, [rentPagination.curPage, rentPage]);

  const pagingRent = (nextPage) => {
    const { totalPage } = rentPagination;
    if (totalPage === 0 || nextPage < 1 || nextPage > totalPage) return;
    setRentPage(nextPage);
  };

  /**
   * 페이징 버튼 영역
   * - visiblePages: curPage 기준 최대 5개 번호 (1~5, 6~10 …)
   * - ◀▶: 한 페이지씩 이동 (6→5 가능, 묶음 점프 아님)
   */
  const rentPageBlock = useMemo(() => {
    const { curPage, totalPage } = rentPagination;
    if (totalPage <= 1) return null;
    const currentBlock = Math.floor((curPage - 1) / RENT_PAGE_BLOCK);
    const startPage = currentBlock * RENT_PAGE_BLOCK + 1;
    const endPage = Math.min(startPage + RENT_PAGE_BLOCK - 1, totalPage);
    return {
      visiblePages: Array.from({ length: endPage - startPage + 1 }, (_, i) => startPage + i),
      prevPage: curPage - 1,
      nextPage: curPage + 1,
      canPrev: curPage > 1,
      canNext: curPage < totalPage,
    };
  }, [rentPagination]);

  /** 시군구 변경 시 읍면동·단지·하위(주소·매물·서류) 초기화 */
  const clearFromSigungu = () => {
    setemd('');
    setAptCmplexNo('');
    resetBelow?.();
  };

  return (
    <section className="form-card">
      <h2 className="form-card-title">{L.sectionTitle}</h2>
      <div className="form-grid-stack">
        {/* 지역 cascade: 시도 → 시군구 → 읍면동 (상위 변경 시 하위 초기화) */}
        <div className="form-row-grid">
          <div className="form-input-group">
            <LR htmlFor="sido" req>{L.sido}</LR>
            <select
              id="sido"
              name="sido"
              value={sido}
              onChange={(e) => {
                setsido(e.target.value);
                setsigungu('');
                clearFromSigungu();
              }}
            >
              <option value="">{L.sidoSelect}</option>
              {sidoOptions.map((o) => (
                <option key={o.value} value={o.value}>{o.label}</option>
              ))}
            </select>
          </div>
          <div className="form-input-group">
            <LR htmlFor="sigungu" req>{L.sigungu}</LR>
            <select
              id="sigungu"
              name="sigungu"
              value={sigungu}
              disabled={!sido}
              onChange={(e) => {
                setsigungu(e.target.value);
                clearFromSigungu();
              }}
            >
              <option value="">{sido ? L.sigunguSelect : L.needSido}</option>
              {sigunguOptions.map((o) => (
                <option key={o.value} value={o.value}>{o.label}</option>
              ))}
            </select>
          </div>
        </div>
        <div className="form-row-grid">
          {/* 단지 선택 시 AnnRegister.handleAptChange → 주소·rentList API 조회 */}
          <div className="form-input-group">
            <LR htmlFor="emd" req>{L.emd}</LR>
            <select
              id="emd"
              name="emd"
              value={emd}
              disabled={!sigungu}
              onChange={(e) => {
                setemd(e.target.value);
                resetBelow?.();
              }}
            >
              <option value="">{sigungu ? L.emdSelect : L.needSigungu}</option>
              {emdOptions.map((o) => (
                <option key={o.value} value={o.value}>{o.label}</option>
              ))}
            </select>
          </div>
          <div className="form-input-group">
            <LR htmlFor="aptCmplexNo" req>{L.apt}</LR>
            <select
              id="aptCmplexNo"
              name="aptCmplexNo"
              value={aptCmplexNo}
              disabled={!sido}
              onChange={handleAptChange ?? ((e) => setAptCmplexNo(e.target.value))}
            >
              <option value="">{emd ? L.aptSelect : L.needEmd}</option>
              {aptOptions.map((o) => (
                <option key={o.value} value={o.value}>{o.label}</option>
              ))}
            </select>
          </div>
        </div>
        {/* 단지 상세 API로 채운 도로명주소 (읽기 전용) */}
        <div className="form-input-group">
          <label htmlFor="addr">{L.addr}</label>
          <input
            id="addr"
            name="addr"
            type="text"
            readOnly
            style={annStyles.readonly}
            value={addr}
            placeholder={L.addrPh}
          />
        </div>
        {/* 공고에 넣을 매물: 체크한 rentLstgNo → selectedRentList (페이지 넘겨도 선택 유지) */}
        <div className="table-wrapper">
          <div className="table-container">
            <table className="data-table ann-supply-table">
              <thead>
                <tr>
                  <th>선택</th>
                  <th>동</th>
                  <th>호</th>
                  <th>타입</th>
                  <th>전용면적(㎡)</th>
                  <th>방 수</th>
                  <th>욕실 수</th>
                  <th>보증금</th>
                  <th>월임대료</th>
                </tr>
              </thead>
              <tbody>
                {rentPagination.totalRecord > 0
                  ? rentPagination.pagedList.map((row) => {
                    const rentNo = getRentNo(row);
                    return (
                    <tr key={rentNo}>
                      <td>
                        <input
                          type="checkbox"
                          checked={selectedRentList.includes(rentNo)}
                          onChange={(e) => {
                            if (e.target.checked) {
                              setSelectedRentList([...selectedRentList, rentNo]);
                            } else {
                              setSelectedRentList(selectedRentList.filter((r) => r !== rentNo));
                            }
                          }}
                        />
                      </td>
                      <td>{row.DONG_NM ?? row.dong_nm}동</td>
                      <td>{row.HO ?? row.ho}호</td>
                      <td>{row.TY_NM ?? row.ty_nm}</td>
                      <td>{row.EXCLUSIVE_SIZE ?? row.exclusive_size}</td>
                      <td>{row.ROOM_CNT ?? row.room_cnt}</td>
                      <td>{row.BATHROOM_CNT ?? row.bathroom_cnt}</td>
                      <td>{formatWon(row.DPST_AMT ?? row.dpst_amt, { zeroAsDash: false })}</td>
                      <td>{formatWon(row.MTHLY_RENT_AMT ?? row.mthly_rent_amt)}</td>
                    </tr>
                    );
                  })
                  : (
                    <tr>
                      <td colSpan={9} style={{ textAlign: 'center', color: 'gray' }}>
                        {aptCmplexNo ? '등록 가능한 매물이 없습니다' : '단지를 선택하세요'}
                      </td>
                    </tr>
                  )
                }
              </tbody>
            </table>
          </div>
          {/* 2페이지 이상일 때만 하단 페이징 표시 */}
          {rentPageBlock && (
            <div className="table-pagination">
              <div className="pagination-right">
                <p className="table-info-text mr-4">
                  Total {rentPagination.totalRecord}건 ({rentPagination.curPage}/{rentPagination.totalPage})
                </p>
                <div className="page-numbers">
                  <button
                    type="button"
                    className="btn-page-nav"
                    disabled={!rentPageBlock.canPrev}
                    onClick={() => pagingRent(rentPageBlock.prevPage)}
                    aria-label="이전 페이지"
                  >
                    ◀
                  </button>
                  {rentPageBlock.visiblePages.map((pageNum) => (
                    <button
                      key={pageNum}
                      type="button"
                      className={`btn-page-number ${rentPagination.curPage === pageNum ? 'active' : ''}`}
                      onClick={() => pagingRent(pageNum)}
                    >
                      {pageNum}
                    </button>
                  ))}
                  <button
                    type="button"
                    className="btn-page-nav"
                    disabled={!rentPageBlock.canNext}
                    onClick={() => pagingRent(rentPageBlock.nextPage)}
                    aria-label="다음 페이지"
                  >
                    ▶
                  </button>
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </section>
  );
}