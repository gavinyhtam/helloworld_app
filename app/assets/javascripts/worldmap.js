//Sourced from http://jsfiddle.net/amcharts/V7Xq8/
/*Commented out temporarily so that can test JS getting Rails variables
var map;

//when AmMap to ready to load
AmCharts.ready(function() {
    map = new AmCharts.AmMap(); //make new Map
    map.pathToImages = "http://www.ammap.com/lib/images/";
    //map.panEventsEnabled = true; // this line enables pinch-zooming and dragging on touch devices
    map.balloon.color = "#000000";
    
    var wordlDataProvider = {
        mapVar: AmCharts.maps.worldLow,
        getAreasFromMap: true,
        areas: [
            { id: "FR", color: "#4444ff" },
            { id: "RU", color: "#4444ff" },
            { id: "US", color: "#4444ff" }
        ]
    };

    map.dataProvider = wordlDataProvider;

    map.areasSettings = {
        autoZoom: true,
        selectedColor: "#CC0000"
    };

    map.smallMap = new AmCharts.SmallMap();
    
    //when country is selected
    map.addListener("clickMapObject", function (event) {
    	//if country is in the 'been to' colour
        if (event.mapObject.color == "#4444ff") {
            jQuery("#myModal").modal({  //show the modal dialog box with the pictures
                show: true
            });
        }
    });
    map.write("mapdiv");

});*/
