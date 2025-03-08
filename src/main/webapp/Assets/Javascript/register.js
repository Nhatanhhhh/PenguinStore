(function ($) {
    "use strict";


    /*==================================================================
     [ Validate ]*/
    var input = $('.validate-input .input100');

    $('.validate-form').on('submit', function () {
        var check = true;

        for (var i = 0; i < input.length; i++) {
            if (validate(input[i]) == false) {
                showValidate(input[i]);
                check = false;
            }
        }

        return check;
    });


    $('.validate-form .input100').each(function () {
        $(this).focus(function () {
            hideValidate(this);
        });
    });

    function showValidate(input) {
        var thisAlert = $(input).parent();

        $(thisAlert).addClass('alert-validate');
    }

    function hideValidate(input) {
        var thisAlert = $(input).parent();

        $(thisAlert).removeClass('alert-validate');
    }

    /*==================================================================
     [ Show pass ]*/
    var showPass = 0;
    $('.btn-show-pass').on('click', function () {
        if (showPass == 0) {
            $(this).next('input').attr('type', 'text');
            $(this).find('i').removeClass('fa-eye');
            $(this).find('i').addClass('fa-eye-slash');
            showPass = 1;
        } else {
            $(this).next('input').attr('type', 'password');
            $(this).find('i').removeClass('fa-eye-slash');
            $(this).find('i').addClass('fa-eye');
            showPass = 0;
        }

    });


})(jQuery);

document.addEventListener("DOMContentLoaded", function () {
    const password = document.getElementById("password");
    const confirmPassword = document.getElementById("confirm_password");
    const passwordError = document.getElementById("passwordError");

    function validatePasswordMatch() {
        if (password.value !== confirmPassword.value) {
            passwordError.style.display = "block";
            confirmPassword.setCustomValidity("Passwords do not match");
        } else {
            passwordError.style.display = "none";
            confirmPassword.setCustomValidity("");
        }
    }

    password.addEventListener("input", validatePasswordMatch);
    confirmPassword.addEventListener("input", validatePasswordMatch);
});

document.addEventListener("DOMContentLoaded", function () {
    const password = document.getElementById("password");
    const confirmPassword = document.getElementById("confirm_password");
    const email = document.getElementById("email");
    const phone = document.getElementById("phone");

    const passwordError = document.getElementById("passwordError");
    const passwordStrength = document.getElementById("passwordStrength");
    const emailError = document.getElementById("emailError");
    const phoneError = document.getElementById("phoneError");

    function validateEmail() {
        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (!emailRegex.test(email.value)) {
            emailError.style.display = "block";
            email.classList.add("input-error");
            return false;
        } else {
            emailError.style.display = "none";
            email.classList.remove("input-error");
            return true;
        }
    }

    function validatePhone() {
        const phoneRegex = /^[0-9]{10,11}$/;
        if (!phoneRegex.test(phone.value)) {
            phoneError.style.display = "block";
            phone.classList.add("input-error");
            return false;
        } else {
            phoneError.style.display = "none";
            phone.classList.remove("input-error");
            return true;
        }
    }

    function validatePasswordStrength() {
        const strongRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

        if (password.value.length < 8) {
            passwordStrength.innerText = "⚠️ Password must be at least 8 characters";
            passwordStrength.style.color = "red";
            passwordStrength.style.display = "block";
        } else if (!strongRegex.test(password.value)) {
            passwordStrength.innerText = "⚠️ Must contain uppercase, lowercase, number, and special character";
            passwordStrength.style.color = "orange";
            passwordStrength.style.display = "block";
        } else {
            passwordStrength.innerText = "✅ Strong password";
            passwordStrength.style.color = "green";
            passwordStrength.style.display = "block";
        }
    }

    function validatePasswordMatch() {
        if (password.value !== confirmPassword.value) {
            passwordError.style.display = "block";
            confirmPassword.classList.add("input-error");
            confirmPassword.setCustomValidity("Passwords do not match");
        } else {
            passwordError.style.display = "none";
            confirmPassword.classList.remove("input-error");
            confirmPassword.setCustomValidity("");
        }
    }

    // Kiểm tra khi người dùng nhập
    password.addEventListener("input", function () {
        validatePasswordStrength();
        validatePasswordMatch();
    });
    confirmPassword.addEventListener("input", validatePasswordMatch);
    email.addEventListener("input", validateEmail);
    phone.addEventListener("input", validatePhone);
});


