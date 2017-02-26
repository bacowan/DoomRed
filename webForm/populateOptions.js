dropDowns = {
    "attack": moveset,
    "type": types,
    "ability": abilities
}

function populateOptions() {
    var rowTemplate = document.getElementById("movesetRowTemplate");
    var combo = rowTemplate.content.querySelectorAll("select")[0];
    appendOptionsToCombobox(combo, moveset);
    for (name in dropDowns)
        populateDropdownsFromList(name, dropDowns[name]);
}

function populateDropdownsFromList(className, list) {
    var comboBoxes = document.getElementsByClassName(className);
    for (var i = 0; i < comboBoxes.length; i++)
        appendOptionsToCombobox(comboBoxes[i], list);
}

function appendOptionsToCombobox(comboBox, list) {
    list.forEach(function(val) {
            var node = document.createElement("option");
            node.value = val[0];
            node.innerHTML = val[1];
            comboBox.appendChild(node);
    });
}

function randomize() {
    for (name in dropDowns)
        randomizeDropDown(name, dropDowns[name]);
    randomizeMoveset();
    radioButtons = document.getElementsByName("gender");
    radioToCheck = radioButtons[Math.floor(Math.random()*3)]
    radioToCheck.checked = true;
}

function randomizeMoveset() {
    clearRows();
    var moveCount = 10 + Math.floor(Math.random()*10);
    for (var i = 0; i < moveCount; i++) {
        var level = 1 + Math.floor(Math.random()*59);
        var selectedItem = 1 + Math.floor(Math.random()*(moveset.length-1));
        addRow(level, selectedItem);
    }
}

function randomizeDropDown(className, list) {
    var comboBoxes = document.getElementsByClassName(className);
    for (var i = 0; i < comboBoxes.length; i++) {
        comboBoxes[i].selectedIndex = Math.floor((Math.random() * comboBoxes[i].length) + 1);
    }
}

function showAdvanced() {
    var element = document.getElementById("advanced");
    var advancedButton = document.getElementById("advancedButton");
    if (element.style.display === "none") {
        element.style.display = "block";
        advancedButton.innerHTML = "Hide Advanced ▲"
    }
    else {
        element.style.display = "none";
        advancedButton.innerHTML = "Show Advanced ▼"
    }
}

function addUserRow() {
    addRow("", 0);
}

function addRow(level, move) {
    var movesetTable = document.getElementById("movesetTable");
    if (movesetTable.rows.length < 21) {
        var rowTemplate = document.getElementById("movesetRowTemplate");
        var row = rowTemplate.content.cloneNode(true);
        
        var moveInput = row.querySelectorAll("select")[0];
        var levelInput = row.querySelectorAll("input")[0];
        moveInput.value = move;
        levelInput.value = String(level);
        
        movesetTable.getElementsByTagName("tbody")[0].appendChild(row);
    }
    enableDisableAddButton();
}

function clearRows() {
    var newBody = document.createElement("tbody");
    var movesetTable = document.getElementById("movesetTable");
    var oldBody = movesetTable.getElementsByTagName("tbody")[0];
    movesetTable.replaceChild(newBody, oldBody);
}

function removeRow(element) {
    var movesetTable = document.getElementById("movesetTable");
    movesetTable.deleteRow(element.parentNode.parentNode.rowIndex);
    enableDisableAddButton();
}

function enableDisableAddButton() {
    var button = document.getElementById("newRowButton");
    if (movesetTable.rows.length > 20)
        button.disabled = true;
    else
        button.disabled = false;
}