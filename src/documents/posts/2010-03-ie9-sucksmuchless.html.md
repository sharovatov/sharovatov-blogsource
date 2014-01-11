---
layout: post
date: 2010-03
title: IE9 - sucks much less than other browsers
---

I won’t repeat everything that’s been said on <a href="http://live.visitmix.com/">Mix</a> now, you should read <a href="http://msdn.microsoft.com/en-us/ie/ff468705.aspx">this article</a> and <a href="http://blogs.msdn.com/ie/archive/2010/03/16/html5-hardware-accelerated-first-ie9-platform-preview-available-for-developers.aspx">this IEBlog entry</a> and get the <a href="http://ie.microsoft.com/testdrive/">IE platform preview</a>. Don’t be afraid that IE9 will spoil your IE8 – IE9 preview doesn’t replace IE8 or anything, it’s got new jscript engine (called “Chakra”), new Trident layout engine version and wininet bundled in one package (31 megabytes installed size!) – first time when Microsoft does it this way – very impressive!

This preview will be updated each few weeks – the work isn’t finished, UI is still in a very “beta” mode:

<a href="http://sharovatov.files.wordpress.com/2010/03/ie91.jpg" target="_blank"><img title="ie9" border="0" alt="ie9" src="http://sharovatov.files.wordpress.com/2010/03/ie9_thumb1.jpg?w=256&#038;h=208" width="256" height="208"></a>

Most important changes IE9 has from IE8:

* JIT-powered js optimisation in jscript engine (Sunspider reports speed faster than Firefox 3.7 alpha2) – looks similar to Apple’s Nitro JIT.

* new Trident with more CSS3 support – <a href="http://dev.w3.org/csswg/css3-background/">CSS3 Selectors</a> module, <a href="http://dev.w3.org/csswg/css3-background/">CSS3 Borders and Backgrounds</a> module (passes <a href="http://tools.css3.info/selectors-test/test.html">CSS Selectors tests</a>)

* <a href="http://www.w3.org/TR/2000/REC-DOM-Level-2-Style-20001113/">DOM2 Styles</a> support

* <a href="http://dev.w3.org/SVG/profiles/1.1F2/publish/">SVG 1.1 2nd ed</a> support (plus hardware acceleration)

* XHTML support (with proper namespaces support)

* complete hardware acceleration support for graphics and text rendering, which makes any animation in IE9 WAY much faster than in other browsers – you should look at videos

* HTML5 video support with h264 codec with proper hardware acceleration support (kicks Chrome’s ass, allows 2 simultaneous HD 720p video playbacks via HTML5 video on a cheap netbook). Another nail in the OGG coffin :)

* <a href="http://www.w3.org/TR/DOM-Level-3-Events/">DOM Events</a> support

And IE9 is ridiculously fast. That’s partly due to the fact that “Chakra” jscript compiles javascript in a separate CPU core in parallel to IE (natural improvement to <a href="http://blogs.msdn.com/ie/archive/2010/03/04/tab-isolation.aspx">LCIE</a>), and partly because of hardware optimisation for all rendering and animations.

Unfortunately, IE9 is not available for Windows XP (and it won’t be), the main reason is the security model – basically, XP security model just doesn’t suit for IE9. Quite right, XP is nearly 10 years old! Another reason is that graphical core on Windows XP works in a different way, so IE9 hardware acceleration just cannot work there.

Of course, IE9 follows the same logics IE8 has in terms of backwards compatibility – rules that <a href="http://sharovatov.wordpress.com/2009/05/18/ie8-rendering-modes-theory-and-practice/">I described here</a> apply to IE9 – if X-UA-Compatible header/meta is set to **Edge**, IE9 new engine will run. Of course, it will render sites with correct doctype (but withouth X-UA-Compatible) in IE9 standards mode, and it will continue support for <a href="http://go2.wordpress.com/?id=725X1342&amp;site=sharovatov.wordpress.com&amp;url=http%3A%2F%2Fsupport.microsoft.com%2Fkb%2F960321">compatibility view lists</a> feature. So old crappy sites designed for IE6 will still work in compatibility mode, and new sites will work in awesome IE9 in the standards mode without any problems. Read the abovementioned post for more details.

Improvements that will be done later:

* better Ecma262 conformance and as a result, better ACID3 scores (current score is 55, IE team promises to improve this significantly, I think it will pass the test by the time RC ships

* support for other CSS3 standard modules

* canvas support – wasn’t announced, but I think this is a natural move when SVG is already done and done properly!

But anyway, the whole feeling after watching IE9 keynote session is IT’S AWESOME!

We’re entering the new era when Microsoft browser is faster than others, more secure (it’s been more secure than others since IE8b1) and provides better level of standards support.

P.S. To see the real speed just run <a href="http://ie.microsoft.com/testdrive/">these test</a> on IE9 platform preview and on any other browser and feel the difference :)

Some links:

* <a href="http://channel9.msdn.com/posts/Charles/Introducing-the-IE9-Developer-Platform-Preview/">In your hands: Introducing the IE9 Developer Platform Preview</a>

* <a href="http://channel9.msdn.com/posts/Charles/In-your-hands-IE-9-Surfing-on-Metal-GPU-Powered-HTML5/">In your hands: IE 9 – Surfing on Metal with GPU Powered HTML5</a>

* <a href="http://channel9.msdn.com/posts/Charles/In-your-hands-IE-9-Performance-From-JS-to-COM-to-DOM-to-HTML5-on-GPU/">In your hands: IE 9 Performance – From JS to COM to DOM to HTML5 on GPU</a>

* <a href="http://channel9.msdn.com/posts/Charles/In-your-hands-IE9-and-SVG-Past-Present-and-Future-of-Vector-Graphics-for-the-Web/">In your hands: IE9 and SVG – Past, Present and Future of Vector Graphics for the Web</a>

* <a href="http://blogs.msdn.com/ie/archive/2010/03/16/html5-hardware-accelerated-first-ie9-platform-preview-available-for-developers.aspx">HTML5, Hardware Accelerated: First IE9 Platform Preview Available for Developers</a>

* http://ie.microsoft.com/testdrive/