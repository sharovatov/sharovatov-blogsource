---
layout: post
date: 2013-12
title: Code comprehension performance and code style
tags:
    - programming
---

I’ve recently come across an old but interesting [paper by Elliot Soloway and Kate Ehrlich on the code comprehension](http://www.researchgate.net/publication/220071417_Empirical_Studies_of_Programming_Knowledge/file/d912f512cb2e91a8c1.pdf).

The main thing the paper concludes is that experienced programmers with time develop schematic comprehension, i.e. they tend to quickly “parse” and understand code by blocks, where each block seems to have certain meaning. Novice programmers don’t possess enough experience to be able to grasp the code meaning by blocks and therefore tend to parse code statement by statement, and perform much worse.

However, this fast code scanning of the experienced programmers is of no value if the code block does something different from what it seems it should do — i.e. if the code doesn’t follow the implied conventions for the language and the problem area. This fast scanning might even have dangerous impact if the code block was misunderstood and the misunderstanding went unnoticed, in which case the experienced developer will imply incorrect behavior of the program. 

The paper states that there is nearly no difference in performance between an experienced and novice programmer when the code does not follow the usual conventions, code style and plan.

This reiterates the point that enforcing code conventions and code style rules can make your team perform better since experienced developers will easier comprehend the code and perform at their maximum level and novice developers will learn the basic structures, schemes and conventions earlier.

I do believe that what can be automated to save human effort, should be automated, and that is why tools like [jscs](https://github.com/mdevils/node-jscs) and [jslint](http://www.jslint.com)/[jshint](http://www.jshint.com) should be employed by almost any team, and issues that cannot be caught by the tools are to be identified and fixed at the code review stage.