---
layout: post
date: 2014-06
title: TLS mixed security content status
tags:
    - webdev
    - security
    - TLS
    - SSL
---

Here’s a list of screenshots of all the relevant browsers displaying normal valid (DV) certificate-encrypted site:

[IE6](http://sharovatov.ru/screenshots/secure-winXP-IE6.png),
[IE7](http://sharovatov.ru/screenshots/secure-winXP-IE7.png),
[IE8](http://sharovatov.ru/screenshots/secure-winXP-IE8.png),
[IE9](http://sharovatov.ru/screenshots/secure-win7-IE9.png),
[IE10](http://sharovatov.ru/screenshots/secure-win7-IE10.png),
[IE11](http://sharovatov.ru/screenshots/secure-win7-IE11.png),
[Win7 Firefox](http://sharovatov.ru/screenshots/secure-win7-firefox.png),
[Win7 Chrome](http://sharovatov.ru/screenshots/secure-win7-chrome.png),
[OS X Chrome](http://sharovatov.ru/screenshots/secure-OSX-chrome.png),
[OS X Safari](http://sharovatov.ru/screenshots/secure-OSX-safari.png),
[OS X Firefox](http://sharovatov.ru/screenshots/secure-OSX-firefox.png),
[iOS6 Safari](http://sharovatov.ru/screenshots/secure-iOS6.png),
[iOS7 Safari](http://sharovatov.ru/screenshots/secure-iOS7.png),
[android 4 webkit](http://sharovatov.ru/screenshots/secure-android4-webkit.png),
[android 4 chrome](http://sharovatov.ru/screenshots/secure-android4-chrome.png)

All of them have a padlock icon of some sort, which tech-savvy users associate with secure connection.

But things change when a browser detects that some content on the https secure page is served from http. The situation when the page is loaded via a secured HTTPS connection but tries to load some resources from an unsecure connection has a special name — ”mixed security content”. 

There’s an [in-progress spec explaining what should be considered mixed security content](https://w3c.github.io/webappsec/specs/mixedcontent/) and also a [W3C recommendation](http://www.w3.org/TR/wsc-ui/) on how agents should behave when they see mixed security content appearing on the page.

With regards to the certificate type, mixed security content case is handled differently for EV and DV (commonly used) certificates:

 * EV — a page is considered not TLS-validated if it has an EV cert and the page tries loading _any_ mixed content: images, scripts, iframes, video, objects; the EV green bar disappears.

 * non-EV — mixed security content is divided into two types: **passive** and **active**. **Passive** mixed security content usually includes images, video, objects (flash included), audio — everything that can’t change the DOM. Browsers _load_ passive mixed security content though this fact is indicated to the user, usually by showing ”insecure mixed content” icon somewhere in the address bar or elsewhere in the UI. And the **active** mixed security content (usually all the content that can modify DOM — scripts, stylesheets, iframes, fonts) _is not_ loaded by most of the browsers and a security warning is usually dumped to the console log.

To illustrate the behaviours of all the modern browsers I prepared a table of testcases and resulting screenshots (older IE6-7-8 behaviour is described above):

<style type="text/css">
.not-loaded a {color: red;}
.loaded a {color: green;}
</style>

<table>
    <thead>
        <tr>
            <td rel="col">Resource / Browser</td>
            <td>IE9</td>
            <td>IE10</td>
            <td>IE11</td>
            <td>Firefox 30</td>
            <td>Chrome 35</td>
            <td>Safari 7</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rel="row">Iframe (<a href="https://ssl.sharovatov.ru/mixed/iframe.html">test</a>)</td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/iframe-IE9.png">No</a></td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/iframe-IE10.png">No</a></td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/iframe-IE11.png">No</a></td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/iframe-firefox.png">No</a></td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/iframe-chrome.png">No</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/iframe-safari.png">Yes</a></td>
        </tr>
        <tr>
            <td rel="row">Script (<a href="https://ssl.sharovatov.ru/mixed/script.html">test</a>)</td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/script-IE9.png">No</a></td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/script-IE10.png">No</a></td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/script-IE11.png">No</a></td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/script-firefox.png">No</a></td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/script-chrome.png">No</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/script-safari.png">Yes</a></td>
        </tr>
        <tr>
            <td rel="row">Stylesheet (<a href="https://ssl.sharovatov.ru/mixed/style.html">test</a>)</td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/style-IE9.png">No</a></td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/style-IE10.png">No</a></td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/style-IE11.png">No</a></td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/style-firefox.png">No</a></td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/style-chrome.png">No</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/style-safari.png">Yes</a></td>
        </tr>
        <tr>
            <td rel="row">Font (<a href="https://ssl.sharovatov.ru/mixed/font.html">test</a>)</td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/font-IE9.png">No</a></td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/font-IE10.png">No</a></td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/font-IE11.png">No</a></td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/font-firefox.png">No</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/font-chrome.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/font-safari.png">Yes</a></td>
        </tr>
        <tr>
            <td rel="row">Image (<a href="https://ssl.sharovatov.ru/mixed/image.html">test</a>)</td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/image-IE9.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/image-IE10.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/image-IE11.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/image-firefox.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/image-chrome.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/image-safari.png">Yes</a></td>
        </tr>
        <tr>
            <td rel="row">Flash (<a href="https://ssl.sharovatov.ru/mixed/flash.html">test</a>)</td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/flash-IE10.png">No</a></td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/flash-IE10.png">No</a></td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/flash-IE11.png">No</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/flash-firefox.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/flash-chrome.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/flash-safari.png">Yes</a></td>
        </tr>
        <tr>
            <td rel="row">https flash + http xhr (<a href="https://ssl.sharovatov.ru/mixed/flash-xhr.html">test</a>)</td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/flash-xhr-IE9.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/flash-xhr-IE10.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/flash-xhr-IE11.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/flash-xhr-firefox.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/flash-xhr-chrome.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/flash-xhr-safari.png">Yes</a></td>
        </tr>
        <tr>
            <td rel="row">js XHR (<a href="https://ssl.sharovatov.ru/mixed/xhr.html">test</a>)</td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/xhr-IE9.png">No</a></td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/xhr-IE10.png">No</a></td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/xhr-IE11.png">No</a></td>
            <td class="not-loaded"><a href="http://sharovatov.ru/screenshots/xhr-firefox.png">No</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/xhr-chrome.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/xhr-safari.png">Yes</a></td>
        </tr>
        <tr>
            <td rel="row">Audio (<a href="https://ssl.sharovatov.ru/mixed/audio.html">test</a>)</td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/audio-IE9.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/audio-IE10.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/audio-IE11.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/audio-firefox.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/audio-chrome.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/audio-safari.png">Yes</a></td>
        </tr>
        <tr>
            <td rel="row">Video (<a href="https://ssl.sharovatov.ru/mixed/video.html">test</a>)</td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/video-IE9.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/video-IE10.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/video-IE11.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/video-firefox.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/video-chrome.png">Yes</a></td>
            <td class="loaded"><a href="http://sharovatov.ru/screenshots/video-safari.png">Yes</a></td>
        </tr>

    </tbody>
    <tfoot></tfoot>
</table>

Chrome is of version 35, Safari — 7.0.5, Firefox 30.

Provided tests show that browsers handle mixed security content case quite differently: 

 * Safari seems to not care about the type of mixed security content, it loads any mixed security content regardless of its type though it *removes* the padlock icon from the progress bar. 

 * similarly to Safari, IE up to version 8 (inclusive) [does not differentiate between active and passive mixed security content](http://blogs.msdn.com/b/askie/archive/2009/05/14/mixed-content-and-internet-explorer-8-0.aspx); it shows a modal dialog (asking if user wants to load only secure content or not) upon detecting _any_ mixed security content in the page: [IE6](http://sharovatov.ru/screenshots/mixed-content-dialog-winXP-IE6.png), [IE7](http://sharovatov.ru/screenshots/mixed-content-dialog-winXP-IE7.png), [IE8](http://sharovatov.ru/screenshots/mixed-content-dialog-winXP-IE8.png). If user chooses to load only secure content, mixed security content is blocked and the padlock icon is retained: [IE6](http://sharovatov.ru/screenshots/mixed-content-refused-winXP-IE6.png) [IE7](http://sharovatov.ru/screenshots/mixed-content-refused-winXP-IE7.png) [IE8](http://sharovatov.ru/screenshots/mixed-content-refused-winXP-IE8.png); if the user prefers to allow loading mixed security content, padlock icon is removed and mixed security content is loaded. If the user presses ”no”, both passive and active mixed security content will be loaded and the browser address bar will _not_ show the padlock, rendering the view similarly to normal http pages: [IE6](http://sharovatov.ru/screenshots/mixed-content-accepted-winXP-IE6.png) [IE7](http://sharovatov.ru/screenshots/mixed-content-accepted-winXP-IE7.png) [IE7](http://sharovatov.ru/screenshots/mixed-content-accepted-winXP-IE8.png) 

 * IE starting from version 9 [started handling different types of mixed security content differently](http://blogs.msdn.com/b/ie/archive/2011/06/23/internet-explorer-9-security-part-4-protecting-consumers-from-malicious-mixed-content.aspx) based on its type: passive mixed security content is loaded though the padlock icon is removed, active mixed security content is blocked and a special UI informational popup is shown.
 
 * When IE9 introduced special handling for passive mixed security content, Chrome and Firefox had to follow, and they did so: [first Chrome](http://googleonlinesecurity.blogspot.ru/2011/06/trying-to-end-mixed-scripting.html) and [two years later Firefox](https://blog.mozilla.org/security/2013/05/16/mixed-content-blocking-in-firefox-aurora/) started distinguishing passive and active mixed security content, both browsers are now able to detect when mixed security content is loaded and block what they consider active mixed security content; passive mixed security content is loaded with a corresponding UI change. To me, Chrome padlock UI looks cleaner and saner — when passive mixed security content is loaded, padlock icon still persists but a yellow warning sign is shown on top. Both Firefox and Chrome behave similarly on OS X and Windows.

* Chrome persists user’s choice to load active mixed security content for the site: if user chooses to load http iframe on one page, http-served script will be loaded on another page. Neither IE nor Firefox persist the user’s choice (which makes sense to me). Safari has nothing to persist as it always loads the content.

* Windows 8 Metro IE10 doesn’t have any UI for showing mixed security content

* IE9, IE10 and IE11 consider flash as active mixed security content, other browsers treat it as passive mixed security content; so IE9+ blocks the flash object from downloading and there’s a specific bug easy to spot [on the screenshot](http://sharovatov.ru/screenshots/flash-IE11.png) — the loading spinner never stops rotating. Which, combined with the IE’s usual ”Only secure content is displayed” dialog makes http-based flash on HTTPS pages almost unusable.

* IE9, IE10, IE11 and Safari **do not** consider HTTP-XHR from flash as mixed security content. Both IE and Safari retain the padlock icon as if all requests were made through a secured connection. Even the console log is empty of warnings or errors. To me this quite clearly seems to be a security hole.

* IE9 does not support cross-domain XHR, XDomainRequest is used instead, which [will block any requests to HTTP resource from a HTTPS page](http://blogs.msdn.com/b/ieinternals/archive/2010/05/13/xdomainrequest-restrictions-limitations-and-workarounds.aspx). IE10 [started supporting CORS-enabled XHR](http://blogs.msdn.com/b/ie/archive/2012/02/09/cors-for-xhr-in-ie10.aspx), but both IE10 and IE11 block CORS XHR requests to the HTTP page with a simple ”access denied” message in the console log. Safari follows its usual procedure — loads the content but removes the padlock icon, Firefox considers XHR to a HTTP active mixed security content and blocks it with its usual warning icon, Chrome considers AJAX _passive_ mixed security content, **loads** the content and adds its usual passive mixed security content informational triangle on top of the padlock icon.

* iOS Safari doesn't have any "insecure mixed content" icon, it just doesn't show the padlock icon at all if any mixed security content is present on the page while loading all the resources. 
