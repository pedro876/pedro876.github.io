
const baseURL = window.location.href.split("?")[0];
var indexButtons = elemIndex.querySelectorAll("button[data-url]");
var isFetching = false;

function SetEnableAllButtons(enabled) {
    indexButtons.forEach((indexButton) => {
        indexButton.disabled = !enabled;
    });
}

function DataUrlToFileName(dataURL) {
    var articleName = dataURL.split("/");
    articleName = articleName[articleName.length - 1];
    articleName = articleName.split(".");
    articleName = articleName[0];
    return articleName;
}

function AddButtonClickBehaviour(elemButton) {
    elemButton.loadContent = function () {
        if (isFetching) return;
        if (isInFullscreen) ExitFullScreen();
        isFetching = true;
        var articlePath = elemButton.getAttribute("data-url");
        fetch(articlePath).then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok ' + response.statusText);
            }
            return response.text();
        }).then(html => {
            elemContent.innerHTML = html;
            SetEnableAllButtons(true);
            AddInputToImageComparisons();
            AddVideos();
            ProcessCode();
            elemButton.disabled = true;
            isFetching = false;
            if (mobileShowIndex) ToggleIndex();

            var articleName = DataUrlToFileName(articlePath);
            var url = `${baseURL}?article=${encodeURIComponent(articleName)}`;
            if (window.location.href != url) {
                window.history.pushState(null, "", url);
                console.log("New url: ", url);
            }
        }).catch(error => {
            console.error('There was a problem with the fetch operation:', error);
        });
    };

    elemButton.addEventListener('click', elemButton.loadContent);
}

indexButtons.forEach((indexButton) => {
    AddButtonClickBehaviour(indexButton);
});

function LoadURLArticle() {
    var urlParams = new URLSearchParams(new URL(window.location.href).search);
    var loadArticle = urlParams.has("article") ? urlParams.get("article") : "contact";
    console.log("Load article: ", loadArticle);

    indexButtons.forEach((indexButton) => {
        var articleName = DataUrlToFileName(indexButton.getAttribute("data-url"));
        if (articleName == loadArticle) {
            indexButton.loadContent();
        }
    });
}

window.addEventListener("popstate", (event) => LoadURLArticle());
LoadURLArticle();