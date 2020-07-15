﻿#Область ОбработчикиСобытийФормы

// Обработка события модуля формы ПриОткрытии
//		
Процедура ПриОткрытии(Форма, Отказ) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемыПТБ.ПланировщикДанные") Тогда
		ОбщийМодульКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ПланировщикДанныеКлиент");
		ОбщийМодульКлиент.ПриОткрытии(Форма, Отказ);
	КонецЕсли;
	
КонецПроцедуры

// Обработка события модуля формы ОбработкаОповещения
//		
Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемыПТБ.ПланировщикДанные") Тогда
		ОбщийМодульКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ПланировщикДанныеКлиент");
		ОбщийМодульКлиент.ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник);
	КонецЕсли;
	
КонецПроцедуры

// Обработка события модуля формы ПередЗакрытием
//		
Процедура ПередЗакрытием(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемыПТБ.ПланировщикДанные") Тогда
		ОбщийМодульКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ПланировщикДанныеКлиент");
		ОбщийМодульКлиент.ПередЗакрытием(Форма, Отказ, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// Обработка события модуля формы ПриЗакрытии
//		
Процедура ПриЗакрытии(Форма) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемыПТБ.ПланировщикДанные") Тогда
		ОбщийМодульКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ПланировщикДанныеКлиент");
		ОбщийМодульКлиент.ПриЗакрытии(Форма);
	КонецЕсли;
	
КонецПроцедуры

// Обработка события модуля формы ОбработкаЗаписиНового
//		
Процедура ОбработкаЗаписиНового(Форма, НовыйОбъект, Источник, СтандартнаяОбработка) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемыПТБ.ПланировщикДанные") Тогда
		ОбщийМодульКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ПланировщикДанныеКлиент");
		ОбщийМодульКлиент.ОбработкаЗаписиНового(Форма, НовыйОбъект, Источник, СтандартнаяОбработка);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийДокументHTMLПланировщик

// Событие при выборе любой пустой части поля планировщика
//
// Параметры:
//	Форма - Тип: УправляемаяФорма
//	ДатаНачала - Тип: Дата. Начало выбранного периода
//	ДатаОкончания - Тип: Дата. Окончание выбранного периода
//	ВесьДень - Тип: Булево. Признак что выбрана часть "Весь день"
//	ОписаниеОповещения - Тип: ОписаниеОповещения. Оповещение при завершении обработки выбора
//		если в результате обработки вернуть пустое значение, обновление выполнено не будет
//
Процедура ПланировщикВыбор(Форма, ДатаНачала, ДатаОкончания, ВесьДень) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемыПТБ.ПланировщикДанные") Тогда
		ОбщийМодульКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ПланировщикДанныеКлиент");
		ОбщийМодульКлиент.ПланировщикВыбор(Форма, ДатаНачала, ДатаОкончания, ВесьДень);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПланировщикСобытиеВыбор(Форма, ДанныеСобытия) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемыПТБ.ПланировщикДанные") Тогда
		ОбщийМодульКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ПланировщикДанныеКлиент");
		ОбщийМодульКлиент.ПланировщикСобытиеВыбор(Форма, ДанныеСобытия);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПланировщикСобытиеПриОкончанииПеретаскивания(Форма, ДанныеСобытия, КоличествоДней, КоличествоМинут, ВесьДень) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемыПТБ.ПланировщикДанные") Тогда
		ОбщийМодульКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ПланировщикДанныеКлиент");
		ОбщийМодульКлиент.ПланировщикСобытиеПриОкончанииПеретаскивания(Форма, ДанныеСобытия, КоличествоДней, КоличествоМинут, ВесьДень);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПланировщикСобытиеПриОкончанииИзменениеРазмера(Форма, ДанныеСобытия, КоличествоДней, КоличествоМинут) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемыПТБ.ПланировщикДанные") Тогда
		ОбщийМодульКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ПланировщикДанныеКлиент");
		ОбщийМодульКлиент.ПланировщикСобытиеПриОкончанииИзменениеРазмера(Форма, ДанныеСобытия, КоличествоДней, КоличествоМинут);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

