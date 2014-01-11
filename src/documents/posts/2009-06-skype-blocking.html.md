---
layout: post
date: 2009-06
title: Skype blocking 80 and 443 ports
---

When trying to start an IIS7 website, you can get the following message: “The process cannot access the file because it is being used by another process. (Exception from HRESULT: 0&#215;80070020)”:

<img title="image" border="0" alt="image" src="http://sharovatov.files.wordpress.com/2009/06/image2.png?w=491&#038;h=173" width="491" height="173">

It’s saying it can’t access the file, but actually IIS can’t bind the ports you’ve configured in Bindings configuration. But which port?

Usually I use the following procedure to find out which application occupies the port:

1. run `netstat –ano –p tcp` to get the list of opened ports, find the port that’s been taken and see which PID the port is bound to

2. run `tasklist /FI "PID eq XXX"` where XXX is the found PID

So in my case the 80 and 443 ports were taken by Skype. Whenever you start Skype, it tries to bind 80 and 443 ports, and so if you start your web server later, it won’t be able to work as ports are occupied. This Skype behaviour can be turned off by deselecting “Use port 80 and 443 as alternatives for incoming connections” here:

<img title="image" border="0" alt="image" src="http://sharovatov.files.wordpress.com/2009/06/image3.png?w=661&#038;h=579" width="661" height="579">

Hope this saves somebody some time :)