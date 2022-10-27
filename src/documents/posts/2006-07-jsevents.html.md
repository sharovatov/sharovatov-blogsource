---
layout: post
date: 2006-07
title: Javascript Events
---

Пожалуй, события (а точнее, обработчики событий) в javascript играют чуть ли не самую важную роль - именно благодаря обработке событий возможно интерактивное общение веб-приложения с пользователем. Изначально обработчики событий начал поддерживать браузер Netscape 2, следом IE3, и затем уже все остальные браузеры.
В этом посте я начну рассказывать про события в js, в течение месяца постараюсь "добить" тему событий и приступить к более интересным вещам.

### Способы установки обработчиков

Существуют четыре варианта "навешивания" обработчиков на определенное событие:

<ol>
<li id="pseudoprotocol">**псевдопротокол <var>javascript:</var>**. Псевдопротокол <var>javascript:</var> по-настоящему бывает необходим очень редко, но, к сожалению, используется повсеместно. Делают это так:

	<a href="javascript:alert('got click!')">link</a>

Изначально этот протокол был создан для тестов - и до сих пор удобно проверять что-то по-быстрому, вписав в адресную строку выражение (например, в IE я раньше проверял hasLayout таким образом - писал в адресную строку `javascript:alert(someElement.currentStyle.hasLayout)`). Этот протокол никогда не был предназначен для навешивания обработчиков событий. Но люди поняли, что при нажатии на ссылку происходит выполнение содержимого её атрибута <var>href</var> (вспомните, что происходит при нажатии на ссылку, имеющую <var>href="mailto:somemail@serv.com"</var>), и стали использовать псевдопротокол <var>javascript:</var> для **замены** основного предназначения ссылки (исполнения роли идентификатора связанного документа посредством универсального локатора ресурса (URL)).

Стоит отметить, что <a href="http://www.iana.org/assignments/uri-schemes.html">ни</a> <a href="http://www.gbiv.com/protocols/uri/rfc/rfc3986.html">в</a> <a href="http://www.ietf.org/rfc/rfc2718.txt">одной</a> <a href="http://www.ietf.org/rfc/rfc2396.txt">спецификации</a> не сказано про наличие протокола <var>javascript:</var>, потому я и называю его "псевдопротоколом" (в то же время <var>mailto:</var> <a href="ftp://ds.internic.net/rfc/rfc1738.txt">как раз</a> <a href="http://www.w3.org/Addressing/URL/url-spec.html">описан</a>).

Более того, WCAG <a href="http://www.w3.org/WAI/GL/WCAG20/tests/test181.html">говорит</a> о том, что псевдопротокол <var>javascript:</var> использовать вообще нельзя, и в этом случае я с ними полностью согласен.

Однако авторы браузеров из соображений обратной совместимости продолжают поддерживать эту пакость, а колхозные веб-девелоперы продолжают пользоваться этой дрянью. Основное неудобство и контрпродуктивность такого подхода в том, что теряется сам смысл ссылки. Ведь со ссылкой можно сделать множество различных вещей - добавить в закладки, открыть в новом окне, распечатать содержимое, сохранить содержимое. Весь этот функционал теряется при использовании этого псевдопротокола. Вообще же этот способ не является полноценным методом установки обработчика события, потому что этот метод может быть примёнен только для элементов, имеющих атрибуты src/href.

При использовании ссылок с таким обработчиком необходимо помнить, что функция ни в коем случае ничего не должна возвращать, иначе произойдёт "переход" на страницу, содержимое которой будет состоять из возвращённого значения.</li>
<li id="inlinemethod">**inline-метод**. Запись атрибута on**event** html-элемента. Пример: 

	<a href="someurl.html" onclick="alert('got click!')">link</a>

Этот метод появился самым первым, и поддерживается **абсолютно везде**. Недостаток его заключается в том, что логика смешивается с содержимым. (если вдруг придётся изменить обработчики, придётся лезть в код (х)html). Применять же его можно, как мне кажется, лишь в самых простых сайтах-визитках, где весь js-функционал заключается, например, в открытии/скрытии какой-нибудь карты проезда. Ссылка сохраняет свой основной функционал, её можно положить в закладки и т.д. Если же Вы не можете держать в памяти все установленные обработчики в проекте, то этот способ неприемлем.</li>
<li id="elementattribute">**Установка element.onclick в js**. Данный метод сообразен предыдущему за тем исключением, что установка обработчика происходит не непосредственно в (x)html, а в скрипте, и это удобнее. Пример: 

	где-то в html: 
	<a href="someurl" id="myhref">link</a>

	где-то в javascript:
	var handler = function(){ alert('clicked'); };
	document.getElementById('myhref').onclick = handler;

<li id="addeventlistener">**<a href="http://www.w3.org/TR/DOM-Level-2-Events/events.html#Events-EventTarget-addEventListener">addEventListener</a>/<a href="http://msdn.microsoft.com/library/default.asp?url=/workshop/author/dhtml/reference/methods/attachevent.asp">attachEvent</a>**.

<var>addEventListener</var> - специфицированный в DOM Level2 метод, <var>attachEvent</var> же встречается только в IE.

Оба этих метода предоставляют наиболее многофункциональную реализацию добавления обработчика события. Пример:

	var handler = function(e){ alert('clicked'); };
	var elem = document.getElementById('note');

addEventListener:

	elem.addEventListener('click', handler, false);

attachEvent:

	elem.attachEvent('onclick', handler);
</li></ol>
Также существуют ещё два метода установки обработчиков событий:

* **в IE4 и старше: **

	&lt;p id="myP">text&lt;/p>
	&lt;script for="myP" event="onclick">
		//code
	&lt;/script>

* **Opera9, Firefox1.5: **<a href="http://www.w3.org/TR/xml-events/">XML events</a>

Но мы эти методы рассматривать не будем, т.к. до поддержки XML events самому популярному браузеру (IE) гораздо дальше, чем до поддержки событийной модели w3c, а <var>script for</var> нарушает принцип отделения логики от содержания (и работает только в IE).

Как Вы успели заметить, первая пара методов отличается от второй коренным образом - обработчики, определяемые в (x)html-документе, представляют собой последовательность javascript-команд, обработчик же, установленный в самом скрипте, обязан быть объектом типа "функция".

Также при использовании второй пары способов возникает одна проблема - если скрипт расположен в документе **до** элемента, событие которого будет обрабатывать какая-то функция из скрипта, велика вероятность того, что браузер попытается "навесить" обработчик на ещё несуществующий элемент. Такое может произойти, если браузер **уже** получил содержимое скрипта и распарсил его, но ещё не получил сам элемент в (x)html-документе. Это далеко не такая редкая ситуация, как может показаться - скрипты, вынесенные во внешние файлы, часто кэшируются, и несколько документов используют одни и те же скрипты, потому браузер часто берёт файлы скриптов из кэша, соответственно, сразу же исполняя их. Впрочем, скрипты, описанные внутри элемента <var>head</var> (x)html-документа, также будут исполнены сразу же, не дожидаясь полной загрузки (x)html-документа в память. Проблема эта решается просто - в структуре DOM, предоставляемой каждым браузером скриптам, есть объект window, имеющий кучу свойств, методов и событий, и одно из таких событий - <var>window.onload</var>. Это событие вызывается браузером после получения и парсинга всего (х)html-документа. Соответственно, в js наиболее безопасно работать с документом и его элементами
**после** появления этого события.

Пример:

	<html>
	<head>
		<title>test</title>
		<script type="text/javascript">
			**window.onload = function(e) {**
				//it's safe inside
				var handler = function(e){ alert('clicked on paragraph'); };
				document.all['text'].onclick = handler;
			**};**
		</script>
	</head>
	<body>
		<h1>header</h1>
		<p id="text">text</p>
	</body>
	</html>

Так как пример будет работать во всех браузерах в quirks mode, я имею полное право использовать document.all (к тому же, так ещё и IE4 будет поддержан). Цель примера исключительно иллюстрационная, потому кому нужен standarts compliancy mode, переделайте <var>document.all['text']</var> на <var>document.getElementById('text')</var>. 

Итак, мы выяснили, _когда_ добавлять обработчики, договорились не использовать первые два метода (inline-описание и псевдопротокол javascript:). Теперь я подробнее остановлюсь на последних двух методах.

Метод установки element.onclick хорош тем, что прост. Основной же его минус заключается
в том, что он не позволяет _добавить обработчик_, он даёт лишь возможность
_заменить существующий_ (если таковой был определён). Получается, что с помощью установки свойства onclick невозможно использовать несколько обработчиков на одном элементе, что иногда бывает нужно. <small>Вообще, конечно, добавить можно и через onclick, только геморрой.</small> Методы же addEventListener и attachEvent позволяют именно добавлять обработчики (для них существуют и соответствующие методы удаления обработчиков - removeEventListener и detachEvent).

При установке какому-то событию определенного элемента одного и того же обработчика, дупликат не будет установлен.

В следующем примере обработчик divHandler будет вызван только один раз:

	<html>
	<head>
		<title>test</title>
		<script type="text/javascript">
			window.onload = function(e) {
				var handler = function(e) { alert('clicked on div'); };
				document.all['text'].addEventListener('click', handler, false);
				document.all['text'].addEventListener('click', handler, false);
			};
		</script>
	</head>
	<body>
		<h1>header</h1>
		<div id="text">text</div>
	</body>
	</html>

Когда на одном элементе "висит" несколько обработчиков, они выполняются в том порядке,
в каком были установлены - стэк, хранящий обработчики событий, имеет тип FIFO.

	var elem = document.getElementById('note');
	var handler1 = function(e){ alert('handler1'); };
	var handler2 = function(e){ alert('handler2'); };
	var handler3 = function(e){ alert('handler3'); };
	note.addEventListener('click', handler1, false);
	//note.attachEvent('onclick', handler1);
	note.addEventListener('click', handler2, false);
	//note.attachEvent('onclick', handler2);
	note.addEventListener('click', handler3, false);
	//note.attachEvent('onclick', handler3);

В этом примере выполнится сначала <var>handler1</var>, затем <var>handler2</var>, потом <var>handler3</var>.

Несмотря на то, что в msdn сказано, что обработчики, буде таких несколько на событии объекта, выполняются в рандомном порядке, опыт говорит, что они выполняются именно в FIFO-порядке.

#### Резюмируем:
1. Обработчики могут устанавливаться четырьмя основными способами: <a href="#pseudoprotocol">используя псевдопротокол <var>javascript:</var></a>, <a href="#inlinemethod">c помощью установки атрибута элемента в (x)html</a>, <a href="#elementattribute">устанавливая свойство объекта в javascript</a>, <a href="#pseudoprotocol">используя специальные методы (<var>attachEvent</var> для IE и <var>addEventListener</var> для реализующих стандарт DOM2 Events браузеров)</a>.

* Методы использования псевдопротокола <var>javascript:</var> и установки атрибута элемента малоприменимы в реальных условиях.

* Использование специальных методов (<var>attachEvent</var>/<var>detachEvent</var> и <var>addEventListener</var>/<var>removeEventListener</var>) позволяют, в отличие от метода установки свойства объекта, _добавлять и удалять_ обработчики событий (а не устанавливать единственный и отменять вовсе). Метод же установки свойства объекта наиболее прост в использовании, и там, где точно хватит одного обработчика события, будет более удобен.

* Если у элемента несколько обработчиков одного события, при возникновении события они будут запущены в том же порядке, в каком были добавлены.

* Регистрация одного и того же обработчика события дважды невозможна, обработчики должны быть уникальны.

### Порядок запуска обработчиков события

Так как (x)html-документ имеет иерархическую древовидную структуру, разработчики браузеров посчитали, что "пропускание события" по всей иерархии документа даст большую свободу веб-разработчикам в реализации интересных обработчиков.

Итак, предположим, у нас есть следующий код:

	<html>
	<head>
	<title>test</title>
	<script type="text/javascript">

	window.onload = function(e) {
		var pHandler = function(e){ alert('clicked on paragraph'); };
		var bodyHandler = function(e){ alert('clicked on body');}
		var docHandler = function(e){ alert('clicked on document'); };
		document.onclick = docHandler;
		document.body.onclick = bodyHandler;
		document.all['text'].onclick = pHandler;
	};

	</script>
	</head>
	<body>
	<h1>header</h1>
	<p id="text">text</p>
	</body>
	</html>

Если нажать на <var>p</var>, запустится сначала обработчик <var>pHandler</var>, затем <var>bodyHandler</var> и уже потом <var>docHandler</var>.

<img src="http://photos1.blogger.com/blogger/2964/3399/320/bubbling.gif" alt="bubbling event model"><br>Событийная модель, в которой браузер выстраивает очередь обработчиков от целевого элемента, инициировавшего событие до корневого элемента <var>document</var>, называется <dfn>bubbling-моделью</dfn> (bubble, англ., - пузырь).

Событие как бы "всплывает" по иерархии документа от элемента, вызвавшего его и до корня. При прохождении каждого родительского элемента браузер проверяет, не установлен ли у этого родителя обработчик события такого же типа, и если установлен, вызывает его. 

Эта модель реализована в IE.

Если запустить этот пример в браузере Netscape4(с небольшими изменениями), обработчики будут выполнены в обратном порядке - <var>docHandler</var>&rarr;<var>bodyHandler</var>&rarr;<var>divHandler</var>.

<img src="http://photos1.blogger.com/blogger/2964/3399/320/capturing.gif" alt="capturing event model"><br>Событийная модель, в которой браузер выстраивает очередь обработчиков от корневого элемента <var>document</var> до целевого элемента (инициировавшего событие), называется <dfn>capturing-моделью</dfn> (capturing, англ., - захват).
При прохождении каждого элемента вниз по иерархии браузер проверяет наличие обработчика события такого же типа, и если обработчик есть, вызывает его.

Эта модель появилась в браузере Netscape3 и со времен Netscape4 в диком виде не наблюдается.

Вообще же Netscape4 - сущий баг, да и процент его на рынке исчезающе мал, потому на нём внимание заострять не будем.

Позже, когда проблемы с разными событийными моделями всем надоели, дядьки из W3C решили стандартизировать событийную модель. Назвали они ее нехитро - <a href="http://www.w3.org/TR/DOM-Level-2-Events/events.html">DOM Events</a>.

Они попытались объединить обе модели. К сожалению, этой спецификации следуют только браузеры Firefox1.5 и Opera9, но в свете проснувшегося интереса IETeam к следованию стандартов, к 8-й версии IE также можно ожидать поддержки этой спецификации. И потому я попытаюсь рассказать о ней.

Как я уже сказал, событийная модель w3c объединяет capturing и bubbling модели с небольшими изменениями. В стандарте w3c для установки обработчика события используется метод <var>addEventListener.</var> Он описан в интерфейсе <var>EventTarget</var>, который авторы браузеров обязаны реализовать для любого элемента.

	interface EventTarget {
		void addEventListener(in DOMString type, in EventListener listener, in boolean useCapture);
		void removeEventListener(in DOMString type, in EventListener listener, in boolean useCapture);
		boolean dispatchEvent(in Event evt) raises(EventException);
	};

Для нас сейчас существенно то, что третий параметр метода <var>addEventListener</var> (<var>useCapture</var>) - флаг, говорящий браузеру, на какой стадии прохождения события должен быть запущен добавляемый обработчик.

Реализующий w3c-модель браузер при появлении события сначала проходит по иерархии документа сверху вниз, как в <var>capturing-модели</var>, затем, когда добирается до целевого элемента, инициировавшего событие, исполняет его обработчик события и совершает путь снизу вверх по иерархии документа, как в <var>bubbling-модели</var>. В w3c-модели при обработке события выделяют capturing- и bubbling-**фазы** прохождения события.

Таким образом можно выстраивать очень гибкие системы, особенно если учесть тот факт, что на любой фазе можно остановить дальнейшее "продвижение" прохождения события.

Таким образом, любой элемент документа в w3c-модели (в отличие от IE bubbling model и NN4 capturing model) имеет два стэка для хранения обработчиков событий - для хранения обработчиков для capturing-стадии и для хранения обработчиков, назначенных на исполнение в bubbling-стадии.

Возьмём для примера следующий код:

	<html>
	<head>
	<title>test</title>
	<script type="text/javascript">
	window.onload = function(e) {
		var doc1Capturing = function(e) { alert('document: first capturing handler'); };
		var doc2Capturing = function(e) { alert('document: second capturing handler'); };
		var doc3Capturing = function(e) { alert('document: third capturing handler'); };

		var doc1Bubbling = function(e) { alert('document: first bubbling handler'); };
		var doc2Bubbling = function(e) { alert('document: second bubbling handler'); };
		var doc3Bubbling = function(e) { alert('document: third bubbling handler'); };

		var body1Capturing = function(e) { alert('body: first capturing handler '); };
		var body2Capturing = function(e) { alert('body: second capturing handler'); };
		var body3Capturing = function(e) { alert('body: third capturing handler '); };

		var body1Bubbling = function(e) { alert('body: first bubbling handler '); };
		var body2Bubbling = function(e) { alert('body: second bubbling handler'); };
		var body3Bubbling = function(e) { alert('body: third bubbling handler '); };

		var div1Capturing = function(e) { alert('div: first capturing handler '); };
		var div2Capturing = function(e) { alert('div: second capturing handler'); };
		var div3Capturing = function(e) { alert('div: third capturing handler '); };

		var div1Bubbling = function(e) { alert('div: first bubbling handler '); };
		var div2Bubbling = function(e) { alert('div: second bubbling handler'); };
		var div3Bubbling = function(e) { alert('div: third bubbling handler '); };

		document.addEventListener('click', doc1Capturing, true);
		document.addEventListener('click', doc2Capturing, true);
		document.addEventListener('click', doc3Capturing, true);

		document.addEventListener('click', doc1Bubbling, false);
		document.addEventListener('click', doc2Bubbling, false);
		document.addEventListener('click', doc3Bubbling, false);

		document.body.addEventListener('click', body1Capturing, true);
		document.body.addEventListener('click', body2Capturing, true);
		document.body.addEventListener('click', body3Capturing, true);

		document.body.addEventListener('click', body1Bubbling, false);
		document.body.addEventListener('click', body2Bubbling, false);
		document.body.addEventListener('click', body3Bubbling, false);

		document.all['text'].addEventListener('click', div1Capturing, true);
		document.all['text'].addEventListener('click', div2Capturing, true);
		document.all['text'].addEventListener('click', div3Capturing, true);

		document.all['text'].addEventListener('click', div1Bubbling, false);
		document.all['text'].addEventListener('click', div2Bubbling, false);
		document.all['text'].addEventListener('click', div3Bubbling, false);
	};
	</script>
	</head>
	<body>
	<h1>header</h1>
	<div id="text">text</div>
	</body>
	</html>

Если нажать в приведённом примере на <var>div</var>, порядок выполнения обработчиков должен быть следующим:

<img src="http://photos1.blogger.com/blogger/2964/3399/320/w3c.gif" alt="">

Я не забыл указать в capturing-фазе обработчики события, установленные на элемент <var>div</var> на исполнение в capturing-фазе (<var>div1Capturing</var>, <var>div2Capturing</var>, <var>div3Capturing</var>), они не должны быть запущены. Спецификация указывает, что обработчики событий, назначенные на capturing-фазу, должны выполняться только для родителей целевого элемента. В данном случае только Opera следует стандарту.

<a href="https://bugzilla.mozilla.org/show_bug.cgi?id=235441">Этот баг в FF</a> открыт уже 2 с половиной года, когда же будет решение, неизвестно.

При появлении события в соответствии с w3c-моделью браузер должен:

* подготовить маршрут для обхода дерева от корневого элемента до целевого (приготовление к capturing-фазе). <small>Этот пункт важен, так как в процессе прохождения фазы _порядок_ исполнения обработчиков нельзя будет изменить даже посредством удаления элементов, на которые они установлены, можно будет лишь остановить процесс прохождения фазы вообще.</small>

* запустить обхода дерева в capturing-фазе: для каждого последующего элемента в иерархии проверить наличие обработчиков события данного типа, в случае наличия таковых, запустить. Как только событие приходит к целевому элементу, исполнение capturing-фазы прекратить.

* подготовить маршрут для обхода дерева от целевого элемента до корневого (приготовления для bubbling-фазы). <small>Этот пункт важен, так как в процессе прохождения фазы _порядок_ исполнения обработчиков нельзя будет изменить даже посредством удаления элементов, на которые они установлены, можно будет лишь остановить процесс прохождения фазы вообще.</small>

* запустить обхода дерева в bubbling-фазе: для каждого последующего элемента в иерархии проверить наличие обработчиков события данного типа, в случае наличия таковых, запустить. После исполнения обработчиков события данного типа, назначенных на корневой элемент (<var>document</var>) на исполнение в bubbling-фазе закончить процесс прохождения фазы.

Фактически получается, что изменить порядок выполнения обработчиков можно только для обработчиков, назначенных на исполнение в bubbling-фазе и только из обработчиков, выполняющихся в capturing-фазе.

#### Резюмируем:
1. <dfn>bubbling-модель</dfn> подразумевает прохождение дерева (x)html-документа снизу вверх, от целевого элемента, возбудившего события, до корневого элемента <var>document</var>. При прохождении каждого элемента проверяется, не зарегистрировано ли у него обработчиков события такого же типа, если да, запуск этих обработчиков.

* <dfn>capturing-модель</dfn> подразумевает прохождение дерева (x)html-документа сверху вниз, от корневого элемента <var>document</var> до целевого элемента, возбудившего событие. При прохождении каждого элемента проверяется, не зарегистрировано ли у него обработчиков события такого же типа, если да, запуск этих обработчиков.

* <dfn>W3C DOM2 Events-модель</dfn> сочетает в себе обе модели. При возбуждении события браузер обходит документ сначала сверху вниз по иерархии (<dfn>capturing-фаза</dfn>), при наличии выполняя обработчики события данного типа у каждого из предков целевого элемента; затем переходит к <dfn>bubbling-фазе</dfn>, при которой сначала запускаются обработчики целевого элемента, назначенные на <dfn>bubbling-фазу</dfn>, затем браузер идёт вверх по иерархии документа, запуская обработчики события данного типа (в случае наличия) у каждого следующего элемента в иерархии, достигая корневого элемента <var>document</var>, выполняя его обработчики события, назначенные на <dfn>bubbling-фазу</dfn>. Ещё раз акцентирую внимание: обработчики, назначенные на <dfn>capturing-фазу</dfn>, не должны быть запущены на целевом элементе. Я думаю, баг в FF всё-таки исправят и этот браузер тоже начнет следовать стандарту.