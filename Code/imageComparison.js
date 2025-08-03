var maximizableElements = [];
var elemDraggable = null;

function AddVideos() {
    var allDataVideos = elemContent.querySelectorAll("div[data-video]");
    allDataVideos.forEach((dataVideo) => {
        const attr = dataVideo.getAttribute("data-video");
        const data = JSON.parse(attr);

        const elemVideo = document.createElement("video");
        elemVideo.className = "video-container";
        elemVideo.src = data.video;
        elemVideo.innerHTML = "Your browser does not support video tag";

        elemVideo.controls = true;
        elemVideo.muted = true;

        if (data.poster != null) {
            elemVideo.poster = data.poster;
        }

        dataVideo.replaceWith(elemVideo);
    });
}

function AddInputToImageComparisons() {
    var isMobile = window.mobileCheck();
    maximizableElements = [];

    var allDataImages = elemContent.querySelectorAll("div[data-image]");
    allDataImages.forEach((dataImage) => {
        const attr = dataImage.getAttribute("data-image");

        var isJson = attr.startsWith("{");
        const data = isJson ? JSON.parse(attr) : null;
        var isComparison = isJson && data.images != null && data.images.length > 1;

        const imageContainer = document.createElement("div");
        imageContainer.className = "image-container";

        // Add the first image
        const img1 = document.createElement('img');
        img1.src = isJson ? data.images[0] : attr;
        imageContainer.appendChild(img1);

        // Add the second image
        if (isComparison) {
            const img2 = document.createElement('img');
            img2.src = data.images[1];
            imageContainer.appendChild(img2);

            const slider = document.createElement('input');
            slider.type = 'range';
            slider.className = 'image-slider';
            slider.value = data.sliderValue == null ? 50 : data.sliderValue;
            imageContainer.appendChild(slider);

            // Add the middle bar div
            const middleBar = document.createElement('div');
            middleBar.className = 'image-middleBar';
            if (data.alwaysVisibleMiddleBar != null && data.alwaysVisibleMiddleBar == true)
            {
                //middleBar.style.opacity = 0.3;
                middleBar.className += " image-middleBarAlwaysVisible";
            }

            middleBar.appendChild(document.createElement('div')); // Inner div
            imageContainer.appendChild(middleBar);
        }

        if (isJson) {
            if (data.texts != null) {
                // Add the first text
                const text1 = document.createElement('p');
                text1.textContent = data.texts[0];
                imageContainer.appendChild(text1);
                if (data.images.length == 1) text1.style.bottom = "0px";

                if (data.texts.length > 1) {
                    // Add the second text
                    const text2 = document.createElement('p');
                    text2.textContent = data.texts[1];
                    imageContainer.appendChild(text2);
                    if (data.images.length == 1) text2.style.bottom = "0px";
                }
                else {
                    text1.style.textAlign = "right";
                    text1.style.clipPath = "none";
                }
            }
        }

        if (!isJson || data.maximizable == true) {
            // Add the maximize button
            const maximizeButton = document.createElement('input');
            maximizeButton.type = 'image';
            maximizeButton.className = 'image-maximize';
            imageContainer.appendChild(maximizeButton);
        }

        // Replace the original container with the new structure
        dataImage.replaceWith(imageContainer);
    });

    var allComparisons = elemContent.querySelectorAll(".image-container");
    allComparisons.forEach((comparison) => {
        comparison.realParent = comparison.parentElement;
        comparison.realChildIndex = Array.prototype.indexOf.call(comparison.realParent.children, comparison);
        var allImages = comparison.querySelectorAll("img");
        var allParagraphs = comparison.querySelectorAll("p");
        var leftParagraph = allParagraphs[0];
        var rightParagraph = allParagraphs[1];
        var overlayImg = allImages[1];

        var maximize = comparison.querySelector(".image-maximize");
        if (maximize != null) {
            comparison.maximizableIndex = maximizableElements.length;
            maximizableElements.push(comparison);
            maximize.addEventListener("click", () => {
                if (isInFullscreen) ExitFullScreen();
                else EnterFullScreen(comparison);
            });

            maximize.src = "GlobalImages/maximize.png";
            maximize.type = "image";
        }

        var slider = comparison.querySelector(".image-slider");

        if (slider != null) {
            comparison.slider = slider;
            slider.middleBar = comparison.querySelector(".image-middleBar");

            if (isMobile && slider.middleBar != null) {
                comparison.removeChild(slider.middleBar);
            }

            slider.min = 0;
            slider.max = 100;
            slider.step = 0.1;

            slider.updateComparisonClip = function () {
                overlayImg.style.clipPath = `inset(0 0 0 ${slider.value}%`;
                rightParagraph.style.clipPath = `inset(0 0 0 ${slider.value}%`;
                leftParagraph.style.clipPath = `inset(0 ${100.0 - slider.value}% 0 0`;
                if (slider.middleBar != null) {
                    slider.middleBar.style.left = `${slider.value}%`;
                }
            };
            slider.updateComparisonClip();

            slider.addEventListener("input", (event) => slider.updateComparisonClip());

            if (slider.middleBar != null) {
                slider.middleBar.slider = slider;
                slider.middleBar.addEventListener("mousedown", (e) => {
                    elemDraggable = slider.middleBar;
                    document.body.style.userSelect = 'none';
                });
            }
        }
    });
}

document.addEventListener("mouseup", (e) => {
    elemDraggable = null;
    document.body.style.userSelect = '';
});

document.addEventListener("mousemove", (e) => {
    if (elemDraggable == null) {
        return;
    }

    var mouseX = e.clientX;
    var rect = elemDraggable.parentElement.getBoundingClientRect();
    var maxWidth = rect.width;
    var offsetX = rect.left;

    var left = Math.min(100, Math.max(0, ((mouseX - offsetX) / maxWidth) * 100));
    elemDraggable.style.left = `${left}%`;

    if (left > 99.9) left = 100.0;
    if (left < 0.01) left = 0.0;

    elemDraggable.slider.value = left;
    elemDraggable.slider.updateComparisonClip();
});