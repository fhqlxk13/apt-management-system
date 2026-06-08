
// eslint-disable-next-line no-unused-vars
const Header = ({ parent, current, admInfo }) => {
  return (
    <div className="topbar">
      <div className="breadcrumb">
        <span className="material-symbols-rounded" style={{ fontSize: '14px' }}>home</span>
        <span style={{ margin: '0 4px' }}>/</span>
        <span>{parent}</span>
        <span style={{ margin: '0 4px' }}>/</span>
        <span className="bc-current">{current}</span>
      </div>
      <div className="topbar-actions">
        <button className="topbar-icon-btn" style={{position:'relative', background:'none', border:'none', cursor:'pointer'}}>
          <span className="material-symbols-rounded">notifications</span>
          <div className="dot" style={{position:'absolute', top:'8px', right:'8px', width:'6px', height:'6px', background:'#ef4444', borderRadius:'50%'}}></div>
        </button>
        <button className="topbar-icon-btn" style={{background:'none', border:'none', cursor:'pointer', marginLeft:'10px'}}>
          <span className="material-symbols-rounded">settings</span>
        </button>
      </div>
    </div>
  );
};

export default Header;