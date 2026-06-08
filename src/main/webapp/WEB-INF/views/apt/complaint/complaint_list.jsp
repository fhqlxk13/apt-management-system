<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>민원 내역 - ${aptInfo.aptComplexInfo.aptCmplexNm}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/apt/apt.css">
    <style>
        .modal-overlay {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(4px);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 2000;
        }
        .modal-content {
            width: 100%;
            max-width: 800px;
            max-height: 90vh;
            overflow-y: auto;
            animation: modalFadeIn 0.3s ease-out;
        }
        .modal-close-btn {
            background: none;
            border: none;
            cursor: pointer;
            color: var(--text-light);
            display: flex;
            align-items: center;
        }
        .modal-close-btn:hover { color: var(--danger); }
        @keyframes modalFadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        #modalCn {
            white-space: pre-wrap;
            word-break: break-all;
            font-size: 13px;
            line-height: 1.8;
            color: var(--text-dark);
        }
        .panel { width: 100%; }
        .search-bar {
            display: flex;
            gap: 10px;
            align-items: center;
            margin-bottom: 16px;
        }
        .search-bar select {
            padding: 8px 12px;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-size: 14px;
            color: var(--text-dark);
            background: #fff;
            cursor: pointer;
        }
        .search-bar button {
            padding: 8px 20px;
            border-radius: 8px;
            border: none;
            background: var(--green-dark);
            color: #fff;
            font-size: 14px;
            cursor: pointer;
        }
        .search-bar button:hover { opacity: 0.9; }
        .pagination-wrap { margin-top: 20px; display: flex; justify-content: center; }
        .pagination { display: flex; list-style: none; padding: 0; margin: 0; gap: 4px; }
        .pagination .page-item .page-link {
            display: inline-flex; align-items: center; justify-content: center;
            width: 32px; height: 32px; border-radius: 6px;
            border: 1px solid var(--green-dark); color: var(--green-dark);
            text-decoration: none; font-size: 13px; cursor: pointer;
        }
        .pagination .page-item.active .page-link {
            background: var(--green-dark); color: #fff; border-color: var(--green-dark);
        }
        .pagination .page-item .page-link:hover {
            background: var(--green-dark); color: #fff;
        }
        .pagination .page-item.disabled .page-link {
            cursor: default; border: none; color: var(--text-light);
        }
        .search-bar select {
            padding: 8px 12px;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-size: 14px;
            color: var(--text-dark) !important;
            background: #fff !important;
            cursor: pointer;
            appearance: auto !important;
            -webkit-appearance: auto !important;
            min-width: 130px;
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>
<div class="main-shell">
    <%@ include file="/WEB-INF/views/include/apt_sidebarLayout.jsp" %>
    <main class="content-area">
        <div class="page-content-wrap">
            <div class="breadcrumb">
                <a href="/apt/main/${aptInfo.aptComplexInfo.aptCmplexNo}">${aptInfo.aptComplexInfo.aptCmplexNm}</a>
                <span>›</span>
                <a href="javascript:void(0);">민원접수</a>
                <span>›</span>
                <span class="cur">민원 내역</span>
            </div>
            <h1 class="page-title">우리 아파트 민원 내역</h1>
            <div class="panel">
                <div class="section-hd">
                    <h3>민원 내역</h3>
                </div>

                <%-- 검색 바 --%>
                <form id="searchForm" method="get"
                      action="/apt/complaint/list/${aptInfo.aptComplexInfo.aptCmplexNo}">
                    <div class="search-bar">
                        <select name="cvplTyCd">
                            <option value="">카테고리 전체</option>
                            <option value="FAC" ${cvplTyCd eq 'FAC' ? 'selected' : ''}>시설/하자</option>
                            <option value="SEC" ${cvplTyCd eq 'SEC' ? 'selected' : ''}>보안/안전</option>
                            <option value="ACC" ${cvplTyCd eq 'ACC' ? 'selected' : ''}>회계/관리비</option>
                            <option value="ENV" ${cvplTyCd eq 'ENV' ? 'selected' : ''}>환경/위생</option>
                            <option value="ETC" ${cvplTyCd eq 'ETC' ? 'selected' : ''}>기타</option>
                        </select>
                        <select name="cvplSttsCd">
                            <option value="">상태 전체</option>
                            <option value="APLY" ${cvplSttsCd eq 'APLY' ? 'selected' : ''}>민원 신청됨</option>
                            <option value="RCPT" ${cvplSttsCd eq 'RCPT' ? 'selected' : ''}>민원 접수됨</option>
                            <option value="SUPL" ${cvplSttsCd eq 'SUPL' ? 'selected' : ''}>보완 요청</option>
                            <option value="REJS" ${cvplSttsCd eq 'REJS' ? 'selected' : ''}>처리 불가</option>
                            <option value="RJCT" ${cvplSttsCd eq 'RJCT' ? 'selected' : ''}>반려</option>
                            <option value="COMP" ${cvplSttsCd eq 'COMP' ? 'selected' : ''}>처리 완료</option>
                            <option value="END"  ${cvplSttsCd eq 'END'  ? 'selected' : ''}>종결</option>
                            <option value="CNCL" ${cvplSttsCd eq 'CNCL' ? 'selected' : ''}>민원 취소됨</option>
                        </select>
                        <input type="text" name="searchWord" value="${searchWord}" placeholder="제목 검색" style="padding: 8px 12px; border: 1px solid var(--border); border-radius: 8px; font-size: 14px;">
                        <button type="submit">검색</button>
                    </div>
                </form>

                <table class="data-table">
                    <thead>
                    <tr>
                        <th style="text-align: center; vertical-align: middle;">민원 번호</th>
                        <th style="text-align: center; vertical-align: middle;">접수일</th>
                        <th style="text-align: center; vertical-align: middle;">카테고리</th>
                        <th>제목</th>
                        <th>발생장소</th>
                        <th style="text-align: center; vertical-align: middle;">상태</th>
                    </tr>
                    </thead>
                    <tbody id="cvplBody">
                    <c:forEach var="cvpl" items="${cvplList}">
                        <tr onclick="openCvplDetail('${cvpl.cvplNo}')" style="cursor:pointer;">
                            <td style="text-align: center; vertical-align: middle;">${cvpl.cvplNo}</td>
                            <td style="text-align: center; vertical-align: middle;"><fmt:formatDate value="${cvpl.cvplRegDt}" pattern="yyyy.MM.dd HH:mm"/></td>
                            <c:choose>
                                <c:when test="${cvpl.cvplTyCd eq 'FAC'}">
                                    <td style="text-align: center; vertical-align: middle;"><span class="badge wait">시설/하자</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplTyCd eq 'SEC'}">
                                    <td style="text-align: center; vertical-align: middle;"><span class="badge cancel">보안/안전</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplTyCd eq 'ACC'}">
                                    <td style="text-align: center; vertical-align: middle;"><span class="badge ok">회계/관리비</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplTyCd eq 'ENV'}">
                                    <td style="text-align: center; vertical-align: middle;"><span class="badge wait">환경/위생</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplTyCd eq 'ETC'}">
                                    <td style="text-align: center; vertical-align: middle;"><span class="badge wait">기타</span></td>
                                </c:when>
                                <c:otherwise>
                                    <td style="text-align: center; vertical-align: middle;">${cvpl.cvplTyCd}</td>
                                </c:otherwise>
                            </c:choose>
                            <td>${cvpl.cvplTtl}</td>
                            <td>${cvpl.cvplLoc}</td>
                            <c:choose>
                                <c:when test="${cvpl.cvplSttsCd eq 'APLY'}">
                                    <td style="text-align: center; vertical-align: middle;"><span class="badge wait">민원 신청됨</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplSttsCd eq 'CNCL'}">
                                    <td style="text-align: center; vertical-align: middle;"><span class="badge cancel">민원 취소됨</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplSttsCd eq 'RCPT'}">
                                    <td style="text-align: center; vertical-align: middle;"><span class="badge ok">민원 접수됨</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplSttsCd eq 'SUPL'}">
                                    <td style="text-align: center; vertical-align: middle;"><span class="badge wait">보완 요청</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplSttsCd eq 'REJS'}">
                                    <td style="text-align: center; vertical-align: middle;"><span class="badge wait">처리 불가</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplSttsCd eq 'RJCT'}">
                                    <td style="text-align: center; vertical-align: middle;"><span class="badge wait">반려</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplSttsCd eq 'COMP'}">
                                    <td style="text-align: center; vertical-align: middle;"><span class="badge info">처리 완료</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplSttsCd eq 'END'}">
                                    <td style="text-align: center; vertical-align: middle;"><span class="badge info">종결</span></td>
                                </c:when>
                            </c:choose>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty cvplList}">
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 40px; color: var(--text-light);">
                                해당 조건의 민원이 없습니다.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>

                <%-- 페이징 --%>
                <c:if test="${page.totalRecord > 0}">
                    <div class="pagination-wrap">
                        <%=((kr.or.ddit.common.model.PaginationInfoVO)request.getAttribute("page")).getPagingHTML()%>
                    </div>
                </c:if>
            </div>
        </div>
    </main>
</div>

<%-- 민원 상세 내역 모달 --%>
<div id="cvplDetailModal" class="modal-overlay" style="display: none;">
    <div class="modal-content panel">
        <div class="section-hd">
            <h3>민원 상세 내역</h3>
            <button type="button" class="modal-close-btn" onclick="closeModal()">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>
        <div class="modal-body">
            <div class="label-grid">
                <div class="th">민원 번호</div>
                <div id="modalNo" class="td" style="grid-column: span 3;"></div>

                <div class="th">제목</div>
                <div id="modalTtl" class="td" style="grid-column: span 3;"></div>

                <div class="th">카테고리</div>
                <div id="modalTy" class="td"></div>
                <div class="th">접수일시</div>
                <div id="modalDate" class="td"></div>

                <div class="th">발생장소</div>
                <div id="modalLoc" class="td" style="grid-column: span 3;"></div>

                <div class="th">처리상태</div>
                <div id="modalStatus" class="td" style="grid-column: span 3;"></div>
            </div>

            <%-- 처리 메모 / 반려 사유 (본인 민원 + 내용 있을 때만 표시) --%>
            <div id="modalAnsWrap" style="display:none; margin-top: 16px;">
                <div id="modalAnsBox" style="background:#fff8e1; border:1px solid #ffe082; border-radius:10px; padding:14px 18px;">
                    <p style="margin:0 0 6px; font-size:12px; font-weight:700; color:#b8860b;" id="modalAnsLabel">처리 메모</p>
                    <p id="modalAns" style="margin:0; font-size:13px; color:#5a4a00; line-height:1.8; white-space:pre-wrap;"></p>
                </div>
            </div>

            <div class="section-hd" style="margin-top: 24px; border-bottom: none;">
                <h3>민원 설명</h3>
            </div>
            <div id="modalCn" class="fake-textarea"
                 style="background: var(--bg); border-color: var(--border); margin-bottom: 20px;"></div>

            <div class="section-hd" style="border-bottom: none;">
                <h3>첨부 파일</h3>
            </div>
            <div id="modalFiles" class="chip-row"
                 style="background: var(--bg); padding: 15px; border-radius: 12px; border: 1px solid var(--border);">
                <span class="chip" style="background: var(--text-light);">첨부된 파일이 없습니다.</span>
            </div>
        </div>
        <div class="btn-row">
            <button class="btn-ghost" onclick="closeModal()">닫기</button>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
</body>
<script>
    const aptCmplexNo = '${aptInfo.aptComplexInfo.aptCmplexNo}';

    function closeModal() {
        document.querySelector('#cvplDetailModal').style.display = 'none';
        document.body.style.overflow = 'auto';
    }

    async function openCvplDetail(cvplNo) {
        try {
            const url = '/apt/complaint/detail/' + aptCmplexNo + '/' + cvplNo;
            const resp = await fetch(url);
            if (!resp.ok) throw new Error("상세 정보를 불러올 수 없습니다.");

            const data = await resp.json();
            const cvpl = data.detail;
            const files = data.files;

            document.querySelector('#modalNo').innerText     = cvpl.cvplNo;
            document.querySelector('#modalTtl').innerText    = cvpl.cvplTtl;
            document.querySelector('#modalTy').innerText     = getCategoryText(cvpl.cvplTyCd);
            document.querySelector('#modalDate').innerText   = new Date(cvpl.cvplRegDt).toLocaleString('ko-KR');
            document.querySelector('#modalLoc').innerText    = cvpl.cvplLoc || '장소 미지정';
            document.querySelector('#modalCn').innerText     = cvpl.cvplCn  || '';
            document.querySelector('#modalStatus').innerText = getStatusText(cvpl.cvplSttsCd);

            // 처리 메모 / 반려 사유 (본인 민원일 때 API가 cvplAns 반환)
            const ansWrap = document.querySelector('#modalAnsWrap');
            const ansBox = document.querySelector('#modalAnsBox');
            const ansLabel = document.querySelector('#modalAnsLabel');
            const ansEl = document.querySelector('#modalAns');
            if (data.cvplAns) {
                const isReject = cvpl.cvplSttsCd === 'RJCT' || cvpl.cvplSttsCd === 'REJS';
                ansLabel.textContent = isReject ? '반려 / 처리불가 사유' : '처리 메모';
                ansLabel.style.color = isReject ? '#a23a3a' : '#b8860b';
                ansBox.style.background = isReject ? '#fbe8e8' : '#fff8e1';
                ansBox.style.borderColor = isReject ? '#f5aaaa' : '#ffe082';
                ansEl.style.color = isReject ? '#7a2020' : '#5a4a00';
                ansEl.textContent = data.cvplAns;
                ansWrap.style.display = 'block';
            } else {
                ansWrap.style.display = 'none';
            }

            const fileBox = document.querySelector('#modalFiles');
            if (files && files.length > 0) {
                fileBox.innerHTML = files.map(f =>
                    '<a href="/file/download/' + f.googleId + '" class="chip" style="background: var(--green-dark); cursor:pointer;">' +
                    '<span class="material-symbols-outlined" style="font-size:14px;">download</span>' +
                    f.fileOgName + '</a>'
                ).join('');
            } else {
                fileBox.innerHTML = '<span class="chip" style="background: var(--text-light);">첨부된 파일이 없습니다.</span>';
            }

            document.querySelector('#cvplDetailModal').style.display = 'flex';
            document.body.style.overflow = 'hidden';

        } catch (error) {
            alert(error.message);
        }
    }

    function getCategoryText(tyCd) {
        const categoryMap = {
            'FAC': '시설/하자',
            'SEC': '보안/안전',
            'ACC': '회계/관리비',
            'ENV': '환경/위생',
            'ETC': '기타'
        };
        return categoryMap[tyCd] || tyCd;
    }

    function getStatusText(statusCd) {
        const statusMap = {
            'APLY': '민원 신청됨',
            'CNCL': '민원 취소됨',
            'RCPT': '민원 접수됨',
            'SUPL': '보완 요청',
            'REJS': '처리 불가',
            'RJCT': '반려',
            'COMP': '처리 완료',
            'END' : '종결'
        };
        return statusMap[statusCd] || '알 수 없음';
    }

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') closeModal();
    });

    document.querySelector('#cvplDetailModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });

    <%-- 페이징 클릭 시 검색 조건 유지 --%>
    document.addEventListener('click', function(e) {
        const pageLink = e.target.closest('[data-page]');
        if (pageLink) {
            e.preventDefault();
            const pageNum = pageLink.getAttribute('data-page');
            const form = document.querySelector('#searchForm');
            const params = new URLSearchParams(new FormData(form));
            params.set('curPage', pageNum);
            location.href = '/apt/complaint/list/' + aptCmplexNo + '?' + params.toString();
        }
    });
</script>
</html>
