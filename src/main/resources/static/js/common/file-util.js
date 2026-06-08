/*
 created bt 2026.04.25
 file-util.js
 파일 업로드 공통 유틸리티 js
*/

/**
 * 이미지 미리보기
 * @param file - input에서 가져온 파일객체
 * @param previewDiv - 미리보기 이미지를 붙여놓을 div
 */
function imgPreview(file, previewDiv) {
    if (file.files && file.files[0]) {
        const reader = new FileReader();

        // onload이벤트 파일읽기가 완료되면 실행됨
        reader.onload = function (event) {
            // div 내부를 비우고 이미지를 새로 삽입
            previewDiv.innerHTML = `
                <img alt='미리보기' src='${event.target.result}' 
                              style='width: 100%; height: 100%;'>
                `;
        };
        reader.readAsDataURL(file.files[0]);
    }
}