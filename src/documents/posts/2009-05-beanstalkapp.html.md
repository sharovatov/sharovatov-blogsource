---
layout: post
date: 2009-05
title: Beanstalkapp and Fogbugz - free online bugtracking and version control
---

Once I tried <a href="http://www.fogcreek.com/fogbugz/learnmore.html">Fogbugz</a> bug tracking <a href="http://www.fogcreek.com/FogBugz/IntrotoOnDemand.html">on-demand service</a> and was amazed how cool it was and how easy it was to use it – no problems with installing and managing anything – just register and start working. And it’s not only a bug tracking software, but a full-fledged project management solution, and as the support cost is zero, it’s almost invaluable for small projects or your own start-up. 

It’s free for 2 users only, which is more than enough if you’re running a hobby project, but if you have a budget, you can easily afford $25 for each additional user.

But in proper development you also need <a href="http://en.wikipedia.org/wiki/Revision_control">source code management system</a> (SCM). And <a href="http://www.fogcreek.com/FogBugz/docs/60/topics/advanced/Sourcecontrolintegration.html?isl=130641">Fogbugz allows for great level of integration</a> with all popular SCM systems. But if you choose Fogbugz on-demand to avoid support costs of running it locally, does it sound logical to install SCM locally? Definitely not.

And here comes <a href="http://beanstalkapp.com/">beanstalk</a> – great hosted hassle-free version control service. It’s free for 3 users and a repository of up to 100Mbytes, and you can easily upgrade at any time.

In most cases, free version should suit your hobby project or start up. Beanstalk runs <a href="http://en.wikipedia.org/wiki/Subversion_(software)">subversion</a> SCM which is almost a de-facto standard in project development and has client software for all platforms.

But the best thing in Beanstalk for me is that it provides <a href="http://help.beanstalkapp.com/faqs/integration-tools/integrating-with-fogbugz">integration with Fogbugz on-demand</a>!

**So you can have bug tracking/PM and version control software at no cost!** It is just a dream for a hobby project or a small start-up.

The installation process is dead easy:

1. register at fogbugz.com for on-demand service and get **yourproject.fogbugz.com** address

2. register at beanstalkapp.com for a free account and get **yourproject.beanstalkapp.com** address and login there. You will be prompted to set your first repository. I assume that you’re just starting and don’t have SCM system yet, so just zip your working directory (where all your project files are) and upload it. Your first repository will be created.

3. go to your repository setup → integration → fogbugz. All you need to do is follow the instructions – but basically they will just need your fogbugz URL (yourproject.fogbugz.com) and username with password.

4. <a href="http://help.beanstalkapp.com/faqs/getting-started-11/choosing-your-subversion-client">choose your subversion client</a>, download it and install. All you’ll have to configure in the client is a repository URL, it will look something like this: 

		http://yourproject.svn.beanstalkapp.com/myfirstrepo/ 

	and your username/password (usually username is the email you entered when registering). That’s it, you can delete all files from the working directory on your computer (do a backup before deleting!) and check-out files from your repository there. I use <a href="http://en.wikipedia.org/wiki/TortoiseSVN">tortoiseSVN</a> so I just stopped IIS, removed everything from my c:\inetpub\testproject directory, right-clicked on it and chose “Check-out” from TortoiseSVN menu. In a minute I had all my files fetched from beanstalk repository. I started IIS and had my test project up and running, but now with full source control!

5. in Fogbugz – set “**Source Control URL for logs**” and “**Source Control URL for diffs**”. To do this, you need to go to your fogbugz account, to Settings → site → Main. Grab your repository URL from beanstalk, add “browse/^FILE” to it and set it as “**Source Control URL for logs**”. It should look something like that:

		http://yourProject.beanstalkapp.com/yourRepository/browse/^FILE

	And “**Source Control URL for diffs**” will be
	
		http://yourProject.beanstalkapp.com/yourRepositroy/diff/path/^FILE?from=^R2&amp;to=^R1

Voila! Everything should be working.

So the workflow will be like that:

1. If you have a bug or a feature request, you enter it to Fogbugz, it will get a number assigned.

2. When you (or someone else) start working on a bug, you just edit your code and then commit it. When committing, you can add tags to a commit message. For example, if you do a commit with the following message:
	
		[case:34 status:resolved] 
		fixed IE5.5 lack of .toFixed() support

	Beanstalk will go to FogBugz, find bug #34, add the message to it and mark the bug as resolved. <a href="http://www.wildbit.com/blog/2008/01/21/beanstalk-major-update-today/">See here</a> for more commit tags.

3. Then in Fogbugz bug#34 you will see that it’s been just resolved and you will be able to check what files were changed and look at the diff of the changes.

So that’s it, you’ve got your bug tracking and version control software set up and integrated. It’s working online so support cost is zero, and it’s completely free :)

P.S. What’s also great about Beanstalk is that it supports twitter integration – so if you have an open-source project, your users can follow it on twitter and see what you’re committing! It also supports web-hooks API so integration is limited to your fantasy only :)

P.P.S. The only thing that’s left is database versioning control – we need something like RoR migrations, but that’s a topic for another post :)