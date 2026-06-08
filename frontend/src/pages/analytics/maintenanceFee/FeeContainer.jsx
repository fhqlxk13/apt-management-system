import React, { useState, useEffect } from 'react';
import FeeChart from './FeeChart';
import FeeFilter from './FeeFilter';
import StatsSection from './StateSection';

const FeeContainer = () => {
    // 1. 처음 들어왔을 때 드롭박스에 채워져 있을 기본 4개 아파트
    const initialApts = ["반포자이", "래미안원베일리", "아크로리버파크", "헬리오시티"];
    
    const [feeData, setFeeData] = useState([]);
    const [filters, setFilters] = useState({
        selectedApts: initialApts // 초기값으로 4개 세팅
    });

const dummy = [
    { month: '1월', 반포자이: 38.5, 래미안원베일리: 39.2, 아크로리버파크: 38.8, 헬리오시티: 32.5, 잠실엘스: 31.0, 트리지움: 30.5, 고덕그라시움: 28.5, 마포래미안푸르지오: 29.5, 경희궁자이: 30.0, 은평뉴타운: 26.0, 래미안대치팰리스: 37.5, 은마아파트: 27.0, 도곡렉슬: 34.0, 개포래미안포레스트: 35.5, 디에이치자이개포: 36.5 },
    { month: '2월', 반포자이: 37.8, 래미안원베일리: 38.5, 아크로리버파크: 38.0, 헬리오시티: 32.0, 잠실엘스: 30.5, 트리지움: 30.0, 고덕그라시움: 28.0, 마포래미안푸르지오: 29.0, 경희궁자이: 29.5, 은평뉴타운: 25.5, 래미안대치팰리스: 37.0, 은마아파트: 26.5, 도곡렉슬: 33.5, 개포래미안포레스트: 35.0, 디에이치자이개포: 36.0 },
    { month: '3월', 반포자이: 34.5, 래미안원베일리: 35.0, 아크로리버파크: 34.8, 헬리오시티: 29.0, 잠실엘스: 28.0, 트리지움: 27.5, 고덕그라시움: 26.0, 마포래미안푸르지오: 27.0, 경희궁자이: 27.5, 은평뉴타운: 24.0, 래미안대치팰리스: 33.5, 은마아파트: 25.0, 도곡렉슬: 31.0, 개포래미안포레스트: 32.0, 디에이치자이개포: 33.0 },
    { month: '4월', 반포자이: 32.0, 래미안원베일리: 32.5, 아크로리버파크: 32.2, 헬리오시티: 27.5, 잠실엘스: 27.0, 트리지움: 26.5, 고덕그라시움: 25.0, 마포래미안푸르지오: 26.0, 경희궁자이: 26.5, 은평뉴타운: 23.5, 래미안대치팰리스: 31.0, 은마아파트: 24.0, 도곡렉슬: 29.5, 개포래미안포레스트: 30.5, 디에이치자이개포: 31.5 }
];

    const handleSearch = () => {
        const activeApts = filters.selectedApts.filter(apt => apt && apt.trim() !== "");
        
        const filtered = dummy.map(item => {
            const newItem = { month: item.month };
            activeApts.forEach(apt => {
                newItem[apt] = item[apt] || 0;
            });
            return newItem;
        });
        setFeeData(filtered);
    };

    // 처음 로드될 때 바로 조회
    useEffect(() => {
        handleSearch();
    }, []);

    return (
        <div className="content-wrapper">
            <h2 className="page-title">관리비 비교 분석</h2>
            <FeeFilter filters={filters} setFilters={setFilters} onSearch={handleSearch} />
            <div className="card-container" style={{ marginTop: '20px' }}>
                <FeeChart data={feeData} />
            </div>
            <StatsSection data={dummy} />
        </div>
    );
};

export default FeeContainer;