﻿
Процедура ПередЗаписью(Отказ)
	ЭтотОбъект.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='%1 (%2,%3,%4)'"),
		ЭтотОбъект.ЦветФонаHex,
		Строка(ЭтотОбъект.ЦветФонаКрасный),
		Строка(ЭтотОбъект.ЦветФонаЗеленый),
		Строка(ЭтотОбъект.ЦветФонаСиний));
КонецПроцедуры
