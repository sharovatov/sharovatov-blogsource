---
layout: post
date: 2009-04
title: designMode and Firefox
---

Another weird bug reported back in 2004 and unfortunately still not resolved – <a href="https://bugzilla.mozilla.org/show_bug.cgi?id=232791">bug 232791</a>, marked as a dup for <a href="https://bugzilla.mozilla.org/show_bug.cgi?id=474255">bug 474255</a> (testcase <a href="https://bug232791.bugzilla.mozilla.org/attachment.cgi?id=187018">here</a> – if you click on the editable window, neither delete nor backspace button works, and if you add a character, it springs back to life). When you work with wysiwyg editor in Firefox (<a href="http://kb.mozillazine.org/Firefox_:_Midas">MIDAS</a>), and programmatically add a text node to the end of the editable document, Firefox creates a dumb BR node of type `_moz` with `_moz_editor_bogus_node` attribute.

<a href="https://bugzilla.mozilla.org/show_bug.cgi?id=232791#c8">Yuh-Ruey Chen proposed</a> a workaround – you set designMode to 'off' and then back to 'on' and it works, and this approach is used in YUI library (see <a href="http://yuilibrary.com/projects/yui2/ticket/1946017">ticket 1946017</a>).

The weird thing I noticed now in FF 3.0.8 is that while the bug is still not fixed, the bogus BR node is not visible through Firebug for some reason! And that’s strange – node’s invisible, but still there.

However, workaround still works so nothing to worry about, just interesting.