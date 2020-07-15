﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен сообщениями".
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Выполняет отправку и получение сообщений системы
//
// Параметры:
//  Отказ - Булево. Флаг отказа. Поднимается в случае возникновения ошибок в процессе выполнения операции.
//
Процедура ОтправитьИПолучитьСообщения(Отказ) Экспорт
	
	ОбменДаннымиСервер.ПроверитьВозможностьВыполненияОбменов();
	
	ОбменСообщениямиВнутренний.ОтправитьИПолучитьСообщения(Отказ);
	
КонецПроцедуры

#КонецОбласти
