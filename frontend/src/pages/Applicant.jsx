import React, { useEffect, useMemo, useState } from 'react'
import { AgGridReact } from 'ag-grid-react';
import { useOutletContext } from 'react-router-dom';
import { Check, Triangle, X } from 'lucide-react';
import requestApi, { getCookie } from '../util/api/requestApi';
import ApplicantDetailModal from './ApplicantDetailModal';
import Swal from 'sweetalert2';
import axios from 'axios';
import '../styles/ag-grid.css'

const Applicant = () => {
    const { admInfo } = useOutletContext();
    const [rowData, setRowData] = useState([]);

    useEffect(() => {
        const fetchApplicants = async () => {
            try {

                const response = await requestApi.get('/api/react/adm/aplct');

                if (Array.isArray(response.data)) {
                    setRowData(response.data);
                } else {
                    console.error("서버 응답이 배열 형식이 아닙니다:", response.data);
                    setRowData([]);
                }
            } catch (error) {
                console.error("데이터 로드 실패 : ", error);
                setRowData([]);
            }
        };
        fetchApplicants();
    }, []);

    const columnDefs = useMemo(() => [
        { field: 'aplctNo', headerName: '신청 번호', flex: 1.1 },
        { field: 'userId', headerName: '회원ID', width: 170, flex: 1 },
        { field: 'userNm', headerName: '이름', width: 150, flex: 0.8 },
        { field: 'annNo', headerName: '공고 번호', width: 130, flex: 0.8 },
        { field: 'ttl', headerName: '공고 명', flex: 1 },
        { field: 'aptCmplexNo', headerName: '단지코드', width: 150 },
        { field: 'tyNm', headerName: '호 타입', width: 105 },
        { field: 'exclusiveSize', headerName: '전용 면적(㎡)', width: 130 },
        {
            field: 'docList', headerName: '제출 서류'
            , cellRenderer: (p) => {
                const docs = p.data.docList;
                if (!docs || docs.length === 0 || !docs[0].sbmsnDocNo) return <span className="text-gray-400">없음</span>;

                return (
                    <span>
                        <button className='btn-confirm' onClick={() => openDetailModal(p)}>
                            확인
                        </button>
                    </span>
                );
            }
            , filter: false
            , width: 110
        },
        {
            field: 'aplctSttsCd', headerName: '상태',
            valueFormatter: (p) => {
                if (p.value === 'SUBMIT') return '임대 신청';
                if (p.value === 'WINNER') return '서류 제출 대기';
                if (p.value === 'INSPECTION') return '서류 검토 필요';
                if (p.value === 'LOSER') return '반려';
                if (p.value === 'CANCEL') return '취소';
                if (p.value === 'SUPPLEMENT') return '서류 보완 요청';
                if (p.value === 'QUALIFIED') return '승인';
                return p.value;
            },
            // 필터가 작동할 때 참조할 값을 정의 (화면에 보이는 값 기준)
            filterValueGetter: (p) => {
                if (p.data.aplctSttsCd === 'SUBMIT') return '임대 신청';
                if (p.data.aplctSttsCd === 'WINNER') return '서류 제출 대기';
                if (p.data.aplctSttsCd === 'INSPECTION') return '서류 검토 필요';
                if (p.data.aplctSttsCd === 'LOSER') return '반려';
                if (p.data.aplctSttsCd === 'CANCEL') return '취소';
                if (p.data.aplctSttsCd === 'SUPPLEMENT') return '서류 보완 필요';
                if (p.data.aplctSttsCd === 'QUALIFIED') return '승인';
                return p.data.aplctSttsCd;
            },
            cellRenderer: (p) => {
                if (p.value === 'SUBMIT') return <span className="stts-apply">임대 신청</span>;
                if (p.value === 'WINNER') return <span className="stts-apply">서류 제출 대기</span>;
                if (p.value === 'INSPECTION') return <span className="stts">서류 검토 필요</span>;
                if (p.value === 'LOSER') return <span className="stts-reject">반려</span>;
                if (p.value === 'CANCEL') return <span className="stts-reject">취소</span>;
                if (p.value === 'SUPPLEMENT') return <span className="stts-apply">서류 보완 요청</span>;
                if (p.value === 'QUALIFIED') return <span className="stts-pass">승인</span>;
                return <span>{p.value}</span>; // 기본값
            },
            width: 140
        },
        {
            field: 'aplctSttsCd', headerName: '관리',
            cellRenderer: (p) => {
                if (p.value === 'SUBMIT') {
                    return (
                        <div>
                            <button title='승인' className='btn-pass' onClick={(e) => { e.stopPropagation(); updStts(p, true) }}>
                                <Check className='check' style={{ marginTop: '0px', padding: '0px' }} size={24} />
                            </button>
                            &nbsp;&nbsp;
                            <button title='반려' className='btn-reject' onClick={(e) => { e.stopPropagation(); updStts(p, false) }}>
                                <X className='reject' style={{ marginTop: '0px', padding: '0px' }} size={24} />
                            </button>
                        </div>
                    )
                } else if (p.value === 'WINNER') {
                    return (
                        <div>
                            <button title='반려' className='btn-reject' onClick={(e) => { e.stopPropagation(); updStts(p, false) }}>
                                <X className='reject' style={{ marginTop: '0px', padding: '0px' }} size={24} />
                            </button>
                        </div>
                    )
                } else if (p.value === 'SUPPLEMENT'
                    || p.value === 'INSPECTION') {
                    return (
                        <div>
                            <button title='승인' className='btn-pass' onClick={(e) => { e.stopPropagation(); updStts(p, true) }}>
                                <Check className='check' style={{ marginTop: '0px', padding: '0px' }} size={24} />
                            </button>
                            &nbsp;&nbsp;
                            <button title='보완' className='btn-supplement' onClick={(e) => { e.stopPropagation(); supplement(p) }}>
                                <Triangle className='supplement' style={{ marginTop: '0px', padding: '0px' }} size={24} />
                            </button>
                            &nbsp;&nbsp;
                            <button title='반려' className='btn-reject' onClick={(e) => { e.stopPropagation(); updStts(p, false) }}>
                                <X className='reject' style={{ marginTop: '0px', padding: '0px' }} size={24} />
                            </button>
                        </div>
                    )
                }
            },
            filter: false,
            width: 120
        },
    ], []);

    const rowSelection = useMemo(() => ({       // 행 옵션
        mode: 'multiRow',               // 여러 행 선택
        headerCheckbox: true,           // 맨 앞에 체크박스
        checkboxes: true                // 체크박스 표시
    }), []);

    const defaultColDef = useMemo(() => ({      // 
        sortable: true,
        filter: true,           // 일반 필터 활성화
        floatingFilter: false,   // 상단 입력창 필터 비활성화 
        resizable: true
    }), []);

    // isApproval => true or false
    // 승인 거절
    const updStts = async (p, isApproval) => {
        const ag = p.api;
        const selectedNodes = ag.getSelectedNodes();
        const actionNm = isApproval ? '승인' : '반려';

        let aplctMapList = [];
        let confirmMsg = "";

        // 현재 클릭한 행이 선택된 행들 중에 포함되어 있는지 확인
        const isCurrentNodeSelected = selectedNodes.some(node => node.data.aplctNo === p.data.aplctNo);

        if (selectedNodes && selectedNodes.length > 1 && isCurrentNodeSelected) {
            // 상태 변경 버튼이 활성화된한 아이들만 필터
            const validNodes = selectedNodes.filter(node => {
                return isApproval ? ['SUBMIT', 'SUPPLEMENT', 'INSPECTION'].includes(node.data.aplctSttsCd)
                    : ['SUBMIT', 'WINNER', 'SUPPLEMENT', 'INSPECTION'].includes(node.data.aplctSttsCd)
            });

            aplctMapList = validNodes.map(node => {
                const currentStts = node.data.aplctSttsCd;
                let nextStts;
                if (currentStts === 'SUBMIT') {
                    nextStts = isApproval ? 'WINNER' : 'LOSER';
                } else if (currentStts === 'WINNER' && !isApproval) {
                    nextStts = 'LOSER';
                } else if (currentStts === 'WINNER' && isApproval) {    // 위 필터에서 거르지만 방어코드
                    return false;
                } else if (currentStts === 'SUPPLEMENT') {
                    nextStts = isApproval ? 'QUALIFIED' : 'LOSER';
                } else if (currentStts === 'INSPECTION') {
                    nextStts = isApproval ? 'QUALIFIED' : 'LOSER';
                }

                return {
                    aplctNo: node.data.aplctNo,
                    aplctSttsCd: nextStts
                };
            });

            if (aplctMapList.length === 0) {
                alert("선택된 항목 중 처리 가능한 '대기'건이 없습니다.");
                return;
            }
            confirmMsg = `현재 선택된 ${selectedNodes.length}개의 목록 중 ${actionNm} 가능 건이 ${aplctMapList.length}개 있습니다. \n일괄 ${actionNm} 처리하시겠습니까?`;
        } else {
            // 선택된 행이 없거나 1개만 선택된 경우 (단일 처리)
            const currentStts = p.data.aplctSttsCd;
            if (['SUBMIT', 'WINNER', 'SUPPLEMENT', 'INSPECTION'].includes(currentStts)) {
                let nextStts;
                if (currentStts === 'SUBMIT') {
                    nextStts = isApproval ? 'WINNER' : 'LOSER';
                } else if (currentStts === 'WINNER' && !isApproval) {
                    nextStts = 'LOSER';
                } else if (currentStts === 'WINNER' && isApproval) {    // 위 조건식에서 거르지만 방어코드
                    return false;
                } else if (currentStts === 'SUPPLEMENT') {
                    nextStts = isApproval ? 'QUALIFIED' : 'LOSER';
                } else if (currentStts === 'INSPECTION') {
                    nextStts = isApproval ? 'QUALIFIED' : 'LOSER';
                }
                aplctMapList.push({
                    aplctNo: p.data.aplctNo,
                    aplctSttsCd: nextStts
                });
                confirmMsg = `신청번호 ${p.data.aplctNo} 항목을 ${actionNm}하시겠습니까?`;
            } else {
                alert(`${actionNm}요청 처리를 가능한 상태가 아닙니다.`);
                return;
            }
        }

        if (!window.confirm(confirmMsg)) return;

        updSttsRequest(aplctMapList, ag);
    };

    // 보완 요청 버튼 기능
    const supplement = async (p) => {

        const ag = p.api;
        const selectedNodes = ag.getSelectedNodes();
        const actionNm = '보완';

        let aplctMapList = [];
        let confirmMsg = "";

        // 현재 클릭한 행이 선택된 행들 중에 포함되어 있는지 확인
        const isCurrentNodeSelected = selectedNodes.some(node => node.data.aplctNo === p.data.aplctNo);

        if (selectedNodes && selectedNodes.length > 1 && isCurrentNodeSelected) {

            // 상태 변경 버튼이 활성화된한 아이들만 필터
            const validNodes = selectedNodes.filter(node => ['SUPPLEMENT', 'INSPECTION'].includes(node.data.aplctSttsCd));

            aplctMapList = validNodes.map(node => {
                const currentStts = node.data.aplctSttsCd;
                const nextStts = 'SUPPLEMENT';

                return {
                    aplctNo: node.data.aplctNo,
                    aplctSttsCd: nextStts
                };
            });

            if (aplctMapList.length === 0) {
                alert("선택된 항목 중 처리 가능한 '대기'건이 없습니다.");
                return;
            }
            confirmMsg = `현재 선택된 ${selectedNodes.length}개의 목록 중 ${aplctMapList.length}개 서류 보완 요청 처리가능합니다. \n일괄 ${actionNm} 처리하시겠습니까?`;
        } else {
            // 선택된 행이 없거나 1개만 선택된 경우 (단일 처리)
            const currentStts = p.data.aplctSttsCd;
            if (['SUPPLEMENT', 'INSPECTION'].includes(currentStts)) {
                const nextStts = 'SUPPLEMENT';

                aplctMapList.push({
                    aplctNo: p.data.aplctNo,
                    aplctSttsCd: nextStts
                });
                confirmMsg = `신청번호 ${p.data.aplctNo} 항목을 ${actionNm}요청 처리 하시겠습니까?`;
            } else {
                alert(`${actionNm} 가능한 상태가 아닙니다.`);
                return;
            }
        }

        if (!window.confirm(confirmMsg)) return;

        const reason = window.prompt(`${actionNm} 사유를 입력해주세요.`);

        if (reason === null) return;
        if (reason.trim() === "") {
            alert("사유를 입력해야 처리가 가능합니다.");
            return;
        }

        const finalMapList = aplctMapList.map(item => ({
            ...item,
            rjctRsnCn: reason // VO에 추가하신 변수명으로 매칭하세요!
        }));

        updSttsRequest(finalMapList, ag);
    }

    // 백엔드 업데이트 요청
    const updSttsRequest = async (aplctMapList, agApi) => {
        if (!aplctMapList || aplctMapList.length === 0) return;

        try {
            const response = await requestApi.put(`/api/react/adm/aplct/upd`, {
                aplctMapList: aplctMapList
            });

            if (response.status === 200) {
                Swal.fire({
                    icon: 'success'
                    , title: '승인'
                    , text: `${aplctMapList.length}건의 처리가 완료되었습니다.`
                    , confirmButtonText: '확인'
                })

                const updateMap = new Map(aplctMapList.map(obj => [obj.aplctNo, obj.aplctSttsCd]));

                setRowData(prevData =>
                    prevData.map(item =>
                        updateMap.has(item.aplctNo)
                            ? { ...item, aplctSttsCd: updateMap.get(item.aplctNo) }
                            : item
                    )
                );

                if (agApi && typeof agApi.deselectAll === 'function') {
                    agApi.deselectAll();
                }
            }
        } catch (error) {
            console.log(error);

            // 백엔드에서 보낸 에러메시지(매물이 없을 때 보낸 매세지)
            if(error.response && error.response.data){
                const errMsg = typeof error.response.data === 'string'
                            ? error.response.data
                            : error.response.data.message || "처리 중 오류가 발생했습니다";
                alert(errMsg);
            }else alert("처리 중 오류가 발생했습니다.");
        }
    };

    const [isModalOpen, setIsModalOpen] = useState(false);
    const [selectedApplicant, setSelectedApplicant] = useState(null);

    // 클릭 시 모달 열기 함수
    const openDetailModal = (params) => {

        if (!params.event) {
            // rowSelection이나 DeselectAll 등으로 호출된 경우
            return;
        }

        const e = params.event;

        if (e.target.closest('.btn-confirm')) {
            setSelectedApplicant(params.data);
            setIsModalOpen(true);
            return; // 처리 완료 후 종료
        }

        if (
            e.target.closest('button')
            || e.target.closest('svg')
        ) {
            return;
        }

        setSelectedApplicant(params.data);
        setIsModalOpen(true);
    };

    return (
        <div style={{ width: '100%', height: '100%' }}>
            <div style={{ marginBottom: '15px' }}>
                <h2 style={{ fontSize: '20px', fontWeight: '700' }}>임대 모집 신청 현황</h2>
            </div>

            {/* AG Grid 테마 적용 영역 */}
            <div className="ag-theme-alpine" style={{ height: 'calc(100vh - 100px)', width: '100%' }}>
                <AgGridReact
                    theme="legacy"
                    rowData={rowData}
                    columnDefs={columnDefs}
                    defaultColDef={defaultColDef}
                    rowSelection={rowSelection}
                    onRowClicked={openDetailModal}
                    pagination={true}
                    paginationPageSize={17}
                    paginationPageSizeSelector={[17, 30, 50]}
                />
            </div>
            {/* 2. 모달 컴포넌트 배치 */}
            <ApplicantDetailModal
                isOpen={isModalOpen}
                data={selectedApplicant}
                onClose={() => {
                    setIsModalOpen(false);
                    setSelectedApplicant(null);
                }}
            />
        </div>
    );
};

export default Applicant