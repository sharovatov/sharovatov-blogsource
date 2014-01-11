---
layout: post
date: 2009-04
title: Silverlight smooth streaming and HTTP
---

I’ve read about smooth streaming technology, and I must say, I just love the way it works. It automatically and smoothly adjusts video quality and allows clients to view smooth video online regardless of their bandwidth and without a need to sit and wait staring at “buffering” message for ages – what it does it dynamically changes the video quality based on network bandwidth, CPU load and other factors.

It’s idea and implementation are so simple and beautiful that I wonder why nobody didn’t invent it earlier.

This is what steps you have to follow to make it work:

1. encode your video file in <a href="http://www.microsoft.com/downloads/details.aspx?FamilyId=A29BE9F9-29E1-4E70-BF67-02D87D3E556E">Expression Encoder 2 Service Pack 1</a>

2. upload it to IIS7 web server with <a href="http://www.iis.net/extensions/SmoothStreaming">IIS7 Smooth Streaming extension</a>

3. point your Silverlight player to the appropriate URL

That’s it. <a href="http://smoothhd.com/">Here’s a showcase</a> how this technology works – awesome!

Looks simple, right? It is simple, but there’s a huge amount of work hidden beside this simplicity. Let me dive into technical details a little bit :)

First of all, let me give you some background. Originally there were basically two types of streaming – stateful streaming and progressive download.

Good example of stateful streaming is <a href="http://en.wikipedia.org/wiki/RTSP">RTSP</a>.

Client had to initiate connection to the server and send commands like PAUSE or PLAY, and server sent back video stream packets, client waited for its playback buffer to be filled with data and started playback. RTSP worked both over UDP and TCP (port 554 was used).

<a href="http://en.wikipedia.org/wiki/Progressive_download">Progressive download</a> – where client was sending traditional HTTP GET request and server responded with video data sent with use of HTTP chunked encoding, and client started the playback as soon as its playback buffer had enough data to play.

Both approaches had serious issues – RTSP couldn’t work for clients behind proxies or firewalls without extra efforts (that’s why Apple had to spend time inventing <strike>the wheel</strike> <a href="http://developer.apple.com/documentation/QuickTime/QTSS/Concepts/QTSSConcepts.html#//apple_ref/doc/uid/TP30000245-TPXREF143">tunnelling RTSP over HTTP</a>), progressive download couldn't work fine for situation where bandwidth wasn't good enough – have you had wonderful time sitting and staring at “Buffering” message?

So if you want to give highest video quality to users on a high bandwidth but still want to show users with low bandwidth at least something &#8211; you’ll create several versions of the same video and give users a way to choose and watch what they want.

But what if a user doesn’t know what bandwidth he’s got? What if _the player itself_ could automatically select what video to download – high-res or low-res? What if the player could _change bitrate during the playback if network conditions or CPU load changed_? What if the player could instantly start playback from _any point of the movie_? And what if pure HTTP was used so that there would be no issues with proxies? What if each chunk of video could be perfectly cached by HTTP agent, such as proxy?

**That’s precisely how Microsoft Silverlight Smooth Streaming works. **

First of all, Microsoft decided to switch from their ASF format to <a href="http://www.iso.org/iso/iso_catalogue/catalogue_tc/catalogue_detail.htm?csnumber=41828">MP4</a>.

There were many reasons for that, but the main point is that MP4 container specification allows content to be internally organised as a series of fragments, so-called “boxes”. Each box contains data and metadata, so that if metadata is written before the data, player can have required information about the video before it plays it.

So what does Expression Encoder do? It allows you to easily create multiple versions of the same video for different bitrates in this fragmented MP4 format. So you get up to 10 versions of the same video file with different resolution – from 320&#215;200 up to 1080 or 720p. Each file internally is split in 2-seconds chunks, each chunk has its own metadata so you can programmatically identify the required chunk. Plus Expression Encoder creates two complimentary files (both follow <a href="http://www.w3.org/TR/SMIL20/">SMIL XML standard</a>) – *.ISM – server manifest file, which basically just describes to server which file versions have what bitrates; and *.ISMC, which tells a client what bitrates can be used and how many fragments files have.

Can you see the idea? **IIS Smooth Streaming extension just maps URL to a chunk in a file.** You do a HTTP GET request to a URL like this:

	<a href="http://test.ru/mov.ism/QualityLevels(400000)/Fragments(video=61024)">http://test.ru/mov.ism/QualityLevels(400000)/Fragments(video=61024)</a>

And IIS Smooth Streaming extension checks “mov.ism” manifest file to find filename of the file with requested quality level (400000), opens and parses this file to get the chunk with requested time offset (61024). Then this chunk is returned to you in a normal HTTP response.

**So you can query for any chunk of any one of your video files with the requested time offset.**

Let me repeat it – you encoded your original video file into 10 fragmented video files with different bitrate. And you have a way to query for any chunk in any of these files.

So to play 10 seconds of video you have to do 5 consequent HTTP requests. As we have versions of the same video with different bitrate, we can get first chunk in the worst quality to see how it renders and what time it takes to download it, and then if CPU load is low and network is fast, we can query next 4 chunks with higher bitrate.

And that’s exactly what Silverlight Media Player component does – it requests chunk by chunk from the server and changes “QualityLevels” parameter in URL if conditions change. For example, if Silverlight Media Player sees that CPU load is too high and it’s dropping frames, or network becomes too slow, it changes “QualityLevels” parameter to a lower value so IIS Smooth Streaming extension serves next chunks from the smaller file with lower video quality.

Actually, when user starts the playback, first thing that Silverlight Media Player does is a request for ISMC file to find out how many different bitrate versions server has (and how to identify frames). And only then it composes URL to get the first chunk of video. Simple and beautiful technology.

So what do we have? Video plays smoothly – on old slow internet channels in lower quality and in full HD on fast internet and good CPUs. As HTTP is used as a transport – therefore no issues with proxies or firewalls; as each chunk is identifiable by a unique URL, every single chunk can be perfectly cached by proxies or other HTTP agents.

And as this technology is quite simple, there’s no doubt that there will be a similar module for other web servers, or even web applications achieving similar functionality!

Yes, as it’s encoded in multiple bitrate versions, it takes up to 6 times more space for one movie/clip, but if that’s what it takes to provide users with smooth playback in any conditions – I’m for it!

Thanks for another great technology, IIS Team!

Links:

* <a title="Live Smooth Streaming for IIS 7.0 - Getting Started" href="http://www.iis.net/learn/media/live-smooth-streaming/getting-started-with-iis-live-smooth-streaming">Live Smooth Streaming for IIS 7.0 &#8211; Getting Started</a>

* <a href="http://alexzambelli.com/blog/2009/02/10/smooth-streaming-architecture/">Smooth Streaming technology infrastructure</a>

* <a href="http://msdn.microsoft.com/en-us/library/cc251059(PROT.10).aspx">Windows Media HTTP Streaming Protocol Specification</a>

* <a href="http://www.clarkezone.net/default.aspx?id=6149974c-3ebf-4002-8dd1-e2aecf835eeb">debugging silverlight smooth streaming applications</a>

## Akamai supports
Just noticed that the <a href="http://smoothhd.com">smoothhd.com</a> serves media from AKAMAI <a href="http://en.wikipedia.org/wiki/Content_Delivery_Network">CDN</a> servers!

Also found that <a href="http://www.akamai.com/html/about/press/releases/2009/press_031709.html">AKAMAI has a contract with Microsoft to deliver Smooth Streaming content</a> – and that’s just great. It means that if you have webcasts or any other video you want to deliver to the maximum audience with any bandwidth and CPUs, Akamai and Silverlight Smooth Streaming would be an ideal solution – you won’t even need to host video files on your servers! Or you can start with streaming from your own server and later if required you can
always seamlessly switch to Akamai.

And here’re some nice videos from MIX09 (about silverlight) that I’ve found today:

* <a href="http://videos.visitmix.com/MIX09/T19F">Creating media content for Microsoft Silverlight using Microsoft Expression Encoder</a>

* <a href="http://videos.visitmix.com/MIX09/T43F">Microsoft Silverlight Media end-to-end</a>

As soon as I get my IIS7, I’ll definitely try streaming something :)