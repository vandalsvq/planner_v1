﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СобытиеЖурналаРегистрацииПодключениеКонечнойТочки = ОбменСообщениямиВнутренний.СобытиеЖурналаРегистрацииПодключениеКонечнойТочки();
	
	СтандартныеПодсистемыСервер.УстановитьОтображениеЗаголовковГрупп(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ТекстПредупреждения = НСтр("ru = 'Отменить подключение конечной точки?'");
	Оповещение = Новый ОписаниеОповещения("ПодключитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ТекстПредупреждения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодключитьКонечнуюТочку(Команда)
	
	ПодключитьИЗакрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодключитьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Состояние(НСтр("ru = 'Выполняется подключение конечной точки. Пожалуйста, подождите...'"));
	
	Отказ = Ложь;
	ОшибкаЗаполнения = Ложь;
	
	ПодключитьКонечнуюТочкуНаСервере(Отказ, ОшибкаЗаполнения);
	
	Если ОшибкаЗаполнения Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		
		НСтрока = НСтр("ru = 'При подключении конечной точки возникли ошибки.
		|Перейти в журнал регистрации?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьЖурналРегистрации", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтрока, РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Нет);
		Возврат;
	КонецЕсли;
	
	Оповестить(ОбменСообщениямиКлиент.ИмяСобытияДобавленаКонечнаяТочка());
	
	ПоказатьОповещениеПользователя(,,НСтр("ru = 'Подключение конечной точки успешно завершено.'"));
	
	Модифицированность = Ложь;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЖурналРегистрации(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Отбор = Новый Структура;
		Отбор.Вставить("СобытиеЖурналаРегистрации", СобытиеЖурналаРегистрацииПодключениеКонечнойТочки);
		ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", Отбор, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодключитьКонечнуюТочкуНаСервере(Отказ, ОшибкаЗаполнения)
	
	Если Не ПроверитьЗаполнение() Тогда
		ОшибкаЗаполнения = Истина;
		Возврат;
	КонецЕсли;
	
	ОбменСообщениями.ПодключитьКонечнуюТочку(
		Отказ,
		НастройкиОтправителяWSURLВебСервиса,
		НастройкиОтправителяWSИмяПользователя,
		НастройкиОтправителяWSПароль,
		НастройкиПолучателяWSURLВебСервиса,
		НастройкиПолучателяWSИмяПользователя,
		НастройкиПолучателяWSПароль);
	
КонецПроцедуры

#КонецОбласти
