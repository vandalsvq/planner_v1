﻿&НаКлиенте
Перем ОткрытаФормаВыбораИсполнителя;  // признак того, что исполнитель выбирается из формы, а не быстрым вводом
&НаКлиенте
Перем ОткрытаФормаВыбораПроверяющего; // признак того, что проверяющий выбирается из формы, а не быстрым вводом
&НаКлиенте
Перем КонтекстВыбора;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Для нового объекта выполняем код инициализации формы в ПриСозданииНаСервере.
	// Для существующего - в ПриЧтенииНаСервере.
	Если Объект.Ссылка.Пустая() Тогда
		ИнициализацияФормы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьДоступностьКомандОстановки();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ИнициализацияФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ВыборРолиИсполнителя") Тогда
		
		Если КонтекстВыбора = "ИсполнительПриИзменении" Тогда
			
			Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
				Объект.Исполнитель = ВыбранноеЗначение.РольИсполнителя;
			КонецЕсли;
			
			УстановитьДоступностьПроверяющего(ЭтотОбъект);
			
		ИначеЕсли КонтекстВыбора = "ПроверяющийПриИзменении" Тогда
			
			Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
				Объект.Проверяющий = ВыбранноеЗначение.РольИсполнителя;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ИзменятьЗаданияЗаднимЧислом = ПолучитьФункциональнуюОпцию("ИзменятьЗаданияЗаднимЧислом");
	Если НачальныйПризнакСтарта И ИзменятьЗаданияЗаднимЧислом Тогда
		УстановитьПривилегированныйРежим(Истина); 
		ТекущийОбъект.ИзменитьРеквизитыНевыполненныхЗадач();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_Задание", ПараметрыЗаписи, Объект.Ссылка);
	Оповестить("Запись_ЗадачаИсполнителя", ПараметрыЗаписи, Неопределено);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаПроверкеПриИзменении(Элемент)
	
	УстановитьДоступностьПроверяющего(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(,Объект.Предмет);
	
КонецПроцедуры

&НаКлиенте
Процедура ГлавнаяЗадачаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(,Объект.ГлавнаяЗадача);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	БизнесПроцессыИЗадачиКлиент.ВыбратьИсполнителя(Элемент, Объект.Исполнитель);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	
	Если ОткрытаФормаВыбораИсполнителя = Истина Тогда
		Возврат;
	КонецЕсли;
	
	ОсновнойОбъектАдресации = Неопределено;
	ДополнительныйОбъектАдресации = Неопределено;
	
	Если ТипЗнч(Объект.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") И ЗначениеЗаполнено(Объект.Исполнитель) Тогда 
		
		Если ИспользуетсяСОбъектамиАдресации(Объект.Исполнитель) Тогда 
			
			КонтекстВыбора = "ИсполнительПриИзменении";
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("РольИсполнителя", Объект.Исполнитель);
			ПараметрыФормы.Вставить("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
			ПараметрыФормы.Вставить("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
			
			ОткрытьФорму("ОбщаяФорма.ВыборРолиИсполнителя", ПараметрыФормы, ЭтотОбъект);
			
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьДоступностьПроверяющего(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОткрытаФормаВыбораИсполнителя = ТипЗнч(ВыбранноеЗначение) = Тип("Структура");
	Если ОткрытаФормаВыбораИсполнителя Тогда
		СтандартнаяОбработка = Ложь;
		Объект.Исполнитель = ВыбранноеЗначение.РольИсполнителя;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БизнесПроцессыИЗадачиВызовСервера.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БизнесПроцессыИЗадачиВызовСервера.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	БизнесПроцессыИЗадачиКлиент.ВыбратьИсполнителя(Элемент, Объект.Проверяющий);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийПриИзменении(Элемент)
	
	Если ОткрытаФормаВыбораПроверяющего = Истина Тогда
		Возврат;
	КонецЕсли;
	
	ОсновнойОбъектАдресации = Неопределено;
	ДополнительныйОбъектАдресации = Неопределено;
	
	Если ТипЗнч(Объект.Проверяющий) = Тип("СправочникСсылка.РолиИсполнителей") И ЗначениеЗаполнено(Объект.Проверяющий) Тогда
		
		Если ИспользуетсяСОбъектамиАдресации(Объект.Проверяющий) Тогда
			
			КонтекстВыбора = "ПроверяющийПриИзменении";
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("РольИсполнителя", Объект.Проверяющий);
			ПараметрыФормы.Вставить("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
			ПараметрыФормы.Вставить("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
			
			ОткрытьФорму("ОбщаяФорма.ВыборРолиИсполнителя", ПараметрыФормы, ЭтотОбъект);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОткрытаФормаВыбораПроверяющего = ТипЗнч(ВыбранноеЗначение) = Тип("Структура");
	Если ОткрытаФормаВыбораПроверяющего Тогда
		СтандартнаяОбработка = Ложь;
		
		Объект.Проверяющий = ВыбранноеЗначение.РольИсполнителя;
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БизнесПроцессыИЗадачиВызовСервера.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БизнесПроцессыИЗадачиВызовСервера.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияПриИзменении(Элемент)
	Если Объект.СрокИсполнения = НачалоДня(Объект.СрокИсполнения) Тогда
		Объект.СрокИсполнения = КонецДня(Объект.СрокИсполнения);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СрокПроверкиПриИзменении(Элемент)
	Если Объект.СрокПроверки = НачалоДня(Объект.СрокПроверки) Тогда
		Объект.СрокПроверки = КонецДня(Объект.СрокПроверки);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;	
	КонецЕсли;
	
	Записать();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Остановить(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОстановитьБизнесПроцессИзФормыОбъекта(ЭтотОбъект);
	ОбновитьДоступностьКомандОстановки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьБизнесПроцесс(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ПродолжитьБизнесПроцессИзФормыОбъекта(ЭтотОбъект);
	ОбновитьДоступностьКомандОстановки();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Проверяющий.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НаПроверке");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Проверяющий");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Проверяющий.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НаПроверке");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Проверяющий");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

КонецПроцедуры

&НаСервере
Процедура ИнициализацияФормы()
	
	НачальныйПризнакСтарта = Объект.Стартован;
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.СрокПроверкиВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.Дата.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	
	Элементы.Предмет.Гиперссылка = Объект.Предмет <> Неопределено И НЕ Объект.Предмет.Пустая();
	ПредметСтрокой = ОбщегоНазначения.ПредметСтрокой(Объект.Предмет);
	Элементы.ГруппаСостояние.Видимость = Объект.Завершен Или Объект.Стартован;
	Если Объект.Завершен Тогда
		ДатаЗавершенияСтрокой = ?(ИспользоватьДатуИВремяВСрокахЗадач, 
			Формат(Объект.ДатаЗавершения, "ДЛФ=DT"), Формат(Объект.ДатаЗавершения, "ДЛФ=D"));
		ТекстСостояния = ?(Объект.Выполнено, 
			НСтр("ru = 'Задание выполнено %1.'"), 
			НСтр("ru = 'Задание отменено %1.'"));
		Элементы.ДекорацияТекст.Заголовок =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСостояния,	
				ДатаЗавершенияСтрокой);
				
		Для каждого Элемент Из Элементы Цикл
			Если ТипЗнч(Элемент) <> Тип("ПолеФормы") И ТипЗнч(Элемент) <> Тип("ГруппаФормы") Тогда
				Продолжить;
			КонецЕсли;
			Элемент.ТолькоПросмотр = Истина;
		КонецЦикла;	
		
	Иначе
		
		ТекстСостояния = ?(ПолучитьФункциональнуюОпцию("ИзменятьЗаданияЗаднимЧислом"), 
			НСтр("ru = 'Изменения формулировки, важности, автора, а также перенос сроков исполнения и проверки задания 
				|вступят в силу немедленно для ранее выданной задачи.'"), 
			НСтр("ru = 'Изменения формулировки, важности, автора, а также перенос сроков исполнения и проверки задания 
				|не будут отражены в ранее выданной задаче.'"));
		Элементы.ДекорацияТекст.Заголовок = ТекстСостояния;
	КонецЕсли;
	
	Элементы.ФормаСтартИЗакрыть.Видимость = Не Объект.Стартован; 
	Элементы.ФормаСтартИЗакрыть.КнопкаПоУмолчанию = Не Объект.Стартован;
	Элементы.ФормаСтарт.Видимость = Не Объект.Стартован; 
	Элементы.ФормаЗаписатьИЗакрыть.Видимость = Объект.Стартован; 
	Элементы.ФормаЗаписатьИЗакрыть.КнопкаПоУмолчанию = Объект.Стартован;
	
	Если Объект.ГлавнаяЗадача = Неопределено Или Объект.ГлавнаяЗадача.Пустая() Тогда
		Элементы.ГлавнаяЗадача.Гиперссылка = Ложь;
		ГлавнаяЗадачаСтрокой = НСтр("ru = 'не задана'");
	Иначе	
		ГлавнаяЗадачаСтрокой = Строка(Объект.ГлавнаяЗадача);
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПодчиненныеБизнесПроцессы") Тогда
		Элементы.ГлавнаяЗадача.Видимость = Ложь;
	КонецЕсли;
	
	БизнесПроцессыИЗадачиСервер.ПриОпределенииИспользованияВнешнихЗадачИБизнесПроцессов(ИспользоватьВнешниеЗадачиИБизнесПроцессы);
	
	УстановитьДоступностьПроверяющего(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступностьКомандОстановки()
	
	Если Объект.Завершен Тогда
		
		Элементы.ФормаОстановить.Доступность = Ложь;
		Элементы.ФормаПродолжить.Доступность = Ложь;
		Возврат;
		
	КонецЕсли;
	
	Если Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияБизнесПроцессов.Остановлен") Тогда
		Элементы.ФормаОстановить.Доступность = Ложь;
		Элементы.ФормаПродолжить.Доступность = Истина;
	Иначе
		Элементы.ФормаОстановить.Доступность = Истина;
		Элементы.ФормаПродолжить.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьПроверяющего(Форма)
	
	ДоступностьПоля = Форма.Объект.НаПроверке;
	Форма.Элементы.ГруппаПроверяющий.Доступность = ДоступностьПоля;
	
	Если Не Форма.ИспользоватьВнешниеЗадачиИБизнесПроцессы Тогда
		Возврат;
	КонецЕсли;
		
	Если ТипЗнч(Форма.Объект.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") 
		И ЗначениеЗаполнено(Форма.Объект.Исполнитель) Тогда
		
		ВнешняяРоль = ВнешняяРольИсполнителя(Форма.Объект.Исполнитель);
		
		Если ВнешняяРоль Тогда
			Форма.Объект.Проверяющий = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
			Форма.Объект.НаПроверке = Ложь;
			Форма.Элементы.ГруппаПроверка.Доступность = Ложь;
		Иначе	
			Форма.Элементы.ГруппаПроверка.Доступность = Истина;
		КонецЕсли;
	Иначе	
		Форма.Элементы.ГруппаПроверка.Доступность = Истина;
	КонецЕсли;
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИспользуетсяСОбъектамиАдресации(ПроверяемыйОбъект)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПроверяемыйОбъект, "ИспользуетсяСОбъектамиАдресации");
	
КонецФункции

&НаСервереБезКонтекста
Функция ВнешняяРольИсполнителя(Исполнитель)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Исполнитель, "ВнешняяРоль");
КонецФункции

#КонецОбласти
