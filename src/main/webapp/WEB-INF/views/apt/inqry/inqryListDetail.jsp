<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
  <style>
    body { font-family: 'Manrope', sans-serif; background-color: #fbf9f1; }
    .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
    .form-card { background:#fff; border:1px solid #e2e2e0; border-radius:20px; padding:32px; }
    .form-label { display:block; font-size:13px; font-weight:700; color:#46483c; margin-bottom:8px; }
    .form-input { width:100%; padding:12px 16px; border:1.5px solid #e2e2e0; border-radius:12px; font-size:14px; background:#fbf9f1; color:#1b1c17; outline:none; }
    .form-input:focus { border-color:#3f4c15; box-shadow:0 0 0 3px rgba(63,76,21,0.1); }
    textarea.form-input { resize:vertical; min-height:160px; }
    .category-chip { padding:8px 18px; border-radius:9999px; font-size:13px; font-weight:600; border:1.5px solid #e2e2e0; background:#fbf9f1; color:#76786b; cursor:pointer; }
    .category-chip.selected { background:#dfe5cb; border-color:#3f4c15; color:#3f4c15; }
    .upload-zone { border:2px dashed #c7c8b8; border-radius:14px; padding:32px; text-align:center; cursor:pointer; background:#fbf9f1; }
    .upload-zone.dragover { border-color:#3f4c15; background:#f0eee6; }
    .preview-item { position:relative; width:80px; height:80px; border-radius:10px; overflow:hidden; border:1px solid #e2e2e0; flex-shrink:0; }
    .preview-item img { width:100%; height:100%; object-fit:cover; }
    .preview-item .remove-btn { position:absolute; top:3px; right:3px; width:18px; height:18px; background:rgba(0,0,0,0.55); border-radius:50%; display:flex; align-items:center; justify-content:center; cursor:pointer; color:#fff; font-size:12px; line-height:1; }
    .toggle-wrap { display:flex; align-items:center; gap:10px; cursor:pointer; }
    .toggle-bg { width:44px; height:24px; border-radius:12px; background:#c7c8b8; position:relative; transition:background 0.2s; }
    .toggle-bg.on { background:#3f4c15; }
    .toggle-knob { width:18px; height:18px; background:#fff; border-radius:50%; position:absolute; top:3px; left:3px; transition:transform 0.2s; }
    .toggle-bg.on .toggle-knob { transform:translateX(20px); }
    .btn-primary { background:#3f4c15; color:#fff; padding:13px 32px; border-radius:12px; font-weight:700; font-size:14px; }
    .btn-secondary { background:#f0eee6; color:#46483c; padding:13px 28px; border-radius:12px; font-weight:700; font-size:14px; }
    .required::after { content:' *'; color:#ba1a1a; }
    .char-counter { font-size:11px; color:#b0b09e; text-align:right; margin-top:5px; }
    .char-counter.warn { color:#ba1a1a; }
    .answer-card { background:#f7faf3; border:1px solid #dfe5cb; border-radius:18px; padding:20px; }
    .badge { display:inline-flex; align-items:center; padding:4px 10px; border-radius:999px; font-size:12px; font-weight:700; }
  </style>
</head>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">
<body class="bg-surface text-on-surface min-h-screen">

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>

<main class="ml-80 p-10 pt-28">
  <div class="flex items-center gap-3 mb-8">
    <button onclick="history.back()" class="w-9 h-9 flex items-center justify-center rounded-full hover:bg-surface-container transition-colors">
      <span class="material-symbols-outlined text-on-surface-variant">arrow_back</span>
    </button>
    <div>
      <h1 class="text-2xl font-bold text-gray-900">
        <c:choose>
          <c:when test="${adminMode}">문의 답변</c:when>
          <c:when test="${empty inqry.postNo}">새 문의 작성</c:when>
          <c:otherwise>문의 수정</c:otherwise>
        </c:choose>
      </h1>
      <p class="text-sm text-gray-400 mt-0.5">
        <c:choose>
          <c:when test="${adminMode}">관리자가 문의를 확인하고 답변을 등록합니다.</c:when>
          <c:otherwise>담당자가 확인 후 신속하게 답변해 드립니다.</c:otherwise>
        </c:choose>
      </p>
    </div>
  </div>

  <c:if test="${not empty errorMessage}">
    <div style="margin-bottom:16px; padding:14px 18px; border-radius:12px; background:#fff1f2; color:#be123c; font-size:14px; font-weight:700;">
      ${errorMessage}
    </div>
  </c:if>

  <c:choose>
    <c:when test="${adminMode}">
      <form action="${pageContext.request.contextPath}/apt/board/inqry/replyProc.do" method="post" id="replyForm">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
        <input type="hidden" name="postNo" value="${inqry.postNo}">

        <div class="space-y-5">
          <div class="form-card">
            <div class="flex items-center justify-between mb-4">
              <div class="text-lg font-bold text-gray-900">문의 정보</div>
              <c:choose>
                <c:when test="${inqry.ansYn eq 'Y'}">
                  <span class="badge bg-[#dfe5cb] text-[#3f4c15]">답변완료</span>
                </c:when>
                <c:otherwise>
                  <span class="badge bg-yellow-100 text-yellow-700">답변대기</span>
                </c:otherwise>
              </c:choose>
            </div>

            <c:set var="opnText" value="${inqry.opnYn eq 'Y' ? '공개' : '비공개'}"/>

            <div class="grid grid-cols-2 gap-4 mb-4">
              <div>
                <label class="form-label">작성자</label>
                <input class="form-input" type="text" value="${inqry.wrtrNm} (${inqry.wrtrId})" readonly>
              </div>
              <div>
                <label class="form-label">등록일</label>
                <fmt:formatDate var="inqryRegDttmText" value="${inqry.regDttm}" pattern="yyyy.MM.dd HH:mm"/>
                <input class="form-input" type="text" value="${inqryRegDttmText}" readonly>
              </div>
            </div>

            <div class="grid grid-cols-2 gap-4 mb-4">
              <div>
                <label class="form-label">문의 유형</label>
                <input class="form-input" type="text" value="${inqry.prrtCd}" readonly>
              </div>
              <div>
                <label class="form-label">공개 여부</label>
                <input class="form-input" type="text" value="${opnText}" readonly>
              </div>
            </div>

            <div class="mb-4">
              <label class="form-label">제목</label>
              <input class="form-input" type="text" value="${inqry.ttl}" readonly>
            </div>
            <div class="mb-4">
              <label class="form-label">문의 내용</label>
              <textarea class="form-input" readonly>${inqry.cn}</textarea>
            </div>
          </div>

          <div class="form-card">
            <div class="flex items-center justify-between mb-4">
              <div class="text-lg font-bold text-gray-900">답변 작성</div>
              <c:if test="${inqry.ansYn eq 'Y'}">
                <span class="text-sm text-gray-400">
                  수정 가능
                </span>
              </c:if>
            </div>

            <div class="mb-3">
              <label class="form-label required" for="answerInput">답변 내용</label>
              <textarea class="form-input" id="answerInput" name="ansCn" maxlength="1000" placeholder="답변 내용을 입력하세요.">${inqry.ansCn}</textarea>
              <div class="char-counter"><span id="answerCount">0</span> / 1000</div>
            </div>

            <c:if test="${inqry.ansYn eq 'Y'}">
              <div class="answer-card mb-4">
                <div class="flex items-center justify-between mb-2">
                  <strong class="text-sm text-[#3f4c15]">현재 등록된 답변</strong>
                  <span class="text-xs text-gray-400">
                    <fmt:formatDate value="${inqry.ansRegDttm}" pattern="yyyy.MM.dd HH:mm"/>
                  </span>
                </div>
                <div class="text-sm text-gray-700 leading-relaxed">${inqry.ansCn}</div>
                <div class="text-xs text-gray-400 mt-2">작성자 : ${inqry.ansUserNm}</div>
              </div>
            </c:if>
          </div>
        </div>

        <div class="flex justify-end gap-3 mt-8">
          <button type="button" class="btn-secondary" onclick="history.back()">취소</button>
          <button type="submit" class="btn-primary" id="submitBtn">
            <span class="inline-flex items-center gap-2">
              <span class="material-symbols-outlined" style="font-size:18px">send</span>
              답변 등록
            </span>
          </button>
        </div>
      </form>
    </c:when>

    <c:otherwise>
      <c:choose>
        <c:when test="${not empty inqry.postNo}">
          <c:set var="formAction" value="${pageContext.request.contextPath}/apt/board/inqry/updateProc.do"/>
        </c:when>
        <c:otherwise>
          <c:set var="formAction" value="${pageContext.request.contextPath}/apt/board/inqry/writeProc.do"/>
        </c:otherwise>
      </c:choose>

      <form action="${formAction}" method="post" enctype="multipart/form-data" id="inquiryForm">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
        <input type="hidden" name="postNo" value="${inqry.postNo}">
        <input type="hidden" name="prrtCd" id="categoryInput" value="${empty inqry.prrtCd ? '시설' : inqry.prrtCd}">
        <input type="hidden" name="opnYn" id="isPublicInput" value="${empty inqry.opnYn ? 'Y' : inqry.opnYn}">

        <div class="space-y-5">
          <div class="form-card">
            <label class="form-label required">문의 유형</label>
            <div class="flex flex-wrap gap-2" id="categoryGroup">
              <button type="button" class="category-chip" data-value="시설">시설 / 설비</button>
              <button type="button" class="category-chip" data-value="주차">주차 / 차량</button>
              <button type="button" class="category-chip" data-value="소음">소음 / 분쟁</button>
              <button type="button" class="category-chip" data-value="커뮤니티">커뮤니티 시설</button>
              <button type="button" class="category-chip" data-value="청소">청결 / 환경</button>
              <button type="button" class="category-chip" data-value="기타">기타</button>
            </div>
          </div>

          <div class="form-card">
            <label class="form-label required" for="titleInput">제목</label>
            <input class="form-input" type="text" id="titleInput" name="ttl" value="${inqry.ttl}" maxlength="50" placeholder="문의 제목을 입력하세요">
            <div class="char-counter"><span id="titleCount">0</span> / 50</div>
          </div>

          <div class="form-card">
            <label class="form-label required" for="contentInput">문의 내용</label>
            <textarea class="form-input" id="contentInput" name="cn" maxlength="1000" placeholder="문의 내용을 상세히 작성해주세요.">${inqry.cn}</textarea>
            <div class="char-counter"><span id="contentCount">0</span> / 1000</div>
          </div>

          <div class="form-card">
            <label class="form-label">사진 첨부 <span class="font-normal text-gray-400">(최대 5장)</span></label>
            <div class="upload-zone" id="uploadZone" onclick="document.getElementById('fileInput').click()">
              <span class="material-symbols-outlined text-3xl text-gray-300 mb-2" style="font-size:36px">add_photo_alternate</span>
              <p class="text-sm text-gray-400 mt-1">클릭하거나 이미지를 드래그하여 업로드</p>
              <p class="text-xs text-gray-300 mt-1">JPG, PNG, GIF · 최대 10MB</p>
            </div>
            <input type="file" id="fileInput" name="files" multiple accept="image/*" class="hidden"/>
            <div class="flex gap-3 mt-4 flex-wrap" id="previewContainer"></div>
          </div>

          <div class="form-card">
            <label class="form-label">공개 설정</label>
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm text-gray-700 font-medium" id="toggleLabel">다른 입주민에게 공개</p>
                <p class="text-xs text-gray-400 mt-0.5">비공개 설정 시 관리자만 확인 가능합니다.</p>
              </div>
              <div class="toggle-wrap" onclick="togglePublic()">
                <div class="toggle-bg ${empty inqry.opnYn || inqry.opnYn eq 'Y' ? 'on' : ''}" id="toggleBg">
                  <div class="toggle-knob"></div>
                </div>
              </div>
            </div>
          </div>

          <c:if test="${not empty inqry.ansCn}">
            <div class="form-card">
              <div class="flex items-center justify-between mb-3">
                <div class="text-lg font-bold text-gray-900">관리자 답변</div>
                <span class="text-xs text-gray-400">
                  <fmt:formatDate value="${inqry.ansRegDttm}" pattern="yyyy.MM.dd HH:mm"/>
                </span>
              </div>
              <div class="answer-card">
                <div class="text-sm text-gray-700 leading-relaxed">${inqry.ansCn}</div>
                <div class="text-xs text-gray-400 mt-2">작성자 : ${inqry.ansUserNm}</div>
              </div>
            </div>
          </c:if>
        </div>

        <div class="flex justify-end gap-3 mt-8">
          <button type="button" class="btn-secondary" onclick="history.back()">취소</button>
          <button type="submit" class="btn-primary" id="submitBtn">
            <span class="inline-flex items-center gap-2">
              <span class="material-symbols-outlined" style="font-size:18px">sen
              d</span>
              <c:choose>
                <c:when test="${not empty inqry.postNo}">수정</c:when>
                <c:otherwise>문의 제출</c:otherwise>
              </c:choose>
            </span>
          </button>
        </div>
      </form>
    </c:otherwise>
  </c:choose>
</main>

<script>
  (function () {
    const categoryInput = document.getElementById('categoryInput');
    const selectedCategory = categoryInput ? categoryInput.value : '시설';

    document.querySelectorAll('.category-chip').forEach(function (chip) {
      if (chip.dataset.value === selectedCategory) {
        chip.classList.add('selected');
      }
      chip.addEventListener('click', function () {
        document.querySelectorAll('.category-chip').forEach(function (item) {
          item.classList.remove('selected');
        });
        chip.classList.add('selected');
        if (categoryInput) categoryInput.value = chip.dataset.value;
      });
    });
  })();

  const titleInput = document.getElementById('titleInput');
  const contentInput = document.getElementById('contentInput');
  const answerInput = document.getElementById('answerInput');

  function bindCounter(inputEl, countEl, warnAt) {
    if (!inputEl || !countEl) return;
    const sync = function () {
      const len = inputEl.value.length;
      countEl.textContent = len;
      countEl.parentElement.classList.toggle('warn', len >= warnAt);
    };
    inputEl.addEventListener('input', sync);
    sync();
  }

  bindCounter(titleInput, document.getElementById('titleCount'), 45);
  bindCounter(contentInput, document.getElementById('contentCount'), 900);
  bindCounter(answerInput, document.getElementById('answerCount'), 900);

  const fileInput = document.getElementById('fileInput');
  const previewContainer = document.getElementById('previewContainer');
  const uploadZone = document.getElementById('uploadZone');
  const isResidentForm = !!document.getElementById('inquiryForm');
  let selectedFiles = [];

  if (fileInput && previewContainer && uploadZone) {
    fileInput.addEventListener('change', function () {
      handleFiles(fileInput.files);
    });

    uploadZone.addEventListener('dragover', function (e) {
      e.preventDefault();
      uploadZone.classList.add('dragover');
    });
    uploadZone.addEventListener('dragleave', function () {
      uploadZone.classList.remove('dragover');
    });
    uploadZone.addEventListener('drop', function (e) {
      e.preventDefault();
      uploadZone.classList.remove('dragover');
      handleFiles(e.dataTransfer.files);
    });
  }

  function handleFiles(files) {
    Array.from(files).forEach(function (file) {
      if (selectedFiles.length >= 5) return;
      if (!file.type.startsWith('image/')) return;
      selectedFiles.push(file);

      const reader = new FileReader();
      reader.onload = function (e) {
        const item = document.createElement('div');
        item.className = 'preview-item';
        item.innerHTML = '<img src="' + e.target.result + '" alt="미리보기"/>' +
          '<div class="remove-btn" onclick="removeFile(this, \'' + file.name + '\')">✕</div>';
        previewContainer.appendChild(item);
      };
      reader.readAsDataURL(file);
    });
  }

  function removeFile(btn, name) {
    selectedFiles = selectedFiles.filter(function (file) { return file.name !== name; });
    btn.closest('.preview-item').remove();
  }

  let isPublic = (document.getElementById('isPublicInput') && document.getElementById('isPublicInput').value) !== 'N';
  function togglePublic() {
    isPublic = !isPublic;
    const bg = document.getElementById('toggleBg');
    const label = document.getElementById('toggleLabel');
    const input = document.getElementById('isPublicInput');
    if (bg) bg.classList.toggle('on', isPublic);
    if (label) label.textContent = isPublic ? '다른 입주민에게 공개' : '비공개 (관리자만 열람)';
    if (input) input.value = isPublic ? 'Y' : 'N';
  }

  const inquiryForm = document.getElementById('inquiryForm');
  if (inquiryForm) {
    inquiryForm.addEventListener('submit', function (e) {
      if (titleInput && !titleInput.value.trim()) {
        e.preventDefault();
        titleInput.focus();
        alert('제목을 입력해주세요.');
        return;
      }
      if (contentInput && !contentInput.value.trim()) {
        e.preventDefault();
        contentInput.focus();
        alert('문의 내용을 입력해주세요.');
      }
    });
  }

  const replyForm = document.getElementById('replyForm');
  if (replyForm) {
    replyForm.addEventListener('submit', function (e) {
      if (answerInput && !answerInput.value.trim()) {
        e.preventDefault();
        answerInput.focus();
        alert('답변 내용을 입력해주세요.');
      }
    });
  }
</script>
</body>
</html>
