import { useState } from 'react';
import { registerRentListing } from '../../../util/api/sales/salesApi';

function RentRegisterModal({

    open,

    onClose,
    onSuccess,

    selectedRooms,

    selectedAptNm,

    selectedDongNm

}) {

    if (!open) return null;

    const [form, setForm] =
        useState({
            rentTtl: ''
            , rentTypeCd: 'JS'
            , dpstAmt: ''
            , mthlyRentAmt: ''
            , rentLstgCn: ''
            , dealSttsCd: 'AVL'
            , mvinPsblDt: ''
            , docTyCdList: []

        });

    const handleChange = (e) => {

        const { name, value } = e.target;

        setForm(prev => ({

            ...prev,

            [name]: value

        }));
    };

    const docTypeList = [

        {
            code: 'ID',
            label: '신분증'
        },

        {
            code: 'RESIDENCE',
            label: '주민등록등본'
        },

        {
            code: 'FAMILY',
            label: '가족관계증명서'
        },

        {
            code: 'INCOME',
            label: '소득증빙서류'
        },

        {
            code: 'EMPLOY',
            label: '재직증명서'
        }
    ];

    const handleSubmit =
        async () => {

            try {

                if (!form.rentTtl) {

                    alert(
                        '매물 제목을 입력해주세요.'
                    );

                    return;
                }

                if (!form.dpstAmt) {

                    alert(
                        '보증금을 입력해주세요.'
                    );

                    return;
                }

                if (
                    form.rentTypeCd ===
                    'PE' &&
                    !form.mthlyRentAmt
                ) {

                    alert(
                        '월 임대금액을 입력해주세요.'
                    );

                    return;
                }

                const payload = {

                    hoNos:
                        selectedRooms.map(
                            item => item.hoNo
                        ),

                    rentTtl:
                        form.rentTtl,

                    rentTypeCd:
                        form.rentTypeCd,

                    dpstAmt:
                        form.dpstAmt,

                    mthlyRentAmt:
                        form.mthlyRentAmt,

                    rentLstgCn:
                        form.rentLstgCn,

                    rcrtLstgSttsCd:
                        'GENERAL',

                    docTyCdList:
                        form.docTyCdList
                };

                await registerRentListing(payload);

                alert(
                    '매물이 등록되었습니다.'
                );

                onSuccess?.();

                onClose();

            } catch (err) {

                console.error(err);

                alert(
                    '매물 등록 중 오류가 발생했습니다.'
                );

            }
        };

    const handleDocToggle = (
        code
    ) => {

        const exists =
            form.docTyCdList.includes(
                code
            );

        if (exists) {

            setForm(prev => ({

                ...prev,

                docTyCdList:
                    prev.docTyCdList.filter(
                        item => item !== code
                    )

            }));

        } else {

            setForm(prev => ({

                ...prev,

                docTyCdList: [

                    ...prev.docTyCdList,

                    code

                ]

            }));
        }
    };


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
                    width: '520px',

                    background: '#fff',

                    borderRadius: '16px',

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

                        marginBottom: '20px'
                    }}
                >

                    <div>
                        <div
                            style={{
                                fontSize: '18px',

                                fontWeight: '700'
                            }}
                        >
                            매물 등록
                        </div>

                        <div
                            style={{
                                marginTop: '4px',

                                fontSize: '13px',

                                color: '#64748b'
                            }}
                        >
                            {selectedAptNm}
                            {' '}
                            {selectedDongNm}
                        </div>
                    </div>

                    <button
                        onClick={onClose}

                        style={{
                            border: 'none',

                            background: 'none',

                            cursor: 'pointer',

                            fontSize: '18px'
                        }}
                    >
                        ✕
                    </button>

                </div>

                {/* 선택 호 */}
                <div
                    style={{
                        marginBottom: '20px'
                    }}
                >

                    {/* 제목 */}
                    <div
                        style={{
                            fontSize: '13px',

                            fontWeight: '600',

                            marginBottom: '8px',

                            display: 'flex',

                            alignItems: 'center',

                            gap: '6px'
                        }}
                    >
                        선택 호

                        <span
                            style={{
                                color: '#2563eb'
                            }}
                        >
                            총 {selectedRooms.length}개
                        </span>

                    </div>

                    {/* 목록 */}
                    <div
                        style={{
                            display: 'flex',

                            flexWrap: 'wrap',

                            gap: '6px'
                        }}
                    >

                        {selectedRooms
                            .slice(0, 5)
                            .map((room) => (

                                <div
                                    key={room.hoNo}

                                    style={{
                                        padding: '6px 10px',

                                        borderRadius:
                                            '999px',

                                        background:
                                            '#eff6ff',

                                        color:
                                            '#2563eb',

                                        fontSize: '12px',

                                        fontWeight: '600'
                                    }}
                                >
                                    {room.ho}호
                                </div>

                            ))}

                        {selectedRooms.length > 5 && (

                            <div
                                style={{
                                    padding: '6px 10px',

                                    borderRadius:
                                        '999px',

                                    background:
                                        '#f1f5f9',

                                    color:
                                        '#64748b',

                                    fontSize: '12px',

                                    fontWeight: '600'
                                }}
                            >
                                +{selectedRooms.length - 5}개
                            </div>

                        )}

                    </div>

                </div>


                <div
                    style={{
                        marginBottom: '16px'
                    }}
                >

                    <div
                        style={{
                            fontSize: '13px',

                            fontWeight: '600',

                            marginBottom: '8px'
                        }}
                    >
                        매물 제목
                    </div>

                    <input
                        type="text"

                        name="rentTtl"

                        value={form.rentTtl}

                        onChange={handleChange}

                        placeholder="매물 제목 입력"

                        style={{
                            width: '100%',

                            height: '42px',

                            border:
                                '1px solid #d1d5db',

                            borderRadius: '8px',

                            padding: '0 14px',

                            fontSize: '14px'
                        }}
                    />

                </div>

                <div
                    style={{
                        display: 'grid',

                        gridTemplateColumns:
                            '120px 1fr 1fr',

                        gap: '12px',

                        marginBottom: '16px'
                    }}
                >

                    {/* 유형 */}
                    <div>

                        <div
                            style={{
                                fontSize: '13px',

                                fontWeight: '600',

                                marginBottom: '8px'
                            }}
                        >
                            유형
                        </div>

                        <select
                            name="rentTypeCd"

                            value={form.rentTypeCd}

                            onChange={handleChange}

                            style={{
                                width: '100%',

                                height: '42px',

                                border:
                                    '1px solid #d1d5db',

                                borderRadius: '8px',

                                padding: '0 12px'
                            }}
                        >

                            <option value="JS">
                                전세
                            </option>

                            <option value="PE">
                                월세
                            </option>

                        </select>

                    </div>

                    {/* 보증금 */}
                    <div>

                        <div
                            style={{
                                fontSize: '13px',

                                fontWeight: '600',

                                marginBottom: '8px'
                            }}
                        >
                            보증금
                        </div>

                        <input
                            type="number"

                            min={0}

                            step={10000}

                            onKeyDown={(e) => {

                                if (
                                    e.key === '-' ||
                                    e.key === 'e'
                                ) {

                                    e.preventDefault();
                                }
                            }}

                            onChange={(e) => {

                                const value =
                                    e.target.value;

                                handleChange({
                                    target: {
                                        name: 'dpstAmt',

                                        value:
                                            value === ''
                                                ? ''
                                                : Math.max(
                                                    0,
                                                    Number(value)
                                                )
                                    }
                                });
                            }}

                            name="dpstAmt"

                            value={form.dpstAmt}

                            placeholder="보증금 입력"

                            style={{
                                width: '100%',

                                height: '42px',

                                border:
                                    '1px solid #d1d5db',

                                borderRadius: '8px',

                                padding: '0 14px',

                                fontSize: '14px'
                            }}
                        />

                    </div>

                    <div>

                        <div
                            style={{
                                fontSize: '13px',

                                fontWeight: '600',

                                marginBottom: '8px'
                            }}
                        >
                            월 임대금액
                        </div>

                        <input
                            type="number"

                            min={0}

                            step={10000}

                            name="mthlyRentAmt"

                            value={form.mthlyRentAmt}

                            onKeyDown={(e) => {

                                if (
                                    e.key === '-' ||
                                    e.key === 'e'
                                ) {

                                    e.preventDefault();
                                }
                            }}
                            onChange={(e) => {

                                const value =
                                    e.target.value;

                                handleChange({
                                    target: {
                                        name: 'mthlyRentAmt',

                                        value:
                                            value === ''
                                                ? ''
                                                : Math.max(
                                                    0,
                                                    Number(value)
                                                )
                                    }
                                });
                            }}

                            disabled={
                                form.rentTypeCd !==
                                'PE'
                            }

                            placeholder="월 임대금액"

                            style={{
                                width: '100%',

                                height: '42px',

                                border:
                                    '1px solid #d1d5db',

                                borderRadius: '8px',

                                padding: '0 14px',

                                background:
                                    form.rentTypeCd !==
                                        'PE'
                                        ? '#f8fafc'
                                        : '#fff',

                                color:
                                    form.rentTypeCd !==
                                        'PE'
                                        ? '#94a3b8'
                                        : '#111827'
                            }}
                        />

                    </div>

                </div>

                <div
                    style={{
                        marginBottom: '20px'
                    }}
                >

                    <div
                        style={{
                            fontSize: '13px',

                            fontWeight: '600',

                            marginBottom: '8px'
                        }}
                    >
                        임대 매물 내용
                    </div>

                    <textarea
                        name="rentLstgCn"

                        value={form.rentLstgCn}

                        onChange={handleChange}

                        placeholder="임대 매물 내용을 입력해주세요."

                        rows={5}

                        style={{
                            width: '100%',

                            border:
                                '1px solid #d1d5db',

                            borderRadius: '8px',

                            padding: '12px 14px',

                            fontSize: '14px',

                            resize: 'none'
                        }}
                    />

                </div>

                <div
                    style={{
                        marginBottom: '24px'
                    }}
                >

                    <div
                        style={{
                            fontSize: '13px',

                            fontWeight: '600',

                            marginBottom: '10px'
                        }}
                    >
                        필수 제출 서류
                    </div>

                    <div
                        style={{
                            display: 'flex',

                            flexWrap: 'wrap',

                            gap: '10px'
                        }}
                    >

                        {docTypeList.map(
                            (doc) => {

                                const checked =
                                    form.docTyCdList.includes(
                                        doc.code
                                    );

                                return (

                                    <label
                                        key={doc.code}

                                        style={{
                                            display: 'flex',

                                            alignItems: 'center',

                                            gap: '6px',

                                            padding:
                                                '8px 12px',

                                            borderRadius:
                                                '10px',

                                            border:
                                                checked
                                                    ? '1px solid #2563eb'
                                                    : '1px solid #d1d5db',

                                            background:
                                                checked
                                                    ? '#eff6ff'
                                                    : '#fff',

                                            cursor: 'pointer'
                                        }}
                                    >

                                        <input
                                            type="checkbox"

                                            checked={checked}

                                            onChange={() =>
                                                handleDocToggle(
                                                    doc.code
                                                )
                                            }
                                        />

                                        {doc.label}

                                    </label>

                                );
                            }
                        )}

                    </div>

                </div>


                <div
                    style={{
                        display: 'flex',

                        justifyContent: 'flex-end',

                        gap: '10px'
                    }}
                >

                    <button
                        onClick={onClose}

                        style={{
                            height: '40px',

                            padding: '0 16px',

                            border:
                                '1px solid #d1d5db',

                            borderRadius: '8px',

                            background: '#fff',

                            cursor: 'pointer'
                        }}
                    >
                        취소
                    </button>

                    <button
                        onClick={handleSubmit}

                        style={{
                            height: '40px',

                            padding: '0 18px',

                            border: 'none',

                            borderRadius: '8px',

                            background: '#2563eb',

                            color: '#fff',

                            fontWeight: '600',

                            cursor: 'pointer'
                        }}
                    >
                        등록
                    </button>

                </div>
            </div>

        </div>

    );
}

export default RentRegisterModal;