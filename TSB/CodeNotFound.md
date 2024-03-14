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
    
function getDocHeight(doc) {
    doc = doc || document;
    // stackoverflow.com/questions/1145850/
    var body = doc.body, html = doc.documentElement;
    var height = Math.max( body.scrollHeight, body.offsetHeight, 
        html.clientHeight, html.scrollHeight, html.offsetHeight );
    return height;
}

function setIframeHeight(id) {
    var ifrm = document.getElementById(id);
    var doc = ifrm.contentDocument? ifrm.contentDocument: 
        ifrm.contentWindow.document;
    ifrm.style.visibility = 'hidden';
    ifrm.style.height = "10px"; // reset to minimal height ...
    // IE opt. for bing/msn needs a bit added or scrollbar appears
    ifrm.style.height = getDocHeight( doc ) + 4 + "px";
    ifrm.style.visibility = 'visible';
}

document.getElementById('ifrm').onload = function() { // Adjust the Id accordingly
    setIframeHeight(this.id);
}
</script>

<div style="justify-content: center; display: flex;">
  <iframe id="ifrm" scrolling="no" frameborder="no" onload="resizeIframe(this)"
style="overflow:hidden;border:0;margin:0;padding:0;width:680;height:900;" 
src="https://www.appsheet.com/start/8aff849a-8d48-4493-b485-a85a81b1d059?refresh=1&wipe=1"></iframe>
</div>