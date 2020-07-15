﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(МассивРассылок, Параметры)
	Если ТипЗнч(МассивРассылок) <> Тип("Массив") ИЛИ МассивРассылок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Форма = Параметры.Источник;
	
	ДополнительныеПараметры = Новый Структура("МассивРассылок, Форма, ЭтоФормаЭлемента");
	ДополнительныеПараметры.МассивРассылок = МассивРассылок;
	ДополнительныеПараметры.Форма = Форма;
	ДополнительныеПараметры.ЭтоФормаЭлемента = (Форма.ИмяФормы = "Справочник.РассылкиОтчетов.Форма.ФормаЭлемента");
	Обработчик = Новый ОписаниеОповещения("ВыполнитьСейчасЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	Если ДополнительныеПараметры.ЭтоФормаЭлемента Тогда
		Если НЕ Форма.Объект.Подготовлена Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Рассылка не подготовлена'"));
			Возврат;
		КонецЕсли;
		
		Если Форма.Объект.ИспользоватьЭлектроннуюПочту Тогда
			РассылкаОтчетовКлиент.ВыбратьПолучателя(Обработчик, Форма.Объект, Истина, Истина);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Обработчик, Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСейчасЗавершение(Получатели, ДополнительныеПараметры) Экспорт
	// Обработчик результата работы процедуры ВыполнитьСейчас.
	
	Форма = ДополнительныеПараметры.Форма;
	
	ПредварительныеНастройки = Неопределено;
	
	Если ДополнительныеПараметры.ЭтоФормаЭлемента Тогда
		Если Форма.Объект.ИспользоватьЭлектроннуюПочту Тогда
			Если Получатели = Неопределено Тогда
				Возврат;
			КонецЕсли;
			ПредварительныеНастройки = Новый Структура("Получатели", Получатели);
		КонецЕсли;
		ТекстСостояния = НСтр("ru = 'Выполняется рассылка отчетов'");
	Иначе
		ТекстСостояния = НСтр("ru = 'Выполняются рассылки отчетов'");
	КонецЕсли;
	
	Состояние(ТекстСостояния, , , );
	
	ПараметрыВызоваСервера = Новый Структура;
	ПараметрыВызоваСервера.Вставить("МассивРассылок", ДополнительныеПараметры.МассивРассылок);
	ПараметрыВызоваСервера.Вставить("ПредварительныеНастройки", ПредварительныеНастройки);
	
	Результат = ВыполнитьРассылкиВФоновомЗадании(ПараметрыВызоваСервера, Форма.УникальныйИдентификатор);
	
	Если Результат.Статус = "ВыполненоУспешно" Тогда
		СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(Форма, Результат.Детали);
	ИначеЕсли Результат.Статус = "Исключение" Тогда
		ТекстПредупреждения = НСтр("ru = 'Не удалось выполнить рассылку отчетов.
		|Подробности см. в журнале регистрации.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
	ИначеЕсли Результат.Статус = "Выполняется" Тогда
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(Форма, Результат.Детали.ИдентификаторЗадания);
		
		ПараметрыОбработчика = Неопределено;
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчика);
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчика);
		
		Форма.ПараметрыФоновогоЗадания.Очистить();
		Форма.ПараметрыФоновогоЗадания.Добавить(Результат.Детали.ИдентификаторЗадания);
		Форма.ПараметрыФоновогоЗадания.Добавить(Результат.Детали.АдресХранилища);
		Форма.ПараметрыФоновогоЗадания.Добавить(ПараметрыОбработчика);
		Форма.ПараметрыФоновогоЗадания.Добавить(ФормаДлительнойОперации);
		
		Форма.ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеФоновогоЗадания", ПараметрыОбработчика.ТекущийИнтервал, Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ВыполнитьРассылкиВФоновомЗадании(ПараметрыВызоваСервера, Знач УникальныйИдентификатор)
	// Запускает выполнение рассылок отчетов в фоновом задании.
	
	Результат = Новый Структура("Статус, Детали");
	
	Попытка
		Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
			РезультатФоновогоЗадания = Новый Структура("ЗаданиеВыполнено, АдресХранилища");
			РезультатФоновогоЗадания.ЗаданиеВыполнено = Истина;
			РезультатФоновогоЗадания.АдресХранилища   = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
			
			РассылкаОтчетов.ВыполнитьРассылкиВФоновомЗадании(ПараметрыВызоваСервера, РезультатФоновогоЗадания.АдресХранилища);
		Иначе
			РезультатФоновогоЗадания = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
				УникальныйИдентификатор,
				"РассылкаОтчетов.ВыполнитьРассылкиВФоновомЗадании", 
				ПараметрыВызоваСервера, 
				НСтр("ru = 'Рассылки отчетов: Выполнение рассылок в фоне'"));
		КонецЕсли;
		
		Если РезультатФоновогоЗадания.ЗаданиеВыполнено Тогда
			Результат.Статус = "ВыполненоУспешно"; // Не локализуется
			Результат.Детали = ПолучитьИзВременногоХранилища(РезультатФоновогоЗадания.АдресХранилища);
		Иначе
			Результат.Статус = "Выполняется"; // Не локализуется
			Результат.Детали = Новый Структура("ИдентификаторЗадания, АдресХранилища");
			ЗаполнитьЗначенияСвойств(Результат.Детали, РезультатФоновогоЗадания);
		КонецЕсли;
	Исключение
		Результат.Статус = "Исключение"; // Не локализуется
	КонецПопытки;
	
	Возврат Результат;
КонецФункции

#КонецОбласти
