allTables = []

function AdjustTables() {
    allTables.forEach((table) => {
        let wrapper = table.container;
        let wrapperWidth = wrapper.offsetWidth;
        let tableWidth = table.offsetWidth;
        let scale = Math.min(1, wrapperWidth / tableWidth);
        table.style.transform = `scale(${scale})`;
    });
}

function ProcessTables() {
    allTables = elemContent.querySelectorAll("table");
    allTables.forEach((table) => {
        let wrapper = document.createElement("div");
        wrapper.className = "table-container";
        table.parentNode.insertBefore(wrapper, table);
        wrapper.appendChild(table);
        table.container = wrapper;
    });

    AdjustTables();
}