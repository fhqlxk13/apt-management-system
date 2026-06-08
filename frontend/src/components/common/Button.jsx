export const Button = ({ children, variant = 'default', size = '', className = '', ...props }) => {
  const baseClassName = `c-btn ${variant !== 'default' ? `c-btn--${variant}` : ''} ${size ? `c-btn--${size}` : ''}`;
  const mergedClassName = [baseClassName, className].filter(Boolean).join(' ');
  return (
    <button className={mergedClassName} {...props}>
      {children}
    </button>
  );
};