import { formatDateDot, RoleBadge } from './shared';

function InfoBlock({ label, value, children }) {
  return (
    <div className="mngr-detail-block">
      <span className="mngr-detail-label">{label}</span>
      <div className="mngr-detail-value">{children || value || '-'}</div>
    </div>
  );
}

export default function AccountDetailModal({ open, account, onClose, onToggleUse }) {
  if (!open || !account) return null;

  const active = account.userYn !== 'N';
  const recentLogin = `${formatDateDot(account.lastLoginDt || account.regDt)}${account.lastLoginTm ? ` ${account.lastLoginTm}` : ''}`;

  return (
    <div className="mngr-modal-overlay" role="presentation">
      <div className="mngr-modal mngr-detail-modal" role="dialog" aria-modal="true" aria-labelledby="accountDetailTitle">
        <div className="mngr-modal-header">
          <div>
            <h3 id="accountDetailTitle">{account.userNm || '-'} — 계정 상세</h3>
          </div>
          <button type="button" className="mngr-modal-close" onClick={onClose} aria-label="닫기">×</button>
        </div>

        <div className="mngr-detail-grid">
          <InfoBlock label="관리자 이름" value={account.userNm} />
          <InfoBlock label="아이디" value={account.userId} />
          <InfoBlock label="전화번호" value={account.userTelno} />
          <InfoBlock label="이메일" value={account.userEml} />
          <InfoBlock label="소속 단지" value={account.aptCmplexNm} />
          <InfoBlock label="상세주소" value={account.detailAddr} />
          <InfoBlock label="관리사무소 번호" value={account.mgmtOfcNo} />
          <InfoBlock label="권한">
            <RoleBadge code={account.mngrDutyCd} name={account.dutyNm} />
          </InfoBlock>
          <InfoBlock label="최근 접속" value={recentLogin} />
          <InfoBlock label="상태" value={active ? '사용' : '미사용'} />
        </div>

        <div className="mngr-modal-footer">
          <button
            type="button"
            className={active ? 'btn-danger-outline' : 'btn-outline'}
            onClick={() => onToggleUse(account, !active)}
          >
            {active ? '계정 미사용' : '계정 사용'}
          </button>
          <button type="button" className="btn-outline" onClick={onClose}>닫기</button>
        </div>
      </div>
    </div>
  );
}
