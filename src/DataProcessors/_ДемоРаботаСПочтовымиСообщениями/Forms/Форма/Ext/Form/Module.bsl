﻿///////////////////////////////////////////////////////////////////////////////////
// ФОРМА ДЛЯ ДЕМОНСТРАЦИИ ВОЗМОЖНОСТЕЙ ПОДСИСТЕМЫ "РАБОТА С ПОЧТОВЫМИ СООБЩЕНИЯМИ"
//

////////////////////////////////////////////////////////////////////////////////
// СЕКЦИЯ ОБРАБОТЧИКОВ СОБЫТИЙ ФОРМЫ И ЭЛЕМЕНТОВ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СистемнаяУчетнаяЗапись = РаботаСПочтовымиСообщениями.СистемнаяУчетнаяЗапись();
	
	ЗаполнитьСписокУчетныхЗаписей();
	
	Входящие_ЗаполнитьСписокВыбораУчетныхЗаписей();
	
	Результат = ПолучитьНастройкуРедактироватьИнтерактивно();
	
	Если Результат <> Неопределено Тогда
		РедактироватьИнтерактивно = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	СохранитьНастройкуРедактироватьИнтерактивно(РедактироватьИнтерактивно);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНастройкуРедактироватьИнтерактивно()
	
	Значение = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ФормаПодготовкиНовогоПисьма",
		"РедактироватьИнтерактивно");
	
	Возврат Значение;
	
КонецФункции

&НаСервереБезКонтекста
Процедура СохранитьНастройкуРедактироватьИнтерактивно(Знач Значение = Неопределено)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ФормаПодготовкиНовогоПисьма",
		"РедактироватьИнтерактивно",
		Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПисьмоВыполнить()
	
	Если КоличествоВыбранныхУчетныхЗаписей() = 0 Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Не заданы параметры системной учетной записи'"), ,
					"УчетныеЗаписи");
		Возврат;
	КонецЕсли;
	
	ПодготовленныеДанные = ПодготовитьПараметрыПисьма();
	Если ПодготовленныеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтправитьПисьмоВыполнитьПарольПолучен", ЭтотОбъект, ПодготовленныеДанные);
	Если Не РедактироватьИнтерактивно И Не ПарольЗадан(ПодготовленныеДанные.УчетнаяЗапись) Тогда
		ЗапросПароляДоступаКПочтовомуСерверу(ОписаниеОповещения, ПодготовленныеДанные.УчетнаяЗапись);
	Иначе
		ОтправитьПисьмоВыполнитьЗавершение(ПодготовленныеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПисьмоВыполнитьПарольПолучен(Пароль, ПодготовленныеДанные) Экспорт
	
	Если Не ПустаяСтрока(Пароль) Тогда
		ПодготовленныеДанные.ПараметрыПисьма.Вставить("Пароль", Пароль);
	КонецЕсли;
	
	ОтправитьПисьмоВыполнитьЗавершение(ПодготовленныеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПисьмоВыполнитьЗавершение(ПодготовленныеДанные)
	
	Если РедактироватьИнтерактивно Тогда
		ОткрытьФорму("ОбщаяФорма.ОтправкаСообщения", ПодготовленныеДанные);
	Иначе
		ОтправитьПочтовоеСообщение(ПодготовленныеДанные.УчетнаяЗапись, ПодготовленныеДанные.ПараметрыПисьма);
		ПоказатьПредупреждение(, НСтр("ru = 'Сообщение успешно отправлено'"),, НСтр("ru = 'Отправление сообщения'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодготовитьСистемнуюУчетнуюЗаписьВыполнить()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", СистемнаяУчетнаяЗапись);
	
	ОткрытьФорму("Справочник.УчетныеЗаписиЭлектроннойПочты.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКВложениюОчистка(Элемент, СтандартнаяОбработка)
	
	Вложения.Очистить();
	ПутьКВложению = "";
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьПередОтправкойПриИзменении(Элемент)
	
	// для неинтерактивной отправки оставляем в таблице учетных записей
	// только одну помеченную
	Если Не РедактироватьИнтерактивно Тогда
		ЗаписьНайдена = Ложь;
		Для Каждого СтрокаУчетнаяЗапись Из УчетныеЗаписи Цикл
			Если СтрокаУчетнаяЗапись.Пометка Тогда
				Если ЗаписьНайдена Тогда
					СтрокаУчетнаяЗапись.Пометка = Ложь;
				Иначе
					ЗаписьНайдена = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура УчетныеЗаписиПередНачаломИзменения(Элемент, Отказ)
	
	// для неинтерактивной отправки возможна только одна учетная запись
	Если Элемент.ТекущийЭлемент.Имя = "Пометка"
	   И НЕ Элемент.ТекущиеДанные.Пометка
	   И НЕ РедактироватьИнтерактивно Тогда
		Для Каждого СтрокаУчетнаяЗапись Из УчетныеЗаписи Цикл
			Если СтрокаУчетнаяЗапись.Пометка Тогда
				СтрокаУчетнаяЗапись.Пометка = Ложь;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЕКЦИЯ СЕРВИСНЫХ ФУНКЦИЙ
//

&НаСервереБезКонтекста
Функция ОтправитьПочтовоеСообщение(Знач УчетнаяЗапись, Знач ПараметрыПисьма)
	
	Возврат РаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(УчетнаяЗапись, ПараметрыПисьма);
	
КонецФункции

// Подготавливает параметры письма в требуемые
// интерфейсами подсистемы работы с почтовыми сообщениями
//
&НаКлиенте
Функция ПодготовитьПараметрыПисьма()
	
	ПараметрыПисьма = Новый Структура;
	
	Если ЗначениеЗаполнено(ТемаПисьма) Тогда
		ПараметрыПисьма.Вставить("Тема", ТемаПисьма);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТелоПисьма) Тогда
		ПараметрыПисьма.Вставить("Тело", ТелоПисьма);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПочтовыйАдресПолучателя) Тогда
		ПараметрыПисьма.Вставить("Кому", ПочтовыйАдресПолучателя);
	КонецЕсли;
	
	Если РедактироватьИнтерактивно Тогда
		
		Если КоличествоВыбранныхУчетныхЗаписей() = 1 Тогда
			ПараметрыПисьма.Вставить("УчетнаяЗапись", ПолучитьУчетнуюЗаписьИзСписка());
		Иначе
			ПараметрыПисьма.Вставить("УчетнаяЗапись", ПолучитьСписокОтмеченныхУчетныхЗаписей());
		КонецЕсли;
		
		Если Вложения.Количество() >0 Тогда
			ПараметрыПисьма.Вставить("Вложения", Вложения);
		КонецЕсли;
		
		Результат = ПараметрыПисьма;
	Иначе
		Если Вложения.Количество() > 0 Тогда
			ВложенияПараметр = Новый Соответствие;
			ВложенияПараметр.Вставить(Вложения[0].Представление, Вложения[0].Значение);
			ПараметрыПисьма.Вставить("Вложения", ВложенияПараметр);
		КонецЕсли;
		
		Результат = Новый Структура;
		Результат.Вставить("УчетнаяЗапись", ПолучитьУчетнуюЗаписьИзСписка());
		Результат.Вставить("ПараметрыПисьма", ПараметрыПисьма);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Заполняет список учетных записей в списке выбора элемента формы
//
&НаСервере
Процедура ЗаполнитьСписокУчетныхЗаписей()
	
	УчетныеЗаписи.Очистить();
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
					|	УчетныеЗаписи.Ссылка,
					|	УчетныеЗаписи.Наименование
					|ИЗ
					|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписи
					|ГДЕ
					|	УчетныеЗаписи.ИспользоватьДляОтправки
					|	И НЕ УчетныеЗаписи.ПометкаУдаления";
	
	ВыборкаУчетныхЗаписей = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаУчетныхЗаписей.Следующий() Цикл
		НоваяСтрока = УчетныеЗаписи.Добавить();
		НоваяСтрока.УчетнаяЗапись = ВыборкаУчетныхЗаписей.Ссылка;
		НоваяСтрока.Наименование  = ВыборкаУчетныхЗаписей.Наименование;
	КонецЦикла;
	
КонецПроцедуры

// Возвращает количество выбранных учетных записей
//
&НаКлиенте
Функция КоличествоВыбранныхУчетныхЗаписей()
	
	Результат = 0;
	
	Для Каждого СтрокаУчетнаяЗапись Из УчетныеЗаписи Цикл
		Если СтрокаУчетнаяЗапись.Пометка Тогда
			Результат = Результат + 1;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает первую выбранную учетную запись в списке
//
&НаКлиенте
Функция ПолучитьУчетнуюЗаписьИзСписка()
	
	Результат = Неопределено;
	
	Для Каждого СтрокаУчетнаяЗапись Из УчетныеЗаписи Цикл
		Если СтрокаУчетнаяЗапись.Пометка Тогда
			Результат = СтрокаУчетнаяЗапись.УчетнаяЗапись;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает список отмеченных учетных записей
//
// Возвращаемое значение
// Список (тип СписокЗначений)
//        представление - наименование учетной записи
//        значение      - ссылка на учетную запись
//
&НаКлиенте
Функция ПолучитьСписокОтмеченныхУчетныхЗаписей()
	
	Результат = Новый СписокЗначений;
	
	Для Каждого СтрокаУчетнаяЗапись Из УчетныеЗаписи Цикл
		Если СтрокаУчетнаяЗапись.Пометка Тогда
			Результат.Добавить(СтрокаУчетнаяЗапись.УчетнаяЗапись, СтрокаУчетнаяЗапись.Наименование);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЕКЦИЯ ФУНКЦИЙ ГРУППЫ ПРОВЕРКИ ВХОДЯЩИХ СООБЩЕНИЙ
//

&НаКлиенте
Процедура ПроверитьВходящиеВыполнить()
	
	Если НЕ ЗначениеЗаполнено(УчетнаяЗаписьВходящие) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Учетная запись для получения входящих не заполнена.'"));
		Возврат;
	КонецЕсли;
	
	Если Не ПарольЗадан(УчетнаяЗаписьВходящие) Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьВходящиеВыполнитьПарольПолучен", ЭтотОбъект);
		ЗапросПароляДоступаКПочтовомуСерверу(ОписаниеОповещения, УчетнаяЗаписьВходящие);
		Возврат;
	КонецЕсли;
	
	ПроверитьВходящиеВыполнитьЗавершение(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВходящиеВыполнитьПарольПолучен(ПарольПараметр, ДополнительныеПараметры) Экспорт
	Если ПарольПараметр <> Неопределено Тогда
		ПроверитьВходящиеВыполнитьЗавершение(ПарольПараметр);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВходящиеВыполнитьЗавершение(ПарольПараметр)
	
	Состояние(НСтр("ru = 'Загрузка входящих сообщений.'"),,НСтр("ru = 'Пожалуйста, подождите...'"));
	Попытка
		ЗагрузитьВходящиеСообщения(ПарольПараметр);
		НовыхПисем = ВходящиеСообщения.Количество();
		Если НовыхПисем > 0 Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Получено новых писем:'") + " " + НовыхПисем);
		Иначе
			ПоказатьПредупреждение(, НСтр("ru = 'Нет новых писем.'"));
		КонецЕсли;
	Исключение
		ПоказатьПредупреждение(, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

// Организует получения пароля для учетной записи, в которой он не задан
//
&НаКлиенте
Процедура ЗапросПароляДоступаКПочтовомуСерверу(ПриПолученииПароля, УчетнаяЗапись)
	ПараметрУчетнаяЗапись = Новый Структура("УчетнаяЗапись", УчетнаяЗапись);
	ОткрытьФорму("ОбщаяФорма.ПодтверждениеПароляУчетнойЗаписи", ПараметрУчетнаяЗапись, , , , , ПриПолученииПароля);
КонецПроцедуры

// Обрабатывает загрузку почтовых сообщений с сервера.
// В том числе обработка ошибок.
//
&НаСервере
Процедура ЗагрузитьВходящиеСообщения(Знач ПарольПараметр = Неопределено)
	
	ПараметрыЗагрузки = Новый Структура;
	
	ПараметрыЗагрузки.Вставить("Колонки", "ИмяОтправителя, Вложения, Тема, ДатаОтправления, ОбратныйАдрес");
	ПараметрыЗагрузки.Вставить("Пароль", ПарольПараметр);
	
	ТаблицаВходящихСообщений = РаботаСПочтовымиСообщениями.ЗагрузитьПочтовыеСообщения(УчетнаяЗаписьВходящие, ПараметрыЗагрузки);
	
	ВходящиеСообщения.Очистить();
	
	Для Каждого ЭлементВходящееСообщение Из ТаблицаВходящихСообщений Цикл
		НоваяСтрока = ВходящиеСообщения.Добавить();
		НоваяСтрока.Отправитель     = ЭлементВходящееСообщение.ИмяОтправителя;
		НоваяСтрока.ОбратныйАдрес   = ЭлементВходящееСообщение.ОбратныйАдрес;
		НоваяСтрока.Тема            = ЭлементВходящееСообщение.Тема;
		НоваяСтрока.ДатаОтправления = ЭлементВходящееСообщение.ДатаОтправления;
		Если ЭлементВходящееСообщение.Вложения.Количество() > 0 Тогда
			НоваяСтрока.Вложение = Истина;
		Иначе
			НоваяСтрока.Вложение = Ложь;
		КонецЕсли
	КонецЦикла;
	
КонецПроцедуры

// Заполняет список учетных записей в списке выбора элемента формы "УчетнаяЗаписьВходящие"
//
&НаСервере
Процедура Входящие_ЗаполнитьСписокВыбораУчетныхЗаписей()
	
	Элементы.УчетнаяЗаписьВходящие.СписокВыбора.Очистить();
	
	ДоступныеУчетныеЗаписи = РаботаСПочтовымиСообщениями.ДоступныеУчетныеЗаписи(, Истина, Истина);
	
	ЕстьПолныеУчетныеЗаписи = Ложь;
	
	Для Каждого СтрУчЗапись Из ДоступныеУчетныеЗаписи Цикл
		ЕстьПолныеУчетныеЗаписи = Истина;
		Элементы.УчетнаяЗаписьВходящие.СписокВыбора.Добавить(
				СтрУчЗапись.Ссылка,
				СтрУчЗапись.Наименование);
	КонецЦикла;
	
	Если ЕстьПолныеУчетныеЗаписи Тогда
		УчетнаяЗаписьВходящие = Элементы.УчетнаяЗаписьВходящие.СписокВыбора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

// Проверяет задан пароль у учетной записи или нет
// Параметры
// УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты
// Возвращаемое значение
// Истина - пароль задан
// Ложь   - пароль не задан
//
&НаСервере
Функция ПарольЗадан(УчетнаяЗапись)
	
	Если ЗначениеЗаполнено(УчетнаяЗапись.Пароль) Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли
	
КонецФункции

&НаКлиенте
Процедура ПутьКВложениюНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Перем ПомещенныеФайлы;
	
	Если ПодключитьРасширениеРаботыСФайлами() Тогда
		
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файл'");
		
		ПомещенныеФайлы = Новый Массив;
		Если ПоместитьФайлы(, ПомещенныеФайлы, ДиалогОткрытияФайла) Тогда
			ПутьКВложению = ПомещенныеФайлы[0].Имя;
			ЗаполнитьВложение(Вложения, ПомещенныеФайлы[0]);
		КонецЕсли;
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'В Веб-клиенте без установленного расширения работы с файлами добавление файлов не поддерживается.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьВложение(Вложения, Описание)
	
	Вложения.Очистить();
	Вложения.Добавить(ПолучитьИзВременногоХранилища(Описание.Хранение), ВыделитьИмяФайлаИзПолногоПути(Описание.Имя));
	УдалитьИзВременногоХранилища(Описание.Хранение);
	
КонецПроцедуры

// Выделяет собственное имя файла из полного пути к файлу
// 
// Параметры:
// ПутьКФайлу    - строка - полный путь к файлу
//
// Возвращаемое значение:
// строка - выделенное имя файла
//
&НаСервереБезКонтекста
Функция ВыделитьИмяФайлаИзПолногоПути(ПутьКФайлу)
	
	Перем Результат;
	
	Индекс = СтрДлина(ПутьКФайлу);
	Найдено = Ложь;
	
	Пока Индекс > 1 Цикл
		Если Сред(ПутьКФайлу, Индекс, 1) = "\" Тогда
			Найдено = Истина;
			Прервать;
		КонецЕсли;
		Индекс = Индекс - 1;
	КонецЦикла;
	
	Если Найдено Тогда
		Результат = Сред(ПутьКФайлу, Индекс+1, СтрДлина(ПутьКФайлу) - Индекс);
	Иначе
		Результат = ПутьКФайлу;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_УчетныеЗаписиЭлектроннойПочты") Тогда
		
		ЗаполнитьСписокУчетныхЗаписей();
		
	КонецЕсли;
	
КонецПроцедуры
