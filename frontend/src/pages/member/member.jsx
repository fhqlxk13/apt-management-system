import { useEffect, useState } from 'react';
import { useOutletContext } from 'react-router-dom';
import { searchMemberList } from '../../util/api/member/memberApi';

const PAGE_SIZE = 10;

const MEMBER_CSS = `
.member-search-grid { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; }
`;

const MOCK_MEMBERS = [
  { id: 1, userId: 'minjun_k', name: '김민준', phone: '010-1234-5678', joinDate: '2023-05-12', role: 'MEMBER', status: 'ACTIVE', lastLogin: '2026-04-25' },
  { id: 2, userId: 'seoyeon_p', name: '박서연', phone: '010-2345-6789', joinDate: '2022-11-01', role: 'MEMBER', status: 'ACTIVE', lastLogin: '2026-04-24' },
  { id: 3, userId: 'jungho_lee', name: '이정호', phone: '010-3456-7890', joinDate: '2024-01-10', role: 'RESIDENT', status: 'ACTIVE', lastLogin: '2026-04-23' },
  { id: 4, userId: 'yujin_choi', name: '최유진', phone: '010-4567-8901', joinDate: '2021-08-20', role: 'MEMBER', status: 'DORMANT', lastLogin: '2025-12-01' },
  { id: 5, userId: 'hyunwoo_j', name: '정현우', phone: '010-5678-9012', joinDate: '2023-09-15', role: 'MEMBER', status: 'ACTIVE', lastLogin: '2026-04-22' },
  { id: 6, userId: 'sohee_han', name: '한소희', phone: '010-6789-0123', joinDate: '2020-07-15', role: 'RESIDENT', status: 'ACTIVE', lastLogin: '2026-04-21' },
  { id: 7, userId: 'jaewon_y', name: '윤재원', phone: '010-7890-1234', joinDate: '2024-02-01', role: 'MEMBER', status: 'SUSPENDED', lastLogin: '2026-01-10' },
  { id: 8, userId: 'jieun_lim', name: '임지은', phone: '010-8901-2345', joinDate: '2022-04-10', role: 'MEMBER', status: 'ACTIVE', lastLogin: '2026-04-20' },
  { id: 9, userId: 'doyun_kang', name: '강도윤', phone: '010-9012-3456', joinDate: '2023-11-12', role: 'MEMBER', status: 'ACTIVE', lastLogin: '2026-04-19' },
  { id: 10, userId: 'haneul_oh', name: '오하늘', phone: '010-0123-4567', joinDate: '2021-12-05', role: 'MEMBER', status: 'DORMANT', lastLogin: '2025-08-30' },
  { id: 11, userId: 'jiho_shin', name: '신지호', phone: '010-1122-3344', joinDate: '2024-03-20', role: 'MEMBER', status: 'ACTIVE', lastLogin: '2026-04-18' },
  { id: 12, userId: 'seoa_yoo', name: '유서아', phone: '010-2233-4455', joinDate: '2019-10-01', role: 'RESIDENT', status: 'ACTIVE', lastLogin: '2026-04-17' },
];

function getRoleName(role) {
  return role === 'RESIDENT' ? '입주민' : '일반 회원';
}

function StatusBadge({ status }) {
  if (status === 'ACTIVE') return <span className="badge-approved">정상</span>;
  if (status === 'DORMANT') return <span className="badge-pending">휴면</span>;
  if (status === 'SUSPENDED') return <span className="badge-urgent">정지</span>;
  return <span className="badge-status">{status}</span>;
}

function toMemberRow(item) {
  return {
    id: item.userNo || item.USER_NO || item.id,
    userId: item.userId || item.USER_ID || '',
    name: item.userNm || item.USER_NM || item.name || '',
    phone: item.userTelno || item.USER_TELNO || item.phone || '',
    joinDate: String(item.joinDate || item.JOIN_DT || '').slice(0, 10),
    role: item.role || item.ROLE || 'MEMBER',
    status: item.status || item.STTS || item.userStts || 'ACTIVE',
    lastLogin: String(item.lastLogin || item.LAST_LOGIN_DT || '').slice(0, 10),
  };
}

function filterMock(role, status, userId, name, sortType) {
  const idQ = userId.trim().toLowerCase();
  const nameQ = name.trim().toLowerCase();
  let result = MOCK_MEMBERS.filter((m) => {
    if (role && m.role !== role) return false;
    if (status && m.status !== status) return false;
    if (idQ && !m.userId.toLowerCase().includes(idQ)) return false;
    if (nameQ && !m.name.toLowerCase().includes(nameQ)) return false;
    return true;
  });
  if (sortType === 'joinDate-desc') result.sort((a, b) => b.joinDate.localeCompare(a.joinDate));
  else if (sortType === 'joinDate-asc') result.sort((a, b) => a.joinDate.localeCompare(b.joinDate));
  else if (sortType === 'name-asc') result.sort((a, b) => a.name.localeCompare(b.name, 'ko'));
  else result.sort((a, b) => b.lastLogin.localeCompare(a.lastLogin));
  return result;
}

export default function Member() {
  const { setPageInfo } = useOutletContext() || {};

  const [role, setRole] = useState('');
  const [status, setStatus] = useState('');
  const [userId, setUserId] = useState('');
  const [name, setName] = useState('');
  const [sort, setSort] = useState('joinDate-desc');

  const [list, setList] = useState([]);
  const [page, setPage] = useState(1);
  const [totalPage, setTotalPage] = useState(1);
  const [totalRecord, setTotalRecord] = useState(0);
  const [fromApi, setFromApi] = useState(false);

  useEffect(() => {
    if (setPageInfo) setPageInfo({ parent: '회원', current: '일반 회원 관리' });
    handleSearch(1);
  }, []);

  async function handleSearch(pageNum) {
    const cur = pageNum || 1;
    const form = { role, status, userId, name, sort };

    try {
      const data = await searchMemberList(form, cur);
      const raw = data.memberList || data.list || data;
      if (Array.isArray(raw)) {
        setList(raw.map(toMemberRow));
        setTotalRecord(data.totalRecord != null ? data.totalRecord : raw.length);
        setTotalPage(data.totalPage != null ? data.totalPage : 1);
        setPage(data.curPage != null ? data.curPage : cur);
        setFromApi(true);
        return;
      }
    } catch (err) {
      console.warn('회원 API 조회 실패 — 목업 데이터로 표시합니다.', err);
    }

    const mock = filterMock(role, status, userId, name, sort);
    setList(mock);
    setTotalRecord(mock.length);
    setTotalPage(Math.max(1, Math.ceil(mock.length / PAGE_SIZE)));
    setPage(1);
    setFromApi(false);
  }

  let rows = list;
  let curPage = page;
  let pageCount = totalPage;

  if (!fromApi) {
    pageCount = Math.max(1, Math.ceil(list.length / PAGE_SIZE));
    curPage = Math.min(Math.max(page, 1), pageCount);
    rows = list.slice((curPage - 1) * PAGE_SIZE, curPage * PAGE_SIZE);
  }

  return (
    <div className="content-wrapper">
      <style>{MEMBER_CSS}</style>

      <div className="form-card">
        <h3 className="form-card-title">검색 조건</h3>
        <div className="member-search-grid">
          <div className="form-input-group">
            <label>회원 유형</label>
            <select value={role} onChange={(e) => setRole(e.target.value)}>
              <option value="">전체</option>
              <option value="MEMBER">일반 회원</option>
              <option value="RESIDENT">입주민</option>
            </select>
          </div>
          <div className="form-input-group">
            <label>상태</label>
            <select value={status} onChange={(e) => setStatus(e.target.value)}>
              <option value="">전체</option>
              <option value="ACTIVE">정상</option>
              <option value="DORMANT">휴면</option>
              <option value="SUSPENDED">정지</option>
            </select>
          </div>
          <div className="form-input-group">
            <label>회원 ID</label>
            <input value={userId} onChange={(e) => setUserId(e.target.value)} onKeyDown={(e) => e.key === 'Enter' && handleSearch(1)} />
          </div>
          <div className="form-input-group">
            <label>이름</label>
            <input value={name} onChange={(e) => setName(e.target.value)} onKeyDown={(e) => e.key === 'Enter' && handleSearch(1)} />
          </div>
        </div>
        <div className="actions-flex" style={{ marginTop: 16 }}>
          <button type="button" className="btn-outline" onClick={() => { setRole(''); setStatus(''); setUserId(''); setName(''); setSort('joinDate-desc'); handleSearch(1); }}>
            초기화
          </button>
          <button type="button" className="btn-primary" onClick={() => handleSearch(1)}>검색</button>
        </div>
      </div>

      <div className="filter-bar">
        <p className="table-info-text">총 {totalRecord}건</p>
        <select className="rows-select-box" value={sort} onChange={(e) => { setSort(e.target.value); handleSearch(1); }}>
          <option value="joinDate-desc">가입일 최신순</option>
          <option value="joinDate-asc">가입일 오래된순</option>
          <option value="name-asc">이름순</option>
          <option value="login-desc">최근 접속순</option>
        </select>
      </div>

      <div className="table-wrapper">
        <div className="table-container">
          <table className="data-table">
            <thead>
              <tr>
                <th>회원 ID</th><th>이름</th><th>연락처</th><th>가입일</th><th>유형</th><th>상태</th><th>최근 접속</th>
              </tr>
            </thead>
            <tbody>
              {rows.length === 0 ? (
                <tr><td colSpan="7" style={{ padding: 24 }}>조회된 회원이 없습니다.</td></tr>
              ) : rows.map((m) => (
                <tr key={m.id}>
                  <td><span className="cell-mono">{m.userId}</span></td>
                  <td><p className="cell-title">{m.name}</p></td>
                  <td>{m.phone}</td>
                  <td>{m.joinDate}</td>
                  <td>{getRoleName(m.role)}</td>
                  <td><StatusBadge status={m.status} /></td>
                  <td>{m.lastLogin}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        <div className="table-pagination">
          <div className="pagination-right">
            <p className="table-info-text">{curPage} / {pageCount}</p>
            <button type="button" className="btn-page-nav" disabled={curPage <= 1} onClick={() => handleSearch(curPage - 1)}>◀</button>
            {Array.from({ length: pageCount }, (_, i) => i + 1).map((p) => (
              <button key={p} type="button" className={'btn-page-number' + (p === curPage ? ' active' : '')} onClick={() => (fromApi ? handleSearch(p) : setPage(p))}>{p}</button>
            ))}
            <button type="button" className="btn-page-nav" disabled={curPage >= pageCount} onClick={() => handleSearch(curPage + 1)}>▶</button>
          </div>
        </div>
      </div>
    </div>
  );
}
