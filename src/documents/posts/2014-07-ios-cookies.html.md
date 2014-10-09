---
layout: post
date: 2014-07
title: iOS javascript cookies persistence
tags:
    - webdev
    - iOS
---

I’ve recently come across an interesting issue in iOS Safari — if the browser is forced to quit, a cookie I set in javascript is forgotten when the browser is reopened.

A [minimal test page reproducing the issue](http://sharovatov.ru/setcookie.php) was prepared. The page provides two options to set the cookie — via a server-side php `setcookie` call and via a clientside javascript `document.cookie` call.

If you set the cookie via javascript, all is fine until you close the browser: you can safely navigate to any other page on this or other domains and the cookie will retain as long as its expiry period lasts. However, if you force the browser to close, the cookie that was set in javascript gets forgotten. I couldn’t find any online resource explaining the behaviour, but only questions like [this](http://stackoverflow.com/questions/17669938/in-ios-safari-cookie-data-gets-destroyed-on-closing-browser-from-background-i) or [that](http://stackoverflow.com/questions/20041399/mobile-safari-clears-cookies-and-localstorage-on-hard-reset). 

It seems to be a bug in iOS Safari, I can’t find out any reasonable explanation for why cookies set in javascript should differ in behaviour from those set from server-sent HTTP header. I can only guess that in iOS Safari javascript-set cookies are retained in some in-memory storage which is not serialized to the storage, while server-sent cookies are serialized and persisted. I submitted bug report to Apple’s bugreporter under 18568056 number, hope that Apple resolves this in some future iOS version.

As the only way to set a cookie that will really persist seems to be to set it from the server, simplest workaround would be to create a server-side script that will return a single pixel with a required cookie. [Resulting test page](http://sharovatov.ru/setcookie-img.php) proves this approach is working correctly, though it’s certainly weird that serious bug like this went unnoticed since iOS version 6.