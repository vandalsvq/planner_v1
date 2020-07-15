﻿// Форма принимает параметры:
//
//     НаборСсылок - Массив, СписокЗначений - набор элементов для анализа при открытии. Может быть коллекцией
//                                            элементов с полем "Ссылка". Если есть элементы, то отчет формируется 
//                                            автоматически при открытии.
//

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИнициализироватьПользовательскиеНастройкиОтчета(Параметры);
	
	// И перекладываем на форму
	Параметры.ПользовательскиеНастройки = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Отображение = Элементы.Результат.ОтображениеСостояния;
	Отображение.Видимость                      = Истина;
	Отображение.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	Отображение.Картинка                       = БиблиотекаКартинок.ДлительнаяОперация48;
	Отображение.Текст                          = НСтр("ru = 'Отчет формируется...'");
	
	ПодключитьОбработчикОжидания("ЗапуститьФормирование", 0.1, Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	ЗапуститьФормирование();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗапуститьФормирование()
	
	СкомпоноватьРезультат(РежимКомпоновкиРезультата.Фоновый);
	
КонецПроцедуры

// Инициализирует пользовательские настройки компоновщика по переданным параметрам
//
&НаСервере
Процедура ИнициализироватьПользовательскиеНастройкиОтчета(Знач ПараметрыДанных)
	НовыеПараметры = Новый Соответствие;
	
	// НаборСсылок
	НаборСсылок = Новый СписокЗначений;
	Если ПараметрыДанных.Свойство("НаборСсылок") Тогда
		ТекущийПараметр = ПараметрыДанных.НаборСсылок;
		
		ТипПараметра = ТипЗнч(ТекущийПараметр);
		Если ТипПараметра = Тип("Массив") Тогда
			НаборСсылок.ЗагрузитьЗначения(ТекущийПараметр);
			
		ИначеЕсли ТипПараметра = Тип("СписокЗначений") Тогда
			НаборСсылок.ЗагрузитьЗначения(ТекущийПараметр.ВыгрузитьЗначения());
			
		Иначе
			ЭтоПеречисляемыйТип = Ложь;
			Попытка
				// Перечисляемый
				Для Каждого Элемент Из ТекущийПараметр Цикл
					ЭтоПеречисляемыйТип = Истина;
					Прервать;
				КонецЦикла;
			Исключение
				ЭтоПеречисляемыйТип = Ложь;
			КонецПопытки;
			
			Если ЭтоПеречисляемыйТип Тогда
				Для Каждого Элемент Из ТекущийПараметр Цикл
					НаборСсылок.Добавить(Элемент.Ссылка);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
		НовыеПараметры.Вставить(Новый ПараметрКомпоновкиДанных("НаборСсылок"), НаборСсылок);
	КонецЕсли;
	
	// Устанавливаем в пользовательские поля
	Для Каждого Элемент Из Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Значение = НовыеПараметры[Элемент.Параметр];
		Если Значение<>Неопределено Тогда
			Элемент.Использование = Истина;
			Элемент.Значение      = Значение;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
