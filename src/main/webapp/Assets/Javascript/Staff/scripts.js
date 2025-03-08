/*!
 * Start Bootstrap - SB Admin v7.0.7 (https://startbootstrap.com/template/sb-admin)
 * Copyright 2013-2023 Start Bootstrap
 * Licensed under MIT (https://github.com/StartBootstrap/startbootstrap-sb-admin/blob/master/LICENSE)
 */
// 
// Scripts
// 

window.addEventListener('DOMContentLoaded', event => {

    // Toggle the side navigation
    const sidebarToggle = document.body.querySelector('#sidebarToggle');
    if (sidebarToggle) {
        // Uncomment Below to persist sidebar toggle between refreshes
        // if (localStorage.getItem('sb|sidebar-toggle') === 'true') {
        //     document.body.classList.toggle('sb-sidenav-toggled');
        // }
        sidebarToggle.addEventListener('click', event => {
            event.preventDefault();
            document.body.classList.toggle('sb-sidenav-toggled');
            localStorage.setItem('sb|sidebar-toggle', document.body.classList.contains('sb-sidenav-toggled'));
        });
    }

});

document.addEventListener("DOMContentLoaded", function () {
    let table = new simpleDatatables.DataTable("#feedbackTable", {
        searchable: true,
        perPage: 10,
        perPageSelect: [5, 10, 25, 50, 100],
    });

    // Đợi DataTable load xong, sau đó set màu lại
    table.on('datatable.init', function () {
        document.querySelectorAll("#feedbackTable td").forEach(td => {
            if (td.textContent.trim() === "Viewed" || td.textContent.trim() === "Resolved") {
                td.style.color = "#28a745"; // Màu xanh
                td.style.fontWeight = "bold";
            } else if (td.textContent.trim() === "Not Viewed" || td.textContent.trim() === "Pending") {
                td.style.color = "#dc3545"; // Màu đỏ
                td.style.fontWeight = "bold";
            }
        });
    });

});
