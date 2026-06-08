function toggleSidebar() {
  var s = document.getElementById("sidebar");
  if (s) s.classList.toggle("collapsed");
}

document.addEventListener("DOMContentLoaded", function () {
  var collapseBtn = document.getElementById("btnCollapseSidebar");
  if (collapseBtn) {
    collapseBtn.addEventListener("click", toggleSidebar);
  }

  var logoIcon = document.getElementById("logoIcon");
  if (logoIcon) {
    logoIcon.addEventListener("click", function () {
      var s = document.getElementById("sidebar");
      if (s && s.classList.contains("collapsed")) toggleSidebar();
    });
  }
});
