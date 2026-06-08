
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html class="light" lang="ko"><head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>시설 관리 이력 조회 - 우리집맵핑</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&amp;display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
  <script id="tailwind-config">
    tailwind.config = {
      darkMode: "class",
      theme: {
        extend: {
          "colors": {
            "surface": "#fbf9f5",
            "primary": "#56642b",
            "on-primary-container": "#253000",
            "surface-container": "#efeeea",
            "on-surface": "#1b1c1a",
            "on-error": "#ffffff",
            "inverse-surface": "#30312e",
            "surface-tint": "#56642b",
            "surface-container-low": "#f5f3ef",
            "inverse-primary": "#bdce89",
            "secondary-fixed-dim": "#b4cdb7",
            "background": "#fbf9f5",
            "secondary-fixed": "#d0e9d2",
            "on-primary-fixed-variant": "#3e4c16",
            "on-secondary": "#ffffff",
            "on-background": "#1b1c1a",
            "surface-container-high": "#eae8e4",
            "primary-fixed": "#d9eaa3",
            "on-tertiary-fixed-variant": "#155037",
            "tertiary": "#30694d",
            "on-primary": "#ffffff",
            "on-secondary-container": "#546a58",
            "on-tertiary-container": "#003320",
            "error": "#ba1a1a",
            "on-surface-variant": "#46483c",
            "outline": "#76786b",
            "surface-variant": "#e4e2de",
            "inverse-on-surface": "#f2f0ed",
            "surface-container-highest": "#e4e2de",
            "tertiary-fixed": "#b4f0cd",
            "primary-fixed-dim": "#bdce89",
            "surface-container-lowest": "#ffffff",
            "on-tertiary-fixed": "#002113",
            "tertiary-container": "#669f80",
            "surface-dim": "#dbdad6",
            "error-container": "#ffdad6",
            "outline-variant": "#c6c8b8",
            "on-primary-fixed": "#161f00",
            "secondary-container": "#d0e9d2",
            "tertiary-fixed-dim": "#98d3b2",
            "secondary": "#4e6452",
            "on-error-container": "#93000a",
            "on-tertiary": "#ffffff",
            "primary-container": "#8a9a5b",
            "on-secondary-fixed-variant": "#364c3b",
            "on-secondary-fixed": "#0b2012",
            "surface-bright": "#fbf9f5"
          },
          "borderRadius": {
            "DEFAULT": "0.25rem",
            "lg": "0.5rem",
            "xl": "0.75rem",
            "full": "9999px"
          },
          "fontFamily": {
            "headline": ["Manrope"],
            "body": ["Manrope"],
            "label": ["Manrope"]
          }
        },
      },
    }
  </script>
  <style>
    body { font-family: 'Manrope', sans-serif; }
    .material-symbols-outlined {
      font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
    }
  </style>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</head>
<body class="bg-surface text-on-surface flex flex-col min-h-screen">
<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

<!-- SideNavBar Shell -->


<!-- TopNavBar -->

<main class="ml-80 p-8 pt-28 max-w-8xl">


  <form id="submitForm"
        action="${pageContext.request.contextPath}/contract/apply.do"
        method="post"
        enctype="multipart/form-data">

      <input type="hidden"
             name="${_csrf.parameterName}"
             value="${_csrf.token}" />
  <!-- 제목 -->
  <div class="mb-8">


      <h1 class="text-3xl font-bold text-gray-900 mb-2">계약신청서 제출</h1>


      <p class="text-gray-500 text-sm ">
          신청을 위해 필요한 서류를 확인하고 업로드해주세요.
      </p>

  </div>



  <!-- 첨부서류 -->
  <div class="mb-10">
    <div class="flex justify-between items-center mb-4">
      <h2 class="text-lg font-semibold text-[#4d5c2b]">첨부서류</h2>
      <span class="bg-red-100 text-red-500 px-3 py-1 rounded-full text-xs">
        필수 5건
      </span>
    </div>

    <!-- 카드 리스트 -->
    <div class="space-y-4">

      <!-- 카드 -->
      <div class="bg-white p-5 rounded-2xl shadow-sm flex justify-between items-center">
        <div>
          <p class="font-semibold text-[#4d5c2b]">주민등록등본(본인)</p>
          <p class="text-sm text-gray-400">최근 3개월 이내 발급분</p>
        </div>

        <div class="flex items-center gap-3">

          <!-- 파일명 -->
          <span class="text-sm text-gray-400 file-name">
    파일 없음
  </span>



          <!-- 문서 타입 -->
          <input type="hidden"
                 name="docTypeList"
                 value="RESIDENT" />

          <!-- 실제 파일 input -->
          <input type="file"
                 name="uploadFiles"
                 class="hidden file-input"
                 accept=".pdf,.jpg,.jpeg,.png" />

          <!-- 업로드 버튼 -->
          <button type="button"
                  class="upload-btn bg-[#5c6b2f] text-white px-4 py-2 rounded-full text-sm">
            업로드
          </button>

        </div>
      </div>

      <div class="bg-white p-5 rounded-2xl shadow-sm flex justify-between items-center">
        <div>
          <p class="font-semibold text-[#4d5c2b]">가족관계증명서</p>
          <p class="text-sm text-gray-400">상세 포함</p>
        </div>

        <div class="flex items-center gap-3">

  <span class="text-sm text-gray-400 file-name">
    파일 없음
  </span>

          <input type="hidden"
                 name="docTypeList"
                 value="FAMILY" />

          <input type="file"
                 name="uploadFiles"
                 class="hidden file-input"
                 accept=".pdf,.jpg,.jpeg,.png" />

          <button type="button"
                  class="upload-btn bg-[#5c6b2f] text-white px-4 py-2 rounded-full text-sm">
            업로드
          </button>

        </div>
      </div>

      <div class="bg-white p-5 rounded-2xl shadow-sm flex justify-between items-center">
        <div>
          <p class="font-semibold text-[#4d5c2b]">금융정보 제공동의서</p>
          <p class="text-sm text-gray-400">양식 다운로드 후 업로드</p>
        </div>

        <div class="flex items-center gap-3">

  <span class="text-sm text-gray-400 file-name">
    파일 없음
  </span>

          <input type="hidden"
                 name="docTypeList"
                 value="FINANCE" />

          <input type="file"
                 name="uploadFiles"
                 class="hidden file-input"
                 accept=".pdf,.jpg,.jpeg,.png" />

          <button type="button"
                  class="upload-btn bg-[#5c6b2f] text-white px-4 py-2 rounded-full text-sm">
            업로드
          </button>

        </div>
      </div>

    </div>
  </div>

  <!-- 안내 -->
  <div class="bg-[#f1efea] p-6 rounded-2xl mb-10">
    <p class="font-semibold text-[#4d5c2b] mb-3">서류 제출 안내</p>

    <ul class="text-sm text-gray-600 space-y-2">
      <li>• 모든 서류는 3개월 이내 발급</li>
      <li>• 주민번호 전체 표시 필요</li>
      <li>• 파일 최대 10MB</li>
    </ul>
  </div>

  <!-- 버튼 -->
  <div class="flex justify-end gap-3">
    <button class="px-5 py-2 bg-gray-200 rounded-full text-sm">
      취소
    </button>
      <button type="button"
              id="submitBtn"
            class="px-6 py-2 bg-[#5c6b2f] text-white rounded-full text-sm">
      신청서 제출
    </button>
  </div>
  </form>
</main>


<script>

  // 업로드 버튼 클릭
  document.querySelectorAll(".upload-btn").forEach(button => {

    button.addEventListener("click", function () {

      // 같은 영역 안의 file input 찾기
      const wrapper = this.parentElement;

      const fileInput =
              wrapper.querySelector(".file-input");

      // 파일 선택창 열기
      fileInput.click();

    });

  });
  //파일 업로드
  document.querySelectorAll(".file-input").forEach(input => {

    input.addEventListener("change", function () {

      const wrapper = this.parentElement;

      const fileNameSpan =
              wrapper.querySelector(".file-name");

      if (this.files.length > 0) {

        fileNameSpan.innerText =
                this.files[0].name;

      } else {

        fileNameSpan.innerText =
                "파일 없음";

      }

    });

  });
    //신청서 제출
  document.querySelector("#submitBtn")
      .addEventListener("click", function () {

          // 유효성 검사
          const fileInputs = document.querySelectorAll(".file-input");
          let allUploaded = true;

          fileInputs.forEach(input => {
              if (!input.files || input.files.length === 0) {
                  allUploaded = false;
              }
          });

          if (!allUploaded) {
              Swal.fire({
                  icon: "warning",
                  title: "파일 미업로드",
                  text: "모든 서류를 업로드해주세요.",
                  confirmButtonColor: "#5c6b2f",
                  confirmButtonText: "확인"
              });
              return;
          }

          // 제출 확인
          Swal.fire({
              icon: "question",
              title: "제출 하시겠습니까?",
              text: "신청서를 제출합니다.",
              confirmButtonColor: "#5c6b2f",
              confirmButtonText: "확인",
              showCancelButton: true,
              cancelButtonText: "취소"
          }).then((result) => {
              if (result.isConfirmed) {
                  document.getElementById("submitForm").submit();
              }
          });
      });

</script>



</body>


</html>