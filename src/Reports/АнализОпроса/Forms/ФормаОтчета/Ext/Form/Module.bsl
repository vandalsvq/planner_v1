﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВидОтчета = "АнализОтветов";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаОтчетаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Расшифровка.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный") Тогда
		ОткрытьФорму("Отчет.АнализОпроса.Форма.РасшифровкаТабличныхВопросов",Новый Структура("Опрос,ВопросШаблонаАнкеты,ПолныйКод,НаименованиеОпроса,ДатаОпроса",
		                                                                                      Опрос,Расшифровка.ВопросШаблона,Расшифровка.ПолныйКод,НаименованиеОпроса,ДатаОпроса),ЭтотОбъект);
	Иначе
		ОткрытьФорму("Отчет.АнализОпроса.Форма.РасшифровкаПростыхОтветов",Новый Структура("Опрос,ВопросШаблонаАнкеты,ВариантОтчета,ПолныйКод,НаименованиеОпроса,ДатаОпроса",
		                                                                                   Опрос,Расшифровка.ВопросШаблона,"Респонденты",Расшифровка.ПолныйКод,НаименованиеОпроса,ДатаОпроса),ЭтотОбъект);	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СформироватьОтчет();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьОтчет()
	
	РеквизитФормыВЗначение("Отчет").СформироватьОтчет(ТаблицаОтчета, Опрос, ВидОтчета);
	РеквизитыОпрос     = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Опрос,"Наименование, Дата");
	НаименованиеОпроса = РеквизитыОпрос.Наименование;
	ДатаОпроса         = РеквизитыОпрос.Дата;
	
КонецПроцедуры

#КонецОбласти
