var elemContent = document.getElementById("articleContent");
var elemIndex = document.getElementById("index");
var indexButtons = elemIndex.querySelectorAll("button[data-url]");
var isFetching = false;

function SetEnableAllButtons(enabled) {
    indexButtons.forEach((indexButton) => {
        indexButton.disabled = !enabled;
    });
}

function AddButtonClickBehaviour(elemButton) {
    elemButton.loadContent = function () {
        if (isFetching) return;
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
            elemButton.disabled = true;
            isFetching = false;
        }).catch(error => {
            console.error('There was a problem with the fetch operation:', error);
        });


    };

    elemButton.addEventListener('click', elemButton.loadContent);
}


indexButtons.forEach((indexButton) => {
    AddButtonClickBehaviour(indexButton);
});

//Use this to load a certain page instantly
indexButtons[0].loadContent();

