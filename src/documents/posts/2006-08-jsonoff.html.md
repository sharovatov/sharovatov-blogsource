---
layout: post
date: 2006-08
title: разные стили при js on/off
---

Часто на сайтах некий функционал реализован целиком на js. Всё бы хорошо, но некоторые несознательные граждане отключают выполнение javascript в браузере, тем самым выключая весь этот замечательный функционал :). И остаются потом пустые контролы, нефункционирующие кнопки и прочая прочая. Поэтому всё сознательное человечество пользователям с выключенным js не показывает элементы, которые без js бессмысленны. Раньше это делалось двумя вариантами
(с небольшими вариациями):

1. генерируя зависящее от js содержимое в самом js, соответственно человек без js и не получит этого содержимого

2. скрывая в css содержимое, которое зависит от js, а потом по window.onload делать это содержимое видимым.

На самом деле, второй вариант в самом оптимальном виде выглядел так: в css прописывалось по умолчанию "сокрытие" содержимого <var>display:none</var> или ещё как и писался селектор навроде #js_enabled, в правилах которого это самое содержимое делалось <var>display: block</var>, и по <var>window.onload</var> к body применялся этот самый id <var>js_enabled</var>. 

Выходило дёшево и сердито - по умолчанию всё скрыто, после загрузки документа js (буде таковой включен), делал всё видимым.

Оба метода далеки от идеальности по многим причинам. И одна из главных проблем - необходимость дожидаться полной загрузки документа - там может быть множество замещаемых элементов (например, <var>img</var>), полной загрузки которых будет ждать <var>window.onload</var>.

Да, проблему ожидания загрузки замещаемых элементов событием <var>window.onload</var>
можно решить, но остаётся ещё много проблем, например, занятость id/className-атрибутов у body, но это не решает самой главной проблемы существующих методов - увеличения связности компонентов документа. Порой сидишь и рисуешь связи между css/js/особенностями браузеров/серверным кодом, чтобы понять, откуда то или иное вылазит.

Я же предлагаю совершенно новый метод (во всяком случае, я долго искал и не нашёл ни одного похожего применения).

Как я уже говорил, несмотря на то, что псевдопротокол <var>javascript:</var> не описан в стандартах, он функционирует во всех браузерах. Возвращённое после выполнения js-кода значение и будет являться содержимым "документа". Для иллюстрации предлагаю описать в html ссылку вида

	<a href="javascript:'new content'">link</a>

и нажать на неё. Как я уже упоминал в статье про события, браузер выполнит "переход" на "страницу", содержимое которой будет определено возвращённым значением.

На этом и основан мой метод. Предположим, что у нас есть блок <var>#js_control</var>, который целиком и полностью зависит от js, и без js не нужный.

	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	<head>
	<title>test.</title>
	<style type="text/css">
		/*в этой таблице стилей описывается вид страницы без js */
		#js_control { display: none; }
	</style>
	<link rel="stylesheet" type="text/css" href="javascript:'
		/*вид страницы с js*/
		#js_control { display: block; }
	'"/>
	</head>
	<body>
		<div id="js_control">
		<input type="text" id="apply rule" />
		<input type="submit" onclick="someFunction()" />
		</div>
		<p>text</p>
	</body>
	</html>

В общем, получается, что в обычной таблице стилей мы описываем "умолчальное" состояние страницы, во второй, _необычной_ таблице стилей описываем css, который будет применён при включенном js. Необычна она тем, что css-код, который я в ней написал, является строкой. Когда браузер запросит таблицу стилей по её href'у, он выполнит javascript-код, который, в свою очередь вернёт строку, в которой я описал css-код. Браузер применит этот css-код к документу.

Таким образом, очень удобно происходит "разделение" - если js выключен, вторая таблица стилей не применится.

Браузеры, в которых я это проверял: IE4/5/5.5/6/7b3, Opera5/8/9, FF1/1.5.

Кстати, только что проверил, opera8/8.5/9, FF1.5, IE4/5/5.5/6 - можно подключать и внешние таблицы стилей:

	<link rel="stylesheet" type="text/css" href="javascript:'@import url(http://host.com/js-enabled.css);'" />

К сожалению, IE4 и FF не понимают иной нотации, кроме <var>@import url(someurl)</var>, причём если написать в кавычках, FF начинает кидаться эксепшнами странными, даже если всё нормально сэкранировать. Если же писать относительный урл, то опять же FF не подгружает почему-то, но как мне кажется, это всё настолько недокументировано, что можно простить странное поведение :)

В общем, получается такая ситуация: если правил немного и в них мало что нужно экранировать (да-да, весь css-код в этом случае суть строка), например, если мало правил с <var>content</var>, то удобнее прописать правила прямо в такой таблице стилей. Если же правил много или не хочется ничего экранировать, то проще написать последним методом, правда, придётся писать абсолютный адрес внешней таблицы стилей.