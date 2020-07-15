﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Или ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
		Возврат; // Отказ устанавливается в ПриОткрытии().
	КонецЕсли;
	
	ИнтервалВремениВыполнения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("АвтоматическоеИзвлечениеТекстов", "ИнтервалВремениВыполнения");
	Если ИнтервалВремениВыполнения = 0 Тогда
		ИнтервалВремениВыполнения = 60;
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("АвтоматическоеИзвлечениеТекстов", "ИнтервалВремениВыполнения",  ИнтервалВремениВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, НСтр("ru = 'Извлечение текстов не поддерживается в Веб-клиенте.'"));
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
		Отказ = Истина;
		ТекстСообщения = НСтр("ru = 'Извлечение текстов не поддерживается в клиенте под управлением ОС Linux.'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;

	// Здесь ТекущаяДата не пишется в базу, а используется только на клиенте
	// в информационных целях, поэтому заменять на ТекущаяДатаСеанса не надо.
	ПрогнозируемоеВремяНачалаИзвлечения = ТекущаяДата() + ИнтервалВремениВыполнения;
	ПодключитьОбработчикОжидания("ИзвлечениеТекстовКлиентОбработчик", ИнтервалВремениВыполнения);
	
	ПодключитьОбработчикОжидания("ОбновлениеОбратногоОтсчета", 1);
	ОбновлениеОбратногоОтсчета();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнтервалВремениВыполненияПриИзменении(Элемент)
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("АвтоматическоеИзвлечениеТекстов", "ИнтервалВремениВыполнения",  ИнтервалВремениВыполнения);
	ОтключитьОбработчикОжидания("ИзвлечениеТекстовКлиентОбработчик");
	
	// Здесь ТекущаяДата не пишется в базу, а используется только на клиенте
	// в информационных целях, поэтому заменять на ТекущаяДатаСеанса не надо.
	ПрогнозируемоеВремяНачалаИзвлечения = ТекущаяДата() + ИнтервалВремениВыполнения;
	
	ПодключитьОбработчикОжидания("ИзвлечениеТекстовКлиентОбработчик", ИнтервалВремениВыполнения);
	ОбновлениеОбратногоОтсчета();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗапуститьСейчас(Команда)
#Если НЕ ВебКлиент Тогда
	ИзвлечениеТекстовКлиентОбработчик();
#КонецЕсли
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ЗаписьЖурналаРегистрацииСервер(ТекстСообщения)
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Файлы.Извлечение текста'",
		     ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка,
		,
		,
		ТекстСообщения);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьВсеИспользуемыеОбластиДанных()
	
	МассивОбластейДанных = Новый Массив;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОбластиДанных.ОбластьДанныхВспомогательныеДанные КАК ОбластьДанных
	               |ИЗ
	               |	РегистрСведений.ОбластиДанных КАК ОбластиДанных
	               |ГДЕ
	               |	ОбластиДанных.Статус = &Статус";
	
	Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыОбластейДанных.Используется);
	
	Для Каждого Строка Из Запрос.Выполнить().Выгрузить() Цикл
		МассивОбластейДанных.Добавить(Строка.ОбластьДанных);
	КонецЦикла;
	
	Возврат МассивОбластейДанных;
	
КонецФункции

// Обновляет обратный отсчет
//
&НаКлиенте
Процедура ОбновлениеОбратногоОтсчета()
	
	// Здесь ТекущаяДата не пишется в базу, а используется только на клиенте
	// в информационных целях, поэтому заменять на ТекущаяДатаСеанса не надо.
	Осталось = ПрогнозируемоеВремяНачалаИзвлечения - ТекущаяДата();
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'До начала извлечения текстов осталось %1 сек'"),
		Осталось);
	
	Если Осталось <= 1 Тогда
		ТекстСообщения = "";
	КонецЕсли;
	
	ИнтервалВремениВыполнения = Элементы.ИнтервалВремениВыполнения.ТекстРедактирования;
	Статус = ТекстСообщения;
	
КонецПроцедуры

#Если НЕ ВебКлиент Тогда

// Извлекает текст из файлов на диске на клиенте.
//
&НаКлиенте
Процедура ИзвлечениеТекстовКлиентОбработчик()
	ИзвлечениеТекстовКлиент();
КонецПроцедуры

// Извлекает текст из файлов на диске на клиенте.
//
&НаКлиенте
Процедура ИзвлечениеТекстовКлиент()
	
	МассивОбластейДанных = ПолучитьВсеИспользуемыеОбластиДанных();
	
	Попытка
	
		ПолноеКоличествоФайловСНеизвлеченнымТекстом = 0;
		ЧислоНеизвлеченныхДляОбластей = Новый Соответствие;
		
		// В первую очередь выполняется подсчет количества файлов
		// с неизвлеченным текстом во всех областях.
		Для Каждого Область Из МассивОбластейДанных Цикл
			
			ОбщегоНазначенияВызовСервера.УстановитьРазделениеСеанса(Истина, Область);
			КоличествоФайловСНеизвлеченнымТекстом = 0;
			
			ПолучитьКоличествоВерсийСНеизвлеченнымТекстом(КоличествоФайловСНеизвлеченнымТекстом);
			
			ПолноеКоличествоФайловСНеизвлеченнымТекстом = ПолноеКоличествоФайловСНеизвлеченнымТекстом + КоличествоФайловСНеизвлеченнымТекстом;
			ЧислоНеизвлеченныхДляОбластей.Вставить(Область, КоличествоФайловСНеизвлеченнымТекстом);
			ОбщегоНазначенияВызовСервера.УстановитьРазделениеСеанса(Ложь);
		
		КонецЦикла;
		
		КоличествоВПорции = 100;
		
		// Вызов исключения для каждой области.
		КоличествоОбластей = МассивОбластейДанных.Количество();
		Для Каждого Область Из МассивОбластейДанных Цикл
			
			ЧислоНеизвлеченных = ЧислоНеизвлеченныхДляОбластей.Получить(Область);
			Если ЧислоНеизвлеченных <> Неопределено И ЧислоНеизвлеченных <> 0 Тогда
				
				РазмерПорцииДляОбласти = Окр((ЧислоНеизвлеченных / ПолноеКоличествоФайловСНеизвлеченнымТекстом)	* КоличествоВПорции);
				Если РазмерПорцииДляОбласти = 0 Тогда
					РазмерПорцииДляОбласти = 1;
				КонецЕсли;
			
				ОбщегоНазначенияВызовСервера.УстановитьРазделениеСеанса(Истина, Область);
				ИзвлечениеТекстовОднойОбластиДанных(РазмерПорцииДляОбласти);
				ОбщегоНазначенияВызовСервера.УстановитьРазделениеСеанса(Ложь);
			КонецЕсли;
		
		КонецЦикла;
		
		// Возврат в неразделенный режим.
		ОбщегоНазначенияВызовСервера.УстановитьРазделениеСеанса(Ложь);
	
	Исключение
	
		// Возврат в неразделенный режим.
		ОбщегоНазначенияВызовСервера.УстановитьРазделениеСеанса(Ложь);
		ВызватьИсключение;
	
	КонецПопытки;
	
КонецПроцедуры

// Извлекает текст из файлов на диске на клиенте.
//
// Параметры:
// РазмерПорции - Число - Количество файлов в порции.
//
&НаКлиенте
Процедура ИзвлечениеТекстовОднойОбластиДанных(РазмерПорции = Неопределено)
	
	// Здесь ТекущаяДата() не пишется в базу, показывается только на клиенте
	// в информационных целях - поэтому не нужно заменять на ТекущаяДатаСеанса.
	ПрогнозируемоеВремяНачалаИзвлечения = ТекущаяДата() + ИнтервалВремениВыполнения;
	
	Состояние(НСтр("ru = 'Начато извлечение текста'"));
	
	Попытка
		
		РазмерПорцииТекущий = 100;
		Если РазмерПорции <> Неопределено Тогда
			РазмерПорцииТекущий = РазмерПорции;
		КонецЕсли;
		
		МассивФайлов = ПолучитьФайлыДляИзвлеченияТекста(РазмерПорцииТекущий);
		
		Если МассивФайлов.Количество() = 0 Тогда
			Состояние(НСтр("ru = 'Нет файлов для извлечения текста'"));
			Возврат;
		КонецЕсли;
		
		Для Индекс = 0 По МассивФайлов.Количество() - 1 Цикл
			
			Расширение = МассивФайлов[Индекс].Расширение;
			ФайлИлиВерсияФайла = МассивФайлов[Индекс].Ссылка;
			
			АдресФайла = ПолучитьНавигационнуюСсылкуФайла(
				ФайлИлиВерсияФайла, УникальныйИдентификатор);
			
			Прогресс = Индекс * 100 / МассивФайлов.Количество();
			Состояние(НСтр("ru = 'Идет извлечение текста файла'"), Прогресс, Строка(ФайлИлиВерсияФайла));
			
			ФайловыеФункцииСлужебныйКлиент.ИзвлечьТекстВерсии(
				ФайлИлиВерсияФайла, АдресФайла, Расширение, УникальныйИдентификатор);
		КонецЦикла;
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Извлечение текста завершено.
			           |Обработано файлов: %1'"),
			МассивФайлов.Количество());
		
		Состояние(ТекстСообщения);
		
	Исключение
		
		ОписаниеОшибкиИнфо = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Во время извлечения текста из файла ""%1""
			           |произошла неизвестная ошибка.'"), 
			Строка(ФайлИлиВерсияФайла));
		
		ТекстСообщения = ТекстСообщения + Строка(ОписаниеОшибкиИнфо);
		
		Состояние(ТекстСообщения);
		
		ЗаписьЖурналаРегистрацииСервер(ТекстСообщения);
		
	КонецПопытки;
	
КонецПроцедуры

#КонецЕсли

&НаСервереБезКонтекста
Функция ПолучитьФайлыДляИзвлеченияТекста(КоличествоФайловВПорции)
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос;
	ПолучитьВсеФайлы = (КоличествоФайловВПорции = 0);
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.ФайловыеФункции\ПриОпределенииТекстаЗапросаДляИзвлеченияТекста");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриОпределенииТекстаЗапросаДляИзвлеченияТекста(Запрос.Текст, ПолучитьВсеФайлы);
	КонецЦикла;
	
	Для Каждого Строка Из Запрос.Выполнить().Выгрузить() Цикл
		
		Результат.Добавить(Новый Структура("Ссылка, Расширение", Строка.Ссылка, Строка.Расширение));
		
		// если превысили нужное количество результатов, выходим
		Если КоличествоФайловВПорции <> 0 И Результат.Количество() >= КоличествоФайловВПорции Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьНавигационнуюСсылкуФайла(Знач ФайлИлиВерсияФайла, Знач УникальныйИдентификатор)
	
	НавигационнаяСсылкаФайла = Неопределено;
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.ФайловыеФункции\ПриОпределенииНавигационнойСсылкиФайла");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриОпределенииНавигационнойСсылкиФайла(
			ФайлИлиВерсияФайла, УникальныйИдентификатор, НавигационнаяСсылкаФайла);
	КонецЦикла;
	
	Возврат НавигационнаяСсылкаФайла;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ПолучитьКоличествоВерсийСНеизвлеченнымТекстом(КоличествоФайловСНеизвлеченнымТекстом)
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.ФайловыеФункции\ПриОпределенииКоличестваВерсийСНеизвлеченнымТекстом");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриОпределенииКоличестваВерсийСНеизвлеченнымТекстом(
			КоличествоФайловСНеизвлеченнымТекстом);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
