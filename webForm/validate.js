validCharacters = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "!", "?", ".", "-", "…", "“", "”", "‘", "’", "♂", "♀", ",", "×", "/", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "▶", ":", "é", "&", "+", "=", "%", "(", ")", "⬆", "⬇", "⬅", "➡"]

validSpecialCharacters = ["$", "Lv", "PK", "MN", "PO", "Ké"]

function validateForm() {
    var x = document.forms["pokemon"]["name"].value;
    if (x.length > 10 || x.length < 1) {
        alert("Name must be between 1 and 10 characters");
        return false;
    }
    for (var i = 0; i < x.length; i++) {
        if (validCharacters.indexOf(x.charAt(i)) === -1) {
            alert("\"" + x.charAt(i) + "\" is not a valid character");
            return false;
        }
    }
}