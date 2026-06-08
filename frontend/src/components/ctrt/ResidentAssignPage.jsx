import { useState } from 'react';
import '../../styles/common.css';
import AptSearchSelect
from '../../components/ctrt/AptSearchSelect';
import { assignResident } from '../../util/ctrt/offlineCtrtApi';

const ResidentAssignPage = () => {

    const [selectedInfo, setSelectedInfo] = useState(null);

    const [form, setForm] =
        useState({

            mvinDt: '',
            mvoutDt: '',

            ctrtAmt: '',
            midPayAmt: '',
            balAmt: '',

            rentorNm: '',
            rentorTelno: '',

            agntNm: '',
            agntTelno: '',

            spclStpltnCn: '',

            requiredFiles: {}
        });

    const handleChange = (e) => {

        const {
            name,
            value
        } = e.target;

        setForm(prev => ({

            ...prev,

            [name]: value
        }));
    };

    const handleSubmit = async () => {

        if (!selectedInfo) {
            alert('매물을 선택해주세요.');
            return;
        }

        try {

            const formData = new FormData();

            // 기본 데이터
            formData.append(
                'rentLstgNo',
                selectedInfo.rentInfo.RENT_LSTG_NO
            );

            formData.append(
                'mvinDt',
                form.mvinDt
            );

            formData.append(
                'mvoutDt',
                form.mvoutDt
            );

            formData.append(
                'ctrtAmt',
                form.ctrtAmt
            );

            formData.append(
                'midPayAmt',
                form.midPayAmt
            );

            formData.append(
                'balAmt',
                form.balAmt
            );

            formData.append(
                'dpstAmt',
                selectedInfo.rentInfo.DPST_AMT
            );

            formData.append(
                'mthlyRentAmt',
                selectedInfo.rentInfo.MTHLY_RENT_AMT
            );

            formData.append(
                'rentorNm',
                form.rentorNm
            );

            formData.append(
                'rentorTelno',
                form.rentorTelno
            );

            formData.append(
                'agntNm',
                form.agntNm
            );

            formData.append(
                'agntTelno',
                form.agntTelno
            );

            formData.append(
                'spclStpltnCn',
                form.spclStpltnCn
            );



            // 제출서류 파일들
            Object.entries(form.requiredFiles)
                .forEach(([docType, file]) => {

                    formData.append(
                        'files',
                        file
                    );

                    formData.append(
                        'fileTypes',
                        docType
                    );
                });

            await assignResident(formData);

            alert('입주 배정 완료');

        } catch (err) {

            console.error(err);

            alert('입주 배정 실패');
        }
    };

    const handleFileChange = (e) => {

        setForm(prev => ({

            ...prev,

            attachFile:
                e.target.files?.[0] || null
        }));
    };

    return (

        <div className="content-wrapper">

            {/* 헤더 */}
            <div className="page-header">

                <div>

                    <h2 className="page-title">
                        입주민 배정
                    </h2>

                    <p className="page-subtitle">
                        Resident Assign Management
                    </p>

                </div>

            </div>

            {/* 본문 */}
            <div className="table-wrapper">

                <div
                    style={{
                        padding: '24px'
                    }}
                >

                    {/* 계약 정보 */}
                    <div
                        style={{
                            marginTop: '40px'
                        }}
                    >

                        <div
                            style={{
                                fontSize: '16px',
                                fontWeight: '700',
                                marginBottom: '18px'
                            }}
                        >
                            계약 정보
                        </div>

                        {/* 아파트 선택 */}
                        <AptSearchSelect
                            value={selectedInfo}
                            onChange={setSelectedInfo}
                        />

                        <br />


                        <div
                            style={{
                                display: 'grid',
                                gridTemplateColumns:
                                    '1fr 1fr 1fr',
                                gap: '16px',
                                marginBottom: '20px'
                            }}
                        >

                            {/* 임대유형 */}
                            <div className="form-input-group">

                                <label
                                    style={{
                                        fontSize: '15px'
                                    }}
                                >
                                    임대유형
                                </label>

                                <input
                                    type="text"

                                    value={
                                        selectedInfo
                                            ?.rentInfo
                                            ?.RENT_TYPE_CD === 'JS'

                                            ? '전세'

                                            : '월세'
                                    }

                                    readOnly

                                    style={{
                                        backgroundColor: '#f3f4f6',
                                        color: '#6b7280'
                                    }}
                                />

                            </div>

                            {/* 보증금 */}
                            <div className="form-input-group">

                                <label
                                    style={{
                                        fontSize: '15px'
                                    }}
                                >
                                    보증금
                                </label>

                                <input
                                    type="text"

                                    value={
                                        Number(
                                            selectedInfo
                                                ?.rentInfo
                                                ?.DPST_AMT || 0
                                        ).toLocaleString() + '원'
                                    }

                                    readOnly

                                    style={{
                                        backgroundColor: '#f3f4f6',
                                        color: '#6b7280'
                                    }}
                                />

                            </div>

                            {/* 월세 */}
                            <div className="form-input-group">

                                <label
                                    style={{
                                        fontSize: '15px'
                                    }}
                                >
                                    월세
                                </label>

                                <input
                                    type="text"

                                    value={
                                        selectedInfo
                                            ?.rentInfo
                                            ?.RENT_TYPE_CD === 'PE'

                                            ? Number(
                                                selectedInfo
                                                    ?.rentInfo
                                                    ?.MTHLY_RENT_AMT || 0
                                            ).toLocaleString() + '원'

                                            : '-'
                                    }

                                    readOnly

                                    style={{
                                        backgroundColor: '#f3f4f6',
                                        color: '#6b7280'
                                    }}
                                />


                            </div>

                        </div>
                        <div
                            style={{
                                display: 'grid',
                                gridTemplateColumns:
                                    '1fr 1fr 1fr',
                                gap: '16px'
                            }}
                        >
                            {/* 계약금 */}
                            <div className="form-input-group">

                                <label
                                    style={{
                                        fontSize: '15px'
                                    }}
                                >
                                    계약금
                                </label>

                                <input
                                    type="number"

                                    name="ctrtAmt"

                                    value={form.ctrtAmt}

                                    onChange={handleChange}

                                    placeholder="계약금 입력"
                                />

                            </div>

                            {/* 중도금 */}
                            <div className="form-input-group">

                                <label
                                    style={{
                                        fontSize: '15px'
                                    }}
                                >
                                    중도금
                                </label>

                                <input
                                    type="number"

                                    name="midPayAmt"

                                    value={form.midPayAmt}

                                    onChange={handleChange}

                                    placeholder="중도금 입력"
                                />

                            </div>

                            {/* 잔금 */}
                            <div className="form-input-group">

                                <label
                                    style={{
                                        fontSize: '15px'
                                    }}
                                >
                                    잔금
                                </label>

                                <input
                                    type="number"

                                    name="balAmt"

                                    value={form.balAmt}

                                    onChange={handleChange}

                                    placeholder="잔금 입력"
                                />

                            </div>

                        </div>

                        <br />

                        <div className="form-row-grid">

                            <div className="form-input-group">

                                <label
                                    style={{
                                        fontSize: '15px'
                                    }}
                                >
                                    입주일자
                                </label>

                                <input
                                    type="date"

                                    name="mvinDt"

                                    value={form.mvinDt}

                                    min={
                                        selectedInfo
                                            ?.rentInfo
                                            ?.MVIN_PSBL_DT
                                    }

                                    onChange={handleChange}
                                />

                            </div>

                            <div className="form-input-group">

                                <label
                                    style={{
                                        fontSize: '15px'
                                    }}
                                >
                                    퇴거일자
                                </label>

                                <input
                                    type="date"

                                    name="mvoutDt"

                                    min={form.mvinDt}

                                    value={form.mvoutDt}

                                    onChange={handleChange}
                                />

                            </div>

                        </div>
                    </div>
                    <br />
                    {/* 임대인 정보 */}
                    <div className="form-row-grid">

                        <div className="form-input-group">

                            <label
                                style={{
                                    fontSize: '15px'
                                }}
                            >
                                임대인 이름
                            </label>

                            <input
                                type="text"

                                name="rentorNm"

                                value={form.rentorNm}

                                onChange={handleChange}

                                placeholder="임대인 이름"
                            />

                        </div>

                        <div className="form-input-group">
                            <label
                                style={{
                                    fontSize: '15px'
                                }}
                            >
                                임대인 전화번호
                            </label>

                            <input
                                type="text"

                                name="rentorTelno"

                                value={form.rentorTelno}

                                onChange={handleChange}

                                placeholder="010-0000-0000"
                            />

                        </div>

                    </div>
                    <br />

                    {/* 대리인 정보 */}
                    <div className="form-row-grid">

                        <div className="form-input-group">

                            <label
                                style={{
                                    fontSize: '15px'
                                }}
                            >
                                대리인 이름
                            </label>

                            <input
                                type="text"

                                name="agntNm"

                                value={form.agntNm}

                                onChange={handleChange}

                                placeholder="대리인 이름"
                            />

                        </div>

                        <div className="form-input-group">

                            <label
                                style={{
                                    fontSize: '15px'
                                }}
                            >
                                대리인 전화번호
                            </label>

                            <input
                                type="text"

                                name="agntTelno"

                                value={form.agntTelno}

                                onChange={handleChange}

                                placeholder="010-0000-0000"
                            />

                        </div>

                    </div>
                    <br />
                    {/* 특약사항 */}
                    <div className="form-input-group">

                        <label
                            style={{
                                fontSize: '15px'
                            }}
                        >
                            특약사항
                        </label>

                        <textarea
                            name="spclStpltnCn"

                            value={form.spclStpltnCn}

                            onChange={handleChange}

                            placeholder="특약사항 입력"

                            rows={5}

                            style={{
                                width: '100%',
                                minHeight: '140px',
                                padding: '14px',
                                borderRadius: '10px',
                                border:
                                    '1px solid #d1d5db',
                                background:
                                    '#f9fafb',
                                fontSize: '15px',
                                resize: 'none',
                                outline: 'none',
                                boxSizing: 'border-box'
                            }}
                        />

                    </div>

                    {/* 첨부파일 */}
                    {/* 제출서류 첨부 */}
                    <div
                        style={{
                            marginTop: '40px'
                        }}
                    >

                        <div
                            className="form-label"
                            style={{
                                marginBottom: '14px'
                            }}
                        >
                            제출서류
                        </div>

                        <div
                            style={{
                                display: 'grid',
                                gap: '16px'
                            }}
                        >

                            {
                                selectedInfo
                                    ?.requiredDocs
                                    ?.map((doc, idx) => (

                                        <div
                                            key={idx}

                                            style={{

                                                display: 'grid',
                                                gridTemplateColumns:
                                                    '220px 1fr',
                                                gap: '16px',
                                                alignItems: 'center',
                                                border:
                                                    '1px solid #d1d5db',
                                                borderRadius:
                                                    '10px',
                                                padding:
                                                    '14px 16px',
                                                background:
                                                    '#ffffff'
                                            }}
                                        >

                                            <div
                                                style={{
                                                    fontSize: '14px',
                                                    fontWeight: '600',
                                                    color: '#111827'
                                                }}
                                            >
                                                {
                                                    {
                                                        ID: '신분증',
                                                        FAMILY: '가족관계서류',
                                                        RESIDENCE: '주민등록서류',
                                                        CONTRACT: '계약서류',
                                                        INCOME: '소득증빙서류',
                                                        EMPLOY: '재직증명서'
                                                    }[
                                                    doc.SBMSN_DOC_TY_CD
                                                    ]
                                                }
                                            </div>

                                            <div
                                                style={{
                                                    display: 'flex',
                                                    alignItems: 'center'
                                                }}
                                            >

                                                <input
                                                    type="file"

                                                    onChange={(e) => {

                                                        const file =
                                                            e.target.files?.[0];

                                                        setForm(prev => ({

                                                            ...prev,

                                                            requiredFiles: {

                                                                ...prev.requiredFiles,

                                                                [
                                                                    doc.SBMSN_DOC_TY_CD
                                                                ]: file
                                                            }
                                                        }));
                                                    }}
                                                />

                                            </div>

                                        </div>

                                    ))
                            }

                        </div>

                    </div>


                    {/* 버튼 */}
                    <div
                        style={{
                            display: 'flex',
                            justifyContent: 'flex-end',
                            gap: '12px',
                            marginTop: '40px'
                        }}
                    >

                        <button
                            className="btn-secondary"
                        >
                            취소
                        </button>

                        <button
                            className="btn-primary"
                            onClick={handleSubmit}
                        >
                            입주 배정
                        </button>

                    </div>

                </div>

            </div>

        </div >
    );
};

export default ResidentAssignPage;