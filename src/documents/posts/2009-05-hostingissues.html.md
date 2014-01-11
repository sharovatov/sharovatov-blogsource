---
layout: post
date: 2009-05
title: Hosting issues
---

I’ve been trying to prepare some test cases for HTTP Chunked Encoding support, but noticed that something went weird when I was requesting data from my host (<a href="http://sharovatov.ru/">sharovatov.ru</a>).

I’ve got a basic LAMP virtual hosting at <a href="http://naunet.ru">naunet.ru</a> which worked fine when I was hosting static content. But when I started doing the testcase, I found out all the weird and wonderful issues – mainly because they have SQUID installed before apache, so every single request goes to squid, and it’s a caching proxy that serves all my request from its cache – so I can’t test chunked encoding properly, can’t test ranges support properly… Crap. Seems that they just use squid to reduce load on their web servers.

But the worst thing is bad techsupport – it works 8 hours a day and there’s nobody there on the weekends or bank holidays. I ask a question and nobody answers it in 3 days. It just drives me insane.

Will have to move to somewhere else where sysadmins know how to do load-balancing without installing front-end proxies.