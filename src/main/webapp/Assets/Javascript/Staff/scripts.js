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
        sidebarToggle.addEventListener('click', event => {
            event.preventDefault();
            document.body.classList.toggle('sb-sidenav-toggled');
            localStorage.setItem('sb|sidebar-toggle', document.body.classList.contains('sb-sidenav-toggled'));
        });
    }

    // Khởi tạo DataTable
    let table = new simpleDatatables.DataTable("#feedbackTable", {
        searchable: true,
        perPage: 10,
        perPageSelect: [5, 10, 25, 50, 100],
        searchDebounce: 0 // Tìm kiếm ngay lập tức
    });

    // Khi nhập tìm kiếm, ép kiểu số để đảm bảo khớp dữ liệu
    const searchInput = document.querySelector("input[data-testid='datatable-search']");
    
    if (searchInput) {
        searchInput.addEventListener("input", function () {
            let searchText = this.value.trim();
            let numericSearch = parseFloat(searchText); // Chuyển thành số

            if (!isNaN(numericSearch)) {
                let formattedSearch = numericSearch.toFixed(1); // Ép kiểu thành '2.0'
                table.search(formattedSearch); // Tìm kiếm theo '2.0'
            } else {
                table.search(searchText); // Nếu không phải số, tìm kiếm bình thường
            }
        });
    }
});


