---
layout: post
date: 2009-12
title: HTTPBis group is awesome!
---

As you know, HTTP/1.1 spec said that conforming clients SHOULD NOT open more than 2 concurrent connections to one host. This was defined back in 1997 and at that time it seemed reasonable to have 2 simultaneous connections for a client, and noting that HTTP/1.1 introduced persistent connections concept, people thought that 2 simultaneously opened reusable TCP/IP connections would be enough for general use.

However, everything changes. Broadband internet came to mass market and people started thinking that better parallel download could benefit the whole website or a webapp performance. The history started with IE5.01, which was opening two connections by default, but <a href="http://blogs.msdn.com/nickmac/archive/2004/08/25/how-to-speed-up-http-requests-on-internet-explorer.aspx">there was a way to configure the number</a>. So if you had a really good internet connection, you could make websites load significantly faster.

By the time IE8 development started, broadband connections became a standard for home internet, so <a href="http://msdn.microsoft.com/en-us/library/cc304129(VS.85).aspx">IE8 started opening 6 connections</a> (if the bandwidth allowed – on the dialup or behind a proxy it will still open 2). So IE8 engineers did a smart move and introduced the world with a browser that seemed to load sites faster.

Needless to say, Firefox 3 decided to change the value as well, so <a href="http://kb.mozillazine.org/Network.http.max-persistent-connections-per-server">now Firefox 3 has 6 as a default value for network.http.max-persistent-connections-per-server</a> configuration setting. Good for Mozilla for copying stuff from IE again!

And now HTTPBis team (Julian Reschke) <a href="http://trac.tools.ietf.org/wg/httpbis/trac/changeset/715">commits the change</a> which states that in the forthcoming HTTP standard the maximum amount of concurrent requests is not limited even with “SHOULD NOT” clause :)

Thanks HTTPBis team!