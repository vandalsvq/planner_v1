﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК КАНАЛОВ СООБЩЕНИЙ ДЛЯ ВЕРСИИ 1.0.3.4 ИНТЕРФЕЙСА СООБЩЕНИЙ
//  УДАЛЕННОГО АДМИНИСТРИРОВАНИЯ
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает пространство имен версии интерфейса сообщений
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/1cFresh/RemoteAdministration/App/" + Версия();
	
КонецФункции

// Возвращает версию интерфейса сообщений, обслуживаемую обработчиком
Функция Версия() Экспорт
	
	Возврат "1.0.3.3";
	
КонецФункции

// Возвращает базовый тип для сообщений версии
Функция БазовыйТип() Экспорт
	
	Возврат СообщенияВМоделиСервисаПовтИсп.ТипТело();
	
КонецФункции

// Выполняет обработку входящих сообщений модели сервиса
//
// Параметры:
//  Сообщение - ОбъектXDTO, входящее сообщение,
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями, узел плана обмена, соответствующий отправителю сообщения
//  СообщениеОбработано - булево, флаг успешной обработки сообщения. Значение данного параметра необходимо
//    установить равным Истина в том случае, если сообщение было успешно прочитано в данном обработчике
//
Процедура ОбработатьСообщениеМоделиСервиса(Знач Сообщение, Знач Отправитель, СообщениеОбработано) Экспорт
	
	СообщениеОбработано = Истина;
	
	Словарь = СообщенияУдаленногоАдминистрированияИнтерфейс;
	ТипСообщения = Сообщение.Body.Тип();
	
	Если ТипСообщения = Словарь.СообщениеОбновитьПользователя(Пакет()) Тогда
		ОбновитьПользователя(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеПодготовитьОбластьДанных(Пакет()) Тогда
		ПодготовитьОбластьДанных(Сообщение, Отправитель, Ложь);
	ИначеЕсли ТипСообщения = Словарь.СообщениеПодготовитьОбластьДанныхИзВыгрузки(Пакет()) Тогда
		ПодготовитьОбластьДанных(Сообщение, Отправитель, Истина);
	ИначеЕсли ТипСообщения = Словарь.СообщениеУдалитьОбластьДанных(Пакет()) Тогда
		УдалитьОбластьДанных(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеУстановитьДоступКОбластиДанных(Пакет()) Тогда
		УстановитьДоступКОбластиДанных(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеУстановитьКонечнуюТочкуМенеджераСервиса(Пакет()) Тогда
		УстановитьКонечнуюТочкуМенеджераСервиса(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеУстановитьПараметрыИБ(Пакет()) Тогда
		УстановитьПараметрыИБ(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеУстановитьПараметрыОбластиДанных(Пакет()) Тогда
		УстановитьПараметрыОбластиДанных(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеУстановитьПолныеПраваОбластиДанных(Пакет()) Тогда
		УстановитьПолныеПраваОбластиДанных(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеУстановитьПраваПользователяПоУмолчанию(Пакет()) Тогда
		УстановитьПраваПользователяПоУмолчанию(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеУстановитьРейтингОбластейДанных(Пакет()) Тогда
		УстановитьРейтингОбластейДанных(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеПрикрепитьОбластьДанных(Пакет()) Тогда
		ПрикрепитьОбластьДанных(Сообщение, Отправитель);
	Иначе
		СообщениеОбработано = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьПользователя(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	СообщенияУдаленногоАдминистрированияРеализация.ОбновитьПользователя(
		ТелоСообщения.Name,
		ТелоСообщения.FullName,
		ТелоСообщения.StoredPasswordValue,
		ТелоСообщения.UserApplicationID,
		ТелоСообщения.UserServiceID,
		ТелоСообщения.Phone,
		ТелоСообщения.EMail,
		ТелоСообщения.Language);
	
КонецПроцедуры

Процедура ПодготовитьОбластьДанных(Знач Сообщение, Знач Отправитель, Знач ИзВыгрузки)
	
	ТелоСообщения = Сообщение.Body;
	СообщенияУдаленногоАдминистрированияРеализация.ПодготовитьОбластьДанных(
		ТелоСообщения.Zone,
		ИзВыгрузки,
		?(ИзВыгрузки, Неопределено, ТелоСообщения.Kind),
		ТелоСообщения.DataFileId);
	
КонецПроцедуры

Процедура УдалитьОбластьДанных(Сообщение, Отправитель)
	
	СообщенияУдаленногоАдминистрированияРеализация.УдалитьОбластьДанных(Сообщение.Body.Zone);
	
КонецПроцедуры

Процедура УстановитьДоступКОбластиДанных(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	СообщенияУдаленногоАдминистрированияРеализация.УстановитьДоступКОбластиДанных(
		ТелоСообщения.Name,
		ТелоСообщения.StoredPasswordValue,
		ТелоСообщения.UserServiceID,
		ТелоСообщения.Value,
		ТелоСообщения.Language);
	
КонецПроцедуры

Процедура УстановитьКонечнуюТочкуМенеджераСервиса(Знач Сообщение, Знач Отправитель)
	
	СообщенияУдаленногоАдминистрированияРеализация.УстановитьКонечнуюТочкуМенеджераСервиса(Отправитель);
	
КонецПроцедуры

Процедура УстановитьПараметрыИБ(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	Параметры = СериализаторXDTO.ПрочитатьXDTO(ТелоСообщения.Params);
	СообщенияУдаленногоАдминистрированияРеализация.УстановитьПараметрыИБ(Параметры);
	
КонецПроцедуры

Процедура УстановитьПараметрыОбластиДанных(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	СообщенияУдаленногоАдминистрированияРеализация.УстановитьПараметрыОбластиДанных(
		ТелоСообщения.Zone,
		ТелоСообщения.Presentation,
		ТелоСообщения.TimeZone);
	
КонецПроцедуры

Процедура УстановитьПолныеПраваОбластиДанных(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	СообщенияУдаленногоАдминистрированияРеализация.УстановитьПолныеПраваОбластиДанных(
		ТелоСообщения.UserServiceID,
		ТелоСообщения.Value);
	
КонецПроцедуры

Процедура УстановитьПраваПользователяПоУмолчанию(Знач Сообщение, Знач Отправитель)
	
	СообщенияУдаленногоАдминистрированияРеализация.УстановитьПраваПользователяПоУмолчанию(
		Сообщение.Body.UserServiceID);
	
КонецПроцедуры

Процедура УстановитьРейтингОбластейДанных(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	ТаблицаРейтинга = Новый ТаблицаЗначений();
	ТаблицаРейтинга.Колонки.Добавить("ОбластьДанных", Новый ОписаниеТипов("Число", , Новый КвалификаторыЧисла(7,0)));
	ТаблицаРейтинга.Колонки.Добавить("Рейтинг", Новый ОписаниеТипов("Число", , Новый КвалификаторыЧисла(7,0)));
	Для Каждого СтрокаСообщения Из ТелоСообщения.Item Цикл
		СтрокаРейтинга = ТаблицаРейтинга.Добавить();
		СтрокаРейтинга.ОбластьДанных = СтрокаСообщения.Zone;
		СтрокаРейтинга.Рейтинг = СтрокаСообщения.Rating;
	КонецЦикла;
	СообщенияУдаленногоАдминистрированияРеализация.УстановитьРейтингОбластейДанных(
		ТаблицаРейтинга, ТелоСообщения.SetAllZones);
	
КонецПроцедуры

Процедура ПрикрепитьОбластьДанных(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	СообщенияУдаленногоАдминистрированияРеализация.ПрикрепитьОбластьДанных(ТелоСообщения); 
	
КонецПроцедуры

#КонецОбласти
