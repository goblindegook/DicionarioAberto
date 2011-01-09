var zoom = 100;
var maxZoom = 150;
var minZoom = 50;
var zoomIncrement = 10;

function gestureEnd (e) {
    var newZoom;
    if (e.scale > 1.0) {
        newZoom = zoom + zoomIncrement;
    } else {
        newZoom = zoom - zoomIncrement;
    }
    
    if (newZoom > maxZoom || newZoom < minZoom) {
        return;
    }
    zoom = newZoom;
    
    var body = document.getElementById('da');
    body.style.webkitTextSizeAdjust = zoom + "%";
}


function addPinchToResize (e) {
    var body = document.getElementById('da');
    body.addEventListener("gestureend", gestureEnd, false);
}


window.addEventListener("load", addPinchToResize, false);