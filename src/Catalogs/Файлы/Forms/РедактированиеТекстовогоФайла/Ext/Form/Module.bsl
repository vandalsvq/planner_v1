﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Файл = Параметры.Файл;
	ДанныеФайла = Параметры.ДанныеФайла;
	ИмяОткрываемогоФайла = Параметры.ИмяОткрываемогоФайла;
	
	КодФайла = Файл.Код;
	
	Если ДанныеФайла.РедактируетТекущийПользователь Тогда
		РежимРедактирования = Истина;
	КонецЕсли;
	
	Если ДанныеФайла.Версия <> ДанныеФайла.ТекущаяВерсия Тогда
		РежимРедактирования = Ложь;
	КонецЕсли;
	
	Элементы.Текст.ТолькоПросмотр = Не РежимРедактирования;
	Элементы.ПоказатьОтличия.Видимость = Не ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент();
	Элементы.ПоказатьОтличия.Доступность = РежимРедактирования;
	Элементы.Редактировать.Доступность = Не РежимРедактирования;
	Элементы.ЗакончитьРедактирование.Доступность = РежимРедактирования;
	Элементы.ЗаписатьИЗакрыть.Доступность = РежимРедактирования;
	Элементы.Записать.Доступность = РежимРедактирования;
	
	Если ДанныеФайла.Версия <> ДанныеФайла.ТекущаяВерсия Тогда
		Элементы.Редактировать.Доступность = Ложь;
	КонецЕсли;
	
	ЗаголовокСтрока = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
		ДанныеФайла.ПолноеНаименованиеВерсии, ДанныеФайла.Расширение);
	
	Если Не РежимРедактирования Тогда
		ЗаголовокСтрока = ЗаголовокСтрока + НСтр("ru=' (только просмотр)'");
	КонецЕсли;
	Заголовок = ЗаголовокСтрока;
	
	Если ЗначениеЗаполнено(ДанныеФайла.Версия) Тогда
		КодировкаТекстаФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьКодировкуВерсииФайла(
			ДанныеФайла.Версия);
		
		Если ЗначениеЗаполнено(КодировкаТекстаФайла) Тогда
			СписокКодировок = РаботаСФайламиСлужебный.ПолучитьСписокКодировок();
			ЭлементСписка = СписокКодировок.НайтиПоЗначению(КодировкаТекстаФайла);
			Если ЭлементСписка = Неопределено Тогда
				КодировкаПредставление = КодировкаТекстаФайла;
			Иначе
				КодировкаПредставление = ЭлементСписка.Представление;
			КонецЕсли;
		Иначе
			КодировкаПредставление = НСтр("ru='По умолчанию'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	КлючУникальности = КодФайла;
	
	КодировкаТекстаДляЧтения = КодировкаТекстаФайла;
	Если Не ЗначениеЗаполнено(КодировкаТекстаДляЧтения) Тогда
		КодировкаТекстаДляЧтения = Неопределено;
	КонецЕсли;
	
	Текст.Прочитать(ИмяОткрываемогоФайла, КодировкаТекстаДляЧтения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ФайлРедактировался" И Источник = Файл Тогда
		РежимРедактирования = Истина;
		УстановитьДоступностьКоманд();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ДанныеФайлаИзменены" И Источник = Файл Тогда
		
		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(Файл);
		
		РежимРедактирования = Ложь;
		
		Если ДанныеФайла.РедактируетТекущийПользователь Тогда
			РежимРедактирования = Истина;
		КонецЕсли;
		
		Если ДанныеФайла.Версия <> ДанныеФайла.ТекущаяВерсия Тогда
			РежимРедактирования = Ложь;
		КонецЕсли;
		
		УстановитьДоступностьКоманд();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		Отказ = Истина;
		ИмяИРасширение = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
			ДанныеФайла.ПолноеНаименованиеВерсии,
			ДанныеФайла.Расширение);
		ТекстВопроса = СтрЗаменить(НСтр("ru ='Файл ""%1"" был изменен.'"), "%1", ИмяИРасширение);
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ТекстВопроса", ТекстВопроса);
		Обработчик = Новый ОписаниеОповещения("ПередЗакрытиемПослеОтветаНаВопросПриВыходеИзТекстовогоРедактора", ЭтотОбъект);
		ОткрытьФорму("Справочник.Файлы.Форма.ВопросПриВыходеИзТекстовогоРедактора", ПараметрыФормы, ЭтотОбъект, , , , Обработчик);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	// выбираем путь к файлу на диске
	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ВыборФайла.МножественныйВыбор = Ложь;
	
	ИмяСРасширением = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
		ДанныеФайла.ПолноеНаименованиеВерсии, ДанныеФайла.Расширение);
	
	ВыборФайла.ПолноеИмяФайла = ИмяСРасширением;
	Фильтр = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Все файлы (*.%1)|*.%1'"), ДанныеФайла.Расширение, ДанныеФайла.Расширение);
	ВыборФайла.Фильтр = Фильтр;
	
	Если ВыборФайла.Выбрать() Тогда
		
		ВыбранноеПолноеИмяФайла = ВыборФайла.ПолноеИмяФайла;
		
		КодировкаТекстаДляЗаписи = КодировкаТекстаФайла;
		Если Не ЗначениеЗаполнено(КодировкаТекстаДляЗаписи) Тогда
			КодировкаТекстаДляЗаписи = Неопределено;
		КонецЕсли;
		
		Текст.Записать(ВыбранноеПолноеИмяФайла, КодировкаТекстаДляЗаписи);
		
		Состояние(НСтр("ru = 'Файл успешно сохранен'"), , ВыбранноеПолноеИмяФайла);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	ПоказатьЗначение(, Файл);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнийРедактор(Команда)
	
	ЗаписатьТекст();
	РаботаСФайламиСлужебныйКлиент.ВыполнитьЗапускПриложения(ИмяОткрываемогоФайла);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	РаботаСФайламиСлужебныйКлиент.РедактироватьСОповещением(Неопределено, Файл, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьТекст();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	ЗаписатьТекст();
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("Сценарий", 1);
	Обработчик = Новый ОписаниеОповещения("ЗакончитьРедактированиеЗавершение", ЭтотОбъект, ПараметрыОбработчика);
	
	РаботаСФайламиСлужебныйКлиент.ЗакончитьРедактированиеСОповещением(
		Обработчик,
		Файл,
		УникальныйИдентификатор,
		Неопределено,
		Неопределено,
		Неопределено,
		Неопределено,
		КодировкаТекстаФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтличия(Команда)
	#Если ВебКлиент Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Сравнение версий в веб-клиенте не поддерживается.'"));
	#Иначе
		ПараметрыВыполнения = Новый Структура;
		ПараметрыВыполнения.Вставить("ТекущийШаг", 1);
		ПараметрыВыполнения.Вставить("СпособСравненияВерсийФайлов", Неопределено);
		ПараметрыВыполнения.Вставить("ПолноеИмяФайлаСлева", ПолучитьИмяВременногоФайла(ДанныеФайла.Расширение));
		СравнениеВерсийАвтомат(-1, ПараметрыВыполнения);
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если Модифицированность Тогда
		ЗаписатьТекст();
		
		ПараметрыОбработчика = Новый Структура;
		ПараметрыОбработчика.Вставить("Сценарий", 2);
		Обработчик = Новый ОписаниеОповещения("ЗакончитьРедактированиеЗавершение", ЭтотОбъект, ПараметрыОбработчика);
		
		РаботаСФайламиСлужебныйКлиент.ЗакончитьРедактированиеСОповещением(
			Обработчик,
			Файл,
			УникальныйИдентификатор,
			Неопределено,
			Неопределено,
			Неопределено,
			Неопределено,
			КодировкаТекстаФайла);
		
		Возврат;
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКодировку(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяКодировка", КодировкаТекстаФайла);
	Обработчик = Новый ОписаниеОповещения("ВыбратьКодировкуЗавершение", ЭтотОбъект);
	ОткрытьФорму("Справочник.Файлы.Форма.ВыборКодировки", ПараметрыФормы, ЭтотОбъект, , , , Обработчик);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПередЗакрытиемПослеОтветаНаВопросПриВыходеИзТекстовогоРедактора(Результат, ПараметрыВыполнения) Экспорт
	Если Результат = "СохранитьИЗакончитьРедактирование" Тогда
		ЗаписатьТекст();
		ПараметрыОбработчика = Новый Структура;
		ПараметрыОбработчика.Вставить("Сценарий", 3);
		Обработчик = Новый ОписаниеОповещения("ЗакончитьРедактированиеЗавершение", ЭтотОбъект, ПараметрыОбработчика);
		РаботаСФайламиСлужебныйКлиент.ЗакончитьРедактированиеСОповещением(
			Обработчик,
			Файл,
			УникальныйИдентификатор,
			Неопределено,
			Неопределено,
			Неопределено,
			Неопределено,
			КодировкаТекстаФайла);
	ИначеЕсли Результат = "СохранитьИзменения" Тогда
		ЗаписатьТекст();
		Модифицированность = Ложь;
		Закрыть();
	ИначеЕсли Результат = "НеСохранять" Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКодировкуЗавершение(Результат, ПараметрыВыполнения) Экспорт
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	КодировкаТекстаФайла = Результат.Значение;
	КодировкаПредставление = Результат.Представление;
	
	ПрочитатьТекст();
	
	РаботаСФайламиСлужебныйВызовСервера.ЗаписатьКодировкуВерсииФайлаИИзвлеченныйТекст(
		ДанныеФайла.Версия,
		КодировкаТекстаФайла,
		Текст.ПолучитьТекст());
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактированиеЗавершение(Результат, ПараметрыВыполнения) Экспорт
	Если ПараметрыВыполнения.Сценарий = 1 Тогда
		РежимРедактирования = Ложь;
		УстановитьДоступностьКоманд();
	ИначеЕсли ПараметрыВыполнения.Сценарий = 2 Тогда
		РежимРедактирования = Ложь;
		УстановитьДоступностьКоманд();
		Закрыть();
	ИначеЕсли ПараметрыВыполнения.Сценарий = 3 Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьТекст()
	
	Если Модифицированность Тогда
		
		КодировкаТекстаДляЗаписи = КодировкаТекстаФайла;
		Если Не ЗначениеЗаполнено(КодировкаТекстаДляЗаписи) Тогда
			КодировкаТекстаДляЗаписи = Неопределено;
		КонецЕсли;
		
		Текст.Записать(ИмяОткрываемогоФайла, КодировкаТекстаДляЗаписи);
		Модифицированность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд()
	
	Элементы.Текст.ТолькоПросмотр = Не РежимРедактирования;
	Элементы.ПоказатьОтличия.Доступность = РежимРедактирования;
	Элементы.Редактировать.Доступность = Не РежимРедактирования;
	Элементы.ЗакончитьРедактирование.Доступность = РежимРедактирования;
	Элементы.ЗаписатьИЗакрыть.Доступность = РежимРедактирования;
	Элементы.Записать.Доступность = РежимРедактирования;
	
	ЗаголовокСтрока = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
		ДанныеФайла.ПолноеНаименованиеВерсии, ДанныеФайла.Расширение);
	
	Если Не РежимРедактирования Тогда
		ЗаголовокСтрока = ЗаголовокСтрока + НСтр("ru=' (только просмотр)'");
	КонецЕсли;
	Заголовок = ЗаголовокСтрока;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьТекст()
	
	Текст.Прочитать(ИмяОткрываемогоФайла, КодировкаТекстаФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СравнениеВерсийАвтомат(Результат, ПараметрыВыполнения) Экспорт
	Если ПараметрыВыполнения.ТекущийШаг = 1 Тогда
		ПерсональныеНастройки = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами();
		ПараметрыВыполнения.СпособСравненияВерсийФайлов = ПерсональныеНастройки.СпособСравненияВерсийФайлов;
		Если ПараметрыВыполнения.СпособСравненияВерсийФайлов = Неопределено Тогда // первый вызов - еще не инициализирована настройка
			Обработчик = Новый ОписаниеОповещения("СравнениеВерсийАвтомат", ЭтотОбъект, ПараметрыВыполнения);
			ОткрытьФорму("Справочник.ВерсииФайлов.Форма.ВыборСпособаСравненияВерсий", , ЭтотОбъект, , , , Обработчик);
			ПараметрыВыполнения.ТекущийШаг = 1.1;
			Возврат;
		КонецЕсли;
		ПараметрыВыполнения.ТекущийШаг = 2;
	ИначеЕсли ПараметрыВыполнения.ТекущийШаг = 1.1 Тогда
		Если Результат <> КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;
		ПерсональныеНастройки = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами();
		ПараметрыВыполнения.СпособСравненияВерсийФайлов = ПерсональныеНастройки.СпособСравненияВерсийФайлов;
		Если ПараметрыВыполнения.СпособСравненияВерсийФайлов = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ПараметрыВыполнения.ТекущийШаг = 2;
	КонецЕсли;
	
	Если ПараметрыВыполнения.ТекущийШаг = 2 Тогда
		// Сохранение файла для правой части.
		ЗаписатьТекст(); // Полное имя помещается в реквизит ИмяОткрываемогоФайла.
		
		// Сохранение файла для левой части.
		Если ДанныеФайла.ТекущаяВерсия = ДанныеФайла.Версия Тогда
			ДанныеФайлаСлева = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляСохранения(
				Файл,
				Неопределено,
				УникальныйИдентификатор);
			АдресФайлаСлева = ДанныеФайлаСлева.НавигационнаяСсылкаТекущейВерсии;
		Иначе
			АдресФайлаСлева = РаботаСФайламиСлужебныйВызовСервера.ПолучитьНавигационнуюСсылкуДляОткрытия(
				ДанныеФайла.Версия,
				УникальныйИдентификатор);
		КонецЕсли;
		ПередаваемыеФайлы = Новый Массив;
		ПередаваемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ПараметрыВыполнения.ПолноеИмяФайлаСлева, АдресФайлаСлева));
		Если Не ПолучитьФайлы(ПередаваемыеФайлы,, ПараметрыВыполнения.ПолноеИмяФайлаСлева, Ложь) Тогда
			Возврат;
		КонецЕсли;
		
		// Сравнение.
		РаботаСФайламиСлужебныйКлиент.СравнитьФайлы(
			ПараметрыВыполнения.ПолноеИмяФайлаСлева,
			ИмяОткрываемогоФайла,
			ПараметрыВыполнения.СпособСравненияВерсийФайлов);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
