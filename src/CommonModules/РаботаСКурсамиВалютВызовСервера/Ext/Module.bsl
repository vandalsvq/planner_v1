﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Валюты"
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Загружает информацию о курсе валюты.
//
Функция ЗагрузитьКурсВалютыИзФайла(Валюта, ПутьКФайлу, НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки) Экспорт
	Возврат РаботаСКурсамиВалют.ЗагрузитьКурсВалютыИзФайла(Валюта, ПутьКФайлу, НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки);
КонецФункции

// Проверяет актуальность курсов всех валют.
//
Функция КурсыАктуальны() Экспорт
	Возврат РаботаСКурсамиВалют.КурсыАктуальны();
КонецФункции

#КонецОбласти
