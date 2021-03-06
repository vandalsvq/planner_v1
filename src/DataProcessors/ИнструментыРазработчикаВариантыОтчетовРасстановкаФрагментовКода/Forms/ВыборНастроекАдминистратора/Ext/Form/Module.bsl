﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "НастройкиАдминистратора");
	
	ИндексВИсходнойКоллекции = 0;
	Для Каждого ЭлементСписка Из НастройкиАдминистратора Цикл
		НастройкаАдминистратора = ЭлементСписка.Значение;
		СтрокаТаблицы = НастройкиАдминистратораВыбор.Добавить();
		СтрокаТаблицы.ИмяОтчета = НастройкаАдминистратора.ИмяОтчета;
		СтрокаТаблицы.КлючВарианта = НастройкаАдминистратора.КлючВарианта;
		СтрокаТаблицы.ПредставлениеНастройки = ЭлементСписка.Представление;
		СтрокаТаблицы.Использование = ЭлементСписка.Пометка;
		СтрокаТаблицы.ИндексВИсходнойКоллекции = ИндексВИсходнойКоллекции;
		ИндексВИсходнойКоллекции = ИндексВИсходнойКоллекции + 1;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ НастройкиАдминистратораВыбор

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройкиАдминистратораВыбор

&НаКлиенте
Процедура НастройкиАдминистратораВыборПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура НастройкиАдминистратораВыборПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура НастройкиАдминистратораВыборПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура НастройкиАдминистратораВыборВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	СтрокаТаблицы = НастройкиАдминистратораВыбор.НайтиПоИдентификатору(ВыбраннаяСтрока);
	СтрокаТаблицы.Использование = Не СтрокаТаблицы.Использование;
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	Для Каждого СтрокаТаблицы Из НастройкиАдминистратораВыбор Цикл
		НастройкиАдминистратора[СтрокаТаблицы.ИндексВИсходнойКоллекции].Пометка = СтрокаТаблицы.Использование;
	КонецЦикла;
	Закрыть(НастройкиАдминистратора);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	Для Каждого СтрокаТаблицы Из НастройкиАдминистратораВыбор Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	Для Каждого СтрокаТаблицы Из НастройкиАдминистратораВыбор Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
