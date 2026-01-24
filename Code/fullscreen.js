var elemFullscreen;
var elemButtonFullscreenRight;
var elemButtonFullscreenLeft;
var isInFullscreen;

function EnterFullScreen(element, isChange = false) {
    if (!isChange && document.fullscreenElement && document.exitFullscreen) {
        document.exitFullscreen();
    }

    console.log("Entering full screen mode");
    elemFullscreen.appendChild(element);
    elemFullscreen.style.display = "flex";
    document.body.style.overflow = "hidden";
    element.style.marginTop = "0px";
    element.style.marginBottom = "0px";
    element.style.maxHeight = "100vh";
    var maximizeButton = element.querySelector(".image-maximize");
    maximizeButton.src = "/GlobalImages/minimize.png";

    var images = element.querySelectorAll("img");
    images.forEach((image) => {
        image.style.height = "100vh";
        image.style.width = "auto";
        image.style.maxWidth = "100vw";
        image.style.objectFit = "contain";
    });

    isInFullscreen = true;
    CheckFullscreenButtonsVisibility();

    if (!isChange)
        elemFullscreen.requestFullscreen();
}

function ExitFullScreen(isChange = false) {
    console.log("Exiting full screen mode");
    var element = elemFullscreen.lastElementChild;

    element.style.marginTop = "";
    element.style.marginBottom = "";
    element.style.maxHeight = "";

    var images = element.querySelectorAll("img");
    images.forEach((image) => {
        image.style.height = "";
        image.style.width = "";
        image.style.maxWidth = "";
        image.style.objectFit = "";
    });

    var maximizeButton = element.querySelector(".image-maximize");
    maximizeButton.src = "/GlobalImages/maximize.png";

    var realParent = element.realParent;
    if (element.realChildIndex >= realParent.children.length) {
        realParent.appendChild(element);
    }
    else {
        realParent.insertBefore(element, realParent.children[element.realChildIndex]);
    }

    elemFullscreen.style.display = "none";
    document.body.style.overflow = "";
    isInFullscreen = false;

    if (!isChange && document.fullscreenElement && document.exitFullscreen)
        document.exitFullscreen();
}

function NavigateFullscreen(dir) {
    if (!isInFullscreen) return;
    var newIndex = elemFullscreen.lastElementChild.maximizableIndex + dir;
    if (newIndex >= 0 && newIndex < maximizableElements.length) {
        ExitFullScreen(true);
        EnterFullScreen(maximizableElements[newIndex], true);
    }
}

function CheckFullscreenButtonsVisibility() {
    if (!isInFullscreen) return;
    elemButtonFullscreenLeft.hidden = elemFullscreen.lastElementChild.maximizableIndex == 0;
    elemButtonFullscreenRight.hidden = elemFullscreen.lastElementChild.maximizableIndex == maximizableElements.length - 1;
}



function FullScreenSetup() {
    elemFullscreen = document.getElementById("fullscreen");
    elemButtonFullscreenRight = document.getElementById("fullscreenRight");
    elemButtonFullscreenLeft = document.getElementById("fullscreenLeft");
    isInFullscreen = false;

    document.addEventListener("keydown", (event) => {
        if (event.key === "Escape") {
            if (isInFullscreen) {
                ExitFullScreen();
            }
        }
        else if (event.key === "ArrowLeft" && isInFullscreen) {
            NavigateFullscreen(-1);
        }
        else if (event.key === "ArrowRight" && isInFullscreen) {
            NavigateFullscreen(1);
        }
    });

    document.addEventListener("fullscreenchange", () => {
        if (document.fullscreenElement === null && isInFullscreen) {
            ExitFullScreen();
        }
    });

    elemButtonFullscreenLeft.addEventListener("click", () => NavigateFullscreen(-1));
    elemButtonFullscreenRight.addEventListener("click", () => NavigateFullscreen(1));
}

