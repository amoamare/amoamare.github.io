function DecodeErrorToBanks(id) {
    var bankNumbersPart = id.substring(6);
    var bankNumbers = parseInt(bankNumbersPart, 16);
    var extractedBankNumbers = [];

    for (var i = 0; i < 8; i++) {
        if ((bankNumbers & 1) === 1) {
            extractedBankNumbers.push(i + 1); // Add 1 to match bank numbering (1-indexed)
        }
        bankNumbers >>= 1;
    }

    return extractedBankNumbers;
}

 // Function to parse query parameters from the URL
 function getQueryParams() {
    var queryParams = {};
    var queryString = window.location.search.substring(1);
    var pairs = queryString.split("&");
    for (var i = 0; i < pairs.length; i++) {
      var pair = pairs[i].split("=");
      queryParams[decodeURIComponent(pair[0])] = decodeURIComponent(pair[1]);
    }
    return queryParams;
  }

  // Get query parameters
  var params = getQueryParams();

  // Highlight areas based on the 'highlighted_areas' parameter
  if (params.highlighted_areas) {
    var highlightedAreas = params.highlighted_areas.split(",");
    for (var i = 0; i < highlightedAreas.length; i++) {
      var areaId = highlightedAreas[i];
      // Highlight area with ID 'areaId'
      // Insert your highlighting logic here
    }
  }

  