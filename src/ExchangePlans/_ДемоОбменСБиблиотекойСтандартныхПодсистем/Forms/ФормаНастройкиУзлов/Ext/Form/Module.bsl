﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИменаРеквизитов = СтруктураСоответствияНастройкиОтборовРеквизитамФормы();
	ИменаРеквизитовБазыКорреспондента = СтруктураСоответствияНастройкиОтборовКорреспондентаРеквизитамФормы();
	
	ОбменДаннымиСервер.ФормаНастройкиУзловПриСозданииНаСервере(ЭтотОбъект, Отказ);
	
	ПланыОбмена._ДемоОбменСБиблиотекойСтандартныхПодсистем.ОпределитьВариантСинхронизацииДокументов(ВариантСинхронизацииДокументов, ЭтотОбъект);
	ПланыОбмена._ДемоОбменСБиблиотекойСтандартныхПодсистем.ОпределитьВариантСинхронизацииСправочников(ВариантСинхронизацииСправочников, ЭтотОбъект);
	
	ИнициализироватьРежимыСинхронизации();
	
	ПолучитьОписаниеКонтекста();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РежимСинхронизацииОрганизацийЭтойПрограммыПриИзмененииЗначения();
	РежимСинхронизацииОрганизацийКорреспондентаПриИзмененииЗначения();
	РежимСинхронизацииПодразделенийПриИзмененииЗначения();
	РежимСинхронизацииСкладовПриИзмененииЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РежимСинхронизацииОрганизацийЭтойПрограммыПриИзменении(Элемент)
	РежимСинхронизацииОрганизацийЭтойПрограммыПриИзмененииЗначения();
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииОрганизацийКорреспондентаПриИзменении(Элемент)
	РежимСинхронизацииОрганизацийКорреспондентаПриИзмененииЗначения();
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииСкладовПриИзменении(Элемент)
	РежимСинхронизацииСкладовПриИзмененииЗначения();
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииПодразделенийПриИзменении(Элемент)
	РежимСинхронизацииПодразделенийПриИзмененииЗначения();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьИЗакрытьНаСервере();
	
	ОбменДаннымиКлиент.ФормаНастройкиУзловКомандаЗакрытьФорму(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИЗакрытьНаСервере()
	
	ИспользоватьОтборПоОрганизациямЭтойПрограммы = (РежимСинхронизацииОрганизацийЭтойПрограммы = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям");
	ИспользоватьОтборПоОрганизациямКорреспондента = (РежимСинхронизацииОрганизацийКорреспондента = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям");
	ИспользоватьОтборПоПодразделениям = (РежимСинхронизацииПодразделений = "СинхронизироватьДанныеТолькоПоВыбраннымПодразделениям");
	ИспользоватьОтборПоСкладам = (РежимСинхронизацииСкладов = "СинхронизироватьДанныеТолькоПоВыбраннымСкладам");
	
	ПланыОбмена._ДемоОбменСБиблиотекойСтандартныхПодсистем.ОпределитьРежимыВыгрузкиДокументов(ВариантСинхронизацииДокументов, ЭтотОбъект);
	ПланыОбмена._ДемоОбменСБиблиотекойСтандартныхПодсистем.ОпределитьРежимыВыгрузкиСправочников(ВариантСинхронизацииСправочников, ЭтотОбъект);
	
	ПолучитьОписаниеКонтекста();
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВсеОрганизацииЭтойПрограммы(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Истина, "ОрганизацииЭтойПрограммы");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьВсеОрганизацииЭтойПрограммы(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Ложь, "ОрганизацииЭтойПрограммы");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьВсеОрганизацииКорреспондента(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Ложь, "ОрганизацииКорреспондента");
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВсеОрганизацииКорреспондента(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Истина, "ОрганизацииКорреспондента");
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВсеПодразделения(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Истина, "Подразделения");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьВсеПодразделения(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Ложь, "Подразделения");
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВсеСклады(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Истина, "Склады");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьВсеСклады(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Ложь, "Склады");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РежимСинхронизацииОрганизацийЭтойПрограммыПриИзмененииЗначения()
	
	Элементы.ОрганизацииЭтойПрограммы.Доступность =
		(РежимСинхронизацииОрганизацийЭтойПрограммы = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям")
	;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииОрганизацийКорреспондентаПриИзмененииЗначения()
	
	Элементы.ОрганизацииКорреспондента.Доступность =
		(РежимСинхронизацииОрганизацийКорреспондента = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям")
	;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииПодразделенийПриИзмененииЗначения()
	
	Элементы.Подразделения.Доступность =
		(РежимСинхронизацииПодразделений = "СинхронизироватьДанныеТолькоПоВыбраннымПодразделениям")
	;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииСкладовПриИзмененииЗначения()
	
	Элементы.Склады.Доступность =
		(РежимСинхронизацииСкладов = "СинхронизироватьДанныеТолькоПоВыбраннымСкладам")
	;
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОтключитьВсеЭлементыВТаблице(Включить, ИмяТаблицы)
	
	Для Каждого ЭлементКоллекции Из ЭтотОбъект[ИмяТаблицы] Цикл
		
		ЭлементКоллекции.Использовать = Включить;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьОписаниеКонтекста()
	
	// дата начала выгрузки документов
	Если ЗначениеЗаполнено(ДатаНачалаВыгрузкиДокументов) Тогда
		ДатаНачалаВыгрузкиДокументовОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Документы будут синхронизироваться, начиная с %1'"),
			Формат(ДатаНачалаВыгрузкиДокументов, "ДЛФ=DD"));
	Иначе
		ДатаНачалаВыгрузкиДокументовОписание = НСтр("ru = 'Данные будут синхронизироваться за весь период ведения учета'");
	КонецЕсли;
	
	Если Не ИспользоватьОтборПоОрганизациямЭтойПрограммы И Не ИспользоватьОтборПоОрганизациямКорреспондента Тогда
		
		ОрганизацииОписание = НСтр("ru = 'Данные будут синхронизироваться по всем организациям.'");
		
	Иначе
		
		// отбор по Организациям этой программы
		Если ИспользоватьОтборПоОрганизациямЭтойПрограммы Тогда
			ОрганизацииЭтойПрограммыОписание = НСтр("ru = 'Из этой программы данные будут отправляться только по организациям:'") + Символы.ПС + ИспользуемыеЭлементы("ОрганизацииЭтойПрограммы");
		Иначе
			ОрганизацииЭтойПрограммыОписание = НСтр("ru = 'Из этой программы данные будут отправляться по всем организациям.'");
		КонецЕсли;
		
		// отбор по Организациям корреспондента
		Если ИспользоватьОтборПоОрганизациямКорреспондента Тогда
			ОрганизацииКорреспондентаОписание = НСтр("ru = 'Из другой программы данные будут отправляться только по организациям:'") + Символы.ПС + ИспользуемыеЭлементы("ОрганизацииКорреспондента");
		Иначе
			ОрганизацииКорреспондентаОписание = НСтр("ru = 'Из другой программы данные будут отправляться по всем организациям.'");
		КонецЕсли;
		
		ОрганизацииОписание = ОрганизацииЭтойПрограммыОписание + Символы.ПС + ОрганизацииКорреспондентаОписание;
		
	КонецЕсли;
	
	// отбор по Складам
	Если ИспользоватьОтборПоСкладам Тогда
		СкладыОписание = НСтр("ru = 'Данные будут синхронизироваться только по складам:'") + Символы.ПС + ИспользуемыеЭлементы("Склады");
	Иначе
		СкладыОписание = НСтр("ru = 'Данные будут синхронизироваться по всем складам.'");
	КонецЕсли;
	
	// отбор по Подразделениям
	Если ИспользоватьОтборПоПодразделениям Тогда
		ПодразделенияОписание = НСтр("ru = 'Данные будут синхронизироваться только по подразделениям:'") + Символы.ПС + ИспользуемыеЭлементы("Подразделения");
	Иначе
		ПодразделенияОписание = НСтр("ru = 'Данные будут синхронизироваться по всем подразделениям.'");
	КонецЕсли;
	
	ЭтотОбъект.ОписаниеКонтекста = (""
		+ ДатаНачалаВыгрузкиДокументовОписание
		+ Символы.ПС
		+ ОрганизацииОписание
		+ Символы.ПС
		+ СкладыОписание
		+ Символы.ПС
		+ ПодразделенияОписание);
		
КонецПроцедуры

&НаСервере
Функция ИспользуемыеЭлементы(ИмяТаблицы)
	
	Возврат СтроковыеФункцииКлиентСервер.СтрокаИзМассиваПодстрок(
			ЭтотОбъект[ИмяТаблицы].Выгрузить(Новый Структура("Использовать", Истина)).ВыгрузитьКолонку("Представление"), ", ");
	
КонецФункции

&НаСервере
Функция СтруктураСоответствияНастройкиОтборовРеквизитамФормы()
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ИспользоватьОтборПоОрганизациям",         "ИспользоватьОтборПоОрганизациямЭтойПрограммы");
	СтруктураНастроек.Вставить("Организации",                             "ОрганизацииЭтойПрограммы");
	
	Возврат СтруктураНастроек;
	
КонецФункции

&НаСервере
Функция СтруктураСоответствияНастройкиОтборовКорреспондентаРеквизитамФормы()
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ИспользоватьОтборПоОрганизациям", "ИспользоватьОтборПоОрганизациямКорреспондента");
	СтруктураНастроек.Вставить("Организации",                     "ОрганизацииКорреспондента");
	
	Возврат СтруктураНастроек;
	
КонецФункции

Процедура ИнициализироватьРежимыСинхронизации()
	
	РежимСинхронизацииОрганизацийЭтойПрограммы = ?(ИспользоватьОтборПоОрганизациямЭтойПрограммы,
		"СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям", "СинхронизироватьДанныеПоВсемОрганизациям");
		
	РежимСинхронизацииОрганизацийКорреспондента = ?(ИспользоватьОтборПоОрганизациямКорреспондента,
		"СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям", "СинхронизироватьДанныеПоВсемОрганизациям");
		
	РежимСинхронизацииПодразделений = ?(ИспользоватьОтборПоПодразделениям,
		"СинхронизироватьДанныеТолькоПоВыбраннымПодразделениям", "СинхронизироватьДанныеПоВсемПодразделениям");
		
	РежимСинхронизацииСкладов = ?(ИспользоватьОтборПоСкладам,
		"СинхронизироватьДанныеТолькоПоВыбраннымСкладам", "СинхронизироватьДанныеПоВсемСкладам");
	
КонецПроцедуры

#КонецОбласти
