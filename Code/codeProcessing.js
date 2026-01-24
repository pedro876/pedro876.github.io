function CodeSetup() {
    var allCodes = elemContent.querySelectorAll("pre code");
    allCodes.forEach((codeElem) => {
        let text = codeElem.textContent;
        if (text.startsWith("\n")) {
            text = text.slice(1);
        }
        let lines = text.split('\n');
        let match = lines[0].match(/^ +/);
        let spaceCount = match ? match[0].length : 0;
        if (spaceCount > 0) {
            const spaceRegex = new RegExp(`^ {0,${spaceCount}}`);

            text = lines
                .map(line => line.replace(spaceRegex, ''))
                .join('\n');
        }
        codeElem.textContent = text;


        //codeElem.style.background = "var(--codeBackgroundColor)";
        const language = codeElem.getAttribute("data-lang"); // Default to plaintext if no language specified
        if (language != null) {
            const worker = new Worker("/Code/highlightWorker.js");
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
    });
}