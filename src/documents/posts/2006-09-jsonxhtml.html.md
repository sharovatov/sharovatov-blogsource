---
layout: post
date: 2006-09
title: Javascript on XHTML pages
---

There are lots of rumours about Javascript in XHTML served as different MIME types. I'll try to explain what's really going on. Shortly, <var>innerHTML</var> works everywhere (even for XHTML served as <var>text/xml</var>); <var>document.*</var> collections work identically for <var>application/xhtml+xml</var> and <var>text/html</var>.

### XHTML served as <var>text/html</var>

There are two main differences in DOM between **valid** HTML and XHTML served as <var>text/html</var> - in XHTML all elements are in lowercase and UAs don't create implicit elements such as <var>tbody</var> in XHTML. That's all! You don't need to put inline styles and scripts in <var>CDATA</var> sections. UAs handle these XHTML pages practically the same as they handle HTML ones, xml well-formedness is not checked. And of course, all <var>document.*</var> collections work, innerHTML works either. And yes, <var>document.all</var> works even in Firefox (since version 1.5).

Yes, there's also a problem of marking inline scripts and style as CDATA sections, but with well-coded unobtrusive javascript there's no need for inline scripts, and there's definately no need for inline styles except rare cases (even LJ allows using external CSS
files).

### XHTML served as <var>application/xhtml+xml</var>

That is the preferred MIME-type for XHTML pages. Commonly it is used with content-negotiation mechanism to serve pages as <var>application/xhtml+xml</var> for browsers that support it and to serve pages as <var>text/html</var> for <a href="http://microsoft.com/windows/ie">browser</a> that doesn't support <var>application/xhtml+xml</var>. Some people say that most of neat DOM methods and properties do not work in XHTML document served as <var>application/xhtml+xml</var>. They say:

* document.write doesn't work

* innerHTML doesn't work

* document.applets, document.forms, document.anchors, document.images, document.links, other document.* collections don't work

* document.all doesn't work

* document.body and all other properties of <var>document</var> don't work

### They are completely wrong.

XHTML document served as <var>application/xhtml+xml</var> has **the same DOM** as XHMTL served as <var>text/html</var>.

At first Mozilla has been creating XMLDocument object for pages served as <var>application/xhtml+xml</var>, but then there was opened a <a href="https://bugzilla.mozilla.org/show_bug.cgi?id=111514">Bug</a> in December 2001, and the first fix was proposed in March 2003 and in two monthes final fix was accepted. Since that time Mozilla started creating HTMLDocument object for XHTML pages served as <var>application/xhtml+xml</var> and therefore they had to support all that HTML stuff: 
	document.write, document.applets, HTMLElement.innerHTML, document.forms, document.anchors, document.images, document.links, document.cookie

The only thing they didn't support is <var>document.all</var>, it's only supported in quirks mode of document served as <var>text/html</var>. 

As for Opera: it checks <var>namespace</var> of <var><html></var> element to understand if it is xhtml and therefore there should be a HTML DOM or if it is a xml document and there should be XML DOM. And yes, Opera provides HTML DOM for ALL MIME types that XHTML can be served as.

### XHTML served as <var>application/xml</var> or <var>text/xml</var>

Mozilla creates XMLDocument for XHTML served as <var>application/xml</var> or <var>text/xml</var>, so it doesn't provide HTML DOM for such documents. But Opera does.

### <var>innerHTML</var>

Yes, that may sound strange, but it's a fact - <var>innerHTML</var> is supported everywhere, FOR EVERY XHTML MIME-TYPE.

### Conclusion

There's quite little amount of problems concerned XHTML served as <var>application/xhtml+xml</var>, javascript works fine since there's the same HTML DOM as it would have being served as <var>text/html</var>. When you serve XHTML as <var>text/html</var> or <var>application/xhtml+xml</var>, in both case you will have eqaul HTML DOMs. So don't be afraid
of all those scary stories of not working <var>innerHTML</var> or <var>document.forms</var> - it's all a lie.

### <a href="http://nix.vlz.ru/test/">For those who don't believe me.</a>