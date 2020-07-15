﻿
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сгенерировать(Команда)
	СгенерироватьЗаказыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура СброситьИзменения(Команда)
	СброситьИзмененияНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуЗапускаОтложенногоОбновления(Команда)
	ОткрытьФорму("Обработка.ОбновлениеИнформационнойБазы.Форма.ИндикацияХодаОтложенногоОбновленияИБ");
КонецПроцедуры

&НаКлиенте
Процедура СброситьСведенияОбОбновлении(Команда)
	
	СброситьСведенияОбОбновленииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаблокироватьОбъект(Команда)
	ЗаблокироватьОбъектНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьОшибкуПриОтложенномОбновлении(Команда)
	
	ДобавитьОшибкуНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьОшибкуНаСервере()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ОтложенноеОбновлениеИБ", "ИмитироватьОшибку", Истина,, ИмяПользователя());
	
КонецПроцедуры

&НаСервере
Процедура СгенерироватьЗаказыНаСервере()
	
	// Получаем валюты
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Валюты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты";
	Валюты = Запрос.Выполнить().Выгрузить();
	
	// Получаем организацию
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ Первые 1
	|	Организации.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Организации КАК Организации";
	Организации = Запрос.Выполнить().Выгрузить();
	
	// Получаем партнера
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	_ДемоПартнеры.Ссылка
	|ИЗ
	|	Справочник._ДемоПартнеры КАК _ДемоПартнеры";
	Партнеры = Запрос.Выполнить().Выгрузить();
	
	// Получаем контрагента
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	_ДемоКонтрагенты.Ссылка
	|ИЗ
	|	Справочник._ДемоКонтрагенты КАК _ДемоКонтрагенты";
	Контрагенты = Запрос.Выполнить().Выгрузить();
	
	// Получаем договоры
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	_ДемоДоговорыКонтрагентов.Ссылка
	|ИЗ
	|	Справочник._ДемоДоговорыКонтрагентов КАК _ДемоДоговорыКонтрагентов";
	Договоры = Запрос.Выполнить().Выгрузить();
	
	Индекс = 1;
	НачатьТранзакцию();
	Попытка
		Пока Индекс <= КоличествоЗаказов Цикл
			НовыйДок = Документы._ДемоЗаказПокупателя.СоздатьДокумент();
			Индекс = Индекс + 1;
			НовыйДок.Дата = ДатаСоздания;
			НовыйДок.УдалитьЗаказЗакрыт = ЗаказЗакрыт;
			НовыйДок.Проведен = ЗаказПроведен;
			
			ГСЧ = Новый ГенераторСлучайныхЧисел;
			НовыйДок.Валюта = Валюты.Получить(ГСЧ.СлучайноеЧисло(0, Валюты.Количество() - 1)).Ссылка;
			НовыйДок.Организация = Организации.Получить(0).Ссылка;
			НовыйДок.Партнер = Партнеры.Получить(0).Ссылка;
			НовыйДок.Контрагент = Контрагенты.Получить(0).Ссылка;
			НовыйДок.Договор = Договоры.Получить(0).Ссылка;
			НовыйДок.СуммаДокумента = ГСЧ.СлучайноеЧисло(100, 1000);
			НовыйДок.Комментарий = НСтр("ru = 'Комментарий документа'");
			
			НовыйДок.Записать();
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура СброситьИзмененияНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	_ДемоЗаказПокупателя.Ссылка КАК Ссылка
	|ИЗ
	|	Документ._ДемоЗаказПокупателя КАК _ДемоЗаказПокупателя";
	Результат = Запрос.Выполнить().Выгрузить();
	
	Для Каждого ДокументСсылка Из Результат Цикл
		ДокументОбъект = ДокументСсылка.Ссылка.ПолучитьОбъект();
		ДокументОбъект.ОбменДанными.Загрузка = Истина;
		ДокументОбъект.СтатусЗаказа = Перечисления._ДемоСтатусыЗаказовПокупателей.ПустаяСсылка();
		ДокументОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СброситьСведенияОбОбновленииНаСервере()
	
	СведенияОбОбновлении = ОбновлениеИнформационнойБазыСлужебный.СведенияОбОбновленииИнформационнойБазы();
	
	Для Каждого СтрокаДереваБиблиотека Из СведенияОбОбновлении.ДеревоОбработчиков.Строки Цикл
		
		Если СтрокаДереваБиблиотека.Статус = "Завершено" Тогда
			СтрокаДереваБиблиотека.Статус = "НеВыполнено";
		КонецЕсли;
		
		Для Каждого СтрокаДереваВерсия Из СтрокаДереваБиблиотека.Строки Цикл
			
			Если СтрокаДереваВерсия.Статус = "Завершено" Тогда
				СтрокаДереваВерсия.Статус = "НеВыполнено";
			КонецЕсли;
			
			Для Каждого Обработчик Из СтрокаДереваВерсия.Строки Цикл
				
				Если Обработчик.Статус = "Выполнено" Тогда
					Обработчик.Статус = "НеВыполнено";
				Иначе
					Обработчик.ИнформацияОбОшибке = "";
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	СведенияОбОбновлении.НомерСеанса = Новый СписокЗначений;
	СведенияОбОбновлении.ВремяНачалаОтложенногоОбновления = Неопределено;
	СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления = Неопределено;
	ОбновлениеИнформационнойБазыСлужебный.ЗаписатьСведенияОбОбновленииИнформационнойБазы(СведенияОбОбновлении);
	
КонецПроцедуры

&НаСервере
Процедура ЗаблокироватьОбъектНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	_ДемоЗаказПокупателя.Ссылка КАК Ссылка
	|ИЗ
	|	Документ._ДемоЗаказПокупателя КАК _ДемоЗаказПокупателя
	|ГДЕ
	|	_ДемоЗаказПокупателя.СтатусЗаказа = ЗНАЧЕНИЕ(Перечисление._ДемоСтатусыЗаказовПокупателей.ПустаяСсылка)";
	
	Результат = Запрос.Выполнить().Выгрузить();
	Для Каждого ЗаказПокупателя Из Результат Цикл
		НачатьТранзакцию();
		
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Документ._ДемоЗаказПокупателя");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ЗаказПокупателя.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			Итератор = 0;
			Итератор2 = 0;
			НоваяДата = ТекущаяДатаСеанса() + 10*60;
			Пока НоваяДата >= ТекущаяДатаСеанса() Цикл
				
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
		Исключение
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
