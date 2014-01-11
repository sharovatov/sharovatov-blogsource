---
layout: post
date: 2009-05
title: Windows 7 Accelerators Platform
---

Cool, I just found out that great <a href="http://www.microsoft.com/windows/internet-explorer/features/accelerators.aspx?tabid=1&amp;catid=1">accelerators feature</a> that’s been introduced in IE8 is a part of Windows 7 API as <a href="http://msdn.microsoft.com/en-us/library/dd565720(VS.85).aspx">Accelerators Platform</a>.

The whole concept is really useful – Accelerators Platform provides a unified way to enhance an text-operating application with cross-application plug-ins.

Accelerators Platform provides an abstraction layer between applications and accelerators:

* Accelerators operate with text selection with help of web services

* application implementing Accelerators Platform API can use Accelerators

* user running the application can select a text and choose an accelerator that will use this selection


So it’s like a plug-in platform for text selection plug-ins where plug-ins are application independent and stored in one place, so if an accelerator is installed once, it will be available in any application that supports Accelerators Platform.

The fact that Accelerators become application-independent gives the following benefits:

* usability is better as users have similar behaviour pattern across applications, and it’s easier for them to get used to your application

* you as an application developer don’t have to reinvent the wheel and implement useful text selection enhanced functionality and work on a plug-in architecture

* you as an application developer don’t have to maintain a list of supported text selection plug-ins – they can be found and installed easily from <a href="http://www.ieaddons.com/en/accelerators/">here</a> – the list of accelerators is huge!

* if you want to create your own accelerator for your application, it’s well documented and dead easy - <a href="http://sharovatov.wordpress.com/2009/04/24/various-ie8-accelerators-thepiratebay-phpnet-pagerank-alexa/">I’ve created 6 accelerators just in 20 minutes!</a> Or your users can do it!

So by supporting Accelerators Platform in your app you allow users to do with the text whatever they like and whatever they are used to!

Just imagine – wouldn’t it be wonderful to be able to select address in any application, right click on it and see where it’s located on the map? Or select unknown word in any application and see its definition in Wikipedia? Or select a function name that you’d like to refresh you memory about and see what php.net or msdn have to say? Or select any text and translate it to other language in one click? Or check how much selected TV model costs on ebay?

As Microsoft said, Office 2010 would have Accelerators platform support, and I bet other serious software will support Accelerators Platform as well. Here’s Word 2010 screenshot from <a href="http://msdn.microsoft.com/en-us/library/dd565720(VS.85).aspx">msdn</a>:

<a href="http://sharovatov.files.wordpress.com/2009/05/dd565720_ie8_win7_word_accelenusvs_85.jpg"><img title="Dd565720_ie8_win7_word_accel(en-us,VS_85)" border="0" alt="Dd565720_ie8_win7_word_accel(en-us,VS_85)" src="http://sharovatov.files.wordpress.com/2009/05/dd565720_ie8_win7_word_accelenusvs_85_thumb.jpg?w=340&#038;h=447" width="340" height="447"></a>

For more details and technical description of Accelerators Platform please visit <a href="http://msdn.microsoft.com/en-us/library/dd565720(VS.85).aspx">this MDSN article</a> and <a href="http://blogs.msdn.com/ie/archive/2009/05/07/accelerator-platform-on-windows-7.aspx">this IE Team Blog entry</a>.

So go and support Accelerators Platform in your app!