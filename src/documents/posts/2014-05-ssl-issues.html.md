---
layout: post
date: 2014-05
title: few HTTPS issues with wildcard certificates
tags:
    - webdev
    - security
---

While playing with an https issue I discovered a few things in current HTTPS state in modern browsers:

 * support for [wildcard certificates](http://en.wikipedia.org/wiki/Wildcard_certificate), though [not obligatory](http://tools.ietf.org/html/rfc6125#section-6.4.3) and even discouraged in RFC6125, is provided in all modern browsers; so that one certificate can cover multiple wildcard domains by putting them in SAN list: *.first.domain.com, *.second.domain.com, *.third.domain.com
	
 * [EV](http://en.wikipedia.org/wiki/Extended_Validation_Certificate) certificates [don’t support](http://www.networksolutions.com/support/why-can-t-i-get-a-wildcard-extended-validation-ev-ssl-certificate/) quite useful wildcards in SANs (Subject Alternative Names) / CNs (Common Name) names at all

 * multi-level wildcards [are not supported by browsers](https://support.quovadisglobal.com/KB/a60/will-ssl-work-with-multilevel-wildcards.aspx) are not sold by CAs 
 
 * wildcard can only be used as the left-most label, \*.sub.mydomain.com will do, sub.\*.mydomain.com is not supported
	
 * Google Chrome violates the [RFC6125 requirement to trust a pinned certificate](http://tools.ietf.org/html/rfc6125#section-6.6.2) and will only show a padlock icon (i.e. truly accept the certificate — “pin the certificate” in the [RFC](http://tools.ietf.org/html/rfc6125) terms) if Common Name or one of SANs  matches the FQDN (wildcard will do).
 All other browsers follow the RFC and a user can manually pin an arbitrary certificate to the site he’s testing. Here’s a screenshot of a pinned self-signed certificate applied to a host not matching the certificate’s Common Name: 
	![chrome self-signed certificate](http://sharovatov.ru/screenshots/ssl-chrome-selfsigned.png)
	So if you use self-signed certificate on your test environment, be sure to generate it correctly and list all domain variations in certificate’s SAN list.

 * A certificate can have an IP address in the Common Name / SAN list, and this could technically be leveraged to save clients DNS lookup time if static files are served from a separate server with this IP address. However, this approach would also require full control over the set IP address for the whole life of the website (if IP address control is lost, a huge security issue is created). And in any case, in HTTPS scenario it’s almost always better to reuse an existing connection than to create a separate one.
