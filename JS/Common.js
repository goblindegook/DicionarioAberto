/* Pinch gestures to resize text */

var zoom            = 100;
var maxZoom         = 150;
var minZoom         = 50;
var zoomIncrement   = 10;

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


document.addEventListener('DOMContentLoaded', function () {

    var body = document.getElementById('da');
    if (body) {
        body.addEventListener("gestureend", gestureEnd, false);
    }
                          
    if (typeof Hyphenator != 'undefined') {
        Hyphenator.config({
            minwordlength : 4
        });
        Hyphenator.run();
    }
});
