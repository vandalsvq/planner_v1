﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает массив структур, адресатов документа Сообщение SMS
//
// Параметры
//  Ссылка  - Документ.СообщениеSMS - документ, для которого получаем массив контактов
//
// Возвращаемое значение:
//   Массив   - адресаты сообщения SMS
//
Функция ПолучитьКонтакты(Ссылка) Экспорт
	
	Возврат Взаимодействия.ПолучитьУчастниковПоТаблице(Ссылка);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Групповое изменение объектов

// Возвращает список реквизитов, которые разрешается редактировать
// с помощью обработки группового изменения объектов.
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Автор");
	Результат.Добавить("Важность");
	Результат.Добавить("Ответственный");
	Результат.Добавить("ВзаимодействиеОснование");
	Результат.Добавить("Комментарий");
	Результат.Добавить("Адресаты.Контакт");
	Результат.Добавить("Адресаты.ПредставлениеКонтакта");
	Результат.Добавить("Адресаты.КакСвязаться");
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ВзаимодействияВызовСервера.ОбработкаПолученияДанныхВыбора(
		ДанныеВыбора,
		Параметры,
		СтандартнаяОбработка, 
		"СообщениеSMS");
	
КонецПроцедуры

#КонецОбласти
