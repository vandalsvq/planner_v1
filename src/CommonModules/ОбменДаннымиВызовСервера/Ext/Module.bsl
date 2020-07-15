﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными"
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Точка входа для выполнения итерации обмена данными - загрузки и выгрузки данных для узла плана обмена
//
// Параметры:
//  Отказ                  - Булево - флаг отказа; поднимается в случае возникновения ошибки при выполнении обмена
//  УзелИнформационнойБазы - ПланОбменаСсылка - узел плана обмена, для которого выполняется итерация обмена данными
//  ВыполнятьЗагрузку      - Булево (необязательный) - флаг необходимости выполнять загрузку данных. Значение по умолчанию - Истина
//  ВыполнятьВыгрузку      - Булево (необязательный) - флаг необходимости выполнять выгрузку данных. Значение по умолчанию - Истина
//  ВидТранспортаСообщенийОбмена (необязательный) - ПеречислениеСсылка.ВидыТранспортаСообщенийОбмена - вид транспорта, 
//								который будет использоваться в процессе обмена данными. 
//								Значение по умолчанию - значение из РС.НастройкиТранспортаОбмена.Ресурс.ВидТранспортаСообщенийОбменаПоУмолчанию;
//								если в РС значение не задано, то значение по умолчанию - Перечисления.ВидыТранспортаСообщенийОбмена.FILE
// 
Процедура ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(Отказ,
														УзелИнформационнойБазы,
														ВыполнятьЗагрузку = Истина,
														ВыполнятьВыгрузку = Истина,
														ВидТранспортаСообщенийОбмена = Неопределено,
														ДлительнаяОперация = Ложь,
														ИдентификаторОперации = "",
														ИдентификаторФайла = "",
														ДлительнаяОперацияРазрешена = Ложь,
														Знач ПараметрыАутентификации = Неопределено
	) Экспорт
	
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(Отказ,
														УзелИнформационнойБазы,
														ВыполнятьЗагрузку,
														ВыполнятьВыгрузку,
														ВидТранспортаСообщенийОбмена,
														ДлительнаяОперация,
														ИдентификаторОперации,
														ИдентификаторФайла,
														ДлительнаяОперацияРазрешена,
														ПараметрыАутентификации);
	
КонецПроцедуры

// Выполняет процесс обмена данными отдельно для каждой строки настройки обмена
// Процесс обмена данными состоит из двух стадий:
// - инициализация обмена - подготовка подсистемы обмена данными к процессу обмена
// - обмен данными        - процесс зачитывания файла сообщения с последующей загрузкой этих данных в ИБ 
//                          или выгрузки изменений в файл сообщения
// Стадия инициализации выполняется один раз за сеанс и сохраняется в кэше сеанса на сервере 
// до перезапуска сеанса или сброса повторно-используемых значений подсистемы обмена данными.
// Сброс повторно-используемых значений происходит при изменении данных, влияющих на процесс обмена данными
// (настройки транспорта, настройка выполнения обмена, настройка отборов на узлах планов обмена)
//
// Обмен может быть выполнен полностью для всех строк сценария,
// а может быть выполнен для отдельной строки ТЧ сценария обмена
//
// Параметры:
//  Отказ                     - Булево - флаг отказа; поднимается в случае возникновения ошибки при выполнении сценария
//  НастройкаВыполненияОбмена - СправочникСсылка.СценарииОбменовДанными - элемент справочника,
//                              по значениям реквизитов которого будет выполнен обмен данными
//  НомерСтроки               - Число - Номер строки по которой будет выполнен обмен данными.
//                              Если не указан, то обмен данными будет выполнен для всех строк
// 
Процедура ВыполнитьОбменДаннымиПоСценариюОбменаДанными(Отказ, НастройкаВыполненияОбмена, НомерСтроки = Неопределено) Экспорт
	
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиПоСценариюОбменаДанными(Отказ, НастройкаВыполненияОбмена, НомерСтроки);
	
КонецПроцедуры

//

// Выполняет проверку актуальности КЭШа механизма регистрации объектов.
// Если кэш неактуальный, то выполняется инициализация КЭШа актуальными значениями.
//
// Параметры:
//  Нет.
// 
Процедура ПроверитьКэшМеханизмаРегистрацииОбъектов() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		АктуальнаяДата = ПолучитьФункциональнуюОпцию("АктуальнаяДатаОбновленияПовторноИспользуемыхЗначенийМРО");
		
		Если ПараметрыСеанса.ДатаОбновленияПовторноИспользуемыхЗначенийМРО <> АктуальнаяДата Тогда
			
			ОбновитьКэшМеханизмаРегистрацииОбъектов();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Обновляет/устанавливает повторно-используемые значения и параметры сеанса для подсистемы обмена данными
//
// Устанавливаемые параметры сеанса:
//   ПравилаРегистрацииОбъектов - ХранилищеЗначения - в бинарном виде содержит таблицу значений с правилами регистрации объектов.
//   ПравилаВыборочнойРегистрацииОбъектов - 
//   ДатаОбновленияПовторноИспользуемыхЗначенийМРО - Дата (Дата и время) - содержит дату последнего актуального
//                                                                         кэша для подсистемы обмена данными
//
// Параметры:
//  Нет.
// 
Процедура ОбновитьКэшМеханизмаРегистрацииОбъектов() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбменДаннымиПовтИсп.ИспользуемыеПланыОбмена().Количество() > 0 Тогда
		
		ПараметрыСеанса.ПравилаРегистрацииОбъектов = Новый ХранилищеЗначения(ОбменДаннымиСервер.ПолучитьПравилаРегистрацииОбъектов());
		
		ПараметрыСеанса.ПравилаВыборочнойРегистрацииОбъектов = Новый ХранилищеЗначения(ОбменДаннымиСервер.ПолучитьПравилаВыборочнойРегистрацииОбъектов());
		
	Иначе
		
		ПараметрыСеанса.ПравилаРегистрацииОбъектов = Новый ХранилищеЗначения(ОбменДаннымиСервер.ИнициализацияТаблицыПравилРегистрацииОбъектов());
		
		ПараметрыСеанса.ПравилаВыборочнойРегистрацииОбъектов = Новый ХранилищеЗначения(ОбменДаннымиСервер.ИнициализацияТаблицыПравилВыборочнойРегистрацииОбъектов());
		
	КонецЕсли;
	
	// Ключ для проверки актуальности кэша
	ПараметрыСеанса.ДатаОбновленияПовторноИспользуемыхЗначенийМРО = ПолучитьФункциональнуюОпцию("АктуальнаяДатаОбновленияПовторноИспользуемыхЗначенийМРО");
	
КонецПроцедуры

// Устанавливает значение константы ДатаОбновленияПовторноИспользуемыхЗначенийМРО
// В качестве устанавливаемого значения используется текущая дата компьютера (сервера)
// В момент изменения значения этой константы повторно-используемые значения 
// для подсистемы обмена данными становятся неактуальными и требуют повторной инициализации.
//
// Параметры:
//  Нет.
// 
Процедура СброситьКэшМеханизмаРегистрацииОбъектов() Экспорт
	
	Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		// записываем дату и время компьютера сервера - ТекущаяДата()
		// метод ТекущаяДатаСеанса() использовать нельзя.
		// Текущая дата сервера в данном случае используется в качестве ключа уникальности кэша механизма регистрации объектов.
		Константы.ДатаОбновленияПовторноИспользуемыхЗначенийМРО.Установить(ТекущаяДата());
		
	КонецЕсли;
	
КонецПроцедуры

//

// Выполняет загрузку данных сообщения обмена, расположенного в локальной файловой системе сервера.
//
Процедура ВыполнитьЗагрузкуДляУзлаИнформационнойБазыЧерезФайл(Отказ, Знач УзелИнформационнойБазы, Знач ПолноеИмяФайлаСообщенияОбмена) Экспорт
	
	Попытка
		ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазыЧерезФайлИлиСтроку(УзелИнформационнойБазы, ПолноеИмяФайлаСообщенияОбмена, Перечисления.ДействияПриОбмене.ЗагрузкаДанных);
	Исключение
		Отказ = Истина;
	КонецПопытки;
	
КонецПроцедуры

// Фиксирует успешное выполнение обмена данными в системе.
//
Процедура ЗафиксироватьВыполнениеВыгрузкиДанныхВРежимеДлительнойОперации(Знач УзелИнформационнойБазы, Знач ДатаНачала) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДействиеПриОбмене = Перечисления.ДействияПриОбмене.ВыгрузкаДанных;
	
	СтруктураНастроекОбмена = Новый Структура;
	СтруктураНастроекОбмена.Вставить("УзелИнформационнойБазы", УзелИнформационнойБазы);
	СтруктураНастроекОбмена.Вставить("РезультатВыполненияОбмена", Перечисления.РезультатыВыполненияОбмена.Выполнено);
	СтруктураНастроекОбмена.Вставить("ДействиеПриОбмене", ДействиеПриОбмене);
	СтруктураНастроекОбмена.Вставить("КоличествоОбъектовОбработано", 0);
	СтруктураНастроекОбмена.Вставить("КлючСообщенияЖурналаРегистрации", ОбменДаннымиСервер.ПолучитьКлючСообщенияЖурналаРегистрации(УзелИнформационнойБазы, ДействиеПриОбмене));
	СтруктураНастроекОбмена.Вставить("ДатаНачала", ДатаНачала);
	СтруктураНастроекОбмена.Вставить("ДатаОкончания", ТекущаяДатаСеанса());
	СтруктураНастроекОбмена.Вставить("ЭтоОбменВРИБ", ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(УзелИнформационнойБазы));
	
	ОбменДаннымиСервер.ЗафиксироватьЗавершениеОбмена(СтруктураНастроекОбмена);
	
КонецПроцедуры

// Фиксирует аварийное завершение обмена данными.
//
Процедура ЗафиксироватьЗавершениеОбменаСОшибкой(Знач УзелИнформационнойБазы,
												Знач ДействиеПриОбмене,
												Знач ДатаНачала,
												Знач СтрокаСообщенияОбОшибке
	) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбменДаннымиСервер.ЗафиксироватьЗавершениеОбменаСОшибкой(УзелИнформационнойБазы,
											ДействиеПриОбмене,
											ДатаНачала,
											СтрокаСообщенияОбОшибке);
КонецПроцедуры

// Выполняет получение файла сообщения обмена из базы-корреспондента через веб-сервис.
// Выполняет загрузку полученного файла сообщения обмена в эту базу.
//
Процедура ВыполнитьОбменДаннымиДляУзлаИнформационнойБазыЗавершениеДлительнойОперации(
															Отказ,
															Знач УзелИнформационнойБазы,
															Знач ИдентификаторФайла,
															Знач ДатаНачалаОперации,
															Знач ПараметрыАутентификации = Неопределено
	) Экспорт
	
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазыЗавершениеДлительнойОперации(
															Отказ,
															УзелИнформационнойБазы,
															ИдентификаторФайла,
															ДатаНачалаОперации,
															ПараметрыАутентификации);
КонецПроцедуры

// Выполняет попытку установки внешнего соединения по переданным параметрам подключения.
// Если установить внешнее соединение не удалось, то поднимается флаг Отказ.
//
Процедура ВыполнитьПроверкуУстановкиВнешнегоСоединения(Отказ, СтруктураНастроек, ОшибкаПодключенияКомпоненты = Ложь) Экспорт
	
	СтрокаСообщенияОбОшибке = "";
	
	// выполняем попытку установки внешнего соединения
	Результат = ОбменДаннымиСервер.УстановитьВнешнееСоединениеСБазой(СтруктураНастроек);
	// Выводим сообщение об ошибке
	Если Результат.Соединение = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.КраткоеОписаниеОшибки,,,, Отказ);
	КонецЕсли;
	ОшибкаПодключенияКомпоненты = Результат.ОшибкаПодключенияКомпоненты;
	
КонецПроцедуры

// Возвращает признак того, что набора записей регистра не содержит данных.
//
Функция НаборЗаписейРегистраПустой(СтруктураЗаписи, ИмяРегистра) Экспорт
	
	МетаданныеРегистра = Метаданные.РегистрыСведений[ИмяРегистра];
	
	// создаем набор записей регистра
	НаборЗаписей = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
	
	// устанавливаем отбор по измерениям регистра
	Для Каждого Измерение Из МетаданныеРегистра.Измерения Цикл
		
		// если задано значение в структуре, то отбор устанавливаем
		Если СтруктураЗаписи.Свойство(Измерение.Имя) Тогда
			
			НаборЗаписей.Отбор[Измерение.Имя].Установить(СтруктураЗаписи[Измерение.Имя]);
			
		КонецЕсли;
		
	КонецЦикла;
	
	НаборЗаписей.Прочитать();
	
	Возврат НаборЗаписей.Количество() = 0;
	
КонецФункции

// Возвращает ключ сообщения журнала регистрации по строке действия
//
Функция ПолучитьКлючСообщенияЖурналаРегистрацииПоСтрокеДействия(УзелИнформационнойБазы, ДействиеПриОбменеСтрокой) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиСервер.ПолучитьКлючСообщенияЖурналаРегистрации(УзелИнформационнойБазы, Перечисления.ДействияПриОбмене[ДействиеПриОбменеСтрокой]);
	
КонецФункции

// Возвращает структуру с данными отбора для журнала регистрации
//
Функция ПолучитьСтруктуруДанныхОтбораЖурналаРегистрации(УзелИнформационнойБазы, Знач ДействиеПриОбмене) Экспорт
	
	Если ТипЗнч(ДействиеПриОбмене) = Тип("Строка") Тогда
		
		ДействиеПриОбмене = Перечисления.ДействияПриОбмене[ДействиеПриОбмене];
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СостоянияОбменовДанными = ОбменДаннымиСервер.СостоянияОбменовДанными(УзелИнформационнойБазы, ДействиеПриОбмене);
	
	Отбор = Новый Структура;
	Отбор.Вставить("СобытиеЖурналаРегистрации", ОбменДаннымиСервер.ПолучитьКлючСообщенияЖурналаРегистрации(УзелИнформационнойБазы, ДействиеПриОбмене));
	Отбор.Вставить("ДатаНачала",                СостоянияОбменовДанными.ДатаНачала);
	Отбор.Вставить("ДатаОкончания",             СостоянияОбменовДанными.ДатаОкончания);
	
	Возврат Отбор;
КонецФункции

// Получает код предопределенного узла плана обмена
//
// Параметры:
//  ИмяПланаОбмена - Строка - имя плана обмена как оно задано в конфигураторе
// 
// Возвращаемое значение:
//  Строка - код предопределенного узла плана обмена
//
Функция ПолучитьКодЭтогоУзлаДляПланаОбмена(ИмяПланаОбмена) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиПовтИсп.ПолучитьКодЭтогоУзлаДляПланаОбмена(ИмяПланаОбмена);
КонецФункции

// Возвращает массив всех ссылочных типов, определенных в конфигурации
//
Функция ВсеСсылочныеТипыКонфигурации() Экспорт
	
	Возврат ОбменДаннымиПовтИсп.ВсеСсылочныеТипыКонфигурации();
	
КонецФункции

// Возвращает состояние выполнения фонового задания.
// Используется для реализации логики длительных операций.
//
// Параметры:
//  ИдентификаторЗадания - УникальныйИдентификатор - идентификатор фонового задания, для которого необходимо получить состояние.
// 
// Возвращаемое значение:
//  Строка - состояние выполнения фонового задания:
// "Активно" - задание выполняется;
// "Завершено" - задание выполнено успешно;
// "ЗавершеноАварийно" - задание завершено аварийно или отменено пользователем.
//
Функция СостояниеЗадания(Знач ИдентификаторЗадания) Экспорт
	
	Попытка
		Результат = ?(ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания), "Завершено", "Активно");
	Исключение
		Результат = "ЗавершеноАварийно";
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
		);
	КонецПопытки;
	
	Возврат Результат;
КонецФункции

// Получает состояние длительной операции (фонового задания), выполняемой в базе-корреспонденте.
//
Функция СостояниеДлительнойОперации(Знач ИдентификаторОперации,
									Знач URLВебСервиса,
									Знач ИмяПользователя,
									Знач Пароль,
									СтрокаСообщенияОбОшибке = ""
	) Экспорт
	
	Попытка
		
		ПараметрыПодключения = ОбменДаннымиСервер.СтруктураПараметровWS();
		ПараметрыПодключения.WSURLВебСервиса   = URLВебСервиса;
		ПараметрыПодключения.WSИмяПользователя = ИмяПользователя;
		ПараметрыПодключения.WSПароль          = Пароль;
		
		WSПрокси = ОбменДаннымиСервер.ПолучитьWSПрокси(ПараметрыПодключения, СтрокаСообщенияОбОшибке);
		
		Если WSПрокси = Неопределено Тогда
			ВызватьИсключение СтрокаСообщенияОбОшибке;
		КонецЕсли;
		
		Результат = WSПрокси.GetContinuousOperationStatus(ИдентификаторОперации, СтрокаСообщенияОбОшибке);
		
	Исключение
		Результат = "Failed";
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
		);
	КонецПопытки;
	
	Возврат Результат;
КонецФункции

// Получает состояние длительной операции (фонового задания), выполняемой в базе-корреспонденте для узла информационной базы.
//
Функция СостояниеДлительнойОперацииДляУзлаИнформационнойБазы(Знач ИдентификаторОперации,
									Знач УзелИнформационнойБазы,
									Знач ПараметрыАутентификации = Неопределено,
									СтрокаСообщенияОбОшибке = ""
	) Экспорт
	
	Попытка
		УстановитьПривилегированныйРежим(Истина);
		
		ПараметрыПодключения = РегистрыСведений.НастройкиТранспортаОбмена.НастройкиТранспортаWS(УзелИнформационнойБазы, ПараметрыАутентификации);
		
		WSПрокси = ОбменДаннымиСервер.ПолучитьWSПрокси(ПараметрыПодключения, СтрокаСообщенияОбОшибке);
		
		Если WSПрокси = Неопределено Тогда
			ВызватьИсключение СтрокаСообщенияОбОшибке;
		КонецЕсли;
		
		Результат = WSПрокси.GetContinuousOperationStatus(ИдентификаторОперации, СтрокаСообщенияОбОшибке);
		
	Исключение
		Результат = "Failed";
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
		);
	КонецПопытки;
	
	Возврат Результат;
КонецФункции

// Получает сообщение обмена из базы-корреспондента через веб-сервис.
// Сохраняет полученное сообщение обмена во временный каталог.
//
Функция ПолучитьСообщениеОбменаВоВременныйКаталогИзИнформационнойБазыКорреспондентаЧерезВебСервис(
											Отказ,
											УзелИнформационнойБазы,
											ИдентификаторФайла,
											ДлительнаяОперация,
											ИдентификаторОперации,
											Знач ПараметрыАутентификации = Неопределено
	) Экспорт
	
	Возврат ОбменДаннымиСервер.ПолучитьСообщениеОбменаВоВременныйКаталогИзИнформационнойБазыКорреспондентаЧерезВебСервис(
											Отказ,
											УзелИнформационнойБазы,
											ИдентификаторФайла,
											ДлительнаяОперация,
											ИдентификаторОперации,
											ПараметрыАутентификации);
КонецФункции

// Получает сообщение обмена из базы-корреспондента через веб-сервис.
// Сохраняет полученное сообщение обмена во временный каталог.
// Используется в том случае, если получение сообщения обмена выполнялось в контексте фонового задания в базе-корреспонденте.
//
Функция ПолучитьСообщениеОбменаВоВременныйКаталогИзИнформационнойБазыКорреспондентаЧерезВебСервисЗавершениеДлительнойОперации(
							Отказ,
							УзелИнформационнойБазы,
							ИдентификаторФайла,
							Знач ПараметрыАутентификации = Неопределено
	) Экспорт
	
	Возврат ОбменДаннымиСервер.ПолучитьСообщениеОбменаВоВременныйКаталогИзИнформационнойБазыКорреспондентаЧерезВебСервисЗавершениеДлительнойОперации(
							Отказ,
							УзелИнформационнойБазы,
							ИдентификаторФайла,
							ПараметрыАутентификации);
КонецФункции

// Возвращает признак изменения конфигурации для подчиненного узла распределенной ИБ.
//
Функция ТребуетсяУстановкаОбновления() Экспорт
	
	ОбменДаннымиСервер.ПроверитьВозможностьВыполненияОбменов();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиСервер.ТребуетсяУстановкаОбновления();
	
КонецФункции

// Удаляет информацию о проблемах записи объекта при его записи
//
Процедура ЗарегистрироватьУстранениеПроблемы(Источник, ТипПроблемы, Знач НовоеЗначениеПометкиУдаления) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбменДаннымиПовтИсп.ИспользуемыеПланыОбмена().Количество() > 0 Тогда
		
		НаборЗаписейКонфликта = РегистрыСведений.РезультатыОбменаДанными.СоздатьНаборЗаписей();
		НаборЗаписейКонфликта.Отбор.ПроблемныйОбъект.Установить(Источник);
		НаборЗаписейКонфликта.Отбор.ТипПроблемы.Установить(ТипПроблемы);
		
		НаборЗаписейКонфликта.Прочитать();
		
		Если НаборЗаписейКонфликта.Количество() = 1 Тогда
			
			Если НовоеЗначениеПометкиУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник, "ПометкаУдаления") Тогда
				
				НаборЗаписейКонфликта[0].ПометкаУдаления = НовоеЗначениеПометкиУдаления;
				НаборЗаписейКонфликта.Записать();
				
			Иначе
				
				НаборЗаписейКонфликта.Очистить();
				НаборЗаписейКонфликта.Записать();
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет удаление настройки синхронизации данных.
//
Процедура УдалитьНастройкуСинхронизации(Знач УзелИнформационнойБазы) Экспорт
	
	ОбменДаннымиСервер.ПроверитьВозможностьАдминистрированияОбменов();
	
	ОбъектУзла = УзелИнформационнойБазы.ПолучитьОбъект();
	Если ОбъектУзла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ОбъектУзла.Удалить();
	
КонецПроцедуры

Функция ВариантОбменаДанными(Знач Корреспондент) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиСервер.ВариантОбменаДанными(Корреспондент);
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обмен данными под полными правами

// Устанавливает параметры сеанса подсистемы обмена данными
//
// Параметры:
//  ИмяПараметра - Строка - имя параметра сеанса, значение которого необходимо установить
//  УстановленныеПараметры - массив - в данный параметр помещается информация об установленных параметрах сеанса
// 
Процедура УстановкаПараметровСеанса(ИмяПараметра, УстановленныеПараметры) Экспорт
	
	// Инициализация параметров сеанса должна выполняться без обращения к параметрам работы программы.
	
	Если ИмяПараметра = "РежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском" Тогда
		ПараметрыСеанса.РежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском = Новый ФиксированнаяСтруктура(Новый Структура);
		УстановленныеПараметры.Добавить("РежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском");
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		// процедура обновления повторно-используемых значений и параметров сеанса
		ОбновитьКэшМеханизмаРегистрацииОбъектов();
		
		// зарегистрируем имена параметров, которые установлены при 
		// выполнении ОбменДаннымиВызовСервера.ОбновитьКэшМеханизмаРегистрацииОбъектов
		УстановленныеПараметры.Добавить("ПравилаВыборочнойРегистрацииОбъектов");
		УстановленныеПараметры.Добавить("ПравилаРегистрацииОбъектов");
		УстановленныеПараметры.Добавить("ДатаОбновленияПовторноИспользуемыхЗначенийМРО");
		
		ПараметрыСеанса.ПаролиСинхронизацииДанных = Новый ФиксированноеСоответствие(Новый Соответствие);
		УстановленныеПараметры.Добавить("ПаролиСинхронизацииДанных");
		
		ПараметрыСеанса.ПриоритетныеДанныеОбмена = Новый ФиксированныйМассив(Новый Массив);
		УстановленныеПараметры.Добавить("ПриоритетныеДанныеОбмена");
		
		СтруктураПроверки =Новый Структура;
		СтруктураПроверки.Вставить("ПроверятьРасхождениеВерсий", Ложь);
		СтруктураПроверки.Вставить("ЕстьОшибка", Ложь);
		СтруктураПроверки.Вставить("ТекстОшибки", "");
		
		ПараметрыСеанса.ОшибкаРасхожденияВерсийПриПолученииДанных = Новый ФиксированнаяСтруктура(СтруктураПроверки);
		УстановленныеПараметры.Добавить("ОшибкаРасхожденияВерсийПриПолученииДанных");
		
	Иначе
		
		ПараметрыСеанса.ПаролиСинхронизацииДанных = Новый ФиксированноеСоответствие(Новый Соответствие);
		УстановленныеПараметры.Добавить("ПаролиСинхронизацииДанных");
		
	КонецЕсли;
	
КонецПроцедуры

// Проверяет режим запуска, устанавливает привилегированный режим и выполняет обработчик
//
Процедура ВыполнитьОбработчикВПривилегированномРежиме(Значение, Знач СтрокаОбработчика) Экспорт
	
	Если ТекущийРежимЗапуска() = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение Тогда
		ВызватьИсключение НСтр("ru = 'Метод не поддерживается в режиме управляемого приложения.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выполнить(СтрокаОбработчика);
	
КонецПроцедуры

// Находит регламентное задание по GUID
//
// Параметры:
//  УникальныйНомерЗадания - Строка - строка с GUID регламентного задания
// 
// Возвращаемое значение:
//  Неопределено        - если поиск регламентного задания по GUID не дал результатов или
//  РегламентноеЗадание - найденное по GUID регламентное задание.
//
Функция НайтиРегламентноеЗаданиеПоПараметру(Знач УникальныйНомерЗадания) Экспорт
	
	Если ПустаяСтрока(УникальныйНомерЗадания) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(УникальныйНомерЗадания));
КонецФункции

// Возвращает структуру со значениями свойств объекта, полученных запросом из ИБ.
// Ключ структуры - имя свойства; Значение - значение свойства объекта.
//
// Параметры:
//	Ссылка - ссылка на объект ИБ, значения свойств которого требуется получить
//
// Возвращаемое значение:
//	Структура - структура со значениями свойств объекта.
//
Функция ПолучитьЗначенияСвойствДляСсылки(Ссылка, СвойстваОбъекта, Знач СвойстваОбъектаСтрокой, Знач ОбъектМетаданныхИмя) Экспорт
	
	Если ТекущийРежимЗапуска() = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение Тогда
		ВызватьИсключение НСтр("ru = 'Метод не поддерживается в режиме управляемого приложения.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиСобытия.ПолучитьЗначенияСвойствДляСсылки(Ссылка, СвойстваОбъекта, СвойстваОбъектаСтрокой, ОбъектМетаданныхИмя);
КонецФункции

// Возвращает массив узлов плана обмена по заданным параметрам запроса и тексту запроса к таблице плана обмена
//
//
Функция МассивУзловПоЗначениямСвойств(ЗначенияСвойств, Знач ТекстЗапроса, Знач ИмяПланаОбмена, Знач ИмяРеквизитаФлага, Знач Выгрузка = Ложь) Экспорт
	
	Если ТекущийРежимЗапуска() = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение Тогда
		ВызватьИсключение НСтр("ru = 'Метод не поддерживается в режиме управляемого приложения.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиСобытия.МассивУзловПоЗначениямСвойств(ЗначенияСвойств, ТекстЗапроса, ИмяПланаОбмена, ИмяРеквизитаФлага, Выгрузка);
КонецФункции

// Возвращает значение параметра сеанса ПравилаРегистрацииОбъектов, полученное в привилегированном режиме.
//
// Возвращаемое значение:
//	ХранилищеЗначения - значение параметра сеанса ПравилаРегистрацииОбъектов.
//
Функция ПараметрыСеансаПравилаРегистрацииОбъектов() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ПараметрыСеанса.ПравилаРегистрацииОбъектов;
	
КонецФункции

// Функция возвращает список всех узлов заданного плана обмена кроме предопределенного узла
//
// Параметры:
//  ИмяПланаОбмена - Строка - имя плана обмена, как оно задано в конфигураторе, список узлов для которого необходимо получить
//
//  Возвращаемое значение:
//   Массив - список всех узлов заданного плана обмена.
//
Функция ВсеУзлыПланаОбмена(Знач ИмяПланаОбмена) Экспорт
	
	Если ТекущийРежимЗапуска() = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение Тогда
		ВызватьИсключение НСтр("ru = 'Метод не поддерживается в режиме управляемого приложения.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиПовтИсп.ПолучитьМассивУзловПланаОбмена(ИмяПланаОбмена);
	
КонецФункции

// Возвращает признак того, что для получателя зарегистрированы изменения данных
//
Функция ИзмененияЗарегистрированы(Знач Получатель) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1 1
	|ИЗ
	|	[Таблица].Изменения КАК ТаблицаИзменений
	|ГДЕ
	|	ТаблицаИзменений.Узел = &Узел";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Узел", Получатель);
	
	УстановитьПривилегированныйРежим(Истина);
	
	СоставПланаОбмена = Метаданные.ПланыОбмена[ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(Получатель)].Состав;
	
	Для Каждого ЭлементСостава Из СоставПланаОбмена Цикл
		
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "[Таблица]", ЭлементСостава.Метаданные.ПолноеИмя());
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если Не РезультатЗапроса.Пустой() Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
КонецФункции

// Возвращает признак использования плана обмена в обмене данными.
// Если план обмена содержит хотя бы один узел кроме предопределенного,
// то считается, что он используется.
//
// Параметры:
//	ИмяПланаОбмена - Строка - имя плана обмена, как оно задано в конфигураторе.
//
// Возвращаемое значение:
//	Булево - Истина, если план обмена используется, Ложь - нет.
//
Функция ОбменДаннымиВключен(Знач ИмяПланаОбмена, Знач Отправитель) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиПовтИсп.ОбменДаннымиВключен(ИмяПланаОбмена, Отправитель);
КонецФункции

// Получает массив узлов плана обмена, для которых установлен признак «Выгружать всегда»
//
// Параметры:
//	ИмяПланаОбмена    - Строка - имя плана обмена, как объекта метаданных, по которому определяются узлы
//	ИмяРеквизитаФлага - Строка - имя реквизита плана обмена, по которому устанавливается фильтр на выборку узлов 
//
// Возвращаемое значение:
//	Массив - узлы плана обмена, для которых установлен признак «Выгружать всегда»
//
Функция ПолучитьМассивУзловДляРегистрацииВыгружатьВсегда(Знач ИмяПланаОбмена, Знач ИмяРеквизитаФлага) Экспорт
	
	Если ТекущийРежимЗапуска() = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение Тогда
		ВызватьИсключение НСтр("ru = 'Метод не поддерживается в режиме управляемого приложения.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиСобытия.ПолучитьМассивУзловДляРегистрацииВыгружатьВсегда(ИмяПланаОбмена, ИмяРеквизитаФлага);
КонецФункции

// Получает массив узлов плана обмена, для которых установлен признак «Выгружать при необходимости»
//
// Параметры:
//	Ссылка - ссылка на объект ИБ, для которого необходимо получить массив узлов, в которые объект ранее выгружался
//	ИмяПланаОбмена    - Строка - имя плана обмена, как объекта метаданных, по которому определяются узлы
//	ИмяРеквизитаФлага - Строка - имя реквизита плана обмена, по которому устанавливается фильтр на выборку узлов 
//
// Возвращаемое значение:
//	Массив - узлы плана обмена, для которых установлен признак «Выгружать при необходимости»
//
Функция ПолучитьМассивУзловДляРегистрацииВыгружатьПриНеобходимости(Ссылка, Знач ИмяПланаОбмена, Знач ИмяРеквизитаФлага) Экспорт
	
	Если ТекущийРежимЗапуска() = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение Тогда
		ВызватьИсключение НСтр("ru = 'Метод не поддерживается в режиме управляемого приложения.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиСобытия.ПолучитьМассивУзловДляРегистрацииВыгружатьПриНеобходимости(Ссылка, ИмяПланаОбмена, ИмяРеквизитаФлага);
КонецФункции

// Возвращает признак режима загрузки параметров работы программы из сообщения обмена в информационную базу.
// Актуально для обмена в РИБ при загрузке данных в подчиненном узле РИБ.
//
Функция РежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском(Свойство) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ПараметрыСеанса.РежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском.Свойство(Свойство);
	
КонецФункции

// Возвращает признак ошибки при запуске:
// 1) Ошибка загрузки сообщения обмена:
//    - ошибка загрузки идентификаторов объектов метаданных при загрузке сообщения обмена,
//    - ошибка проверки идентификаторов объектов метаданных,
//    - ошибка загрузки сообщения обмена перед обновлением ИБ,
//    - ошибка загрузки сообщения обмена перед обновлением ИБ в режиме когда версия не изменилась;
// 2) Ошибка обновления ИБ после успешной загрузки сообщения обмена.
//
Функция ПовторитьЗагрузкуСообщенияОбменаДаннымиПередЗапуском() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Константы.ПовторитьЗагрузкуСообщенияОбменаДаннымиПередЗапуском.Получить() = Истина;
	
КонецФункции

// Возвращает список приоритетных данных обмена
//
// Возвращаемое значение:
//	Массив - коллекция ссылок на выгруженные приоритетные данные обмена.
//
Функция ПриоритетныеДанныеОбмена() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Массив;
	
	Для Каждого Элемент Из ПараметрыСеанса.ПриоритетныеДанныеОбмена Цикл
		
		Результат.Добавить(Элемент);
		
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Дополняет список приоритетных данных обмена переданным значением
//
Процедура ДополнитьПриоритетныеДанныеОбмена(Знач Данные) Экспорт
	
	Результат = ПриоритетныеДанныеОбмена();
	
	Результат.Добавить(Данные);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыСеанса.ПриоритетныеДанныеОбмена = Новый ФиксированныйМассив(Результат);
	
КонецПроцедуры

// Очищает список приоритетных данных обмена
//
Процедура ОчиститьПриоритетныеДанныеОбмена() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыСеанса.ПриоритетныеДанныеОбмена = Новый ФиксированныйМассив(Новый Массив);
	
КонецПроцедуры

// Получает список метаданных объектов узла, для которых не разрешена выгрузка.
// Выгрузка не разрешена, если в правилах регистрации объектов плана обмена таблица отмечена как НеВыгружать
//
// Параметры:
//     УзелИнформационнойБазы - ПланОбменаСсылка - ссылка на анализируемый узел плана обмена
//
// Возвращаемое значение:
//     Массив, содержащий полные имена объектов метаданных
//
Функция ИменаМетаданныхНеВыгружаемыхОбъектовУзла(Знач УзелИнформационнойБазы) Экспорт
	Результат = Новый Массив;
	
	РежимНеВыгружать = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
	РежимыВыгрузки   = ОбменДаннымиПовтИсп.ПользовательскийСоставПланаОбмена(УзелИнформационнойБазы);
	Для Каждого КлючЗначение Из РежимыВыгрузки Цикл
		Если КлючЗначение.Значение=РежимНеВыгружать Тогда
			Результат.Добавить(КлючЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Создает запрос на очистку разрешений для узла (при удалении)
//
Функция ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов(Знач УзелИнформационнойБазы) Экспорт
	
	Запрос = РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов(УзелИнформационнойБазы);
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Запрос);
	
КонецФункции

#КонецОбласти
