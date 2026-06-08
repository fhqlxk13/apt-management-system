import Anls from "./analytics/Anls";
import RecruitContainer from "./analytics/recruitment/RecruitContainer";
import ResidentContainer from "./analytics/resident/ResidentContainer";
import CtrtBoard from "./ctrt/CtrtBoard";

const Home = () => {

  const thStyle = {
    padding: '14px',
    textAlign: 'center',
    borderBottom: '1px solid #e5e7eb',
    fontWeight: '700',
    color: '#475569',
    background: '#f8fafc'
  };

  const tdStyle = {
    padding: '14px',
    textAlign: 'center',
    borderBottom: '1px solid #f1f5f9'
  };

  return (
    <>
      <div style={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: 'var(--bg)'
      }}>
        <h1 style={{
          fontSize: '40px',
          fontWeight: '900',
          color: 'var(--text-primary)',
          letterSpacing: '-1px',
          margin: 0,
          opacity: 0.9
        }}>
          DASH BOARD
        </h1>
        <div style={{
          marginTop: '10px',
          marginBottom: '20px',
          padding: '6px 16px',
          backgroundColor: 'rgba(59, 130, 246, 0.1)',
          borderRadius: '20px',
          color: 'var(--text-secondary)',
          fontSize: '15px',
          fontWeight: '600'
        }}>
          우리집맵핑 중앙관리 시스템
        </div>
      </div>
      <div className="content-wrapper" style={{ alignSelf: 'flex-start', padding: '6px 16px' }}>
        <section>
          <h1 className="section-title board">계약 현황</h1>
          <CtrtBoard />
          <div style={{ display: 'flex', gap: '20px' }}>
            <div style={{ flex: 1, marginTop: '20px', height: '300px' }}>
              <h1 className="section-title board">진행중인 공고별 지원률</h1>
              <RecruitContainer />
            </div>
            <div style={{ flex: 1, marginTop: '20px', height: '300px' }}>
              <h1 className="section-title board">최근 6개월 입주자 수 추이</h1>
              <ResidentContainer />
            </div>
          </div>

          <div style={{ marginTop: '60px' }}>
            <h1 className="section-title board">최근 관리자 신청 현황</h1>

            <div
              style={{
                background: '#fff',
                borderRadius: '12px',
                border: '1px solid #e5e7eb',
                overflowX: 'auto'
              }}
            >
              <table
                style={{
                  width: '100%',
                  tableLayout: 'fixed',
                  borderCollapse: 'collapse'
                }}
              >
                <thead>
                  <tr style={{ background: '#f8fafc' }}>
                    <th style={thStyle}>신청자</th>
                    <th style={thStyle}>아이디</th>
                    <th style={thStyle}>단지명</th>
                    <th style={thStyle}>직무</th>
                    <th style={thStyle}>신청일</th>
                    <th style={thStyle}>상태</th>
                  </tr>
                </thead>

                <tbody>
                  {[
                    {
                      name: '김도윤',
                      id: 'kimdy26',
                      apt: '가락 미륭 아파트',
                      duty: '회계담당',
                      date: '2026-06-05',
                      status: '승인대기'
                    },
                    {
                      name: '이서연',
                      id: 'lsy_admin',
                      apt: '세종 더샵 레이크파크',
                      duty: '행정담당',
                      date: '2026-06-04',
                      status: '승인완료'
                    },
                    {
                      name: '박준혁',
                      id: 'parkjh88',
                      apt: '대전 도안 푸르지오',
                      duty: '시설관리',
                      date: '2026-06-03',
                      status: '승인대기'
                    },
                    {
                      name: '정유진',
                      id: 'jyj_manager',
                      apt: '유성 자이아파트',
                      duty: '회계담당',
                      date: '2026-06-03',
                      status: '반려'
                    },
                    {
                      name: '최민석',
                      id: 'cms_admin',
                      apt: '관저 리슈빌',
                      duty: '관리과장',
                      date: '2026-06-02',
                      status: '승인대기'
                    }
                  ].map((row, idx) => (
                    <tr
                      key={idx}
                      style={{
                        transition: 'all .2s ease'
                      }}
                    >
                      <td style={tdStyle}>{row.name}</td>

                      <td
                        style={{
                          ...tdStyle,
                          color: '#64748b',
                          fontSize: '13px'
                        }}
                      >
                        {row.id}
                      </td>

                      <td
                        style={{
                          ...tdStyle,
                          fontWeight: '600'
                        }}
                      >
                        {row.apt}
                      </td>

                      <td style={tdStyle}>{row.duty}</td>

                      <td
                        style={{
                          ...tdStyle,
                          color: '#64748b'
                        }}
                      >
                        {row.date}
                      </td>

                      <td style={tdStyle}>
                        <span
                          style={{
                            padding: '5px 12px',
                            borderRadius: '20px',
                            fontSize: '12px',
                            fontWeight: '700',
                            display: 'inline-block',
                            background:
                              row.status === '승인완료'
                                ? '#dcfce7'
                                : row.status === '반려'
                                  ? '#fee2e2'
                                  : '#fef3c7',
                            color:
                              row.status === '승인완료'
                                ? '#166534'
                                : row.status === '반려'
                                  ? '#b91c1c'
                                  : '#92400e'
                          }}
                        >
                          {row.status}
                        </span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </section>
      </div>
    </>
  );
};

export default Home;