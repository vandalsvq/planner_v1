﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ЗаголовокФормы") Тогда
		Заголовок = Параметры.ЗаголовокФормы;
	КонецЕсли;
	
	Если Параметры.Свойство("ВладелецФайла") Тогда 
		Список.Параметры.УстановитьЗначениеПараметра("Владелец", Параметры.ВладелецФайла);
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущийПользователь", Пользователи.ТекущийПользователь());
	
	РаботаСФайламиСлужебныйВызовСервера.ЗаполнитьУсловноеОформлениеСпискаФайлов(Список);
	
	Если РаботаСФайламиСлужебныйВызовСервера.ПолучитьИспользоватьЭлектронныеПодписиИШифрование() = Ложь Тогда
		Элементы.СписокНомерКартинкиПодписанЗашифрован.Видимость = Ложь;
	КонецЕсли;
	
	ПоказыватьКолонкуРазмер = РаботаСФайламиСлужебныйВызовСервера.ПолучитьПоказыватьКолонкуРазмер();
	Если ПоказыватьКолонкуРазмер = Ложь Тогда
		Элементы.СписокТекущаяВерсияРазмер.Видимость = Ложь;
	КонецЕсли;
	
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		Элементы.ФормаИзменить.Видимость = Ложь;
		Элементы.ФормаИзменить82.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.ФормаСоздатьСоСканера.Видимость = РаботаСФайламиСлужебныйКлиент.ДоступнаКомандаСканировать();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИмпортФайловЗавершен" Тогда
		Элементы.Список.Обновить();
		
		Если Параметр <> Неопределено Тогда
			Элементы.Список.ТекущаяСтрока = Параметр;
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "СозданФайл" Тогда
		
		Если Параметр <> Неопределено Тогда
			
			ВладелецФайлаСписка = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Владелец"));
			
			ВладелецФайла = Неопределено;
			Если Параметр.Свойство("Владелец", ВладелецФайла) Тогда
				Если ВладелецФайла = ВладелецФайлаСписка.Значение Тогда
					Элементы.Список.Обновить();
					
					ФайлСозданный = Неопределено;
					Если Параметр.Свойство("Файл", ФайлСозданный) Тогда
						Элементы.Список.ТекущаяСтрока = ФайлСозданный;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ДанныеФайлаИзменены" Тогда
		Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
			УстановитьДоступностьФайловыхКоманд();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если ТипЗнч(ВыбраннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ПерсональныеНастройки = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами();
	КакОткрывать = ПерсональныеНастройки.ДействиеПоДвойномуЩелчкуМыши;
	
	Если КакОткрывать = "ОткрыватьКарточку" Тогда
		ПоказатьЗначение(, ВыбраннаяСтрока);
		Возврат;
	КонецЕсли;
	
	ИмяКаталога = ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя();
	Если ИмяКаталога = Неопределено ИЛИ ПустаяСтрока(ИмяКаталога) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
		ВыбраннаяСтрока,
		Неопределено,
		УникальныйИдентификатор,
		Неопределено,
		ПредыдущийАдресФайла);
	
	// Если уже занят для редактирования, то не спрашивать - сразу открывать
	Если ДанныеФайла.Редактирует.Пустая() Тогда
		СпрашиватьРежимРедактированияПриОткрытииФайла = ПерсональныеНастройки.СпрашиватьРежимРедактированияПриОткрытииФайла;
		Если СпрашиватьРежимРедактированияПриОткрытииФайла = Истина Тогда
			ПараметрыОбработчика = Новый Структура;
			ПараметрыОбработчика.Вставить("ДанныеФайла", ДанныеФайла);
			Обработчик = Новый ОписаниеОповещения("СписокВыборПослеВыбораРежимаОткрытия", ЭтотОбъект, ПараметрыОбработчика);
			ОткрытьФорму("Справочник.Файлы.Форма.ФормаВыбораРежимаОткрытия", , ЭтотОбъект, , , , Обработчик, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	// Для просмотра.
	РаботаСФайламиСлужебныйКлиент.ОткрытьФайлСОповещением(Неопределено, ДанныеФайла, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура СписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
	
	ЗначениеПараметраКД = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Владелец"));
	Если ЗначениеПараметраКД = Неопределено Тогда
		ВладелецФайла = Неопределено;
	Иначе
		ВладелецФайла = ЗначениеПараметраКД.Значение;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ВладелецФайла) Тогда
		Возврат;
	КонецЕсли;
	
	ОбработкаПеретаскиванияВЛинейныйСписок(ПараметрыПеретаскивания, ВладелецФайла);
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
	ФайлОснование = Элементы.Список.ТекущаяСтрока;
	
	ЗначениеПараметраКД = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Владелец"));
	Если ЗначениеПараметраКД = Неопределено Тогда
		ВладелецФайла = Неопределено;
	Иначе
		ВладелецФайла = ЗначениеПараметраКД.Значение;
	КонецЕсли;
	
	Если Копирование Тогда
		РаботаСФайламиКлиент.СкопироватьФайл(ВладелецФайла, ФайлОснование);
	Иначе
		РаботаСФайламиСлужебныйКлиент.ДобавитьФайл(Неопределено, ВладелецФайла, ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		УстановитьДоступностьФайловыхКоманд();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	ФайлСсылка = Элементы.Список.ТекущаяСтрока;
	Если Не ФайловыеКомандыДоступны(ФайлСсылка) Тогда 
		Возврат;
	КонецЕсли;
	ДанныеФайла = Элементы.Список.ТекущиеДанные;
	
	Обработчик = Новый ОписаниеОповещения("ЗакончитьРедактированиеЗавершение", ЭтотОбъект);
	
	РаботаСФайламиСлужебныйКлиент.ЗакончитьРедактированиеСОповещением(
		Обработчик,
		ФайлСсылка,
		УникальныйИдентификатор,
		ДанныеФайла.ХранитьВерсии,
		ДанныеФайла.РедактируетТекущийПользователь,
		ДанныеФайла.Редактирует);
	
КонецПроцедуры

&НаКлиенте
Процедура Занять(Команда)
	
	ФайлСсылка = Элементы.Список.ТекущаяСтрока;
	Если Не ФайловыеКомандыДоступны(ФайлСсылка) Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ЗанятьЗавершение", ЭтотОбъект);
	РаботаСФайламиСлужебныйКлиент.ЗанятьСОповещением(
		Обработчик,
		ФайлСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	
	ФайлСсылка = Элементы.Список.ТекущаяСтрока;
	Если Не ФайловыеКомандыДоступны(ФайлСсылка) Тогда 
		Возврат;
	КонецЕсли;
	ДанныеФайла = Элементы.Список.ТекущиеДанные;
	
	Обработчик = Новый ОписаниеОповещения("ОсвободитьЗавершение", ЭтотОбъект);
	РаботаСФайламиСлужебныйКлиент.ОсвободитьФайлСОповещением(
		Обработчик,
		ФайлСсылка,
		ДанныеФайла.ХранитьВерсии,
		ДанныеФайла.РедактируетТекущийПользователь,
		ДанныеФайла.Редактирует);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайла(Команда)
	
	ФайлСсылка = Элементы.Список.ТекущаяСтрока;
	Если Не ФайловыеКомандыДоступны(ФайлСсылка) Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
		ФайлСсылка,
		Неопределено,
		УникальныйИдентификатор,
		Неопределено,
		ПредыдущийАдресФайла);
	
	РаботаСФайламиКлиент.ОткрытьКаталогФайла(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	ФайлСсылка = Элементы.Список.ТекущаяСтрока;
	Если Не ФайловыеКомандыДоступны(ФайлСсылка) Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
		ФайлСсылка,
		Неопределено,
		УникальныйИдентификатор,
		Неопределено,
		ПредыдущийАдресФайла);
	
	РаботаСФайламиКлиент.Открыть(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	ФайлСсылка = Элементы.Список.ТекущаяСтрока;
	Если Не ФайловыеКомандыДоступны(ФайлСсылка) Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("РедактироватьЗавершение", ЭтотОбъект);
	РаботаСФайламиСлужебныйКлиент.РедактироватьСОповещением(Обработчик, ФайлСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	ФайлСсылка = Элементы.Список.ТекущаяСтрока;
	Если Не ФайловыеКомандыДоступны(ФайлСсылка) Тогда 
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиСлужебныйКлиент.ОпубликоватьФайлСОповещением(
		Неопределено,
		ФайлСсылка,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	ФайлСсылка = Элементы.Список.ТекущаяСтрока;
	Если Не ФайловыеКомандыДоступны(ФайлСсылка) Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляСохранения(
		ФайлСсылка,
		Неопределено,
		УникальныйИдентификатор);
	
	РаботаСФайламиСлужебныйКлиент.СохранитьКак(Неопределено, ДанныеФайла, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмпортФайлов(Команда)
	#Если ВебКлиент Тогда
		ТекстПредупреждения =  НСтр("ru = 'В Веб-клиенте импорт файлов не поддерживается.
		                                  |Используйте команду ""Создать"" в списке файлов.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	#КонецЕсли
	
	МассивИменФайлов = ФайловыеФункцииСлужебныйКлиент.ПолучитьСписокИмпортируемыхФайлов();
	
	Если МассивИменФайлов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЗначениеПараметраКД = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Владелец"));
	Если ЗначениеПараметраКД = Неопределено Тогда
		ВладелецФайла = Неопределено;
	Иначе
		ВладелецФайла = ЗначениеПараметраКД.Значение;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПапкаДляДобавления", ВладелецФайла);
	ПараметрыФормы.Вставить("МассивИменФайлов",   МассивИменФайлов);
	
	ОткрытьФорму("Справочник.Файлы.Форма.ФормаИмпортаФайлов", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура Подписать(Команда)
	
	ФайлСсылка = Элементы.Список.ТекущаяСтрока;
	Если Не ФайловыеКомандыДоступны(ФайлСсылка) Тогда 
		Возврат;
	КонецЕсли;
	
	Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
		ФайловыеФункцииСлужебныйКлиент.ПоказатьПредупреждениеОНеобходимостиРасширенияРаботыСКриптографией(
			Неопределено,
			Команды.Найти("Подписать").Заголовок);
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаИРабочийКаталог(ФайлСсылка);
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ДанныеФайла", ДанныеФайла);
	
	Обработчик = Новый ОписаниеОповещения("ПодписатьЗавершение", ЭтотОбъект, ПараметрыОбработчика);
	
	РаботаСФайламиСлужебныйКлиент.СформироватьПодписьФайла(Обработчик, ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Зашифровать(Команда)
	
	ФайлСсылка = Элементы.Список.ТекущаяСтрока;
	Если Не ФайловыеКомандыДоступны(ФайлСсылка) Тогда 
		Возврат;
	КонецЕсли;
	
	Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
		ФайловыеФункцииСлужебныйКлиент.ПоказатьПредупреждениеОНеобходимостиРасширенияРаботыСКриптографией(
			Неопределено,
			Команды.Найти("Зашифровать").Заголовок);
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаИКоличествоВерсий(ФайлСсылка);
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ФайлСсылка", ФайлСсылка);
	ПараметрыОбработчика.Вставить("ДанныеФайла", ДанныеФайла);
	Обработчик = Новый ОписаниеОповещения("ЗашифроватьЗавершение", ЭтотОбъект, ПараметрыОбработчика);
	
	РаботаСФайламиСлужебныйКлиент.Зашифровать(Обработчик, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Расшифровать(Команда)
	
	ФайлСсылка = Элементы.Список.ТекущаяСтрока;
	Если Не ФайловыеКомандыДоступны(ФайлСсылка) Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаИКоличествоВерсий(ФайлСсылка);
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ФайлСсылка", ФайлСсылка);
	ПараметрыОбработчика.Вставить("ДанныеФайла", ДанныеФайла);
	Обработчик = Новый ОписаниеОповещения("РасшифроватьЗавершение", ЭтотОбъект, ПараметрыОбработчика);
	
	РаботаСФайламиСлужебныйКлиент.Расшифровать(
		Обработчик,
		ДанныеФайла.Ссылка,
		УникальныйИдентификатор,
		ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПодписьИзФайла(Команда)
	
	ФайлСсылка = Элементы.Список.ТекущаяСтрока;
	Если Не ФайловыеКомандыДоступны(ФайлСсылка) Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаИРабочийКаталог(ФайлСсылка);
	
	Обработчик = Новый ОписаниеОповещения("ДобавитьПодписьИзФайлаЗавершение", ЭтотОбъект);
	
	РаботаСФайламиСлужебныйКлиент.ДобавитьПодписьИзФайла(Обработчик, ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВместеСПодписью(Команда)
	
	ФайлСсылка = Элементы.Список.ТекущаяСтрока;
	Если Не ФайловыеКомандыДоступны(ФайлСсылка) Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляСохранения(ФайлСсылка);
	
	Обработчик = Новый ОписаниеОповещения("СохранитьВместеСПодписьюЗавершение", ЭтотОбъект);
	
	РаботаСФайламиСлужебныйКлиент.СохранитьСПодписью(Обработчик, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьФайлВыполнить()
	
	ЗначениеПараметраКД = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Владелец"));
	Если ЗначениеПараметраКД = Неопределено Тогда
		ВладелецФайла = Неопределено;
	Иначе
		ВладелецФайла = ЗначениеПараметраКД.Значение;
	КонецЕсли;
	
	ПараметрыДобавления = Новый Структура;
	ПараметрыДобавления.Вставить("ОбработчикРезультата", Неопределено);
	ПараметрыДобавления.Вставить("ВладелецФайла", ВладелецФайла);
	ПараметрыДобавления.Вставить("ФормаВладелец", ЭтотОбъект);
	ПараметрыДобавления.Вставить("НеОткрыватьКарточкуПослеСозданияИзФайла", Неопределено);
	Если ПодключитьРасширениеРаботыСФайлами() Тогда
		РаботаСФайламиСлужебныйКлиент.ДобавитьИзФайловойСистемыСРасширением(ПараметрыДобавления);
	Иначе
		РаботаСФайламиСлужебныйКлиент.ДобавитьИзФайловойСистемыБезРасширения(ПараметрыДобавления);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьФайлИзШаблона(Команда)
	
	ЗначениеПараметраКД = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Владелец"));
	Если ЗначениеПараметраКД = Неопределено Тогда
		ВладелецФайла = Неопределено;
	Иначе
		ВладелецФайла = ЗначениеПараметраКД.Значение;
	КонецЕсли;
	
	ПараметрыДобавления = Новый Структура;
	ПараметрыДобавления.Вставить("ОбработчикРезультата", Неопределено);
	ПараметрыДобавления.Вставить("ВладелецФайла", ВладелецФайла);
	ПараметрыДобавления.Вставить("ФормаВладелец", ЭтотОбъект);
	ПараметрыДобавления.Вставить("НеОткрыватьКарточкуПослеСозданияИзФайла", Неопределено);
	РаботаСФайламиСлужебныйКлиент.ДобавитьНаОсновеШаблона(ПараметрыДобавления);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьФайлСоСканера(Команда)
	
	ЗначениеПараметраКД = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Владелец"));
	Если ЗначениеПараметраКД = Неопределено Тогда
		ВладелецФайла = Неопределено;
	Иначе
		ВладелецФайла = ЗначениеПараметраКД.Значение;
	КонецЕсли;
	
	ПараметрыДобавления = Новый Структура;
	ПараметрыДобавления.Вставить("ОбработчикРезультата", Неопределено);
	ПараметрыДобавления.Вставить("ВладелецФайла", ВладелецФайла);
	ПараметрыДобавления.Вставить("ФормаВладелец", ЭтотОбъект);
	ПараметрыДобавления.Вставить("НеОткрыватьКарточкуПослеСозданияИзФайла", Неопределено);
	РаботаСФайламиСлужебныйКлиент.ДобавитьСоСканера(ПараметрыДобавления);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СписокВыборПослеВыбораРежимаОткрытия(Результат, ПараметрыВыполнения) Экспорт
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.КакОткрывать = 1 Тогда
		// Для редактирования.
		Обработчик = Новый ОписаниеОповещения("СписокВыборПослеРедактирования", ЭтотОбъект, ПараметрыВыполнения);
		РаботаСФайламиСлужебныйКлиент.РедактироватьФайл(Обработчик, ПараметрыВыполнения.ДанныеФайла, УникальныйИдентификатор);
		Возврат;
	КонецЕсли;
	
	// Для просмотра.
	РаботаСФайламиСлужебныйКлиент.ОткрытьФайлСОповещением(Неопределено, ПараметрыВыполнения.ДанныеФайла, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборПослеРедактирования(Результат, ПараметрыВыполнения) Экспорт
	ОповеститьОбИзменении(ПараметрыВыполнения.ДанныеФайла.Ссылка);
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

&НаКлиенте
Процедура ЗанятьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

&НаКлиенте
Процедура ОсвободитьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	Если Результат.Успех = Истина Тогда
		РаботаСФайламиСлужебныйВызовСервера.ЗанестиИнформациюОднойПодписи(Результат.ДанныеПодписи);
		ОповещениеПараметр = Новый Структура("Событие", "ПрисоединенныйФайлПодписан");
		Оповестить("Запись_Файл", ОповещениеПараметр, ПараметрыВыполнения.ДанныеФайла.Владелец);
		ОповеститьОбИзменении(ПараметрыВыполнения.ДанныеФайла.Ссылка);
	КонецЕсли;
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

&НаКлиенте
Процедура ЗашифроватьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	Если Результат.Успех <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРабочегоКаталога = ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя();
	
	МассивФайловВРабочемКаталогеДляУдаления = Новый Массив;
	
	РаботаСФайламиСлужебныйВызовСервера.ЗанестиИнформациюОШифровании(
		ПараметрыВыполнения.ФайлСсылка,
		Истина, // Зашифровать
		Результат.МассивДанныхДляЗанесенияВБазу,
		Неопределено, // УникальныйИдентификатор
		ИмяРабочегоКаталога,
		МассивФайловВРабочемКаталогеДляУдаления,
		Результат.МассивОтпечатков);
	
	РаботаСФайламиСлужебныйКлиент.ИнформироватьОШифровании(
		МассивФайловВРабочемКаталогеДляУдаления, 
		ПараметрыВыполнения.ДанныеФайла.Владелец,
		ПараметрыВыполнения.ФайлСсылка);
	
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

&НаКлиенте
Процедура РасшифроватьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	Если Результат.Успех <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРабочегоКаталога = ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя();
	
	РаботаСФайламиСлужебныйВызовСервера.ЗанестиИнформациюОШифровании(
		ПараметрыВыполнения.ФайлСсылка,
		Ложь,          // Зашифровать
		Результат.МассивДанныхДляЗанесенияВБазу,
		Неопределено,  // УникальныйИдентификатор
		ИмяРабочегоКаталога,
		Новый Массив,  // МассивФайловВРабочемКаталогеДляУдаления
		Новый Массив); // МассивОтпечатков
		
	РаботаСФайламиСлужебныйКлиент.ИнформироватьОРасшифровке(
		ПараметрыВыполнения.ДанныеФайла.Владелец,
		ПараметрыВыполнения.ФайлСсылка);
	
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПодписьИзФайлаЗавершение(Результат, ПараметрыВыполнения) Экспорт
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВместеСПодписьюЗавершение(Результат, ПараметрыВыполнения) Экспорт
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактированиеЗавершение(Результат, ПараметрыВыполнения) Экспорт
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьФайловыхКоманд()
	
	ФайлСсылка = Элементы.Список.ТекущаяСтрока;
	Если Не ФайловыеКомандыДоступны(ФайлСсылка) Тогда 
		Возврат;
	КонецЕсли;
	ДанныеФайла = Элементы.Список.ТекущиеДанные;
	
	УстановитьДоступностьКоманд(
		ДанныеФайла.РедактируетТекущийПользователь,
		ДанныеФайла.Редактирует,
		ДанныеФайла.ПодписанЭП,
		ДанныеФайла.Зашифрован);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд(РедактируетТекущийПользователь, Редактирует, ПодписанЭП, Зашифрован)
	
	Элементы.ФормаЗакончитьРедактирование.Доступность = РедактируетТекущийПользователь;
	Элементы.СписокКонтекстноеМенюЗакончитьРедактирование.Доступность = РедактируетТекущийПользователь;
	
	Элементы.ФормаСохранитьИзменения.Доступность = РедактируетТекущийПользователь;
	Элементы.СписокКонтекстноеМенюСохранитьИзменения.Доступность = РедактируетТекущийПользователь;
	
	Элементы.ФормаОсвободить.Доступность = Не Редактирует.Пустая();
	Элементы.СписокКонтекстноеМенюОсвободить.Доступность = Не Редактирует.Пустая();
	
	Элементы.ФормаЗанять.Доступность = Редактирует.Пустая() И НЕ (ПодписанЭП ИЛИ Зашифрован);
	Элементы.СписокКонтекстноеМенюЗанять.Доступность = Редактирует.Пустая() И НЕ (ПодписанЭП ИЛИ Зашифрован);
	
	Элементы.ФормаРедактировать.Доступность = НЕ (ПодписанЭП ИЛИ Зашифрован);
	Элементы.СписокКонтекстноеМенюРедактировать.Доступность = НЕ (ПодписанЭП ИЛИ Зашифрован);
	
	Элементы.ФормаПодписать.Доступность = Редактирует.Пустая();
	Элементы.СписокКонтекстноеМенюПодписать.Доступность = Редактирует.Пустая();
	
	Элементы.ФормаСохранитьВместеСПодписью.Доступность = ПодписанЭП;
	Элементы.СписокКонтекстноеМенюСохранитьВместеСПодписью.Доступность = ПодписанЭП;
	
	Элементы.ФормаЗашифровать.Доступность = Редактирует.Пустая() И НЕ Зашифрован;
	Элементы.СписокКонтекстноеМенюЗашифровать.Доступность = Редактирует.Пустая() И НЕ Зашифрован;
	
	Элементы.ФормаРасшифровать.Доступность = Зашифрован;
	Элементы.СписокКонтекстноеМенюРасшифровать.Доступность = Зашифрован;
	
КонецПроцедуры

&НаКлиенте
Функция ФайловыеКомандыДоступны(ФайлСсылка)
	// Доступны файловые команды - есть хотя бы одна строка в списке и выделена не группировка
	
	Если ФайлСсылка = Неопределено Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(ФайлСсылка) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаПеретаскиванияВЛинейныйСписок(ПараметрыПеретаскивания, ВладелецФайлаСписка)
	// Обработчик события Перетаскивание в формах объектов - владельцев Файл (кроме формы Файлы)
	//
	// Параметры
	//  ПараметрыПеретаскивания - Параметры перетаскивания
	//  ВладелецФайлаСписка     - ЛюбаяСсылка - владелец файла
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл") И ПараметрыПеретаскивания.Значение.ЭтоФайл() = Истина Тогда
		
		ПараметрыДобавления = Новый Структура;
		ПараметрыДобавления.Вставить("ОбработчикРезультата", Неопределено);
		ПараметрыДобавления.Вставить("ПолноеИмяФайла", ПараметрыПеретаскивания.Значение.ПолноеИмя);
		ПараметрыДобавления.Вставить("ВладелецФайла", ВладелецФайлаСписка);
		ПараметрыДобавления.Вставить("ФормаВладелец", ЭтотОбъект);
		ПараметрыДобавления.Вставить("ИмяСоздаваемогоФайла", Неопределено);
		ПараметрыДобавления.Вставить("НеОткрыватьКарточкуПослеСозданияИзФайла", Неопределено);
		РаботаСФайламиСлужебныйКлиент.ДобавитьИзФайловойСистемыСРасширением(ПараметрыДобавления);
		
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл") И ПараметрыПеретаскивания.Значение.ЭтоФайл() = Ложь Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите только файлы без каталогов.'"));
		Возврат;
		
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("СправочникСсылка.Файлы") Тогда
		
		РаботаСФайламиСлужебныйКлиент.ПеренестиФайлВПриложенныеФайлы(
			ПараметрыПеретаскивания.Значение,
			ВладелецФайлаСписка);
		
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		Если ПараметрыПеретаскивания.Значение.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		ТипПеретаскиваемого = ТипЗнч(ПараметрыПеретаскивания.Значение[0]);
		Если ТипПеретаскиваемого = Тип("СправочникСсылка.Файлы") Тогда
			РаботаСФайламиСлужебныйКлиент.ПеренестиФайлыВПриложенныеФайлы(
				ПараметрыПеретаскивания.Значение,
				ВладелецФайлаСписка);
			Возврат;
		КонецЕсли;
		
		Если ТипПеретаскиваемого <> Тип("Файл") Тогда
			ПоказатьПредупреждение(, Нстр("ru = 'Выберите файлы.'"));
			Возврат;
		КонецЕсли;
		
		Для Каждого ФайлПринятый Из ПараметрыПеретаскивания.Значение Цикл
			Если Не ФайлПринятый.ЭтоФайл() Тогда // только файлы, но не каталоги
				ПоказатьПредупреждение(, Нстр("ru = 'Выберите только файлы без каталогов.'"));
				Возврат;
			КонецЕсли;
		КонецЦикла;
		
		ПараметрыДобавления = Новый Структура;
		ПараметрыДобавления.Вставить("ОбработчикРезультата", Неопределено);
		ПараметрыДобавления.Вставить("ПолноеИмяФайла", Неопределено);
		ПараметрыДобавления.Вставить("ВладелецФайла", ВладелецФайлаСписка);
		ПараметрыДобавления.Вставить("ФормаВладелец", ЭтотОбъект);
		ПараметрыДобавления.Вставить("ИмяСоздаваемогоФайла", Неопределено);
		ПараметрыДобавления.Вставить("НеОткрыватьКарточкуПослеСозданияИзФайла", Истина);
		
		ТекстыОшибок = Новый Массив;
		
		Для Каждого ФайлПринятый Из ПараметрыПеретаскивания.Значение Цикл
			ПараметрыДобавления.ПолноеИмяФайла = ФайлПринятый.ПолноеИмя;
			Результат = РаботаСФайламиСлужебныйКлиент.ДобавитьИзФайловойСистемыСРасширениемСинхронно(ПараметрыДобавления);
			Если Не Результат.ФайлДобавлен И ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
				ТекстыОшибок.Добавить(Результат.ТекстОшибки);
			КонецЕсли;
		КонецЦикла;
		
		// Вывод ошибок.
		КоличествоОшибок = ТекстыОшибок.Количество();
		Если КоличествоОшибок > 0 Тогда
			Результат = СтандартныеПодсистемыКлиентСервер.НовыйРезультатВыполнения();
			Результат.ВыводПредупреждения.Использование = Истина;
			Если КоличествоОшибок = 1 Тогда
				Результат.ВыводПредупреждения.Текст = ТекстыОшибок[0];
			Иначе
				КраткийТекстВсехОшибок = СтрЗаменить(НСтр("ru = 'При выполнении возникли ошибки (%1).'"), "%1", Строка(КоличествоОшибок));
				ПолныйТекстВсехОшибок = "";
				Для Каждого ТекстОшибки Из ТекстыОшибок Цикл
					Если ПолныйТекстВсехОшибок <> "" Тогда
						ПолныйТекстВсехОшибок = ПолныйТекстВсехОшибок + Символы.ПС + Символы.ПС + "---" + Символы.ПС + Символы.ПС;
					КонецЕсли;
					ПолныйТекстВсехОшибок = ПолныйТекстВсехОшибок + ТекстОшибки;
				КонецЦикла;
				Результат.ВыводПредупреждения.Текст = КраткийТекстВсехОшибок;
				Результат.ВыводПредупреждения.ТекстОшибок = ПолныйТекстВсехОшибок;
			КонецЕсли;
			СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(ЭтотОбъект, Результат);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
