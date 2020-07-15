﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Клиентские процедуры и функции общего назначения.
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает Истина, если это веб клиент в Mac OS.
Функция ЭтоВебКлиентПодMacOS() Экспорт
	
#Если Не ВебКлиент Тогда
	Возврат Ложь;  // только в веб клиенте этот код работает		
#КонецЕсли
	
	СистемнаяИнфо = Новый СистемнаяИнформация;
	Если Найти(СистемнаяИнфо.ИнформацияПрограммыПросмотра, "Macintosh") <> 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Возвращает тип платформы клиента.
Функция ТипПлатформыКлиента() Экспорт
	СистемнаяИнфо = Новый СистемнаяИнформация;
	Возврат СистемнаяИнфо.ТипПлатформы;
КонецФункции	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция получает цвет стиля по имени элемента стиля
//
// Параметры:
// ИмяЦветаСтиля - Строка -  Имя элемента стиля.
//
// Возвращаемое значение:
// Цвет.
//
Функция ЦветСтиля(ИмяЦветаСтиля) Экспорт
	
	Возврат ОбщегоНазначенияВызовСервера.ЦветСтиля(ИмяЦветаСтиля);
	
КонецФункции

// Функция получает шрифт стиля по имени элемента стиля.
//
// Параметры:
// ИмяШрифтаСтиля - Строка - Имя шрифта стиля.
//
// Возвращаемое значение:
// Шрифт.
//
Функция ШрифтСтиля(ИмяШрифтаСтиля) Экспорт
	
	Возврат ОбщегоНазначенияВызовСервера.ШрифтСтиля(ИмяШрифтаСтиля);
	
КонецФункции

#КонецОбласти
