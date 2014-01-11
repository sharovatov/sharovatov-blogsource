---
layout: post
date: 2009-11
title: Beanstalkapp, FogBugz and now Case Tracker
---


As a follow-up to <a href="http://sharovatov.wordpress.com/2009/05/23/beanstalkapp-and-fogbugz-free-online-bugtracking-and-version-control/">my post about free hosted integrated solution for bugtracking and version-control</a>, I’d like to introduce a great tool I accidentally found and then installed – <a href="http://code.google.com/p/visionmap/wiki/CaseTracker">Case Tracker</a>.

It’s a free desktop application which allows you to easily view a list of current bugs, gives you a way to “start working” on the bug – so the time you actually spend on fixing the bug or implementing the feature is carefully calculated. So it’s basically a time-tracking application for a fogbugz – it takes the list of bugs

<img title="image" border="0" alt="image" src="http://sharovatov.files.wordpress.com/2009/11/image.png?w=717&#038;h=165" width="717" height="165">

To start working, you need to enter your fogbugz username, password and the URL where you have it installed:

<img title="image" border="0" alt="image" src="http://sharovatov.files.wordpress.com/2009/11/image1.png?w=505&#038;h=184" width="505" height="184">

Case Tracker supports both FogBugz On-demand and hosted versions – it simulates all required POST requests as if you’re working with Fogbugz through your browser. As soon as you entered correct username and password, it will show you the list of active bugs:

<img title="image" border="0" alt="image" src="http://sharovatov.files.wordpress.com/2009/11/image2.png?w=639&#038;h=339" width="639" height="339">

However, by default it shows bugs assigned to anybody, which may be not always desirable. To address this issue, Case Tracker provides a search filter (funnel on the right-hand side of the pause button). For example, I need only those bugs that are assigned to me, so I add `assignedto:"Vitaly Sharovatov"` as a search filter:

<img title="image" border="0" alt="image" src="http://sharovatov.files.wordpress.com/2009/11/image3.png?w=687&#038;h=131" width="687" height="131">

Then I press “Go” and get my list populated with only those bugs that I need! Awesome!

For more detailed instructions on the allowed syntax read <a href="http://www.fogcreek.com/fogbugz/docs/60/topics/basics/Searchingforcases.html">this</a>.

What’s really great in Case Tracker – it can automatically stop measuring time when you’re away from keyboard for a certain period of time:

<img title="image" border="0" alt="image" src="http://sharovatov.files.wordpress.com/2009/11/image4.png?w=452&#038;h=278" width="452" height="278">

However, Case Tracker doesn’t allow creating new cases – it opens your fogbugz URL in your default browser so you can enter new case there. But Case Tracker is not a replacement for Fogbugz UI – it’s goal is to simplify time tracking.

So the general flow is:

1. you choose a bug from a drop-down list

2. if the estimate hasn’t been set for this bug, Case Tracker prompts you to enter the estimate (using the same syntax rules as in Fogbugz in the browser)

3. the work is started and time is measured – if you’re afk or just press pause button, it stops measuring the time

4. when you’re finished – you commit the bug and mark it resolved either by specifying status:resolved in svn comments or using Case Tracker – I prefer to specify it in a submit comment – just got used to it.

So if you use fogbugz – this tool is definitely worth trying!