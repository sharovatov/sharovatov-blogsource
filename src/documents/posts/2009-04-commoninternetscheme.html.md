---
layout: post
date: 2009-04
title: Common Internet Scheme Syntax
---

I've recently read an <a href="http://bolknote.ru/2009/04/04/~2074">extremely interesting post</a> on <a href="http://bolknote.ru/">bolknote.ru</a> about "Common Internet Scheme Syntax".

You may have already faced quite a common problem of setting absolute URIs to a resource on a page that must be accessed by both HTTPS and HTTP schemes.

<a href="http://tools.ietf.org/html/rfc1738">RFC 1738</a> Common Internet Scheme Syntax section states the following:

> While the syntax for the rest of the URL may vary depending on the particular scheme selected, URL schemes that involve the direct use of an IP-based protocol to a specified host on the Internet use a common syntax for the scheme-specific data:

> `**//<user>:<password>@<host>:<port>/<url-path>**`

So you don’t actually have to specify HTTP or HTTPS scheme, you just put two slashes and browser adds the current scheme automatically!

I tested this URL notation in the following browsers – IE3, IE4, IE5.0, IE501, IE5.5, IE6, IE7, IE8, FF2, FF3.0.8, Opera 8.5, Opera 9, Opera 10, Google Chrome (current version) – and it works fine in all of them!

You can test it yourself – here’s <a href="http://sharovatov.ru/testcases/schemeTest.html">the testcase</a>. 

As you may see, the URL is set without a scheme and your browser silently adds the current scheme. If you change http to https in your address, you’ll see that the scheme in dummy.html page URL will change to https!

It’s interesting to note that <a href="http://tools.ietf.org/html/rfc3986#section-3.1">RFC 3986 (URI Generic Syntax)</a> says that **scheme** part is required:

> Each URI begins with a scheme name that refers to a specification for assigning identifiers within that scheme. As such, the URI syntax is a federated and extensible naming system wherein each scheme's specification may further restrict the syntax and semantics of identifiers using that scheme.

but it also mentions Common Internet Syntax notation in the <a href="http://tools.ietf.org/html/rfc3986#section-4.2">Relative Reference</a> section:

> **A relative reference that begins with two slash characters is termed a network-path reference; such references are rarely used**. A relative reference that begins with a single slash character is termed an absolute-path reference. A relative reference that does not begin with a slash character is termed a relative-path reference.

However, I don’t think that any browser vendor will stop support for this functionality as it’s quite useful and there’s no problem in supporting it.

**UPDATE**: Google and Nigma.ru said their robots would follow and index such a link.

# Common Internet Scheme Syntax – detailed post
Now I’d like to describe in detail why and when abovementioned approach is extremely useful.

## Problem
If you serve CSS/JS or images from a domain that’s different to the domain of your page, and the page must be accessed from both HTTP and HTTPS, you must’ve already been thinking about this – what protocol scheme to set for these links? HTTP or HTTPS?

If you set your links’ URLs with HTTP scheme, and the page is accessed over HTTPS, all the resources are suddenly in a non-secure zone. Browsers behave differently, but they warn user in some way that the page contains non-secure content. Here’s <a href="https://www.allrussiantrains.com/schemeTestAdvanced.html">the testcase</a>. As you may see, testcase link points to HTTPS resource on allrussiantrains.com domain. This testcase has **IMG**, **LINK type="text/css"**, **SCRIPT** and **A** elements pointing to a HTTP locations on **sharovatov.ru** domain.

So if we have HTTP urls on the page that’s served through SSL, we face **the problem of “mixed content security warnings”**.

IE7 shows a **Security Information** warning asking user if he wants to display non-secure
content:

<img alt="non-secure content security warning in IE" src="http://sharovatov.ru/screenshots/securityWarning.gif">

If user presses Yes, all the elements are loaded.

If user presses No, all the elements are not loaded at all.

Firefox 3.0.8 silently loads HTTP-referenced content, but shows a small icon in the right-hand corner:

<img alt="security warning in FF" src="http://sharovatov.ru/screenshots/securityWarning-FF.gif">

Firefox also changes the address bar as if the connection isn’t secured by SSL, indicating user that the browser is displaying mixed content:

<img src="http://sharovatov.ru/screenshots/securityWarningAddressBar-FF.jpg">

Compare it to normal address bar interface when secure page is shown:

<img src="http://sharovatov.ru/screenshots/noSecurityWarningAddressBar-FF.jpg">

Opera 9.62 silently loads HTTP-referenced content, but shows a question mark icon in the address bar:

<img src="http://sharovatov.ru/screenshots/securityWarningAddressBar-OP.gif">

Compare it to the normal address bar when secure page is shown:

<img src="http://sharovatov.ru/screenshots/noSecurityWarningAddressBar-OP.gif">

Google Chrome does a similar thing – displays non-secure content, but shows an icon in the address bar:

<img src="http://sharovatov.ru/screenshots/securityWarningAddressBar-GG.gif">

Compare to the normal secure address bar:

<img src="http://sharovatov.ru/screenshots/noSecurityWarningAddressBar-GG.gif">

So all the browsers **in a very obvious way** alert user that the page has mixed content, and IE even fires an alert. This is clearly not suitable for public websites.

# Popular solutions

Usually people solve this problem by setting all the links to be HTTPS. So whichever way the page is accessed – either by HTTP or HTTPS, all the content is served through HTTPS channel.

This is generally OK, but still couple of issues bother me:

* **HTTPS loads server’s CPU as all the traffic must be encrypted**

* **HTTPS content is not cached by default**

So though setting all links to HTTPS won’t cause clients any problems, it will increase server load.

**Another way around is to change scheme in the URLs dynamically by a server-side language based on current scheme of the requested page**. But what if you have a static html file? Then you have to edit links’ URLs in javascript. Well, in any way, changing links schemes is right a kerfuffle! :)

And if you @import some CSS files or serve background images from a different domain, you’ll have to dynamically parse CSS in order to change URL scheme in all @import rules and background-image url’s. Which isn’t always a bad thing, but as your CSS file will be dumped into response stream by your favourite scripting language, default **HTTP conditional GET caching mode **will stop working (while it’s supported and working perfectly fine for static files in all web servers). So you will have to either reinvent the wheel and support caching in your CSS-parsing script, or live with the fact that your CSS is going to be fetched every time your page’s loaded.

# Proposed solution

We’ve got a better option!

<a href="http://tools.ietf.org/html/rfc1738">RFC 1738</a> Common Internet Scheme Syntax section states the following:

> While the syntax for the rest of the URL may vary depending on the particular scheme selected, URL schemes that involve the direct use of an IP-based protocol to a specified host on the Internet use a common syntax for the scheme-specific data:

> `**//<user>:<password>@<host>:<port>/<url-path>**`

And <a href="http://tools.ietf.org/html/rfc3986#section-4.2">RFC 3986 follows</a>:

> **A relative reference that begins with two slash characters is termed a network-path reference; such references are rarely used**. A relative reference that begins with a single slash character is termed an absolute-path reference. A relative reference that does not begin with a slash character is termed a relative-path reference.

So you don’t need to specify HTTP or HTTPS scheme, you just put two slashes and browser adds the current scheme automatically!

I tested this URL notation in the following browsers – IE3, IE4, IE5.0, IE501, IE5.5, IE6, IE7, IE8, FF2, FF3.0.8, Opera 8.5, Opera 9, Opera 10, Google Chrome (current version) – and it works fine in all of them!

You can test it yourself – here’s <a href="http://sharovatov.ru/testcases/schemeTest.html">the testcase</a>. 

As you may see, the URL is set without a scheme and your browser silently adds the current scheme of the loaded page, be it HTTP or HTTPS! If you change HTTP to HTTPS in your address, you’ll see that the scheme in dummy.html page URL will change to HTTPS!

# Conclusion

So, if you use “**General Internet Syntax Scheme**” URL syntax, you’ll achieve the following:

* you won’t have to care about URL schemes in CSS @import and background-image rules – you just put `@import "//externalsite.com/stylesheet.css"` or `#someElement { background-image: url(//externalsite.com/someBG.jpg); }` and your browser automatically puts current URL scheme and fetches the corresponding resource.

* you won’t have to parse CSS to change the URL scheme, and therefore you won’t break default HTTP Conditional GET caching mode, so your CSS will be perfectly cached as they remain static files

* you won’t have to mess with URL scheme in your JS-files, so you won’t have to parse your js-files and change URLs in them

* you won’t need to rewrite IMG URLs on all your pages!

Plus Google said their robot would happily parse, index and follow such links (of course, with HTTP scheme).

I also asked MSN Live Search Team about that – hope they reply soon – I’ll update the post.

So – use this approach if you have a page which is accessed by both HTTP and HTTPS and whenever you need to reference any resource from a different host on this page. Plus this host must support both HTTP and HTTPS :)

McAffee SiteScan button uses this in their image - **check!**