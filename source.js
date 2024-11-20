var elemContent = document.getElementById("articleContent");
var elemIndex = document.getElementById("index");
var indexButtons = elemIndex.querySelectorAll("button[data-url]");
var isFetching = false;
const mobileViewAspectRatio = 1.0;

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


//RESIZING

function OnResize() {
    var aspect = window.innerWidth / window.innerHeight;
    if (aspect <= mobileViewAspectRatio) {
        elemIndex.hidden = true;
    }
    else {
        elemIndex.hidden = false;
    }

    console.log('New aspect: ' + aspect);
    console.log('New width: ' + window.innerWidth);
    console.log('New height: ' + window.innerHeight);
}

window.addEventListener('resize', OnResize);
OnResize();
