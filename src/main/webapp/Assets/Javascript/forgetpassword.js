document.addEventListener("DOMContentLoaded", function () {
    const emailInput = document.getElementById("email");
    const form = document.querySelector("form");

    let errorMessage = document.createElement("div");
    errorMessage.style.color = "red";
    errorMessage.style.fontSize = "14px";
    errorMessage.style.marginTop = "5px";
    errorMessage.style.display = "none"; 
    emailInput.parentNode.appendChild(errorMessage);

    function validateEmail(email) {
        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        return emailRegex.test(email);
    }

    emailInput.addEventListener("input", function () {
        if (!validateEmail(emailInput.value)) {
            errorMessage.textContent = "⚠️ Email không hợp lệ. Hãy nhập đúng định dạng (ví dụ: example@gmail.com).";
            errorMessage.style.display = "block";
            emailInput.classList.add("is-invalid"); // Bootstrap: viền đỏ
        } else {
            errorMessage.style.display = "none";
            emailInput.classList.remove("is-invalid");
        }
    });

    form.addEventListener("submit", function (event) {
        if (!validateEmail(emailInput.value)) {
            event.preventDefault(); // Ngăn chặn form gửi đi
            errorMessage.textContent = "⚠️ Email không hợp lệ. Vui lòng nhập lại!";
            errorMessage.style.display = "block";
            emailInput.classList.add("is-invalid");
        }
    });
});
