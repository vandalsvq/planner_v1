﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// Обработчики выгрузки конвертации БСП 2.1.2 --> БСП 2.2.2 {c2de3602-78fd-11e3-900e-005056c00000}                                                                                                   
// 
// Данный модуль содержит экспортные процедуры обработчиков событий конвертации 
// и предназначен для отладки правил обмена. После отладки рекомендуется
// скопировать текст модуля в буфер обмена и импортировать его в базу
// "Конвертация данных".
//
////////////////////////////////////////////////////////////////////////////////
// ИСПОЛЬЗУЕМЫЕ СОКРАЩЕНИЯ ИМЕН ПЕРЕМЕННЫХ (АББРЕВИАТУРЫ)
//
//  ПКО  - правило конвертации объектов
//  ПКС  - правило конвертации свойств объектов
//  ПКГС - правило конвертации группы свойств объектов
//  ПВД  - правило выгрузки данных
//  ПОД  - правило очистки данных

////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ОБРАБОТКИ
// Данный раздел изменять запрещено.

Перем Параметры;
Перем Алгоритмы;
Перем Запросы;
Перем УзелДляОбмена;
Перем ОбщиеПроцедурыФункции;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОНВЕРТАЦИИ (ГЛОБАЛЬНЫЕ)
// В данном разделе разрешено изменять реализацию процедур.

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОНВЕРТАЦИИ ОБЪЕКТОВ
// В данном разделе разрешено изменять реализацию процедур.

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОНВЕРТАЦИИ СВОЙСТВ ОБЪЕКТОВ
// В данном разделе разрешено изменять реализацию процедур.

Процедура ПКС__ДемоЗаказПокупателя_Номер_ПриВыгрузкеСвойства_18_20(ФайлОбмена, Источник, Приемник, ВходящиеДанные, ИсходящиеДанные,
	ПКС, ПКО, ОбъектКоллекции, Отказ, Значение, КлючИЗначение, ВидСубконто,
	Субконто, Пусто, ИмяПКО, ПКОСвойств,УзелСвойства, УзелКоллекцииСвойств,
	ИмяПКОВидСубконто, ВыгрузитьОбъект) Экспорт

	// В различных версиях имеет разный тип и источник, передаем через параметр
	Если Метаданные.Документы._ДемоЗаказПокупателя.Реквизиты.Найти("СтатусЗаказа") = Неопределено Тогда
		// Младшая версия
		Если Источник.ЗаказЗакрыт Тогда
			Значение = "Закрыт";
		Иначе
			Значение = "НеСогласован";
		КонецЕсли;
	Иначе
		// Старшая версия
		ТекущийСтатусЗаказа = Источник.СтатусЗаказа;
		Если ТекущийСтатусЗаказа.Пустая() Тогда
			Значение = "НеСогласован";
		Иначе
			ИндексПеречисления = Перечисления["_ДемоСтатусыЗаказовПокупателей"].Индекс(ТекущийСтатусЗаказа);
			Значение = ТекущийСтатусЗаказа.Метаданные().ЗначенияПеречисления.Получить(ИндексПеречисления).Имя;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПКС_Организации_КонтактнаяИнформация_ЗначенияПолей_ПриВыгрузкеСвойства_10_11(ФайлОбмена, Источник, Приемник, ВходящиеДанные, ИсходящиеДанные,
	ПКС, ПКО, ОбъектКоллекции, Отказ, Значение, КлючИЗначение, ВидСубконто,
	Субконто, Пусто, ИмяПКО, ПКОСвойств,УзелСвойства, УзелКоллекцииСвойств,
	ИмяПКОВидСубконто, ВыгрузитьОбъект) Экспорт

	ВерсияБСП = СтандартныеПодсистемыСервер.ВерсияБиблиотеки();
	Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияБСП, "2.1.4.1") >= 0 Тогда
		
		МодульУправлениеКонтактнойИнформацией = Вычислить("УправлениеКонтактнойИнформацией");
		Значение = МодульУправлениеКонтактнойИнформацией.ПредыдущийФорматКонтактнойИнформацииXML(Значение, Истина);
		
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОНВЕРТАЦИИ ГРУПП СВОЙСТВ ОБЪЕКТОВ
// В данном разделе разрешено изменять реализацию процедур.

Процедура ПКГС_НаборыДополнительныхРеквизитовИСведений_ДополнительныеРеквизиты_ПередОбработкойВыгрузки_5_39(ФайлОбмена, Источник, Приемник, ВходящиеДанные, ИсходящиеДанные, ПКО,
	ПКГС, Отказ, КоллекцияОбъектов, НеЗамещать, УзелКоллекцииСвойств, НеОчищать) Экспорт

	Если Источник.ЭтоГруппа Тогда
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

Процедура ПКГС_НаборыДополнительныхРеквизитовИСведений_ДополнительныеСведения_ПередОбработкойВыгрузки_7_39(ФайлОбмена, Источник, Приемник, ВходящиеДанные, ИсходящиеДанные, ПКО,
	ПКГС, Отказ, КоллекцияОбъектов, НеЗамещать, УзелКоллекцииСвойств, НеОчищать) Экспорт

	Если Источник.ЭтоГруппа Тогда
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ВЫГРУЗКИ ДАННЫХ
// В данном разделе разрешено изменять реализацию процедур.

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОЧИСТКИ ДАННЫХ
// В данном разделе разрешено изменять реализацию процедур.

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ПАРАМЕТРОВ
// В данном разделе разрешено изменять реализацию процедур.

////////////////////////////////////////////////////////////////////////////////
// АЛГОРИТМЫ
// Данный раздел разрешено изменять.
// Также допустимо размещать процедуры с алгоритмами в любом из разделов выше.

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
// Данный раздел изменять запрещено.

// Служебная. Инициализирует переменные, необходимые для отладки
//
// Параметры:
//  Владелец - Обработка КонвертацияОбъектовИнформационныхБаз
//
Процедура ПодключитьОбработкуДляОтладки(Владелец) Экспорт

	Параметры            	 = Владелец.Параметры;
	ОбщиеПроцедурыФункции	 = Владелец;
	Запросы              	 = Владелец.Запросы;
	УзелДляОбмена		 	 = Владелец.УзелДляОбмена;

КонецПроцедуры

#КонецЕсли
