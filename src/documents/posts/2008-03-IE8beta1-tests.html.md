---
layout: post
date: 2008-03
title: Some IE8b1 test results:
---

# IE8b1 intitial tests 

* As earlier,` alert([1,2,3,].length)` shows **4** and 4<sup>th</sup> element has `undefined` value.

* Unfortunately no support for so wanted `:last-child` CSS3 Selector and buggy support for dynamically added elements that match `:first-child` and should therefore enforce layout to be recalculated. See <a href="http://www.quirksmode.org/css/firstchild.html">PPK's testcase on quirksmode.org</a>.

* We can't set padding on html element for some reason - see <a href="http://sharovatov.ru/testcases/htmlPadding.html">testcase</a>.

But I really enjoy Selectors API implemented in IE8b1.	It was the second browser to support this right after Webkit. I will describe the support and prepare some testcases in the next post.

I've tested generated content model in IE8b1 quite thoroughly, have found quite weird bugs and here's what I've come up with:

* First bug I've noticed was happening when you set `position: relative` for the generated content rule. The tab where you have this page opened dies. And then due to newly introduced <a href="http://www.microsoft.com/windows/products/winfamily/ie/ie8/readiness/NewFeatures.htm#crash">crash recovery system</a>, it tries to recover the tab, loads the page and dies again and so on - an infinite loop that you can't break. But the weird thing is that it doesn't actually _die_ - it shows a window promting to select a debugger. The kind of window that appears when you have errors in your javascript code.

	here's the code sample:

		p:before {content: "test"; position: relative;}` 

	and <a href="http://sharovatov.ru/testcases/genPosition.html">the testcase</a>.

* I noted the bug and continued testing. 
	Next thing I came up with was the fact that if the page doesn't have IMG/OBJECT/IFRAME elements or an image set as a background for an element, generated content is created **after** `window.onload`!

	Please have a look on the following testcases:

	* Document contains <a href="http://sharovatov.ru/testcases/textOnly.html">None of the elements listed above</a>, and generated content **is not being generated** till you press OK. It means that generated content is created **after** `window.onload` occurred!

	* Generated content is created before `window.onload` as it should be in the following cases:
		<a href="http://sharovatov.ru/testcases/withCssBg.html">an element has CSS `background-image` rule set</a>,
		or page includes one of the elements: <a href="http://sharovatov.ru/testcases/withImage.html">IMG</a>,
		<a href="http://sharovatov.ru/testcases/withObject.html">OBJECT</a>
		or an <a href="http://sharovatov.ru/testcases/withIframe.html">IFRAME</a>


* At this point I thought - wait - it's strange - all CSS rules were always
	applied _before_ `window.onload`! Anyway, I just went on testing.

* And then there was another strange thing - when you use `content: attr(class)`, IE8b1 doesn't show the attribute value but shows `null` instead. But if you set the rule as `content: attr(className)`, it actually shows the attribute value!

	Here's <a href="http://sharovatov.ru/testcases/classNameBug.html">the testcase</a> for this bug.

* And another interesting thing is that `expression` doesn't work in generated content rules.
	Please see <a href="http://sharovatov.ru/testcases/genContExpression.html">the testcase</a>.

Of course I can only guess but my feeling is that IE8b1 doesn't have proper support for the generated content, it's rather done by a hook somewhere firing off the function that generates the content. All these four bugs have something in common - debug window (that's usually shown for javascript errors); generating content after `window.onload` in some cases; reading `class` attribute value by its DOM name (`className`). Basically it's all about javascript.

And I can't help thinking that IE8b1 uses some hidden javascript code to support generated content. And this functionality is triggered by some hidden event like DomContentLoaded.

And if so I would be really happy if they could give us access to this handler :)

# Selectors API and IE8b1

As mentioned above, IE8b1 introduced support for very powerful DOM accessing concept - <a href="http://www.w3.org/TR/selectors-api/">Selectors API</a>. It is still a W3C working draft, but I bet that as IE and Webkit already support it, Presto and Gecko will soon have it as well.

So what do we have? As per the <a href="http://www.w3.org/TR/selectors-api/">spec</a>, we have 2 methods: `.querySelector()` and `.querySelectorAll()` which can be applied to any <var>HTMLElement</var> and based on he parameter (CSS selectors string) provided return an <var>Element</var> or <var>StaticNodeList</var> populated with elements matching the provided CSS selectors. Bottom line, you give it CSS selector, they return you matching element(s).

It provides you with a new flexible way to select elements in DOM. We can do any weird and wonderful stuff we want with the power of JS combined with the flexibility of CSS selectors:

* Get all paragraphs with the `.note` classname from one div? Not a problem – `document.querySelectorAll('#myDiv .note');`

* Get all elements with some classname? Forget about `document.getElementsByClassName` slow kludges - use `document.querySelectorAll('.myClass');`

* Get a link with `.current` classname from your UL-based menu? `document.querySelector('#menu .current');`

So generally we don't have to iterate over huge <var>StaticNodeLists</var> anymore - it's done natively and very fast (much faster then by JS libraries). Please see <a href="http://webkit.org/perf/slickspeed/">the testcase prepared by Webkit authors</a> to measure
their Selectors API support - it works in IE8b1 except for CSS3 Selectors block (IE8b1 doesn't support CSS3 `:nth-` and `:last-child` selectors).

Bottom line, **Selectors** is a way to find elements in DOM. All browsers know how do it already when they parse CSS rules and find elements to which these rules have to be applied. So it's just an existing browser functionality exposed to the developer. And we have to keep in mind that if browser supports a CSS selector, it will allow you to query for this element using **Selectors API**. And obviously if there's no support for some CSS selector, you won't be able to get this element using **Selectors**.

For example, as IE8b1 doesn't support `:last-child` CSS3 selector, you can't style such
elements in CSS and you can't query them using **Selectors**.

## Notes:

* Unfortunately, IE8b1 doesn't fully implement the <a href="http://www.w3.org/TR/selectors-api/">Selectors API spec</a>. Here's the <a href="http://msdn2.microsoft.com/en-us/library/cc288326(VS.85).aspx">MSDN article</a> quotation:
> Because Internet Explorer 8 does not formally support XHTML documents, it does not support the namespace features of the W3C Selectors API specification, such as the <var>NSResolver</var> parameter.
	But for websites where namespaces are not used it's not gonna be of any problem.

* Another interesting issue that Selectors API spec raises is a potential history theft.

	Basically you can get all visited links `href`s and send them by AJAX somewhere (just a matter of getting a <var>StaticNodeList</var> of elements by doing `document.querySelectorAll("a:visited")`).

	<a href="http://www.w3.org/TR/selectors-api/">Spec leaves it for the vendor to fix</a>. So IE8b1 ignores the `:visited` and `:link` selectors when they appear in the selector query criteria.

	Please see the <a href="http://sharovatov.ru/testcases/example.html">Testcase</a>

## Attribute selectors

Both `[class=myclass]` and `[className=myclass]` work in IE7/IE8. The last one can be used as a CSS hack to target those browsers, but I would still recommend using conditional comments to target different IE versions.

If you look at <a href="http://sharovatov.ru/testcases/attrClassName.html">the testcase</a>, you will see that both `[class=test1]` and `[classname=test2]` selectors work. When I saw className working, I immediately tested other DOM properties like nodeName. Unfortunately, it didn't work there - <a href="http://sharovatov.ru/testcases/attrClassName2.html">here's the testcase</a>. If it did, if there was such a way to access not HTML attribute but DOM properties from CSS selectors, it would be really weird but interesting.

## Generated content

When I was <a href="http://sharovatov.wordpress.com/2008/04/08/ie8b1-generated-content-support/">testing it</a>, I noticed that if you want to get element's class, you can't use `content: attr(class)` rule, you have to use `content: attr(className)`. It's obvious that this is a DOM property name rather than HTML element's attribute.

This violates the standard which clearly says that `attr(X)` must return an attribute string value for the element matching the selector. It also violates the standard by returning `null` value for not existing attributes.

This behavior also gives us some strange options. Please see <a href="http://sharovatov.ru/testcases/genContJs.html">the testcase</a>.

I don't know if it's a bug or a feature - none of the Microsoft documents on IE8 describes this behaviour, so I don't know if this is going to be fixed or not; but it may be used in some interesting ways.<br>E.g. using `outerHTML` IE-only DOM property I rebuilt <a href="http://sharovatov.ru/testcases/attrClassName3.html">the testcase</a> for the attribute selectors bug mentioned above. If you have IE8, don't wait to have a look. And please have a look at another <a href="http://sharovatov.ru/testcases/DOMgenCont.html">interesting thing</a> - again it's IE8-only as it uses `attr(nodeName)` function to show every element's nodeName.

During testing I've noticed some more bugs with generated content:

* text-transform doesn't work for generated content. Please see <a href="http://sharovatov.ru/testcases/genContTextTransform.html">the testcase</a>

* text-indent doesn't work for generated content. <a href="http://sharovatov.ru/testcases/genContTextIndent.html">Here's the testcase</a>

* text-align doesn't work for generated content. <a href="http://sharovatov.ru/testcases/genContTextAlign.html">The testcase</a>

# IE8 and expressions
Internet Explorer keeps on changing. One example is <a href="http://msdn.microsoft.com/en-us/library/ms537634.aspx">expressions</a> - their support is dropping from version to version. In different versions of IE <a href="http://sharovatov.ru/testcases/expressions_test.html">this testcase</a> produces <a href="http://sharovatov.ru/testcases/expressions_shots.html">the following output</a>.

So IE started filtering values in expressions since IE6, and now IE8b1 in both modes doesn't even allow you to use object property accessors (both dot and square brackets notations - see <a href="http://sharovatov.ru/testcases/exp_propacc.html">testcase</a>). So in IE8b1 in expressions you can only use plain string values in your expressions (which is not handy at all) or call externally defined functions.

I can't think of any other reason for disabling this except for protecting from potential XSS threat that I described in the previous post.

Also in IE8b1 expressions are not reevaluated on <var>mouseover</var> event (see <a href="http://sharovatov.ru/testcases/exps_recalc.html">testcase</a>), but <var>onscroll</var> still fires `document.recalc` (this again seems to be left intentionally in order to support all cludges that were invented to implement for example non-existent position: fixed CSS rule).

Bottom line, if you have expressions used in your CSS code, don't wait - separate all the stuff you do there to JS functions and just call these functions from your expressions.