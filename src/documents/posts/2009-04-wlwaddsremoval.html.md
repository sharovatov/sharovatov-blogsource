---
layout: post
date: 2009-04
title: Windows Live Messenger adds removal
---

If you use Windows Live Messenger 2009 and you don’t want to watch adds – there’re two simple ways to disable them:

* add rad.msn.com to a list of Restricted Sites in your Internet Explorer

* add `.0.0.0 rad.msn.com` record to your `%systemroot%system32driversetchosts` file

Both ways will stop Live Messenger from downloading advertisement. I don’t know if these ways are legal, but we’re not touching Live Messenger, not disassembling it or doing anything specifically prohibited.

As always, there’s a patch (<a href="http://apatch.org/">apatch</a>), but as it modifies Live Messenger dlls, it certainly breaches the EULA.

The same approach can be used for blocking ads in all kinds of messengers – you just need to find out which host adds are served from and if your messenger uses IE settings, add it to restricted zone list, or to the hosts file with 0.0.0.0 address.