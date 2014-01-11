---
layout: post
date: 2009-04
title: rel="canonical"
---

I recently found out a very useful SEO stuff supported by Google (<a href="http://googlewebmastercentral.blogspot.com/2009/02/specify-your-canonical.html">here</a>), Microsoft Live Search (<a href="http://blogs.msdn.com/webmaster/archive/2009/02/12/partnering-to-help-solve-duplicate-content-issues.aspx">here</a>), Yahoo (<a href="http://blog.ask.com/2009/02/ask-is-going-canonical.html">here</a>) and Ask.com ( <a href="http://ysearchblog.com/2009/02/12/fighting-duplication-adding-more-arrows-to-your-quiver/">here</a>) – canonical links.

Basically, if you have a page accessible by multiple URLs, from search engine’s prospective you’re bloating its database by serving duplicate content. So to avoid this, you have to set `<link rel="canonical" href="...">` with `href` pointing to the original URL of this page. Search engines will check the url in href attr and won’t put a duplicate content penalty on your pages.

Useful thing to remember and use!

WordPress (<a href="http://wordpress.org/extend/plugins/canonical/">here</a>) and RoR (
<a href="http://github.com/mbleigh/canonical-url/tree/master">here</a>) have already got plugins for canonical URL support. Hope to see support for this useful rel in other frameworks, forum and blog engines.

And I just found an <a href="http://annevankesteren.nl/2009/04/rev-canonical">interesting post on this topic</a> by Anne van Kesteren with interesting discussion going in comments.