﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Варианты отчетов" (сервер, повт. исп.)
// 
// Выполняется на сервере, возвращаемые значения кэшируются на время сеанса.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Формирует список отчетов конфигурации, доступных текущему пользователю.
//
// Возвращаемое значение:
//   Массив из <см. Справочники.ВариантыОтчетов.Реквизиты.Отчет> -
//       Ссылки отчетов, доступных текущему пользователю.
//
// Описание:
//   Данный массив следует использовать во всех запросах к таблице
//   справочника "ВариантыОтчетов" как отбор по реквизиту "Отчет".
//
Функция ДоступныеОтчеты() Экспорт
	Результат = Новый Массив;
	
	Для Каждого ОтчетМетаданные Из Метаданные.Отчеты Цикл
		Если ПравоДоступа("Просмотр", ОтчетМетаданные)
			И ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ОтчетМетаданные) Тогда
			Результат.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ОтчетМетаданные));
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Формирует список вариантов отчетов конфигурации, недоступных текущему пользователю по функциональным опциям.
//
// Возвращаемое значение:
//   Массив из СправочникСсылка.ПредопределенныеВариантыОтчетов -
//       Варианты отчетов, которые отключены по функциональным опциям.
//
// Описание:
//   Данный массив следует использовать во всех запросах к таблице
//   справочника "ВариантыОтчетов" как исключающий отбор по реквизиту "ПредопределенныйВариант".
//
Функция ОтключенныеВариантыПрограммы() Экспорт
	// Получить варианты, недоступные по функциональным опциям
	
	ЗначениеКонстанты = Константы.ПараметрыВариантовОтчетов.Получить();
	Структура = ЗначениеКонстанты.Получить();
	ТаблицаОпций = Структура.ТаблицаФункциональныхОпций;
	ТаблицаОпций.Колонки.Добавить("ОтчетДоступен", Новый ОписаниеТипов("Булево"));
	ТаблицаОпций.Колонки.Добавить("ЗначениеОпции", Новый ОписаниеТипов("Число"));
	
	ОтчетыПользователя = ВариантыОтчетовПовтИсп.ДоступныеОтчеты();
	Для Каждого ОтчетСсылка Из ОтчетыПользователя Цикл
		Найденные = ТаблицаОпций.НайтиСтроки(Новый Структура("Отчет", ОтчетСсылка));
		Для Каждого СтрокаТаблицы Из Найденные Цикл
			СтрокаТаблицы.ОтчетДоступен = Истина;
			Значение = ПолучитьФункциональнуюОпцию(СтрокаТаблицы.ИмяФункциональнойОпции);
			Если Значение = Истина Тогда
				СтрокаТаблицы.ЗначениеОпции = 1;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ТаблицаОпций.Свернуть("ПредопределенныйВариант, ОтчетДоступен", "ЗначениеОпции");
	ТаблицаВариантов = ТаблицаОпций.Скопировать(Новый Структура("ОтчетДоступен, ЗначениеОпции", Истина, 0));
	ТаблицаВариантов.Свернуть("ПредопределенныйВариант");
	ОтключенныеВарианты = ТаблицаВариантов.ВыгрузитьКолонку("ПредопределенныйВариант");
	
	// Добавить варианты, отключенные разработчиком
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОтчетыПользователя", ОтчетыПользователя);
	Запрос.УстановитьПараметр("МассивОтключенных", ОтключенныеВарианты);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПредопределенныеВариантыОтчетов.Ссылка
	|ИЗ
	|	Справочник.ПредопределенныеВариантыОтчетов КАК ПредопределенныеВариантыОтчетов
	|ГДЕ
	|	ПредопределенныеВариантыОтчетов.Включен = ЛОЖЬ
	|	И ПредопределенныеВариантыОтчетов.Отчет В(&ОтчетыПользователя)
	|	И НЕ ПредопределенныеВариантыОтчетов.Ссылка В (&МассивОтключенных)
	|	И ПредопределенныеВариантыОтчетов.ПометкаУдаления = ЛОЖЬ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОтключенныеВарианты.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат ОтключенныеВарианты;
КонецФункции

// Формирует дерево подсистем, доступных текущему пользователю.
//
// Возвращаемое значение: 
//   Результат - ДеревоЗначений -
//       * РазделСсылка - СправочникСсылка.ИдентификаторыОбъектовМетаданных - Ссылка раздела.
//       * Ссылка       - СправочникСсылка.ИдентификаторыОбъектовМетаданных - Ссылка подсистемы.
//       * Имя           - Строка - Имя подсистемы.
//       * ПолноеИмя     - Строка - Полное имя подсистемы.
//       * Представление - Строка - Представление подсистемы.
//       * Приоритет     - Строка - Приоритет подсистемы.
//
Функция ПодсистемыТекущегоПользователя() Экспорт
	Результат = Новый ДеревоЗначений;
	Результат.Колонки.Добавить("Ссылка",              Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
	Результат.Колонки.Добавить("Имя",                 ВариантыОтчетов.ОписаниеТиповСтрока(150));
	Результат.Колонки.Добавить("ПолноеИмя",           ВариантыОтчетов.ОписаниеТиповСтрока(510));
	Результат.Колонки.Добавить("Представление",       ВариантыОтчетов.ОписаниеТиповСтрока(150));
	Результат.Колонки.Добавить("РазделСсылка",        Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
	Результат.Колонки.Добавить("Приоритет",           ВариантыОтчетов.ОписаниеТиповСтрока(100));
	Результат.Колонки.Добавить("ПолноеПредставление", ВариантыОтчетов.ОписаниеТиповСтрока(300));
	
	КорневаяСтрока = Результат.Строки.Добавить();
	КорневаяСтрока.Ссылка = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка();
	КорневаяСтрока.Представление = НСтр("ru = 'Все разделы'");
	
	ВариантыОтчетов.ДобавитьПодсистемыТекущегоПользователя(КорневаяСтрока, Неопределено, Неопределено);
	
	Возврат Результат;
КонецФункции

// Возвращает Истина если у пользователя есть право чтения вариантов отчетов.
Функция ПравоЧтения() Экспорт
	Возврат ПравоДоступа("Чтение", Метаданные.Справочники.ВариантыОтчетов);
КонецФункции

// Возвращает Истина если у пользователя есть право на сохранение вариантов отчетов.
Функция ПравоДобавления() Экспорт
	Возврат ПравоДоступа("СохранениеДанныхПользователя", Метаданные) И ПравоДоступа("Добавление", Метаданные.Справочники.ВариантыОтчетов);
КонецФункции

// Массив отчетов, которые хранят настройки общей формы "ФормаОтчета" и переопределяют их в модуле объекта.
//
// Возвращаемое значение:
//   Массив из <см. Справочники.ВариантыОтчетов.Реквизиты.Отчет> -
//       Ссылки отчетов, в модулях объектов которых есть процедура ОпределитьНастройкиФормы().
//
// См. также:
//   ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
Функция ОтчетыСНастройками() Экспорт
	ЗначениеКонстанты = Константы.ПараметрыВариантовОтчетов.Получить();
	Структура = ЗначениеКонстанты.Получить();
	Возврат Структура.ОтчетыСНастройками;
КонецФункции

#КонецОбласти
