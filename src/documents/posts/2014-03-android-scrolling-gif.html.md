---
layout: post
date: 2014-03
title: Android native browsers scrolling bug when gif animation is present
tags:
    - css
    - webdev
    - ios6
---

Android standard browser (up to kitkat 4.4) is usually more expensive to support than iOS Safari or Android Chrome, partly because it’s buggy and mostly because of the lack of tooling — Android webkit doesn’t expose a javascript debbuging API and hence the only way to remotely debug javascript is from within the page — using what’s available — putting debug data into a DOM element or even plainly alerting some intermediate results. *rant mode on* Even IE5.5 allowed javascript debugging with MS Office Script Debugger but who at Google cares about what’s considered a common sense for at least 12 years already? *rant mode off*. For browsers that don’t expose a JS debugging API (and having no developer tools) the only tool worthy of note is [weinre](http://people.apache.org/~pmuellr/weinre/docs/latest/Home.html) which can be of help for basic CSS and DOM inspection, but it still uses current page DOM and therefore will never be able to provide any access to the javascript engine internals (e.g. provide breakpoints capability).

And that’s why sharing bugs (and corresponding workarounds) found in native Android webkit browser is even more valuable. 

The bug I found recently is simple yet impressively stupid: when you have a horizontally scrolled (`overflow-x: auto; overflow-y: hidden;`) block that has an animated gif element in it, and you set scroll handler on the scrolling element and try scrolling, scroll events will never stop firing.

The way I came across this issue was simple: it’s a well-known fact that both iOS Safari and Android Chrome fire the scroll event only when scrolling is finished, but Android webkit does something extremely stupid — it fires scroll event multiple times during scrolling, making its already bad javascript performance even worse. So if a developer wants to handle scrolling events properly and universally detect when scrolling is finished in iOS Safari, Android Chrome and Android webkit, the simplest option is to wrap scrolling event handler in a debouncing function with a reasonable timeout (which basically allows the actual handler to run only if enough time passed from the last call).

However, when I wanted to do an AJAX infinite scrolling with some animated gif preloader at the end of the elements’ list, I witnessed an amusing behaviour — debounced scrolling event handler was never called, which in turn was caused by the fact that scrolling event never stopped firing!

To get the idea of how it looks — check the [testcase link](http://sharovatov.ru/ios6/gif.html) in the standard Android webkit browser that you have.

The initial behaviour is correct, if you scroll the horizontal block with coloured rectangles, you will see dashes filling the line in the textarea while scrolling is occuring (a dash is added for every onscroll event fired), and when the scrolling stops and debounce function is called, a message ”debounced scroll fired” is added to the textarea. 

However, if an animated gif image is added inside the last element or set as its background, scrolling event handler will never stop firing. This can be observed by clicking ”gif animation” button — it will add a small animated gif (spinner) to the background of the last element, and dashes (visualising onscroll event firing) will never stop appearing. Hence, debounced wrapper will never be called. 

The simplest workaround is just forgetting animated gifs that confuse Android webkit so much and using CSS3 animations, which work correctly (as can be checked in the same testcase by clicking on ”CSS3 animation” button).

And what’s even more fascinating — the bug is not reproduced on every Android device, for example, HTC One V doesn’t have it for some reason. 

I still struggle to understand what can cause the bug internally and why it’s reproducing on some devices and not other. Maybe it’s a certain gif library version, or manufacturer settings of some sort. I searched for animated gif issues in the [Android bug tracker](https://code.google.com/p/android/) and could find a few: https://code.google.com/p/android/issues/detail?id=3422 https://code.google.com/p/android/issues/detail?id=35544 and https://code.google.com/p/android/issues/detail?id=29732 — seems that Google didn’t pay enough attention to GIF support in their standard browser, probably due to the intention to move to Chrome Android soon. In any case, until [Google Dashboard](https://developer.android.com/about/dashboards/index.html) shows that Kitkat takes 95% of the market and older versions’ market share is negligible, web-developers will have to know how to find workarounds for all the Android webkit issues and managers will have to understand that the additional amount of effort is required to support this platform.