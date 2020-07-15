﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации()
//   НастройкиОтчета - СтрокаДереваЗначений - Настройки размещения всех вариантов отчета.
//       см. "Реквизиты для изменения" функции ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//
// Описание:
//   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Вспомогательные методы:
//   НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//   ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь); // Отчет поддерживает только этот режим.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	
	НастройкиОтчета = МодульВариантыОтчетов.ОписаниеОтчета(Настройки, Создать().Метаданные());
	НастройкиОтчета.Описание = НСтр("ru = 'Внешние ресурсы, используемые программой и дополнительными модулями'");
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	НастройкиОтчета.НастройкиДляПоиска.НаименованияПолей = 
		НСтр("ru = 'Адрес
		|Чтение данных
		|Запись данных
		|Имя и идентификатор COM-класса
		|Имя компьютера
		|Имя макета и файла компоненты
		|Контрольная сумма
		|Шаблон командной строки
		|Протокол
		|Адрес Интернет-ресурса
		|Порт
		|Разрешения на расширенную работу с данными'");
	
КонецПроцедуры

// Формирует представление разрешений на использование внешних ресурсов по таблицам разрешений.
//
// Параметры:
//  ТаблицыРазрешений - Структура - см. Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ТаблицыРазрешений().
//
// Возвращаемое значение: ТабличныйДокумент - представление разрешений.
//
Функция ПредставлениеРазрешенийНаИспользованиеВнешнихРесурсов(Знач ТаблицыРазрешений) Экспорт
	
	Макет = ПолучитьМакет("ПредставленияРазрешений");
	ТабличныйДокумент = Новый ТабличныйДокумент();
	
	СформироватьПредставлениеРазрешений(ТабличныйДокумент, ТаблицыРазрешений, Макет, Истина);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует представление изменений в разрешениях на использование внешних ресурсов в результате
// применения запросов.
//
// Параметры:
//  ОперацииАдминистрирования - ТаблицаЗначений, см. Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ОперацииАдминистрированияВЗапросах(),
//  ДельтаРазрешений - Структура, см. Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ДельтаИзмененийРазрешенийНаИспользованиеВнешнихРесурсов(),
//  КакТребуемые - Булево - флаг использования в представлении терминов вида "требуются следующие ресурсы" вместо "будут предоставлены следующие ресурсы".
//
// Возвращаемое значение: ТабличныйДокумент.
//
Функция ПредставлениеРезультатаПримененияЗапросовНаИспользованиеВнешнихРесурсов(Знач ОперацииАдминистрирования, Знач ДельтаРазрешений, Знач КакТребуемые = Ложь) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент();
	ЗаполнитьПредставлениеРезультатаПримененияЗапросовНаИспользованиеВнешнихРесурсов(ТабличныйДокумент, ОперацииАдминистрирования, ДельтаРазрешений);
	Возврат ТабличныйДокумент;
	
КонецФункции

// Заполняет переданный табличный документ представлением изменений в разрешениях на использование
// внешних ресурсов в результате применения запросов.
//
// Параметры:
//  ТабличныйДокумент - ТабличныйДокумент, который будет заполнен,
//  ОперацииАдминистрирования - ТаблицаЗначений, см. Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ОперацииАдминистрированияВЗапросах(),
//  ДельтаРазрешений - Структура, см. Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ДельтаИзмененийРазрешенийНаИспользованиеВнешнихРесурсов(),
//  КакТребуемые - Булево - флаг использования в представлении терминов вида "требуются следующие ресурсы" вместо "будут предоставлены следующие ресурсы".
//
Процедура ЗаполнитьПредставлениеРезультатаПримененияЗапросовНаИспользованиеВнешнихРесурсов(ТабличныйДокумент, Знач ОперацииАдминистрирования, Знач ДельтаРазрешений, Знач КакТребуемые = Ложь) Экспорт
	
	Макет = ПолучитьМакет("ПредставленияРазрешений");
	ОбластьОтступа = Макет.ПолучитьОбласть("Отступ");
	
	СформироватьПредставлениеОпераций(ТабличныйДокумент, Макет, ОперацииАдминистрирования);
	
	ВыводитьГруппировки = ДельтаРазрешений.Количество() > 1;
	
	Для Каждого ФрагментИзменений Из ДельтаРазрешений Цикл
		
		Модуль = ФрагментИзменений.ВнешнийМодуль;
		
		Если Модуль = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка() Тогда
		
			Словарь = СловарьМодуляКонфигурации();
			НаименованиеМодуля = Метаданные.Синоним;
			
		Иначе
			
			Словарь = РаботаВБезопасномРежимеСлужебный.МенеджерВнешнегоМодуля(Модуль).СловарьКонтейнераВнешнегоМодуля();
			НаименованиеМодуля = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Модуль, "Наименование");
			
		КонецЕсли;
		
		Разница = ФрагментИзменений.Изменения;
		
		КоличествоДобавляемых = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.КоличествоРазрешенийВТаблицах(Разница.Добавляемые);
		КоличествоУдаляемых = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.КоличествоРазрешенийВТаблицах(Разница.Удаляемые);
		
		Если КоличествоДобавляемых > 0 Тогда
			
			ТабличныйДокумент.Вывести(ОбластьОтступа);
			
			Если КакТребуемые Тогда
				ОбластьШапки = Макет.ПолучитьОбласть("ШапкаТребуемыеРазрешения");
			Иначе
				ОбластьШапки = Макет.ПолучитьОбласть("ШапкаНовыеРазрешения");
			КонецЕсли;
			ОбластьШапки.Параметры.ВидВнешнегоМодуляВРодительномПадеже = НРег(Словарь.Родительный);
			ОбластьШапки.Параметры.Наименование = НаименованиеМодуля;
			Если Модуль <> Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка() Тогда
				ОбластьШапки.Параметры.Модуль = Модуль;
			КонецЕсли;
			ТабличныйДокумент.Вывести(ОбластьШапки);
			
			Если ВыводитьГруппировки Тогда
				ТабличныйДокумент.НачатьГруппуСтрок();
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьОтступа);
			
			СформироватьПредставлениеРазрешений(ТабличныйДокумент, Разница.Добавляемые, Макет, КакТребуемые);
			
			Если ВыводитьГруппировки Тогда
				ТабличныйДокумент.ЗакончитьГруппуСтрок();
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
		КонецЕсли;
		
		Если КоличествоУдаляемых > 0 Тогда
			
			Если ВыводитьГруппировки Тогда
				ТабличныйДокумент.НачатьГруппуСтрок();
			КонецЕсли;
			
			ОбластьШапки = Макет.ПолучитьОбласть("ШапкаУдаляемыеРазрешения");
			ОбластьШапки.Параметры.ВидВнешнегоМодуляВРодительномПадеже = НРег(Словарь.Родительный);
			ОбластьШапки.Параметры.Наименование = НаименованиеМодуля;
			ТабличныйДокумент.Вывести(ОбластьШапки);
			СформироватьПредставлениеРазрешений(ТабличныйДокумент, Разница.Удаляемые, Макет, КакТребуемые);
			
			Если ВыводитьГруппировки Тогда
				ТабличныйДокумент.ЗакончитьГруппуСтрок();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Формирует представление операций администрирования разрешений на использование внешних ресурсов.
//
// Параметры:
//  ТабличныйДокумент - ТабличныйДокумент, в который будет выведено представление операций,
//  Макет - ТабличныйДокумент, полученный из макета отчета ПредставленияРазрешений,
//  ОперацииАдминистрирования - ТаблицаЗначений, см. Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ОперацииАдминистрированияВЗапросах().
//
Процедура СформироватьПредставлениеОпераций(ТабличныйДокумент, Знач Макет, Знач ОперацииАдминистрирования)
	
	Для Каждого Описание Из ОперацииАдминистрирования Цикл
		
		Если Описание.Операция = Перечисления.ОперацииСНаборамиРазрешений.Удаление Тогда
			
			ЭтоПрофильКонфигурации = (Описание.ВнешнийМодуль = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка());
			
			Если ЭтоПрофильКонфигурации Тогда
				
				Словарь = СловарьМодуляКонфигурации();
				НаименованиеМодуля = Метаданные.Синоним;
				
			Иначе
				
				Словарь = РаботаВБезопасномРежимеСлужебный.МенеджерВнешнегоМодуля(Описание.ВнешнийМодуль).СловарьКонтейнераВнешнегоМодуля();
				НаименованиеМодуля = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Описание.ВнешнийМодуль, "Наименование");
				
			КонецЕсли;
			
			Область = Макет.ПолучитьОбласть("ШапкаУдалениеПрофиляБезопасности");
			Область.Параметры["ВидВнешнегоМодуляВРодительномПадеже"] = НРег(Словарь.Родительный);
			Область.Параметры["Наименование"] = НаименованиеМодуля;
			
			ТабличныйДокумент.Вывести(Область);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Формирует представление разрешений.
//
// Параметры:
//  ТабличныйДокумент - ТабличныйДокумент, в который будет выведено представление операций,
//  НаборыРазроешений - Структура, см. Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ТаблицыРазрешений(),
//  Макет - ТабличныйДокумент, полученный из макета отчета ПредставленияРазрешений,
//  КакТребуемые - Булево - флаг использования в представлении терминов вида "требуются следующие ресурсы" вместо "будут предоставлены следующие ресурсы".
//
Процедура СформироватьПредставлениеРазрешений(ТабличныйДокумент, Знач НаборыРазрешений, Знач Макет, Знач КакТребуемые = Ложь)
	
	ОбластиМакета = ОбластиМакета(КакТребуемые);
	
	ОбластьОтступа = Макет.ПолучитьОбласть("Отступ");
	
	Для Каждого КлючИЗначение Из НаборыРазрешений Цикл
		
		ТипРазрешения = КлючИЗначение.Ключ;
		Разрешения = КлючИЗначение.Значение;
		
		Если Разрешения.Количество() > 0 Тогда
			
			ИмяОбластиГруппы = ОбластиМакета.Найти(ТипРазрешения, "ТипРазрешения").Группа;
			ОбластьГруппы = Макет.ПолучитьОбласть(ИмяОбластиГруппы);
			ЗаполнитьЗначенияСвойств(ОбластьГруппы.Параметры, Новый Структура("Количество", Разрешения.Количество()));
			ТабличныйДокумент.Вывести(ОбластьГруппы);
			
			ТабличныйДокумент.НачатьГруппуСтрок(ТипРазрешения, Истина);
			
			ИмяОбластиШапки = ОбластиМакета.Найти(ТипРазрешения, "ТипРазрешения").ШапкаТаблицы;
			ОбластьШапки = Макет.ПолучитьОбласть(ИмяОбластиШапки);
			ТабличныйДокумент.Вывести(ОбластьШапки);
			
			ИмяОбластиСтроки = ОбластиМакета.Найти(ТипРазрешения, "ТипРазрешения").СтрокаТаблицы;
			ОбластьСтроки = Макет.ПолучитьОбласть(ИмяОбластиСтроки);
			
			Для Каждого Разрешение Из Разрешения Цикл
				
				Если ТипРазрешения = "FileSystemAccess" Тогда
					
					Если Разрешение.Адрес = "/temp" Тогда
						Разрешение.Адрес = НСтр("ru = 'Каталог временных файлов'");
					КонецЕсли;
					
					Если Разрешение.Адрес = "/bin" Тогда
						Разрешение.Адрес = НСтр("ru = 'Каталог, в который установлен сервер 1С:Предприятия'");
					КонецЕсли;
					
				КонецЕсли;
				
				ЗаполнитьЗначенияСвойств(ОбластьСтроки.Параметры, Разрешение);
				ТабличныйДокумент.Вывести(ОбластьСтроки);
				
			КонецЦикла;
			
			ТабличныйДокумент.ЗакончитьГруппуСтрок();
			
			ТабличныйДокумент.Вывести(ОбластьОтступа);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает словарь свойст конфигурации.
//
// Возвращаемое значение: Структура:
//                         * Именительный - синоним вида модуля в именительном падеже,
//                         * Родительный - синоним вида модуля в родительном падеже.
//
Функция СловарьМодуляКонфигурации() Экспорт
	
	Результат = Новый Структура();
	
	Результат.Вставить("Именительный", НСтр("ru = 'Программа'"));
	Результат.Вставить("Родительный", НСтр("ru = 'Программы'"));
	
	Возврат Результат;
	
КонецФункции

// Возвращает соответствие типов разрешений областям макета ПредставленияРазрешений.
//
// Возвращаемое значение: ТаблицаЗначений:
//                          * ТипРазрешений - Строка - - имя XDTO-типа, описывающего типа разрешений.
//                              Тип должен быть определен в пакете {http://www.1c.ru/1cFresh/Application/Permissions/a.b.c.d},
//                          * Группа - Строка - имя области макета, которая используется в качестве группы для типа разрешений,
//                          * ШапкаТаблицы - Строка - имя области макета, которая используется в качестве шапки таблицы для типа разрешений,
//                          * СтрокаТаблицы - Строка - имя области макета, которая используется в качестве строки таблицы для типа разрешений.
//
Функция ОбластиМакета(Знач КакТребуемые)
	
	Результат = Новый ТаблицаЗначений();
	Результат.Колонки.Добавить("ТипРазрешения", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("Группа", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("ШапкаТаблицы", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("СтрокаТаблицы", Новый ОписаниеТипов("Строка"));
	
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.ТипРазрешения = "FileSystemAccess";
	Если КакТребуемые Тогда
		НоваяСтрока.Группа = "ТребованияКаталогиФайловойСистемы";
	Иначе
		НоваяСтрока.Группа = "РазрешенияКаталогиФайловойСистемы";
	КонецЕсли;
	НоваяСтрока.ШапкаТаблицы = "ШапкаТаблицыКаталогиФайловойСистемы";
	НоваяСтрока.СтрокаТаблицы = "СтрокаТаблицыКаталогиФайловойСистемы";
	
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.ТипРазрешения = "CreateComObject";
	Если КакТребуемые Тогда
		НоваяСтрока.Группа = "ТребованияCOMОбъекты";
	Иначе
		НоваяСтрока.Группа = "РазрешенияCOMОбъекты";
	КонецЕсли;
	НоваяСтрока.ШапкаТаблицы = "ШапкаТаблицыCOMОбъекты";
	НоваяСтрока.СтрокаТаблицы = "СтрокаТаблицыCOMОбъекты";
	
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.ТипРазрешения = "AttachAddin";
	Если КакТребуемые Тогда
		НоваяСтрока.Группа = "ТребованияВнешниеКомпоненты";
	Иначе
		НоваяСтрока.Группа = "РазрешенияВнешниеКомпоненты";
	КонецЕсли;
	НоваяСтрока.ШапкаТаблицы = "ШапкаТаблицыВнешниеКомпоненты";
	НоваяСтрока.СтрокаТаблицы = "СтрокаТаблицыВнешниеКомпоненты";
	
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.ТипРазрешения = "RunApplication";
	Если КакТребуемые Тогда
		НоваяСтрока.Группа = "ТребованияПриложенияОС";
	Иначе
		НоваяСтрока.Группа = "РазрешенияПриложенияОС";
	КонецЕсли;
	НоваяСтрока.ШапкаТаблицы = "ШапкаТаблицыПриложенияОС";
	НоваяСтрока.СтрокаТаблицы = "СтрокаТаблицыПриложенияОС";
	
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.ТипРазрешения = "InternetResourceAccess";
	Если КакТребуемые Тогда
		НоваяСтрока.Группа = "ТребованияИнтернетРесурсы";
	Иначе
		НоваяСтрока.Группа = "РазрешенияИнтернетРесурсы";
	КонецЕсли;
	НоваяСтрока.ШапкаТаблицы = "ШапкаТаблицыИнтернетРесурсы";
	НоваяСтрока.СтрокаТаблицы = "СтрокаТаблицыИнтернетРесурсы";
	
	НоваяСтрока = Результат.Добавить();
	Если КакТребуемые Тогда
		НоваяСтрока.Группа = "ТребованияПривилегированныйРежим";
	Иначе
		НоваяСтрока.Группа = "РазрешенияПривилегированныйРежим";
	КонецЕсли;
	НоваяСтрока.ТипРазрешения = "ExternalModulePrivilegedModeAllowed";
	НоваяСтрока.ШапкаТаблицы = "ШапкаТаблицыПривилегированныйРежим";
	НоваяСтрока.СтрокаТаблицы = "СтрокаТаблицыПривилегированныйРежим";
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли