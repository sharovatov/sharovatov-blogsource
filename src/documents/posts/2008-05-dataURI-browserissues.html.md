---
layout: post
date: 2008-05
title: data URI browser issues
---

## Length limit
### Theory

<a href="http://www.ietf.org/rfc/rfc2397.txt">data URI specification</a> says the following:

> some applications that use URLs may impose a length limit; for example, URLs embedded within <A> anchors in HTML have a length limit determined by the SGML declaration for HTML [RFC1866]. The LITLEN (1024) limits the number of characters which can appear in a single attribute value literal, the ATTSPLEN (2100) limits the sum of all lengths of all attribute value specifications which appear in a tag, and the TAGLEN (2100) limits the overall length of a tag.

Though at the time of writing data URI specification <a href="http://www.w3.org/TR/REC-html32">HTML3.2</a> was current HTML recommendation, author intentionally used LITLEN, ATTSPLEN and TAGLEN values from the older <a href="http://www.w3.org/MarkUp/html-spec/html-spec_9.html#SEC9.5">HTML2.0 SGML declaration</a> to show that some user-agents may impose a length limit for URI.

<a href="http://www.ietf.org/rfc/rfc2616.txt">HTTP1.1</a> doesn't put a limit on the length of URI, but it warns us:

> Note: Servers ought to be cautious about depending on URI lengths above 255 bytes, because some older client or proxy implementations might not properly support these lengths.

which basically means that if all clients in the network support URIes more than 255 bytes long, we're ok.

<a href="http://www.w3.org/TR/REC-html32#sgmldecl">HTML3.2 SGML declaration</a> states the maximum length of an attribute to be 65535. Even more, <a href="http://www.w3.org/TR/html40/sgml/sgmldecl.html">HTML4.01 SGML declaration</a> uses value 65535 as a maximum allowed in SGML but says that fixed limits should be avoided. <a href="http://xml.coverpages.org/xmlSGMLDecl970627.html">XML1.0 SGML declaration</a> uses 99999999 value just to show that there's no limit specified.

### Practice

Different browsers have different maximum length of dataURI'ed values supported.

As per <a href="http://support.microsoft.com/kb/208427">the kb208427 article</a>, IE supports URI length of up to 2048 bytes. According to the <a href="http://go.microsoft.com/fwlink?LinkID=110274">Microsoft IE8 data URI support whitepaper</a>, IE8 supports up to 32Kbytes of data URI and silently discards dataURI value if its size exceeds 32Kbytes (which can be checked in the <a href="http://sharovatov.ru/testcases/dataURI_maxlength.html">testcase1</a> and <a href="http://sharovatov.ru/testcases/dataURI_maxlength2.html">testcase2</a>). As I've already mentioned in the previous post, other browsers provide bigger-sized URI support, but I doubt that IE8 will have minor market share so we will still have to stick to 32Kbytes. And I will repeat: data URI spec author that the only reasonable and semantic use of data URI is embedding small resources, so realistically
speaking 32Kbytes limit shouldn't be a problem.

## Serving CSS dataURI'ed
In theory, CSS has to be served with its MIME type (`text/css`).

In practice, only Firefox and only in standards compliancy mode cares about MIME type that CSS's been served with. Please see the testcases with CSS served with wrong MIME type in different render modes: <a href="http://sharovatov.ru/testcases/dataURI_extCSSwrongMIME.html">in standards compliancy mode</a> and <a href="http://sharovatov.ru/testcases/dataURI_extCSSwrongMIME_quirks.html">in quirks mode</a>.

Opera, Safari and Internet Explorer 8 all apply CSS served with any MIME type in all modes. The behaviour is the same for both CSS files served using dataURI and by referencing normal external files.

## Serving Javascript and HTML dataURI'ed
Safari, Opera and Firefox support <a href="http://sharovatov.ru/testcases/dataURI_extJS.html">embedding javascript using data URI scheme</a>. According to <a href="http://code.msdn.microsoft.com/ie8whitepapers/Release/ProjectReleases.aspx?ReleaseId=575">the whitepaper</a>, IE8b1 doesn't support this. Here's the quote:

> Scripts in data URIs are unsupported because they allow potentially harmful script to bypass server- and proxy-script filters for applications such as HTML email. (Web-based email clients generally do not allow emails to execute script; data URIs could be used to easily bypass these filters).

I do agree that this is a valid point, it is a potential security issue, dataURIed javascript is even <a href="http://ha.ckers.org/xss.html">published as an XSS vector</a>. 

Please see <a href="http://sharovatov.ru/testcases/dataURI_JSXSS.html">the testcase</a>.

Opera and Safari run dataURI'ed HTML page in a separate isolated context, IE8b1 doesn't support dataURI'ed html at all, so the only affected browser here is Firefox. There's an interesting bugzilla <a href="https://bugzilla.mozilla.org/show_bug.cgi?id=296871">entry describing the XSS</a> (marked as duplicate to <a href="https://bugzilla.mozilla.org/show_bug.cgi?id=255107">the security proposal</a>) which says:

> The attack works by exploiting an ambiguity in RFC 2397 with regard to the Javascript same-origin security policy &#8212; what is the origin of a URI? Is it the containing page? If so, preventing this attack is the responsibility of site maintainers. If not, FF should launch the child of a data: URI without same-origin privileges.

Firefox authors reply that this is site maintainers' problem to filter dataURI and compare this to filtering `javascript:` (which is quite fair) but why did they want to create a new hole in all the sites for some vague benefits of executing dataURI'ed scripts in the same context?

To me it seems a bit weird especially looking at the fact that other browsers do care about execution context. <a href="https://bugzilla.mozilla.org/show_bug.cgi?id=255107">The bugzilla entry</a> is still opened, but I doubt that this is going to be fixed. So, “site maintainers”, be aware! (note from 2012 - this bug report is still open)

### Nested dataURI'es

Neither dataURI spec nor any other mentions if dataURI'es can not be nested. So here's <a href="http://sharovatov.ru/testcases/dataURI_extCSS_dataURI_img.html">the testcase</a> where dataURI'ed CSS has dataURI'ed image embedded. IE8b1, Firefox3 and Safari applied the stylesheet and showed the image, Opera9.50 (build 9613) applies the stylesheet but **doesn't show the embedded image**! So it seems that Opera9 doesn't expect to get anything embedded inside of an already embedded resource! :D

But funny thing, as IE8b1 supports expressions and also supports nested data URI'es, it has the same potential security flaw as Firefox does (as described in the section above). See <a href="http://sharovatov.ru/testcases/dataURI_JSXSSIE.html">the testcase</a> — embedded CSS has the following code: `body { background: expression(a()); } `which calls <var>function a()</var> defined in the javascript of the main page, and this function is called every time the expression is reevaluated. Though IE8b1 has limited expressions support (which is going to be explained in a separate post) you can't use _any_ code as the expression value, but you can only call already defined functions or use direct
string values. 

So in order to exploit this feature we need to have a ready javascript function already located on the page and then we can just call it from the expression embedded in the stylesheet. That's not very trivial obviously, but if you have a website that allows people to specify their own stylesheets and you want to be on the safe side, you have to either make sure you don't have a javascript function that can cause any potential harm or filter expressions from people's stylesheets.

### Line feeds
Firefox, Opera, Safari and IE8b1 support both data URI values supplied as one line (as an URI) and splitted by 76 bytes (as specified in <a href="http://tools.ietf.org/html/rfc2045">MIME</a> and <a href="http://www.faqs.org/rfcs/rfc2557.html">MHTML</a> RFCs). See <a href="http://sharovatov.ru/testcases/dataURI_extCSSIMGs_split.html">the testcase</a>.

But <a href="http://tools.ietf.org/html/rfc3548#section-2.1">base64 RFC</a> doesn't put a requirement to split base64 strings:

> MIME [3] is often used as a reference for base 64 encoding. However, MIME does not define "base 64" per se, but rather a "base 64 Content-Transfer-Encoding" for use within MIME. As such, MIME enforces a limit on line length of base 64 encoded data to 76 characters. MIME inherits the encoding from PEM [2] stating it is "virtually identical", however PEM uses a line length of 64 characters. The MIME and PEM limits are both due to limits within SMTP.

> Implementations **MUST NOT not add line feeds** to base encoded data unless the specification referring to this document explicitly directs base encoders to add line feeds after a specific number of characters.

### DataURIed images with images turned off
When you turn off images in your browser, only Firefox still shows dataURIed images. IE8b1, Safari and Opera don't show the image as it's supposed to be when you turn the images off. To test this turn off images in your browser and run <a href="http://sharovatov.ru/testcases/dataURI_img.html">the testcase</a>.

**UPDATE:** Firefox developers told me this is by design as unchecking “Load images automatically” option in the browser settings **disables only network request to get the image**. So if the image is accessible without doing a network request — either from cache or embedded as dataURI, it will be displayed in any case.

### Dynamically created dataURIes

As dataURI can contain binary data (e.g. to show images), there are thoughts on using this. Ajaxian has a <a href="http://ajaxian.com/archives/jsonvid-pure-javascript-video-player">crazy article</a> on creating pure JS video player that doesn't use flash but changes dataURI'ed images instead. This technique may get some practical evolution and usage, but now it's rather impractical.

### Links and references

* <a href="http://www.w3.org/MarkUp/html-spec/html-spec_9.html#SEC9.5">HTML 2.0 SGML declaration</a>

* <a href="http://www.w3.org/TR/html40/sgml/sgmldecl.html">HTML 4.01 SGML declaration</a>

* <a href="http://www.w3.org/MarkUp/html3/sgmldecl.dtd">HTML 3.0 SGML declaration</a>

* <a href="http://www.w3.org/TR/REC-html32#sgmldecl">HTML 3.2 SGML delcaration</a>

* <a href="http://go.microsoft.com/fwlink?LinkID=110274">Microsoft IE8 data URI support</a>

* <a href="http://xml.coverpages.org/xmlSGMLDecl970627.html">XML1.0 SGML declaration</a>

* <a href="http://www.boutell.com/newfaq/misc/urllength.html">Maximum Length of the URL</a>

* <a href="http://developer.mozilla.org/en/docs/How_Mozilla_determines_MIME_Types">How Mozilla determines MIME types</a>

P.S. And here’s a great tool from Nicholas C. Zakas – <a href="http://www.nczonline.net/blog/2009/11/03/automatic-data-uri-embedding-in-css-files/">CSSEmbed</a> – it reads the CSS file you want, finds all the images references, converts images to dataURIes and saves resulting CSS file. So if you have small presentational images referenced in your CSS file, feed CSSEmbed with your CSS file and you’ll get them all converted in one go! Nice and simple! This tool can be also easily integrated into your publishing process if required.