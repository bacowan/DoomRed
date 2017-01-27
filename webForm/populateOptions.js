dropDowns = {
    "attack": moveset,
    "type": types,
    "ability": abilities
}

function populateOptions() {
    for (name in dropDowns)
        populateDropdownsFromList(name, dropDowns[name]);
}

function populateDropdownsFromList(className, list) {
    var comboBoxes = document.getElementsByClassName(className);
    for (var i = 0; i < comboBoxes.length; i++) {
        list.forEach(function(val) {
            var node = document.createElement("option");
            node.value = val[0];
            node.innerHTML = val[1];
            comboBoxes[i].appendChild(node);
        });
    }
}

function randomize() {
    for (name in dropDowns)
        randomizeDropDown(name, dropDowns[name]);
    radioButtons = document.getElementsByName("gender");
    
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