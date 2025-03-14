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
    const passwordStrength = document.getElementById("passwordStrength");
    const passwordError = document.getElementById("passwordError");

    function validatePasswordStrength() {
        const strongRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
        const mediumRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$/;

        passwordStrength.classList.remove("alert-validate");

        if (password.value.length < 8) {
            passwordStrength.innerText = "⚠️ Password must be at least 8 characters";
            passwordStrength.style.color = "#FF0000";
            passwordStrength.style.display = "block";
        } else if (strongRegex.test(password.value)) {
            passwordStrength.innerText = "✅ Strong password!";
            passwordStrength.style.color = "#008000";
            passwordStrength.style.display = "block";
        } else if (mediumRegex.test(password.value)) {
            passwordStrength.innerText = "⚠️ Medium: Add special characters for a stronger password!";
            passwordStrength.style.color = "#FFA500";
            passwordStrength.style.display = "block";
        } else {
            passwordStrength.innerText = "⚠️ Weak: Add uppercase, number & special character!";
            passwordStrength.style.color = "#FF4500";
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

    // Kiểm tra khi nhập
    password.addEventListener("input", function () {
        validatePasswordStrength();
        validatePasswordMatch();
    });
    confirmPassword.addEventListener("input", validatePasswordMatch);
});

