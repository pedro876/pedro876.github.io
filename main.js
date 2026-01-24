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

//function LoadScriptSequentially(scripts, index = 0) {
//    if (index >= scripts.length) return; // Done
//    const script = document.createElement('script');
//    script.src = scripts[index];
//    script.onload = () => LoadScriptSequentially(scripts, index + 1); // Load next after current
//    script.onerror = () => console.error(`Failed to load ${scripts[index]}`);
//    document.head.appendChild(script);
//}

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
    FullScreenSetup();
    CodeSetup();
    TablesSetup();
    ImagesSetup();
    ProcessArticleGrid();
}

Main();
