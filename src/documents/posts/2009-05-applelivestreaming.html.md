---
layout: post
date: 2009-05
title: Apple submitted HTTP Live Streaming spec to IETF
---

As <a href="http://sharovatov.wordpress.com/2009/04/28/silverlight-smooth-streaming-and-http/">I’ve blogged recently</a>, nearly a year ago Microsoft proposed an approach for adaptive video streaming over HTTP – Smooth Streaming. As Microsoft didn’t apply for a patent for this technology, I was hoping to see the same beautiful approach implemented in modules for other web-servers, or even as web-applications – as it’s really easy to implement.

The mistake Microsoft did was that they didn’t submit this technology standard to IETF to make it RFC – and that’s what Apple’s doing at the moment.

Yes, I’m not mistaken – Apple copied the whole idea, called it <a href="http://www.ietf.org/internet-drafts/draft-pantos-http-live-streaming-00.txt">HTTP Live Streaming and submitted to IETF</a>.

Yes, there’re differences, but they are absolutely insignificant:

* Apple spec suggests extending M3U format for a playlist – Microsoft uses <a href="http://www.w3.org/TR/SMIL20/">SMIL-compliant</a> ISMC client-manifest file (i.e. playlist)

* Apple spec defines that the server creates the playlist – in Microsoft approach the encoder creates the playlist

* Apple spec defines encryption for media files – Microsoft doesn’t

And the whole specification that’s been proposed is weird – I think they just wanted to submit it as soon as possible before Microsoft Smooth Streaming approach gets popularity and becomes de-facto standard.

Here’s what jumped at me when I was reading the spec:

* section 6.2.3. Reloading the Playlist file - why specify the expiration time of the playlist separately when HTTP 1.1 already has flexible methods for <br>setting expiration time of the resource?

* encryption - what’s the purpose of encrypting media files when there’s HTTPS? And if there’s a purpose - HTTP already provides a place where encryption could be "plugged in" - Transfer-Encoding, why didn't Apple just register another transfer-coding in IANA?

* EXT-X-ALLOW-CACHE - why add this if HTTP already gives flexible tools to control caching?

So as I see it – Apple was just a little bit in a hurry to propose this “standard” – looks like they took Microsoft idea, added some proprietary bits and bobs without thinking them through, didn’t use what HTTP natively provides but bravely called the draft “**HTTP** Live Streaming”.

Awesome.