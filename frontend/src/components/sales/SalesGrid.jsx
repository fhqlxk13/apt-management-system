import { useEffect, useMemo, useState } from 'react';

import { AgGridReact } from 'ag-grid-react';

import { ModuleRegistry, AllCommunityModule } from 'ag-grid-community';

import 'ag-grid-community/styles/ag-grid.css';
import 'ag-grid-community/styles/ag-theme-alpine.css';

import { deleteRentListing, getHoList } from '../../util/api/sales/salesApi';
import RentRegisterModal from './modal/RentRegisterModal';

ModuleRegistry.registerModules([
    AllCommunityModule
]);

function SalesGrid({
    aptCmplexNo
    , selectedAptNm
    , selectedDongNm
    , selectedRooms
    , setSelectedRooms
    , hoList
    , setHoList
}) {

    const [rowData, setRowData] = useState([]);
    const [showModal, setShowModal] = useState(false);
    const [gridApi, setGridApi] = useState(null);

    const fetchHoList = async () => {

        if (!aptCmplexNo || !selectedDongNm) {
            setRowData([]);
            return;
        }

        try {
            const data = await getHoList(aptCmplexNo, selectedDongNm);
            setRowData(data);
            setHoList(data);
        } catch (err) {
            console.error(err);
        }
    };

    /* 호 목록 조회 */
    useEffect(() => {

        fetchHoList();

    }, [
        aptCmplexNo,
        selectedDongNm
    ]);

    const handleDelete = async () => {

        const confirmDelete =
            window.confirm(
                '선택한 호의 매물을 삭제하시겠습니까?'
            );

        if (!confirmDelete) return;

        try {

            await deleteRentListing(

                selectedRooms.map(
                    item => item.hoNo
                )
            );

            alert(
                '선택한 매물등록이 취소되었습니다.'
            );

            fetchHoList();

            setSelectedRooms([]);

        } catch (err) {

            console.error(err);

            alert(
                '매물 등록 취소 중 오류가 발생했습니다.'
            );
        }
    };


    /* 상태 한글화 */
    const statusMap = {

        EMPTY: '공실',

        LIVE: '거주중',

        DISABLED: '비활성'

    };

    /* 컬럼 */
    const columnDefs = useMemo(() => [

        {
            headerCheckboxSelection: false,

            checkboxSelection: (params) =>
                params.data?.hoSttsCd !== 'DISABLED',

            width: 55,

            pinned: 'left'
        },
        {
            field: 'ho',

            headerName: '호',

            filter: 'agTextColumnFilter',

            width: 90,
            cellStyle: {
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center'
            },

            sort: 'asc',

            comparator: (a, b) => {

                return Number(a) - Number(b);

            }
        },
        {
            field: 'floor',

            headerName: '층',

            filter: 'agNumberColumnFilter',

            width: 90,
            cellStyle: {
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center'
            }
        },
        {
            field: 'hoTyNo',

            headerName: '호 타입',

            filter: true,

            width: 150,
            cellStyle: {
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center'
            }
        },

        {
            valueGetter: (params) => params.data?.rentInfo?.rentTypeCd,

            headerName: '거래유형',

            width: 100,
            cellStyle: {
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center'
            },

            valueFormatter: ({ value }) => {

                switch (value) {

                    case 'JS':
                        return '전세';

                    case 'PE':
                        return '월세';

                    default:
                        return '-';
                }
            }
        }

        , {
            headerName: '입주가능일',

            width: 130,
            cellStyle: {
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center'
            },

            valueGetter: (params) =>
                params.data?.rentInfo?.mvinPsblDt,

            valueFormatter: ({ value }) => {

                if (!value) return '-';

                return value.substring(0, 10);
            }
        }
        , {
            headerName: '모집유형',

            width: 110,

            cellStyle: {
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center'
            },
            valueGetter: (params) =>
                params.data?.rentInfo?.rcrtLstgSttsCd,

            valueFormatter: ({ value }) => {

                switch (value) {

                    case 'GENERAL':
                        return '일반';

                    case 'SUBSCRIBE':
                        return '청약';

                    default:
                        return '-';
                }
            }
        }
        , {
            headerName: '보증금',

            width: 140,

            headerClass: 'ag-right-header',

            cellStyle: {
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'flex-end',
                paddingRight: '16px'
            },

            valueGetter: (params) =>
                params.data?.rentInfo?.dpstAmt,

            valueFormatter: ({ value }) => {

                if (!value) return '-';

                return Number(value)
                    .toLocaleString();
            }
        }
        , {
            headerName: '월세',

            width: 120,

            cellStyle: {
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'flex-end',
                paddingRight: '16px'
            },

            valueGetter: (params) =>
                params.data?.rentInfo?.mthlyRentAmt,

            valueFormatter: ({ value }) => {

                if (!value) return '-';

                return Number(value).toLocaleString();
            }
        }
        , {
            field: 'hoSttsCd',
            headerName: '상태',
            filter: true,
            width: 90,
            cellStyle: {
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center'
            },
            cellRenderer: ({ value }) => {
                const label = statusMap[value] || value;
                let bg = '#e2e8f0';
                let color = '#334155';
                if (value === 'EMPTY') {
                    bg = '#dcfce7';
                    color = '#166534';
                }
                if (value === 'LIVE') {
                    bg = '#fee2e2';
                    color = '#991b1b';
                }


                return (
                    <div
                        style={{
                            display: 'flex',
                            alignItems: 'center',
                            height: '100%'
                        }}
                    >
                        <span
                            style={{
                                padding:
                                    '4px 10px',

                                borderRadius:
                                    '999px',

                                fontSize: '12px',

                                fontWeight: '600',

                                background: bg,

                                color
                            }}
                        >
                            {label}
                        </span>
                    </div>
                );
            }
        }

    ], []);

    /**
     * 선택 변경
     */
    const handleSelectionChanged = (event) => {

        const rows = event.api.getSelectedRows();

        setSelectedRooms(rows);

    };

    useEffect(() => {

        if (!gridApi) return;

        gridApi.forEachNode((node) => {

            const shouldSelect = selectedRooms.some(item => item.ho === node.data.ho);

            if (
                node.isSelected() !== shouldSelect
            ) {
                node.setSelected(shouldSelect);
            }
        });

    }, [
        selectedRooms,
        gridApi
    ]);

    const disabled = selectedRooms.length === 0;

    const actionButtonStyle = {

        height: '36px',

        padding: '0 16px',

        borderRadius: '8px',

        fontSize: '13px',

        fontWeight: '600',

        transition: 'all 0.2s ease'
    };

    return (
        <>
            <style>
                {`
                .ag-header-cell-label {
                    justify-content: center;
                }
            `}
            </style>

            <div
                style={{
                    height: '100%',

                    background: '#fff',

                    border:
                        '1px solid var(--outline-variant)',

                    borderRadius: '16px',

                    overflow: 'hidden',

                    display: 'flex',
                    flexDirection: 'column'
                }}
            >

                {/* 헤더 */}
                <div
                    style={{
                        height: '56px',

                        borderBottom:
                            '1px solid #eee',

                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'space-between',

                        padding: '0 20px',

                        fontSize: '15px',
                        fontWeight: '700'
                    }}
                >

                    {selectedDongNm
                        ? `${selectedAptNm} ${selectedDongNm}`
                        : '동을 선택해주세요'}


                    <div
                        style={{
                            display: 'flex',
                            gap: '8px'
                        }}
                    >

                        <button disabled={disabled} onClick={() => {
                            if (disabled) return;
                            setShowModal(true);
                        }}

                            style={{

                                ...actionButtonStyle,

                                border: 'none',

                                background: disabled
                                    ? '#e2e8f0'
                                    : '#2563eb',

                                color: disabled
                                    ? '#94a3b8'
                                    : '#fff',

                                cursor: disabled
                                    ? 'not-allowed'
                                    : 'pointer',

                                opacity: disabled
                                    ? 0.8
                                    : 1
                            }}
                        >
                            선택한 호 매물 등록
                        </button>

                        <button
                            disabled={selectedRooms.length === 0}

                            onClick={handleDelete}

                            style={{

                                ...actionButtonStyle,

                                border:
                                    disabled
                                        ? 'none'
                                        : '1px solid #ef4444',

                                background:
                                    disabled
                                        ? '#e2e8f0'
                                        : '#fff',

                                color:
                                    disabled
                                        ? '#94a3b8'
                                        : '#ef4444',

                                cursor:
                                    disabled
                                        ? 'not-allowed'
                                        : 'pointer',

                                opacity:
                                    disabled
                                        ? 0.8
                                        : 1
                            }}
                        >
                            매물 등록 취소
                        </button>
                    </div>
                </div>

                {/* Grid */}
                <div
                    className="ag-theme-alpine"

                    style={{
                        flex: 1,
                        width: '100%'
                    }}
                >

                    {!selectedDongNm ? (

                        <div
                            style={{
                                height: '100%',

                                display: 'flex',
                                alignItems: 'center',
                                justifyContent: 'center',

                                color: '#94a3b8'
                            }}
                        >
                            좌측 탐색기에서 동을 선택해주세요.
                        </div>

                    ) : (

                        <AgGridReact

                            rowData={rowData}
                            columnDefs={columnDefs}
                            rowSelection="multiple"
                            animateRows={true}
                            rowMultiSelectWithClick={true}
                            suppressRowClickSelection={false}
                            onGridReady={(params) => {
                                setGridApi(params.api);
                            }}
                            onSelectionChanged={
                                handleSelectionChanged
                            }
                        />

                    )}

                </div>

            </div>
            <RentRegisterModal

                open={showModal}
                onClose={() => setShowModal(false)}
                onSuccess={() => {
                    fetchHoList();
                    setSelectedRooms([]);
                }}
                selectedRooms={selectedRooms}
                selectedAptNm={selectedAptNm}
                selectedDongNm={selectedDongNm}
            />
        </>
    );
}

export default SalesGrid;