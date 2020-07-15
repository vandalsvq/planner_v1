﻿Функция ПолучитьВидыУчастников() Экспорт

	Соответствие = Новый Соответствие;
	Соответствие.Вставить(1, "Пользователь (участник)");
	Соответствие.Вставить(2, "Контактное лицо (участник)");
	Соответствие.Вставить(3, "Прочее (представление)");
	
	Возврат Соответствие;
	
КонецФункции

Процедура ВыполнитьЗапись(Отказ, СобытиеСсылка, ТаблицаДанных) Экспорт
	
	Попытка
		// Блокируем данные для записи
		Блокировка = Новый БлокировкаДанных;
		
		Элемент = Блокировка.Добавить("РегистрСведений.УчастникиСобытийПланировщика");
		Элемент.Режим = РежимБлокировкиДанных.Исключительный;
		Элемент.УстановитьЗначение("Событие", СобытиеСсылка);
		
		Блокировка.Заблокировать();
		
		// Считываем записи и заполняем их вновь
		НаборЗаписей = РегистрыСведений.УчастникиСобытийПланировщика.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Событие.Установить(СобытиеСсылка);
		НаборЗаписей.Прочитать();
		
		// Проверяем существующие записи
		Проверенные	= Новый Массив;
		Удаление	= Новый Массив;
		
		Для Каждого ЗаписьРегистра Из НаборЗаписей Цикл
			МассивСтрок = ТаблицаДанных.НайтиСтроки(Новый Структура("Идентификатор", ЗаписьРегистра.Идентификатор));
			Если МассивСтрок.Количество() = 0 Тогда
				Удаление.Добавить(ЗаписьРегистра);
			Иначе 
				ЗаполнитьЗначенияСвойств(ЗаписьРегистра, МассивСтрок[0]);
				Проверенные.Добавить(МассивСтрок[0]);
			КонецЕсли;
		КонецЦикла;
		
		// Удаляем старые строки
		Для Каждого ЗаписьРегистра Из Удаление Цикл
			НаборЗаписей.Удалить(ЗаписьРегистра);
		КонецЦикла;
		
		// Добавляем новые строки
		Для Каждого СтрокаТаблицы Из ТаблицаДанных Цикл
			Если НЕ Проверенные.Найти(СтрокаТаблицы) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ЗаписьРегистра = НаборЗаписей.Добавить();
			ЗаписьРегистра.Событие = СобытиеСсылка;
			ЗаполнитьЗначенияСвойств(ЗаписьРегистра, СтрокаТаблицы);
			
			Если ЗаписьРегистра.Идентификатор = ПланировщикКлиентСервер.ПустойИдентификатор() Тогда
				ЗаписьРегистра.Идентификатор = Новый УникальныйИдентификатор;
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(ЗаписьРегистра.ВидУчастника) Тогда
				Если ЗначениеЗаполнено(ЗаписьРегистра.Участник) Тогда
					ЗаписьРегистра.ВидУчастника = Перечисления.ВидыУчастниковСобытийПланировщика.УчастникСсылка;
				Иначе 
					ЗаписьРегистра.ВидУчастника = Перечисления.ВидыУчастниковСобытийПланировщика.УчастникСтрока;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		// Записываем набор
		НаборЗаписей.Записать();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Отказ = Истина;
	КонецПопытки;
	
КонецПроцедуры