﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает XDTO-тип, описывающий разрешения типа, соответствующего элементу кэша.
//
// Возвращаемое значение - ТипОбъектаXDTO.
//
Функция ТипXDTOПредставленияРазрешений() Экспорт
	
	Возврат ФабрикаXDTO.Тип(РаботаВБезопасномРежимеСлужебный.ПакетXDTOПредставленийРазрешений(), "CreateComObject");
	
КонецФункции

// Формирует набор записей текущего регистра кэша из XDTO-представлений разрешения.
//
// Параметры:
//  ВнешнийМодуль - ЛюбаяСсылка,
//  Владелец - ЛюбаяСсылка,
//  XDTOПредставления - Массив(ОбъектXDTO).
//
// Возвращаемое значение - РегистрСведенийНаборЗаписей.
//
Функция НаборЗаписейИзXDTOПредставления(Знач XDTOПредставления, Знач ВнешнийМодуль, Знач Владелец, Знач ДляУдаления) Экспорт
	
	Набор = СоздатьНаборЗаписей();
	
	СвойстваПрограммногоМодуля = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.СвойстваДляРегистраРазрешений(ВнешнийМодуль);
	Набор.Отбор.ТипПрограммногоМодуля.Установить(СвойстваПрограммногоМодуля.Тип);
	Набор.Отбор.ИдентификаторПрограммногоМодуля.Установить(СвойстваПрограммногоМодуля.Идентификатор);
	
	СвойстваВладельца = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.СвойстваДляРегистраРазрешений(Владелец);
	Набор.Отбор.ТипВладельца.Установить(СвойстваВладельца.Тип);
	Набор.Отбор.ИдентификаторВладельца.Установить(СвойстваВладельца.Идентификатор);
	
	Если ДляУдаления Тогда
		
		Возврат Набор;
		
	Иначе
		
		Таблица = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ТаблицаРазрешений(СоздатьНаборЗаписей().Метаданные(), Истина);
		
		Для Каждого XDTOПредставление Из XDTOПредставления Цикл
			
			Ключ = Новый Структура("ТипПрограммногоМодуля,ИдентификаторПрограммногоМодуля,ТипВладельца,ИдентификаторВладельца,ProgId",
				СвойстваПрограммногоМодуля.Тип,
				СвойстваПрограммногоМодуля.Идентификатор,
				СвойстваВладельца.Тип,
				СвойстваВладельца.Идентификатор,
				XDTOПредставление.ProgId);
			Если Таблица.НайтиСтроки(Ключ).Количество() = 0 Тогда
				Строка = Таблица.Добавить();
				Строка.ТипПрограммногоМодуля = СвойстваПрограммногоМодуля.Тип;
				Строка.ИдентификаторПрограммногоМодуля = СвойстваПрограммногоМодуля.Идентификатор;
				Строка.ТипВладельца = СвойстваВладельца.Тип;
				Строка.ИдентификаторВладельца = СвойстваВладельца.Идентификатор;
				Строка.ProgId = XDTOПредставление.ProgId;
				Строка.CLSID = XDTOПредставление.CLSID;
				Строка.ИмяКомпьютера = XDTOПредставление.ComputerName;
			КонецЕсли;
			
		КонецЦикла;
		
		Набор.Загрузить(Таблица);
		Возврат Набор;
		
	КонецЕсли;
	
КонецФункции

// Заполняет описание профиля безопасности (в нотации программного интерфейса общего модуля
//  АдминистрированиеКластераКлиентСервер) по менеджеру записи текущего элемента кэша.
//
// Параметры:
//  Менеджер - РегистрСведенийМенеджерЗаписи,
//  Профиль - Структура.
//
Процедура ЗаполнитьСвойстваПрофиляБезопасностиВНотацииИнтерфейсаАдминистрирования(Знач Менеджер, Профиль) Экспорт
	
	COMКласс = АдминистрированиеКластераКлиентСервер.СвойстваCOMКласса();
	COMКласс.Имя = Менеджер.ProgId;
	COMКласс.CLSID = Менеджер.CLSID;
	COMКласс.Компьютер = Менеджер.ИмяКомпьютера;
	Профиль.COMКлассы.Добавить(COMКласс);
	
КонецПроцедуры

// Возвращает текст запроса для получения текущего среза разрешений по данному
//  элементу кэша.
//
// Параметры:
//  СвернутьВладельцев - Булево - флаг необходимости сворачивания результата запроса
//    по владельцам.
//
// Возвращаемое значение - Строка, текст запроса.
//
Функция ЗапросТекущегоСреза(Знач СвернутьВладельцев = Истина) Экспорт
	
	Если СвернутьВладельцев Тогда
		
		Возврат "ВЫБРАТЬ РАЗЛИЧНЫЕ
		        |	Разрешения.ProgId,
		        |	Разрешения.CLSID,
		        |	Разрешения.ИмяКомпьютера,
		        |	Разрешения.ТипПрограммногоМодуля КАК ТипПрограммногоМодуля,
		        |	Разрешения.ИдентификаторПрограммногоМодуля КАК ИдентификаторПрограммногоМодуля
		        |ИЗ
		        |	РегистрСведений.РазрешенныеCOMКлассы КАК Разрешения";
		
	Иначе
		
		Возврат "ВЫБРАТЬ РАЗЛИЧНЫЕ
		        |	Разрешения.ProgId,
		        |	Разрешения.CLSID,
		        |	Разрешения.ИмяКомпьютера,
		        |	Разрешения.ТипПрограммногоМодуля КАК ТипПрограммногоМодуля,
		        |	Разрешения.ИдентификаторПрограммногоМодуля КАК ИдентификаторПрограммногоМодуля,
		        |	Разрешения.ТипВладельца КАК ТипВладельца,
		        |	Разрешения.ИдентификаторВладельца КАК ИдентификаторВладельца
		        |ИЗ
		        |	РегистрСведений.РазрешенныеCOMКлассы КАК Разрешения";
		
	КонецЕсли;
	
КонецФункции

// Возвращает текст запроса для получения дельты измения разрешений по данному
//  элементу кэша.
//
// Возвращаемое значение - Строка, текст запроса.
//
Функция ЗапросПолученияДельты() Экспорт
	
	Возврат
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_До.ProgId,
		|	ВТ_До.CLSID,
		|	ВТ_До.ИмяКомпьютера,
		|	ВТ_До.ТипПрограммногоМодуля,
		|	ВТ_До.ИдентификаторПрограммногоМодуля
		|ИЗ
		|	ВТ_До КАК ВТ_До
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_После КАК ВТ_После
		|		ПО ВТ_До.ТипПрограммногоМодуля = ВТ_После.ТипПрограммногоМодуля
		|			И ВТ_До.ИдентификаторПрограммногоМодуля = ВТ_После.ИдентификаторПрограммногоМодуля
		|			И ВТ_До.ProgId = ВТ_После.ProgId
		|ГДЕ
		|	ВТ_После.ProgId ЕСТЬ NULL 
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_После.ProgId,
		|	ВТ_После.CLSID,
		|	ВТ_После.ИмяКомпьютера,
		|	ВТ_После.ТипПрограммногоМодуля,
		|	ВТ_После.ИдентификаторПрограммногоМодуля
		|ИЗ
		|	ВТ_После КАК ВТ_После
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_До КАК ВТ_До
		|		ПО ВТ_После.ТипПрограммногоМодуля = ВТ_До.ТипПрограммногоМодуля
		|			И ВТ_После.ИдентификаторПрограммногоМодуля = ВТ_До.ИдентификаторПрограммногоМодуля
		|			И ВТ_После.ProgId = ВТ_До.ProgId
		|ГДЕ
		|	ВТ_До.ProgId ЕСТЬ NULL ";
	
КонецФункции

#КонецОбласти

#КонецЕсли