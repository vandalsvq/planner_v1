﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает структуру параметров, необходимых для работы
// конфигурации на клиенте при запуске, т.е. в обработчиках событий
// - ПередНачаломРаботыСистемы,
// - ПриНачалеРаботыСистемы
//
// Важно: при запуске недопустимо использовать команды сброса кэша
// повторно используемых модулей, иначе запуск может привести
// к непредсказуемым ошибкам и лишним серверным вызовам
// 
// Возвращаемое значение:
//   ФиксированнаяСтруктура - структура параметров работы клиента при запуске.
//
Функция ПараметрыРаботыКлиентаПриЗапуске() Экспорт
	
	Если ТипЗнч(ПараметрыПриЗапускеИЗавершенииПрограммы) <> Тип("Структура") Тогда
		ПараметрыПриЗапускеИЗавершенииПрограммы = Новый Структура;
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("ПолученныеПараметрыКлиента", Неопределено);
	
	Если ПараметрыПриЗапускеИЗавершенииПрограммы.Свойство("ПолученныеПараметрыКлиента")
	   И ТипЗнч(ПараметрыПриЗапускеИЗавершенииПрограммы.ПолученныеПараметрыКлиента) = Тип("Структура") Тогда
		
		Параметры.Вставить("ПолученныеПараметрыКлиента",
			ПараметрыПриЗапускеИЗавершенииПрограммы.ПолученныеПараметрыКлиента);
	КонецЕсли;
	
	Если ПараметрыПриЗапускеИЗавершенииПрограммы.Свойство("ПропуститьОчисткуСкрытияРабочегоСтола") Тогда
		Параметры.Вставить("ПропуститьОчисткуСкрытияРабочегоСтола");
	КонецЕсли;
	
#Если ВебКлиент Тогда
	ЭтоВебКлиент = Истина;
#Иначе
	ЭтоВебКлиент = Ложь;
#КонецЕсли
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтоLinuxКлиент = СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86
	              ИЛИ СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86_64;

	Параметры.Вставить("ПараметрЗапуска", ПараметрЗапуска);
	Параметры.Вставить("СтрокаСоединенияИнформационнойБазы", СтрокаСоединенияИнформационнойБазы());
	Параметры.Вставить("ЭтоВебКлиент",    ЭтоВебКлиент);
	Параметры.Вставить("ЭтоLinuxКлиент", ЭтоLinuxКлиент);
	Параметры.Вставить("СкрытьРабочийСтолПриНачалеРаботыСистемы", Ложь);
	
	ПараметрыКлиента = СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиентаПриЗапуске(Параметры);
	
	// Обновление состояния скрытия рабочего стола на клиенте по состоянию на сервере.
	СтандартныеПодсистемыКлиент.СкрытьРабочийСтолПриНачалеРаботыСистемы(
		Параметры.СкрытьРабочийСтолПриНачалеРаботыСистемы, Истина);
	
	Возврат ПараметрыКлиента;
	
КонецФункции

// Возвращает структуру параметров, необходимых для работы
// конфигурации на клиенте.
// 
// Возвращаемое значение:
//   ФиксированнаяСтруктура - структура параметров работы клиента при запуске.
//
Функция ПараметрыРаботыКлиента() Экспорт
	
	#Если ТонкийКлиент Тогда 
		ИмяИсполняемогоФайлаКлиента = "1cv8c.exe";
	#Иначе
		ИмяИсполняемогоФайлаКлиента = "1cv8.exe";
	#КонецЕсли
	
	ТекущаяДата = ТекущаяДата(); // текущая дата клиентского компьютера
	
	ПараметрыРаботыКлиента = Новый Структура;
	ПараметрыРаботы = СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиента();
	Для Каждого Параметр Из ПараметрыРаботы Цикл
		ПараметрыРаботыКлиента.Вставить(Параметр.Ключ, Параметр.Значение);
	КонецЦикла;
	ПараметрыРаботыКлиента.ПоправкаКВремениСеанса = ПараметрыРаботыКлиента.ПоправкаКВремениСеанса - ТекущаяДата;
	ПараметрыРаботыКлиента.Вставить("ИмяИсполняемогоФайлаКлиента", ИмяИсполняемогоФайлаКлиента);
	
	Возврат Новый ФиксированнаяСтруктура(ПараметрыРаботыКлиента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает массив описаний обработчиков клиентского события.
Функция ОбработчикиКлиентскогоСобытия(Событие, Служебное = Ложь) Экспорт
	
	ПодготовленныеОбработчики = ПодготовленныеОбработчикиКлиентскогоСобытия(Событие, Служебное);
	
	Если ПодготовленныеОбработчики = Неопределено Тогда
		// Автообновление кэша. Обновление повторно используемых значений требуется.
		СтандартныеПодсистемыВызовСервера.ПриОшибкеПолученияОбработчиковСобытия();
		ОбновитьПовторноИспользуемыеЗначения();
		// Повторная попытка получить обработчики события.
		ПодготовленныеОбработчики = ПодготовленныеОбработчикиКлиентскогоСобытия(Событие, Служебное, Ложь);
	КонецЕсли;
	
	Возврат ПодготовленныеОбработчики;
	
КонецФункции

// Возвращает соответствие имен и клиентских модулей.
Функция ИменаКлиентскихМодулей() Экспорт
	
	МассивИмен = СтандартныеПодсистемыВызовСервера.МассивИменКлиентскихМодулей();
	
	КлиентскиеМодули = Новый Соответствие;
	
	Для каждого Имя Из МассивИмен Цикл
		КлиентскиеМодули.Вставить(Вычислить(Имя), Имя);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(КлиентскиеМодули);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с предопределенными данными

// Получает ссылку предопределенного элемента по его полному имени.
//  Подробнее - см. ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент();
//
Функция ПредопределенныйЭлемент(Знач ПолноеИмяПредопределенного) Экспорт
	
	Возврат СтандартныеПодсистемыВызовСервера.ПредопределенныйЭлемент(ПолноеИмяПредопределенного);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПодготовленныеОбработчикиКлиентскогоСобытия(Событие, Служебное = Ложь, ПерваяПопытка = Истина)
	
	Параметры = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске(
		).ОбработчикиКлиентскихСобытий;
	
	Если Служебное Тогда
		Обработчики = Параметры.ОбработчикиСлужебныхСобытий.Получить(Событие);
	Иначе
		Обработчики = Параметры.ОбработчикиСобытий.Получить(Событие);
	КонецЕсли;
	
	Если ПерваяПопытка И Обработчики = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Обработчики = Неопределено Тогда
		Если Служебное Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не найдено клиентское служебное событие ""%1"".'"), Событие);
		Иначе
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не найдено клиентское событие ""%1"".'"), Событие);
		КонецЕсли;
	КонецЕсли;
	
	Массив = Новый Массив;
	
	Для каждого Обработчик Из Обработчики Цикл
		Элемент = Новый Структура;
		Модуль = Неопределено;
		Если ПерваяПопытка Тогда
			Попытка
				Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль(Обработчик.Модуль);
			Исключение
				Возврат Неопределено;
			КонецПопытки;
		Иначе
			Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль(Обработчик.Модуль);
		КонецЕсли;
		Элемент.Вставить("Модуль",     Модуль);
		Элемент.Вставить("Версия",     Обработчик.Версия);
		Элемент.Вставить("Подсистема", Обработчик.Подсистема);
		Массив.Добавить(Новый ФиксированнаяСтруктура(Элемент));
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(Массив);
	
КонецФункции

#КонецОбласти
