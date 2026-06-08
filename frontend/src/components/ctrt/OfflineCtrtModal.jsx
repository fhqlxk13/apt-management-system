import { useState } from 'react';

import AptSearchSelect
    from './AptSearchSelect';

function OfflineCtrtModal({

    open,

    onClose

}) {

    const [selectedApt, setSelectedApt]
        = useState(null);

    const [dongList, setDongList]
        = useState([]);

    const [selectedDong, setSelectedDong]
        = useState('');

    const [hoList, setHoList]
        = useState([]);

    const [selectedHo, setSelectedHo]
        = useState('');

    if (!open) return null;

    return (

        <div
            style={{
                position: 'fixed',

                inset: 0,

                background:
                    'rgba(0,0,0,0.35)',

                display: 'flex',

                alignItems: 'center',

                justifyContent: 'center',

                zIndex: 9999
            }}
        >

            <div
                style={{
                    width: '920px',

                    maxHeight: '90vh',

                    overflowY: 'auto',

                    background: '#fff',

                    borderRadius: '12px',

                    padding: '24px'
                }}
            >

                {/* 헤더 */}
                <div
                    style={{
                        display: 'flex',

                        justifyContent:
                            'space-between',

                        alignItems: 'center',

                        marginBottom: '24px'
                    }}
                >

                    <div>

                        <div
                            style={{
                                fontSize: '22px',

                                fontWeight: '700'
                            }}
                        >
                            오프라인 계약 등록
                        </div>

                        <div
                            style={{
                                marginTop: '4px',

                                fontSize: '13px',

                                color: '#666'
                            }}
                        >
                            오프라인 계약서를 기반으로
                            계약 정보를 등록합니다.
                        </div>

                    </div>

                    <button
                        onClick={onClose}

                        style={{
                            border: 'none',

                            background: 'none',

                            fontSize: '22px',

                            cursor: 'pointer'
                        }}
                    >
                        ✕
                    </button>

                </div>

                {/* 아파트 / 동 / 호 */}
                <div
                    style={{
                        border:
                            '1px solid #ddd',

                        padding: '20px',

                        marginBottom: '24px'
                    }}
                >

                    <div
                        style={{
                            fontSize: '15px',

                            fontWeight: '700',

                            marginBottom: '16px'
                        }}
                    >
                        계약 대상 선택
                    </div>

                    <div
                        style={{
                            display: 'grid',

                            gridTemplateColumns:
                                '2fr 1fr 1fr',

                            gap: '16px'
                        }}
                    >

                        {/* 아파트 */}
                        <div>

                            <div
                                style={{
                                    fontSize: '13px',

                                    marginBottom: '6px'
                                }}
                            >
                                아파트
                            </div>

                            <AptSearchSelect
                                value={selectedApt}
                                onChange={
                                    setSelectedApt
                                }
                            />

                        </div>

                        {/* 동 */}
                        <div>

                            <div
                                style={{
                                    fontSize: '13px',

                                    marginBottom: '6px'
                                }}
                            >
                                동
                            </div>

                            <select
                                value={selectedDong}

                                onChange={(e) =>
                                    setSelectedDong(
                                        e.target.value
                                    )
                                }

                                style={{
                                    width: '100%',

                                    height: '40px'
                                }}
                            >

                                <option value="">
                                    동 선택
                                </option>

                                {dongList.map(
                                    (dong) => (

                                        <option
                                            key={dong}
                                            value={dong}
                                        >
                                            {dong}
                                        </option>

                                    )
                                )}

                            </select>

                        </div>

                        {/* 호 */}
                        <div>

                            <div
                                style={{
                                    fontSize: '13px',

                                    marginBottom: '6px'
                                }}
                            >
                                호
                            </div>

                            <select
                                value={selectedHo}

                                onChange={(e) =>
                                    setSelectedHo(
                                        e.target.value
                                    )
                                }

                                style={{
                                    width: '100%',

                                    height: '40px'
                                }}
                            >

                                <option value="">
                                    호 선택
                                </option>

                                {hoList.map((ho) => (

                                    <option
                                        key={ho.unitNo}
                                        value={ho.unitNo}
                                    >
                                        {ho.hoNo}
                                    </option>

                                ))}

                            </select>

                        </div>

                    </div>

                </div>

                {/* 자동 조회 정보 */}
                <div
                    style={{
                        border:
                            '1px solid #ddd',

                        padding: '20px',

                        marginBottom: '24px'
                    }}
                >

                    <div
                        style={{
                            fontSize: '15px',

                            fontWeight: '700',

                            marginBottom: '16px'
                        }}
                    >
                        매물 정보
                    </div>

                    <div
                        style={{
                            display: 'grid',

                            gridTemplateColumns:
                                '1fr 1fr 1fr',

                            gap: '16px'
                        }}
                    >

                        <div>
                            <div>거래유형</div>
                            <input
                                readOnly
                                value=""
                                style={{
                                    width: '100%',
                                    height: '36px'
                                }}
                            />
                        </div>

                        <div>
                            <div>보증금</div>
                            <input
                                readOnly
                                value=""
                                style={{
                                    width: '100%',
                                    height: '36px'
                                }}
                            />
                        </div>

                        <div>
                            <div>월 임대금액</div>
                            <input
                                readOnly
                                value=""
                                style={{
                                    width: '100%',
                                    height: '36px'
                                }}
                            />
                        </div>

                    </div>

                </div>

                {/* 계약 정보 */}
                <div
                    style={{
                        border:
                            '1px solid #ddd',

                        padding: '20px',

                        marginBottom: '24px'
                    }}
                >

                    <div
                        style={{
                            fontSize: '15px',

                            fontWeight: '700',

                            marginBottom: '16px'
                        }}
                    >
                        계약 정보
                    </div>

                    <div
                        style={{
                            display: 'grid',

                            gridTemplateColumns:
                                '1fr 1fr',

                            gap: '16px'
                        }}
                    >

                        <div>
                            <div>입주일</div>
                            <input
                                type="date"
                                style={{
                                    width: '100%',
                                    height: '36px'
                                }}
                            />
                        </div>

                        <div>
                            <div>퇴거일</div>
                            <input
                                type="date"
                                style={{
                                    width: '100%',
                                    height: '36px'
                                }}
                            />
                        </div>

                        <div>
                            <div>계약금액</div>
                            <input
                                type="number"
                                style={{
                                    width: '100%',
                                    height: '36px'
                                }}
                            />
                        </div>

                        <div>
                            <div>중도금액</div>
                            <input
                                type="number"
                                style={{
                                    width: '100%',
                                    height: '36px'
                                }}
                            />
                        </div>

                        <div>
                            <div>잔금액</div>
                            <input
                                type="number"
                                style={{
                                    width: '100%',
                                    height: '36px'
                                }}
                            />
                        </div>

                    </div>

                </div>

                {/* 임대인 정보 */}
                <div
                    style={{
                        border:
                            '1px solid #ddd',

                        padding: '20px',

                        marginBottom: '24px'
                    }}
                >

                    <div
                        style={{
                            fontSize: '15px',

                            fontWeight: '700',

                            marginBottom: '16px'
                        }}
                    >
                        임대인 정보
                    </div>

                    <div
                        style={{
                            display: 'grid',

                            gridTemplateColumns:
                                '1fr 1fr',

                            gap: '16px'
                        }}
                    >

                        <div>
                            <div>이름</div>
                            <input
                                type="text"
                                style={{
                                    width: '100%',
                                    height: '36px'
                                }}
                            />
                        </div>

                        <div>
                            <div>전화번호</div>
                            <input
                                type="text"
                                style={{
                                    width: '100%',
                                    height: '36px'
                                }}
                            />
                        </div>

                    </div>

                </div>

                {/* 특약사항 */}
                <div
                    style={{
                        border:
                            '1px solid #ddd',

                        padding: '20px',

                        marginBottom: '24px'
                    }}
                >

                    <div
                        style={{
                            fontSize: '15px',

                            fontWeight: '700',

                            marginBottom: '16px'
                        }}
                    >
                        특약사항
                    </div>

                    <textarea
                        rows={5}

                        style={{
                            width: '100%'
                        }}
                    />

                </div>

                {/* 버튼 */}
                <div
                    style={{
                        display: 'flex',

                        justifyContent:
                            'flex-end',

                        gap: '12px'
                    }}
                >

                    <button
                        onClick={onClose}

                        style={{
                            height: '40px',

                            padding: '0 18px'
                        }}
                    >
                        취소
                    </button>

                    <button
                        style={{
                            height: '40px',

                            padding: '0 18px'
                        }}
                    >
                        계약 등록
                    </button>

                </div>

            </div>

        </div>

    );
}

export default OfflineCtrtModal;