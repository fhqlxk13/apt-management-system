import React from 'react';
import { X, FileText, User, ClipboardList, MapPin, Calendar } from 'lucide-react';

const ApplicantDetailModal = ({ isOpen, data, onClose }) => {
    if (!isOpen || !data) return null;


    return (
        <div className="mngr-modal-overlay">
            <div className="mngr-modal mngr-detail-modal">
                {/* 헤더 */}
                <div className="mngr-modal-header">
                    <div>
                        <h3>신청 상세 정보</h3>
                        <p>신청 번호: {data.aplctNo}</p>
                    </div>
                    <button onClick={onClose} className="mngr-modal-close">
                        <X size={20} />
                    </button>
                </div>

                {/* 본문 그리드 */}
                <div className="mngr-detail-grid">
                    <div className="mngr-detail-block">
                        <span className="mngr-detail-label"><User size={12} /> 사용자 ID</span>
                        <div className="mngr-detail-value">{data.userId}</div>
                    </div>
                    <div className="mngr-detail-block">
                        <span className="mngr-detail-label"><User size={12} /> 이름</span>
                        <div className="mngr-detail-value">{data.userNm}</div>
                    </div>
                    <div className="mngr-detail-block">
                        <span className="mngr-detail-label"><ClipboardList size={12} /> 공고명</span>
                        <div className="mngr-detail-value">{data.ttl}</div>
                    </div>
                    <div className="mngr-detail-block">
                        <span className="mngr-detail-label"><MapPin size={12} /> 단지 번호</span>
                        <div className="mngr-detail-value">{data.aptCmplexNo}</div>
                    </div>
                    <div className="mngr-detail-block" style={{ gridColumn: 'span 2' }}>
                        <span className="mngr-detail-label"><FileText size={12} /> 타입 / 면적</span>
                        <div className="mngr-detail-value">{data.tyNm} / {data.exclusiveSize}㎡</div>
                    </div>
                </div>

                {/* 첨부 파일 섹션 */}
                <div style={{ padding: '0 20px 20px 20px' }}>
                    <div className="mngr-detail-label" style={{ marginBottom: '10px' }}>첨부 파일 리스트</div>
                    <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
                        {data.docList.map((doc, index) => {
                            const formattedDate = doc.mdfcnDt || doc.regDt ? new Date(doc.mdfcnDt || doc.regDt).toLocaleDateString('sv-SE') : "미등록";
                            return (
                                <a 
                                    key={index}
                                    href={`/file/download/${doc.fileInfo?.googleId}`} 
                                    className="action-card" 
                                    style={{ padding: '12px', textDecoration: 'none' }}
                                >
                                    <div style={{ fontSize: '20px' }}><FileText color="var(--primary)" /></div>
                                    <div style={{ flex: 1 }}>
                                        <div style={{ fontSize: '14px', fontWeight: '600', color: 'var(--primary-container)' }}>{doc.fileInfo?.fileOgName}</div>
                                        <div className="sub-info">
                                            {doc.sbmsnDocTyCd} | {doc.mdfcnDt ? '수정일' : '등록일'}: {formattedDate}
                                        </div>
                                    </div>
                                </a>
                            );
                        })}
                    </div>
                </div>

                {/* 푸터 */}
                <div className="mngr-modal-footer">
                    <button onClick={onClose} className="btn-outline">닫기</button>
                </div>
            </div>
        </div>
    );
};

export default ApplicantDetailModal;