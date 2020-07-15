﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

//Процедура формирует строки списка участников
Процедура ЗаполнитьКонтакты(Контакты) Экспорт
	
	Взаимодействия.ЗаполнитьКонтактыДляВстречи(Контакты, Участники);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Взаимодействия.ЗаполнитьРеквизитыПоУмолчанию(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Взаимодействия.СформироватьСписокУчастников(ЭтотОбъект);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Ответственный    = Пользователи.ТекущийПользователь();
	Автор            = Пользователи.ТекущийПользователь();

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Взаимодействия.ПриЗаписиДокумента(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// _Демо начало примера
// Подсистема "Управление доступом"

// См. описание в комментарии к одноименной процедуре в модуле УправлениеДоступом.
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт

	// Логика ограничения следующая: объект доступен если доступен  "Автор" или "Ответственный".
	// Логика "ИЛИ" реализуется через различные номера наборов.

	// Ограничение по "УчетныеЗаписиЭлектроннойПочты".
	НомерНабора = 1;

	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.НомерНабора     = НомерНабора;
	СтрокаТаб.ЗначениеДоступа = Автор;

	// Ограничение по "Ответственный".
	НомерНабора = НомерНабора + 1;

	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.НомерНабора     = НомерНабора;
	СтрокаТаб.ЗначениеДоступа = Ответственный;

	МассивКонтактныхЛиц = Новый Массив;
	Для Каждого СтрокаТаблицы Из Участники Цикл

		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Контакт) Тогда
			Продолжить;
		КонецЕсли;

		Если ТипЗнч(СтрокаТаблицы.Контакт) = Тип("СправочникСсылка._ДемоПартнеры") Тогда

			НомерНабора = НомерНабора + 1;

			СтрокаТаб = Таблица.Добавить();
			СтрокаТаб.НомерНабора     = НомерНабора;
			СтрокаТаб.ЗначениеДоступа = СтрокаТаблицы.Контакт;

		ИначеЕсли ТипЗнч(СтрокаТаблицы.Контакт) = Тип("СправочникСсылка._ДемоКонтактныеЛицаПартнеров") Тогда

			МассивКонтактныхЛиц.Добавить(СтрокаТаблицы.Контакт);

		КонецЕсли;

	КонецЦикла;

	Если МассивКонтактныхЛиц.Количество() > 0 Тогда

		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	КонтактныеЛицаПартнеров.Владелец КАК Партнер
		|ИЗ
		|	Справочник._ДемоКонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
		|ГДЕ
		|	КонтактныеЛицаПартнеров.Ссылка В(&МассивКонтактныхЛиц)
		|");
		Запрос.УстановитьПараметр("МассивКонтактныхЛиц", МассивКонтактныхЛиц);
		Выборка = Запрос.Выполнить().Выбрать();

		Пока Выборка.Следующий() Цикл

			НомерНабора = НомерНабора + 1;

			СтрокаТаб = Таблица.Добавить();
			СтрокаТаб.НомерНабора     = НомерНабора;
			СтрокаТаб.ЗначениеДоступа = Выборка.Партнер;

		КонецЦикла;

	КонецЕсли;

КонецПроцедуры

// Подсистема "Управление доступом"
// _Демо конец примера

#КонецОбласти

#КонецЕсли