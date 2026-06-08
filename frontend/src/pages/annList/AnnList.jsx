import { useCallback, useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { deleteAnn, getAnnDetail, getAnnList, getAptOptions, updateAnn } from '../../util/api/announcement/annList';
import { EMPTY_FILTER } from './components/annBits';
import AnnTable from './components/AnnTable';
import DetailModal from './components/DetailModal';
import SearchBar from './components/SearchBar';

/**
 * 공고 관리 — 목록·검색·상세·삭제 (등록은 /adm/ann/register)
 */
export default function AnnList() {
  const navigate = useNavigate();

  const [aptOptions, setAptOptions] = useState([]);
  const [draftFilter, setDraftFilter] = useState({ ...EMPTY_FILTER });
  const [apiFilter, setApiFilter] = useState({ ...EMPTY_FILTER });

  const [list, setList] = useState([]);
  const [page, setPage] = useState(1);
  const [loading, setLoading] = useState(false);

  const [detailOpen, setDetailOpen] = useState(false);
  const [detail, setDetail] = useState(null);
  const [deleting, setDeleting] = useState(false);
  const [saving, setSaving] = useState(false);

  // 공고 전체조회
  const loadList = useCallback(async (filter) => {
    setLoading(true);
    try {
      const data = await getAnnList(filter);
      setList(Array.isArray(data) ? data : []);
      setPage(1);
    } catch (e) {
      console.error('공고 목록 조회 실패', e);
      setList([]);
      alert('공고 목록을 불러오지 못했습니다.');
    } finally {
      setLoading(false);
    }
  }, []);

  // 필터링 및 검색
  useEffect(() => {
    getAptOptions()
      .then((data) => setAptOptions(Array.isArray(data) ? data : []))
      .catch((e) => console.error('단지 목록 조회 실패', e));
    loadList(EMPTY_FILTER);
  }, [loadList]);

  const handleSearch = () => {
    setApiFilter({ ...draftFilter });
    loadList(draftFilter);
  };

  const handleReset = (empty) => {
    setDraftFilter(empty);
    setApiFilter(empty);
    loadList(empty);
  };

  const openDetail = async (annNo) => {
    try {
      const data = await getAnnDetail(annNo);
      setDetail(data);
      setDetailOpen(true);
    } catch (e) {
      console.error(e);
      alert('공고 상세를 불러오지 못했습니다.');
    }
  };

  const handleSave = async (payload) => {
    if (!detail?.annNo) return;
    setSaving(true);
    try {
      const res = await updateAnn(detail.annNo, payload);
      if (res?.success) {
        alert('수정 완료');
        // 상세 재조회 + 목록 갱신
        const next = await getAnnDetail(detail.annNo);
        setDetail(next);
        loadList(apiFilter);
      } else {
        alert(res?.message ?? '수정 실패');
      }
    } catch (e) {
      console.error(e);
      alert('수정 중 오류가 발생했습니다.');
    } finally {
      setSaving(false);
    }
  };

  // 공고 삭제
  const handleDelete = async () => {
    if (!detail?.annNo) return;
    if (!window.confirm('공고를 삭제하시겠습니까?')) return;

    setDeleting(true);
    try {
      const res = await deleteAnn(detail.annNo);
      if (res?.success) {
        alert('공고가 삭제되었습니다.');
        setDetailOpen(false);
        setDetail(null);
        loadList(apiFilter);
      } else {
        alert('공고 삭제에 실패했습니다.');
      }
    } catch (e) {
      console.error(e);
      alert('공고 삭제 중 오류가 발생했습니다.');
    } finally {
      setDeleting(false);
    }
  };

  return (
    <div className="content-wrapper">
      <header className="page-header">
        <div>
          <h1 className="page-title">공고 관리</h1>
          <p className="page-subtitle">
            입주자 모집·공고를 등록·조회하고 진행 상태를 한눈에 관리합니다.
          </p>
        </div>
        <div className="header-actions">
          <button
            type="button"
            className="btn-primary"
            onClick={() => navigate('/adm/ann/register')}
          >
            공고 등록
          </button>
        </div>
      </header>

      <SearchBar
        draft={draftFilter}
        onChange={setDraftFilter}
        aptOptions={aptOptions}
        onSearch={handleSearch}
        onReset={handleReset}
      />

      <AnnTable
        rows={list}
        total={list.length}
        page={page}
        onPageChange={setPage}
        onRowClick={openDetail}
        loading={loading}
      />

      <DetailModal
        open={detailOpen}
        data={detail}
        onClose={() => {
          setDetailOpen(false);
          setDetail(null);
        }}
        onSave={handleSave}
        onDelete={handleDelete}
        deleting={deleting}
        saving={saving}
      />
    </div>
  );
}
