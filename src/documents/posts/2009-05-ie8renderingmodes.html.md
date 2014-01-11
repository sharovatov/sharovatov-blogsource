---
layout: post
date: 2009-05
title: IE8 Rendering Modes theory and practice
---

Many web-developers moan about the Rendering Modes switch that’s been introduced in IE8. I’ve got some thoughts on this.

## Rendering modes switches history

As you may know, IE5 on Mac (followed by IE6 on Windows) introduced Quirks and Standards compliancy modes with a DOCTYPE switcher. All other browsers followed the move and introduced similar approach – they tried to mimic IE behaviour in quirks mode and tried supporting CSS as close to the W3C standard as they could

DOCTYPE switch approach was really straight forward – if you put a valid DOCTYPE for your HTML page, browser switches to the standards compliancy mode; if DOCTYPE is omitted, quirks mode is used.

This switch was required because many sites were built at the time when even CSS1 was a draft, and for browsers to evolve safely (and add newer standards’ support) without breaking the existing web these old websites were to be rendered properly.

At the time the idea of using DOCTYPE as a rendering mode switcher was fine - almost all pages that had been built without standards support in mind didn’t have DOCTYPE. And if developers wanted to use modern standards, they added HTML or XHTML DOCTYPE and the page was rendered using standard-compliant parser.

**Quirks mode and DOCTYPE switch locked old web with old rendering engine, IE5 engine**.

I’m not wrong – after IE4 won first browsers war (**BW I**) nearly all sites were built for IE4 and IE5 **only**, so all other browsers had nothing to do but copy IE5 behaviour.

It’s important to note that DOCTYPE can only toggle standards compliancy on and off.

**Therefore DOCTYPE switch only solves backwards compatibility issue and does nothing to prevent future compatibility issues.**

When developers started using DOCTYPE switch, IE6 was a major browser and all the sites were build around its CSS support level. So when IE7 was shipped, it had better support for CSS2.1 but had the same DOCTYPE rendering modes switch.

**That’s why many of these websites had rendering issues and had to fix CSS/JS for IE7 specifically**. <a href="http://msdn.microsoft.com/en-us/library/ms537512(VS.85).aspx">Conditional comments</a> and <a href="http://msdn.microsoft.com/en-us/library/121hztk3(VS.85).aspx">conditional compilation</a> came to rescue. However, with XP SP3 update IE6 started showing `@jscript_version` equal to that of IE7 and conditional compilation became pretty useless.

In IE7 old web-sites in quirks mode continued being rendered by IE5 rendering engine, and standards compliancy engine was just an updated version of IE6 standards compliancy rendering engine with some bugs fixed. And while IE7 was a minor update to IE6 but still caused so much trouble, one could imagine what IE8 with proper CSS2.1 support would do to websites. Basically, all the websites with DOCTYPES that were just fixed for IE7 Standards Compliancy mode would break in IE8 again.

Other browsers didn’t have a similar problem, and there’re many reasons to this. First of all, by the time when first IE7 beta was shipped, other browsers had really insignificant market share (so their developers could change anything and wouldn’t be blamed for “breaking the web”), were updated really often and were mostly installed by IT-related people who knew how to update the browser. So DOCTYPE rendering switch was
and still is fine for non-IE browsers.

And Microsoft had to solve interesting problem in IE8 – support CSS2.1, support IE7 standards compliancy mode and support IE5 quirks mode. But DOCTYPE can only toggle standards compliancy on or off! They couldn’t drop support for very old but still existing sites build in quirks mode, couldn’t drop IE6 and IE7 support, and couldn’t leave IE8 without proper CSS2.1 support.

So we see that if any browser is locked at some version and this version gains noticeable market share, DOCTYPE switching will not work as vendors will have to choose what to support – older sites or newer features.

And Microsoft found a way – they gave web-developers and users a way to control in which mode sites are rendered.

## IE8 Rendering Modes Theory

In IE8 there’re 6 rendering modes:

* “Edge” Standard compliancy mode

* IE8 Standards mode

* “Emulate IE8” mode

* IE7 Standards mode

* “Emulate IE7” mode

* IE5 – Quirks mode

**Edge Standard compliancy mode **basically tells the browser that it should use the most recent rendering mode – in IE8 it’s “IE8 Standards mode”, in IE9 it will hopefully be “IE9 Standards mode”.

**IE8 Standards mode **makes browser render a page using IE8 standards compliancy parser and renderer.

**Emulate IE8** – DOCTYPE switch will be used to determine whether to use IE8 Standards
compliancy mode or IE5 Mode.

**IE7 Standards mode** makes browser render a page using IE7 Standards compliancy parser and renderer.

**Emulate IE7** – DOCTYPE switch will be used to determine whether to use IE7 Standards
compliancy mode or IE5 Mode. If you have a site that’s been built with IE7 Standards compliant mode support and you don’t want to change anything there, just add this META tag or HTTP header and IE8 (and all future versions of IE) will emulate IE7 behaviour, i.e. use IE7 Standards Compliant renderer when DOCTYPE is present and use IE5 mode when there’s no DOCTYPE. **So you virtually “lock” your website to a current browser version behaviour**. “Emulate IE7 mode” even sets User Agent string to IE7 string and report Version Vector as IE7 (so conditional comments will be evaluated as for IE7).

**IE5 Mode** – basically, it’s Quirks Mode. If we compare this to DOCTYPE switch approach, Edge mode is similar to a mode when DOCTYPE is set, and IE5 mode – to a mode when DOCTYPE is not present.

To explain modes in more details, I need to show how they are applied.

## IE8 Rendering Modes Practice
As I’ve shown above, the whole idea of using DOCTYPE as a rendering mode switch failed because **there were more than two types of documents** on the web – those that should work in quirks mode, those that should work in IE7 standards mode, those that should work in IE8 standards compliancy mode and those that should work even with future versions of IE. So instead of two types we have three and a half :)

To give a proper way to control this, Microsoft and <a href="http://www.webstandards.org/">WaSP</a> invented X-UA-Compatible http header, so you can either configure your server to send this header with corresponding value or add it as META HTTP-EQUIV to your page. For example:

	<meta http-equiv="X-UA-Compatible" content="IE=8">

This declaration will tell IE8 to toggle **IE8 Standards compliancy mode** to render the page.

Here’s a list of modes:

<table border="1" cellspacing="0" cellpadding="4" width="540">
	<tbody></tbody>
	<thead>
	<tr>
		<th width="230">Rendering mode</th>
		<th width="308">X-UA-Compatible value</th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<th valign="top" width="256" scope="row" align="left">Edge Standard compliancy</td>
		</th>
		<td valign="top" width="308">IE=edge</td>
	</tr>
	<tr>
		<th width="272" scope="row" align="left">IE8 Standards compliancy </td>
		</th>
		<td valign="top" width="308">IE=8</td>
	</tr>
	<tr>
		<th width="281" scope="row" align="left">IE8 Emulation </td>
		</th>
		<td valign="top" width="308">IE=EmulateIE8</td>
	</tr>
	<tr>
		<th width="285" scope="row" align="left">IE7 Standards compliancy </td>
		</th>
		<td valign="top" width="308">IE=7</td>
	</tr>
	<tr>
		<th width="287" scope="row" align="left">IE7 Emulation </td>
		</th>
		<td valign="top" width="308">IE=EmulateIE7</td>
	</tr>
	<tr>
		<th width="289" scope="row" align="left">IE5 Quirks </td>
		</th>
		<td valign="top" width="308">IE=5</td>
	</tr>
	</tbody>
</table>


## IE8 Rendering Modes Switches Priority

**First and main rule – if you specify X-UA-Compatible header or meta tag, IE8 will use the rendering engine you set.**

If it’s **EmulateIE7**, DOCTYPE switch will be used to determine whether to use IE7 Standards mode or IE5 Quirks mode. See test case <a href="http://sharovatov.ru/testcases/X-UA-Compatible(IE=EmulateIE7)DTD.html">with DTD</a> and <a href="http://sharovatov.ru/testcases/X-UA-Compatible(IE=EmulateIE7)noDTD.html">without DTD</a>.

If it’s **EmulateIE8**, DOCTYPE switch will be used to determine if it should use IE8 Standards mode or IE5 Quirks mode. See test case <a href="http://sharovatov.ru/testcases/X-UA-Compatible(IE=EmulateIE8)DTD.html">with DTD</a> and <a href="http://sharovatov.ru/testcases/X-UA-Compatible(IE=EmulateIE8)noDTD.html">without DTD</a>.

If it’s **IE=8**, IE8 Standards Compliancy mode will be used regardless of presence or absence of DOCTYPE. See test case <a href="http://sharovatov.ru/testcases/X-UA-Compatible(IE=8)DTD.html">with DTD</a> and <a href="http://sharovatov.ru/testcases/X-UA-Compatible(IE=8)noDTD.html">without DTD</a>.

If it’s **IE=7**, IE7 Standards Compliancy mode will be used regardless of presence or absence of DOCTYPE. See test case <a href="http://sharovatov.ru/testcases/X-UA-Compatible(IE=7)DTD.html">with DTD</a> and <a href="http://sharovatov.ru/testcases/X-UA-Compatible(IE=7)noDTD.html">without DTD</a>.

If it’s **IE=5**, IE5 Quirks mode is used even if there is a DOCTYPE (actually it didn’t matter for IE5 if there was DOCTYPE or not – quirks mode was the only mode it had). See <a href="http://sharovatov.ru/testcases/X-UA-Compatible(IE=5).html">test case</a>.

If it’s **Edge**, most modern rendering engine is used. For example, IE8 uses **IE=8** mode regardless if there’s a DOCTYPE or not and IE9 will use **IE=9**. See test case <a href="http://sharovatov.ru/testcases/X-UA-Compatible(IE=edge)DTD.html">with DTD</a> and <a href="http://sharovatov.ru/testcases/X-UA-Compatible(IE=edge)noDTD.html">without DTD</a>.

It’s worthy to note that **X-UA-Compatible META overwrites X-UA-Compatible HTTP header**, so you can set X-UA-Compatible HTTP header for the whole website and then have X-UA-Compatible META with a different value on some pages.

**If website doesn’t have X-UA-Compatible META tag or HTTP header, IE8 uses EmulateIE8 mode **i.e. DOCTYPE is used to switch between IE8 standards compliancy mode and IE5 Quirks mode.

This means that everybody needs to add to add X-UA-Compatible header or META to their websites.

Accepting the fact that web-developers wouldn’t update all the websites that were built around IE6/IE7 standards compliancy mode, Microsoft decision to take standards compliancy mode as a default would certainly “break the web”.

So Microsoft had to find a way around this which they successfully did by introducing a bunch of Compatibility View settings.

## Compatibility View
As I’ve already said, when developer didn’t care about adding X-UA-Compatible header or META, IE8 works in **EmulateIE8** mode and uses DOCTYPE switch to determine which rendering mode to use. If the site hasn’t got a DOCTYPE set, IE5 Quirks mode will be used, so backwards compatibility is not an issue. But if there’s a DOCTYPE, which Standards compliant mode to use? IE7? IE8? IE9 Standards Compliancy mode when IE9 it’s shipped? There’s no automatic way to choose.

And as IE8 Standards mode is a default one, there might be issues on sites that only supported IE6/IE7 Standard modes. Apparently, only user can see if the site he’s viewing has rendering issues. And Microsoft gave users an easy way to switch back to IE7 Standards Compliancy mode if required by clicking on a Compatibility View button (located to the left of refresh button).

<a href="http://sharovatov.files.wordpress.com/2009/05/image.png"><img title="image" border="0" alt="image" src="http://sharovatov.files.wordpress.com/2009/05/image_thumb.png?w=124&#038;h=46" width="124" height="46"></a>

IE8 will switch to **EmulateIE7** mode and save the setting for the domain so all the pages from this domain will be rendered using IE7 engine.

**Compatibility View button is shown only when X-UA-Compatible HTTP header or META is not set.**

Also during IE8 install a user can specify if he wants to use <a href="http://support.microsoft.com/kb/960321">Compatibility View List</a> feature. Basically, when this feature is turned and user clicks Compatibility View button while browsing, IE8 reports to Microsoft that the website on this domain required user to press the Compatibility View button.

If statistics show that users tend to press Compatibility View button for the site, it’s included in iecompatdata.xml file which fresh copy is distributed with Windows Update. It can be viewed by typing `res://iecompat.dll/iecompatdata.xml` into the address bar.

So when Compatibility View List feature is enabled and there’s no X-UA-Compatible HTTP header or META, and DOCTYPE is present, IE8 will look if the site is in the `res://iecompat.dll/iecompatdata.xml` file and make Compatibility View button pressed by default.

As soon as the site gets X-UA-Compatible header or META tag, IE8 will use the rendering mode from its value and won’t even check Compatibility View List and also Compatibility View button won’t show at all.

## Local Intranet security zone
Intranet differs from Internet a lot.

If Compatibility View List feature will work fine for public internet websites, Intranet sites should not be reported anywhere. So what rendering engine to use when there’s no X-UA-Compatible value and DOCTYPE is present? IE7 Standards Compliancy? IE8 Standards Compliancy?

Intranet is a controlled environment where to decrease support costs IT pros usually set everybody with same set of software. As most successful companies use Microsoft technologies as a core of their IT infrastructure and because only IE has been providing a decent platform for building powerful intranet web applications, IE was always a de-facto standard browser in companies.

Many intranet web applications were targeting IE5.5/6.0 and nobody cared to refactor to get standards compliancy – why bother if there was always only one browser supporting a well-known list of technologies so cross-browser interoperability was never an issue? We can argue if this approach is good or not – but IE8 team had thousands of intranet applications they had to support. That’s why compatibility view was the only option for sites from Local Intranet security zone.

If the site is in the Local Intranet zone and there’s no X-UA-Compatible header or meta tag, DOCTYPE switch is used to determine which rendering engine to take – IE7 Standards compliancy or IE5 quirks mode.

**If there’s no X-UA-Compatible value and site is in Local Intranet security zone, it will be rendered in EmulateIE7 mode by default.**

Compatibility View button is not displayed at all.

But as soon as a developer adds X-UA-Compatible header or META, site will start working in the specified mode.

## Developer Tools
With great set of developer tools that Microsoft provided for IE8 you can also view what rendering is being used and change it if required. This is useful for developers only and overrides any other settings. It’s very useful for testing – you don’t need IE7 in a virtual machine to test how a page looks in IE7 – just press F12 to get the developer tools and play with Browser modes or Document modes :)

Hope I managed to cover all the modes. In future posts I’ll write more on this topic.

P.S. As SelenIT pointed in comments, it’s very important that X-UA-Compatible meta tag must be put **before** any other elements in the head section, otherwise it might not work!