function CodeSetup() {
    var allCodes = elemContent.querySelectorAll(".code");
    allCodes.forEach((codeElem) => {
        function OnCodeElemLoaded(codeElem) {
            codeElem.style.background = "var(--codeBackgroundColor)";
            const language = codeElem.getAttribute("data-lang"); // Default to plaintext if no language specified
            if (language != null) {
                const worker = new Worker("Code/highlightWorker.js");
                worker.onmessage = (event) => {
                    if (codeElem.isConnected) {
                        codeElem.innerHTML = event.data;
                        console.log("Worker finished highlighting");
                    }
                };
                worker.postMessage({
                    code: codeElem.textContent,
                    language: language
                });
            }
            //if (language != null) {
            //    codeElem.classList.add(`language-${language}`); // Add language class
            //    hljs.highlightElement(codeElem);
            //}
        }

        const url = codeElem.getAttribute("data-url");
        if (url != null) {
            console.log("Fetching code file: " + url);
            fetch(url).then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok ' + response.statusText);
                }
                return response.text();
            }).then(result => {
                if (codeElem.isConnected) {
                    codeElem.innerHTML = result;
                    OnCodeElemLoaded(codeElem);
                }
            }).catch(error => {
                console.error('There was a problem with the fetch operation:', error);
            });
        }
        else {
            OnCodeElemLoaded(codeElem);
        }
    });
}