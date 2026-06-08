import { useState, useEffect } from 'react';
import { Button } from '../components/common/Button';
import requestApi from '../util/api/requestApi';

/** 페이지 전용 레이아웃·표(common 미수정). 별도 .css 없음 */
const ANN_PAGE_CSS = `
.content-wrapper.ann-register-full {
  max-width: none;
  width: 100%;
  min-height: calc(100vh - 120px);
}
.content-wrapper.ann-register-full .form-sections-stack {
  flex: 1 1 auto;
}
.ann-supply-table tbody tr {
  transition: none;
}
.ann-supply-table tbody tr:hover {
  background-color: transparent;
}
`;

/** 시·도 선택값 = sigungu API의 sidoNm(행정구역명) */
const SIDO_OPTIONS = [
  { value: '서울특별시', label: '서울특별시' },
  { value: '부산광역시', label: '부산광역시' },
  { value: '대구광역시', label: '대구광역시' },
  { value: '인천광역시', label: '인천광역시' },
  { value: '광주광역시', label: '광주광역시' },
  { value: '대전광역시', label: '대전광역시' },
  { value: '울산광역시', label: '울산광역시' },
  { value: '세종특별자치시', label: '세종특별자치시' },
  { value: '경기도', label: '경기도' },
  { value: '강원특별자치도', label: '강원특별자치도' },
  { value: '충청북도', label: '충청북도' },
  { value: '충청남도', label: '충청남도' },
  { value: '전북특별자치도', label: '전북특별자치도' },
  { value: '전라남도', label: '전라남도' },
  { value: '경상북도', label: '경상북도' },
  { value: '경상남도', label: '경상남도' },
  { value: '제주특별자치도', label: '제주특별자치도' },
];

function unwrapList(data) {
  if (data == null) return [];
  if (Array.isArray(data)) return data;
  if (Array.isArray(data.list)) return data.list;
  if (Array.isArray(data.data)) return data.data;
  if (Array.isArray(data.result)) return data.result;
  return [];
}

/** 백엔드 응답 → { value, label }[] (필드명이 다르면 여기서 맞춤) */
function toSigunguOptions(payload) {
  return unwrapList(payload)
    .map((item, idx) => {
      if (item == null) return null;
      if (typeof item === 'string') return { value: item, label: item };
      const value =
        item.sigunguCd ??
        item.sigunguCode ??
        item.code ??
        item.cd ??
        item.value ??
        `sigungu-${idx}`;
      const label =
        item.sigunguNm ??
        item.sigunguName ??
        item.name ??
        item.nm ??
        item.label ??
        String(value);
      return { value: String(value), label: String(label) };
    })
    .filter(Boolean);
}

const DATE_FIELDS = [
  ['pubStartDt', '게시 시작일'],
  ['pubEndDt', '게시 종료일'],
  ['rcritStartDt', '모집 시작일'],
  ['rcritEndDt', '모집 종료일'],
];

/** 공급 유형 표 헤더 — 컬럼 정의만 유지 (행 데이터는 연동 후) */
const SUPPLY_COLS = [
  { key: 'type', label: '타입', input: 'text', ph: '예: A타입' },
  { key: 'exclArea', label: '전용면적(㎡)', input: 'number', min: 0, step: '0.01', ph: '예: 65' },
  { key: 'roomCnt', label: '방 수', input: 'number', min: 0, ph: '예: 3' },
  { key: 'bathCnt', label: '욕실 수', input: 'number', min: 0, ph: '예: 2' },
  { key: 'supplyCnt', label: '공급 세대수', input: 'number', min: 0, ph: '예: 2' },
];

/** common.css에 없는 필드만 — 페이지 안에서만 사용 */
const ann = {
  reqStar: { color: 'var(--error)', marginLeft: 4, fontWeight: 700 },
  textarea: {
    width: '100%',
    minHeight: 120,
    border: '1px solid var(--outline-variant)',
    borderRadius: 8,
    padding: 12,
    fontSize: 14,
    background: 'var(--surface-container-low)',
    boxSizing: 'border-box',
    outline: 'none',
    fontFamily: 'inherit',
    resize: 'vertical',
  },
  readonly: {
    background: 'var(--surface-container-high)',
    color: 'var(--on-surface-variant)',
  },
  tableInput: {
    width: '100%',
    padding: '10px 12px',
    borderRadius: 8,
    border: '1px solid var(--outline-variant)',
    boxSizing: 'border-box',
    fontSize: 14,
    background: 'var(--surface-container-low)',
    textAlign: 'left',
  },
  footer: {
    display: 'flex',
    justifyContent: 'flex-end',
    gap: 12,
    paddingTop: 20,
    marginTop: 'auto',
    borderTop: '1px solid var(--outline-variant)',
  },
  docList: { margin: 0, paddingLeft: 24, lineHeight: 1.75, fontSize: 14 },
};

function ReqStar() {
  return <span style={ann.reqStar} aria-hidden>*</span>;
}

function LR({ htmlFor, children, req }) {
  return (
    <label htmlFor={htmlFor}>
      {children}
      {req ? <ReqStar /> : null}
    </label>
  );
}

export default function AnnRegister() {
  const [sidoCd, setSidoCd] = useState('');
  const [sigunguCd, setSigunguCd] = useState('');
  const [sigunguOptions, setSigunguOptions] = useState([]);
  const [dongCd, setDongCd] = useState('');
  const [aptCmplexNo, setAptCmplexNo] = useState('');
  const [addr, setAddr] = useState('');

  useEffect(() => {
    if (!sidoCd) {
      setSigunguOptions([]);
      return;
    }
    const ac = new AbortController();
    (async () => {
      try {
        const res = await requestApi.get('/main/apt/sigungu.do', {
          params: { sidoNm: sidoCd },
          signal: ac.signal,
        });
        setSigunguOptions(toSigunguOptions(res.data));
      } catch (e) {
        if (e?.code === 'ERR_CANCELED' || e?.name === 'CanceledError') return;
        console.error('sigungu.do', e);
        setSigunguOptions([]);
      }
    })();
    return () => ac.abort();
  }, [sidoCd]);

  const dongOptions = [];
  const aptOptions = [];
  const submitDocNames = [];

  const resetFromSigungu = () => {
    setDongCd('');
    setAptCmplexNo('');
    setAddr('');
  };

  return (
    <>
      <style>{ANN_PAGE_CSS}</style>
      <div className="content-wrapper ann-register-full">
      <header className="page-header" style={{ alignItems: 'flex-start' }}>
        <h1 className="page-title">공고 등록</h1>
      </header>

      <div className="form-sections-stack">
        <section className="form-card">
          <h2 className="form-card-title">기본 정보</h2>
          <div className="form-grid-stack">
            <div className="form-input-group">
              <LR htmlFor="ttl" req>
                공고 제목
              </LR>
              <input id="ttl" name="ttl" type="text" placeholder="공고 제목을 입력하세요" />
            </div>
            <div className="form-input-group">
              <LR htmlFor="content" req>
                공고 내용
              </LR>
              <textarea
                id="content"
                name="content"
                style={ann.textarea}
                placeholder="공고 내용을 입력하세요"
              />
            </div>
          </div>
        </section>

        <section className="form-card">
          <h2 className="form-card-title">공고 정보</h2>
          <div className="form-grid-stack">
            {[0, 2].map((start) => (
              <div key={DATE_FIELDS[start][0]} className="form-row-grid">
                {DATE_FIELDS.slice(start, start + 2).map(([name, label]) => (
                  <div key={name} className="form-input-group">
                    <LR htmlFor={name} req>
                      {label}
                    </LR>
                    <input id={name} name={name} type="date" />
                  </div>
                ))}
              </div>
            ))}
          </div>
        </section>

        <section className="form-card">
          <h2 className="form-card-title">공급 정보</h2>
          <div className="form-grid-stack">
            <div className="form-row-grid">
              <div className="form-input-group">
                <LR htmlFor="sidoCd" req>
                  시·도
                </LR>
                <select
                  id="sidoCd"
                  name="sidoCd"
                  value={sidoCd}
                  onChange={(e) => {
                    setSidoCd(e.target.value);
                    setSigunguCd('');
                    resetFromSigungu();
                  }}
                >
                  <option value="">시·도 선택</option>
                  {SIDO_OPTIONS.map((o) => (
                    <option key={o.value} value={o.value}>
                      {o.label}
                    </option>
                  ))}
                </select>
              </div>
              <div className="form-input-group">
                <LR htmlFor="sigunguCd" req>
                  시·군·구
                </LR>
                <select
                  id="sigunguCd"
                  name="sigunguCd"
                  value={sigunguCd}
                  disabled={!sidoCd}
                  onChange={(e) => {
                    setSigunguCd(e.target.value);
                    resetFromSigungu();
                  }}
                >
                  <option value="">{sidoCd ? '시·군·구 선택' : '시·도를 먼저 선택하세요'}</option>
                  {sigunguOptions.map((o) => (
                    <option key={o.value} value={o.value}>
                      {o.label}
                    </option>
                  ))}
                </select>
              </div>
            </div>
            <div className="form-row-grid">
              <div className="form-input-group">
                <LR htmlFor="dongCd" req>
                  읍·면·동
                </LR>
                <select
                  id="dongCd"
                  name="dongCd"
                  value={dongCd}
                  disabled={!sigunguCd}
                  onChange={(e) => {
                    setDongCd(e.target.value);
                    setAptCmplexNo('');
                    setAddr('');
                  }}
                >
                  <option value="">{sigunguCd ? '읍·면·동 선택' : '시·군·구를 먼저 선택하세요'}</option>
                  {dongOptions.map((o) => (
                    <option key={o.value} value={o.value}>
                      {o.label}
                    </option>
                  ))}
                </select>
              </div>
              <div className="form-input-group">
                <LR htmlFor="aptCmplexNo" req>
                  아파트 단지
                </LR>
                <select
                  id="aptCmplexNo"
                  name="aptCmplexNo"
                  value={aptCmplexNo}
                  disabled={!dongCd}
                  onChange={(e) => {
                    setAptCmplexNo(e.target.value);
                    setAddr('');
                  }}
                >
                  <option value="">{dongCd ? '아파트 단지 선택' : '읍·면·동을 먼저 선택하세요'}</option>
                  {aptOptions.map((o) => (
                    <option key={o.value} value={o.value}>
                      {o.label}
                    </option>
                  ))}
                </select>
              </div>
            </div>
            <div className="form-input-group">
              <label htmlFor="addr">주소</label>
              <input
                id="addr"
                name="addr"
                type="text"
                readOnly
                style={ann.readonly}
                value={addr}
                placeholder="단지를 선택하세요"
              />
            </div>
            <div className="table-wrapper">
              <div className="table-container">
                <table className="data-table ann-supply-table">
                  <thead>
                    <tr>
                      {SUPPLY_COLS.map((c) => (
                        <th key={c.key}>{c.label}</th>
                      ))}
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      {SUPPLY_COLS.map((c) => (
                        <td key={c.key}>
                          <input
                            style={ann.tableInput}
                            type={c.input}
                            name={`supply_${c.key}`}
                            placeholder={c.ph}
                            {...(c.input === 'number'
                              ? { min: c.min ?? 0, ...(c.step != null ? { step: c.step } : {}) }
                              : {})}
                          />
                        </td>
                      ))}
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </section>

        <section className="form-card">
          <h2 className="form-card-title">제출 서류</h2>
          {submitDocNames.length === 0 ? (
            <p className="upload-sub-text">목록은 백엔드 연동 후 표시됩니다.</p>
          ) : (
            <ol style={ann.docList}>
              {submitDocNames.map((n) => (
                <li key={n}>{n}</li>
              ))}
            </ol>
          )}
        </section>
      </div>

      <footer style={ann.footer}>
        <Button type="button" className="btn-primary">
          등록
        </Button>
      </footer>
    </div>
    </>
  );
}
