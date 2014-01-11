---
layout: post
date: 2012-10
title: Installing Opera Mini emulator locally
---

If I remember correctly, Opera website earlier had instructions on how to use Opera Mini on the desktop, but now they are either gone or unreachable. So here’s a simple set of instructions to get Opera Mini running in a JVM emulator.

1. make sure that JRE is installed

2. <a href="http://code.google.com/p/microemu/downloads/list">download latest microemulator</a> and unzip it somewhere

3. download Opera Mini jars:

	* http://demo.opera-mini.net/public/skin.jar

	* http://demo.opera-mini.net/public/mini.jar

	* http://demo.opera-mini.net/public/applet.jar

4. run microemu: java -jar microemulator.jar

5. Make sure Options&rarr;MIDlet network access is checked so that your emulator will have access to the network

6. Select Options&rarr;Select device and choose “Resizable device” and set it as a default – this will allow you to resize your emulator to any width you like

7. Select File&rarr;Open midlet, locate mini.jar and select it

However, this setup is only useful to see how your website looks in Opera Mini, and is certainly not a proper development environment. For instance, I couldn’t find a way to inspect what’s being transferred over the network – and even if I did, I’d obviously only see Opera’s OBML traffic between the jar and Opera’s servers and nothing more.

The only useful thing hiding in Opera Mini is **server:source**.

Basically, if you want to view the source of the page, you can type in **server:source** in the address bar while viewing a website and you’ll get awfully-rendered page source (note that this will not be OBML, but rather the original page source that Opera’s servers got from the URL you specified). And if want to inspect the source on your desktop rather than small emulator screen, you can ask Opera’s servers to post the source to a URL by specifying **server:source?post=http://youraddress/script** and three values will be POSTed to the URL provided:

* html – the original page source

* host – the HTTP host field value

* URL – the URL that was fetched