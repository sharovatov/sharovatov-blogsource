---
layout: post
date: 2012-01
title: iframe height auto-resize
---

If you have a page and an iframe in it,  and the iframe viewport height changes, browser adds scrollbars to the iframe.

Sometimes it’s ok, but when you need your iframe to “expand” automatically on the host page, you have to change the iframe object height style property. And it’s dead easy when both iframe and the host page are from same origin – you just talk to parent window from the iframe and make it set the object height.

However, when cross-origin security model applies, everything gets more interesting, and you’re pretty much limited to <a href="http://dev.w3.org/html5/postmsg/">CDM</a>/<a href="http://www.sitepen.com/blog/2008/07/22/windowname-transport/">window.name</a>/location.hash transports.

So the proper approach would be to use CDM with a fallback to location.hash – newer browsers (IE8+ and current Firefox, Opera, Safari and Chrome) support postMessage, older versions will fall back to setting parent page location.hash property and on the parent page – interval polling for changes.

Here’s <a href="http://sharovatov.ru/iframe-autoheight/iframeHost.php">a basic working sample</a> implementing this approach and here’s the code for it:

* <a href="https://bitbucket.org/sharovatov/test/src/2bca47aa8b71/iframe-autoheight/iframeChild.html">child page</a>

* <a href="https://bitbucket.org/sharovatov/test/src/2bca47aa8b71/iframe-autoheight/iframeHost.php">parent page</a>

Please note that in this sample no origin check is done for the message on the parent page and the message is sent from the client page to * origin. This might be a serious security breach since the parent page will process a message send from **any** page, but in my case it’s OK because the worst thing that can happen – the iframe height will change. Please don’t use this as a universal solution for cross-iframe communication – there’re plenty of plugins and libraries that do it properly.

I built it this way just to fit my exact needs – i.e. change height of the iframe object on a parent page.