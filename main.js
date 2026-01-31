// loader.js
const scripts = [
    '/Code/highlight/highlight.min.js',
    '/Code/highlightjs-hlsl/dist/hlsl.min.js',
    '/Code/responsive.js',
    '/Code/fullscreen.js',
    '/Code/codeProcessing.js',
    '/Code/tables.js',
    '/Code/imageComparison.js',
    '/Code/navigation.js'
];

async function LoadScriptSequentially() {
    for (const src of scripts) {
        await new Promise((resolve, reject) => {
            const script = document.createElement('script');
            script.src = src;
            script.onload = resolve;
            script.onerror = () => reject(new Error(`Failed to load ${src}`));
            document.head.appendChild(script);
        });
    }
}

async function Main() {
    await LoadScriptSequentially();
    await LoadStructure();
    await LoadIndex();
    ResponsiveSetup();
    document.documentElement.classList.remove("loading");
    FullScreenSetup();
    CodeSetup();
    TablesSetup();
    ImagesSetup();
    ProcessArticleGrid();
}

Main();
