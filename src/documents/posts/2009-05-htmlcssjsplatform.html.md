---
layout: post
date: 2009-05
title: HTML+CSS+JS Widgets - future cross-platform environment
---

Yesterday I installed Windows 7 on both my laptop (MSI Wind U100) and work PC (Core2Duo with 2Gb RAM). Both machines had XP – Home on laptop and Pro on work PC. One of the first things I’ve noticed right after installation was Gadgets technology that Windows 7 supports (actually, support for Sidebar Gadgets appeared in Vista, but as I didn’t have Vista installed, I couldn’t check it out). The technology is very simple – you create a manifest file with your gadget settings and HTML file with your gadget code, styles and scripting (of course, you’d better put styles and js in separate files); then zip everything in one archive and rename its extension to .gadget. That’s it, then you can install it on your sidebar in Vista or Windows 7.

Technical details of how gadgets work are for one of next blog posts, but I feel the tendency that all small applications soon will be written in HTML/JS/CSS (especially those that use web-services!).

Look, Opera has proposed a <a href="http://www.w3.org/TR/widgets-apis/">draft to W3C called Widgets</a> – the same concept of small HTML/CSS/JS application but running inside a browser. Vodafone <a href="http://www.quirksmode.org/blog/archives/2009/03/testing_mobile.html">hired PPK</a> to spec Mobile Widgets technology and test thoroughly (and Peter-Paul is famous for his great tests and compatibility tables!). Nokia already supports
<a href="http://www.s60.com/life/thisiss60/s60indetail/technologiesandfeatures/webruntime">Web Widgets</a> on S60 phones.

So instead of multiple environments we have one common environment for building applications for almost any platform – be it a browser, a mobile phone or Windows desktop. Yes, there’re API and DOM differences, for example, Windows Gadgets allow access to WMI so that you can build an application leveraging all the system functionality provided by WMI, on the phones and in Opera you will be limited to web-service based development and some pretty basic DOM, but even so it’s great that html/js/css is becoming a standard for writing cross-platform applications.

Front-end developers – our skills will become even more valuable :)