---
layout: post
date: 2009-06
title: Opera revolution fail
---

Opera announced “<a href="http://unite.opera.com">Opera Unite</a>” concept – they integrated a web-server right into Opera and made Opera Desktop Gadgets run on it.

All the <a href="http://unite.opera.com/services/">services</a> Opera Unite offers are web gadgets, so they are built in html+javascript with some <a href="http://dev.opera.com/libraries/unite/">additional API</a> provided by the browser.

To get any of the services, you must register at Opera. When you register, you give your computer a name, e.g. “home” and then you are provided with a URL home.yourlogin.operaunite.com where **yourlogin **is what you chose as a login when you were registering.

File sharing service is basically a web server directory listing exposed to the internet. This is my understanding how it works:

1. You point Opera Unite to a directory

2. Opera internal web server starts listening 8840 port locally

3. Opera opens a persistent connection to operaunite.com (213.236.208.30 IP address in my case)

4. So when anyone opens up home.yourlogin.operaunite.com, operaunite.com server requests the list of files from your machine using a persistent connection that you opened and sends the response back to user.

5. when you close Opera, web server is shut down, connection is dropped and nobody can download anything.

So sharing can work ONLY when your computer is working and Opera is running.

## So none of the services can work when computer is turned off or Opera is not running.

When you want your sharing/chat/fridge services to be working, you will need to keep your Opera running. And if several users start using it, your computer will slow down significantly. And if you by any chance put a link to an image hosted in your Opera Unite on a popular site… Your computer will either stop responding or eat 100% resources.

That’s what John Resig, the author of beautiful jQuery says:

> I just tried to visit six Opera Unite pages and only one resolved. The future of the web is two 9s: 0.99% uptime!

Useful service? I doubt.

Photo sharing service is just crap at the moment. My Opera Unite serving 1 client with a Photo Sharing page with thumbnails eats 60-70% of CPU and up to 200 Megabytes of memory. Full-blown web servers like IIS7 or Apache2 would serve this page and static files in a milliseconds without any noticeable resources eating. Thumbnails are created in really poor quality.

In Web Server service CGI is not supported, in-memory modules are not supported. PHP is not supported. The only language you can use is javascript. HTTPS is not supported.

Opera <a href="http://unite.opera.com/support/userguide/#diff_data_share">says</a> that the communication between users is done directly. Truth is that it’s done through operaunite.com. Let me repeat it, **all the traffic goes through operaunite.com**. Are you ready to give all your information to Opera?

Do you trust them so much? Do you care about your privacy? Do you think they will care about users after what they did to Windows 7 users in Europe?

Opera says this is a revolution – I can only see a bad (or alpha, not even beta) implementation of a rather poor technology. When I go out, I don’t leave my laptop working and Opera running, so the sharing won’t work. And I don’t want my _browser_ to take 100% CPU and 400 Mb RAM when two users are watching static pages with static thumbnails. And it’s not p2p as all the traffic goes through Opera servers.

There’re plenty of good services that do their work and don’t pretend to do a revolution where there’sclearly nothing revolutionary.

<a href="http://labs.opera.com/news/2009/06/16/">This</a> makes me laugh:

> Our computers are only dumb terminals connected to other computers (meaning servers) owned by other people — such as large corporations — who we depend upon to host our words, thoughts, and images. We depend on them to do it well and with our best interests at heart. We place our trust in these third parties, and we hope for the best, but as long as our own computers are not first class citizens on the Web, we are merely tenants, and hosting companies are the landlords of the Internet.

P.S. Opera engineers said that in the final version p2p file sharing will be implemented – well, let’s see.