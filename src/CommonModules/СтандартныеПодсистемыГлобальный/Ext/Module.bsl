﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Продолжает завершение в режиме интерактивного взаимодействия с пользователем
// после установки Отказ = Истина.
//
Процедура ОбработчикОжиданияИнтерактивнаяОбработкаПередЗавершениемРаботыСистемы() Экспорт
	
	СтандартныеПодсистемыКлиент.НачатьИнтерактивнуюОбработкуПередЗавершениемРаботыСистемы();
	
КонецПроцедуры

// Продолжает запуск в режиме интерактивного взаимодействия с пользователем.
Процедура ОбработчикОжиданияПриНачалеРаботыСистемы() Экспорт
	
	СтандартныеПодсистемыКлиент.ПриНачалеРаботыСистемы(, Ложь);
	
КонецПроцедуры

#КонецОбласти
