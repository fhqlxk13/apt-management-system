import { LR, annStyles } from './formBits';

export default function BasicInfoSection({ annForm, onFieldChange }) {
  return (
    <section className="form-card">
      <h2 className="form-card-title">기본 정보</h2>
      <div className="form-grid-stack">
        <div className="form-input-group">
          <LR htmlFor="ttl" req>
            공고 제목
          </LR>
          <input
            id="ttl"
            name="ttl"
            type="text"
            placeholder="공고 제목을 입력하세요"
            value={annForm.ttl}
            onChange={(e) => onFieldChange('ttl', e.target.value)}
          />
        </div>
        <div className="form-input-group">
          <LR htmlFor="cn" req>
            공고 내용
          </LR>
          <textarea
            id="cn"
            name="cn"
            style={annStyles.textarea}
            placeholder="공고 내용을 입력하세요"
            value={annForm.cn}
            onChange={(e) => onFieldChange('cn', e.target.value)}
          />
        </div>
      </div>
    </section>
  );
}
