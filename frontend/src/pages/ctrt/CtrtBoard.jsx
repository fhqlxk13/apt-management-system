import { ChartSpline, FileBracesCorner, FileChartLine, FileClock, FileXCorner, SquarePen } from 'lucide-react';
import React, { useEffect, useState } from 'react'
import requestApi from '../../util/api/requestApi';

function CtrtBoard() {

  // 대시보드 통계 상태
  const [stats, setStats] = useState({
    totalCnt: 0,
    pendingCnt: 0,
    approvedCnt: 0,
    terminatedCnt: 0,
    rejectCnt: 0,
    cancelCnt: 0,
    urgentCnt: 0,
  });

  // 대시보드 통계 API 호출
  useEffect(() => {
    const fetchDashboardStats = async () => {
      try {
        const response = await requestApi.get(`/api/react/adm/ctrt/dashboard`);
        if (response.data && response.data.dashboard) {
          const stts = response.data.dashboard;
          setStats({
            totalCnt: stts.totalCnt || 0,
            pendingCnt: stts.pendingCnt || 0,
            approvedCnt: stts.approvedCnt || 0,
            terminatedCnt: stts.terminatedCnt || 0,
            rejectCnt: stts.rejectCnt || 0,
            cancelCnt: stts.cancelCnt || 0,
            expiredCnt: stts.expiredCnt || 0,
            urgentCnt: stts.urgentCnt || 0,
            increaseRate: stts.increaseRate || 0,
          });
        }
      } catch (error) {
        console.error("대시보드 데이터 로드 실패", error);
      }
    };
    fetchDashboardStats();
  }, []);

  const board = [
    { label: '총 계약', value: stats.totalCnt, change: '+12%', icon: <FileChartLine />, color: 'bg-primary-fixed' },

    { label: '승인된 계약', value: stats.approvedCnt, icon: <FileBracesCorner />, color: 'bg-primary-green', hasTrend: true },

    { label: '승인대기 계약', value: stats.pendingCnt, icon: <SquarePen />, color: 'bg-pending-container', pending: true },

    { label: '만료 임박 계약', value: stats.urgentCnt, icon: <FileClock />, color: 'bg-error-container', urgent: true },

    { label: '만료된 계약', value: stats.expiredCnt + stats.terminatedCnt , icon: <FileXCorner />, color: 'bg-expired-container', expired: true },

  ];

  return (
    <>
      {/* 대시보드 통계 그리드*/}
      <div className="stats-grid">
        {board.map((stat, i) => (
          <div key={i} className="stat-card">
            <div className="stat-icon-row">
              <div className={`icon-box-wrapper ${stat.color}`}>
                <span className="material-symbols-outlined">
                  {stat.icon}
                </span>
              </div>
              {stat.hasTrend && (
                <span className="stat-change">
                  <ChartSpline size={16} />전월 대비 : <span className='text-[12px]'>{stats.increaseRate}%</span>    {/* 지난달 대비 */}
                </span>
              )}
              {stat.expired && <span className="badge-expired">Expired</span>}
              {stat.urgent && <span className="badge-urgent">Urgent</span>}
            </div>
            <p className="stat-label">{stat.label}</p>
            <div style={{ display: 'flex', justifyContent: 'space-between' }}>
              <h3 className="stat-value">{stat.value}</h3>
              {stat.expired && (<p className='sub-info'>중도 해지 : {stats.terminatedCnt} 건 </p>)}
            </div>
          </div>
        ))}
      </div>
    </>
  )
}

export default CtrtBoard