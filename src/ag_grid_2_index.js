// Row Data Interface

// Grid API: Access to Grid API methods
let gridApi;

// Grid Options: Contains all of the Data Grid configurations
// Row Data: The data to be displayed.
// Column Definitions: Defines the columns to be displayed.
// defaultColDef:


// multiline strings ``
const testData = `{
    "querySelector": "#myGrid",
    "gridOptions": {
        "rowData": [
            {
                "make": "Tesla",
                "model": "Model Y",
                "price": 64950,
                "electric": true
            },
            {
                "make": "Ford",
                "model": "F-Series",
                "price": 33850,
                "electric": false
            },
            {
                "make": "Toyota",
                "model": "Corolla",
                "price": 29600,
                "electric": false
            },
            {
                "make": "Mercedes",
                "model": "EQA",
                "price": 48890,
                "electric": true
            },
            {
                "make": "Fiat",
                "model": "500",
                "price": 15774,
                "electric": false
            },
            {
                "make": "Nissan",
                "model": "Juke",
                "price": 20675,
                "electric": false
            }
        ],
        "columnDefs": [
            {
                "field": "make"
            },
            {
                "field": "model"
            },
            {
                "field": "price"
            },
            {
                "field": "electric"
            }
        ],
        "defaultColDef": {
            "flex": 1
        }
    }
}`;


function binArrayToJson(binArray) {
    var str = "";
    for (var i = 0; i < binArray.length; i++) {
        str += String.fromCharCode(parseInt(binArray[i]));
    }
    return JSON.parse(str)
}


function agGridCreate(rawData) {
    // `rawData` is Uint8Array type

    console.log("In agGridCreate function");
    alert("In agGridCreate function");

    console.log(String(rawData));
    alert(String(rawData));

    const inObj = binArrayToJson(rawData);

    // console.log(String(testData));
    // const inObj = JSON.parse(testData);

    // Your Javascript code to create the Data Grid
    const myGridElement = document.querySelector(inObj.querySelector);
    agGrid.createGrid(myGridElement, inObj.gridOptions);
    // Create Grid: Create new grid within the #myGrid div, using the Grid Options object
    // gridApi = agGrid.createGrid(document.querySelector("#myGrid"), gridOptions);
}
