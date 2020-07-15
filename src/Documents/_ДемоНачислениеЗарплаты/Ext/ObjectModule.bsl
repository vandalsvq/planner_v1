﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// См. описание в комментарии к одноименной процедуре в модуле УправлениеДоступом.
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	// Логика ограничения следующая:
	// объект доступен, если доступен
	// Ответственный и ВСЕ физические лица
	
	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.ЗначениеДоступа = Ответственный;
	
	Для Каждого СтрокаТаблицы Из Зарплата Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Физлицо) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТаб = Таблица.Добавить();
		СтрокаТаб.ЗначениеДоступа = СтрокаТаблицы.Физлицо;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ДанныеЗаполнения = Неопределено Тогда // Ввод нового.
		_ДемоСтандартныеПодсистемы.ПриВводеНовогоЗаполнитьОрганизацию(ЭтотОбъект);
		ПериодРегистрации = НачалоМесяца(ТекущаяДатаСеанса());
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	СформироватьДвиженияНачислений();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьДвиженияНачислений()
	
	Движения._ДемоОсновныеНачисления.Записывать = Истина;
	
	Для Каждого Строка Из Зарплата Цикл
		Движение = Движения._ДемоОсновныеНачисления.Добавить();
		
		Движение.ПериодРегистрации = ПериодРегистрации;
		
		Движение.ПериодДействияНачало = НачалоМесяца(ПериодРегистрации);
		Движение.ПериодДействияКонец  = КонецМесяца(ПериодРегистрации);
		
		Движение.ФизическоеЛицо = Строка.ФизЛицо;
		Движение.Организация    = Организация;
		
		Движение.ВидРасчета = ПланыВидовРасчета._ДемоОсновныеНачисления.ОкладПоДням;
		Движение.Результат  = Строка.Сумма;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли