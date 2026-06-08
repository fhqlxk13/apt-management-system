import { useEffect, useState } from 'react';
import { useOutletContext } from 'react-router-dom';
import Swal from 'sweetalert2';
import AccountDetailModal from '../../components/mngrRqstAprv/AccountDetailModal';
import AccountList from '../../components/mngrRqstAprv/AccountList';
import RejectModal from '../../components/mngrRqstAprv/RejectModal';
import RequestDetailModal from '../../components/mngrRqstAprv/RequestDetailModal';
import RequestList from '../../components/mngrRqstAprv/RequestList';
import { PAGE_SIZE } from '../../components/mngrRqstAprv/shared';
import {
  approveRequest,
  getAccountList,
  getRequestList,
  rejectRequest,
  updateAccountUse,
} from '../../util/api/mngrRqstAprv/mngrRqstAprvApi';

function getErrorMessage(error) {
  return error.response?.data?.message || error.message || '요청 처리 중 오류가 발생했습니다.';
}

function normalizeList(data) {
  if (Array.isArray(data)) return data;
  if (Array.isArray(data?.list)) return data.list;
  if (Array.isArray(data?.data)) return data.data;
  return [];
}

export default function MngrRqstAprv() {
  const { setPageInfo } = useOutletContext() || {};

  const [activeTab, setActiveTab] = useState('requests');
  const [requestSearch, setRequestSearch] = useState({ keyword: '', status: '' });
  const [accountSearch, setAccountSearch] = useState({ keyword: '', status: '', role: '' });
  const [requestList, setRequestList] = useState([]);
  const [accountList, setAccountList] = useState([]);
  const [selectedRqstNos, setSelectedRqstNos] = useState([]);
  const [requestPage, setRequestPage] = useState(1);
  const [accountPage, setAccountPage] = useState(1);
  const [loading, setLoading] = useState(false);
  const [feedback, setFeedback] = useState(null);
  const [rejectModal, setRejectModal] = useState({ open: false, rqstNos: [] });
  const [rejectReason, setRejectReason] = useState('');
  const [selectedRequest, setSelectedRequest] = useState(null);
  const [selectedAccount, setSelectedAccount] = useState(null);

  useEffect(() => {
    if (setPageInfo) setPageInfo({ parent: '직원', current: '하위 관리자 계정 관리' });
    loadAll();
  }, []);

  function showFeedback(type, message) {
    setFeedback({ type, message });
  }

  async function loadAll() {
    setLoading(true);
    try {
      await loadRequests();
      await loadAccounts();
    } finally {
      setLoading(false);
    }
  }

  async function loadRequests(search = requestSearch) {
    try {
      const data = await getRequestList(search);
      setRequestList(normalizeList(data));
      setRequestPage(1);
      setSelectedRqstNos([]);
    } catch (error) {
      setRequestList([]);
      showFeedback('error', getErrorMessage(error));
    }
  }

  async function loadAccounts(search = accountSearch) {
    try {
      const data = await getAccountList(search);
      setAccountList(normalizeList(data));
      setAccountPage(1);
    } catch (error) {
      setAccountList([]);
      if (error.response?.status !== 404) {
        showFeedback('error', getErrorMessage(error));
      }
    }
  }

  function changeRequestSearch(name, value) {
    setRequestSearch((prev) => ({ ...prev, [name]: value }));
  }

  function changeAccountSearch(name, value) {
    setAccountSearch((prev) => ({ ...prev, [name]: value }));
  }

  function resetRequestSearch() {
    const next = { keyword: '', status: '' };
    setRequestSearch(next);
    loadRequests(next);
  }

  function resetAccountSearch() {
    const next = { keyword: '', status: '', role: '' };
    setAccountSearch(next);
    loadAccounts(next);
  }

  function selectAllRequests(checked, pageWaitNos) {
    setSelectedRqstNos((prev) => {
      if (!checked) return prev.filter((no) => !pageWaitNos.includes(no));
      return [...new Set([...prev, ...pageWaitNos])];
    });
  }

  function selectRequest(rqstNo, checked) {
    setSelectedRqstNos((prev) => (
      checked ? [...prev, rqstNo] : prev.filter((no) => no !== rqstNo)
    ));
  }

  async function approveRequests(rqstNos = selectedRqstNos) {
    if (rqstNos.length === 0) {
      showFeedback('error', '승인할 계정을 선택해주세요.');
      return;
    }
    if (!window.confirm(`${rqstNos.length}건을 승인 처리하시겠습니까?`)) return;

    try {
      await Promise.all(rqstNos.map((rqstNo) => approveRequest(rqstNo)));
      await loadAll();
      showFeedback('success', `${rqstNos.length}건의 신청을 승인했습니다.`);
    } catch (error) {
      showFeedback('error', getErrorMessage(error));
    }
  }

  async function approveRequestFromDetail(rqstNo) {
    await approveRequests([rqstNo]);
    setSelectedRequest(null);
  }

  function openRejectModal(rqstNos) {
    if (!rqstNos || rqstNos.length === 0) {
      showFeedback('error', '반려할 신청을 선택해주세요.');
      return;
    }

    setRejectReason('');
    setRejectModal({ open: true, rqstNos });
  }

  function rejectRequestFromDetail(rqstNo) {
    setSelectedRequest(null);
    openRejectModal([rqstNo]);
  }

  function closeRejectModal() {
    setRejectModal({ open: false, rqstNos: [] });
    setRejectReason('');
  }

  async function submitReject() {
    const reason = rejectReason.trim();
    if (!reason) {
      showFeedback('error', '반려 사유를 입력해야 합니다.');
      return;
    }

    try {
      await Promise.all(rejectModal.rqstNos.map((rqstNo) => rejectRequest(rqstNo, reason)));
      await loadRequests();
      showFeedback('success', `${rejectModal.rqstNos.length}건의 신청을 반려했습니다.`);
      closeRejectModal();
    } catch (error) {
      showFeedback('error', getErrorMessage(error));
    }
  }

  async function changeAccountUse(row, checked) {
    const nextLabel = checked ? '사용' : '미사용';
    const targetName = row.userNm || row.userId || '선택한 계정';

    const result = await Swal.fire({
      title: `계정 ${nextLabel} 처리`,
      text: `${targetName} 계정을 ${nextLabel} 상태로 변경하시겠습니까?`,
      icon: checked ? 'question' : 'warning',
      showCancelButton: true,
      confirmButtonColor: '#226046',
      cancelButtonColor: '#d33',
      confirmButtonText: '변경',
      cancelButtonText: '취소',
    });

    if (!result.isConfirmed) return;

    try {
      await updateAccountUse(row.userNo, checked ? 'Y' : 'N');
      await loadAccounts();
      setSelectedAccount((prev) => (
        prev?.userNo === row.userNo ? { ...prev, userYn: checked ? 'Y' : 'N' } : prev
      ));
      await Swal.fire({
        icon: 'success',
        title: '변경 완료',
        text: `${targetName} 계정을 ${nextLabel} 상태로 변경했습니다.`,
        confirmButtonText: '확인',
      });
    } catch (error) {
      Swal.fire({
        icon: 'error',
        title: '변경 실패',
        text: getErrorMessage(error),
        confirmButtonColor: '#d33',
        confirmButtonText: '확인',
      });
    }
  }

  const requestLastPage = Math.max(1, Math.ceil(requestList.length / PAGE_SIZE));
  const accountLastPage = Math.max(1, Math.ceil(accountList.length / PAGE_SIZE));
  const requestRows = requestList.slice((requestPage - 1) * PAGE_SIZE, requestPage * PAGE_SIZE);
  const accountRows = accountList.slice((accountPage - 1) * PAGE_SIZE, accountPage * PAGE_SIZE);
  const pageWaitRqstNos = requestRows
    .filter((row) => String(row.rqstSttsCd).toUpperCase() === 'WAIT')
    .map((row) => row.rqstNo);
  const allPageWaitSelected = pageWaitRqstNos.length > 0
    && pageWaitRqstNos.every((no) => selectedRqstNos.includes(no));
  const isRequestsTab = activeTab === 'requests';

  return (
    <div className="content-wrapper" style={{ paddingBottom: 24 }}>

      <div className="compact-card">
        <div className="mngr-tabs" role="tablist" aria-label="단지 관리자 계정 관리">
          <button
            type="button"
            role="tab"
            aria-selected={isRequestsTab}
            className={`mngr-tab${isRequestsTab ? ' active' : ''}`}
            onClick={() => setActiveTab('requests')}
          >
            신청·승인
          </button>
          <button
            type="button"
            role="tab"
            aria-selected={!isRequestsTab}
            className={`mngr-tab${!isRequestsTab ? ' active' : ''}`}
            onClick={() => setActiveTab('accounts')}
          >
            운영 계정
          </button>
        </div>

        {feedback && (
          <div className={`mngr-feedback ${feedback.type}`} role="status">
            <span>{feedback.message}</span>
            <button type="button" onClick={() => setFeedback(null)} aria-label="알림 닫기">×</button>
          </div>
        )}

        {loading && <div className="mngr-loading">데이터를 불러오는 중입니다.</div>}

        {isRequestsTab ? (
          <RequestList
            loading={loading}
            requestSearch={requestSearch}
            requestRows={requestRows}
            requestListLength={requestList.length}
            requestPage={requestPage}
            requestLastPage={requestLastPage}
            selectedRqstNos={selectedRqstNos}
            pageWaitRqstNos={pageWaitRqstNos}
            allPageWaitSelected={allPageWaitSelected}
            onChangeSearch={changeRequestSearch}
            onSearch={() => loadRequests()}
            onReset={resetRequestSearch}
            onSelectAll={selectAllRequests}
            onSelect={selectRequest}
            onApprove={approveRequests}
            onReject={openRejectModal}
            onPageChange={setRequestPage}
            onOpenDetail={setSelectedRequest}
          />
        ) : (
          <AccountList
            loading={loading}
            accountSearch={accountSearch}
            accountRows={accountRows}
            accountListLength={accountList.length}
            accountPage={accountPage}
            accountLastPage={accountLastPage}
            onChangeSearch={changeAccountSearch}
            onSearch={() => loadAccounts()}
            onReset={resetAccountSearch}
            onPageChange={setAccountPage}
            onOpenDetail={setSelectedAccount}
            onToggleUse={changeAccountUse}
          />
        )}
      </div>

      <AccountDetailModal
        open={!!selectedAccount}
        account={selectedAccount}
        onClose={() => setSelectedAccount(null)}
        onToggleUse={changeAccountUse}
      />

      <RequestDetailModal
        open={!!selectedRequest}
        request={selectedRequest}
        onClose={() => setSelectedRequest(null)}
        onApprove={approveRequestFromDetail}
        onReject={rejectRequestFromDetail}
      />

      <RejectModal
        open={rejectModal.open}
        rqstNos={rejectModal.rqstNos}
        reason={rejectReason}
        onChangeReason={setRejectReason}
        onClose={closeRejectModal}
        onSubmit={submitReject}
      />
    </div>
  );
}
