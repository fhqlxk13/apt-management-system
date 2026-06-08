import React from 'react'
import RecruitChart from './RecruitChart';

function RecruitContainer() {
    const dummyData = [
        { annNo: 1, ttl: '공덕동 행복주택 크로시티', supplyCnt: 100, applicantCnt: 85, rate: (85 / 100) * 100 },
        { annNo: 2, ttl: '상암 월드컵3단지', supplyCnt: 50, applicantCnt: 25, rate: (25 / 50) * 100 },
        { annNo: 3, ttl: '가락 미륭 아파트', supplyCnt: 200, applicantCnt: 210, rate: (210 / 200) * 100 },
    ];
    return (
        <div className="card-container" style={{paddingBottom: '10px'}}>
            <RecruitChart data={dummyData} />
        </div>
    )
}

export default RecruitContainer