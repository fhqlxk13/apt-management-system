import React from 'react';
import * as Rc from 'recharts';

const FeeChart = ({ data }) => {
    if (!data || data.length === 0) return <div>아파트를 선택하고 조회 버튼을 누르세요.</div>;
    
    // 데이터의 첫 번째 월 정보에서 'month' 키를 뺀 나머지(아파트 이름들)를 모두 뽑음
    const aptKeys = Object.keys(data[0]).filter(k => k !== 'month');
    const colors = ["#8884d8", "#82ca9d", "#ffc658", "#ff8042", "#a4de6c", "#d0ed57", "#ffc658"];

    return (
        <Rc.ResponsiveContainer width="100%" height={300}>
            <Rc.BarChart data={data}>
                <Rc.CartesianGrid strokeDasharray="3 3" vertical={false} />
                <Rc.XAxis dataKey="month" />
                <Rc.YAxis />
                <Rc.Tooltip />
                <Rc.Legend />
                {aptKeys.map((key, i) => (
                    <Rc.Bar key={key} dataKey={key} fill={colors[i % colors.length]} radius={[4, 4, 0, 0]} />
                ))}
            </Rc.BarChart>
        </Rc.ResponsiveContainer>
    );
};

export default FeeChart;