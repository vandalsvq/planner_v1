﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		Элементы.ФормаУстановкаПометкиУдаления.ТолькоВоВсехДействиях = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьСнятьПометкуУдаления(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НачатьИзменениеПометкиУдаления(Элементы.Список.ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НачатьИзменениеПометкиУдаления(ТекущиеДанные)
	
	Если ТекущиеДанные.ПометкаУдаления Тогда
		ТекстВопроса = НСтр("ru = 'Снять с ""%1"" пометку на удаление?'");
	Иначе
		ТекстВопроса = НСтр("ru = 'Пометить ""%1"" на удаление?'");
	КонецЕсли;
	
	СодержимоеВопроса = Новый Массив;
	СодержимоеВопроса.Добавить(БиблиотекаКартинок.Вопрос32);
	СодержимоеВопроса.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстВопроса, ТекущиеДанные.Наименование));
	
	ПоказатьВопрос(
		Новый ОписаниеОповещения("ПродолжитьИзменениеПометкиУдаления", ЭтотОбъект, ТекущиеДанные),
		Новый ФорматированнаяСтрока(СодержимоеВопроса),
		РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьИзменениеПометкиУдаления(Ответ, ТекущиеДанные) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Том = Элементы.Список.ТекущиеДанные.Ссылка;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Том", Элементы.Список.ТекущиеДанные.Ссылка);
	ДополнительныеПараметры.Вставить("ПометкаУдаления", Неопределено);
	ДополнительныеПараметры.Вставить("Запросы", Новый Массив());
	ДополнительныеПараметры.Вставить("ИдентификаторФормы", УникальныйИдентификатор);
	
	ПодготовкаКУстановкеСнятиюПометкиУдаления(Том, ДополнительныеПараметры);
	
	РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(
		ДополнительныеПараметры.Запросы, ЭтотОбъект, Новый ОписаниеОповещения(
			"ПродолжитьУстановкуСнятиеПометкиУдаления", ЭтотОбъект, ДополнительныеПараметры));
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПодготовкаКУстановкеСнятиюПометкиУдаления(Том, ДополнительныеПараметры)
	
	ЗаблокироватьДанныеДляРедактирования(Том, , ДополнительныеПараметры.ИдентификаторФормы);
	
	СвойстваТома = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Том, "ПометкаУдаления,ПолныйПутьWindows,ПолныйПутьLinux");
	
	ДополнительныеПараметры.ПометкаУдаления = СвойстваТома.ПометкаУдаления;
	
	Если ДополнительныеПараметры.ПометкаУдаления Тогда
		// Пометка удаления установлена, ее требуется снять
		
		Запрос = Справочники.ТомаХраненияФайлов.ЗапросНаИспользованиеВнешнихРесурсовДляТома(
			Том, СвойстваТома.ПолныйПутьWindows, СвойстваТома.ПолныйПутьLinux);
	Иначе
		// Пометка удаления не установлена, ее требуется установить
		Запрос = РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов(Том)
	КонецЕсли;
	
	ДополнительныеПараметры.Запросы.Добавить(Запрос);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьУстановкуСнятиеПометкиУдаления(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		
		ЗавершитьУстановкуСнятиеПометкиУдаления(ДополнительныеПараметры);
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗавершитьУстановкуСнятиеПометкиУдаления(ДополнительныеПараметры)
	
	Объект = ДополнительныеПараметры.Том.ПолучитьОбъект();
	Объект.УстановитьПометкуУдаления(Не ДополнительныеПараметры.ПометкаУдаления);
	Объект.Записать();
	
	РазблокироватьДанныеДляРедактирования(
	ДополнительныеПараметры.Том, ДополнительныеПараметры.ИдентификаторФормы);
	
КонецПроцедуры

#КонецОбласти