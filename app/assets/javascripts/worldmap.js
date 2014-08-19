//Sourced from http://jsfiddle.net/amcharts/V7Xq8/
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
        if (event.mapObject.id == "FR") {
            jQuery("#myModal").modal({  //show the modal dialog box with the pictures
                show: true
            });
        }
        else if (event.mapObject.id == "RU") {
            jQuery("#myModal").modal({
                show: true
            });
        }
        else if (event.mapObject.id == "US") {
            jQuery("#myModal").modal({
                show: true
            });
        }
    });

    map.write("mapdiv");

});