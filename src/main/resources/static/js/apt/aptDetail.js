let scale = 1;
let translateX = 0;
let translateY = 0;

let isDragging = false;

let startX = 0;
let startY = 0;

let isZoomed = false;

let modalImages = [];
let modalIndex = 0;

const imageModal =
    document.getElementById("imageModal");

const modalImage =
    document.getElementById("modalImage");

const modalImageTarget =
    document.getElementById("modalImageTarget");

function openModal(images, index) {

    modalImages = images;
    modalIndex = index;

    setModalImage();

    imageModal.classList.add("active");

    document.body.style.overflow = "hidden";
}

function closeModal() {

    imageModal.classList.remove("active");

    document.body.style.overflow = "";
}

function showModalImage(index) {

    if(index < 0) {
        modalIndex = modalImages.length - 1;
    }
    else if(index >= modalImages.length) {
        modalIndex = 0;
    }
    else {
        modalIndex = index;
    }

    setModalImage();
}

function setModalImage() {

    const currentSrc = modalImages[modalIndex];

    modalImage.src = currentSrc;

    const googleId =
        currentSrc.split("/").pop();

    document.getElementById("modalDownloadBtn").href =
        "/file/download/" + googleId;

    scale = 1;

    translateX = 0;
    translateY = 0;

    isZoomed = false;

    applyImageTransform();
}

function applyImageTransform() {

    modalImageTarget.style.transform =
        `translate(${translateX}px, ${translateY}px) scale(${scale})`;
}

function initSlider(sliderId) {

    const slider =
        document.getElementById(sliderId);

    if(!slider) return;

    const images =
        slider.querySelectorAll(".slider-image");

    const imageSrcList =
        [...images].map(img => img.src);

    images.forEach((img) => {

        img.addEventListener("click", (e) => {

            if(!img.classList.contains("active")) {
                return;
            }

            e.stopPropagation();

            const activeIndex =
                [...images].findIndex(el =>
                    el.classList.contains("active")
                );

            openModal(imageSrcList, activeIndex);
        });
    });

    if(images.length <= 1) {
        return;
    }

    const prevBtn =
        slider.querySelector(".prev");

    const nextBtn =
        slider.querySelector(".next");

    let currentIndex = 0;

    function showImage(index) {

        images.forEach(img => {
            img.classList.remove("active");
        });

        images[index].classList.add("active");
    }

    nextBtn.addEventListener("click", () => {

        currentIndex++;

        if(currentIndex >= images.length) {
            currentIndex = 0;
        }

        showImage(currentIndex);
    });

    prevBtn.addEventListener("click", () => {

        currentIndex--;

        if(currentIndex < 0) {
            currentIndex = images.length - 1;
        }

        showImage(currentIndex);
    });
}

initSlider("layoutSlider");
initSlider("complexSlider");

document.getElementById("modalClose")
    .addEventListener("click", closeModal);

document.getElementById("modalPrev")
    .addEventListener("click", () => {
        showModalImage(modalIndex - 1);
    });

document.getElementById("modalNext")
    .addEventListener("click", () => {
        showModalImage(modalIndex + 1);
    });

imageModal.addEventListener("click", (e) => {

    if(e.target === imageModal) {
        closeModal();
    }
});

document.addEventListener("keydown", (e) => {

    if(!imageModal.classList.contains("active")) {
        return;
    }

    if(e.key === "Escape") {
        closeModal();
    }

    if(e.key === "ArrowLeft") {
        showModalImage(modalIndex - 1);
    }

    if(e.key === "ArrowRight") {
        showModalImage(modalIndex + 1);
    }
});

document.addEventListener("dragstart", (e) => {
    e.preventDefault();
});

modalImage.addEventListener("mousedown", (e) => {

    if(!isZoomed) {
        return;
    }

    isDragging = true;

    startX = e.clientX - translateX;
    startY = e.clientY - translateY;
});

document.addEventListener("mousemove", (e) => {

    if(!isDragging) {
        return;
    }

    translateX =
        (e.clientX - startX) / scale;

    translateY =
        (e.clientY - startY) / scale;

    applyImageTransform();
});

document.addEventListener("mouseup", () => {

    isDragging = false;
});

document.getElementById("zoomInBtn")
    .addEventListener("click", () => {

        scale += 0.3;

        if(scale > 5) {
            scale = 5;
        }

        isZoomed = scale > 1;

        applyImageTransform();
    });

document.getElementById("zoomOutBtn")
    .addEventListener("click", () => {

        scale -= 0.3;

        if(scale < 1) {

            scale = 1;

            translateX = 0;
            translateY = 0;
        }

        isZoomed = scale > 1;

        applyImageTransform();
    });