// Grid and Charts wrapper file

// Row Data Interface
// Grid API: Access to Grid API methods
let gridApi;

function binArrayToJson(binArray) {
    var str = "";
    for (var i = 0; i < binArray.length; i++) {
        str += String.fromCharCode(parseInt(binArray[i]));
    }
    return JSON.parse(str)
}

function createGrid(inData) {
    // Your Javascript code to create the Data Grid
    //
    // @param 'inData' - FIXME: type must be JSONString or may be Uint8Array
    //
    // gridOptions: Grid Options - Contains all of the Data Grid configurations
    // rowData: Row Data - The data to be displayed.
    // columnDefs: Column Definitions - Defines the columns to be displayed.

    // console.log("In createGrid function");
    // alert("In createGrid function");

    console.log("Type of inData is", typeof inData,
                "\nContent of inData is", String(inData));

    const inObj = binArrayToJson(inData);
    const myGridElement = document.querySelector(inObj.querySelector);
    agGrid.createGrid(myGridElement, inObj.gridOptions);

/* TODO:
     do {
        if (typeof inData === "string") {
            const inObj = JSON.parse(inData);
        }
        else if (typeof inData === "Uint8Array") {
            const inObj = binArrayToJson(inData);
            // 'inData', type is object
        }
        else {
            console.error("Not approved type for parameter 'inData', type is", typeof inData);
            break
        }
        const myGridElement = document.querySelector(inObj.querySelector);
        agGrid.createGrid(myGridElement, inObj.gridOptions);
    } while (false);
 */
}

function createCharts(JSONString) {
    const { AgCharts } = AgCharts;

    // Chart Options
    const options = {
        container: document.getElementById("myChart"), // Container: HTML Element to hold the chart
        // Data: Data to be displayed in the chart
        data: [
            { month: "Jan", avgTemp: 2.3, iceCreamSales: 162000 },
            { month: "Mar", avgTemp: 6.3, iceCreamSales: 302000 },
            { month: "May", avgTemp: 16.2, iceCreamSales: 800000 },
            { month: "Jul", avgTemp: 22.8, iceCreamSales: 1254000 },
            { month: "Sep", avgTemp: 14.5, iceCreamSales: 950000 },
            { month: "Nov", avgTemp: 8.9, iceCreamSales: 200000 },
        ],
        // Series: Defines which chart type and data to use
        series: [{ type: "bar", xKey: "month", yKey: "iceCreamSales" }],
    };

    // Create Chart
    AgCharts.create(options);
}
