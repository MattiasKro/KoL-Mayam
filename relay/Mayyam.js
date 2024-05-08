// Function to search for an image by title within a specific div
function searchImageByTitleWithinDiv(divId, title) {
    // Find the div element with the specified id
    var div = document.getElementById(divId);
    
    // Check if the div is found
    if (div) {
        // Find the image element with the specified alt text  within the div
        var image = div.querySelector('img[alt="' + title + '"]');        
    }
    
    return image; // Return the image element (or null if not found)
}

function handleYam(event) {
    event.stopPropagation();
    const source = event.target || event.srcElement;
    rotateWheel(source);
}

function rotateWheel(source) {
    if (source.dataset.yamdata != null) {
//        console.log("Click! " + source.dataset.yamdata);
        const items = source.dataset.yamdata.split(",").map(item => item.trim());
        for (i=0;i<4;i++) {
            searchImageByTitleWithinDiv("x" + (4-i), items[i]).click();
        }
    } else {
        if (source.parentNode != null) {
            rotateWheel(source.parentNode);
        }
        return false;
    }
}
