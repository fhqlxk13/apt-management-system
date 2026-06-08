import { DATE_FIELDS, LR } from './formBits';

export default function AnnInfoSection({ annForm, onFieldChange }) {
  return (
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
                <input
                  id={name}
                  name={name}
                  type="date"
                  value={annForm[name]}
                  onChange={(e) => onFieldChange(name, e.target.value)}
                />
              </div>
            ))}
          </div>
        ))}
      </div>
    </section>
  );
}
