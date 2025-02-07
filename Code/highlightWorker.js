//https://github.com/highlightjs/highlight.js?tab=readme-ov-file#using-web-workers

onmessage = (event) => {
    importScripts('highlight/highlight.min.js', 'highlightjs-hlsl/dist/hlsl.min.js');
    const { code, language } = event.data;
    var result;
    if (language == "auto") {
        result = self.hljs.highlightAuto(code);
    }
    else {
        result = self.hljs.highlight(code, {language});
    }

    postMessage(result.value);
};