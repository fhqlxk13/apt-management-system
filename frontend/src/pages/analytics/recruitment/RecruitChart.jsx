import React from 'react';

const RecruitChart = ({ data = [] }) => {
  if (!data || data.length === 0) return <div>데이터가 없습니다.</div>;

  return (
    <div className="card-container">
      
      {data.map((item) => {
        const percentage = Math.min(item.rate, 100);
        const isOver = item.rate > 100;

        return (
          <div key={item.annNo} style={{ marginBottom: '24px' }}>
            <div style={{ 
              display: 'flex', 
              justifyContent: 'space-between', 
              alignItems: 'baseline', 
              marginBottom: '8px' 
            }}>
              <span className="cell-title">{item.ttl}</span>
              <span className="text-small" style={{ color: 'var(--on-surface-variant)', fontWeight: '600' }}>
                {item.applicantCnt}명 / {item.supplyCnt}세대 ({item.rate.toFixed(1)}%)
              </span>
            </div>
            
            {/* 진행률 바 컨테이너 */}
            <div style={{ 
              width: '100%', 
              height: '12px', 
              backgroundColor: 'var(--surface-container-high)', 
              borderRadius: '999px', 
              overflow: 'hidden' 
            }}>
              {/* 실제 채워지는 바 */}
              <div style={{ 
                width: `${percentage}%`, 
                height: '100%', 
                backgroundColor: isOver ? 'var(--error)' : 'var(--primary)',
                transition: 'width 0.5s ease-in-out'
              }} />
            </div>
          </div>
        );
      })}
    </div>
  );
};

export default RecruitChart;