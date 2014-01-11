---
layout: post
date: 2011-01
title: small piece of js code explained
---

Today a colleague showed me a piece of js code and asked to explain how it works.

Here’s the code:

	(function(x) {return x(x);})(function(z){ return function(y){ return z; } })(1)(2)(3) 

For many from non-js background it would be easier if I rewrite first two function expressions as function declarations, turn third function expression into named function expression and break the execution into parts:

	function f1(x) {
		return x(x);
	}
	function f2(z) {
		return function f3 (y) {
			return z;
		}
	}
	var result1 = f1(f2);
	var result2 = result1(1);
	var result3 = result2(2);
	var result4 = result3(3);

So let's see what each function does first:

Function **f1** accepts one argument and calls this argument as a function and passes it with itself as a parameter.

Function **f2 **accepts parameter **z **and creates another function. As **f2 **scope gets copied to **f3**, argument **z **is always accessible from within **f3**; and what **f3** does is it returns this argument **z**.

After we grasp the idea of what these functions do, let’s see how everything is executed.

When `var result1 = f1(f2)` is executed, **f1** is called with **f2** passed as a parameter. `return x(x)` means that we need to call `f2(f2)` and return the result.

When **f2** is called with **f2** as a parameter, function **f3** will be created and it’s **z** will hold a reference to **f2**. And this **f3** is returned to **result1**.

Now we know that **result1 **actually holds a reference to **f3** which regardless of the parameters always returns a reference to **f2** which it “remembered” earlier. Hence, when we come to execute `var result2 = result1(1)`, we actually call **f3(1)** and our **f3** just returns a reference to **f2**.

So, this part of the code 

	(function(x) { return x(x) })(function(z){ return function(y) { return z; } })(1)

could be replaced with 

	(function(z){ return function(y) { return z; } })

Let's move on and execute `var result3 = result2(2);`. We’ve just found out that **result2** holds a reference to **f2**, so it’s rather **f2(2)** that we’re seeing here, which – as we remember – creates **f3** function and stores **z** in it’s context. This **f3** will always return 2, **result3** is a function will always return 2.

And when we execute `var result4 = result3(3)`,** f3(3)** is actually called and returns 2 as expected.

I think, this again proves that javascript is syntactically very powerful language.