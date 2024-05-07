// Function to search for an image by title within a specific div
function searchImageByTitleWithinDiv(divId, title) {
    // Find the div element with the specified id
    var div = document.getElementById(divId);
    
    // Check if the div is found
    if (div) {
        // Find the image element with the specified title within the div
        var image = div.querySelector('img[title="' + title + '"]');        
    }
    
    return image; // Return the image element (or null if not found)
}

function handleYam(source) {
    if (source.dataset.yamdata != null) {
//        console.log("Click! " + source.dataset.yamdata);
        const items = source.dataset.yamdata.split(",").map(item => item.trim());
        for (i=0;i<4;i++) {
            searchImageByTitleWithinDiv("x" + (4-i), items[i]).click();
        }
    }
}

