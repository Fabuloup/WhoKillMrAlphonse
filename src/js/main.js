let db;

// Initialize CodeMirror
let editor = CodeMirror.fromTextArea(document.getElementById("sql-editor"), {
    mode: "text/x-sql",
    theme: "monokai",
    lineNumbers: true,
    extraKeys: {
        "Ctrl-Space": "autocomplete" // Enable autocomplete on Ctrl + Space
    },
    hintOptions: {
        tables: {} // Placeholder, will be updated dynamically
    },
    autofocus: true
});

// Initialize SQLite database
(async () => {
    const SQL = await initSqlJs({ locateFile: file => 'sql-wasm.wasm' }); // Load local wasm file

    const response = await fetch("sql/db.sql"); // Load SQL file
    const sqlText = await response.text(); // Read file content as text

    db = new SQL.Database();
    db.run(sqlText);
    editor.options.hintOptions.tables = getDatabaseHints();

    InitCulpritDropdown();
})();

// Enable autocomplete when typing
editor.on("inputRead", function(cm, event) {
    if (!cm.state.completionActive && /^[\w.]+$/.test(event.text[0])) {
        cm.showHint();
    }
});

// Initialize culprit dropdown
function InitCulpritDropdown() {
    const result = db.exec("SELECT id, name FROM persons WHERE name != 'Creator';");
    if (result.length > 0) {
        let select = document.getElementById("culprit-name");
        result[0].values.forEach(row => {
            let option = document.createElement("option");
            option.value = row[0];
            option.text = row[1];
            select.appendChild(option);
        });
    }
};

function executeSQL() {
    const query = editor.getSelection() || editor.getValue();  // Get SQL from CodeMirror
    let outputDiv = document.getElementById("output");
    outputDiv.innerHTML = "";
    try {
        let results = db.exec(query);
        if (results.length > 0) {
            let table = "<table><tr>" + results[0].columns.map(col => `<th>${col}</th>`).join("") + "</tr>";
            results[0].values.forEach(row => {
                table += "<tr>" + row.map(value => `<td>${value}</td>`).join("") + "</tr>";
            });
            table += "</table>";
            outputDiv.innerHTML = table;
        } else {
            outputDiv.innerHTML = "<p>Query executed successfully.</p>";
        }
    } catch (e) {
        outputDiv.innerHTML = `<p style="color:red;">Error: ${e.message}</p>`;
    }
}

document.addEventListener("keydown", function(event) {
    if (event.key === "F5" && event.ctrlKey === false) { // Detect F5 key
        event.preventDefault(); // Prevent page refresh
        executeSQL(); // Run the SQL query
    }
});

function getDatabaseHints() {
    let tables = {};
    try {
        let result = db.exec("SELECT name FROM sqlite_master WHERE type='table';");
        if (result.length > 0) {
            result[0].values.forEach(row => {
                let tableName = row[0];
                let columnResult = db.exec(`PRAGMA table_info(${tableName});`);
                let columns = columnResult.length > 0 ? columnResult[0].values.map(col => col[1]) : [];
                tables[tableName] = columns;
            });
        }
    } catch (e) {
        console.error("Error fetching table schema:", e);
    }
    return tables;
}

function validateCulprit()
{
    const select = document.getElementById("culprit-name");
    const selectedValue = select.options[select.selectedIndex].text;
    let outputDiv = document.getElementById("output");
    outputDiv.innerHTML = "";
    if (selectedValue === "Moe") {
        outputDiv.innerHTML = "<p style='color:green; font-weight:bold;'>Success !<br>Moe poisoned Alphonse's drink when he went to the bar and then threw the pill bottle of poison into the street near the bar.</p>";
    } else {
        outputDiv.innerHTML = "<p style='color:red;'>Incorrect culprit. Try again.</p>";
    }
}