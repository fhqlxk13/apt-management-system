import { Blocks, Book, Building2, ChartSpline, ChevronDown, ChevronRight, FileOutput, Files, FileSearchCorner, IdCardLanyard, MapPinHouse, Megaphone, MessageCircleQuestionMark, NotebookPen, PenBox, PenIcon, ScrollText, SquareUserRound, UserRoundPlus, Users } from 'lucide-react';
import React, { useState } from 'react';
import { NavLink } from 'react-router-dom';

const MENU_DATA = [
  {
    id: 'building',
    label: '건물 · 매물',
    items: [
      { to: '/adm/apt/register', label: '아파트 관리', icon: <Building2 className='luci-icon' /> },
      // { to: '/adm/apt/search', label: '아파트 통합 검색', icon: <Building2 className='luci-icon' /> },
      { to: '/adm/sales', label: '임대 매물 관리', icon: <NotebookPen className='luci-icon' /> },
      // { to: '/adm/sales/list', label: '임대 매물 검색', icon: <FileSearchCorner className='luci-icon' /> },
    ]
  },
  {
    id: 'contract',
    label: '계약',
    items: [
      { to: '/adm/applicant', label: '임대모집 신청 관리', icon: <FileOutput className='luci-icon' /> },
      { to: '/adm/ctrt', label: '계약 관리', icon: <ScrollText className='luci-icon' /> },
      // { to: '/adm/ctrt-forms', label: '계약 서식 관리', icon: <Files className='luci-icon' /> },
    ]
  },
  {
    id: 'member',
    label: '회원',
    items: [
      { to: '/adm/member', label: '회원 관리', icon: <Users className='luci-icon' /> },
      // { to: '/adm/resident', label: '입주민 관리', icon: <SquareUserRound className='luci-icon' /> },
    ]
  },
  {
    id: 'community',
    label: '커뮤니티',
    items: [
      { to: '/adm/ann', label: '공고 관리', icon: <Megaphone className='luci-icon' /> },
      // { to: '/adm/ann/register', label: '공고 등록', icon: <PenIcon className='luci-icon' /> },
      // { to: '/adm/inqry', label: '문의 관리', icon: <MessageCircleQuestionMark className='luci-icon' /> },
    ]
  },
  {
    id: 'staff',
    label: '직원',
    items: [
      // { to: '/adm/staff', label: '직원 계정 관리', icon: <UserRoundPlus className='luci-icon' /> },
      { to: '/adm/mgmtOfc/account', label: '관리사무소 직원 관리', icon: <IdCardLanyard className='luci-icon' /> },
    ]
  },
  {
    id: 'analytics',
    label: '통계 · 수치',
    items: [
      { to: '/adm/analytics', label: '통계', icon: <ChartSpline className='luci-icon' /> },
    ]
  },
];

const Sidebar = ({ isCollapsed, toggleSidebar, admInfo }) => {
  const [openSections, setOpenSections] = useState(MENU_DATA.map(section => section.id));
  const handleToggle = (id) => {
    if (isCollapsed) return;
    setOpenSections(prev => prev.includes(id) ? prev.filter(item => item !== id) : [...prev, id]);
  };

  return (
    /* 사이드바 헤더 부분 */
    <aside id="sidebar" className={isCollapsed ? 'collapsed' : ''}>
      <div className="sidebar-logo">
        <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
          <div className="logo-icon">
            <MapPinHouse />
          </div>
          {!isCollapsed && (
            <div>
              <h1 style={{ fontSize: '16px', fontWeight: '700', margin: 0, color: '#009785FF' }}>우리집맵핑</h1>
              <p style={{ fontSize: '10px', color: 'var(--sb-label)', margin: 0 }}>중앙관리 시스템</p>
            </div>
          )}
        </div>
        <button onClick={toggleSidebar} className='sidebar-btn'>
          <span className="material-symbols-rounded">{isCollapsed ? 'side_navigation' : 'left_panel_close'}</span>
        </button>
      </div>
      {/* 사이드바 헤더 부분 end */}

      {/* nav 영역 시작 */}
      <nav className="sidebar-nav">
        <NavLink to="/"
          className={({ isActive }) => isActive ? "nav-item active" : "nav-item"}>
          <span className="material-symbols-rounded">dashboard</span>
          {!isCollapsed && <span style={{ marginLeft: '12px' }}>대시보드</span>}
        </NavLink>
        <div className="nav-divider"></div>

        {/* 대분류 */}
        {MENU_DATA.map((section) => (
          <React.Fragment key={section.id}>

            {/* 대분류 레이블 */}
            <div
              className="nav-item section-label"
              onClick={() => handleToggle(section.id)}
              style={{ cursor: 'pointer', display: 'flex', justifyContent: 'space-between' }}>
              <span>{section.label}</span>
              {!isCollapsed && (openSections.includes(section.id) ? <ChevronDown size={14} /> : <ChevronRight size={14} />)}
            </div>

            {/* 하위 메뉴 리스트 (조건부 렌더링) */}
            {(openSections.includes(section.id) || isCollapsed) && (
              <div className="sub-menu">
                {section.items.map((item, idx) => (
                  <NavLink
                    key={idx}
                    to={item.to}
                    className={({ isActive }) => isActive ? "nav-item active" : "nav-item"}
                  >
                    {item.icon}
                    {!isCollapsed && <span>&nbsp; {item.label}</span>}
                  </NavLink>
                ))}
              </div>
            )}
            <div className="nav-divider"></div>
          </React.Fragment>
        ))}
      </nav>
      {/* nav영역 end */}

      {/* 관리자 명함 카드 */}
      <div className="admin-card">
        <div style={{ width: '34px', height: '34px', background: '#3b9e52', borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <span className="material-symbols-rounded" style={{ color: '#fff', fontSize: '18px' }}>person</span>
        </div>
        {!isCollapsed && (
          <div style={{ flex: 1, marginLeft: '12px' }}>
            <p style={{ color: '#fff', fontSize: '12px', fontWeight: '700', margin: 0 }}>중앙관리자</p>
            <span style={{ color: 'var(--sb-label)', fontSize: '10px' }}>{admInfo ? `${admInfo.userNm} 님 ` : '정보 로딩중...'}</span>
            <span style={{ color: 'var(--sb-label)', fontSize: '10px' }}>
              {admInfo?.userNo ? `(no.${admInfo.userNo})` : ''}
            </span>
          </div>
        )}
      </div>
    </aside>
  );
};

export default Sidebar;