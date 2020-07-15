﻿#Область СлужебныйПрограммныйИнтерфейс

// Обновляет данные субъектов РФ в адресных объектах
//
// Записи сопоставляются по коду субъекта РФ - региону
//
Процедура ОбновитьСоставСубъектовРФПоКлассификатору() Экспорт
	
	Классификатор = КлассификаторСубъектовРФ();
	
	// Выбираем только отсутствующие в регистре
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	Параметр.КодСубъектаРФ КАК КодСубъектаРФ
		|ПОМЕСТИТЬ
		|	Классификатор
		|ИЗ
		|	&Классификатор КАК Параметр
		|ИНДЕКСИРОВАТЬ ПО
		|	КодСубъектаРФ
		|;
		|
		|ВЫБРАТЬ
		|	Классификатор.КодСубъектаРФ КАК КодСубъектаРФ
		|ИЗ
		|	Классификатор КАК Классификатор
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	РегистрСведений.АдресныйКлассификатор КАК АдресныйКлассификатор
		|ПО
		|	  АдресныйКлассификатор.ТипАдресногоЭлемента      = 1
		|	И АдресныйКлассификатор.КодАдресногоОбъектаВКоде  = Классификатор.КодСубъектаРФ
		|	И АдресныйКлассификатор.КодРайонаВКоде            = 0
		|	И АдресныйКлассификатор.КодГородаВКоде            = 0
		|	И АдресныйКлассификатор.КодНаселенногоПунктаВКоде = 0
		|	И АдресныйКлассификатор.КодУлицыВКоде             = 0
		|ГДЕ
		|	АдресныйКлассификатор.Код ЕСТЬ NULL
		|");
	Запрос.УстановитьПараметр("Классификатор", Классификатор);
	НовыеСубъектыРФ = Запрос.Выполнить().Выгрузить();
	
	// Перезаписываем только отсутствующих
	Набор = РегистрыСведений.АдресныйКлассификатор.СоздатьНаборЗаписей();
	Отбор = Набор.Отбор;
	
	Отбор.ТипАдресногоЭлемента.Установить(1);
	Отбор.КодРайонаВКоде.Установить(0);
	Отбор.КодГородаВКоде.Установить(0);
	Отбор.КодНаселенногоПунктаВКоде.Установить(0);
	Отбор.КодУлицыВКоде.Установить(0);
	
	Для Каждого СубъектРФ Из НовыеСубъектыРФ Цикл
		
		ИсходныеДанные = Классификатор.Найти(СубъектРФ.КодСубъектаРФ, "КодСубъектаРФ");
		
		Отбор.КодАдресногоОбъектаВКоде.Установить(СубъектРФ.КодСубъектаРФ);
		Набор.Очистить();
		
		НовыйСубъектРФ = Набор.Добавить();
		НовыйСубъектРФ.ТипАдресногоЭлемента     = 1;
		НовыйСубъектРФ.КодАдресногоОбъектаВКоде = СубъектРФ.КодСубъектаРФ;
		НовыйСубъектРФ.Код                      = СубъектРФ.КодСубъектаРФ * 10000000000000000000;
		
		НовыйСубъектРФ.Наименование             = ИсходныеДанные.Наименование;
		НовыйСубъектРФ.Сокращение               = ИсходныеДанные.Сокращение;
		НовыйСубъектРФ.Индекс                   = ИсходныеДанные.ПочтовыйИндекс;
		
		Набор.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Возвращает информацию из классификатора субъектов РФ
//
// Возвращаемое значение:
//     ТаблицаЗначений - поставляемые данные. Содержит колонки:
//       * КодСубъектаРФ  - Число  - код классифкатора субъекта, например 77 для Москвы
//       * Наименование   - Строка - наименование субъекта по классификатору. Например "Московская"
//       * Сокращение     - Строка - наименование субъекта по классификатору. Например "Обл"
//       * ПочтовыйИндекс - Число  - индекс региона. Если 0 - то неопределено
//       * Идентификатор  - УникальныйИдентификатор - идентификатор ФИАС
//
Функция КлассификаторСубъектовРФ() Экспорт
	Макет = РегистрыСведений.АдресныйКлассификатор.ПолучитьМакет("СубъектыРФ");
	
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(Макет.ПолучитьТекст());
	Результат = СериализаторXDTO.ПрочитатьXML(Чтение);
	
	Возврат Результат;
КонецФункции

// Возвращает информацию о состоянии загруженности регионов
//
// Возвращаемое значение:
//    ТаблицаЗначений - описание состояния. Содержит колонки
//      * КодСубъектаРФ - Число  - Код региона
//      * Представление - Строка - Наименование и сокращение региона
//      * Загружено     - Булево - Истина, если классификатор по данному региону сейчас загружен
// 
Функция СведенияОЗагрузкеСубъектовРФ() Экспорт
	
	Классификатор = РегистрыСведений.АдресныйКлассификатор.КлассификаторСубъектовРФ();
	
	// Выбираем все возможные данные - и из регистра, и из классификатора
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	Параметр.Наименование  КАК Наименование,
		|	Параметр.Сокращение    КАК Сокращение,
		|	Параметр.КодСубъектаРФ КАК КодСубъектаРФ
		|ПОМЕСТИТЬ
		|	Классификатор
		|ИЗ
		|	&Классификатор КАК Параметр
		|;
		|
		|ВЫБРАТЬ 
		|	ВсеРегионы.Наименование + "" "" + ВсеРегионы.Сокращение КАК Представление,
		|	ВсеРегионы.КодСубъектаРФ                                КАК КодСубъектаРФ,
		|
		|	ВЫБОР
		|		КОГДА 1 В (ВЫБРАТЬ ПЕРВЫЕ 1 1 ИЗ РегистрСведений.АдресныйКлассификатор ГДЕ КодАдресногоОбъектаВКоде = ВсеРегионы.КодСубъектаРФ И ТипАдресногоЭлемента = 2) ТОГДА ИСТИНА
		|		КОГДА 1 В (ВЫБРАТЬ ПЕРВЫЕ 1 1 ИЗ РегистрСведений.АдресныйКлассификатор ГДЕ КодАдресногоОбъектаВКоде = ВсеРегионы.КодСубъектаРФ И ТипАдресногоЭлемента = 3) ТОГДА ИСТИНА
		|		КОГДА 1 В (ВЫБРАТЬ ПЕРВЫЕ 1 1 ИЗ РегистрСведений.АдресныйКлассификатор ГДЕ КодАдресногоОбъектаВКоде = ВсеРегионы.КодСубъектаРФ И ТипАдресногоЭлемента = 4) ТОГДА ИСТИНА
		|		КОГДА 1 В (ВЫБРАТЬ ПЕРВЫЕ 1 1 ИЗ РегистрСведений.АдресныйКлассификатор ГДЕ КодАдресногоОбъектаВКоде = ВсеРегионы.КодСубъектаРФ И ТипАдресногоЭлемента = 5) ТОГДА ИСТИНА
		|		КОГДА 1 В (ВЫБРАТЬ ПЕРВЫЕ 1 1 ИЗ РегистрСведений.АдресныйКлассификатор ГДЕ КодАдресногоОбъектаВКоде = ВсеРегионы.КодСубъектаРФ И ТипАдресногоЭлемента = 6) ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Загружено
		|ИЗ (
		|
		|	ВЫБРАТЬ РАЗЛИЧНЫЕ
		|		АдресныйКлассификатор.Наименование             КАК Наименование,
		|		АдресныйКлассификатор.Сокращение               КАК Сокращение,
		|		АдресныйКлассификатор.КодАдресногоОбъектаВКоде КАК КодСубъектаРФ
		|	ИЗ
		|		РегистрСведений.АдресныйКлассификатор КАК АдресныйКлассификатор
		|	ГДЕ
		|		АдресныйКлассификатор.ТипАдресногоЭлемента        = 1
		|		И АдресныйКлассификатор.КодРайонаВКоде            = 0
		|		И АдресныйКлассификатор.КодГородаВКоде            = 0
		|		И АдресныйКлассификатор.КодНаселенногоПунктаВКоде = 0
		|		И АдресныйКлассификатор.КодУлицыВКоде             = 0
		|	
		|	ОБЪЕДИНИТЬ ВЫБРАТЬ
		|		Классификатор.Наименование,
		|		Классификатор.Сокращение,
		|		Классификатор.КодСубъектаРФ
		|	ИЗ
		|		Классификатор КАК Классификатор
		|
		|) КАК ВсеРегионы
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВсеРегионы.КодСубъектаРФ,
		|	ВсеРегионы.Наименование + "" "" + ВсеРегионы.Сокращение
		|");
	Запрос.УстановитьПараметр("Классификатор", Классификатор);
	
	ЗагруженныеСведения = Запрос.Выполнить().Выгрузить();
	ЗагруженныеСведения.Индексы.Добавить("КодСубъектаРФ");
	ЗагруженныеСведения.Индексы.Добавить("Загружено");
	
	Возврат ЗагруженныеСведения;
КонецФункции

// Определяет наименование с сокращением региона по его коду.
//
// Параметры:
//    КодСубъектаРФ - Строка, Число - код региона.
//
// Возвращаемое значение:
//    Строка, Неопределено - наименование и сокращение региона. Если регион не найден, то возвращается Неопределено
//
Функция НаименованиеРегионаПоКоду(Знач КодСубъектаРФ) Экспорт
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	Наименование + "" "" + Сокращение КАК Наименование
		|ИЗ
		|	РегистрСведений.АдресныйКлассификатор
		|ГДЕ
		|	ТипАдресногоЭлемента = 1
		|	И КодАдресногоОбъектаВКоде = &КодСубъектаРФ
		|");
		
	Если ТипЗнч(КодСубъектаРФ) = Тип("Строка") Тогда
		ТипЧисло = Новый ОписаниеТипов("Число");
		КодСубъектаРФ = ТипЧисло.ПривестиЗначение(КодСубъектаРФ);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("КодСубъектаРФ", КодСубъектаРФ);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		Возврат Выборка.Наименование;
	КонецЕсли;
	
	// Если не нашли, то подсмотрим еще и в классификаторе - макете 
	Классификатор = РегистрыСведений.АдресныйКлассификатор.КлассификаторСубъектовРФ();
	Вариант = Классификатор.Найти(КодСубъектаРФ, "КодСубъектаРФ");
	Если Вариант = Неопределено Тогда
		// Не нашли
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Вариант.Наименование + " " + Вариант.Сокращение;
КонецФункции

// Возвращает код региона по наименованию.
//
// Параметры:
//    Название - Строка - наименование или полное наименование (с сокращением) региона.
//
// Возвращаемое значение:
//    Число, Неопределено - код региона или Неопределено, если данные не найдены
//
Функция КодРегионаПоНаименованию(Знач Название) Экспорт
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ 
		|	Варианты.КодСубъектаРФ
		|ИЗ (
		|	ВЫБРАТЬ ПЕРВЫЕ 1
		|		1                        КАК Порядок,
		|		КодАдресногоОбъектаВКоде КАК КодСубъектаРФ
		|	ИЗ
		|		РегистрСведений.АдресныйКлассификатор
		|	ГДЕ
		|		ТипАдресногоЭлемента = 1 
		|		И Наименование = &Название
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ ПЕРВЫЕ 1
		|		2                        КАК Порядок,
		|		КодАдресногоОбъектаВКоде КАК КодСубъектаРФ
		|	ИЗ
		|		РегистрСведений.АдресныйКлассификатор
		|	ГДЕ
		|		ТипАдресногоЭлемента = 1 
		|		И Наименование = &Наименование
		|		И Сокращение   = &Сокращение
		|) КАК Варианты
		|
		|УПОРЯДОЧИТЬ ПО
		|	Варианты.Порядок
		|");
		
	ЧастиСлова = НаименованиеИСокращение(Название);
	Запрос.УстановитьПараметр("Наименование", ЧастиСлова.Наименование);
	Запрос.УстановитьПараметр("Сокращение",   ЧастиСлова.Сокращение);
	Запрос.УстановитьПараметр("Название",     Название);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		Возврат Выборка.КодСубъектаРФ;
	КонецЕсли;

	// Если не нашли, то подсмотрим еще и в классификаторе - макете 
	Классификатор = РегистрыСведений.АдресныйКлассификатор.КлассификаторСубъектовРФ();
	
	Фильтр = Новый Структура("Наименование", Название);
	Варианты = Классификатор.НайтиСтроки(Фильтр);
	Если Варианты.Количество() = 0 Тогда
		Фильтр.Вставить("Наименование", ЧастиСлова.Наименование);
		Фильтр.Вставить("Сокращение",   ЧастиСлова.Сокращение);
		Варианты = Классификатор.НайтиСтроки(Фильтр);
	КонецЕсли;
	
	Если Варианты.Количество() > 0 Тогда
		Возврат Варианты[0].КодСубъектаРФ;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Разделяет исходный текст на наименование и сокращение.
// Сокращением считается последнее слово, отделенное пробельным символом
//
// Параметры:
//     Название - Строка - Полное название, например "Москва г"
//
// Возвращаемое значение:
//     Структура - содержит поля
//       * Наименование - Строка - Наименование, например "Москва". Если сокращение выделить не удалось, то исходное название
//       * Сокращение   - Строка - Сокращение, например "г". Если сокращение выделить не удалось, то пустая строка
//
Функция НаименованиеИСокращение(Знач Название)
	ТекстПоиска = СокрП(Название);
	
	Позиция = СтрДлина(ТекстПоиска);
	Пока Позиция > 0 Цикл
		Если ПустаяСтрока(Сред(ТекстПоиска, Позиция, 1)) Тогда
			Прервать;
		КонецЕсли;
		Позиция = Позиция - 1;
	КонецЦикла;
	
	Результат = Новый Структура("Наименование, Сокращение");
	Если Позиция = 0 Тогда
		Результат.Наименование = ТекстПоиска;
		Результат.Сокращение   = "";
	Иначе
		Результат.Наименование = СокрП(Лев(ТекстПоиска, Позиция));
		Результат.Сокращение   = Сред(ТекстПоиска, Позиция + 1);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

