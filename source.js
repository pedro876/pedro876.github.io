var elemContent = document.getElementById("articleContent");
var elemIndex = document.getElementById("index");

function AddButtonClickBehaviour(elemButton) {
    elemButton.addEventListener('click', () => {
        var articlePath = elemButton.getAttribute("data-url");
        fetch(articlePath).then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok ' + response.statusText);
            }
            return response.text();
        }).then(html => {
            elemContent.innerHTML = html;
        }).catch(error => {
            console.error('There was a problem with the fetch operation:', error);
        });
    });
}

var indexButtons = elemIndex.querySelectorAll("button[data-url]");
indexButtons.forEach((indexButton) => {
    AddButtonClickBehaviour(indexButton);
});