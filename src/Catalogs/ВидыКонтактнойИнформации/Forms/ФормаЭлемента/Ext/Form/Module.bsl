﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Предопределенный Тогда
		Элементы.Наименование.ТолькоПросмотр = Истина;
		Элементы.Родитель.ТолькоПросмотр     = Истина;
		Элементы.Тип.ТолькоПросмотр          = Истина;
		Элементы.Подсказка.ТолькоПросмотр    = Истина;
		
	Иначе
		// Обработчик подсистемы запрета редактирования реквизитов объектов.
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
			МодульЗапретРедактированияРеквизитовОбъектов = ОбщегоНазначения.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектов");
			МодульЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект,, НСтр("ru = 'Разрешить редактирование типа и группы'"));
			
		Иначе
			Элементы.Родитель.ТолькоПросмотр = Истина;
			Элементы.Тип.ТолькоПросмотр = Истина;
			
		КонецЕсли;
	КонецЕсли;
	
	СсылкаРодителя = Объект.Родитель;
	ТекущийУровень = ?(СсылкаРодителя.Пустая(), 0, СсылкаРодителя.Уровень() );
	
	Элементы.РазрешитьВводНесколькихЗначений.Доступность = ?(ТекущийУровень = 1, Ложь, Истина);
	
	Если Не Объект.МожноИзменятьСпособРедактирования Тогда
		Элементы.РедактированиеТолькоВДиалоге.Доступность       = Ложь;
		Элементы.РазрешитьВводНесколькихЗначений.Доступность    = Ложь;
		Элементы.ГруппаНаименованиеНастройкиПоТипам.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИзменитьОтображениеПриИзмененииТипа();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ТекущийОбъект.ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ТекущийОбъект.Предопределенный Тогда
		// Обработчик подсистемы запрета редактирования реквизитов объектов.
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
			МодульЗапретРедактированияРеквизитовОбъектов = ОбщегоНазначения.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектов");
			МодульЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипПриИзменении(Элемент)
	
	ИзменитьРеквизитыПриИзмененииТипа();
	ИзменитьОтображениеПриИзмененииТипа();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресТолькоРоссийскийПриИзменении(Элемент)
	
	ИзменитьРеквизитыПриИзмененииТолькоРоссии();
	ИзменитьОтображениеПриИзмененииТолькоРоссии();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверятьПоКлассификаторуПриИзменении(Элемент)
	
	ИзменитьРеквизитыПриИзмененииПроверятьКорректность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверятьКорректностьПриИзменении(Элемент)
	
	ИзменитьРеквизитыПриИзмененииПроверятьКорректность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если Не Объект.Предопределенный Тогда
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
			МодульЗапретРедактированияРеквизитовОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектовКлиент");
			МодульЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьОтображениеПриИзмененииТипа()
	
	Если Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.Адрес;
		Элементы.РедактированиеТолькоВДиалоге.Доступность = Объект.МожноИзменятьСпособРедактирования;
		
		ИзменитьОтображениеПриИзмененииТолькоРоссии();
		
	ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты") Тогда
		Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.АдресЭлектроннойПочты;
		Элементы.РедактированиеТолькоВДиалоге.Доступность = Ложь;
		
	ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон")
		Или Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Факс") Тогда
		Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.Другое;
		Элементы.РедактированиеТолькоВДиалоге.Доступность = Объект.МожноИзменятьСпособРедактирования;
		
	Иначе
		Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.Другое;
		Элементы.РедактированиеТолькоВДиалоге.Доступность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРеквизитыПриИзмененииТипа()
	Если Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		ИзменитьРеквизитыПриИзмененииТолькоРоссии();
		
	ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты") Тогда
		Объект.РедактированиеТолькоВДиалоге = Ложь;
		ИзменитьРеквизитыПриИзмененииПроверятьКорректность();
		
	ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон")
		Или Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Факс") Тогда
		// Нет изменений
		
	Иначе
		Объект.РедактированиеТолькоВДиалоге = Ложь;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьОтображениеПриИзмененииТолькоРоссии()
	
	Элементы.ПроверятьПоКлассификатору.Доступность = Объект.АдресТолькоРоссийский;
	Элементы.СкрыватьНеактуальныеАдреса.Доступность = Объект.АдресТолькоРоссийский;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРеквизитыПриИзмененииТолькоРоссии()
	
	Если Не Объект.АдресТолькоРоссийский Тогда
		Объект.ПроверятьКорректность = Ложь;
		Объект.СкрыватьНеактуальныеАдреса = Ложь;
	КонецЕсли;
	
	ИзменитьРеквизитыПриИзмененииПроверятьКорректность();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРеквизитыПриИзмененииПроверятьКорректность()
	
	Объект.ЗапрещатьВводНекорректного = Объект.ПроверятьКорректность;
	
КонецПроцедуры

#КонецОбласти
