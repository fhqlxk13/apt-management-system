import React from 'react';
import { Search } from 'lucide-react';

const FeeFilter = ({ filters, setFilters, onSearch }) => {
    const aptOptions = [
        "반포자이", "래미안원베일리", "아크로리버파크", "헬리오시티", "잠실엘스",
        "트리지움", "고덕그라시움", "마포래미안푸르지오", "경희궁자이", "은평뉴타운",
        "래미안대치팰리스", "은마아파트", "도곡렉슬", "개포래미안포레스트", "디에이치자이개포"
    ];

    const handleInputChange = (index, value) => {
        const newSelected = [...filters.selectedApts];
        newSelected[index] = value;
        setFilters(prev => ({ ...prev, selectedApts: newSelected }));
    };

    return (
        <div style={{ padding: '10px', background: '#f8f9fa', borderRadius: '12px', marginBottom: '10px' }}>
            <div style={{ display: 'flex', gap: '10px', alignItems: 'center', flexWrap: 'wrap' }}>
                <span style={{ fontWeight: 'bold' }}>아파트 비교:</span>

                {/* 인풋 4개 */}
                {[0, 1, 2, 3].map((index) => (
                    <input
                        key={index}
                        // 모든 인풋이 동일한 ID를 참조하여 리스트가 항상 뜨게 함
                        list="apt-list-all" 
                        value={filters.selectedApts[index] || ""}
                        onChange={(e) => handleInputChange(index, e.target.value)}
                        placeholder={`아파트 ${index + 1}`}
                        style={{ padding: '8px', borderRadius: '6px', border: '1px solid #ddd', width: '130px' }}
                    />
                ))}

                {/* 리스트는 딱 하나만 선언 */}
                <datalist id="apt-list-all">
                    {aptOptions.map(apt => (
                        <option key={apt} value={apt} />
                    ))}
                </datalist>

                <button onClick={onSearch} style={{ padding: '8px 16px', background: '#4a90e2', color: 'white', border: 'none', borderRadius: '6px', cursor: 'pointer' }}>
                     조회
                </button>
            </div>
        </div>
    );
};

export default FeeFilter;