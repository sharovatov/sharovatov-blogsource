---
layout: post
date: 2009-11
title: HTTP persistent connections, pipelining and chunked encoding
---

When I have free time, I like to reorganise the knowledge I’ve got and prepare mindmaps/cheatsheets/manuals of interesting stuff. And the formal approach I usually use forces me to organise data in a way so that it won’t take me long to grasp the idea if I forget something.

And I also like posting resulting resources to blog — that’s a good English techwriting skills practice plus some publicity for the knowledge ;)

So this post is another one from the HTTP series and describes HTTP/1.1 persistent connections and chunked
encoding.

HTTP/1.0 said that for every request to a server you have to open a TCP/IP connection, write a request to the socket and get the data back.

But pages on the internet became more complex and authors started including more and more resources on their pages (images, scripts, stylesheets, objects — everything that browsers had to download from the server).

And for every resource request clients were opening separate connections, and it was taking time and CPU/memory resources to open a new connection, so from users prospective, resulting latency was becoming worse. Something could be done to improve the situation.

So HTTP IETF decided to implement a nice technique called “persistent connections”.

**Persistent connections reduce network latency and CPU/memory usage of all the peers by allowing reuse of the already established TCP/IP connection for multiple requests.**

As I mentioned, HTTP/1.0 client was closing the connection after each request. HTTP/1.1 introduced using one TCP/IP connection for multiple sequential requests, and both server and client can indicate that the connection has to be closed upon the completion of current request-response by specifying `Connection: Close` header.

Usually HTTP/1.1 client sends `Connection: Close` header with the last request in the queue to indicate that it won’t need anything else from the server, so that the TCP/IP connection can be safely closed after the request has been served with response. (Say, it wanted to download 10 images for the HTML page, it sends `Connection: Close` with the 10<sup>th</sup> image request and the server sends the last image and closes the connection after it’s done).

**Persistent connections are the default for HTTP/1.1 clients and servers. **

And even more interestingly, HTTP/1.1 introduced **pipelining** support – a concept where client can send multiple requests without waiting for each response to be sent back, and then server will have to send responses in the same order the requests came in.

**Note:** pipelining is not supported in IE/Safari/Chrome, disabled by default in Firefox, leaving Opera the only browser to support and have it enabled. 

In any case, if the connection was dropped, client will initiate new TCP/IP connection and those requests that didn't get a response back will be resubmitted through the new connection.

But as one connection is used to send multiple requests and receive responses, how does the client know when it has to finish reading the first request?

Obviously, `Content-Length` header must be set for each response.

**But what happens when the data is dynamic or the whole response’s content length can’t be determined by the time transmission starts?**

In HTTP/1.0 everything’s easy — `Content-Length` header can just be left out, so the transmission starts, client starts reading the data it’s getting from the connection, then when the server finishes sending the data, it just closes the TCP/IP connection, so client can’t read from the socket any more and considers the transmission completed.

However, as I’ve said, in HTTP/1.1 each transaction has to have correct `Content-Length` header because client needs to know when each transmission is completed, so that the client can either start waiting for the next response (if requests were pipelined), or stop reading current response from the socket and send new request through this TCP/IP connection (if requests are sent in a normal sequential mode), or close the connection it if it was the last response he was to receive.

**So as the connection is reused for multiple resources’ content transmission, the client needs to know exactly when each resource download is completed, i.e. it needs the exact number of bytes it has to read from the connection socket.**

And it's obvious that if `Content-Length` can not be determined before the transmission starts, the whole persistent connections concept is useless.

**That is why HTTP/1.1 introduced chunked encoding concept.**

The concept is quite simple — if exact `Content-Length` for the resource is unknown at the time when transmission starts, server may send resource content piece by piece (so-called chunks) and provide `Content-Length` for each chunk, plus sends an empty chunk with zero `Content-Length` at the end of the whole response to notify client that this response transmission is complete.

To let HTTP/1.1 conforming clients know that chunked response is coming, server sends special header — `Transfer-Encoding: chunked`.

Chunked encoding approach allows client to safely read the data — it knows the exact number of bytes that are to be read for each chunk and knows that if an empty chunk arrived, this resource transmission is completed.

It’s a little bit more complex than HTTP/1.0 scenario where server just closes the connection as soon as it’s finished, but truly worth it — persistent connections save server resources and reduce whole network latency, therefore improving overall user experience.

Links and resources:

* <a href="http://www.w3.org/Protocols/rfc2616/rfc2616-sec8.html">HTTP/1.1 Persistent connections</a>

* <a href="http://en.wikipedia.org/wiki/HTTP_pipelining">Wikipedia about HTTP Pipelining</a>

* <a href="http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html">HTTP/1.1 Chunked encoding</a>