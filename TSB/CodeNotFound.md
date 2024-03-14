---
layout: minimal
title: Unkown Error Code

subtitle: Technical Service Bulletin
permalink: /tsb/codenotfound
---

<h3 id="errorCode"></h3>

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

<div style="justify-content: center; display: flex;">
  <iframe id="ifrm" title="" scrolling="no" frameborder="no" onload="setIframeHeight('ifrm')"
style="overflow:hidden;border:0;margin:0;padding:0;width:680;height:900;" 
src="https://www.appsheet.com/start/8aff849a-8d48-4493-b485-a85a81b1d059?refresh=1&wipe=1"></iframe>
</div>