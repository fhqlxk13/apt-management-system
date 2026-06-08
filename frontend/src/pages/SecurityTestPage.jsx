import axios from 'axios';

const SecurityTestPage = () => {

  const checkAuth = async () => {

    try {

      // JWT 토큰 가져오기
      const token = localStorage.getItem("accessToken");

      const res = await axios.get('/api/react/adm/test', {
        headers: {
          Authorization: `Bearer ${token}`
        }
      });

      alert(`성공: ${res.data}`);

    } catch (err) {

      console.error(err);

      alert(`실패: ${err.response?.status || '연결 오류'}`);
    }
  };

  return (
    <div
      style={{
        border: '2px solid #444',
        padding: '20px',
        borderRadius: '10px'
      }}
    >
      <h2>🔐 중앙관리자 보안 테스트 섹션</h2>

      <p>
        JWT 인증 기반 React API 권한 테스트
      </p>

      <div
        style={{
          display: 'flex',
          gap: '10px',
          marginTop: '20px'
        }}
      >

        <button
          onClick={checkAuth}
          style={{
            padding: '10px 20px',
            cursor: 'pointer'
          }}
        >
          권한 체크 API 호출 (@PreAuthorize)
        </button>

        <button
          onClick={() => {
            window.location.href = '/member/myPage.do';
          }}
          style={{
            padding: '10px 20px',
            backgroundColor: '#f0f0f0'
          }}
        >
          JSP 마이페이지로 돌아가기
        </button>

        <button
          onClick={() => {
            window.location.href = '/apt/main/A10023118';
          }}
          style={{
            padding: '10px 20px',
            backgroundColor: '#f0f0f0'
          }}
        >
          공덕동 행복시티로 돌아가기
        </button>

      </div>
    </div>
  );
};

export default SecurityTestPage;