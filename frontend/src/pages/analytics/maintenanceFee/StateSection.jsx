import React from 'react';

const StatsSection = ({ data }) => {
    const aptNames = Object.keys(data[0]).filter(k => k !== 'month');
    const averages = aptNames.map(name => {
        const sum = data.reduce((acc, curr) => acc + (curr[name] || 0), 0);
        return { name, avg: (sum / data.length).toFixed(1) };
    });

    const sorted = [...averages].sort((a, b) => b.avg - a.avg);
    const top4 = sorted.slice(0, 4);
    const bottom4 = sorted.slice(-4).reverse();

    return (
        <div className="stats-wrapper" style={{marginTop: '0px'}}>
            {/* 상위 4개 섹션 */}
            <div className="stat-group-card">
                <h4 className="stat-group-title">
                    관리비 상위 4개
                </h4>
                {top4.map((apt, i) => (
                    <div key={i} className="stat-item">
                        <span style={{display: 'flex', alignItems: 'center'}}>
                            <span className="stat-rank">{i + 1}</span> {apt.name}
                        </span>
                        <span className="stat-value">{apt.avg} <span className="sub-info">만원</span></span>
                    </div>
                ))}
            </div>

            {/* 하위 4개 섹션 */}
            <div className="stat-group-card">
                <h4 className="stat-group-title" style={{ color: 'var(--secondary)' }}>
                    관리비 하위 4개
                </h4>
                {bottom4.map((apt, i) => (
                    <div key={i} className="stat-item">
                        <span style={{display: 'flex', alignItems: 'center'}}>
                            <span className="stat-rank">{i + 1}</span> {apt.name}
                        </span>
                        <span className="stat-value">{apt.avg} <span className="sub-info">만원</span></span>
                    </div>
                ))}
            </div>
        </div>
    );
};

export default StatsSection;