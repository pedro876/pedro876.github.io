var elemContent = document.getElementById("articleContent");
var elemIndex = document.getElementById("index");
var indexButtons = elemIndex.querySelectorAll("button[data-url]");
var elemButtonIndex = document.getElementById("buttonIndex");
var elemTopBarRightContent = document.getElementById("topBarRightContent");

var isFetching = false;
var mobileShowIndex = false;
const mobileViewAspectRatio = 1.17;

//RESPONSIVE RESIZING
function OnResize() {
    var aspect = window.innerWidth / window.innerHeight;
    //console.log("new aspect ratio: " + aspect);
    if (aspect <= mobileViewAspectRatio) {
        //Portrait View
        elemIndex.hidden = !mobileShowIndex;
        elemContent.hidden = mobileShowIndex;
        elemButtonIndex.hidden = false;
        //elemTopBarRightContent.hidden = true;

        //Portrait Style
        elemIndex.style.flex = 'auto';
        elemIndex.style.width = '100%';
        elemContent.style.paddingLeft = '20px';
        elemContent.style.paddingRight = '20px';
    }
    else {
        //Landscape View
        mobileShowIndex = false;
        elemIndex.hidden = false;
        elemContent.hidden = false;
        elemButtonIndex.hidden = true;
        //elemTopBarRightContent.hidden = false;


        //Landscape Style
        elemIndex.style.flex = '';
        elemIndex.style.width = '';
        elemContent.style.paddingLeft = '';
        elemContent.style.paddingRight = '';
    }

    console.log(window.innerWidth);
    elemTopBarRightContent.hidden = window.innerWidth < 700;
    elemTopBarRightContent.style.display = window.innerWidth < 700 ? 'none' : 'grid';
}

function ToggleIndex()
{
    mobileShowIndex = !mobileShowIndex;
    OnResize();
}

elemButtonIndex.addEventListener('click', ToggleIndex);
window.addEventListener('resize', OnResize);
OnResize();

//NAVIGATION
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
            if (mobileShowIndex) ToggleIndex();
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