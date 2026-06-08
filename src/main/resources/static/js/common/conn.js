document.addEventListener("DOMContentLoaded", () => {

    // 로그인 폼
    const loginFormBtn = document.querySelector("#loginFormBtn");
    if(loginFormBtn) {
        loginFormBtn.addEventListener("click", () => {
            location.href="/login.do";
        })
    }

    // 로그인 기능
    const loginBtn = document.querySelector("#loginBtn");
    const loginForm = document.querySelector("#loginForm");

    if(loginBtn && loginForm){  // 로그인 버튼과 폼이 있을 때
        loginBtn.addEventListener("click", (e) => {
            e.preventDefault();
            let username = loginForm.querySelector("input[name=username]").value.trim();
            let password = loginForm.querySelector("input[name=password]").value.trim();

            if(!username){
                alert("아이디를 입력하세요");
                return;
            }
            if(!password){
                alert("비밀번호를 입력하세요");
                return;
            }

            loginForm.submit();
        });
    }

    // 로그아웃 기능
    const logoutBtn = document.querySelector("#logoutBtn");
    const logoutForm = document.querySelector("#logoutForm");

    if(logoutBtn && logoutForm){
        logoutBtn.addEventListener("click", (e) => {
            e.preventDefault();

            Swal.fire({
                title: '로그아웃',
                text: '로그아웃 하시겠습니까?',
                icon: 'question',
                showCancelButton: true,
                cancelButtonText: '취소',
                confirmButtonText: '로그아웃',
                reverseButtons: false
            }).then((result) => {
                if(result.isConfirmed){
                    logoutForm.submit();
                }
            });
        });
    }

    // 회원가입 폼 버튼
    const joinFormBtn = document.querySelector("#joinFormBtn");

    if(joinFormBtn) {
        joinFormBtn.addEventListener("click", (e) => {
            // 팝업창 크기
            const width = 700;
            const height = 1000;

            // 화면 중앙 정렬 계산
            const left = (window.screen.width / 2) - (width / 2);
            const top = (window.screen.height / 2) - (height / 2);

            window.open(
                '/member/join.do',
                'joinPopup',
                'width=' + width + ', height=' + height +
                ', top=' + top + ', left=' + left + ', scrollbars=yes, resizable=no'
            );
        });
    }

    // 마이페이지 버튼
    const myPageBtn = document.querySelector("#myPageBtn");
    if(myPageBtn) {
        myPageBtn.addEventListener("click", (e) => {
            location.href="/member/myPageAuth.do";
        });
    }

})
