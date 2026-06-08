export default function RejectModal({
  open,
  rqstNos,
  reason,
  onChangeReason,
  onClose,
  onSubmit,
}) {
  if (!open) return null;

  return (
    <div className="mngr-modal-overlay" role="presentation">
      <div className="mngr-modal" role="dialog" aria-modal="true" aria-labelledby="rejectModalTitle">
        <div className="mngr-modal-header">
          <div>
            <h3 id="rejectModalTitle">신청 반려</h3>
            <p>{rqstNos.length}건의 신청을 반려합니다. 사유는 신청 이력에 남습니다.</p>
          </div>
          <button type="button" className="mngr-modal-close" onClick={onClose} aria-label="닫기">×</button>
        </div>
        <textarea
          className="mngr-reject-textarea"
          value={reason}
          maxLength={300}
          placeholder="반려 사유를 입력해주세요. 예: 소속 단지 정보가 확인되지 않습니다."
          onChange={(e) => onChangeReason(e.target.value)}
          autoFocus
        />
        <div className="mngr-modal-footer">
          <span className="mngr-text-count">{reason.length}/300</span>
          <button type="button" className="btn-outline" onClick={onClose}>취소</button>
          <button type="button" className="btn-danger-outline" disabled={!reason.trim()} onClick={onSubmit}>반려 처리</button>
        </div>
      </div>
    </div>
  );
}
