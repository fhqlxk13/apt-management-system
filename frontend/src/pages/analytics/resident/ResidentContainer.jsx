import React from 'react';
import ResidentChart from './ResidentChart';

const ResidentContainer = () => {
  // 6개월간의 더미 데이터
  const residentData = [
    { month: '2026-01', count: 12 },
    { month: '2026-02', count: 10 },
    { month: '2026-03', count: 14 },
    { month: '2026-04', count: 15 },
    { month: '2026-05', count: 17 },
    { month: '2026-06', count: 18 },
  ];

  return (
    <div className="card-container">
      <ResidentChart data={residentData} />
    </div>
  );
};

export default ResidentContainer;