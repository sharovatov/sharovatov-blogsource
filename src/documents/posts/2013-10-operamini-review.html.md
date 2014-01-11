---
layout: post
date: 2013-10
title: Opera Mini review
---

This is the exerpt of my Opera Mini review for Mail Ru where we had to decide  what browsers we had to support for one of our mobile projects and what functionality had to be provided for the target platforms. 

Intro
---

Every request to a website is done not directly from the client installed on the phone, but through Opera servers farm in Norway, Poland, Korea, China and the United States as per [this press release](http://www.operasoftware.com/press/releases/mobile/opera-slashes-power-usage-with-new-server-parks).

Opera Mini is just a viewer (with a few features) for the website rendered image that is composed on the server by Presto rendering engine (and now with Presto’s death all the servers may eventually be upgraded to Webkit). This image is rendered in a proprietary format called OBML (Opera Binary Markup Language). It has “language” word because though being compressed, it presents some dynamic features.

So Opera Mini is basically a very thin client that doesn’t have its own HTML/JS/CSS engines and hence the following consequences apply:

1. Opera Mini cannot do any recalculations on its own – no animation, no background processing, no timers, no generated events.

2. as the actual page is rendered somewhere on the server possibly in another country, you won’t be able to access your localhost or your protected network from neither Opera Mini emulator nor from a real device. The address you are trying to fetch must be publicly accessible from the outside world.

3. There is nothing to debug on the actual device and there’s no way Opera will provide remote debuggers access to their servers. Hence ther are no development toolbars and no script debugging. You’re back to alerting debugging information, and even with alerts Opera Mini doesn’t make it easy for you – usually only one alert at a page load is displayed, even if you put few alerts calls one after another in the code.

Rendering modes
---

Opera mini has two rendering modes: **desktop view** and **mobile view**. **Desktop view** is enabled by default and **mobile view** can be enabled in the settings.

Desktop view
----

**Desktop view** makes Opera Mini report its media type to CSS as **screen** and the corresponding media queries fire.
	
**Desktop mode** has two viewing modes:

1. as it is, 1:1, automatically enabled if the page viewport width is _not more_ than the device doubled screen width.
2. “zoomed out” mode, automatically enabled if the page viewport width is _more_ than the device doubled screen width. The whole page is zoomed out to fit in the screen without a horizontal scroll. So the user sees the page zoomed out and selects an area of interest to zoom in. 

To prevent “zoomed out” mode and to make Opera Mini show the pages in 1:1 mode, the following javascript code can be of help: `window.operamini.page.samePage=true;`

However, if the first page the user visits is very wide, “zoomed out” mode will be enabled for this page regardless of the **samePage** property value, and only the next page will respect the corresponding value.
	
In the **desktop view** mode page content is not reflowed.


Mobile view
----

In the **mobile view** mode page content is reflowed into one column to fit in the screen width.

Opera Mini starts reporting its Media as **handheld** and corresponding media queries are applied in the CSS.

There’s no way to prevent user from changing rendering modes and the reflow rules Opera Mini uses are not published or documented, so targeting **mobile view** is very problematic and can only be experimentally driven.


Rendering
----

Currently Opera servers use Presto (though the desktop version of Opera abandoned Presto in favour of Webkit). 

The following features are supported:

* media queries
* CSS3 colours
* CSS3 selectors 
* CSS3 multiple backgrounds
* all popular image types (though the server will convert them to internal OBML imaging with quality loss anyway)
* SVG (rasterized by the server!)
* favicon
* document title
* reads RSS
* canvas (but rasterized and shows only the first frame)
* text styling: bold, underline, overline, strike

And the following features are not supported:

* web fonts
* italic font style (seems to depend on the fonts installed on the phone)
* transitions
* flash
* dotted/dashed borders are drawn as solid 
* **line-height**
* **there’s only one scrollable area, everything that might have scrollbars is flattened and the hidden content is cropped**
* **animated images only have the first frame displayed**
* only few fonts available on the device are shown + 1 UTF font is included (most often sans-serif)
* only one font-family for the whole page + monospace
* different devices can have different font sizes (though I didn’t observe that)
* tables can not be properly reflowed in the mobile view mode and the horizontal scroll will be shown
* no CSS features requiring Vega (Opera’s graphical library) are supported: drop-shadow, border-radiua, gradients)


Javascript
----

Opera Mini doesn’t have its own JS engine and it just shows a “snapshot” of the page state as it was rendered and executed on the server. Elements with event handlers are transformed to so called “active areas”, when user clicks one of these areas, a request is sent to Opera Mini server where the page is ressurected and corresponding javascript event fires. As soon as the Presto engine completes javascript execution (within the timeout), new page state is dumped to OBML and sent back to Opera Mini.

Active area state is considered to be changed when one of the elements contained within this active area is clicked or form values are changed, neither scrolling nor other actions cause Opera Mini to request fresh page state from the server.

The following events are fired on the server:

* window.onload – as soon as the server loads the page
* when a form element active area state is changed on the Opera Mini and Opera Mini sends the change to the server, corresponding form elements fire focus->click->change->blur events sequence (without any delay between them), waits for javascript handlers to complete execution and compile resulting DOM state back to OBML and sends to the Opera Mini client.

Javascript execution time on the server is limited by 2.5 seconds for Opera Mini 4 servers and 5 seconds for Opera Mini 5 and newer. As soon as the limit is hit, execution is paused and resulting DOM is compiled to OBML and sent to the Opera Mini client. So for each fresh page state request from Opera Mini to Opera Mini servers javascript code on the page has up to 5 seconds to perform (this limitation applies to all javascript APIs: XHR, setTimeout/setInterval etc.).

Opera Mini 5 and later support progressive rendering so that OBML can be delivered to Opera Mini client and rendered by chunks, when this process is occuring, download progress bar is animated and javascript is still being executed on the server. With this progressive rendering the 5 seconds javascript execution time limit still apply.

Important
---

* window.open replaces current page with the new one. The old one is either discarded or hidden, there will be no communication between the opener and the new window.
* no client-side storage exist: localStorage, sessionStorage etc.
* no html5 client-side validation, new form elements (input type=email|range etc are not validated on the client)
* no webworkers support (otherwise Opera servers would be a perfect free bitcoin mining servers)

Additional functionality
---

Opera Mini provides additional information about the phone it runs on. Opera Mini somehow sends this information to its servers and then the server sends some information to the requested URL via HTTP headers. Note that OBML is binary and not documented, so we don’t know what exactly is sent to its servers in Norway or elsewhere, we can only observe what these servers request from our servers. Also note that true privacy can not be ensured because all the communication is done through their servers and noone knows what statistics or data they collect.

Headers
---

Opera Mini servers have the following headers when requesting data from target servers:

**User-Agent**: Opera/9.80 ($PLATFORM_NAME$; $PRODUCT_NAME$/$CLIENT_VERSION$/
$SERVER_VERSION$;U; $LOCALE$) $PRESTO_VERSION$ $EQUIV_DESKTOP_VERSION$

**X-OperaMini-Features**: Basic comma-separated list of features supported on the device. 

* **advanced** - MIDP2-version (has more RAM)

* **basic** - MIDP1-version (usually installed on the cheapest phones)
	
* **camera** - shows support for photos file upload using HTML input type=file. Unfortunately there’s no available statistical data (or a list of models) on what phones support this and what don’t.
	
* **file_system** - file system support (i.e. user is able to download and/or upload files)

* **folding** - content folding feature status 
	
* **secure** - connection between Opera Mini and Opera Mini servers is encrypted.
	
* **touch** - Opera Mini is running on a touch-operated device

**X-OperaMini-Phone**: phone model and vendor, useful for the project audience statistics. 

**X-Forwarded-For**: the list of proxy agents between the Opera Mini servers and your server, the first entry in the list shows the actual phone connection IP address. This is the only place where the actual phone’s IP address is shown.

The same information is exposed to javascript via **window.operamini.features** object (e.g. `window.operamini.features.folding == 1` check will tell if content folding is enabled). So this list of features can both be checked in the server-side code and on the client-side in javascript.

However, javascript **window.operamini** object has some additional properties:

* **window.operamini.page.maxAge** - time that the client will keep the page cached (minutes)

* **window.operamini.page.samePage** - indicates if the pages is forced be left in *zoomed in* mode or it can be allowed to be switched to *zoomed out* mode

* **window.operamini.sms** - shows sms send dialogue as soon as **window.operamini.sms.number** and **window.operamini.sms.body** values are filled in. This method could be used to ask user to send some sms somewhere (even paid ones). The availability of sms sending feature can be checked by **window.operamini.features.sms**

* **window.operamini.remote** - *X-Forwarded-For* analogue, first value in the list is the client IP address, other values are just a list of proxies between Opera Mini server and your server. Most of the times, the list only contains one value - phone IP address.


Hidden settings
---

There are some hidden settings available in Opera Mini client. To toggle any of them, type the corresponding name into the address bar and press “Go”.

* **config:** - most of the additiional settings

* **server:source** - shows the html page source (in the exact form as it was sent to Opera Mini servers by your server for the requested URL). Unfortunately, the source is rendered in the ugly monospace font (so ugly that it’s obvious it’s included in Opera Mini package). As OBML format is binary and not documented, inspecting this source is the only view-source option a client-side developer has.

* **opera:cache** - shows the elements cached by the client

* **about:** - shows all versions and patent information.


Issues and quirks
---
Never use `:after` or `:before` selectors with `content` property on form elements such as inputs – input value can be erraneously overwritten by the `content` property value. I witnessed this on a live project - input value was overwritten right before form submit.

