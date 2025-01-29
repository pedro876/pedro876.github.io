var elemFullscreen = document.getElementById("fullscreen");
var elemButtonFullscreenRight = document.getElementById("fullscreenRight");
var elemButtonFullscreenLeft = document.getElementById("fullscreenLeft");
var isInFullscreen = false;

function EnterFullScreen(element) {
    console.log("Entering full screen mode");
    elemFullscreen.appendChild(element);
    elemFullscreen.style.display = "flex";
    document.body.style.overflow = "hidden";
    element.style.marginTop = "0px";
    element.style.marginBottom = "0px";
    element.style.maxHeight = "100vh";
    var maximizeButton = element.querySelector(".image-maximize");
    maximizeButton.src = "GlobalImages/minimize.png";

    var images = element.querySelectorAll("img");
    images.forEach((image) => {
        image.style.maxHeight = "100vh";
    });

    isInFullscreen = true;
    CheckFullscreenButtonsVisibility();
}

function ExitFullScreen() {
    console.log("Exiting full screen mode");
    var element = elemFullscreen.lastElementChild;

    element.style.marginTop = "";
    element.style.marginBottom = "";
    element.style.maxHeight = "";

    var images = element.querySelectorAll("img");
    images.forEach((image) => {
        image.style.maxHeight = "";
    });

    var maximizeButton = element.querySelector(".image-maximize");
    maximizeButton.src = "GlobalImages/maximize.png";

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
}

function NavigateFullscreen(dir) {
    if (!isInFullscreen) return;
    var newIndex = elemFullscreen.lastElementChild.maximizableIndex + dir;
    if (newIndex >= 0 && newIndex < maximizableElements.length) {
        ExitFullScreen();
        EnterFullScreen(maximizableElements[newIndex]);
    }
}

function CheckFullscreenButtonsVisibility() {
    if (!isInFullscreen) return;
    elemButtonFullscreenLeft.hidden = elemFullscreen.lastElementChild.maximizableIndex == 0;
    elemButtonFullscreenRight.hidden = elemFullscreen.lastElementChild.maximizableIndex == maximizableElements.length - 1;
}

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

elemButtonFullscreenLeft.addEventListener("click", () => NavigateFullscreen(-1));
elemButtonFullscreenRight.addEventListener("click", () => NavigateFullscreen(1));