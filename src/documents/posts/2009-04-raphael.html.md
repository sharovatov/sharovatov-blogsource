---
layout: post
date: 2009-04
title: Raphaёl – excellent JS vector graphics library
---

When you need to create charts or do other graphically-reach stuff in your web application, you’re usually going to choose flash or silverlight, which is fine, but right a kerfuffle! :) I mean, you need to know one more technology while you could achieve nearly the same results just with Javascript and vml/svg.

And here comes <a href="http://raphaeljs.com/">Raphaёl</a> – awesome javascript library for providing a cross-browser way to operate with vector graphics written by Dmitry Baranovsky. Check out its demos – really impressive and works in all major browsers – IE6+, Firefox 3.0+, Safari 3.0+ and Opera 9.5+; and Safari on iPhone! It leverages VML functionality for IE and SVG for other browsers. While John Resig is still working on his processingjs.com (and it’s not working in IE at the moment), we already have a well-supported and easy-to-use library.

I did some tests of Raphaёl, and its performance was sufficient to use it in a production environment.

P.P.S. heh, <a href="http://en.wikipedia.org/wiki/VML">VML</a> is another thing that’s been invented by Microsoft (and Macromedia), then <a href="http://www.w3.org/TR/1998/NOTE-VML-19980513">proposed to W3C as a standard</a>; but W3C has always its own weird way – they decided to create <a href="http://www.w3.org/Graphics/SVG/">SVG spec</a> instead. I mean, really, spend time to spec what’s already been spec’ed so that the new spec doesn’t match the old spec – isn’t it weird?