﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	БольшеНеПоказывать = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	
	Если Найти(СистемнаяИнформация.ИнформацияПрограммыПросмотра, "Firefox") <> 0 Тогда
		Элементы.Дополнения.ТекущаяСтраница = Элементы.MozillaFireFox;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПродолжитьВыполнить(Команда)
	Если БольшеНеПоказывать = Истина Тогда
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьИОбновитьПовторноИспользуемыеЗначения(
			"НастройкиПрограммы",
			"ПоказыватьПодсказкиПриРедактированииФайлов",
			Ложь);
	КонецЕсли;
	Закрыть(БольшеНеПоказывать);
КонецПроцедуры

#КонецОбласти
