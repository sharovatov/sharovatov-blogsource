---
layout: post
date: 2009-04
title: Weird bug with hiding columns in IE7
---

Sometimes when you create a table, you need to dynamically toggle certain columns visibility. I usually use the following approach:

* Set those columns that are supposed to be hidden and shown with a className, e.g. `tohide`

* Set their parent with some className, say, `hiddenChildren`.

* Define the following CSS rule: `.`hiddenChildren `.tohide { display: none }`, which basically says that if there is a parent node with `className="hiddenChildren"` and it has child nodes with `className="tohide"`, all these child nodes will be hidden.

* When I need to show cells, I remove this `hiddenChildren` class from parent’s className, and when I need to hide them again, I add it back.

This is a very common scenario and it’s much more efficient than the approach where you go through all the elements in javascript and toggle their personal display mode.

There’s also an _inverted_ approach where by default elements are hidden and assigned class specifies _positive_ display – `table-cell` for CSS2.1-compliant browsers and `block` for IE6. But my approach is better as it’s cleaner – there’s no need for IE6-specific code (usually assigned by star hack).

However, in IE7 with both of the approaches the cells’ display is not switched as you may notice by viewing <a href="http://sharovatov.ru/testcases/hideColumns0.html">the testcase</a>.

But as in most cases, there’s a workaround – you have to “poke” any TH of your table. In <a href="http://sharovatov.ru/testcases/hideColumns1.html">this testcase</a> I added the following code:

	/*@cc_on if (!document.querySelector)
		document.getElementsByTagName('th')[0].className = 'wt2'; 
	@*/

to the toggling function. As you may know, js code within `/*@cc_on ... @*/` block will be executed only by IE, and only IE8 has support for `document.querySelector` interface, so chances are that this code will be executed only in IE with version earlier than 8, which is precisely what we need (as IE8 doesn't have this problem).

It’s interesting to know, that YUI Team in their <a href="http://developer.yahoo.com/yui/datatable/">DataTable control</a> in order to implement hiding/showing functionality choosed to loop through all the cells and set their display individually (see `hideColumn`/`showColumn` functions <a href="http://yui.yahooapis.com/2.7.0/build/datatable/datatable.js">here</a>). I understand that this is the bulletproof approach ready to use in any environment, but it can be rather ineffective when your table has a significant amount of rows as it will have to go through all the TR’s. And it will do the loop twice if you choose to hide two columns :) Of course, using my approach requires setting classes for those cells that you were going to hide, so it’s not that flexible, but in the controlled environment it’s definitely the best option.