export const Card = ({ title, subtitle, children, actions, divide = false }) => (
  <div className={`c-card ${divide ? 'c-card--divide' : ''}`}>
    {(title || actions) && (
      <div className="c-card__header">
        <div>
          {title && <div className="c-card__title">{title}</div>}
          {subtitle && <div className="c-card__sub">{subtitle}</div>}
        </div>
        {actions && <div className="c-card__actions">{actions}</div>}
      </div>
    )}
    <div className="c-card__body">{children}</div>
  </div>
);