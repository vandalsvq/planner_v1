﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.ВладелецФайла = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Список присоединенных файлов можно посмотреть
		                             |только в форме объекта-владельца.'");
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		КлючНазначенияИспользования = "ВыборПодбор";
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
		Заголовок = НСтр("ru = 'Выбор присоединенного файла'");
		
		// Отбор не помеченных на удаление.
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ПометкаУдаления", Ложь, , , Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
	Иначе
		Элементы.Список.РежимВыбора = Ложь;
	КонецЕсли;
	
	ИмяСправочникаХранилищаФайлов = Неопределено;
	НастроитьДинамическийСписок(ИмяСправочникаХранилищаФайлов);
	
	ТипСправочникаСФайлами = Тип("СправочникСсылка." + ИмяСправочникаХранилищаФайлов);
	
	МетаданныеСправочникаСФайлами = Метаданные.НайтиПоТипу(ТипСправочникаСФайлами);
	
	Если НЕ ПравоДоступа("ИнтерактивноеДобавление", МетаданныеСправочникаСФайлами) Тогда
		СкрытьКнопкиДобавления();
	КонецЕсли;
	
	Если НЕ ПравоДоступа("Редактирование", МетаданныеСправочникаСФайлами)
	 ИЛИ НЕ ПравоДоступа("Редактирование", Параметры.ВладелецФайла.Метаданные())
	 ИЛИ Параметры.ТолькоПросмотр = Истина Тогда
		
		СкрытьКнопкиИзменения();
	КонецЕсли;
	
	ИменаВсехКомандФормы = ПолучитьИменаКомандФормы();
	ИменаЭлементов = Новый Массив;
	
	Для Каждого ЭлементФормы ИЗ Элементы Цикл
		
		Если ТипЗнч(ЭлементФормы) <> Тип("КнопкаФормы") Тогда
			Продолжить;
		КонецЕсли;
		
		Если ИменаВсехКомандФормы.Найти(ЭлементФормы.ИмяКоманды) <> Неопределено Тогда
			ИменаЭлементов.Добавить(ЭлементФормы.Имя);
		КонецЕсли;
	КонецЦикла;
	
	ИменаЭлементовКнопокФормы = Новый ФиксированныйМассив(ИменаЭлементов);
	
	УстановитьПривилегированныйРежим(Истина);
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись")
	 Или Константы["ИспользоватьЭлектронныеПодписи"].Получить() <> Истина Тогда
		
		Элементы.СписокНомерКартинкиПодписанЗашифрован.Видимость = Ложь;
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		Элементы.ФормаИзменить.Видимость = Ложь;
		Элементы.ФормаИзменить82.Видимость = Истина;
		Элементы.ФормаСкопировать.ТолькоВоВсехДействиях = Ложь;
		Элементы.ФормаУстановитьПометкуУдаления.ТолькоВоВсехДействиях = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступностьКнопок();
	
	// ТекущаяДата получена не для сохранения в базе данных, а используется
	// только расчета в динамическом списке местного времени от
	// универсального времени сохраненного в базе данных,
	// поэтому приведение к ТекущаяДатаСеанса не требуется.
	ТекущаяДатаКлиента = ТекущаяДата();
	
	Список.Параметры.УстановитьЗначениеПараметра(
		"СекундДоМестногоВремени",
		ТекущаяДатаКлиента - УниверсальноеВремя(ТекущаяДатаКлиента));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_ПрисоединенныйФайл" Тогда
		Возврат;
	КонецЕсли;
		
	СсылкаНаФайл = ?(ТипЗнч(Источник) = Тип("Массив"), Источник[0], Источник);
	
	Если Параметр.Свойство("ЭтоНовый") И Параметр.ЭтоНовый Тогда
		
		Элементы.Список.ТекущаяСтрока = СсылкаНаФайл;
		УстановитьДоступностьКнопок();
	Иначе
		Если НЕ ПроверитьДействиеРазрешено() Тогда
			Возврат;
		КонецЕсли;
		
		Если СсылкаНаФайл = Элементы.Список.ТекущиеДанные.Ссылка Тогда
			УстановитьДоступностьКнопок();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.Список.РежимВыбора Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФайл();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьКнопок();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	Если Копирование Тогда
		
		Если НЕ ПроверитьДействиеРазрешено() Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура("ЗначениеКопирования", Элемент.ТекущиеДанные.Ссылка);
		
		ОткрытьФорму("ОбщаяФорма.ПрисоединенныйФайл", ПараметрыФормы);
		
	Иначе
		ПрисоединенныеФайлыКлиент.ДобавитьФайлы(Параметры.ВладелецФайла, УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	Если НЕ ПроверитьДействиеРазрешено() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ",           ТекущиеДанные.Ссылка);
	ПараметрыФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр);
	
	ОткрытьФорму("ОбщаяФорма.ПрисоединенныйФайл", ПараметрыФормы, , Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	МассивИменФайлов = Новый Массив;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл")
	   И ПараметрыПеретаскивания.Значение.ЭтоФайл() = Истина Тогда
		
		МассивИменФайлов.Добавить(ПараметрыПеретаскивания.Значение.ПолноеИмя);
		
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		
		Если ПараметрыПеретаскивания.Значение.Количество() >= 1
		   И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("Файл") Тогда
			
			Для каждого Значение Из ПараметрыПеретаскивания.Значение Цикл
				
				Если ТипЗнч(Значение) = Тип("Файл") И Значение.ЭтоФайл() Тогда
					МассивИменФайлов.Добавить(Значение.ПолноеИмя);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
			
	КонецЕсли;
	
	Если МассивИменФайлов.Количество() > 0 Тогда
		
		ПрисоединенныеФайлыСлужебныйКлиент.ДобавитьФайлыПеретаскиванием(
			Параметры.ВладелецФайла, УникальныйИдентификатор, МассивИменФайлов);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

///////////////////////////////////////////////////////////////////////////////////
// Обработчики команд файлов

&НаКлиенте
Процедура Создать(Команда)
	
	Элементы.Список.ДобавитьСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайлДляПросмотра(Команда)
	
	ОткрытьФайл();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайла(Команда)
	
	Если НЕ ПроверитьДействиеРазрешено() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные.Зашифрован Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = ПолучитьДанныеФайла(ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	
	Если ТекущиеДанные.Зашифрован Тогда
		// Файл может быть изменен в другом сеансе.
		ОповеститьОбИзменении(ТекущиеДанные.Ссылка);
		Возврат;
	КонецЕсли;
	
	ПрисоединенныеФайлыСлужебныйКлиент.ОткрытьКаталогСФайлом(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)
	
	Если НЕ ПроверитьДействиеРазрешено() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные.Зашифрован Или ТекущиеДанные.ПодписанЭП Или ТекущиеДанные.ФайлРедактируется Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = ПолучитьДанныеФайла(ТекущиеДанные.Ссылка, , Ложь);
	Если ДанныеФайла.Зашифрован Или ДанныеФайла.ПодписанЭП Или ДанныеФайла.ФайлРедактируется Тогда
		// Файл может быть изменен в другом сеансе.
		ОповеститьОбИзменении(ТекущиеДанные.Ссылка);
		Возврат;
	КонецЕсли;
	
	ПрисоединенныеФайлыСлужебныйКлиент.ОбновитьПрисоединенныйФайл(ТекущиеДанные.Ссылка, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	Если НЕ ПроверитьДействиеРазрешено() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные.Зашифрован
	 ИЛИ (ТекущиеДанные.ФайлРедактируется И ТекущиеДанные.ФайлРедактируетТекущийПользователь) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = ПолучитьДанныеФайла(ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	
	Если ДанныеФайла.Зашифрован
	 ИЛИ (ДанныеФайла.ФайлРедактируется И ДанныеФайла.ФайлРедактируетТекущийПользователь) Тогда
		// Файл может быть изменен в другом сеансе.
		ОповеститьОбИзменении(ТекущиеДанные.Ссылка);
		Возврат;
	КонецЕсли;
	
	ПрисоединенныеФайлыКлиент.СохранитьФайлКак(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Скопировать(Команда)
	
	Элементы.Список.СкопироватьСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСвойстваФайла(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПрисоединенныйФайл", Элементы.Список.ТекущиеДанные.Ссылка);
	
	ОткрытьФорму("ОбщаяФорма.ПрисоединенныйФайл", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкуУдаления(Команда)
	
	Если НЕ ПроверитьДействиеРазрешено("ПометкаУдаления") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные.ПометкаУдаления Тогда
		ТекстВопроса = НСтр("ru = 'Снять пометку на удаление с файла
		                          |""%1""?'");
	Иначе
		ТекстВопроса = НСтр("ru = 'Пометить на удаление файл
		                          |""%1""?'");
	КонецЕсли;
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, ТекущиеДанные.Ссылка);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьПометкуУдаленияОтветПолучен", ЭтотОбъект, ТекущиеДанные);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкуУдаленияОтветПолучен(РезультатВопроса, ТекущиеДанные) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		УстановитьЗначениеПометкиУдаления(ТекущиеДанные.Ссылка, НЕ ТекущиеДанные.ПометкаУдаления);
		Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////
// Обработчики команд для поддержки ЭП и шифрования

&НаКлиенте
Процедура ЭППодписать(Команда)
	
	Если НЕ ПроверитьДействиеРазрешено() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные.ФайлРедактируется
	 ИЛИ ТекущиеДанные.Зашифрован Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = ПолучитьДанныеФайла(ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	
	Если ДанныеФайла.ФайлРедактируется
	 ИЛИ ДанныеФайла.Зашифрован Тогда
		// Файл может быть изменен в другом сеансе.
		ОповеститьОбИзменении(ТекущиеДанные.Ссылка);
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПрисоединенныйФайл", ТекущиеДанные.Ссылка);
	ДополнительныеПараметры.Вставить("ДанныеФайла", ДанныеФайла);
	ДополнительныеПараметры.Вставить("ОповещениеПользователя");
	ДополнительныеПараметры.Вставить("ОбработчикРезультата",
		Новый ОписаниеОповещения("ЭППодписатьПодписьСформирована", ЭтотОбъект));
	
	ПрисоединенныеФайлыСлужебныйКлиент.СформироватьПодписьФайла(ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭППодписатьПодписьСформирована(Результат, Неопределен) Экспорт
	
	Если Результат.ПодписьСформирована Тогда
		УстановитьДоступностьКнопок();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВместеСЭП(Команда)
	
	Если НЕ ПроверитьДействиеРазрешено() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные.Зашифрован Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = ПолучитьДанныеФайла(ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	
	Если ДанныеФайла.Зашифрован Тогда
		// Файл может быть изменен в другом сеансе.
		ОповеститьОбИзменении(ТекущиеДанные.Ссылка);
		Возврат;
	КонецЕсли;
	
	ПрисоединенныеФайлыКлиент.СохранитьВместеСЭП(ТекущиеДанные.Ссылка, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЭПИзФайла(Команда)
	
	Если НЕ ПроверитьДействиеРазрешено() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные.ФайлРедактируется
	 ИЛИ ТекущиеДанные.Зашифрован Тогда
		Возврат;
	КонецЕсли;
	
	ПрисоединенныеФайлыСлужебныйКлиент.ДобавитьЭПИзФайла(
		ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Зашифровать(Команда)
	
	Если НЕ ПроверитьДействиеРазрешено() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные.ФайлРедактируется
	 ИЛИ ТекущиеДанные.Зашифрован Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = ПолучитьДанныеФайла(ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	
	Если ДанныеФайла.ФайлРедактируется
	 ИЛИ ДанныеФайла.Зашифрован Тогда
		// Файл может быть изменен в другом сеансе.
		ОповеститьОбИзменении(ТекущиеДанные.Ссылка);
		Возврат;
	КонецЕсли;
	
	ПрисоединенныеФайлыСлужебныйКлиент.Зашифровать(
		ТекущиеДанные.Ссылка, ДанныеФайла, УникальныйИдентификатор);
	
	УстановитьДоступностьКнопок();
	
КонецПроцедуры

&НаКлиенте
Процедура Расшифровать(Команда)
	
	Если НЕ ПроверитьДействиеРазрешено() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные.Зашифрован Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = ПолучитьДанныеФайла(ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	
	Если НЕ ДанныеФайла.Зашифрован Тогда
		// Файл может быть изменен в другом сеансе.
		ОповеститьОбИзменении(ТекущиеДанные.Ссылка);
		Возврат;
	КонецЕсли;
	
	ПрисоединенныеФайлыСлужебныйКлиент.Расшифровать(
		ТекущиеДанные.Ссылка, ДанныеФайла, УникальныйИдентификатор);
	
	УстановитьДоступностьКнопок();
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////
// Обработчики команд для поддержки совместной работы с файлами

&НаКлиенте
Процедура Редактировать(Команда)
	
	Если НЕ ПроверитьДействиеРазрешено() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если (ТекущиеДанные.ФайлРедактируется И НЕ ТекущиеДанные.ФайлРедактируетТекущийПользователь)
	 ИЛИ ТекущиеДанные.Зашифрован
	 ИЛИ ТекущиеДанные.ПодписанЭП Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = ПолучитьДанныеФайла(ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	
	Если (  ДанныеФайла.ФайлРедактируется
	      И НЕ ДанныеФайла.ФайлРедактируетТекущийПользователь)
	 ИЛИ ДанныеФайла.Зашифрован
	 ИЛИ ДанныеФайла.ПодписанЭП Тогда
		// Файл может быть изменен в другом сеансе.
		ОповеститьОбИзменении(ТекущиеДанные.Ссылка);
		Возврат;
	КонецЕсли;
	
	ПрисоединенныеФайлыКлиент.ОткрытьФайл(ДанныеФайла, Истина);
	
	Если НЕ ТекущиеДанные.ФайлРедактируется Тогда
		
		ЗанятьФайлДляРедактированияСервер(ТекущиеДанные.Ссылка);
		
		ОповеститьОбИзменении(ТекущиеДанные.Ссылка);
		УстановитьДоступностьКнопок();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Если НЕ ПроверитьДействиеРазрешено() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные.ФайлРедактируется
	 ИЛИ НЕ ТекущиеДанные.ФайлРедактируетТекущийПользователь Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = ПолучитьДанныеФайла(ТекущиеДанные.Ссылка, , Ложь);
	
	Если НЕ ДанныеФайла.ФайлРедактируется
	 ИЛИ НЕ ДанныеФайла.ФайлРедактируетТекущийПользователь Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗакончитьРедактированиеВыполненоПомещение", ЭтотОбъект, ТекущиеДанные);
	ПрисоединенныеФайлыСлужебныйКлиент.ПоместитьРедактируемыйФайлНаДискеВХранилище(ОписаниеОповещения, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактированиеВыполненоПомещение(ИнформацияОФайле, ТекущиеДанные) Экспорт
	
	Если ИнформацияОФайле <> Неопределено Тогда
		ПоместитьФайлВХранилищеИОсвободить(ТекущиеДанные.Ссылка, ИнформацияОФайле);
		ОповеститьОбИзменении(ТекущиеДанные.Ссылка);
		УстановитьДоступностьКнопок();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	
	Если НЕ ПроверитьДействиеРазрешено() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные.ФайлРедактируется
	 ИЛИ НЕ ТекущиеДанные.ФайлРедактируетТекущийПользователь Тогда
		Возврат;
	КонецЕсли;
	
	ОсвободитьФайл(ТекущиеДанные.Ссылка);
	ОповеститьОбИзменении(ТекущиеДанные.Ссылка);
	УстановитьДоступностьКнопок();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Оформление файла, занятого для редактирования другим пользователем.
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ФайлРедактируетДругойПользователь");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ФайлЗанятыйДругимПользователем);
	
	// Оформление файла, занятого для редактирования текущим пользователем.
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ФайлРедактируетТекущийПользователь");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ФайлЗанятыйТекущимПользователем);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл()
	
	Если НЕ ПроверитьДействиеРазрешено() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные.Зашифрован Тогда
		Возврат;
	КонецЕсли;
	
	ФайлРедактируется = ТекущиеДанные.ФайлРедактируется И ТекущиеДанные.ФайлРедактируетТекущийПользователь;
	
	ДанныеФайла = ПолучитьДанныеФайла(ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	
	Если ДанныеФайла.Зашифрован Тогда
		// Файл может быть изменен в другом сеансе.
		ОповеститьОбИзменении(ТекущиеДанные.Ссылка);
		Возврат;
	КонецЕсли;
	
	ПрисоединенныеФайлыКлиент.ОткрытьФайл(ДанныеФайла, ФайлРедактируется);
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьДействиеРазрешено(Знач ТекущееДействие = "")
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущееДействие = "ПометкаУдаления" И ТекущиеДанные.ФайлРедактируется Тогда
		
		Если ТекущиеДанные.ФайлРедактируетТекущийПользователь Тогда
			ТекстПредупреждения = НСтр("ru = 'Действие недоступно, так как файл занят для редактирования.'");
		Иначе
			ТекстПредупреждения = НСтр("ru = 'Действие недоступно, так как файл занят для редактирования
			                                 |другим пользователем.'");
		КонецЕсли;
		
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = ТипСправочникаСФайлами Тогда
		Возврат Истина;
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Действие недоступно для строки группировки списка.'"));
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ Элементы.ФормаСкопировать.Видимость
	 ИЛИ НЕ Элементы.ФормаСкопировать.Доступность Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура СкрытьКнопкиДобавления()
	
	Элементы.ФормаСоздать.Видимость = Ложь;
	Элементы.СписокКонтекстноеМенюСоздать.Видимость = Ложь;
	
	Элементы.ФормаСкопировать.Видимость = Ложь;
	Элементы.СписокКонтекстноеМенюСкопировать.Видимость = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура СкрытьКнопкиИзменения()
	
	ИменаКоманд = ПолучитьИменаКомандИзмененияОбъектов();
	
	Для каждого ЭлементФормы Из Элементы Цикл
		
		Если ТипЗнч(ЭлементФормы) <> Тип("КнопкаФормы") Тогда
			Продолжить;
		КонецЕсли;
		
		Если ИменаКоманд.Найти(ЭлементФормы.ИмяКоманды) <> Неопределено Тогда
			ЭлементФормы.Видимость = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКнопок()
	
#Если ВебКлиент Тогда
	Возврат;
#КонецЕсли
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		ИменаКоманд = Новый Массив;
		ИменаКоманд.Добавить("Создать");
		
	ИначеЕсли ТипЗнч(Элементы.Список.ТекущаяСтрока) <> ТипСправочникаСФайлами Тогда
		ИменаКоманд = Новый Массив;
	Иначе
		ИменаКоманд = ПолучитьДоступныеКоманды(
			ТекущиеДанные.ФайлРедактируется,
			ТекущиеДанные.ФайлРедактируетТекущийПользователь,
			ТекущиеДанные.ПодписанЭП,
			ТекущиеДанные.Зашифрован);
	КонецЕсли;
	
	Для каждого ИмяЭлементаФормы Из ИменаЭлементовКнопокФормы Цикл
		
		ЭлементФормы = Элементы.Найти(ИмяЭлементаФормы);
		
		Если ИменаКоманд.Найти(ЭлементФормы.ИмяКоманды) <> Неопределено Тогда
			Если НЕ ЭлементФормы.Доступность Тогда
				ЭлементФормы.Доступность = Истина;
			КонецЕсли;
			
		ИначеЕсли ЭлементФормы.Доступность Тогда
			ЭлементФормы.Доступность = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеФайла(Знач ПрисоединенныйФайл,
                            Знач ИдентификаторФормы = Неопределено,
                            Знач ПолучатьСсылкуНаДвоичныеДанные = Истина)
	
	Возврат ПрисоединенныеФайлы.ПолучитьДанныеФайла(
		ПрисоединенныйФайл, ИдентификаторФормы, ПолучатьСсылкуНаДвоичныеДанные);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗанятьФайлДляРедактированияСервер(Знач ПрисоединенныйФайл)
	
	ПрисоединенныеФайлыСлужебный.ЗанятьФайлДляРедактированияСервер(ПрисоединенныйФайл);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОсвободитьФайл(Знач ПрисоединенныйФайл)
	
	ПрисоединенныеФайлыСлужебный.ОсвободитьФайл(ПрисоединенныйФайл);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПоместитьФайлВХранилищеИОсвободить(Знач ПрисоединенныйФайл,
                                             Знач ИнформацияОФайле)
	
	ПрисоединенныеФайлыСлужебный.ПоместитьФайлВХранилищеИОсвободить(
		ПрисоединенныйФайл, ИнформацияОФайле);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьЗначениеПометкиУдаления(Знач ПрисоединенныйФайл, Знач ПометкаУдаления)
	
	ПрисоединенныйФайлОбъект = ПрисоединенныйФайл.ПолучитьОбъект();
	ПрисоединенныйФайлОбъект.ПометкаУдаления = ПометкаУдаления;
	ПрисоединенныйФайлОбъект.Записать();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьДинамическийСписок(ИмяСправочникаХранилищаФайлов)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Файлы.Ссылка КАК Ссылка,
	|	Файлы.ПометкаУдаления,
	|	ВЫБОР
	|		КОГДА Файлы.ПометкаУдаления = ИСТИНА
	|			ТОГДА Файлы.ИндексКартинки + 1
	|		ИНАЧЕ Файлы.ИндексКартинки
	|	КОНЕЦ КАК ИндексКартинки,
	|	Файлы.Наименование КАК Наименование,
	|	ВЫРАЗИТЬ(Файлы.Описание КАК СТРОКА(500)) КАК Описание,
	|	Файлы.Автор,
	|	Файлы.ДатаСоздания,
	|	Файлы.Изменил КАК Отредактировал,
	|	ДОБАВИТЬКДАТЕ(Файлы.ДатаМодификацииУниверсальная, СЕКУНДА, &СекундДоМестногоВремени) КАК ДатаИзменения,
	|	ВЫРАЗИТЬ(Файлы.Размер / 1024 КАК ЧИСЛО(10, 0)) КАК Размер,
	|	Файлы.ПодписанЭП,
	|	Файлы.Зашифрован,
	|	ВЫБОР
	|		КОГДА Файлы.ПодписанЭП
	|				И Файлы.Зашифрован
	|			ТОГДА 2
	|		КОГДА Файлы.Зашифрован
	|			ТОГДА 1
	|		КОГДА Файлы.ПодписанЭП
	|			ТОГДА 0
	|		ИНАЧЕ -1
	|	КОНЕЦ КАК НомерКартинкиПодписанЗашифрован,
	|	ВЫБОР
	|		КОГДА НЕ Файлы.Редактирует В (&ПустыеПользователи)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ФайлРедактируется,
	|	ВЫБОР
	|		КОГДА Файлы.Редактирует = &ТекущийПользователь
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ФайлРедактируетТекущийПользователь,
	|	ВЫБОР
	|		КОГДА НЕ Файлы.Редактирует В (&ПустыеПользователи)
	|				И Файлы.Редактирует <> &ТекущийПользователь
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ФайлРедактируетДругойПользователь,
	|	Файлы.Редактирует КАК Редактирует
	|ИЗ
	|	&ИмяСправочника КАК Файлы
	|ГДЕ
	|	Файлы.ВладелецФайла = &ВладелецФайлов";
	
	ЗаголовокОшибки = НСтр("ru = 'Ошибка при настройке динамического списка присоединенных файлов.'");
	ОкончаниеОшибки = НСтр("ru = 'В этом случае настройка динамического списка невозможна.'");
	
	ИмяСправочникаХранилищаФайлов = ПрисоединенныеФайлыСлужебный.ИмяСправочникаХраненияФайлов(
		Параметры.ВладелецФайла, "", ЗаголовокОшибки, Неопределено, ОкончаниеОшибки);
	
	ПолноеИмяСправочника = "Справочник." + ИмяСправочникаХранилищаФайлов;
	Список.ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяСправочника", ПолноеИмяСправочника);
	
	ПустыеПользователи = Новый Массив;
	ПустыеПользователи.Добавить(Неопределено);
	ПустыеПользователи.Добавить(Справочники.Пользователи.ПустаяСсылка());
	ПустыеПользователи.Добавить(Справочники.ВнешниеПользователи.ПустаяСсылка());
	
	Список.Параметры.УстановитьЗначениеПараметра("ВладелецФайлов",      Параметры.ВладелецФайла);
	Список.Параметры.УстановитьЗначениеПараметра("ТекущийПользователь", Пользователи.АвторизованныйПользователь());
	Список.Параметры.УстановитьЗначениеПараметра("ПустыеПользователи",  ПустыеПользователи);
	Список.Параметры.УстановитьЗначениеПараметра("СекундДоМестногоВремени", '00010101'); // Установка на клиенте
	Список.ОсновнаяТаблица = ПолноеИмяСправочника;
	Список.ДинамическоеСчитываниеДанных = Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьИменаКомандФормы()
	
	ИменаКоманд = ПолучитьИменаКомандИзмененияОбъектов();
	Для Каждого ИмяКоманды Из ПолучитьИменаПростыхКомандОбъектов() Цикл
		ИменаКоманд.Добавить(ИмяКоманды);
	КонецЦикла;
	
	Возврат ИменаКоманд;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьИменаКомандИзмененияОбъектов()
	
	ИменаКоманд = Новый Массив;
	
	// Команды зависимые от состояния объектов.
	ИменаКоманд.Добавить("ЗакончитьРедактирование");
	ИменаКоманд.Добавить("Освободить");
	ИменаКоманд.Добавить("Редактировать");
	ИменаКоманд.Добавить("УстановитьПометкуУдаления");
	
	ИменаКоманд.Добавить("ЭППодписать");
	ИменаКоманд.Добавить("ДобавитьЭПИзФайла");
	ИменаКоманд.Добавить("СохранитьВместеСЭП");
	
	ИменаКоманд.Добавить("Зашифровать");
	ИменаКоманд.Добавить("Расшифровать");
	
	ИменаКоманд.Добавить("ОбновитьИзФайлаНаДиске");
	
	// Команды независимые от состояния объектов.
	ИменаКоманд.Добавить("Создать");
	ИменаКоманд.Добавить("ОткрытьСвойстваФайла");
	ИменаКоманд.Добавить("Скопировать");
	
	Возврат ИменаКоманд;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьИменаПростыхКомандОбъектов()
	
	ИменаКоманд = Новый Массив;
	
	// Простые команды доступные любому пользователю, читающему файлы.
	ИменаКоманд.Добавить("ОткрытьКаталогФайла");
	ИменаКоманд.Добавить("ОткрытьФайлДляПросмотра");
	ИменаКоманд.Добавить("СохранитьКак");
	
	Возврат ИменаКоманд;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьДоступныеКоманды(ФайлРедактируется,
                                 ФайлРедактируетТекущийПользователь,
                                 ФайлПодписан,
                                 ФайлЗашифрован)
	
	ИменаКоманд = ПолучитьИменаКомандФормы();
	
	Если ФайлРедактируется Тогда
		Если ФайлРедактируетТекущийПользователь Тогда
			УдалитьКомандуИзМассива(ИменаКоманд, "ОбновитьИзФайлаНаДиске");
		Иначе
			УдалитьКомандуИзМассива(ИменаКоманд, "ЗакончитьРедактирование");
			УдалитьКомандуИзМассива(ИменаКоманд, "Освободить");
			УдалитьКомандуИзМассива(ИменаКоманд, "Редактировать");
		КонецЕсли;
		УдалитьКомандуИзМассива(ИменаКоманд, "УстановитьПометкуУдаления");
		
		УдалитьКомандыЭП(ИменаКоманд);
		
		УдалитьКомандуИзМассива(ИменаКоманд, "ОбновитьИзФайлаНаДиске");
		УдалитьКомандуИзМассива(ИменаКоманд, "СохранитьКак");
		
		УдалитьКомандуИзМассива(ИменаКоманд, "Зашифровать");
		УдалитьКомандуИзМассива(ИменаКоманд, "Расшифровать");
	Иначе
		УдалитьКомандуИзМассива(ИменаКоманд, "ЗакончитьРедактирование");
		УдалитьКомандуИзМассива(ИменаКоманд, "Освободить");
	КонецЕсли;
	
	Если ФайлПодписан Тогда
		УдалитьКомандуИзМассива(ИменаКоманд, "ЗакончитьРедактирование");
		УдалитьКомандуИзМассива(ИменаКоманд, "Освободить");
		УдалитьКомандуИзМассива(ИменаКоманд, "Редактировать");
		УдалитьКомандуИзМассива(ИменаКоманд, "ОбновитьИзФайлаНаДиске");
	КонецЕсли;
	
	Если ФайлЗашифрован Тогда
		УдалитьКомандыЭП(ИменаКоманд);
		УдалитьКомандуИзМассива(ИменаКоманд, "ЗакончитьРедактирование");
		УдалитьКомандуИзМассива(ИменаКоманд, "Освободить");
		УдалитьКомандуИзМассива(ИменаКоманд, "Редактировать");
		
		УдалитьКомандуИзМассива(ИменаКоманд, "ОбновитьИзФайлаНаДиске");
		
		УдалитьКомандуИзМассива(ИменаКоманд, "Зашифровать");
		
		УдалитьКомандуИзМассива(ИменаКоманд, "ОткрытьКаталогФайла");
		УдалитьКомандуИзМассива(ИменаКоманд, "ОткрытьФайлДляПросмотра");
		УдалитьКомандуИзМассива(ИменаКоманд, "СохранитьКак");
	Иначе
		УдалитьКомандуИзМассива(ИменаКоманд, "Расшифровать");
	КонецЕсли;
	
	Возврат ИменаКоманд;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УдалитьКомандыЭП(ИменаКоманд)
	
	УдалитьКомандуИзМассива(ИменаКоманд, "ЭППодписать");
	УдалитьКомандуИзМассива(ИменаКоманд, "ДобавитьЭПИзФайла");
	УдалитьКомандуИзМассива(ИменаКоманд, "СохранитьВместеСЭП");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УдалитьКомандуИзМассива(Массив, ИмяКоманды)
	
	Позиция = Массив.Найти(ИмяКоманды);
	
	Если Позиция = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Массив.Удалить(Позиция);
	
КонецПроцедуры

#КонецОбласти
