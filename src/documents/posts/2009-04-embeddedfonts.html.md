---
layout: post
date: 2009-04
title: Embedded fonts
---

Long long ago (before IE4, yes, IE4) Microsoft  proposed a standard called EOT (<a href="http://en.wikipedia.org/wiki/Embedded_OpenType">Embedded OpenType</a>) which allowed you to embed any font on your website – all you had to do was to prepare eot fonts in a free <a href="http://www.microsoft.com/typography/web/embedding/weft3/overview.aspx">WEFT tool</a> (see <a href="http://www.sean.co.uk/a/webdesign/embedding_fonts_in_webpages.shtm">nice how-to</a>) and then reference them in your CSS:

	@font-face {
		font-family: myFont;
		src: url(myfont.eot);
	}
	h1 { font-family: myFont; }

It’s interesting to know that support for @font-face property appeared in <a href="http://www.w3.org/TR/2008/REC-CSS2-20080411/fonts.html#font-descriptions">CSS2.0</a> without specifying of font format, then was suddenly dropped in <a href="http://www.w3.org/TR/CSS21/fonts.html">CSS2.1</a> and now is back in <a href="http://www.w3.org/TR/css3-webfonts/#font-descriptions">CSS3</a>.

And now, 10 years later after this feature has been introduced in IE4, all other browsers are slowly starting to implement embedded fonts support. As always, browser vendors talk about compatibility more than actually support this compatibility – while the technology is 10 years old and quite mature, none of popular browsers supports or plans to support EOT – only IE.

And this silent boycott of EOT looks extremely weird because EOT has got a unique feature – font file in this format can be much smaller than a TTF/OTF file due to subsetting. And EOT is not proprietary any more – <a href="http://www.w3.org/Submission/2008/SUBM-EOT-20080305/">Microsoft has submitted it to W3C</a>.

The only reason browser vendors say stops them from implementing EOT is DRM, but:

* as <a href="http://novemberborn.net/sifr3/web-fonts-eot">Mark Wubben says</a>, using OTF/TTF can be violating fonts EULA while EOT was **designed to follow **the rules.

* there're free fonts that can be embedded.

And it’s really funny to read rants <a href="http://diveintomark.org/archives/2009/04/21/fuck-the-foundries">like this</a> – if there’s a law, you can’t just violate it because you think it’s too hard to follow it.

And while browser vendors pretend they don’t see the industry standard implementation of the technology, we’ll have to use something like this:

	@font-face {
		font-family: myFont;
		src: url(font.eot);
	}
	@font-face {
		font-family: myFont;
		src: url(font.ttf) format("truetype"),
		url(font.eot) format("embedded-opentype");
	}

I.e. set the @font-face twice – for IE and other browsers. More crap for us, developers. Thanks to Opera, Mozilla and Safari.

**Update: **Thanks to Philip Taylor, author of great <a href="http://fonts.philip.html5.org/">web fonts application</a>, he pointed in comments that I was wrong saying that TTF/OTF didn’t support subsetting – they did! But my point is still the same – why inventing other standards when there’s a working one?

Links:

* <a href="http://en.wikipedia.org/wiki/Embedded_OpenType">Wikipedia article about EOT</a>

* <a href="http://fonts.philip.html5.org/">Nice webapp that generates EOT files from free opentype fonts</a>

* <a href="http://talleming.com/2009/04/21/web-fonts/">Web fonts from font author prospective</a>

* <a href="http://www.w3.org/Fonts/Misc/eot-report-2008">EOT report</a>

* <a href="http://novemberborn.net/sifr3/web-fonts-eot">Excellent article by Mark Wubben (novemberborn) discussing license issues</a>