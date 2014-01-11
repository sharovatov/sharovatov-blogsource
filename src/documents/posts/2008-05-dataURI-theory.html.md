---
layout: post
date: 2008-05
title: data URI theory and practice
---

# Theory

Data URI'es is an <a href="http://www.ietf.org/rfc/rfc2397.txt">RFC 2397</a> published in 1998. It's a URL scheme which is used to embed small resources right into the (X)HTML page.

Syntax is quite simple: `data:[<mediatype>][;base64],<data>`

To see how it works let's take the following code (<a href="http://sharovatov.ru/testcases/dataURI_extCSS.html">testcase</a>):

	<link rel="stylesheet" type="text/css" href="data:text/css;base64,Ym9keXtiYWNrZ3JvdW5kOmdyZWVuO30=">

Browser supporting data URI will base64-decode the encoded string `Ym9keXtiYWNrZ3JvdW5kOmdyZWVuO30=` to `body{background:green;}` and then _load_ this string as if it was a result of an http request to an external file containing this CSS code.

According to the RFC we can embed any small resource into our page, e.g:

* <a href="http://sharovatov.ru/testcases/dataURI_img.html">images</a> (as <var>img</var> elements and CSS backgrounds)

* <a href="http://sharovatov.ru/testcases/dataURI_extJS.html">javascript</a>

* <a href="http://sharovatov.ru/testcases/dataURI_HTML.html">html</a> (links, iframes)

* <a href="http://sharovatov.ru/testcases/dataURI_extCSS.html">css</a> (and even <a href="http://sharovatov.ru/testcases/dataURI_extCSS_dataURI_img.html">dataURIed images inside dataURIed CSS</a>!)

* any other resource supported by browsers

So theoretically we could have the same functionality as we have in MHTML - some or all external resources embedded directly in the page.

All data URI advocates say that as most of the browsers have 2 concurrent connections per server (but 6 in total), dataURI mechanism potentially can speed up page load by decreasing the amount of HTTP requests (especially in case of HTTPS where encrypting payload produces quite big overhead). But:

* HTTP protocol already has methods to help building efficient applications - persistent connections to avoid recreating the sockets, different caching mechanisms to reduce overhead (Conditional GET) or avoid total amount of requests (aggressive caching using Expires header).

* Even more, using <a href="http://www.ajaxperformance.com/2006/12/18/circumventing-browser-connection-limits-for-fun-and-profit/">simple technique</a> you can have your browser use 6 concurrent connections to parallelize fetching data as much as it can and therefore fasten page load.

* Though <a href="http://tools.ietf.org/html/rfc2616#section-8.1.4">HTTP 1.1 spec says</a> that we shouldn't have more than 2 concurrent connections per server, in real world we have 2 concurrent connections only in Firefox and IE6/7. In IE8b1 the number is 6, in Opera 9 and Safari it's 4. In the next post I will give more details on this.

So keeping all this in mind we can't just say that dataURI is the only usable way to improve page load times. But it definetely is the only option when you have a limited access to the server and/or the server is not configured properly, so you can't set Expires header for aggressive caching, you can't set DNS wildcards or CNAME records to get your resources served from different hosts (and therefore leverage the maximum available concurrent connection in browsers) or server doesn't support HTTP caching properly.

# Practice

I can only see the following cases where dataURI can be effectively used:

* **CSS sprites, rounded corners images, icons and other images that have only presentational
	semantics**. It's the perfect target for dataURI + base64 to be applied to. If we embed them
	in the CSS file, we _remove_ HTTP requests that would be queried if these images were normal
	files. These images are part of the design described in the stylesheet, so it makes perfect sense to
	embed them in CSS. CSS files can be perfectly cached and while design doesn't change, we don't
	need to touch this CSS and change anything. But there should be a common sense here as well -
	firstly, base64 decoding takes system resources and secondly, who wants to wait for a CSS file of couple
	hundred kilobytes in size to load?

* **Reasonably small CSS files with rules specific for a page**. If there is a semantical sense to define an inline CSS on a page, then there's a perfect sense to set it using dataURI.
	Another thing is that if CSS file is not going to be parsed until it's fully downloaded by a browser. So when we embed a big image, we'll have first client opening the page wait till CSS is fully loaded. So we loose our HTTP parallelism benefits here.

Please don't forget that if a resource is embedded on multiple pages, it's obviously going to be redownloaded as many times as these containing pages are. And if a resource is not dataURI'ed but referenced normally as an external file, it can be cached quite aggressively and requested from the server only once (all popular web-servers already provide good caching support for static files).

However, this is all ideal world where specification don't have flaws and all browsers follow them.

In our world we have the following:

* Lack of support. Only IE8b1/Opera9/Firefox2/Safari support data URI. No IE6/IE7<sup><a href="#dataURI_note1">1</a></sup>. That means that for the next three or four years while IE6 and IE7 will still have a significant market share, we can't just go and start using dataURI.

* Different size limits on URI length in different browsers. As far as I know for now IE8 supports up to 32 kilobytes in <var>data:</var> value. Even though all other browsers support bigger sizes, our limit will obviously be 32Kb.<br>See <a href="http://sharovatov.ru/testcases/dataURI_maxlength.html">testcase 1 with data URI of 32755 bytes</a> and <a href="http://sharovatov.ru/testcases/dataURI_maxlength2.html">testcase2 with dataURI of 32868 bytes</a>.

Also I would strongly discourage from dynamically base64-encoding and embedding images in CSS files by some scripting language unless you're well aware of HTTP caching principles.

Let's consider the following composed code from <a href="http://en.wikipedia.org/wiki/Data:_URI_scheme">Wikipedia data:URI page</a>:

	<?php
	function data_url($file, $mime)
	{
		$contents = file_get_contents($file);
		$base64 = base64_encode($contents);
		return ('data:' . $mime . ';base64,' . $base64);
	}

	header('Content-type: text/css');

	?>

	div.menu {
		background-image:url(<?php echo data_url('menu_background.png','image/png')?>);
	}

Unless accompanied with correct HTTP caching algorythm, this CSS file will be downloaded **every time the page that references this CSS file is loaded**! So every time user accesses the page referencing this CSS file, server will get a request, initiate script parsing, base64-encode the image and send it back to client. So you get rid of one simple request for an image (that in case of being a static file will be perfectly cached) but have one heavy request that will be run every time user requests a page! Not a fair change I think. So again, if you decide to use data URI scheme for your resources, encode and embed them beforehand or implement proper server-side HTTP caching and compressing support.

**Note for russian-speaking users**: - there's <a href="http://bolknote.ru/2006/08/25/~314">a way to embed images even for IE6/IE7</a>. Though it's rather a proof-of-concept - it doesn't support HTTP caching/compressing, but it works!

## Links and resources:

* <a href="http://www.ietf.org/rfc/rfc2397.txt">RFC 2397 - The &ldquo;data&rdquo; URL scheme</a>

* <a href="http://www.mozilla.org/quality/networking/testing/datatests.html">Mozilla tests for data URI support</a>

* <a href="http://www.packetgram.com/pktg/docs/std/urls/techrfc2397.html">Technical review of RFC 2397</a>

* <a href="http://www.ietf.org/rfc/rfc2396.txt">RFC 2396 - URI generic syntax</a>

* <a href="http://www.ietf.org/rfc/rfc2616.txt">RFC 2616 - HTTP/1.1</a>

* <a href="http://support.microsoft.com/kb/208427">Maximum URL length is 2,083 characters in Internet Explorer</a>

* <a href="http://www.geocities.com/max1million/bookmarklets.htm">Bookmarklets for Firefox</a>

* <a href="http://www.alistapart.com/articles/sprites">CSS sprites</a>

* <a href="http://code.msdn.microsoft.com/ie8whitepapers/Release/ProjectReleases.aspx?ReleaseId=575">Microsoft IE8b1 data URI support</a>

* <a href="http://www.ajaxperformance.com/2006/12/18/circumventing-browser-connection-limits-for-fun-and-profit/">Circumventing browser connection limits for fun and profit</a>

* <a href="http://forevergeek.com/open_source/make_firefox_faster.php">Make Firefox faster</a>

* <a href="http://bolknote.ru/2006/08/25/~314">Embedding resources in IE6/IE7</a>