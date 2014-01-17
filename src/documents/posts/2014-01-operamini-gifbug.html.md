---
layout: post
date: 2014-01
title: Opera Mini bug with an animated gif as a background
tags:
    - css
    - webdev
    - operamini
---

A strange thing was noticed in Opera Mini during a feature development – animated gifs were not showing when set as a background image for an element.

As noted in [the review](http://sharovatov.github.io/posts/2013-10-operamini-review.html), Opera Mini usually displays animated gifs, but renders them statically, effectively showing only the very first frame. 

You can witness this behaviour by opening [this link](http://sharovatov.ru/operamini/gif-single.html) in Opera Mini and any other browser: Opera Mini will render only the first frame while other browsers will animate the whole image.

Note that if the first frame of your animated gif is transparent, Opera Mini will show the image rasterised to its background.

However, if an animated gif is set as a background of some element, it will not be shown at all, which can be observed [here](http://sharovatov.ru/operamini/gif-bg.html) – if you open this link in Opera Mini, all you see is three grayish rectangles. For some reason, Opera Mini does not render even the first frame of the images.

This can be fixed either by switching to `<img>` elements in the markup, or by exploiting the fact that browsers download `<img>`-served images even if they are hidden with `display:none` rule. Here’s [the testcase](http://sharovatov.ru/operamini/gif-bg-fix.html).

Unfortunately, if the html code containing animated gifs set as background is loaded dynamically (for example, with ajax or is constructed by a js templating engine), Opera Mini will refuse to render the images regardless of the fix presence, the background will be empty. The behaviour can be observed [here](http://sharovatov.ru/operamini/gif-loading.html).

To summarise: if you are to fix the existing markup with animated gifs set as elements’ backgrounds and no elements are loaded dynamically, it’s perfectly safe to apply `img style='display:none'` fix to force Opera Mini to load and render gifs’ first frame as backgrounds; but if your content is dynamically generated, there is no other choice but to change the markup to use plain `<img>` elements.