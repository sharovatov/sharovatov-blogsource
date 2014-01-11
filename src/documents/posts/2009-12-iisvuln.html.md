---
layout: post
date: 2009-12
title: critical IIS vulnerability
---

Just got a link from our <a href="http://trukhanov.wordpress.com">system administrator</a> &#8211; <a title="http://securityvulns.ru/Wdocument993.html" href="http://securityvulns.ru/Wdocument993.html">http://securityvulns.ru/Wdocument993.html</a>

Go read the vulnerability description now!

Basically – if your users upload files to your site and THEY specify file names, you’re vulnerable:

> **Vulnerability/Risk Description**:

> IIS can execute any extension as an Active Server Page or any other executable extension.

> For instance “malicious.asp;.jpg” is executed as an ASP file on the server. Many file uploaders protect the system by checking only the last section of the filename as its extension. And by using this vulnerability, an attacker can bypass this protection and upload a dangerous executable file on the server.

There’s an unchecked <a href="http://securityvulns.ru/files/iissemi1.cpp">patch</a> for this vulnerability, but again this shows that you just can’t allow any user input saved to your system without filtering.

So, if you allow file uploads – your script has to specify filenames, not users.