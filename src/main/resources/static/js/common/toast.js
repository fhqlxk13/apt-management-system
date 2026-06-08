function showToast({
                       title = "알림",
                       message = "",
                       type = "success",
                       duration = 4000,
                       onClick = null
                   }) {

    const container =
        document.getElementById("toastContainer");

    if (!container) {
        console.warn("toastContainer 없음");
        return;
    }

    const toast =
        document.createElement("div");

    toast.className = `toast ${type}`;

    toast.innerHTML = `
        <button class="toast-close">
            ×
        </button>

        <div class="toast-title">
            ${title}
        </div>

        <div class="toast-message">
            ${message}
        </div>
    `;

    if (onClick) {

        toast.addEventListener("click", function(e){

            if(
                e.target.classList.contains(
                    "toast-close"
                )
            ){
                return;
            }

            onClick();
        });
    }

    const closeBtn =
        toast.querySelector(".toast-close");

    closeBtn.addEventListener("click", function(e){

        e.stopPropagation();

        hideToast(toast);
    });

    container.appendChild(toast);

    const timer = setTimeout(() => {

        hideToast(toast);

    }, duration);

    toast.addEventListener("mouseenter", () => {
        clearTimeout(timer);
    });
}

function hideToast(toast){

    toast.classList.add("hide");

    setTimeout(() => {
        toast.remove();
    }, 250);
}