import { Download, FilePlusCorner } from 'lucide-react';
import { useEffect, useState } from 'react';
import { useNavigate, useOutletContext } from 'react-router-dom';
import '../../styles/common.css';
import requestApi from '../../util/api/requestApi';
import { getNameByStatus, getNameOfJm } from '../../util/ctrt/ctrt';
import CtrtBoard from './CtrtBoard';
import Swal from 'sweetalert2';
import * as XLSX from 'xlsx';

const Ctrt = () => {
  const navigate = useNavigate();

  const { admInfo } = useOutletContext() || {};
  const [list, setList] = useState([]);

  const [pagination, setPagination] = useState({
    curPage: 1,
    totalPage: 1,
    totalRecord: 0
  });

  const [searchParams, setSearchParams] = useState({
    ctrtNo: '',
    aptNm: '',
    aprvStartDt: '',
    aprvEndDt: '',
    startDt: '',
    endDt: '',
    minRent: '',
    maxRent: '',
    manager: '',
    status: 'ALL'
  });

  const [apiParams, setApiParams] = useState(searchParams);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setSearchParams(prev => ({ ...prev, [name]: value }));
  };

  const handleSearch = () => {
    setApiParams(searchParams); // 검색 시에만 API용 상태 업데이트
    setPagination(prev => ({ ...prev, curPage: 1 }));
  };

  const handleReset = () => {
    const resetParams = {
      ctrtNo: '', aptNm: '', aprvDt: '', startDt: '', endDt: '',
      minRent: '', maxRent: '', manager: '', status: 'ALL'
    };
    setSearchParams(resetParams);
    setApiParams(resetParams); // 초기화 시 API 호출용도 초기화
    setPagination(prev => ({ ...prev, curPage: 1 }));
  };

  // 리스트 조회 API 호출
  useEffect(() => {
    const fetchContracts = async () => {
      try {
        // 1. URL에서 쿼리스트링 제거 (params 객체로 전달해야 함)
        const response = await requestApi.get(`/api/react/adm/ctrt`, {
          params: {
            page: pagination.curPage,
            ...apiParams // 여기에 검색어들이 포함됨
          }
        });

        if (response.data && Array.isArray(response.data.ctrtList)) {
          setList(response.data.ctrtList);
          setPagination(prev => ({
            ...prev,
            totalPage: response.data.totalPage,
            totalRecord: response.data.totalRecord
          }));
        } else {
          setList([]);
        }
      } catch (error) {
        console.error("데이터 로드 실패 : ", error);
        setList([]);
      }
    };
    fetchContracts();
  }, [pagination.curPage, apiParams]);

  const paging = (newPage) => {
    if (newPage >= 1 && newPage <= pagination.totalPage) {
      setPagination(prev => ({ ...prev, curPage: newPage }));
    }
  };

  const openDetail = (RENT_CTRT_NO) => {
    if (!RENT_CTRT_NO) {
      Swal.fire({
        icon: 'info'
        , title: '검색 결과'
        , text: "계약 정보가 없습니다."
        , confirmButtonText: '확인'
      })
      return;
    }
    navigate(`/adm/ctrt/detail/${RENT_CTRT_NO}`);
  };

  // 엑셀 다운로드 기능
  const handleExcelDownload = () => {
    const fetchXls = async () => {
      try {
        const response = await requestApi.get(`api/react/adm/ctrtXls`, {
          params: {
            ...apiParams
          }
        });
        if (response.data && Array.isArray(response.data.ctrtList)) {
          // 1. 엑셀에 들어갈 데이터 가공
          const xlsData = response.data.ctrtList;
          const excelData = xlsData.map(item => ({
            '계약번호': item.RENT_CTRT_NO,
            'ID': item.USER_ID,
            '이름': item.USER_NM,
            '아파트': item.APT_CMPLEX_NM,
            '승인일': item.CTRT_APRV_DT,
            '임대타입': getNameOfJm(item.RENT_TYPE_CD).text,
            '임대료': item.RENT_TYPE_CD === 'JS' ? item.DPST_AMT : item.MTHLY_RENT_AMT,
            '상태': getNameByStatus(item.CTRT_STTS_CD, item.MVIN_DT, item.MVOUT_DT).text,
            '담당자': item.CTRT_MGR_USER_NM
          }));

          // 2. 워크북 및 워크시트 생성
          const worksheet = XLSX.utils.json_to_sheet(excelData);
          const workbook = XLSX.utils.book_new();
          XLSX.utils.book_append_sheet(workbook, worksheet, "계약관리목록");

          // 3. 파일 다운로드 실행
          XLSX.writeFile(workbook, "계약관리목록.xlsx");
        }
      } catch (error) {
        console.error("엑셀 다운로드 중 오류 발생:", error);
        Swal.fire({
          title: '엑셀 다운로드 에러',
          icon: 'error',
          cancelButtonText: '닫기'
        })
      }
    };
    fetchXls();
  };


  return (
    <div className="content-wrapper" style={{ paddingTop: '0px' }}>
      {/* 타이틀 세션 */}
      <div className="page-header">
        <div>
          <h2 className="page-title">계약 관리</h2>
          <p className="page-subtitle">Contract management</p>
        </div>
        <div className="header-actions">
          <button className="btn-outline"
            onClick={() => handleExcelDownload()}
          >
            <span className="material-symbols-outlined">.xls 다운로드</span><Download size={17} />
          </button>
          <button
            className="btn-primary"
            onClick={() => navigate('/apt/residentAssign')}
          >
            <span className="material-symbols-outlined">
              오프라인 계약 등록
            </span><FilePlusCorner size={17} />
          </button>
        </div>
      </div>

      {/* 대시보드 통계 그리드 컴포넌트 */}
      <CtrtBoard />

      <div className="filter-panel">
        <div className="filter-grid">
          <div className="filter-column">
            <div className="filter-group">
              <label className="filter-label">상태</label>
              <select name="status" value={searchParams.status} onChange={handleInputChange} className="filter-input">
                <option value="ALL">전체</option>
                <option value="PENDING">승인대기</option>
                <option value="APPROVED">승인</option>
                <option value="CANCEL">취소</option>
                <option value="REJECT">반려</option>
                <option value="TERMINATED">중도해지</option>
                <option value="EXPIRED">계약만료</option>
              </select>
            </div>

            <div className="filter-group">
              <label className="filter-label">계약자 (이름/ID)</label>
              <input name="userSearch" value={searchParams.userSearch} onChange={handleInputChange} className="filter-input" placeholder="이름 또는 ID 입력" onKeyDown={(e) => e.key === 'Enter' && handleSearch()} />
            </div>
          </div>

          {/* 2열 */}
          <div className="filter-column">
            <div className="filter-group">
              <label className="filter-label">계약 번호</label>
              <input name="ctrtNo" value={searchParams.ctrtNo} onChange={handleInputChange} className="filter-input" placeholder="검색" onKeyDown={(e) => e.key === 'Enter' && handleSearch()} />
            </div>

            <div className="filter-group">
              <label className="filter-label">아파트</label>
              <input name="aptNm" value={searchParams.aptNm} onChange={handleInputChange} className="filter-input" placeholder="아파트 명 검색" onKeyDown={(e) => e.key === 'Enter' && handleSearch()} />
            </div>
          </div>

          {/* 3열 */}
          <div className="filter-column">
            <div className="filter-group">
              <label className="filter-label">승인일</label>
              <div style={{ display: 'flex', gap: '5px' }}>
                <input name="aprvStartDt" type="date" value={searchParams.aprvStartDt} onChange={handleInputChange} className="filter-input" onKeyDown={(e) => e.key === 'Enter' && handleSearch()} />
                <input name="aprvEndDt" type="date" value={searchParams.aprvEndDt} onChange={handleInputChange} className="filter-input" onKeyDown={(e) => e.key === 'Enter' && handleSearch()} />
              </div>
            </div>
            <div className="filter-group">
              <label className="filter-label">계약 기간</label>
              <div style={{ display: 'flex', gap: '5px' }}>
                <input name="startDt" type="date" value={searchParams.startDt} onChange={handleInputChange} className="filter-input" onKeyDown={(e) => e.key === 'Enter' && handleSearch()} />
                <input name="endDt" type="date" value={searchParams.endDt} onChange={handleInputChange} className="filter-input" onKeyDown={(e) => e.key === 'Enter' && handleSearch()} />
              </div>
            </div>

          </div>

          {/* 4열 */}
          <div className="filter-column">
            <div className="filter-group">
              <label className="filter-label">담당자</label>
              <input name="manager" value={searchParams.manager} onChange={handleInputChange} className="filter-input" placeholder="담당자 이름/번호" onKeyDown={(e) => e.key === 'Enter' && handleSearch()} />
            </div>
            <div className="filter-group">
              <label className="filter-label">임대료 범위</label>
              <div style={{ display: 'flex', gap: '5px' }}>
                <input name="minRent" type="number" value={searchParams.minRent} onChange={handleInputChange} className="filter-input" placeholder="최소" onKeyDown={(e) => e.key === 'Enter' && handleSearch()} />
                <input name="maxRent" type="number" value={searchParams.maxRent} onChange={handleInputChange} className="filter-input" placeholder="최대" />
              </div>
            </div>
            <div style={{ marginTop: 'auto', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '8px' }}>
              <button onClick={handleReset} className="btn-outline" style={{ height: '38px', cursor: 'pointer', margin: 0 }}>초기화</button>
              <button onClick={handleSearch} className="btn-primary" style={{ height: '38px', cursor: 'pointer', margin: 0 }}>검색</button>
            </div>
          </div>
        </div>
      </div>

      {/* 데이터 테이블 컨테이너 */}
      <div className="table-wrapper shadow-sm">
        <div className="table-container">
          <table className="data-table">
            <thead>
              <tr>
                <th style={{ textAlign: 'left', marginRight: '0px', paddingRight: '0px' }}>계약 번호</th>
                <th>ID</th>
                <th>이름</th>
                <th>아파트</th>
                <th>승인일</th>
                <th>계약 기간</th>
                <th>전·월세</th>
                <th>임대료</th>{/* 전세면 보증금, 월세면 월 임대 금액 */}
                <th>상태</th>
                <th>담당자</th>
                <th>상세</th>
              </tr>
            </thead>
            <tbody>
              {list.length === 0 ? (
                <tr>
                  <td colSpan="9" className="text-center py-4" style={{ color: '#888' }}>배정된 계약 건이 없습니다.</td>
                </tr>
              ) : (
                list.map((item, i) => {
                  const statusBadge = getNameByStatus(item.CTRT_STTS_CD, item.MVIN_DT, item.MVOUT_DT);
                  const jm = getNameOfJm(item.RENT_TYPE_CD)
                  return (
                    <tr key={i}>
                      <td style={{ textAlign: 'left', marginRight: '0px', paddingRight: '0px' }}>  {/* 계약 번호 */}
                        <div>
                          <p className="cell-title" style={{ marginRight: '0px' }}>{item.RENT_CTRT_NO}</p>
                        </div>
                      </td>
                      <td> {/* ID */}
                        <div>
                          <p className="cell-title">{item.USER_ID}</p>
                        </div>
                      </td>
                      <td> {/* 이름 */}
                        <div>
                          <p className="cell-title">{item.USER_NM}</p>
                        </div>
                      </td>
                      <td> {/* 아파트 */}
                        <p className="cell-title">{item.APT_CMPLEX_NO}</p>
                        <p className="cell-sub">{item.APT_CMPLEX_NM}</p>
                      </td>
                      <td> {/* 계약 승인일 */}
                        <span className="cell-title">{item.CTRT_APRV_DT
                          ? new Date(item.CTRT_APRV_DT).toLocaleDateString().replace(/\.$/, '')
                          : '-'}</span>
                      </td>
                      <td> {/* 기간 */}
                        {item.MVIN_DT && item.MVOUT_DT ?
                          <span className="cell-title">
                            {new Date(item.MVIN_DT).toLocaleDateString().replace(/\.$/, '')} ~ {new Date(item.MVOUT_DT).toLocaleDateString().replace(/\.$/, '')}
                          </span>
                          : <span className='cell-title'>미정</span>}
                      </td>
                      <td> {/* 임대 타입 */}
                        <span className="cell-title">
                          {jm.text}
                        </span>
                      </td>
                      <td className='price'> {/* 임대료 */}
                        <span className='cell-title'>
                          {item.RENT_TYPE_CD === 'JS' ? `${Number(item.DPST_AMT || 0).toLocaleString()}원`
                            : `${(Number(item.MTHLY_RENT_AMT) || 0).toLocaleString()}원`}
                        </span>
                      </td>
                      <td> {/* 상태 */}
                        <span className={`cell-title ${statusBadge.className}`}>
                          {statusBadge.text}
                        </span>
                      </td>
                      <td> {/* 담당자 */}
                        <div>
                          <p className="cell-title">{item.CTRT_MGR_USER_NM}</p>
                          <p className="cell-sub">관리자 번호 : {item.CTRT_MGR_USER_NO}</p>
                        </div>
                      </td>
                      <td> {/* 상세 버튼 */}
                        <button className='btn-cell' onClick={() => openDetail(item.RENT_CTRT_NO)}>상세보기</button>
                      </td>
                    </tr>
                  )
                })
              )}
            </tbody>
          </table>
        </div>

        {/* 하단 페이징 영역 */}
        <div className="table-pagination">
          <div className="pagination-right">
            <p className="table-info-text mr-4">Total {pagination.totalRecord}건</p>

            <div className="page-numbers">
              {/* 이전 버튼 */}
              <button className="btn-page-nav"
                disabled={pagination.curPage === 1}
                onClick={() => paging(pagination.curPage - 1)}
              >
                <span className="material-symbols-outlined">&lt;</span>
              </button>

              {/* 페이지 번호 동적 생성 */}
              {Array.from({ length: pagination.totalPage || 1 }, (_, i) => i + 1).map((pageNum) => (
                <button key={pageNum}
                  className={`btn-page-number ${pagination.curPage === pageNum ? 'active' : ''}`}
                  onClick={() => paging(pageNum)}>
                  {pageNum}
                </button>
              ))}

              {/* 다음 버튼 */}
              <button
                className='btn-page-nav'
                disabled={pagination.curPage === pagination.totalPage || pagination.totalPage === 0}
                onClick={() => paging(pagination.curPage + 1)}
              >
                <span className='material-symbols-outlined'>&gt;</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Ctrt;