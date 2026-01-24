function ResetScroll() {
    window.scrollTo({
        top: 0,
        behavior: "smooth"
    });
}

function ProcessArticleGrid() {
    let grid = document.querySelector(".articles-grid");
    if (!grid) return;

    let ul = grid.firstElementChild;
    for (var child of ul.children) {
        let button = document.createElement("button");
        let link = child.firstElementChild.href;
        let name = child.firstElementChild.innerHTML;
        button.setAttribute("data-url", link);
        button.className = "article-grid-element";

        let img = document.createElement("img");
        let thumbnailPath = link.replace(".html", "_Thumbnail.jpg");
        img.src = thumbnailPath;
        img.alt = name;

        let p = document.createElement("p");
        p.textContent = name;

        button.appendChild(img);
        button.appendChild(p);
        grid.appendChild(button);

        button.addEventListener("click", () => {
            window.location.href = link;
        });
    }
    grid.removeChild(ul);
}

//What we need to do start is load structure html
async function LoadStructure() {
    return fetch("/structure.html").then(response => {
        if (!response.ok) {
            throw new Error("Failed to load structure.html: Error: " + response.statusText);
        }
        return response.text();
    }).then(structureHTML => {
        const parser = new DOMParser();
        const structureDoc = parser.parseFromString(structureHTML, "text/html");

        // Grab the main elements
        const documentMain = document.querySelector("main");
        const structureMain = structureDoc.querySelector("main");

        // 1. Replace structure's main content with the content of documentMain
        structureMain.replaceWith(documentMain);

        // 2. Replace documentMain with the entire structure's body content
        document.body.replaceWith(structureDoc.body);
    }).catch(error => {
        console.error("There was a problem with the fetch operation: " + error);
    });
}

async function LoadIndex() {
    return fetch("/index.html").then(response => {
        if (!response.ok) {
            throw new Error("Failed to load index.html: Error: " + response.statusText);
        }
        return response.text();
    }).then(indexHTML => {
        const parser = new DOMParser();
        const indexDoc = parser.parseFromString(indexHTML, "text/html");

        // Now we want to populate the left side index using the nav element of index.html
        var structureNav = document.querySelector("#index");
        var indexNav = indexDoc.querySelector("nav").firstElementChild;
        for (const child of indexNav.children) {
            let elem = document.createElement("button");
            let link = child.firstElementChild.href;
            let name = child.firstElementChild.innerHTML;
            elem.setAttribute("data-url", link);
            elem.innerHTML = name;
            elem.addEventListener("click", () => {
                window.location.href = link;
            });
            structureNav.appendChild(elem);
        }

    }).catch(error => {
        console.error("There was a problem with the fetch operation: " + error);
    });
}