﻿#Область ПрограммныйИнтерфейс

// Вызывается при получении основного календаря пользователя, например
// при создании нового события
//
// Параметры:
//	Пользователь - Тип: СправочникСсылка.Пользователи
//
// Возвращаемое значение:
//	СправочникСсылка.КалендариПланировщика
//
Функция ПолучитьОсновнойКалендарьПользователя(Пользователь) Экспорт
	// текст обработчика
	Возврат Неопределено;
КонецФункции

// Вызывается при определении адреса электронной почты для получения напоминаний
//
// Параметры:
//	Пользователь - Тип: СправочникСсылка.Пользователи
//
// Возвращаемое значение:
//	Строка. Адрес электронной почты
//
Функция ПолучитьАдресЭлектроннойПочтыПользователя(Пользователь) Экспорт
	АдресЭП = "";
	
	Если НЕ ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Возврат АдресЭП;
	КонецЕсли;
	
	ТипКИ = Перечисления["ТипыКонтактнойИнформации"].АдресЭлектроннойПочты;
	
	ОбщийМодульСервер = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
	АдресаЭП = ОбщийМодульСервер.ЗначенияКонтактнойИнформацииОбъекта(Пользователь, ТипКИ);
	
	Если АдресаЭП.Количество() > 0 Тогда
		АдресЭП = АдресаЭП[0].Значение;
	КонецЕсли;
	
	Возврат АдресЭП;
КонецФункции

// Вызывается при определении номера мобильного телефона для получения напоминаний
//
// Параметры:
//	Пользователь - Тип: СправочникСсылка.Пользователи
//
// Возвращаемое значение:
//	Строка. Номер телефона
//
Функция ПолучитьНомерМобильногоТелефонаПользователя(Пользователь) Экспорт
	НомерТелефона = "";
	
	Если НЕ ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Возврат НомерТелефона;
	КонецЕсли;
	
	ТипКИ = Перечисления["ТипыКонтактнойИнформации"].Телефон;
	
	ОбщийМодульСервер = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
	НомераТелефонов = ОбщийМодульСервер.ЗначенияКонтактнойИнформацииОбъекта(Пользователь, ТипКИ);
	
	Если НомераТелефонов.Количество() > 0 Тогда
		НомерТелефона = НомераТелефонов[0].Значение;
	КонецЕсли;
	
	Возврат НомерТелефона;
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления информационной базы.

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
//  Обработчики - ТаблицаЗначений - описание полей, см. в процедуре
//                ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.1.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//  Обработчик.РежимВыполнения     = "Монопольно";
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	//#Область Обновление_2_2_0_1
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "2.2.0.1";
	//Обработчик.Процедура = "ПланыОбмена.ОбменОнлайнСервисыCalendar.ЗаполнитьИсточникОбменаДаннымиПланировщика_2_2_0_1";
	//
	//#КонецОбласти
	
КонецПроцедуры

#КонецОбласти

