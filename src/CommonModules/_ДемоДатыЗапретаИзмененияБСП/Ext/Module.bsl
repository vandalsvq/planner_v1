﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Даты запрета изменения".
// Настройка переопределяемого модуля в конфигурации "Демо: БСП".
// 
// Реализация процедур и функций модуля ДатыЗапретаИзмененияПереопределяемый
// для поддержки библиотечного подхода разработки.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается из переопределяемого модуля
Процедура НастройкаИнтерфейса(Знач НастройкиРаботыИнтерфейса) Экспорт
	
	НастройкиРаботыИнтерфейса.ИспользоватьВнешнихПользователей = Истина;
	
КонецПроцедуры

// Вызывается из переопределяемого модуля
Процедура ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(Знач ИсточникиДанных) Экспорт
	
	// Данные(Таблица, ПолеДаты, Раздел, ПолеОбъекта)
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ._ДемоОприходованиеТоваров", "Дата", "_ДемоСкладскойУчет", "МестоХранения");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ._ДемоСписаниеТоваров",      "Дата", "_ДемоСкладскойУчет", "МестоХранения");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ._ДемоПеремещениеТоваров",   "Дата", "_ДемоСкладскойУчет", "МестоХраненияИсточник");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ._ДемоПеремещениеТоваров",   "Дата", "_ДемоСкладскойУчет", "МестоХраненияПриемник");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ._ДемоЗаказПокупателя",      "Дата", "_ДемоТорговля",      "Партнер.ГруппаДоступа");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ._ДемоПоступлениеТоваров",   "Дата", "_ДемоТорговля",      "Контрагент.Партнер.ГруппаДоступа");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ._ДемоПоступлениеТоваров",   "Дата", "_ДемоСкладскойУчет", "МестоХранения");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ._ДемоРеализацияТоваров",    "Дата", "_ДемоТорговля",      "Контрагент.Партнер.ГруппаДоступа");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ._ДемоРеализацияТоваров",    "Дата", "_ДемоСкладскойУчет", "МестоХранения");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрСведений._ДемоЗаведующиеМестамиХранения", "Период", "_ДемоСкладскойУчет", "МестоХранения");
	
КонецПроцедуры

// Вызывается из переопределяемого модуля
Процедура ПередПроверкойЗапретаИзменения(Объект, СтандартнаяОбработка, УзелПланаОбмена, СообщитьОЗапрете) Экспорт
	
	Если Объект.Метаданные().ПолноеИмя() = "Документ._ДемоЗаказПокупателя" Тогда
		СтараяВерсияЗаказЗакрыт = (ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Ссылка, "СтатусЗаказа") = Перечисления._ДемоСтатусыЗаказовПокупателей.Закрыт);
		Если (СтараяВерсияЗаказЗакрыт = Ложь) И Не (Объект.СтатусЗаказа = Перечисления._ДемоСтатусыЗаказовПокупателей.Закрыт) Тогда
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
