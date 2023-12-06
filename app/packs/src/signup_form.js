$(document).ready(() => {
    $("label[for='registration_user_birth_date'] select").wrapAll('<div class="select-date-container">');

    // Sélection des éléments du DOM
    const passwordInput = document.getElementById('registration_user_password');
    const confirmPasswordInput = document.getElementById('registration_user_password_confirmation');
    const userNameInput = document.getElementById('registration_user_name');
    const userNicknameInput = document.getElementById('registration_user_nickname');
    const userNicknameField = document.querySelector('.user-nickname');
    const fieldElements = document.querySelectorAll('.field');

    // Masquer la classe "user-nickname"
    userNicknameField.style.display = 'none';

    // Masquer la classe "field" contenant la classe "registration_user_password_confirmation"
    fieldElements.forEach(field => {
    const confirmPasswordField = field.querySelector('#registration_user_password_confirmation');
    if (confirmPasswordField !== null) {
        field.style.display = 'none';
    }
    });

    // // Écouteur d'événement sur le champ du mot de passe
    passwordInput.addEventListener('input', function() {
        // If there is a form-error behind the password field, remove it
        const passwordField = passwordInput.parentElement;
        const passwordError = passwordField.querySelector('.form-error');
        if (passwordError !== null) {
            changeMessage(passwordError)
        }

        confirmPasswordInput.value = passwordInput.value;
    });

    function changeMessage(passwordError) {
        const password = passwordInput.value;
        const passwordLength = password.length;

        if (passwordLength < 10) {
            passwordError.textContent = 'Le mot de passe doit contenir au moins 10 caractères.';
        }
    }

    // Génération automatique du surnom à partir du champ du nom
    userNameInput.addEventListener('input', function() {
        const userName = userNameInput.value.toLowerCase().replace(/\s/g, '_').replace(/[^\w\s]/gi, ''); // Remplacement des espaces par des underscores, suppression des caractères spéciaux et mise en minuscules
        const randomNum = Math.floor(100000 + Math.random() * 900000); // Génération d'un nombre aléatoire à 6 chiffres
        const generatedNickname = userName + '_' + randomNum;

        // Remplissage automatique du champ du surnom
        userNicknameInput.value = generatedNickname.substr(0, 20); // Limite le surnom à 20 caractères

        // Cacher les champs générés automatiquement
        confirmPasswordInput.style.display = 'none'; // Cacher le champ de confirmation du mot de passe
        userNicknameInput.style.display = 'none'; // Cacher le champ du surnom
    });
})
