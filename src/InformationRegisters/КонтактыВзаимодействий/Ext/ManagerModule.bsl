﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Удаляет либо одну, либо все записи из регистра
//
// Параметры:
//  Папка  - Ссылка на документ взаимодействия, Неопределено - взаимодействие, запись о котором удаляется.
//          Если указано значение Неопределено, то регистр будет очищен полностью.
//
Процедура УдалитьНаборЗаписейПоВзаимодействию(Взаимодействие = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.КонтактыВзаимодействий.СоздатьНаборЗаписей();
	Если Взаимодействие <> Неопределено Тогда
		НаборЗаписей.Отбор.Взаимодействие.Установить(Взаимодействие);
	КонецЕсли;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Выполняет запись в регистр сведений для указанного взаимодействия
//
// Параметры:
//  Предмет  - Ссылка на документ взаимодействия - взаимодействие, для которого выполняется запись
//  Контакт  - Ссылка на справочник контакта - контакт, являющийся участником взаимодействия
//
Процедура ВыполнитьЗаписьВРегистр(Взаимодействие, Контакт) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.КонтактыВзаимодействий.СоздатьМенеджерЗаписи();
	Запись.Взаимодействие = Взаимодействие;
	Запись.Контакт        = Контакт;
	Запись.Записать(Истина);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления

//Процедура обновления ИБ для версии БСП 2.2.
//Заполняет регистр сведений КонтактыВзаимодействий
//
Процедура ЗаполнитьКонтактыВзаимодействий_2_2_0_0(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1000
	|	Взаимодействия.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ НеобработанныеВзаимодействия
	|ИЗ
	|	ЖурналДокументов.Взаимодействия КАК Взаимодействия
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактыВзаимодействий КАК КонтактыВзаимодействий
	|		ПО Взаимодействия.Ссылка = КонтактыВзаимодействий.Взаимодействие
	|ГДЕ
	|	КонтактыВзаимодействий.Взаимодействие ЕСТЬ NULL 
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВстречаУчастники.Ссылка КАК Взаимодействие,
	|	ВстречаУчастники.Контакт,
	|	ВстречаУчастники.ПредставлениеКонтакта КАК ПредставлениеКонтакта
	|ПОМЕСТИТЬ ИнформацияОКонтактах
	|ИЗ
	|	Документ.Встреча.Участники КАК ВстречаУчастники
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактыВзаимодействий КАК КонтактыВзаимодействий
	|		ПО ВстречаУчастники.Ссылка = КонтактыВзаимодействий.Взаимодействие
	|ГДЕ
	|	ВстречаУчастники.Ссылка В
	|			(ВЫБРАТЬ
	|				НеобработанныеВзаимодействия.Ссылка
	|			ИЗ
	|				НеобработанныеВзаимодействия КАК НеобработанныеВзаимодействия)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗапланированноеВзаимодействиеУчастники.Ссылка,
	|	ЗапланированноеВзаимодействиеУчастники.Контакт,
	|	ЗапланированноеВзаимодействиеУчастники.ПредставлениеКонтакта
	|ИЗ
	|	Документ.ЗапланированноеВзаимодействие.Участники КАК ЗапланированноеВзаимодействиеУчастники
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактыВзаимодействий КАК КонтактыВзаимодействий
	|		ПО ЗапланированноеВзаимодействиеУчастники.Ссылка = КонтактыВзаимодействий.Взаимодействие
	|ГДЕ
	|	ЗапланированноеВзаимодействиеУчастники.Ссылка В
	|			(ВЫБРАТЬ
	|				НеобработанныеВзаимодействия.Ссылка
	|			ИЗ
	|				НеобработанныеВзаимодействия КАК НеобработанныеВзаимодействия)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТелефонныйЗвонок.Ссылка,
	|	ТелефонныйЗвонок.АбонентКонтакт,
	|	ТелефонныйЗвонок.АбонентПредставление
	|ИЗ
	|	Документ.ТелефонныйЗвонок КАК ТелефонныйЗвонок
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактыВзаимодействий КАК КонтактыВзаимодействий
	|		ПО (КонтактыВзаимодействий.Взаимодействие = ТелефонныйЗвонок.Ссылка)
	|ГДЕ
	|	ТелефонныйЗвонок.Ссылка В
	|			(ВЫБРАТЬ
	|				НеобработанныеВзаимодействия.Ссылка
	|			ИЗ
	|				НеобработанныеВзаимодействия КАК НеобработанныеВзаимодействия)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СообщениеSMSАдресаты.Ссылка,
	|	СообщениеSMSАдресаты.Контакт,
	|	СообщениеSMSАдресаты.ПредставлениеКонтакта
	|ИЗ
	|	Документ.СообщениеSMS.Адресаты КАК СообщениеSMSАдресаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактыВзаимодействий КАК КонтактыВзаимодействий
	|		ПО СообщениеSMSАдресаты.Ссылка = КонтактыВзаимодействий.Взаимодействие
	|ГДЕ
	|	СообщениеSMSАдресаты.Ссылка В
	|			(ВЫБРАТЬ
	|				НеобработанныеВзаимодействия.Ссылка
	|			ИЗ
	|				НеобработанныеВзаимодействия КАК НеобработанныеВзаимодействия)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЭлектронноеПисьмоВходящее.Ссылка,
	|	ЭлектронноеПисьмоВходящее.ОтправительКонтакт,
	|	ЭлектронноеПисьмоВходящее.ОтправительПредставление
	|ИЗ
	|	Документ.ЭлектронноеПисьмоВходящее КАК ЭлектронноеПисьмоВходящее
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактыВзаимодействий КАК КонтактыВзаимодействий
	|		ПО (КонтактыВзаимодействий.Взаимодействие = ЭлектронноеПисьмоВходящее.Ссылка)
	|ГДЕ
	|	ЭлектронноеПисьмоВходящее.Ссылка В
	|			(ВЫБРАТЬ
	|				НеобработанныеВзаимодействия.Ссылка
	|			ИЗ
	|				НеобработанныеВзаимодействия КАК НеобработанныеВзаимодействия)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЭлектронноеПисьмоИсходящееПолучателиПисьма.Ссылка,
	|	ЭлектронноеПисьмоИсходящееПолучателиПисьма.Контакт,
	|	ЭлектронноеПисьмоИсходящееПолучателиПисьма.Представление
	|ИЗ
	|	Документ.ЭлектронноеПисьмоИсходящее.ПолучателиПисьма КАК ЭлектронноеПисьмоИсходящееПолучателиПисьма,
	|	РегистрСведений.КонтактыВзаимодействий КАК КонтактыВзаимодействий
	|ГДЕ
	|	ЭлектронноеПисьмоИсходящееПолучателиПисьма.Ссылка В
	|			(ВЫБРАТЬ
	|				НеобработанныеВзаимодействия.Ссылка
	|			ИЗ
	|				НеобработанныеВзаимодействия КАК НеобработанныеВзаимодействия)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЭлектронноеПисьмоИсходящееПолучателиКопий.Ссылка,
	|	ЭлектронноеПисьмоИсходящееПолучателиКопий.Контакт,
	|	ЭлектронноеПисьмоИсходящееПолучателиКопий.Представление
	|ИЗ
	|	Документ.ЭлектронноеПисьмоИсходящее.ПолучателиКопий КАК ЭлектронноеПисьмоИсходящееПолучателиКопий
	|ГДЕ
	|	ЭлектронноеПисьмоИсходящееПолучателиКопий.Ссылка В
	|			(ВЫБРАТЬ
	|				НеобработанныеВзаимодействия.Ссылка
	|			ИЗ
	|				НеобработанныеВзаимодействия КАК НеобработанныеВзаимодействия)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Ссылка,
	|	ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Контакт,
	|	ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Представление
	|ИЗ
	|	Документ.ЭлектронноеПисьмоИсходящее.ПолучателиСкрытыхКопий КАК ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактыВзаимодействий КАК КонтактыВзаимодействий
	|		ПО ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Ссылка = КонтактыВзаимодействий.Взаимодействие
	|ГДЕ
	|	ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Ссылка В
	|			(ВЫБРАТЬ
	|				НеобработанныеВзаимодействия.Ссылка
	|			ИЗ
	|				НеобработанныеВзаимодействия КАК НеобработанныеВзаимодействия)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПредставлениеКонтакта
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ИнформацияОКонтактах.Взаимодействие КАК Взаимодействие,
	|	ВЫБОР
	|		КОГДА ИнформацияОКонтактах.Контакт = НЕОПРЕДЕЛЕНО
	|			ТОГДА ЕСТЬNULL(СтроковыеКонтактыВзаимодействий.Ссылка, НЕОПРЕДЕЛЕНО)
	|		ИНАЧЕ ИнформацияОКонтактах.Контакт
	|	КОНЕЦ КАК Контакт,
	|	ИнформацияОКонтактах.ПредставлениеКонтакта
	|ИЗ
	|	ИнформацияОКонтактах КАК ИнформацияОКонтактах
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтроковыеКонтактыВзаимодействий КАК СтроковыеКонтактыВзаимодействий
	|		ПО ИнформацияОКонтактах.ПредставлениеКонтакта = СтроковыеКонтактыВзаимодействий.Наименование
	|ИТОГИ ПО
	|	Взаимодействие";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ТребуетсяЗаполнение = Ложь;
		Возврат;
	КонецЕсли;
	
	СозданныеСтроковыеКонтакты = Новый Соответствие;
	
	ВыборкаВзаимодействие = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаВзаимодействие.Следующий() Цикл
		
		ВыборкаДетали = ВыборкаВзаимодействие.Выбрать();
		
		НаборЗаписей = РегистрыСведений.КонтактыВзаимодействий.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Взаимодействие.Установить(ВыборкаВзаимодействие.Взаимодействие);
		
		Пока ВыборкаДетали.Следующий() Цикл
			
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.Взаимодействие = ВыборкаВзаимодействие.Взаимодействие;
			Если ВыборкаДетали.Контакт <> Неопределено Тогда
				НоваяЗапись.Контакт = ВыборкаДетали.Контакт;
			Иначе
				
				УжеСозданныйСтроковыйКонтакт = СозданныеСтроковыеКонтакты.Получить(ВыборкаДетали.ПредставлениеКонтакта);
				
				Если УжеСозданныйСтроковыйКонтакт = Неопределено Тогда
					СтроковыйКонтактВзаимодействий              = Справочники.СтроковыеКонтактыВзаимодействий.СоздатьЭлемент();
					СтроковыйКонтактВзаимодействий.Наименование = ВыборкаДетали.ПредставлениеКонтакта;
					СтроковыйКонтактВзаимодействий.Записать();
					СозданныеСтроковыеКонтакты.Вставить(ВыборкаДетали.ПредставлениеКонтакта, СтроковыйКонтактВзаимодействий.Ссылка);
					НоваяЗапись.Контакт                         = СтроковыйКонтактВзаимодействий.Ссылка;
				Иначе
					НоваяЗапись.Контакт                         = УжеСозданныйСтроковыйКонтакт;
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = (ВыборкаВзаимодействие.Количество() = 0);

#КонецОбласти
КонецПроцедуры
#КонецЕсли