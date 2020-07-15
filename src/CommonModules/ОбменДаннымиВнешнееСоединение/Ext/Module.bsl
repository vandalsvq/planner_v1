﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными"
// Модуль предназначен для работы с внешним соединением
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет выгрузку данных для узла информационной базы во временный файл
// (Только для внутреннего использования)
//
Процедура ВыполнитьВыгрузкуДляУзлаИнформационнойБазы(Отказ,
												ИмяПланаОбмена,
												КодУзлаИнформационнойБазы,
												ПолноеИмяФайлаСообщенияОбмена,
												СтрокаСообщенияОбОшибке = ""
	) Экспорт
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными();
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		Попытка
			ОбменДаннымиСервер.ВыполнитьВыгрузкуДляУзлаИнформационнойБазыЧерезФайл(ИмяПланаОбмена, КодУзлаИнформационнойБазы, ПолноеИмяФайлаСообщенияОбмена);
		Исключение
			Отказ = Истина;
			СтрокаСообщенияОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
		
	Иначе
		
		Адрес = "";
		
		Попытка
			
			ОбменДаннымиСервер.ВыполнитьВыгрузкуДляУзлаИнформационнойБазыВоВременноеХранилище(ИмяПланаОбмена, КодУзлаИнформационнойБазы, Адрес);
			
			ПолучитьИзВременногоХранилища(Адрес).Записать(ПолноеИмяФайлаСообщенияОбмена);
			
			УдалитьИзВременногоХранилища(Адрес);
			
		Исключение
			Отказ = Истина;
			СтрокаСообщенияОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

// Помещает в журнал регистрации запись о начале обмена данными
// (Только для внутреннего использования)
//
Процедура ЗаписьЖурналаРегистрацииНачалаОбменаДанными(СтруктураНастроекОбмена) Экспорт
	
	ОбменДаннымиСервер.ЗаписьЖурналаРегистрацииНачалаОбменаДанными(СтруктураНастроекОбмена);
	
КонецПроцедуры

// Фиксирует завершение обмена данными через внешнее соединение
// (Только для внутреннего использования)
//
Процедура ЗафиксироватьЗавершениеОбмена(СтруктураНастроекОбменаВнешнееСоединение) Экспорт
	
	СтруктураНастроекОбменаВнешнееСоединение.РезультатВыполненияОбмена = Перечисления.РезультатыВыполненияОбмена[СтруктураНастроекОбменаВнешнееСоединение.РезультатВыполненияОбменаСтрокой];
	
	ОбменДаннымиСервер.ЗафиксироватьЗавершениеОбменаЧерезВнешнееСоединение(СтруктураНастроекОбменаВнешнееСоединение);
	
КонецПроцедуры

// Получает зачитанные правила конвертации объектов по имени плана обмена
// (Только для внутреннего использования)
//
//  Возвращаемое значение:
//  Зачитанные правила конвертации объектов
//
Функция ПолучитьПравилаКонвертацииОбъектов(ИмяПланаОбмена) Экспорт
	
	Возврат ОбменДаннымиСервер.ПолучитьПравилаКонвертацииОбъектовЧерезВнешнееСоединение(ИмяПланаОбмена);
	
КонецФункции

// Получает структуру настроек обмена
// (Только для внутреннего использования)
//
Функция СтруктураНастроекОбмена(Структура) Экспорт
	
	Возврат ОбменДаннымиСервер.СтруктураНастроекОбменаЧерезВнешнееСоединение(ОбменДаннымиСобытия.СкопироватьСтруктуру(Структура));
	
КонецФункции

// Проверяет существование плана обмена с заданным именем
// (Только для внутреннего использования)
//
Функция ПланОбменаСуществует(ИмяПланаОбмена) Экспорт
	
	Возврат Метаданные.ПланыОбмена.Найти(ИмяПланаОбмена) <> Неопределено;
	
КонецФункции

// Получает префикс информационной базы по умолчанию через внешнее соединение
// Обертка одноименной функции в переопределяемом модуле.
// (Только для внутреннего использования)
//
Функция ПрефиксИнформационнойБазыПоУмолчанию() Экспорт
	
	ПрефиксИнформационнойБазы = Неопределено;
	ПрефиксИнформационнойБазы = ОбменДаннымиПереопределяемый.ПрефиксИнформационнойБазыПоУмолчанию();
	ОбменДаннымиПереопределяемый.ПриОпределенииПрефиксаИнформационнойБазыПоУмолчанию(ПрефиксИнформационнойБазы);
	
	Возврат ПрефиксИнформационнойБазы;
	
КонецФункции

// Проверяет необходимость проверки расхождения версий в правилах конвертации
//
Функция ПредупреждатьОНесоответствииВерсийПравилОбмена(ИмяПланаОбмена) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат ОбменДаннымиСервер.ЗначениеНастройкиПланаОбмена(ИмяПланаОбмена, "ПредупреждатьОНесоответствииВерсийПравилОбмена");
	
КонецФункции

// Возвращает признак доступности роли ПолныеПрава
// (Только для внутреннего использования)
//
Функция РольДоступнаПолныеПрава() Экспорт
	
	Возврат Пользователи.ЭтоПолноправныйПользователь(, Истина);
	
КонецФункции

// Возвращает таблицу списка объектов заданного объекта метаданных
// (Только для внутреннего использования)
// 
Функция ПолучитьОбъектыТаблицы(ПолноеИмяТаблицы) Экспорт
	
	Возврат ЗначениеВСтрокуВнутр(ОбщегоНазначения.ЗначениеИзСтрокиXML(ОбменДаннымиСервер.ПолучитьОбъектыТаблицы(ПолноеИмяТаблицы)));
	
КонецФункции

// Возвращает таблицу списка объектов заданного объекта метаданных
// (Только для внутреннего использования)
// 
Функция ПолучитьОбъектыТаблицы_2_0_1_6(ПолноеИмяТаблицы) Экспорт
	
	Возврат ОбменДаннымиСервер.ПолучитьОбъектыТаблицы(ПолноеИмяТаблицы);
	
КонецФункции

// Получает заданные свойства (Синоним, Иерархический) объекта метаданных
// (Только для внутреннего использования)
//
Функция СвойстваОбъектаМетаданных(ПолноеИмяТаблицы) Экспорт
	
	Возврат ОбменДаннымиСервер.СвойстваОбъектаМетаданных(ПолноеИмяТаблицы);
	
КонецФункции

// Возвращает название предопределенного узла плана обмена
// (Только для внутреннего использования)
//
Функция НаименованиеПредопределенногоУзлаПланаОбмена(ИмяПланаОбмена) Экспорт
	
	Возврат ОбменДаннымиСервер.НаименованиеПредопределенногоУзлаПланаОбмена(ИмяПланаОбмена);
	
КонецФункции

// Для внутреннего использования
//
Функция ПолучитьОбщиеДанныеУзлов(Знач ИмяПланаОбмена) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ЗначениеВСтрокуВнутр(ОбменДаннымиСервер.ДанныеДляТабличныхЧастейУзловЭтойИнформационнойБазы(ИмяПланаОбмена));
	
КонецФункции

// Для внутреннего использования
//
Функция ПолучитьОбщиеДанныеУзлов_2_0_1_6(Знач ИмяПланаОбмена) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбщегоНазначения.ЗначениеВСтрокуXML(ОбменДаннымиСервер.ДанныеДляТабличныхЧастейУзловЭтойИнформационнойБазы(ИмяПланаОбмена));
	
КонецФункции

// Для внутреннего использования
//
Функция ПолучитьПараметрыИнформационнойБазы(Знач ИмяПланаОбмена, Знач КодУзла, СообщениеОбОшибке) Экспорт
	
	Возврат ОбменДаннымиСервер.ПолучитьПараметрыИнформационнойБазы(ИмяПланаОбмена, КодУзла, СообщениеОбОшибке);
	
КонецФункции

// Для внутреннего использования
//
Функция ПолучитьПараметрыИнформационнойБазы_2_0_1_6(Знач ИмяПланаОбмена, Знач КодУзла, СообщениеОбОшибке) Экспорт
	
	Возврат ОбменДаннымиСервер.ПолучитьПараметрыИнформационнойБазы_2_0_1_6(ИмяПланаОбмена, КодУзла, СообщениеОбОшибке);
	
КонецФункции

#КонецОбласти
