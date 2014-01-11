---
layout: post
date: 2009-06
title: Efficient IE version targeting
---

When you’re writing a web page, you have to keep in mind that IE6 and IE7 have higher market share than all other browsers combined and IE8 has only started gaining popularity. So in most projects you have to support IE6 and IE7, even though IE6 support for CSS2.1 has a significant amount of bugs and issues. IE7 was slightly better and IE8 provides full CSS2.1 support, which is nice.

Some web-developers whose fanatic hatred to IE blows out common sense, <a href="http://sharovatov.wordpress.com/2009/05/22/universal-internet-explorer-6-css/">propose really weird “solutions”</a>, while all sane people support all their target audience browsers with <a href="http://marketshare.hitslink.com/browser-market-share.aspx?qprid=2">significant market share</a>.

So we have three IE versions with different level of CSS support. One of the most often mentioned issues is IE6’s lack of support for <a href="http://www.w3.org/TR/CSS2/selector.html#dynamic-pseudo-classes">`:hover `pseudo class</a> on elements other than links. IE7 and IE8 support `:hover` fully. Another sample is that IE8 supports <a href="http://msdn.microsoft.com/en-us/library/cc304082(VS.85).aspx#gen_content">`:after` and `:before` generated content elements</a> while IE6 and IE7 don’t. These are just two samples that spring to my mind just to show that level of CSS2.1 support really differs.

The first thing that most web-developers would use to specify a CSS rule for different browsers would be CSS hacks. But this leads to problems. For example, when IE7 wasn’t yet published, and people were using IE6, many developers used star selector bug to fix CSS2.1 issues in IE. When IE7 was shipped, it fixed support for star hack, but didn’t fix all the CSS2.1 issues. So using CSS hacks is **perfectly backwards compatible** – you know in which already shipped browsers and their versions it works – but is **not future-compatible**. This is because CSS hacks do not provide an obvious mechanism for a version targeting.

## Conditional comments to rescue

Microsoft was aware that this problem would occur and in IE5 (and all newer versions, of course) they included <a href="http://msdn.microsoft.com/en-us/library/ms537512(VS.85).aspx">conditional comments</a> feature. There’s a perfect PPK’s post about <a href="http://www.quirksmode.org/css/condcom.html">“conditional comments”</a> with samples so I’m not going to dive into details of conditional comments in this post. The main thing is that you can specify a version vector (IE version) and serve different IE versions with separate content – usually, CSS files.

Conditional comments allow to _configure_ compatibility.

I consider a best practice to set one separate CSS and JS file for Internet Explorers that are older than IE8:

	<!--[if lte IE 7]>
		<link rel="stylesheet" type="text/css" href="iefix.css">
	<![endif]-->

And inside this iefix.css I use star selector hack to fix issues in IE6 and lower:

	* html #someElement { /*rules for IE6 and lower */ }

Using star selector hack here is a perfect way to target IE6 and lower:

* we are aware that star selector CSS hack was fixed in IE7

* we are inside a CSS file that is only served to IE7 and lower

It’s perfectly future-compatible (IE8 and newer versions won’t fetch it as it’s inside a conditional comments) and also perfectly backwards-compatible (we know that star selector hack works in IE6 and lower versions).

So there’s no real need for a separate CSS file for IE6 and lower because we can easily separate IE7 and lower versions’ rules inside our iefix.css file.

## Version targeting in javascript

There are cases when adding some javascript for IE6 and lower versions is required, for example, if you want to emulate `:hover` support on some elements.

Microsoft thought about this and along with conditional comments provided a <a href="http://msdn.microsoft.com/en-us/library/ahx1z4fs(VS.71).aspx">conditional compilation</a> technique. The approach is very similar – you put some javascript code inside **/*@cc_on @*/**
comment block and IE parses it.

To control which version to target, special <a href="http://msdn.microsoft.com/en-us/library/7142yyxw(VS.71).aspx">conditional compilation variable</a> `@_jscript_version` is provided. This variable shows the build number of JScript compiler. Different versions of IE had different JScript compiler versions: IE5.01 had `@_jscript_version` of 5.1, IE5.5 – 5.5, IE6 – 5.6, IE7 – 5.7 and IE8 – 5.8. 

**And this approach worked fine until Windows XP Service Pack 3 was shipped which replaced IE6’s JScript compiler of version 5.6 with a newer one of version 5.7**. Before SP3 you could use the following code to separate IE6 from IE7 and upper
versions:

	/*@cc_on
		if (@_jscript_version < 5.7) {
			//code for IE6 and lower
		} else {
			//code for IE7 and upper
		}
	@*/

But when SP3 was installed, IE6 JScript compiler was updated and wouldn't enter the first if clause. This was a serious compatibility issue and many libraries had to update their code to find a workaround. The problem was that we were solving an issue of one technology (CSS) with another (javascript), and these technologies are supposed to be loosely coupled. So JScript was upgraded, new features were added, but CSS wasn’t. This leads me to a conclusion that

## Using conditional compilation version targeting to solve CSS problems is wrong

Again, these technologies are loosely coupled and you cannot assume that if `@_jscript_version` is **X**, CSS parser version is **Y**.

So ideally, if you want to support `:hover` for IE6 and lower in javascript, serve a separate javascript file for them using conditional comments.

**But if want to support something that’s not provided in a specific version of JScript compiler – using conditional compilation is perfectly valid**.

P.S. Well, if you still want to separate all IE6 from IE7, here’s a snippet that would work:

	/*@cc_on
		if (@_jscript_version==5.6 ||
			(@_jscript_version==5.7 &amp;&amp;
			 navigator.userAgent.toLowerCase().indexOf("msie 6.") != -1)) {
				//ie6 code
			}
	@*/

So even if Windows XP user installed Service Pack 3 which updated JScript compiler to version 5.7, IE6 own version will still be 6. And it’s perfectly safe to use userAgent sniffing inside a conditional comments block which will be run in IE only.