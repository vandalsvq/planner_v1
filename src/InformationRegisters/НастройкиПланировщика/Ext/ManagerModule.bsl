﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
 
Функция ПолучитьЗначенияНастроек(знач ПользовательСсылка = Неопределено) Экспорт
	Если НЕ ТипЗнч(ПользовательСсылка) = Тип("СправочникСсылка.Пользователи") Тогда
		ПользовательСсылка = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	НастройкиПользователей = Перечисления.ВидыНастроекПланировщика.ПолучитьНастройкиПользователей();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Настройки"		, НастройкиПользователей);
	Запрос.УстановитьПараметр("Пользователь"	, ПользовательСсылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкиПланировщика.Настройка,
	|	НастройкиПланировщика.Подсистема,
	|	НастройкиПланировщика.Пользователь,
	|	НастройкиПланировщика.ЗначениеСтрока,
	|	НастройкиПланировщика.ЗначениеЧисло,
	|	НастройкиПланировщика.ЗначениеДата,
	|	НастройкиПланировщика.ЗначениеСсылка,
	|	НастройкиПланировщика.ЗначениеБулево,
	|	НастройкиПланировщика.ИмяРесурса
	|ИЗ
	|	РегистрСведений.НастройкиПланировщика КАК НастройкиПланировщика
	|ГДЕ
	|	НастройкиПланировщика.Настройка В (&Настройки)
	|	И НастройкиПланировщика.Пользователь = &Пользователь";
	
	Соответствие = Новый Соответствие;
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Настройка			= Выборка.Настройка;		
		ЗначениеНастройки	= Выборка[Выборка.ИмяРесурса];
		
		НормализоватьЗначение(Настройка, ЗначениеНастройки);
		Соответствие.Вставить(Настройка, ЗначениеНастройки);
	КонецЦикла;
	
	// Дополним соответствие всеми настройками
	Для Каждого НастройкаСсылка Из НастройкиПользователей Цикл
		Если Соответствие.Получить(НастройкаСсылка) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЗначениеНастройки = Неопределено;
		
		НормализоватьЗначение(НастройкаСсылка, ЗначениеНастройки);
		Соответствие.Вставить(НастройкаСсылка, ЗначениеНастройки);
	КонецЦикла;
	
	Возврат Соответствие;
КонецФункции

Функция ПолучитьЗначениеНастройки(знач Настройка, знач ПользовательСсылка = Неопределено) Экспорт
	
	ПустойПользователь = Справочники.Пользователи.ПустаяСсылка();
	Если НЕ ТипЗнч(ПользовательСсылка) = Тип("СправочникСсылка.Пользователи") Тогда
		ПользовательСсылка = ПустойПользователь;
	КонецЕсли;
	
	ПараметрыНастройки = Перечисления.ВидыНастроекПланировщика.ПолучитьДанныеНастройки(Настройка);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Настройка"		, Настройка);
	Запрос.УстановитьПараметр("Подсистема"		, ПараметрыНастройки.Подсистема);
	Запрос.УстановитьПараметр("Пользователь"	, ?(ПараметрыНастройки.Пользователь, ПользовательСсылка, ПустойПользователь));
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкиПланировщика.Настройка,
	|	НастройкиПланировщика.Подсистема,
	|	НастройкиПланировщика.Пользователь,
	|	НастройкиПланировщика.ЗначениеСтрока,
	|	НастройкиПланировщика.ЗначениеЧисло,
	|	НастройкиПланировщика.ЗначениеДата,
	|	НастройкиПланировщика.ЗначениеСсылка,
	|	НастройкиПланировщика.ЗначениеБулево,
	|	НастройкиПланировщика.ИмяРесурса
	|ИЗ
	|	РегистрСведений.НастройкиПланировщика КАК НастройкиПланировщика
	|ГДЕ
	|	НастройкиПланировщика.Настройка = &Настройка
	|	И НастройкиПланировщика.Подсистема = &Подсистема
	|	И НастройкиПланировщика.Пользователь = &Пользователь";
	
	ЗначениеНастройки = Неопределено;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();  
		
		ЗначениеНастройки = Выборка[Выборка.ИмяРесурса];
	КонецЕсли;
	
	НормализоватьЗначение(Настройка, ЗначениеНастройки);
	
	Возврат ЗначениеНастройки;
КонецФункции

Процедура НормализоватьЗначение(Настройка, Значение) Экспорт
	
	Если Настройка = Перечисления.ВидыНастроекПланировщика.НачалоРабочегоВремени Тогда
		Если НЕ ТипЗнч(Значение) = Тип("Число") ИЛИ Значение < 0 Тогда
			Значение = 0;
		КонецЕсли;
	ИначеЕсли Настройка = Перечисления.ВидыНастроекПланировщика.ОкончаниеРабочегоВремени Тогда
		Если НЕ ТипЗнч(Значение) = Тип("Число") ИЛИ Значение > 24 Тогда
			Значение = 24;
		КонецЕсли;
	ИначеЕсли Настройка = Перечисления.ВидыНастроекПланировщика.ИспользоватьDHTMLX Тогда
		Если НЕ ТипЗнч(Значение) = Тип("Булево") Тогда
			Значение = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли 
