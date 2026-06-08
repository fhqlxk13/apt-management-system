export const getNameByStatus = (ctrtSttsCd, mvinDt, mvoutDt) => {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    switch (ctrtSttsCd) {
        case 'PENDING':
            return { text: '승인대기', className: 'badge-pending' };

        case 'EXPIRED':
            return { text: '계약만료', className: 'badge-expired' };

        case 'CANCEL':
            return { text: '취소', className: 'badge-expired' };

        case 'TERMINATED':
            return { text: '중도 해지', className: 'badge-expired' };

        case 'REJECT':
            return { text: '반려', className: 'badge-expired' };

        case 'APPROVED':
            if (mvinDt && mvoutDt) {
                const start = new Date(mvinDt);
                const end = new Date(mvoutDt);
                start.setHours(0, 0, 0, 0);
                end.setHours(0, 0, 0, 0);

                if (today >= start && today <= end) return { text: '이행 중', className: 'badge-approved' }
                else if (today < start) return { text: '입주 대기', className: 'badge-waiting' };
            }
            return { text: '승인', className: 'badge-approved' };

        default:
            return { text: status || '미정', className: '' };
    }
};

export const getNameOfJm = (rentTypeCode) => {
    switch (rentTypeCode) {
        case 'JS':
            return { text: '전세' }

        default:
            return { text: '월세' }
    }
};