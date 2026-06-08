import { useEffect, useMemo, useRef, useState } from 'react';
import { formatRange, getStatusName, StatusBadge } from './annBits';

function Info({ label, value, full }) {
  return (
    <div className="mngr-detail-block" style={full ? { gridColumn: '1 / -1' } : undefined}>
      <span className="mngr-detail-label">{label}</span>
      <div className="mngr-detail-value">{value ?? '-'}</div>
    </div>
  );
}

function Field({ label, children, full }) {
  return (
    <div className="mngr-detail-block" style={full ? { gridColumn: '1 / -1' } : undefined}>
      <span className="mngr-detail-label">{label}</span>
      <div className="mngr-detail-value">{children}</div>
    </div>
  );
}

export default function DetailModal({ open, data, onClose, onDelete, deleting, onSave, saving }) {
  if (!open || !data) return null;

  const status = getStatusName(data);
  const initialForm = useMemo(
    () => ({
      ttl: data?.ttl ?? '',
      cn: data?.cn ?? '',
      pblancBgngDt: data?.pblancBgngDt ?? '',
      pblancEndDt: data?.pblancEndDt ?? '',
      rcrtBgngDt: data?.rcrtBgngDt ?? '',
      rcrtEndDt: data?.rcrtEndDt ?? '',
    }),
    [data]
  );

  const [editing, setEditing] = useState(false);
  const [form, setForm] = useState(initialForm);
  const ttlRef = useRef(null);

  useEffect(() => {
    setEditing(false);
    setForm(initialForm);
  }, [initialForm]);

  useEffect(() => {
    if (!editing) return;
    const t = setTimeout(() => ttlRef.current?.focus?.(), 0);
    return () => clearTimeout(t);
  }, [editing]);

  const setField = (name, value) => setForm((prev) => ({ ...prev, [name]: value }));

  const inputClassName = 'filter-input';
  const textareaStyle = {
    width: '100%',
    minHeight: 110,
    maxHeight: 180,
    padding: '10px 12px',
    border: '1px solid var(--outline-variant)',
    borderRadius: 8,
    fontSize: 13,
    fontWeight: 500,
    lineHeight: 1.7,
    fontFamily: 'inherit',
    backgroundColor: '#fff',
    boxSizing: 'border-box',
    resize: 'vertical',
    outline: 'none',
  };

  const handleClickSave = () => {
    if (!form.ttl.trim()) return alert('공고 제목을 입력하세요');
    if (!form.cn.trim()) return alert('공고 내용을 입력하세요');
    const { pblancBgngDt, pblancEndDt, rcrtBgngDt, rcrtEndDt } = form;
    if (!pblancBgngDt || !pblancEndDt || !rcrtBgngDt || !rcrtEndDt) {
      return alert('게시·모집 기간을 모두 입력하세요');
    }
    if (pblancBgngDt > pblancEndDt) return alert('게시 시작일은 게시 종료일보다 앞서야 합니다.');
    if (rcrtBgngDt > rcrtEndDt) return alert('모집 시작일은 모집 종료일보다 앞서야 합니다.');

    onSave?.({
      ttl: form.ttl.trim(),
      cn: form.cn.trim(),
      pblancBgngDt,
      pblancEndDt,
      rcrtBgngDt,
      rcrtEndDt,
      // 제출서류는 수정 불가: 기존 값 유지
      sbmsnDoc: String(data?.sbmsnDoc ?? '').trim(),
    });
  };

  return (
    <div className="mngr-modal-overlay" role="presentation" onClick={onClose}>
      <div
        className="mngr-modal mngr-detail-modal"
        role="dialog"
        aria-modal="true"
        onClick={(e) => e.stopPropagation()}
        style={{ maxWidth: 720, maxHeight: '86vh', display: 'flex', flexDirection: 'column' }}
      >
        <div className="mngr-modal-header">
          <div style={{ display: 'flex', alignItems: 'center', gap: 10, flexWrap: 'wrap' }}>
            <h3 style={{ margin: 0 }}>공고 상세 정보</h3>
            <StatusBadge status={status} />
          </div>
          <button type="button" className="mngr-modal-close" onClick={onClose} aria-label="닫기">
            ×
          </button>
        </div>

        <div style={{ overflowY: 'auto' }}>
        <div className="mngr-detail-grid">
          {editing ? (
            <>
              <Field label="공고 제목" full>
                <input
                  ref={ttlRef}
                  className={inputClassName}
                  value={form.ttl}
                  onChange={(e) => setField('ttl', e.target.value)}
                  placeholder="공고 제목을 입력하세요"
                />
              </Field>
              <Info label="공급 세대수" value={data.supplyDisplay} />
              <Info label="아파트 단지" value={data.aptCmplexNm} />
              <Info label="주소" value={data.dorojuso} />
              <Field label="게시 시작일">
                <input
                  type="date"
                  className={inputClassName}
                  value={form.pblancBgngDt}
                  onChange={(e) => setField('pblancBgngDt', e.target.value)}
                />
              </Field>
              <Field label="게시 종료일">
                <input
                  type="date"
                  className={inputClassName}
                  value={form.pblancEndDt}
                  onChange={(e) => setField('pblancEndDt', e.target.value)}
                />
              </Field>
              <Field label="모집 시작일">
                <input
                  type="date"
                  className={inputClassName}
                  value={form.rcrtBgngDt}
                  onChange={(e) => setField('rcrtBgngDt', e.target.value)}
                />
              </Field>
              <Field label="모집 종료일">
                <input
                  type="date"
                  className={inputClassName}
                  value={form.rcrtEndDt}
                  onChange={(e) => setField('rcrtEndDt', e.target.value)}
                />
              </Field>
              <Info label="제출 서류(수정 불가)" value={data.sbmsnDocNm || data.sbmsnDoc} full />
              <Field label="공고 내용" full>
                <textarea
                  value={form.cn}
                  onChange={(e) => setField('cn', e.target.value)}
                  placeholder="공고 내용을 입력하세요"
                  style={textareaStyle}
                />
              </Field>
            </>
          ) : (
            <>
              <Info label="공고 제목" value={data.ttl} full />
              <Info label="공급 세대수" value={data.supplyDisplay} />
              <Info label="아파트 단지" value={data.aptCmplexNm} />
              <Info label="주소" value={data.dorojuso} />
              <Info label="게시 기간" value={formatRange(data.pblancBgngDt, data.pblancEndDt)} />
              <Info label="모집 기간" value={formatRange(data.rcrtBgngDt, data.rcrtEndDt)} />
              <Info label="제출 서류" value={data.sbmsnDocNm || data.sbmsnDoc} full />
              <Info
                label="공고 내용"
                value={
                  <div style={{ whiteSpace: 'pre-wrap', lineHeight: 1.7, textAlign: 'left' }}>
                    {data.cn || '-'}
                  </div>
                }
                full
              />
            </>
          )}
        </div>
        </div>

        <div className="mngr-modal-footer">
          {editing ? (
            <>
              <button type="button" className="btn-primary" disabled={saving} onClick={handleClickSave}>
                {saving ? '저장 중…' : '저장'}
              </button>
            </>
          ) : (
            <button type="button" className="btn-primary" onClick={() => setEditing(true)}>
              수정
            </button>
          )}
          {!editing && (
            <button
              type="button"
              className="btn-danger-outline"
              disabled={deleting || saving}
              onClick={onDelete}
            >
              {deleting ? '삭제 중…' : '삭제'}
            </button>
          )}
          <button type="button" className="btn-outline" onClick={onClose}>
            닫기
          </button>
        </div>
      </div>
    </div>
  );
}
