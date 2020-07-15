﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗапуститьИЗавершить = Параметры.ЗапуститьИЗавершить;
	Объект.КаталогВыгрузкиМодулей = Параметры.КаталогВыгрузкиМодулей;
	
	ПутьКФайлу = Параметры.ПутьКФайлу;
	ПутьКВременномуФайлуДанных = Параметры.ПутьКВременномуФайлуДанных;
	ПутьКФайлуСОтветами = ?(ПустаяСтрока(ПутьКФайлу), ПутьКВременномуФайлуДанных, ПутьКФайлу);
	
	НовыйСписокПодсистем = ПолучитьИзВременногоХранилища(Параметры.АдресСпискаИспользуемыхПодсистем);
	
	ЗначениеВРеквизитФормы(НовыйСписокПодсистем, "СписокПодсистем");
	ОтборПоПодсистемам = Новый СписокЗначений;
	ОтборПоПодсистемам.ЗагрузитьЗначения(НовыйСписокПодсистем.ВыгрузитьКолонку("Подсистема"));
	ЗаписатьСтруктуруВопросовОтветов(НовыйСписокПодсистем);
	
	ОтборПоОбъектам = "Все";
	
	Если Параметры.Свойство("РежимПроверки") Тогда
		Если Параметры.РежимПроверки Тогда
			СтруктураОтчета = РеквизитФормыВЗначение("Объект").ПроверитьВнедрение(ОтборПоПодсистемам, ПутьКФайлуСОтветами);
			ТаблицаОтчета  = СтруктураОтчета.ТаблицаОтчета;
			ЗначениеВРеквизитФормы(СтруктураОтчета.СтруктураОписанияОшибок, "СтруктураОписанияОшибок");
		КонецЕсли;
	ИначеЕсли ПустаяСтрока(ПутьКФайлу) Тогда
		СтруктураОтчета = РеквизитФормыВЗначение("Объект").ПроверитьВнедрение(ОтборПоПодсистемам, ПутьКВременномуФайлуДанных);
		ТаблицаОтчета  = СтруктураОтчета.ТаблицаОтчета;
		ЗначениеВРеквизитФормы(СтруктураОтчета.СтруктураОписанияОшибок, "СтруктураОписанияОшибок");
	Иначе
		СтруктураОтчета = РеквизитФормыВЗначение("Объект").ПроверитьВнедрение(ОтборПоПодсистемам, ПутьКФайлу);
		ТаблицаОтчета  = СтруктураОтчета.ТаблицаОтчета;
		ЗначениеВРеквизитФормы(СтруктураОтчета.СтруктураОписанияОшибок, "СтруктураОписанияОшибок");
	КонецЕсли;
	
	ИмяФормыВыбора = РеквизитФормыВЗначение("Объект").ИмяФормыОбработки(ИмяФормы, "ВыборОбъектовМетаданных");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗапуститьИЗавершить Тогда
		ОтборПоОбъектам = "Ошибки";
		ОбработатьПользовательскиеОтборы();
		ТаблицаОтчета.Записать(Объект.КаталогВыгрузкиМодулей + "\ПомощникВнедрения\ТаблицаВнедренияПодсистем.mxl");
		ПрекратитьРаботуСистемы(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ВыборОбъектовМетаданных" Тогда
		ЗаполнитьОтборНаСервере(Параметр);
		ОтборПоПодсистемамПриИзменении("");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаОтчетаВыбор(Элемент, Область, СтандартнаяОбработка)
	// Если выбрали элемент в шапке и ширина области = 1(признак того, что щелкнули на вопрос), тогда выведем текст вопроса
	Если Область.Верх < 4 И (Область.Право - Область.Лево) = 0 Тогда
		ТекстВопроса = ОпределитьТекстВопроса(Область.Право-2);
		ПоказатьЗначение(, СокрЛП(ТекстВопроса));
	Иначе
		СтандартнаяОбработка = Ложь;
		Если Область.Защита = Ложь Тогда
			Область.Текст = ?(Область.Текст = "+", "", "+");
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоОбъектамПриИзменении(Элемент)
	ОбработатьПользовательскиеОтборы();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОтчетаПриИзменении(Элемент)
	Если Элемент.ТекущаяОбласть.ЦветФона = Новый Цвет (217, 217, 217) Тогда
		Элемент.ТекущаяОбласть.Текст = "";
		Возврат;
	КонецЕсли;
	
	Если Не ПустаяСтрока(ТекстТекущейОбласти) И Элемент.ТекущаяОбласть.Текст = "" 
		И Элемент.ТекущаяОбласть.ЦветТекста <> Новый Цвет (51, 102, 255) Тогда
		Элемент.ТекущаяОбласть.Узор = ТипУзораТабличногоДОкумента.Узор14;
		Элемент.ТекущаяОбласть.ЦветУзора = Новый Цвет (51, 102, 255);
	КонецЕсли;
	
	Если ПустаяСтрока(ТекстТекущейОбласти) И Элемент.ТекущаяОбласть.Текст = "+" Тогда
		Элемент.ТекущаяОбласть.Узор = ТипУзораТабличногоДОкумента.БезУзора;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОтчетаПриАктивизацииОбласти(Элемент)
	ТекстТекущейОбласти = Элемент.ТекущаяОбласть.Текст;
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоПодсистемамПриИзменении(Элемент)
	ОбработатьПользовательскиеОтборы();
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоПодсистемамНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	СписокОтбора = Новый СписокЗначений;
	СписокОтбора.Добавить("Подсистемы");
	ПараметрыФормы = Новый Структура("КоллекцииВыбираемыхОбъектовМетаданных, ВыбранныеОбъектыМетаданных",СписокОтбора, ПодготовитьСписокПодсистем());
	СписокРодительскихПодсистем = Новый СписокЗначений;
	СписокРодительскихПодсистем.Добавить("СтандартныеПодсистемы");
	ПараметрыФормы.Вставить("РодительскиеПодсистемы", СписокРодительскихПодсистем);
	ПараметрыФормы.Вставить("Заголовок", Нстр("ru = 'Подсистемы'"));
	
	ОткрытьФорму(ИмяФормыВыбора, ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьВнедрениеКоманда(Команда)
	Если Не ПроверитьИмяФайла() Тогда
		Возврат;
	КонецЕсли;
	Состояние(НСтр("ru= 'Проверка корректности внедрения подсистем'"),, 
	НСтр("ru = 'Пожалуйста, подождите. Выполняется проверка корректности внедрения подсистем...'"));
	ПроверитьВнедрение();
	ТекстПредупреждения = НСтр("ru = 'Проверка корректности внедрения завершена. 
	|%1
	|Цветовую легенду таблицы можно посмотреть в справочной информации.
	|Для просмотра ошибок по конкретной ячейке воспользуйтесь командой контекстного меню ""Показать описание ошибки"".'");
	
	КоличествоОшибок = 	СтруктураОписанияОшибок.Количество() ;
	Если КоличествоОшибок = 0 Тогда 
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%1", НСтр("ru = 'Ошибок не обнаружено.
		|Однако это не означает, что внедрение выполнено корректно. Откройте отчет по дополнительны параметрам внедрения, чтобы перейти к списку ручных проверок.'"));
	Иначе
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%1", НСтр("ru = 'Обнаружено %2 ошибок.'"));
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%2", КоличествоОшибок);
	КонецЕсли;
	ПоказатьПредупреждение(, ТекстПредупреждения);
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	Если Не ПроверитьИмяФайла() Тогда
		Возврат;
	КонецЕсли;
	ЗаписатьСтруктуру();
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОписаниеОшибки(Команда)
	
	Область = Строка(Элементы.ТаблицаОтчета.ТекущаяОбласть.Верх)+":"+Строка(Элементы.ТаблицаОтчета.ТекущаяОбласть.Лево);
	ОписаниеОшибки = ВернутьОписаниеОшибкиПоТекущемуАдресу(Область);
	Если ОписаниеОшибки = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'По этой ячейке нет зафиксированных ошибок внедрения. Для выполнения проверки воспользуйтесь командой ""Проверить внедрение"".'"));
		Возврат;
	КонецЕсли;
	
	ТекстОшибки = Новый ТекстовыйДокумент;
	ТекстОшибки.УстановитьТекст(ОписаниеОшибки);
	ТекстОшибки.Показать(НСтр("ru = 'Расшифровка ошибок внедрения'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
процедура ЗаписатьСтруктуруВопросовОтветов(ВыводимыеПодсистемы)
	СоответствиеВопросовНомерамКолонок.Очистить();
	НомерКолонки = 0;
	Для Каждого ВнедреннаяПодсистема Из ВыводимыеПодсистемы Цикл	
		НомерКолонки = НомерКолонки + ДобавитьОписаниеВопроса(НомерКолонки, ВнедреннаяПодсистема.Подсистема);
	КонецЦикла;			
КонецПроцедуры

&НаСервере 
Процедура ПроверитьВнедрение()
	ЗаписатьСтруктуру();
	ПутьКФайлуСОтветами = ?(ПустаяСтрока(ПутьКФайлу), ПутьКВременномуФайлуДанных, ПутьКФайлу);
	СтруктураОтчета = РеквизитФормыВЗначение("Объект").ПроверитьВнедрение(ОтборПоПодсистемам, ПутьКФайлуСОтветами);
	ТаблицаОтчета  = СтруктураОтчета.ТаблицаОтчета;
	ЗначениеВРеквизитФормы(СтруктураОтчета.СтруктураОписанияОшибок, "СтруктураОписанияОшибок");
КонецПроцедуры

&НаСервере
Процедура ЗаписатьСтруктуру()
	ЗаписатьСтруктуруВопросовОтветов(СписокПодсистем);
	ПутьКФайлуСОтветами = ?(ПустаяСтрока(ПутьКФайлу), ПутьКВременномуФайлуДанных, ПутьКФайлу);
	РеквизитФормыВЗначение("Объект").СохранитьСписокПодсистемВФайл(СписокПодсистем, ПутьКФайлуСОтветами);
	
	// по каждому вопросу, требующему заполнения в таблице
	СоответствиеВопросовОтветов = Новый ТаблицаЗначений;
	СоответствиеВопросовОтветов.Колонки.Добавить("Вопрос");
	СоответствиеВопросовОтветов.Колонки.Добавить("Ответ");
	Для Каждого ЭлементСписка Из  СоответствиеВопросовНомерамКолонок Цикл
		
		//определим область колонки, в которой размещается ответ на этот вопрос
		
		СтрокаОтвета = "";
		НомерКолонки = СоответствиеВопросовНомерамКолонок.Индекс(ЭлементСписка) + 2;
		ОбластьПоиска = ТаблицаОтчета.Область( ,НомерКолонки, , НомерКолонки);
		
		Начало = ТаблицаОтчета.НайтиТекст("+", , ОбластьПоиска);
		
		Пока Начало <> Неопределено Цикл
			ИмяОбъекта = ТаблицаОтчета.Область(Начало.Верх, 1).Расшифровка;
			СтрокаОтвета = ?(ПустаяСтрока(СтрокаОтвета), ИмяОбъекта, СтрокаОтвета + ","+ ИмяОбъекта);
			Начало = ТаблицаОтчета.НайтиТекст("+", Начало, ОбластьПоиска);
		КонецЦикла;
				
		НовоеСоответствие = СоответствиеВопросовОтветов.Добавить();
		НовоеСоответствие.Вопрос = ЭлементСписка.ТекстВопроса;
		НовоеСоответствие.Ответ = СтрокаОтвета;
	КонецЦикла;
	
	Текст = Новый ТекстовыйДокумент;
	Текст.Прочитать(ПутьКФайлуСОтветами);
	НашлиСтроку = Неопределено;
	ОбластьПримечаний = Ложь;
	КоличествоСтрок = Текст.КоличествоСтрок();
	ТекущаяСтрока = 0 ;
	Пока ТекущаяСтрока < КоличествоСтрок Цикл
		
		Строка = Текст.ПолучитьСтроку(ТекущаяСтрока);
		
		Если ОбластьПримечаний И Найти(Строка, "</Конфигурация") = 0 Тогда
			Текст.УдалитьСтроку(ТекущаяСтрока);
			Продолжить;
		КонецЕсли;
		
		Если ОбластьПримечаний Тогда
			ОбластьПримечаний = Ложь;
			Прервать;
		КонецЕсли;
		
		Если НашлиСтроку = Неопределено Тогда
			Для Каждого СтрокаТаблицы Из СоответствиеВопросовОтветов Цикл
				Если Найти(Строка, Строка("НомерПП="""+СтрокаТаблицы.Вопрос+"""")) > 0 Тогда
					НашлиСтроку = СтрокаТаблицы;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;		
		
		Если НашлиСтроку<> Неопределено И Найти(Строка, "<Ответ") > 0 Тогда
			Текст.ЗаменитьСтроку(ТекущаяСтрока, "<Ответ>"+СтрокаТаблицы.Ответ+"</Ответ>");
			НашлиСтроку = Неопределено;
		КонецЕсли;
		
		Если Найти(Строка, "<Примечание") > 0 Тогда
			ОбластьПримечаний = Истина;
			Продолжить;
		КонецЕсли;
		ТекущаяСтрока = ТекущаяСтрока + 1;
	КонецЦикла;
	
	// Определим и запишем данные по доп. вопросам
	
	Для Каждого ВопросОтвет Из СоответствиеВопросовОтветов Цикл
		Если ЭтоДопВопрос(ВопросОтвет.Вопрос) Тогда
			СтруктураДопВопроса = ПолучитьСтруктуруДопВопроса(ВопросОтвет.Вопрос);
			
			ИндексСтроки = Текст.КоличествоСтрок() - 1;
			СтрокаЗаголовка = "<НомерПППодчиненный>%1</НомерПППодчиненный>";
			СтрокаПараметра = "<ОбъектОтвета>%1</ОбъектОтвета>";
			СтрокаОтвета = "<Ответ>%1</Ответ>";
			
			ПодставитьПараметрИДописатьИтог(СтрокаЗаголовка, СтруктураДопВопроса.ИмяДополнительногоВопроса, ИндексСтроки, Текст);
			ПодставитьПараметрИДописатьИтог(СтрокаПараметра, СтруктураДопВопроса.ОбъектДопВопроса, ИндексСтроки, Текст);
			ПодставитьПараметрИДописатьИтог(СтрокаОтвета,ВопросОтвет.Ответ, ИндексСтроки, Текст);
			
		КонецЕсли;
	КонецЦикла;
	//Теперь определим и запишем примечания к тексту 
	
	КоличествоСтрок = ТаблицаОтчета.ВысотаТаблицы;
	КоличествоКолонок = ТаблицаОтчета.ШиринаТаблицы;
	ТекущаяСтрока = 1;
	ИндексСтроки = Текст.КоличествоСтрок() - 1;
	Пока ТекущаяСтрока <= КоличествоСтрок Цикл
		ТекущаяКолонка = 1;
		Пока ТекущаяКолонка <=КоличествоКолонок Цикл
			ИсследуемаяОбласть = ТаблицаОтчета.Область(ТекущаяСтрока, ТекущаяКолонка, ТекущаяСтрока, ТекущаяКолонка);
			Если Не ПустаяСтрока(ИсследуемаяОбласть.Примечание.Текст) Тогда
				СтрокаТекста = "<Примечание Адрес=""%1"" Текст=""%2""></Примечание>";
				ИмяОбъекта = ТаблицаОтчета.Область(ТекущаяСтрока, 1).Расшифровка;
                ИмяВопроса = СоответствиеВопросовНомерамКолонок[ТекущаяКолонка - 2].ТекстВопроса;
				СтрокаТекста = РеквизитФормыВЗначение("Объект").ПодставитьПараметрыВСтроку(СтрокаТекста, 
				Строка(ИмяОбъекта)+","+Строка(ИмяВопроса),
				СокрЛП(ИсследуемаяОбласть.Примечание.Текст));
				Текст.ВставитьСтроку(ИндексСтроки, СтрокаТекста);
			КонецЕсли;
			ТекущаяКолонка = ТекущаяКолонка + 1;
		КонецЦикла;
		ТекущаяСтрока = ТекущаяСтрока +1;	
	КонецЦикла;
	
	Текст.Записать(ПутьКФайлуСОтветами);
	
КонецПроцедуры

&НаСервере
Процедура ПодставитьПараметрИДописатьИтог(СтрокаВТекст, ПараметрСтроки, ИндексСтроки, ТекстовыйДокумент)
	ИтоговаяСтрока = СтрЗаменить(СтрокаВТекст,"%1", ПараметрСтроки);
	ТекстовыйДокумент.ВставитьСтроку(ИндексСтроки, ИтоговаяСтрока);
	ИндексСтроки = ИндексСтроки + 1;
КонецПроцедуры

&НаСервере
Функция ПолучитьСтруктуруДопВопроса(ИмяВопроса)
	СтруктураДопВопроса = Новый Структура;
	ПозКвадратнойСкобки = Найти(ИмяВопроса, "[");
	СтруктураДопВопроса.Вставить("ИмяВопросаРодителя", Лев(ИмяВопроса, ПозКвадратнойСкобки -1));
	ПозЗакрывающейКвадратнойСкобки = Найти(ИмяВопроса, "]");
	СтруктураДопВопроса.Вставить("ИмяДополнительногоВопроса", Сред(ИмяВопроса, ПозКвадратнойСкобки + 1, ПозЗакрывающейКвадратнойСкобки - ПозКвадратнойСкобки - 1));
	ПозЗакрывающейКруглойСкобки = Найти(ИмяВопроса, ")");
	СтруктураДопВопроса.Вставить("ОбъектДопВопроса", Сред(ИмяВопроса, ПозЗакрывающейКвадратнойСкобки + 2, ПозЗакрывающейКруглойСкобки - ПозЗакрывающейКвадратнойСкобки -2));
	Возврат СтруктураДопВопроса;
КонецФункции

&НаСервере
Функция ЭтоДопВопрос(ИмяВопроса)
	Если Найти(ИмяВопроса, "[")Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

&НаСервере
Функция ДобавитьОписаниеВопроса(НомерНачальнойКолонки, ИмяПодсистемы)
	Текст = РеквизитФормыВЗначение("Объект").ПолучитьМакет("ЭлектронныйВопросник");
	ИмяФайла = КаталогВременныхФайлов() + "ЗаписьВариантов.xml";
	Текст.Записать(ИмяФайла);
	НашлиПодсистему = Ложь;
	ЧтениеХМЛ = Новый ЧтениеXML;
	
	ЧтениеХМЛ.ОткрытьФайл(ИмяФайла);
	
	Пока ЧтениеХМЛ.Прочитать() Цикл
		Если ЧтениеХМЛ.ТипУзла = ТипУзлаXML.НачалоЭлемента  И
			ЧтениеХМЛ.ЛокальноеИмя = "Подсистема" И
			ЧтениеХМЛ.ПолучитьАтрибут("Имя") = ИмяПодсистемы Тогда			
			НашлиПодсистему = Истина;			
		КонецЕсли;
		
		Если НашлиПодсистему И ЧтениеХМЛ.ТипУзла  = ТипУзлаXML.НачалоЭлемента И
			ЧтениеХМЛ.ЛокальноеИмя = "Вопрос" И 
			Найти(ЧтениеХМЛ.ПолучитьАтрибут("Тип"), "ВыборОбъектов")> 0 И 
			Найти(ЧтениеХМЛ.ПолучитьАтрибут("Тип"), "Подсистемы") = 0 Тогда	
			НомерПП = ЧтениеХМЛ.ПолучитьАтрибут("НомерПП");
			
			Если СоответствиеВопросовНомерамКолонок.НайтиСтроки(Новый Структура("ТекстВопроса", НомерПП)).Количество() <> 0 Тогда
				Продолжить;
			КонецЕсли;					
			Запись = СоответствиеВопросовНомерамКолонок.Добавить();
			Запись.ТекстВопроса = НомерПП;
			Запись.Подсистема	= ИмяПодсистемы;
			
			Если ЕстьПодчиненныеВопросы(ЧтениеХМЛ, НомерПП) Тогда
				СтруктураОтветов = ПолучитьОтветыНаГлавныйВопрос(НомерПП);
				Если СтруктураОтветов <> Неопределено И СтруктураОтветов.Количество() >  0 Тогда
					ВывестиДопВопросы(ЧтениеХМЛ, НомерПП, СтруктураОтветов, СоответствиеВопросовНомерамКолонок, ИмяПодсистемы);
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЧтениеХМЛ.ТипУзла = ТипУзлаXML.КонецЭлемента  И
			ЧтениеХМЛ.ЛокальноеИмя = "Подсистема" И
			ЧтениеХМЛ.ПолучитьАтрибут("Имя") = ИмяПодсистемы Тогда
			Возврат СоответствиеВопросовНомерамКолонок.Количество();
		КонецЕсли;
	КонецЦикла;
	Возврат СоответствиеВопросовНомерамКолонок.Количество();
КонецФункции

&НаСервере
Функция ЕстьПодчиненныеВопросы(ЧтениеХМЛ, НомерПП)
	Пока ЧтениеХМЛ.Прочитать() Цикл
		Если ЧтениеХМЛ.ЛокальноеИмя = "Вопрос" И ЧтениеХМЛ.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если ЧтениеХМЛ.ЛокальноеИмя = "ПодчиненныеВопросы" Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
КонецФункции

&НаСервере
Функция ПолучитьОтветыНаГлавныйВопрос(НомерПП)
	МассивОтветов = Новый Массив;
	
	ПутьКФайлуДанных = ?(ПустаяСтрока(ПутьКФайлу), ПутьКВременномуФайлуДанных, ПутьКФайлу);
	НашлиВопрос = Ложь;
	ЧтениеХМЛ = Новый ЧтениеXML;
	Попытка 
		// если проводится проверка текущего состояния - сначала файла нет 
		ЧтениеХМЛ.ОткрытьФайл(ПутьКФайлуДанных);
	Исключение
		Возврат "";
	КонецПопытки;
	
	Пока ЧтениеХМЛ.Прочитать() Цикл
		Если Не НашлиВопрос Тогда
			Если ЧтениеХМЛ.ПолучитьАтрибут("НомерПП") = НомерПП Тогда
				НашлиВопрос = Истина;
			КонецЕсли;
		ИначеЕсли ЧтениеХМЛ.ЛокальноеИмя = ("Ответ") И ЧтениеХМЛ.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			ЧтениеХМЛ.Прочитать();
			МассивОтветов = РеквизитФормыВЗначение("Объект").РазложитьСтрокуВМассивПодстрок(ЧтениеХМЛ.Значение);
			Возврат МассивОтветов;
		ИначеЕсли ЧтениеХМЛ.ЛокальноеИмя = "Вопрос" И ЧтениеХМЛ.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
			Возврат МассивОтветов;
		КонецЕсли;	
	КонецЦикла;
	Возврат Неопределено;
КонецФункции

&НаСервере
Функция ОпределитьДополнительныеВопросы(ЧтениеХМЛ)
	МассивВозврата = Новый Массив;
	Пока ЧтениеХМЛ.Прочитать() Цикл
		Если ЧтениеХМЛ.ЛокальноеИмя = "НомерПППодчиненный" И ЧтениеХМЛ.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			ЧтениеХМЛ.Прочитать();
			МассивВозврата.Добавить(ЧтениеХМЛ.Значение);
		КонецЕсли;
		
		Если ЧтениеХМЛ.ЛокальноеИмя = "ПодчиненныеВопросы" И ЧтениеХМЛ.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
			Возврат МассивВозврата;
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

&НаСервере
Процедура ВывестиДопВопросы(ЧтениеХМЛ, НомерПП, СтруктураОтветов, Соответствие, ИмяПодсистемы)
	МассивДопВопросов = ОпределитьДополнительныеВопросы(ЧтениеХМЛ);
	Для Каждого ДопВопрос Из МассивДопВопросов Цикл
		Для Каждого ДопЭлемент Из СтруктураОтветов Цикл
			НовыйНомерПП = НомерПП+"["+ДопВопрос+"]" + "("+ДопЭлемент+")";
			Запись = СоответствиеВопросовНомерамКолонок.Добавить();
			Запись.ТекстВопроса = НовыйНомерПП;
			Запись.Подсистема	= ИмяПодсистемы;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ОпределитьТекстВопроса(НомерВСписке)
	ТекстСВопросами = РеквизитФормыВЗначение("Объект").ПолучитьМакет("ЭлектронныйВопросник");
	НомерВопроса = СоответствиеВопросовНомерамКолонок[НомерВСписке].ТекстВопроса;
	НашлиВопрос = ЛожЬ;
	КоличествоСтрокТекста = ТекстСВопросами.КоличествоСтрок();
	ТекущаяСтрока = 0;
	Пока ТекущаяСтрока < КоличествоСтрокТекста Цикл
		СтрокаТекста = ТекстСВопросами.ПолучитьСтроку(ТекущаяСтрока);
		Если Найти(СтрокаТекста, НомерВопроса) = 0 Тогда
			ТекущаяСтрока = ТекущаяСтрока + 1;
		Иначе
			НашлиВопрос = Истина;
		КонецЕсли;
		
		Если Не НашлиВопрос Тогда
			Продолжить;
		КонецЕсли;
		
		Если Найти(СтрокаТекста, "<Текст>") >0 Тогда
			СтрокаВозврата = СтрЗаменить(СтрокаТекста, "<Текст>", "");
			СтрокаВозврата = СтрЗаменить(СтрокаВозврата, "</Текст>", "");
			Возврат СтрокаВозврата;
		Иначе
			ТекущаяСтрока = ТекущаяСтрока + 1;
		КонецЕсли;
	КонецЦикла;
КонецФункции

&НаКлиенте
Функция ПроверитьИмяФайла()
	Если ПустаяСтрока(ПутьКФайлу) Тогда
		ПутьКФайлу = ПутьКВременномуФайлуДанных;
	КонецЕсли;
	Возврат Истина;
КонецФункции

&НаСервере
Процедура ИзменитьВидимостьОбластейТаблицы(ВидимыеСтроки = Неопределено, ВидимыеКолонки = Неопределено, ОтборПоОбъектам = "")
	//по колонкам
	КоличествоКолонок = ТаблицаОтчета.ШиринаТаблицы;
	ТекущаяКолонка = 2;
	Пока ТекущаяКолонка <= КоличествоКолонок Цикл
		Если ВидимыеКолонки = Неопределено Тогда
			ТаблицаОтчета.Область(, ТекущаяКолонка,, ТекущаяКолонка).Видимость = Истина;
		ИначеЕсли ВидимыеКолонки.Найти(ТекущаяКолонка) = Неопределено  Тогда
			ТаблицаОтчета.Область(, ТекущаяКолонка,, ТекущаяКолонка).Видимость = Ложь;			
		Иначе
			ТаблицаОтчета.Область(, ТекущаяКолонка,, ТекущаяКолонка).Видимость =Истина;
		КонецЕсли;
		ТекущаяКолонка = ТекущаяКолонка + 1;
	КонецЦикла;
	
	//по строкам
	КоличествоСтрок = ТаблицаОтчета.ВысотаТаблицы;
	ТекущаяСтрока = 3;
	ОтборПоОшибкам = (ОтборПоОбъектам = "Ошибки");
	
	Пока ТекущаяСтрока <= КоличествоСтрок Цикл
		Если ВидимыеСтроки = Неопределено Тогда
			ОпределитьВидимость(ТекущаяСтрока, ВидимыеКолонки);
		ИначеЕсли ВидимыеСтроки.Найти(ТекущаяСтрока) = Неопределено Тогда
			
			Если ОтборПоОшибкам Тогда
				
				ТаблицаОтчета.Область(ТекущаяСтрока, , ТекущаяСтрока).Видимость = Ложь;
				
			Иначе
				
				Если ТаблицаОтчета.Область(ТекущаяСтрока, 1, ТекущаяСтрока, 1).Шрифт.Жирный = Ложь Тогда
					ТаблицаОтчета.Область(ТекущаяСтрока, , ТекущаяСтрока).Видимость = Ложь;
				Иначе
					ОпределитьВидимость(ТекущаяСтрока, ВидимыеКолонки);
				КонецЕсли;
				
			КонецЕсли;
			
		Иначе
			
			Если ОтборПоОшибкам Тогда
				ТаблицаОтчета.Область(ТекущаяСтрока, , ТекущаяСтрока).Видимость = Истина;
			Иначе
				ОпределитьВидимость(ТекущаяСтрока, ВидимыеКолонки);
			КонецЕсли;
			
		КонецЕсли;
		ТекущаяСтрока = ТекущаяСтрока + 1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьВидимость(ТекущаяСтрока, ВидимыеКолонки)
	Для Каждого ВидимаяКолонка Из ВидимыеКолонки Цикл
		Если НЕ ТаблицаОтчета.Область(ТекущаяСтрока, ВидимаяКолонка, ТекущаяСтрока, ВидимаяКолонка).Защита Тогда
			ТаблицаОтчета.Область(ТекущаяСтрока, ,ТекущаяСтрока).Видимость = Истина;
			Возврат;
		КонецЕсли;
	КонецЦикла;
	ТаблицаОтчета.Область(ТекущаяСтрока, ,ТекущаяСтрока).Видимость = Ложь;
КонецПроцедуры

&НаСервере
Функция НайтиЯчейки(ПараметрПоиска, ВидимыеКолонки)
	МассивСтрок = Новый Структура("Строки, Колонки", Новый Массив, Новый Массив);
	КоличествоСтрок = ТаблицаОтчета.ВысотаТаблицы;
	КоличествоКолонок = ТаблицаОтчета.ШиринаТаблицы;
	
	Если ПараметрПоиска = "Отмеченные" Тогда
		ОбластьОтметки = ТаблицаОтчета.НайтиТекст("+");
		Пока ОбластьОтметки <> Неопределено  Цикл
			
			Если ВидимыеКолонки.Найти(ОбластьОтметки.Лево)<> Неопределено Тогда	
				МассивСтрок.Строки.Добавить(ОбластьОтметки.Верх);
				МассивСтрок.Колонки.Добавить(ОбластьОтметки.Лево);
			КонецЕсли;
			ОбластьОтметки = ТаблицаОтчета.НайтиТекст("+", ОбластьОтметки);
		КонецЦикла;
	КонецЕсли;
	
	Если ПараметрПоиска = "Ошибки" Тогда
		
		НачальнаяСтрока = 4;
		Пока НачальнаяСтрока <= КоличествоСтрок Цикл
			НачальнаяКолонка = 2;
			Пока НачальнаяКолонка <= КоличествоКолонок Цикл
				Если ВидимыеКолонки.Найти(НачальнаяКолонка) = Неопределено Тогда
					НачальнаяКолонка = НачальнаяКолонка + 1;
					Продолжить;
				КонецЕсли;
				
				ОбластьПроверки = ТаблицаОтчета.Область(НачальнаяСтрока, НачальнаяКолонка, НачальнаяСтрока, НачальнаяКолонка);
				ОбластьЗаголовка = ТаблицаОтчета.Область(НачальнаяСтрока, 1, НачальнаяСтрока, 1);
				
				Если ОбластьЗаголовка.Шрифт.Жирный Тогда
					ТекущийЗаголовок = НачальнаяСтрока;
				КонецЕсли;
				
				Если ОбластьПроверки.ЦветФона = Новый Цвет(255,127,80) ИЛИ ОбластьПроверки.ЦветФона =  Новый Цвет(253,233,16) Тогда
					Если МассивСтрок.Строки.Найти(ТекущийЗаголовок) = Неопределено Тогда
						МассивСтрок.Строки.Добавить(ТекущийЗаголовок);
					КонецЕсли;
					МассивСтрок.Строки.Добавить(НачальнаяСтрока);
					МассивСтрок.Колонки.Добавить(НачальнаяКолонка);
				КонецЕсли;
				НачальнаяКолонка = НачальнаяКолонка + 1;
			КонецЦикла;
			НачальнаяСтрока = НачальнаяСтрока + 1;
		КонецЦикла;
	КонецЕсли;
	
	Если ПараметрПоиска = "Изменения" Тогда
		НачальнаяСтрока = 4;
		Пока НачальнаяСтрока <= КоличествоСтрок Цикл
			НачальнаяКолонка = 2;
			Пока НачальнаяКолонка <= КоличествоКолонок Цикл
				Если ВидимыеКолонки.Найти(НачальнаяКолонка) = Неопределено Тогда
					НачальнаяКолонка = НачальнаяКолонка + 1;
					Продолжить;
				КонецЕсли;
				ОбластьПроверки = ТаблицаОтчета.Область(НачальнаяСтрока, НачальнаяКолонка, НачальнаяСтрока, НачальнаяКолонка);
				Если ОбластьПроверки.Узор = ТипУзораТабличногоДокумента.Узор14 ИЛИ 
					(ОбластьПроверки.Текст = "+" И ОбластьПроверки.ЦветТекста = НОвый Цвет (51, 102, 255)) Тогда
					
					МассивСтрок.Строки.Добавить(НачальнаяСтрока);
					МассивСтрок.Колонки.Добавить(НачальнаяКолонка);
				КонецЕсли;
				НачальнаяКолонка = НачальнаяКолонка + 1;
			КонецЦикла;
			НачальнаяСтрока = НачальнаяСтрока + 1;
		КонецЦикла;
	КонецЕсли;	
	Возврат МассивСтрок;
КонецФункции

&НаКлиенте
Процедура ОбработатьПользовательскиеОтборы()
	// по подсистемам
	СписокВопросов = ОпределитьСписокВопросовПоПодсистемам(ОтборПоПодсистемам);
	ВидимыеКолонки = Новый Массив;
	
	Для Каждого ЭлементКолонки Из СоответствиеВопросовНомерамКолонок Цикл
		ПозицияСкобки = Найти(ЭлементКолонки.ТекстВопроса, "[");
		Если ПозицияСкобки = 0 Тогда 
			ИмяВопроса = ЭлементКолонки.ТекстВопроса;
		Иначе
			ИмяВопроса = Лев(ЭлементКолонки.ТекстВопроса, ПозицияСкобки-1);
		КонецЕсли;
		
		Если СписокВопросов.Найти(ИмяВопроса) <> Неопределено Тогда
			ВидимыеКолонки.Добавить(СоответствиеВопросовНомерамКолонок.Индекс(ЭлементКолонки)+2);
		КонецЕсли;
	КонецЦикла;
	
	// по ошибкам
	Если ОтборПоОбъектам = "Все" Тогда
		ИзменитьВидимостьОбластейТаблицы(,ВидимыеКолонки);
	Иначе СтруктураСтрок = НайтиЯчейки(ОтборПоОбъектам, ВидимыеКолонки);
		МассивПересеченийКолонокПоОтборам = Новый Массив;
		ВычислитьПересечениеМассивов(ВидимыеКолонки, СтруктураСтрок.Колонки, , , МассивПересеченийКолонокПоОтборам);
		ИзменитьВидимостьОбластейТаблицы(СтруктураСтрок.Строки, МассивПересеченийКолонокПоОтборам, ОтборПоОбъектам);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ОпределитьСписокВопросовПоПодсистемам(ОтборПоПодсистемам)
	МассивВозврата = Новый Массив;
	Текст = РеквизитФормыВЗначение("Объект").ПолучитьМакет("ЭлектронныйВопросник");
	ИмяФайла = КаталогВременныхФайлов() + "ЗаписьВариантов.xml";
	Текст.Записать(ИмяФайла);
	НашлиПодсистему = Ложь;
	ЧтениеХМЛ = Новый ЧтениеXML;
	
	ЧтениеХМЛ.ОткрытьФайл(ИмяФайла);
	
	Пока ЧтениеХМЛ.Прочитать() Цикл
		Если ЧтениеХМЛ.ТипУзла = ТипУзлаXML.НачалоЭлемента  И
			ЧтениеХМЛ.ЛокальноеИмя = "Подсистема" И
			ОтборПоПодсистемам.НайтиПоЗначению(ЧтениеХМЛ.ПолучитьАтрибут("Имя")) <> Неопределено Тогда			
			НашлиПодсистему = Истина;			
		КонецЕсли;
		
		Если НашлиПодсистему И ЧтениеХМЛ.ТипУзла  = ТипУзлаXML.НачалоЭлемента И
			ЧтениеХМЛ.ЛокальноеИмя = "Вопрос" И 
			Найти(ЧтениеХМЛ.ПолучитьАтрибут("Тип"), "ВыборОбъектов")> 0 И 
			Найти(ЧтениеХМЛ.ПолучитьАтрибут("Тип"), "Подсистемы") = 0 Тогда	
			НомерПП = ЧтениеХМЛ.ПолучитьАтрибут("НомерПП");
			МассивВозврата.Добавить(НомерПП);
		КонецЕсли;
		
		Если ЧтениеХМЛ.ТипУзла = ТипУзлаXML.КонецЭлемента  И
			ЧтениеХМЛ.ЛокальноеИмя = "Подсистема" И
			НашлиПодсистему Тогда
			
			НашлиПодсистему = Ложь;
			
		КонецЕсли;
	КонецЦикла;
	Возврат МассивВозврата;
КонецФункции

&НаСервере
Функция ВернутьОписаниеОшибкиПоТекущемуАдресу(Адрес)
	ПараметрыОтбора = Новый Структура("Адрес", Адрес);
	СтрокиОповещений = СтруктураОписанияОшибок.НайтиСтроки(ПараметрыОтбора);
	Если СтрокиОповещений.Количество() > 0 Тогда
		Возврат СтрокиОповещений[0].ОписаниеОшибки;
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

&НаСервере
Процедура ЗаполнитьОтборНаСервере(СписокВыбранныхПодсистем)
	ОтборПоПодсистемам.Очистить();
	Для Каждого ЭлементСписка Из СписокВыбранныхПодсистем Цикл
		ИмяПодсистемыВМакете = Метаданные.НайтиПоПолномуИмени(ЭлементСписка.Значение).Имя;
		ОтборПоПодсистемам.Добавить(ИмяПодсистемыВМакете);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПодготовитьСписокПодсистем()
	
	СтандартныеПодсистемы = Метаданные.Подсистемы.Найти("СтандартныеПодсистемы");
	Если СтандартныеПодсистемы = Неопределено Тогда
		ВызватьИсключение Нстр("ru = 'Ошибка внедрения БСП. Группа подсистем ""СтандартныеПодсистемы"" не найдена в метаданных конфигурации базы данных.'");
	КонецЕсли;
	
	СписокСтандартныхПодсистемВКонфигурации = СтандартныеПодсистемы.Подсистемы;
	
	СписокВозврата = Новый СписокЗначений;
	Для каждого ПодсистемаОтбора Из ОтборПоПодсистемам Цикл	
		Для Каждого СтандартнаяПодсистема Из СписокСтандартныхПодсистемВКонфигурации Цикл
			Если СтандартнаяПодсистема.Имя = ПодсистемаОтбора.Значение Тогда
				ИмяПодсистемы = СтандартнаяПодсистема.ПолноеИмя();
				СписокВозврата.Добавить(ИмяПодсистемы);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	Возврат СписокВозврата;
	
КонецФункции

&НаКлиенте
Процедура ВычислитьПересечениеМассивов(Массив1, Массив2, МассивРезультат1 = Неопределено, МассивРезультат2 = Неопределено, МассивРезультат12 = Неопределено)
	
	МассивРезультат1  = ?(МассивРезультат1  = Неопределено, Новый Массив, МассивРезультат1);
	МассивРезультат2  = ?(МассивРезультат2  = Неопределено, Новый Массив, МассивРезультат2);
	МассивРезультат12 = ?(МассивРезультат12 = Неопределено, Новый Массив, МассивРезультат12);
	
	Для Каждого Значение Из Массив1 Цикл
		
		Если Массив2.Найти(Значение) = Неопределено Тогда
			
			Если МассивРезультат1.Найти(Значение) = Неопределено Тогда
				
				МассивРезультат1.Добавить(Значение);
				
			КонецЕсли;
			
		Иначе
			
			Если МассивРезультат12.Найти(Значение) = Неопределено Тогда
				
				МассивРезультат12.Добавить(Значение);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Значение Из Массив2 Цикл
		
		Если Массив1.Найти(Значение) = Неопределено Тогда
			
			Если МассивРезультат2.Найти(Значение) = Неопределено Тогда
				
				МассивРезультат2.Добавить(Значение);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
