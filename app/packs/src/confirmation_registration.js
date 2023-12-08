$(document).ready(() => {
    $("#user_certification").on("change", function(e) {
        const certificationField = event.target.parentNode.parentNode;
        const certificationError = certificationField.querySelector('.form-error');

        if (certificationError) {
            certificationError.remove();
        }
    });

    $("#user_tos_agreement").on("change", function(e) {
        const tosField = event.target.parentNode.parentNode;
        const tosError = tosField.querySelectorAll('.form-error');

        if (tosError) {
            tosError.forEach(error => {
                error.remove();
            });
        }
    });

    $(".select-date-container").on("change", function(e) {
        const dateField = event.target.parentNode.parentNode;
        const dateError = dateField.querySelectorAll('.form-error');
        const invalidFields = dateField.querySelectorAll('.is-invalid-input');

        if (dateError) {
            dateError.forEach(error => {
                error.remove();
            });
        }

        if (invalidFields) {
            invalidFields.forEach(field => {
                field.classList.remove('is-invalid-input');
            });
        }
    });
});