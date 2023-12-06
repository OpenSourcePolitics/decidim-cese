$(() => {
    const $userRegistrationForm = $("#register-form");
    const $userGroupFields      = $userRegistrationForm.find(".user-group-fields");
    const inputSelector         = 'input[name="user[sign_up_as]"]';
    const newsletterSelector    = 'input[type="checkbox"][name="user[newsletter]"]';
    const $newsletterModal      = $("#sign-up-newsletter-modal");


    const setGroupFieldsVisibility = (value) => {
        if (value === "user") {
            $userGroupFields.hide();
        } else {
            $userGroupFields.show();
        }
    }

    setGroupFieldsVisibility($userRegistrationForm.find(`${inputSelector}:checked`).val());

    $userRegistrationForm.on("change", inputSelector, (event) => {
        const value = event.target.value;

        setGroupFieldsVisibility(value);
    });
});