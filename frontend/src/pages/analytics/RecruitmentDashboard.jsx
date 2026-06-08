import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer } from 'recharts';
const RecruitmentDashboard = ({ data = [] }) => { // props 기본값 설정

  // 데이터가 없는 경우를 대비한 안전 장치
  if (!data || data.length === 0) return <div>데이터가 없습니다.</div>;

  return (
    <div className="dashboard-container">
      {data.map((item) => (
        <div key={item.annNo} className="row" style={{ display: 'flex', alignItems: 'center', marginBottom: '20px' }}>
          <div style={{ width: '40%' }}>
            <h3>{item.ttl}</h3>
            <p>공급 세대: {item.supplyCnt} | 신청자: {item.applicantCnt}</p>
          </div>
          
          <div style={{ width: '60%', height: '80px' }}>
            <ResponsiveContainer>
              <BarChart 
                data={[{ 
                    name: '비율', 
                    value: item.supplyCnt > 0 ? (item.applicantCnt / item.supplyCnt) * 100 : 0 
                }]} 
                layout="vertical">
                <XAxis type="number" domain={[0, 100]} hide />
                <YAxis dataKey="name" type="category" hide />
                <Tooltip />
                <Bar dataKey="value" fill="#8884d8" radius={[0, 5, 5, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>
      ))}
    </div>
  );
};

export default RecruitmentDashboard;