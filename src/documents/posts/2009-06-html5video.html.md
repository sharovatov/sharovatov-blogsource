---
layout: post
date: 2009-06
title: HTML5 video tag and Internet Explorer
---

It’s interesting to see how popular `<video>` and `<audio>` tags are getting now. Every browser tries to implement it as soon as it can and shout about it as loud as possible. And now people are even starting blaming IE for being old and not supporting inline video and audio.

The whole situation reminds me of AJAX where original concept was invented by Microsoft (actual ActiveX was shipped with IE5 in 1999), then it was standardised by W3C (in a different way), then implemented by other browsers, and then people started accusing IE for not supporting this new W3C standard.

The same thing is now happening with inline video/audio playback concept, which has been introduced in IE2 in 1995, almost 15 years ago. Yes, 15 years ago, when W3C has been just founded and was still asking <a href="http://www.csail.mit.edu/">MIT/CSAIL</a> to join. And now this functionality is being spec’ed in HTML5 as `<video>` and `<audio>` tags. Opera, Firefox, Safari and Google Chrome start supporting `<video>` and `<audio>` and are making a loud marketing message of it.

The original concept that was introduced in IE2 (and supported in following versions) was adding a `DYNSRC` attribute to `IMG` element:

	<img src="cover.gif" dynsrc="clock.avi" controls>

When IE saw dynsrc attribute, it tried loading the movie and playing it. “Controls” attribute made IE show simple playback controls.

This is how it looked like in IE3:

<img title="ie3" border="0" alt="ie3" src="http://sharovatov.files.wordpress.com/2009/06/ie3.gif?w=387&#038;h=602" width="387" height="602">

However, in future versions the support for DYNSRC was limited to make developers to switch to other ways (`<object>`/`<embed>`/SMIL video). In IE5 no controls were shown, in IE7 `DYNSRC` disappeared.

World changes, and now the functionality that nobody’s been using for a decade seems really new and interesting. It’s great that WHATWG is spending time on defining clear standard on how this should work and it’s really cool that Chrome, Firefox, Opera and Safari already support this draft. Of course, Silverlight supports greater level of RIA, but giving that IE Team is now really focused on following public standards, 

I hope that in IE9 we’ll have native support for `<video>`/`<audio>` as we had native support for XMLHttpRequest in IE7.

But my point is – credit for inline video playback functionality invention should be definitely given to IE2.