import { formatDateDot, RoleBadge, StatusBadge } from './shared';

function InfoBlock({ label, value, children }) {
  return (
    <div className="mngr-detail-block">
      <span className="mngr-detail-label">{label}</span>
      <div className="mngr-detail-value">{children || value || '-'}</div>
    </div>
  );
}

export default function RequestDetailModal({ open, request, onClose, onApprove, onReject }) {
  if (!open || !request) return null;

  const status = String(request.rqstSttsCd || '').toUpperCase();
  const isWait = status === 'WAIT';

  return (
    <div className="mngr-modal-overlay" role="presentation">
      <div className="mngr-modal mngr-detail-modal" role="dialog" aria-modal="true" aria-labelledby="requestDetailTitle">
        <div className="mngr-modal-header">
          <div>
            <h3 id="requestDetailTitle">{request.rqstMngrNm || '-'} — 신청 상세</h3>
          </div>
          <button type="button" className="mngr-modal-close" onClick={onClose} aria-label="닫기">×</button>
        </div>

        <div className="mngr-detail-grid">
          <InfoBlock label="신청자 이름" value={request.rqstMngrNm} />
          <InfoBlock label="신청 아이디" value={request.rqstLoginId} />
          <InfoBlock label="소속 단지" value={request.aptCmplexNm || request.aptCmplexNo} />
          <InfoBlock label="상세주소" value={request.detailAddr} />
          <InfoBlock label="관리사무소 번호" value={request.mgmtOfcNo} />
          <InfoBlock label="신청 직무">
            <RoleBadge code={request.rqstDutyCd} name={request.dutyNm} />
          </InfoBlock>
          <InfoBlock label="신청일자" value={formatDateDot(request.rqstDt)} />
          <InfoBlock label="처리상태">
            <StatusBadge status={status} />
          </InfoBlock>
          <InfoBlock label="승인일자" value={formatDateDot(request.aprvDt)} />
          <InfoBlock label="승인자" value={request.aprvId} />
          <InfoBlock label="반려사유" value={request.rjctRsnCn} />
          <InfoBlock label="비고" value={request.rmrkCn} />
        </div>

        <div className="mngr-modal-footer">
          {isWait && (
            <>
              <button type="button" className="btn-outline" onClick={() => onApprove(request.rqstNo)}>승인</button>
              <button type="button" className="btn-danger-outline" onClick={() => onReject(request.rqstNo)}>반려</button>
            </>
          )}
          <button type="button" className="btn-outline" onClick={onClose}>닫기</button>
        </div>
      </div>
    </div>
  );
}
