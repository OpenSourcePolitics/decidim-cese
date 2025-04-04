// disable the prompt for pwa
(() => {
    if (localStorage.getItem("pwaInstallPromptSeen") !== 'true') {
        localStorage.setItem("pwaInstallPromptSeen", true);
    }
})();
