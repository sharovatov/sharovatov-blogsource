---
layout: post
date: 2010-03
title: link-to-QRCode IE8 accelerator
---

I have Nokia N78 phone and use it a lot for surfing web (with beautiful <a href="http://www.opera.com/mobile/">Opera Mobile 10</a>), reading RSS (with internal webkit-based browser), tweeting (with <a href="http://mobileways.de/products/gravity/gravity/">awesome Gravity client</a>), reading CHMs (with <a href="http://www.hugematrix.com/modules/news/article.php?storyid=8">great mobiCHM tool</a>) or using <a href="http://www.skype.com/intl/en/download/skype/symbian/">Skype</a>, or doing many other tasks.

But mostly I use the phone to read something on the internet when I’m on the way to some place (as it takes at least an hour to get somewhere in Moscow using public transport). And usually when I’m browsing web on a PC and find something worthy to save to mobile, I type its URL  on the phone and save it to bookmarks. 

Which, even with <a href="http://bit.ly/">bit.ly</a> or any other url-shortening service, is a kerfuffle, and T9 doesn’t really help here.

So I was trying to find an easier way to get URLs transferred from my PC onto the mobile. Opera 10 Mobile comes with <a href="http://link.opera.com/">Opera Link</a> bookmarks synchronisation service, but I don’t surf internet in Opera on a PC. There’re some social bookmarking sites, but I’m not adding every link that I want to read on mobile to my bookmarks, be it a web-service or browser bookmarks.

And here comes <a href="http://en.wikipedia.org/wiki/QR_Code">QRCode</a> scanning to the rescue. I knew that Nokia <a href="http://mobilecodes.nokia.com/scan.htm">provided a nice free easy-to-use QRCode scanner</a> for their smartphones, and I gave it a go. Downloaded, installed, tried with some QRCodes I had, everything was fine, scanning and recognition speed was really high – I just pointed the phone camera onto my computer’s screen and the encoded text was momentarily recognised. I decided to try encoding links in QRCodes using Nokia service, and it worked fine as well – the scanner made them active so I could either copy them to use in Opera Mobile or open with default web-browser (handy if it’s a link to RSS feed).

Of course, encoding each link manually and then scanning resulting QRCode is taking much more time than just typing the link in the phone, so the idea of making the browser show QRCode for any link made more sense to me.

The easiest way to integrate some web-service to IE8 is its beautiful <a href="http://msdn.microsoft.com/en-us/library/cc289775(VS.85).aspx">Accelerators platform</a>. I did 10 lines of PHP code which shortens any URL with bit.ly service, and then echoes the IMG tag pointing to <a href="http://mobilecodes.nokia.com/create.jsp">Nokia QR Code creation service</a> URL. Here’s the code:

	<?php
	require_once('bitly.php');
	$sUrl = make_bitly_url($_GET['url']); //shorten the original URL first
	echo '<img src="http://mobilecodes.nokia.com/qr?DATA='.$sUrl.'&amp;MODULE_SIZE=4&amp;name=&amp;MARGIN=2&amp;ENCODING=BYTE&amp;type=link&amp;MODE=TEXT&amp;a=view">';
	?>

Bit.ly is used to make QRCode creation faster and easier as only small chunk of data is encoded.

Then I created a very simple XML file which instructs IE8 what to do with the link:

	<?xml version="1.0" encoding="UTF-8"?>
	<!-- author: Vitaly Sharovatov (http://sharovatov.ru) -->
	<openServiceDescription xmlns="http://www.microsoft.com/schemas/openservicedescription/1.0">
		<homepageUrl>http://sharovatov.ru</homepageUrl>
		<display>
			<name>link QRCode</name>
			<icon>http://sharovatov.ru/qrcode/favicon.ico</icon>
		</display>
		<description>Get the QRCode for selected link</description>
		<activity category="mobile">
			<activityAction context="link">
				<preview action="http://sharovatov.ru/qrcode/createCode.php?url={link}" />
				<execute method="get" action="http://sharovatov.ru/qrcode/createCode.php?url={link}" />
			</activityAction>
		</activity>
	</openServiceDescription>


And then just uploaded the php script and my accelerator to my site. Dead easy, 10 minutes job.

As wordpress.com doesn’t allow javascript onclick handlers on the links (and accelerator gets added to IE by `window.external.addService` call), I had to put the install page on my site. Please visit <a href="http://sharovatov.ru/current.html">http://sharovatov.ru/current.html</a> for this and few other IE8 accelerators. To get this accelerator installed, just press on “Install now” link in its description.

Now if you right-click on any link, go to Accelerators, and just hover “link to QRCode” accelerator you’ll get the window with QRCode for the current link:

<a href="http://sharovatov.files.wordpress.com/2010/03/qrcodeaccelerator1.gif" target="_blank"><img title="qrcode-accelerator" border="0" alt="qrcode-accelerator"
src="http://sharovatov.files.wordpress.com/2010/03/qrcodeaccelerator_thumb1.gif?w=256&#038;h=239" width="256" height="239"></a>

Then you just run Barcode app on the mobile, get the QRCode scanned and then can do anything with the link – copy it to the clipboard, open right now in the default browser. Seems to be quite handy.

In order to get this accelerator in the main right-click menu, you need to go to Page &rarr; All Accelerators &rarr; Manage accelerators and in the window that appears select “link QRCode” accelerator and press on “Set as default” button.

Here’s some guiding screenshots:

<a href="http://sharovatov.files.wordpress.com/2010/03/manageaccels1.gif" target="_blank"><img title="manageaccels" border="0" alt="manageaccels" src="http://sharovatov.files.wordpress.com/2010/03/manageaccels_thumb1.gif?w=209&#038;h=256" width="209" height="256"></a> <a href="http://sharovatov.files.wordpress.com/2010/03/manageaddones1.gif" target="_blank"><img title="manageaddones" border="0" alt="manageaddones" src="http://sharovatov.files.wordpress.com/2010/03/manageaddones_thumb1.gif?w=256&#038;h=170" width="256" height="170"></a>

Then your link QRCode accelerator will be in the default context menu:

<a href="http://sharovatov.files.wordpress.com/2010/03/defaultmenu1.gif" target="_blank"><img title="defaultmenu" border="0" alt="defaultmenu" src="http://sharovatov.files.wordpress.com/2010/03/defaultmenu_thumb1.gif?w=232&#038;h=256" width="232" height="256"/></a>

So now you can get a QRCode for any link, scan it and use it on your mobile.

P.S. There’re QRCode scanners for all mobile platforms, so if you want similar functionality on your phone, google for “QRCode scanner %yourphone%”.