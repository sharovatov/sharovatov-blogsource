---
layout: post
date: 2014-04
title: iOS 7 minimal ui and smart app banners
tags:
    - css
    - webdev
    - ios7
---

With iOS6 release Apple [introduced a nice way to promote a native app on a webpage opened in Safari](https://developer.apple.com/library/ios/documentation/AppleApplications/Reference/SafariWebContent/PromotingAppswithAppBanners/PromotingAppswithAppBanners.html) and this approach is widely used across the industry.

And in iOS7 Apple introduced a new meta viewport value — [minimal-ui](http://www.mobilexweb.com/blog/ios-7-1-safari-minimal-ui-bugs) which was hugely welcomed by web-developers as it provided a much nicer browser UX (by making browser controls look modal rather than just a part of the page), more available real screen size and removed the untouchable area in the bottom of the page that was reserved for the browser UI. And all is well until a ”smart app banner” is added to the page — then the smart app banner suddenly gets a noticeable margin-top and the header gets almost hidden under the banner.

Here’s a screenshot of the issue: 

![ios7 fixed header with minimal-ui and smart app banner](http://sharovatov.ru/ios6/ios7-smart.png)

(small blue line is actually a normal element of 30px height)

And [here’s the testcase with minimal-ui](http://sharovatov.ru/ios6/smart2.php?minimal=1) and [here’s without](http://sharovatov.ru/ios6/smart2.php).

I couldn’t find any workaround for this issue, so I had to turn off minimal-ui for the page that has the smart app banner, at least until Apple fixes this.