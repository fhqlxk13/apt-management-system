import { useEffect, useState } from 'react';
import { Outlet } from 'react-router-dom';
import Header from './Header';
import Sidebar from './Sidebar';
import requestApi from '../../util/api/requestApi';

const MainLayout = ({ children }) => {
  const [isCollapsed, setIsCollapsed] = useState(false);
  const [admInfo, setAdmInfo] = useState(null); // 관리자 정보를 담을 상태
  const [pageInfo, setPageInfo] = useState({ parent: "", current: "" });

  useEffect(() => {
    // 1. 페이지 로드 시 관리자 정보 요청 (JWT는 인터셉터가 알아서 챙김)
    const getAdmProfile = async () => {
      try {
        const res = await requestApi.get('/api/react/adm/info');
        setAdmInfo(res.data); // 받아온 정보를 상태에 저장
        console.log("관리자 인증 성공:", res.data);
      } catch (err) {
        console.error("관리자 정보 로딩 실패:", err);
        // 토큰이 없거나 만료되었다면 로그인 페이지로 튕기기 등의 처리 가능
      }
    };

    getAdmProfile();
  }, []);

  return (
    <div id="wrapper">
      <Sidebar
        isCollapsed={isCollapsed}
        toggleSidebar={() => setIsCollapsed(!isCollapsed)}
        admInfo={admInfo} />
      <div className="main-wrap" style={{ flex: 1, display: 'flex', flexDirection: 'column' }}>
        <Header
          parent={pageInfo.parent}
          current={pageInfo.current}
          admInfo={admInfo} />
        <main className="main-content" style={{ flex: 1, padding: '10px 28px' }}>
          <Outlet context={{ admInfo, setPageInfo }} />
        </main>
      </div>
    </div>
  );
};

export default MainLayout;