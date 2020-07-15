﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЭтоВебКлиент = ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент();
	
	ВыполнитьПроверкуПравДоступа("СохранениеДанныхПользователя", Метаданные);
	
	ПредлагатьПерейтиНаСайтПриЗапуске = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ОбщиеНастройкиПользователя", 
		"ПредлагатьПерейтиНаСайтПриЗапуске",
		Ложь);

	// СтандартныеПодсистемы.БазоваяФункциональность
	Если ЭтоВебКлиент Тогда
		Элементы.ЗапрашиватьПодтверждениеПриЗавершенииПрограммы.Видимость = Ложь;
	Иначе
		Элементы.ГруппаУстановитьРасширениеРаботыСФайламиНаКлиенте.Видимость = Ложь;
	КонецЕсли;
	ЗапрашиватьПодтверждениеПриЗавершенииПрограммы = СтандартныеПодсистемыСервер.ЗапрашиватьПодтверждениеПриЗавершенииПрограммы();
	
	// Определение текущей настройки рабочей даты
	ЗначениеРабочейДаты = ОбщегоНазначения.РабочаяДатаПользователя();
	Если ЗначениеЗаполнено(ЗначениеРабочейДаты) Тогда
		ИспользоватьТекущуюДатуКомпьютера = 0;
	Иначе
		ИспользоватьТекущуюДатуКомпьютера = 1;
		Элементы.ЗначениеРабочейДаты.Доступность = Ложь;
	КонецЕсли;
	
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.Пользователи
	АвторизованныйПользователь = Пользователи.АвторизованныйПользователь();
	Элементы.СведенияОПользователе.Заголовок = АвторизованныйПользователь;
	// Конец СтандартныеПодсистемы.Пользователи
	
	// СтандартныеПодсистемы.РаботаСФайлами
	СпрашиватьРежимРедактированияПриОткрытииФайла = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиОткрытияФайлов",
		"СпрашиватьРежимРедактированияПриОткрытииФайла",
		Истина);
	
	ДействиеПоДвойномуЩелчкуМыши = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиОткрытияФайлов",
		"ДействиеПоДвойномуЩелчкуМыши",
		Перечисления.ДействияСФайламиПоДвойномуЩелчку.ОткрыватьФайл);
	
	СпособСравненияВерсийФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСравненияФайлов",
		"СпособСравненияВерсийФайлов",
		Перечисления.СпособыСравненияВерсийФайлов.ПустаяСсылка());
	
	ПоказыватьПодсказкиПриРедактированииФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы",
		"ПоказыватьПодсказкиПриРедактированииФайлов",
		Ложь);
	
	ПоказыватьИнформациюЧтоФайлНеБылИзменен = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы",
		"ПоказыватьИнформациюЧтоФайлНеБылИзменен",
		Ложь);
	
	ПоказыватьЗанятыеФайлыПриЗавершенииРаботы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы",
		"ПоказыватьЗанятыеФайлыПриЗавершенииРаботы",
		Истина);
	
	ПоказыватьКолонкуРазмер = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы",
		"ПоказыватьКолонкуРазмер",
		Ложь);
	
	// Заполнение настроек открытия файлов.
	СтрокаНастройки = НастройкиОткрытияФайлов.Добавить();
	СтрокаНастройки.ТипФайла = Перечисления.ТипыФайловДляВстроенногоРедактора.ТекстовыеФайлы;
	
	СтрокаНастройки.Расширение = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиОткрытияФайлов\ТекстовыеФайлы",
		"Расширение",
		"TXT XML INI");
	
	СтрокаНастройки.СпособОткрытия = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиОткрытияФайлов\ТекстовыеФайлы",
		"СпособОткрытия",
		Перечисления.СпособыОткрытияФайлаНаПросмотр.ВоВстроенномРедакторе);
	
	Если ЭтоВебКлиент Тогда
		Элементы.ПоказыватьЗанятыеФайлыПриЗавершенииРаботы.Видимость      = Ложь;
	КонецЕсли;
	
	Если ЭтоВебКлиент Или ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
		Элементы.НастройкаСканирования.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ЭлектроннаяПодпись
	Элементы.НастройкаЭП.Видимость = ПравоДоступа("СохранениеДанныхПользователя", Метаданные);
	// Конец СтандартныеПодсистемы.ЭлектроннаяПодпись
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
#Если ВебКлиент Тогда	
	НапоминатьОбУстановкеРасширенияРаботыСФайлами = ОбщегоНазначенияКлиент.ПредлагатьУстановкуРасширенияРаботыСФайлами();
	ОбновитьГруппуУстановкиРасширенияРаботыСФайлами();
#КонецЕсли	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

////////////////////////////////////////////////////////////////////////////////
// Страница Главное

&НаКлиенте
Процедура СведенияОПользователе(Команда)
	
	ПоказатьЗначение(, АвторизованныйПользователь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерсональнаяНастройкаПроксиСервера(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера", Новый Структура("НастройкаПроксиНаКлиенте", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСФайламиНаКлиенте(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьРасширениеРаботыСФайламиНаКлиентеЗавершение", ЭтотОбъект);
	НачатьУстановкуРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьГруппуУстановкиРасширенияРаботыСФайлами()
	
	Подключено = ПодключитьРасширениеРаботыСФайлами();
	Элементы.ГруппаСтраницы.ТекущаяСтраница = ?(Подключено, Элементы.ГруппаРасширениеРаботыСФайламиУстановлено, 
		Элементы.ГруппаРасширениеРаботыСФайламиНеУстановлено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы(Команда)
	
	ОбновитьПовторноИспользуемыеЗначения();
	ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьТекущуюДатуКомпьютераПриИзменении(Элемент)

	Если ИспользоватьТекущуюДатуКомпьютера = 1 Тогда
		ЗначениеРабочейДаты = '0001-01-01';
	Иначе
		ЗначениеРабочейДаты = ТекущаяДата();
	КонецЕсли;
	Элементы.ЗначениеРабочейДаты.Доступность = ИспользоватьТекущуюДатуКомпьютера = 0;
	Модифицированность = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Страница Органайзер

////////////////////////////////////////////////////////////////////////////////
// Страница Печать

&НаКлиенте
Процедура НастройкаРабочегоКаталогаДляПечати(Команда)
	
	ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.НастройкаКаталогаФайловПечати");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьДействиеПриВыбореМакетаПечатнойФормы(Команда)
	
	ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.ВыбораРежимаОткрытияМакета");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Страница РаботаСФайлами

&НаКлиенте
Процедура НастройкаРабочегоКаталога(Команда)
	
	РаботаСФайламиКлиент.ОткрытьФормуНастройкиРабочегоКаталога();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСканирования(Команда)
	
	РаботаСФайламиКлиент.ОткрытьФормуНастройкиСканирования();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаЭП(Команда)
	
	ЭлектроннаяПодписьКлиент.ОткрытьФормуНастройкиЭП();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСКриптографиейНаКлиенте(Команда)
	Обработчик = Новый ОписаниеОповещения("УстановитьРасширениеРаботыСКриптографиейНаКлиентеЗавершение", ЭтотОбъект);
	НачатьУстановкуРасширенияРаботыСКриптографией(Обработчик);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	ПараметрыКлиента = Новый Структура;
	#Если ВебКлиент Тогда
		СистемнаяИнформация = Новый СистемнаяИнформация;
		ПараметрыКлиента.Вставить("ИдентификаторКлиента", СистемнаяИнформация.ИдентификаторКлиента);
	#КонецЕсли
	ЗаписатьНастройкиНаСервере(ПараметрыКлиента);
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьРасширениеРаботыСФайламиНаКлиентеЗавершение(ДополнительныеПараметры) Экспорт
	
	ОбновитьГруппуУстановкиРасширенияРаботыСФайлами();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСКриптографиейНаКлиентеЗавершение(ПараметрыВыполнения) Экспорт
	Перем ОбработчикНеТребуется; // Обработчик не требуется.
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкиНаСервере(ПараметрыКлиента)
	// Рабочая дата.
	Если ИспользоватьТекущуюДатуКомпьютера = 1 Тогда
		ЗначениеРабочейДатыДляСохранения = '0001-01-01';
	Иначе
		ЗначениеРабочейДатыДляСохранения = ЗначениеРабочейДаты;
	КонецЕсли;
	ОбщегоНазначения.УстановитьРабочуюДатуПользователя(ЗначениеРабочейДатыДляСохранения);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	СохранитьСвойстваКоллекции("ОбщиеНастройкиПользователя", ЭтотОбъект,
		"ПредлагатьПерейтиНаСайтПриЗапуске,
		|ЗапрашиватьПодтверждениеПриЗавершенииПрограммы");
	Если ПараметрыКлиента.Свойство("ИдентификаторКлиента") Тогда
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами",
			ПараметрыКлиента.ИдентификаторКлиента,
			НапоминатьОбУстановкеРасширенияРаботыСФайлами);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.РаботаСФайлами
	СохранитьСвойстваКоллекции("НастройкиОткрытияФайлов", ЭтотОбъект,
		"ДействиеПоДвойномуЩелчкуМыши,
		|СпрашиватьРежимРедактированияПриОткрытииФайла");
	СохранитьСвойстваКоллекции("НастройкиПрограммы", ЭтотОбъект,
		"ПоказыватьПодсказкиПриРедактированииФайлов,
		|ПоказыватьЗанятыеФайлыПриЗавершенииРаботы,
		|ПоказыватьКолонкуРазмер,
		|ПоказыватьИнформациюЧтоФайлНеБылИзменен");
	СохранитьСвойстваКоллекции("НастройкиСравненияФайлов", ЭтотОбъект,
		"СпособСравненияВерсийФайлов");
	Если НастройкиОткрытияФайлов.Количество() >= 1 Тогда
		СохранитьСвойстваКоллекции("НастройкиОткрытияФайлов\ТекстовыеФайлы", НастройкиОткрытияФайлов[0],
			"Расширение,
			|СпособОткрытия");
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

&НаСервере
Процедура СохранитьСвойстваКоллекции(КлючОбъекта, Коллекция, ИменаРеквизитов)
	СтруктураРеквизитов = Новый Структура(ИменаРеквизитов);
	ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, Коллекция);
	Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
