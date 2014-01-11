---
layout: post
date: 2008-06
title: HTTP History Lists and Back Button
---

While writing the post about forms values persistence, I noticed that browsers handle back button in different HTTP _situations_ differently.

<a href="http://www.ietf.org/rfc/rfc2616.txt">HTTP 1.1 spec</a> says the following:

> 13.13 History Lists

> User agents often have history mechanisms, such as "Back" buttons and history lists, which can be used to redisplay an entity retrieved earlier in a session.

> History mechanisms and caches are different. In particular history mechanisms SHOULD NOT try to show a semantically transparent view of the current state of a resource. Rather, a history mechanism is meant to show exactly what the user saw at the time when the resource was retrieved.

> By default, an expiration time does not apply to history mechanisms. If the entity is still in storage, a history mechanism SHOULD display it even if the entity has expired, unless the user has specifically configured the agent to refresh expired history documents.

> This is not to be construed to prohibit the history mechanism from telling the user that a view might be stale.

So it clearly recommends UA authors to separate history list and cache behaviour. So if user navigates through the history list (using Back or Forward buttons), HTTP spec recommends to show the **exact** response that the user saw before, regardless if it's stale or expired.

I've tested 4 major browsers - IE, FF, Opera and Safari, and here is the summary table:

<table border="1" cellpadding="3">
	<tbody>
	<tr>
		<th scope="row"><a title="click to see the corresponding perl code"
href="http://sharovatov.ru/testcases/samples/expiresAndCG.txt">Expires in the future
			+ <br>Conditional GET validators</a></th>
		<td style="color:green;">no request</td>
		<td style="color:green;">no request</td>
		<td style="color:green;">no request</td>
		<td style="color:green;">no request</td>
	</tr>
	<tr>
		<th scope="row"><a title="click to see the corresponding perl code"
href="http://sharovatov.ru/testcases/samples/expires.txt">Expires in the future</a>
		</th>
		<td style="color:green;">no request</td>
		<td style="color:green;">no request</td>
		<td style="color:green;">no request</td>
		<td style="color:green;">no request</td>
	</tr>
	<tr>
		<th scope="row"><a title="click to see the corresponding perl code"
href="http://sharovatov.ru/testcases/samples/CG.txt">Conditional GET validators</a>
		</th>
		<td style="color:green;">no request</td>
		<td style="color:green;">no request</td>
		<td style="color:green;">no request</td>
		<td style="color:green;">no request</td>
	</tr>
	<tr>
		<th scope="row"><a title="click to see the corresponding perl code"
href="http://sharovatov.ru/testcases/samples/noHeaders.txt">no HTTP caching
			headers</a></th>
		<td style="color:green;">no request</td>
		<td style="color:green;">no request</td>
		<td style="color:green;">no request</td>
		<td style="color:red;">full request</td>
	</tr>
	<tr>
		<th scope="row"><a title="click to see the corresponding perl code"
href="http://sharovatov.ru/testcases/samples/expiresPast.txt">Expires in the past</a>
		</th>
		<td style="color:green;">no request</td>
		<td style="color:green;">no request</td>
		<td style="color:green;">no request</td>
		<td style="color:red;">full request</td>
	</tr>
	<tr>
		<th scope="row"><a title="click to see the corresponding perl code"
href="http://sharovatov.ru/testcases/samples/noStore.txt">Cache-Control: no-store</a>
		</th>
		<td style="color:red;">full request</td>
		<td style="color:red;">full request</td>
		<td style="color:green;">no request</td>
		<td style="color:red;">full request</td>
	</tr>
	<tr>
		<th scope="row"><a title="click to see the corresponding perl code"
href="http://sharovatov.ru/testcases/samples/noStoreAndExpiresPast.txt">Cache-Control:
			no-store +<br>Expires in the past</a></th>
		<td style="color:red;">full request</td>
		<td style="color:red;">full request</td>
		<td style="color:green;">no request</td>
		<td style="color:red;">full request</td>
	</tr>
	</tbody>
	<thead>
	<tr style="background:#eee;">
		<th scope="col">Page served with</th>
		<th scope="col">IE8</th>
		<th scope="col">FF</th>
		<th scope="col">Opera</th>
		<th scope="col">Safari</th>
	</tr>
	</thead>
</table>

So we can see that only Opera follows HTTP 1.1 recommendation.

Obviously IE and FF don't produce a request when HTTP caching is not explicitly prohibited which is against the HTTP spec recommendation, but this was done intentionally as authors usually prohibit caching for a reason and don't want users to view those pages without revalidating.

And Safari just does the full request whenever the page is not cached explicitly.