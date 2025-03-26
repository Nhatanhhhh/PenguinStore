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
        $(thisAlert).addClass('alert-validate'); // Add error styles
        $(thisAlert).find('.error-message').show(); // Show the error message
    }

    function hideValidate(input) {
        var thisAlert = $(input).parent();
        $(thisAlert).removeClass('alert-validate'); // Remove error styles
        $(thisAlert).find('.error-message').hide(); // Hide the error message
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
    // Set custom validation messages
    window.ub.form.validationMessages.username.required = 'You forgot to enter your name!';
    window.ub.form.validationMessages.email.email = "That doesn't seem to be a valid email!";
    window.ub.form.validationMessages.phone.phone = "Phone number must be 10-11 digits!";

    // Email validation
    const emailInput = document.getElementById("email");
    const emailError = document.getElementById("emailError");

    emailInput.addEventListener("input", function () {
        const emailValue = emailInput.value.trim();
        const isValidEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailValue);

        if (!isValidEmail) {
            emailError.style.display = "block"; // Show error message
            emailInput.classList.add("error");  // Add error class to input
            emailError.innerText = window.ub.form.validationMessages.email.email;  // Show custom message
        } else {
            emailError.style.display = "none"; // Hide error message
            emailInput.classList.remove("error");  // Remove error class
            emailInput.classList.add("success");  // Add success class
        }
    });

    // Password validation
    const passwordInput = document.getElementById("password");
    const passwordError = document.getElementById("passwordError");

    passwordInput.addEventListener("input", function () {
        const passwordValue = passwordInput.value.trim();
        const isValidPassword = passwordValue.length >= 8;

        if (!isValidPassword) {
            passwordError.style.display = "block"; // Show error message
            passwordInput.classList.add("error");  // Add error class to input
            passwordError.innerText = "Password must be at least 8 characters"; // Custom message
        } else {
            passwordError.style.display = "none"; // Hide error message
            passwordInput.classList.remove("error");  // Remove error class
            passwordInput.classList.add("success");  // Add success class
        }
    });

    // Phone number validation
    const phoneInput = document.getElementById("phone");
    const phoneError = document.getElementById("phoneError");

    phoneInput.addEventListener("input", function () {
        const phoneValue = phoneInput.value.trim();
        const isValidPhone = /^\d{10,11}$/.test(phoneValue);

        if (!isValidPhone) {
            phoneError.style.display = "block"; // Show error message
            phoneInput.classList.add("error");  // Add error class to input
            phoneError.innerText = window.ub.form.validationMessages.phone.phone;  // Show custom message
        } else {
            phoneError.style.display = "none"; // Hide error message
            phoneInput.classList.remove("error");  // Remove error class
            phoneInput.classList.add("success");  // Add success class
        }
    });

    // Form submission validation
    const form = document.querySelector(".register100-form");
    form.addEventListener("submit", function (event) {
        const phoneValue = phoneInput.value.trim();
        const isValidPhone = /^\d{10,11}$/.test(phoneValue);

        // If the phone number is not valid, prevent form submission
        if (!isValidPhone) {
            event.preventDefault();  // Prevent form submission if invalid
            phoneError.style.display = "block"; // Show error tooltip
        }
    });
});

