---
layout: post
date: 2009-04
title: HTTP Chunked Encoding
---

Did you notice that some pages on the internet start rendering in your browser incrementally, block after block, and on some sites you have to sit and look at the white screen and then get the full page in one second?

There’re two main problems that can make your browser wait for the whole page to load before it starts parsing it:

* if you’re using IE6 and the page you’re viewing has table-based layout without COLGROUPs/COLs specifying width or `table-layout: fixed` CSS rule.

* if the page’s not being served from server using chunked encoding.

The first issue is really simple – IE6 has to know the exact width of the columns before it starts displaying the table, and if you have `table-layout: fixed` rule for the table or COLs with specified width – it will wait for the whole content to load, calculate the width and only then display the table. Other browsers (such as Opera, Firefox, Google Chrome) and newer versions of IE don’t have this issue and start displaying content right after they get at least a piece of it.

<a href="http://www.ietf.org/rfc/rfc2616.txt">So while the first issue is really simple, the second is definitely more interesting!</a>

Normally when HTTP client receives a response, it parses HTTP headers and then tries to read from the input the exact amount of bytes as specified in Content-Length header. So if it takes 3 seconds for the server-side script to prepare the page, HTTP client (and the user!) will be just waiting with opened connection for these seconds.

What was OK at the time when HTTP1.0 was invented and the web had almost only static content, authors of HTTP1.1 thought was inacceptable for era of web applications.

And <a href="http://www.ietf.org/rfc/rfc2616.txt">HTTP 1.1 Spec</a> introduces a concept of "Chunked" transfer encoding:

> The chunked encoding modifies the body of a message in order to transfer it as a series of chunks, each with its own size indicator, followed by an OPTIONAL trailer containing entity-header fields.

> This allows dynamically produced content to be transferred along with the information necessary for the recipient to verify that it has received the full message

The main goal of HTTP Chunked Encoding is to allow clients to parse and display data immediately after the first chunk is read!

Here's a sample of HTTP response with chunked encoding:

		HTTP/1.1 200 OK
		Transfer-Encoding: chunked
		Content-Type: text/html

		c
		<h1>go!</h1>

		1b
		<h1>first chunk loaded</h1>

		2a
		<h1>second chunk loaded and displayed</h1>

		29
		<h1>third chunk loaded and displayed</h1>

		0

As you may see, there’s no Content-Length field in the beginning of the message, but there’s a hexadecimal chunk-size before every chunk. And 0 with two CRLFs specifies the end of the payload.

**So the server doesn’t need to calculate Content-Length before it starts serving data to client. **This is an amazing functionality! It means that the server can start sending the first part of the response while still processing the other parts of it.

Say, you have a dynamic page with two elements, both of which are queried from the database.

So you can either wait for both queries to finish, populate your template with results and send the whole page to client, or you can get first query result, send it in one chunk to the client, then do the next query and send its results in another chunk. You may not notice the difference between chunked and normal serving mode in most of the cases – but if the page is created from different sources or it takes significant time to prepare the data – user experience may be seriously improved.

Before the widespread popularization of AJAX (another Microsoft-invented technology) – Chunked Encoding was used as a core for so-called “<a href="http://en.wikipedia.org/wiki/Push_technology">Server Push</a>” approach for building web-chats and other _streaming_ purposes. The idea was simple – server didn’t close the HTTP connection and kept on sending chunk after chunk with new messages or other data. This approach had serious drawbacks – e.g. for each new client server had to instantiate a new connection (which eats resources), browsers had a limit on waiting time, so the page had to be reloaded once in a while and so on. But anyway, Chunked Encoding was widely used.

In my company we use Chunked Encoding to show loading progressbar in our <a href="http://www.realrussia.co.uk/main_train_screen.asp">online train tickets ordering system</a> – we
serve the first chunk with nicely styled `<div id=”loading”></div>` and when the data for the main table is ready, we serve it in the second chunk. And after the document is fully loaded, javascript routine hides `<div id=”loading”></div>` :) Simple and nice.