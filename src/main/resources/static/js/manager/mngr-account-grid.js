/**
 * ============================================================
 * mngr-account-grid.js
 * 직원 계정 관리 화면 AG Grid 전용 스크립트
 * ============================================================
 */
(function () {

    /* ─────────────────────────────────────────────
       계정 관리 화면 전용 코드맵
    ───────────────────────────────────────────── */

    var DUTY_TEXT = {
        HEAD:'관리소장',
        ACNT:'회계담당',
        ADM:'행정담당',
        FAC:'시설담당'
    };

    var STTS_TEXT = {
        WAIT:'승인대기',
        OK:'승인완료',
        RJCT:'반려',
        CNL:'신청취소'
    };


    /* ─────────────────────────────────────────────
       텍스트 변환 유틸
    ───────────────────────────────────────────── */

    function normalizeStatus(code){
        return String(code||'').toUpperCase();
    }

    function dutyText(code){
        return DUTY_TEXT[normalizeStatus(code)]||'-';
    }

    function sttsText(code){
        return STTS_TEXT[normalizeStatus(code)]||'-';
    }


    /* ─────────────────────────────────────────────
       createGrids(option)
    ───────────────────────────────────────────── */

    function createGrids(option){

        var managerGridEl=option.managerGridEl;
        var requestGridEl=option.requestGridEl;

        var managerRowData=option.managerRowData||[];
        var requestRowData=option.requestRowData||[];

        var isAdmin=option.isAdmin===true;

        /* 기존 그리드 제거 */
        if(typeof destroyManagerGrid==='function'){
            destroyManagerGrid(managerGridEl);
            destroyManagerGrid(requestGridEl);
        }

        if(typeof createManagerGrid!=='function') return;


        /* =====================================================
           재직 직원 그리드
        ===================================================== */

        createManagerGrid(
            managerGridEl,
            [
                {
                    headerName:'No',
                    valueGetter:function(params){
                        return params.node ? params.node.rowIndex + 1 : '';
                    },
                    width:52,
                    minWidth:44,
                    maxWidth:80,
                    sortable:false,
                    filter:false,
                    cellClass:'align-center',
                    headerClass:'align-center'
                },
                {
                    headerName:'직원',
                    field:'userNm',
                    width:250,
                    cellRenderer:AgRenderer.user.by('userNm','userId')
                },
                {
                    headerName:'직무',
                    field:'mngrDutyCd',
                    width:100,
                    cellClass:'align-center',
                    headerClass:'align-center',
                    cellRenderer:AgRenderer.badge(AgRenderer.CODE.JOB_TY)
                },
                {
                    headerName:'연락처',
                    field:'telno',
                    width:250
                },
                {
                    headerName:'이메일',
                    field:'userEml',
                    width:200,
                    cellRenderer:AgRenderer.text
                },
                {
                    headerName:'상태',
                    field:'userYn',
                    width:90,
                    cellClass:'align-center',
                    headerClass:'align-center',
                    cellRenderer:AgRenderer.yn('활성','비활성')
                },
                {
                    /*
                     * 재직 직원 관리 버튼
                     * ADMIN : 상세만
                     * 일반  : 상세 + 수정
                     */
                    headerName:'관리',
                    field:'userNo',
                    width:isAdmin?90:140,
                    sortable:false,
                    filter:false,
                    cellClass:'align-center',
                    headerClass:'align-center',

                    cellRenderer:isAdmin
                        ? AgRenderer.actions([
                            {
                                label:'상세',
                                action:'manager-detail',
                                cls:'btn-detail'
                            }
                        ],'userNo')

                        : AgRenderer.actions([
                            {
                                label:'상세',
                                action:'manager-detail',
                                cls:'btn-detail'
                            },
                            {
                                label:'수정',
                                action:'manager-edit',
                                cls:'btn-edit'
                            }
                        ],'userNo')
                }
            ],
            managerRowData,
            {
                domLayout:'autoHeight',
                paginationPageSize:10
            }
        );


        /* =====================================================
           계정 생성 요청 그리드
        ===================================================== */

        createManagerGrid(
            requestGridEl,
            [
                {
                    headerName:'No',
                    valueGetter:function(params){
                        return params.node ? params.node.rowIndex + 1 : '';
                    },
                    width:52,
                    minWidth:44,
                    maxWidth:80,
                    sortable:false,
                    filter:false,
                    cellClass:'align-center',
                    headerClass:'align-center'
                },
                {
                    headerName:'요청 직원',
                    field:'rqstMngrNm',
                    width:250,
                    cellRenderer:AgRenderer.user.by('rqstMngrNm','rqstLoginId')
                },
                {
                    headerName:'직무',
                    field:'rqstDutyCd',
                    width:150,
                    cellClass:'align-center',
                    headerClass:'align-center',
                    cellRenderer:AgRenderer.badge(AgRenderer.CODE.JOB_TY)
                },
                {
                    headerName:'요청 일자',
                    field:'rqstDt',
                    width:150,
                    cellClass:'align-center',
                    headerClass:'align-center',
                    cellRenderer:AgRenderer.date.dot
                },
                {
                    headerName:'처리 일자',
                    field:'aprvDt',
                    width:150,
                    cellClass:'align-center',
                    headerClass:'align-center',
                    cellRenderer:AgRenderer.date.dot
                },
                {
                    headerName:'상태',
                    field:'rqstSttsCd',
                    width:140,
                    cellClass:'align-center',
                    headerClass:'align-center',
                    cellRenderer:AgRenderer.badge(AgRenderer.CODE.ACNT_RQST_STTS)
                },
                {
                    /*
                     * 요청 관리 버튼
                     * ADMIN : 상세만
                     * 일반 :
                     * - WAIT → 상세/수정/취소 활성
                     * - WAIT 이외 → 수정/취소 흐리게 표시
                     *
                     * 실제 차단 및 alert는
                     * mngr-account.js 에서 처리
                     */
                    headerName:'관리',
                    field:'rqstNo',
                    width:230,
                    sortable:false,
                    filter:false,
                    cellClass:'align-center',
                    headerClass:'align-center',

                    cellRenderer:isAdmin
                        ? AgRenderer.actions([
                            {
                                label:'상세',
                                action:'request-detail',
                                cls:'btn-detail'
                            }
                        ],'rqstNo')

                        : AgRenderer.actions([
                            {
                                label:'상세',
                                action:'request-detail',
                                cls:'btn-detail'
                            },
                            {
                                label:'수정',
                                action:'request-edit',
                                cls:'btn-edit',

                                /*
                                 * WAIT 아니면 흐리게 표시
                                 */
                                disabledWhen:function(row){
                                    return normalizeStatus(row.rqstSttsCd)!=='WAIT';
                                }
                            },
                            {
                                label:'취소',
                                action:'request-cancel',
                                cls:'btn-delete',

                                /*
                                 * WAIT 아니면 흐리게 표시
                                 */
                                disabledWhen:function(row){
                                    return normalizeStatus(row.rqstSttsCd)!=='WAIT';
                                }
                            }
                        ],'rqstNo')
                }
            ],
            requestRowData,
            {
                domLayout:'autoHeight',
                paginationPageSize:10
            }
        );
    }


    /* ─────────────────────────────────────────────
       외부 공개 API
    ───────────────────────────────────────────── */

    window.MngrAccountGrid={

        normalizeStatus:normalizeStatus,
        dutyText:dutyText,
        sttsText:sttsText,

        setRows:function(gridEl,rows){

            if(typeof setGridRowData==='function'){
                setGridRowData(gridEl,rows);

            }else if(gridEl&&gridEl.__gridApi){
                gridEl.__gridApi.setGridOption('rowData',rows||[]);
            }
        },

        createGrids:createGrids
    };

})();
