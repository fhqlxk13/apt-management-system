<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
  <title>예약승인관리</title>

  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

  <style>
    .pf-wrap{padding:24px}
    .pf-page-title{font-size:24px;font-weight:700;color:#1f2d1f;margin-bottom:6px}
    .pf-page-desc{font-size:13px;color:#6b7280;margin-bottom:22px}
    .pf-card{background:#fff;border:1px solid #dfe5df;border-radius:8px;margin-bottom:16px}
    .pf-card-hd{display:flex;justify-content:space-between;align-items:center;padding:14px 18px;border-bottom:1px solid #e5e7eb;font-weight:700}
    .pf-card-bd{padding:16px 18px}
    .pf-search-grid{
      display:grid;
      grid-template-columns:1.1fr 1.1fr .65fr .65fr .9fr .9fr .9fr .8fr 70px auto;
      gap:10px;
      align-items:end;
    }

    .pf-btn-reset{
      width:70px;
      padding:0;
    }
    .pf-field label{display:block;font-size:12px;font-weight:700;color:#374151;margin-bottom:6px}
    .pf-field input,.pf-field select{width:100%;height:36px;border:1px solid #d7ded7;border-radius:5px;padding:0 10px;font-size:13px}
    .pf-btn{height:36px;border:1px solid #245b36;border-radius:5px;padding:0 14px;font-weight:700;cursor:pointer}
    .pf-btn-primary{background:#245b36;color:#fff}
    .pf-btn-light{background:#fff;color:#374151;border-color:#d7ded7}
    .pf-table{width:100%;border-collapse:collapse;font-size:13px}
    .pf-table th{background:#f2f6f1;border-bottom:1px solid #d7ded7;padding:12px;text-align:center;color:#374151}
    .pf-table td{border-bottom:1px solid #edf0ed;padding:11px;text-align:center}
    .pf-badge{display:inline-block;min-width:66px;padding:4px 8px;border-radius:6px;font-size:12px;font-weight:700}
    .pf-badge-wait{background:#eef2f7;color:#4b5563}
    .pf-paging{display:flex;justify-content:center;margin-top:18px}
    .pagination{display:flex;gap:4px;list-style:none;padding:0}
    .page-link{display:block;padding:6px 10px;border:1px solid #d7ded7;border-radius:4px;color:#374151;text-decoration:none}
    .page-item.active .page-link{background:#245b36;color:#fff;border-color:#245b36}
    .pf-actions{display:flex;gap:6px;justify-content:center}
  </style>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body>
<div class="app-wrapper">
  <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

  <div class="main-wrap">
    <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

    <main class="main-content">
      <div class="office-page">
        <div class="pf-wrap">
          <h2 class="pf-page-title">예약승인관리</h2>
          <p class="pf-page-desc">단지 내 편의시설 예약 정보를 조회합니다.</p>

          <form id="searchForm" method="get" action="${pageContext.request.contextPath}/manager/publicFacility/reservation/approval/${mgmtOfcNo}">
            <div class="pf-card">
              <div class="pf-card-hd">검색 조건</div>
              <div class="pf-card-bd pf-search-grid">
                <div class="pf-field">
                  <label>시설명</label>
                  <select name="searchCmnFacilityNo">
                    <option value="">전체</option>
                    <c:forEach items="${historyFacilityList}" var="facility">
                      <option value="${facility.cmnFacilityNo}"
                        ${searchVO.searchCmnFacilityNo eq facility.cmnFacilityNo ? 'selected' : ''}>
                          ${facility.cmnFacilityNm}
                      </option>
                    </c:forEach>
                  </select>
                </div>

                <div class="pf-field">
                  <label>예약대상</label>
                  <select name="searchItemNo">
                    <option value="">전체</option>
                    <c:forEach items="${historyItemList}" var="item">
                      <option value="${item.cmnFacilityItemNo}"
                        ${searchVO.searchItemNo eq item.cmnFacilityItemNo ? 'selected' : ''}>
                          ${item.itemNm}
                      </option>
                    </c:forEach>
                  </select>
                </div>

                <div class="pf-field">
                  <label>동</label>
                  <input name="searchDongNm" value="${searchVO.searchDongNm}" placeholder="예: 101"/>
                </div>

                <div class="pf-field">
                  <label>호</label>
                  <input name="searchHo" value="${searchVO.searchHo}" placeholder="예: 305"/>
                </div>

                <div class="pf-field">
                  <label>입주민명</label>
                  <input name="searchUserNm" value="${searchVO.searchUserNm}" placeholder="이름"/>
                </div>

                <div class="pf-field">
                  <label>예약시작</label>
                  <input type="date" name="searchStartDt" value="${searchVO.searchStartDt}"/>
                </div>

                <div class="pf-field">
                  <label>예약종료</label>
                  <input type="date" name="searchEndDt" value="${searchVO.searchEndDt}"/>
                </div>

                <div class="pf-field">
                  <label>상태</label>
                  <select name="searchRsvtSttsCd">
                    <option value="">전체</option>
                    <option value="PENDING" ${searchVO.searchRsvtSttsCd eq 'PENDING' ? 'selected' : ''}>승인대기</option>
                    <option value="APPROVED" ${searchVO.searchRsvtSttsCd eq 'APPROVED' ? 'selected' : ''}>승인완료</option>
                    <option value="REJECTED" ${searchVO.searchRsvtSttsCd eq 'REJECTED' ? 'selected' : ''}>거절</option>
                    <option value="CANCELLED" ${searchVO.searchRsvtSttsCd eq 'CANCELLED' ? 'selected' : ''}>취소</option>
                  </select>
                </div>

                <button type="button" class="pf-btn pf-btn-light pf-btn-reset"
                        onclick="location.href='${pageContext.request.contextPath}/manager/publicFacility/reservation/approval/${mgmtOfcNo}'">
                  초기화
                </button>

                <button class="pf-btn pf-btn-primary">검색</button>
              </div>
            </div>
          </form>

          <div class="pf-card">
            <div class="pf-card-hd">
              <span>예약승인관리 <b>${pagingVO.totalRecord}</b>건</span>
            </div>

            <div class="pf-card-bd">
              <table class="pf-table">
                <thead>
                <tr>
                  <th>번호</th>
                  <th>시설명</th>
                  <th>예약대상</th>
                  <th>동/호</th>
                  <th>입주민명</th>
                  <th>예약시간</th>
                  <th>예약목적</th>
                  <th>상태</th>
                  <th>관리</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach items="${pagingVO.dataList}" var="row" varStatus="st">
                  <tr>
                    <td>${pagingVO.totalRecord - ((pagingVO.currentPage - 1) * pagingVO.screenSize) - st.index}</td>
                    <td>${row.cmnFacilityNm}</td>
                    <td>${row.itemNm}</td>
                    <td>${row.dongNm} / ${row.ho}</td>
                    <td>${row.userNm}</td>
                    <td>${row.rsvtBgngDttm} ~ ${row.rsvtEndDttm}</td>
                        <%-- 예약목적 --%>
                    <td><c:out value="${row.purposeCn}" default="-"/></td>
                    <td><span class="pf-badge pf-badge-wait">${row.rsvtSttsNm}</span></td>
                    <td class="pf-actions">
                      <button type="button" class="pf-btn pf-btn-primary" onclick="approveRsvt('${row.rsvtNo}')">승인</button>
                      <button type="button" class="pf-btn pf-btn-light" onclick="rejectRsvt('${row.rsvtNo}')">거절</button>
                    </td>
                  </tr>
                </c:forEach>

                <c:if test="${empty pagingVO.dataList}">
                  <tr>
                    <td colspan="9">조회된 데이터가 없습니다.</td>
                  </tr>
                </c:if>
                </tbody>
              </table>

              <div class="pf-paging">${pagingVO.pagingHTML}</div>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</div>

<script>

  /*
   * contextPath
   * -> 프로젝트 루트 경로
   */
  const contextPath = '${pageContext.request.contextPath}';

  /*
   * 단지관리사무소 번호
   */
  const mgmtOfcNo = '${mgmtOfcNo}';

  /*
   * CSRF 보안 토큰
   *
   * Spring Security POST 요청 시 필요
   */
  const csrfToken = document.querySelector('meta[name="_csrf"]').content;
  const csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;

  /*
   * 페이지 번호 클릭 처리
   */
  document.addEventListener('click', function(e){

    const a = e.target.closest('.page-link');

    if(!a || !a.dataset.page){
      return;
    }

    e.preventDefault();

    const form = document.getElementById('searchForm');

    const page = document.createElement('input');

    page.type = 'hidden';
    page.name = 'currentPage';
    page.value = a.dataset.page;

    form.appendChild(page);

    form.submit();
  });

  /*
   * 예약 승인 처리
   */
  function approveRsvt(rsvtNo){

    Swal.fire({
      title: '예약 승인',
      text: '해당 예약을 승인하시겠습니까?',
      icon: 'question',
      showCancelButton: true,
      confirmButtonText: '승인',
      cancelButtonText: '취소',
      confirmButtonColor: '#245b36',
      cancelButtonColor: '#6b7280'
    }).then(function(result){

      if(!result.isConfirmed){
        return;
      }

      fetch(
              contextPath
              + '/manager/publicFacility/reservation/approval/'
              + mgmtOfcNo
              + '/'
              + rsvtNo
              + '/approve',
              {
                method : 'POST',
                headers : {
                  [csrfHeader] : csrfToken
                }
              }
      )
              .then(function(response){

                if(!response.ok){
                  Swal.fire({
                    icon:'error',
                    title:'오류',
                    text:'승인 처리 중 오류가 발생했습니다.'
                  });
                  return;
                }

                Swal.fire({
                  icon:'success',
                  title:'승인 완료',
                  text:'예약이 승인되었습니다.'
                }).then(function(){
                  location.reload();
                });
              })
              .catch(function(error){
                console.error(error);

                Swal.fire({
                  icon:'error',
                  title:'오류',
                  text:'승인 요청 중 오류가 발생했습니다.'
                });
              });
    });
  }

  /*
   * 예약 거절 처리
   */
  function rejectRsvt(rsvtNo){

    Swal.fire({
      title:'예약 거절',
      input:'textarea',
      inputLabel:'거절사유',
      inputPlaceholder:'거절사유를 입력하세요.',
      showCancelButton:true,
      confirmButtonText:'거절',
      cancelButtonText:'취소',
      confirmButtonColor:'#d33',
      inputValidator:(value)=>{
        if(!value){
          return '거절사유를 입력해주세요.';
        }
      }
    }).then((result)=>{

      if(!result.isConfirmed){
        return;
      }

      const reason = result.value;

      fetch(
              contextPath
              + '/manager/publicFacility/reservation/approval/'
              + mgmtOfcNo
              + '/'
              + rsvtNo
              + '/reject',
              {
                method:'POST',
                headers:{
                  [csrfHeader]:csrfToken,
                  'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8'
                },
                body:'rejectReason=' + encodeURIComponent(reason)
              }
      )
              .then(function(response){

                if(!response.ok){

                  Swal.fire({
                    icon:'error',
                    title:'오류',
                    text:'거절 처리 중 오류가 발생했습니다.'
                  });

                  return;
                }

                Swal.fire({
                  icon:'success',
                  title:'거절 완료',
                  text:'예약이 거절되었습니다.'
                }).then(()=>{
                  location.reload();
                });
              });
    });

    if(!reason || reason.trim() === ''){
      Swal.fire({
        icon:'warning',
        title:'확인',
        text:'거절사유를 입력해주세요.'
      });
      return;
    }

    fetch(
            contextPath
            + '/manager/publicFacility/reservation/approval/'
            + mgmtOfcNo
            + '/'
            + rsvtNo
            + '/reject',
            {
              method : 'POST',

              headers : {
                [csrfHeader] : csrfToken,
                'Content-Type' : 'application/x-www-form-urlencoded;charset=UTF-8'
              },

              body : 'rejectReason=' + encodeURIComponent(reason.trim())
            }
    )
            .then(function(response){

              if(!response.ok){
                Swal.fire({
                  icon:'error',
                  title:'오류',
                  text:'처리 중 오류가 발생했습니다.'
                });
                return;
              }

              Swal.fire({
                icon:'success',
                title:'완료',
                text:'거절 처리가 완료되었습니다.'
              });

              location.reload();
            })
            .catch(function(error){

              console.error(error);

              Swal.fire({
                icon:'error',
                title:'오류',
                text:'처리 중 오류가 발생했습니다.'
              });
            });
  }

</script>
</body>
</html>