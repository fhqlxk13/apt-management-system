import { annStyles } from './formBits';

/** 단지 매물 기준 필요 제출서류 — 조회 전용 (등록 시 label을 sbmsnDoc으로 저장) */
export default function SubmitDocSection({ submitDocOptions = [] }) {
  return (
    <section className="form-card">
      <h2 className="form-card-title">제출 서류</h2>
      {submitDocOptions.length === 0 ? (
        <p className="upload-sub-text">단지를 선택하면 해당 매물에 필요한 제출 서류가 표시됩니다.</p>
      ) : (
        <ol style={annStyles.docList}>
          {submitDocOptions.map((doc) => (
            <li key={doc.value}>{doc.label}</li>
          ))}
        </ol>
      )}
    </section>
  );
}
