---
layout: post
date: 2012-01
title: X-FRAME-OPTIONS
---

This X-FRAME-OPTIONS HTTP header invented by Microsoft for IE8 provides an easy way to work around <a href="http://en.wikipedia.org/wiki/Clickjacking">Clickjacking</a> security issue (see <a href="http://w2spconf.com/2010/papers/p27.pdf">this great paper</a> for even more details). The main article explaining how X-FRAME-OPTION works is this: http://blogs.msdn.com/b/ie/archive/2009/01/27/ie8-security-part-vii-clickjacking-defenses.aspx

Basically, here’s what behaviour you get with different X-FRAME-OPTIONS values:

<table border="0" cellspacing="0" cellpadding="5" width="703">
	<tbody>
	<tr>
		<td valign="top" width="201">`DENY`</td>
		<td valign="top" width="500">browser will not render the iframe contents in any case</td>
	</tr>
	<tr>
		<td valign="top" width="201">`SAMEORIGIN`</td>
		<td valign="top" width="500">browser will only render the iframe contents if host page origin is the same as the iframe page origin
	</td>
	</tr>
	<tr>
		<td valign="top" width="201">`ALLOW FROM http://host`</td>
		<td valign="top" width="500">browser will only render the iframe contents if the iframe host is httр://host </td>
	</tr>
	</tbody>
</table>

**Please note that specifying the header in META tag won’t work**.

Good news – all browsers vendors copied this from Microsoft and now we’ve got all modern browsers supporting this header (Firefox 3.6.9, IE8, Opera 10.50, Safari 4.0, Chrome 4.1).

Unfortunately, for some reason only Opera and IE show a meaningful message why the frame was blocked, all others just display the empty iframe (it’s especially weird for Firefox, which should show the warning as per their bugzilla):

<a href="http://sharovatov.files.wordpress.com/2012/01/image.png"><img title="image" border="0" alt="image" src="http://sharovatov.files.wordpress.com/2012/01/image_thumb.png?w=700&#038;h=238" width="700" height="238"></a>

In any case, study the security papers I linked to above to understand how the attack works and what it can do to your visitors or your business.

However, if you strongly believe no one should embed your page in an iframe – then your silver bullet is to add `X-FRAME-OPTIONS: DENY` to all the pages you serve.

P.S. X-FRAME-OPTIONS is now proposed to IETF: http://tools.ietf.org/html/draft-gondrom-frame-options-01