---
layout: post
date: 2014-02
title: iOS6 Safari "scroll to top" doesn’t work when -webkit-overflow-scrolling: touch is set
tags:
    - css
    - webdev
    - ios6
---

iOS5 introduced a useful CSS property that brings overflow’ed elements native scrolling animation: `-webkit-overflow-scroll: touch`. However, recently I noticed that in iOS6 if this property is set on at least one element on the page, the whole page stops scrolling to top when user taps the top of the page.

Here's a [testpage](http://sharovatov.ru/ios6/index.html), when it's initially loaded, the horizontal list of square icons is scrollable but doesn't have `-webkit-overflow-scroll: touch` set, so the horizontal list scrolling looks more like dragging the elements rather than proper native scrolling. But if you scroll down and tap the top of the screen, the page gets scrolled to top, rightly as intended.

And when "set -webkit-overflow-scrolling: touch" button is clicked, scrolling experience in the horizontal list gets accelerated and native scrolling experience is enabled. However, tap-on-top suddenly stops working.

I could not find any quick hack to get both `-webkit-overflow-scroll: touch` and tap-on-top working, so if both features are required for your design and you have to support iOS6, I suggest replacing `-webkit-overflow-scroll: touch` with [natural kinetic scrolling](http://ariya.ofilabs.com/2013/08/javascript-kinetic-scrolling-part-1.html) only for iOS6. 

iOS7 has this bug fixed, and [according to Apple](https://developer.apple.com/support/appstore/), iOS7 adoption is 87% already, so there's less and less sense in spending resources on supporting iOS6, especially with such minor issues.

