---
layout: minimal
title: Unkown Error Code

subtitle: Technical Service Bulletin
permalink: /tsb/codenotfound
---
<div id="errorCode"></div>

<script>
    // Function to extract URL parameters
    function getUrlParameter(name) {
        name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
        var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
        var results = regex.exec(window.location.search);
        return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
    };

    // Get the error code from URL parameter
    var errorId = getUrlParameter('errorId');

    // Update the text on the page
    var errorCodeElement = document.getElementById('errorCode');
    errorCodeElement.textContent = 'Error Code: ' + errorId;
</script>