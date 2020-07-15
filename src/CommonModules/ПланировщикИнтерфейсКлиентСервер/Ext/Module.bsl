
#Область ПрограммныйИнтерфейс

// Формирование HTML страницы календаря
//
// Параметры:
//	ПараметрыКалендаря - Тип: Структура
//		НачалоРабочегоДня - Тип: Дата
//		КонецРабочегоДня - Тип: Дата
//		ВидКалендаря - Тип: Число
//		ТекущийПериод - Тип: Дата
//		ИмяРасширенияИнтерфейса - Тип: Строка. См. ПланировщикИнтерфейсПереопределяемый.ИмяРасширенияИнтерфейса
//	ТаблицаСобытий - Тип: ТабличнаяЧасть, ТаблицаЗначений
//		колонки см. Обработка.ПланировщикИнтерфейс.ТабличныеЧасти.ТаблицаСобытий
//	РежимПодбора - Тип: Булево
//
// Возвращаемое значение:
//	Строка (текст HTML)
//
Функция ПолучитьТекстСтраницыПланировщика(ПараметрыКалендаря, ТаблицаСобытий, РежимПодбора) Экспорт
	
	ИмяРасширения = ПараметрыКалендаря.ИмяРасширенияИнтерфейса;
	Если ИмяРасширения = "DHTMLX" Тогда
		ТекстСтраницы = ПолучитьТекстСтраницыПланировщика_DHTMLX(ПараметрыКалендаря, ТаблицаСобытий, РежимПодбора);
	ИначеЕсли ИмяРасширения = "Fullcalendar" Тогда
		ТекстСтраницы = ПолучитьТекстСтраницыПланировщика_Fullcalendar(ПараметрыКалендаря, ТаблицаСобытий, РежимПодбора);
	КонецЕсли;
		
	Возврат ТекстСтраницы;
	
КонецФункции

// Формирование структуры с реквизитами формы для передачи в качестве параметра
//
// Параметры:
//	Форма - Тип: УправляемаяФорма. Обработки.ПланировщикИнтерфейс.Форма.Форма
//
// Возвращаемое значение:
//	Структура. Ключи соответствуют реквизитам формы. Табличные части преобразуются
//	в массив структур с ключами соответствующими реквизитам ТЧ
//
Функция ПолучитьСтруктуруРеквизитовФормы(Форма) Экспорт

	МассивКалендари = Новый Массив;
	Для Каждого СтрокаТаблицы Из Форма.Объект.Календари Цикл
		СтруктураКалендари = Новый Структура("Использование, Календарь, Представление");
		ЗаполнитьЗначенияСвойств(СтруктураКалендари, СтрокаТаблицы);
		МассивКалендари.Добавить(СтруктураКалендари);
	КонецЦикла;

	МассивОбщиеКалендари = Новый Массив;
	Для Каждого СтрокаТаблицы Из Форма.Объект.ОбщиеКалендари Цикл
		СтруктураОбщиеКалендари = Новый Структура("Использование, Календарь, Пользователь, Представление");
		ЗаполнитьЗначенияСвойств(СтруктураОбщиеКалендари, СтрокаТаблицы);
		МассивОбщиеКалендари.Добавить(СтруктураОбщиеКалендари);
	КонецЦикла;

	МассивСобытий = Новый Массив;
	Для Каждого СтрокаТаблицы Из Форма.Объект.ТаблицаСобытий Цикл
		СтруктураСобытия = Новый Структура("Идентификатор, Наименование, ВесьДень, Начало, Конец, " + 
			"Редактирование, ЦветФонаHEX, ЦветТекстаHEX, Ссылка, Картинка, ЕстьНапоминания, " + 
			"ЕстьУчастники, ЦветФона");
		ЗаполнитьЗначенияСвойств(СтруктураСобытия, СтрокаТаблицы);
		МассивСобытий.Добавить(СтруктураСобытия);
	КонецЦикла;
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("ВидКалендаря"				, Форма.Объект.ВидКалендаря);
	Реквизиты.Вставить("ДатаКалендаря"				, Форма.Объект.ДатаКалендаря);
	Реквизиты.Вставить("Компоновщик"				, Форма.Объект.Компоновщик);
	Реквизиты.Вставить("НачалоПериода"				, Форма.Объект.НачалоПериода);
	Реквизиты.Вставить("ОкончаниеПериода"			, Форма.Объект.ОкончаниеПериода);
	Реквизиты.Вставить("НачалоРабочегоВремени"		, Форма.Объект.НачалоРабочегоВремени);
	Реквизиты.Вставить("ОкончаниеРабочегоВремени"	, Форма.Объект.ОкончаниеРабочегоВремени);
	Реквизиты.Вставить("ТекущийПользователь"		, Форма.Объект.ТекущийПользователь);
	Реквизиты.Вставить("Календари"					, МассивКалендари);
	Реквизиты.Вставить("ОбщиеКалендари"				, МассивОбщиеКалендари);
	Реквизиты.Вставить("ТаблицаСобытий"				, МассивСобытий);
	
	Возврат Реквизиты;
	
КонецФункции

// Возвращает строку представления периода по переданным параметрам
//
// Параметры:
//	НачалоСобытия - Тип: Дата.
//	ОкончаниеСобытия - Тип: Дата.
//	ВесьДень - Тип: Булево
//
// Возвращаемое значение:
//	Строка
//
Функция ПолучитьПредставлениеПериода(НачалоПериода, ОкончаниеПериода, ВесьДень) Экспорт
	НачНомерДняНедели = ДеньНедели(НачалоПериода);
	КонНомерДняНедели = ДеньНедели(ОкончаниеПериода);
	
	НачНомерМесяца = Месяц(НачалоПериода);
	КонНомерМесяца = Месяц(ОкончаниеПериода);
	
	НачСтрПериод = ПланировщикКлиентСервер.ПредставлениеДняНедели(НачНомерДняНедели);
	КонСтрПериод = ПланировщикКлиентСервер.ПредставлениеДняНедели(КонНомерДняНедели);
	
	НачСтрПериод = НачСтрПериод + ", " + Формат(НачалоПериода, "ДФ=d") + " ";
	КонСтрПериод = КонСтрПериод + ", " + Формат(ОкончаниеПериода, "ДФ=d") + " ";
	
	НачСтрПериод = НачСтрПериод + ПланировщикКлиентСервер.ПредставлениеМесяца(НачНомерМесяца);
	КонСтрПериод = КонСтрПериод + ПланировщикКлиентСервер.ПредставлениеМесяца(КонНомерМесяца);
	
	НачСтрВремя	= Формат(НачалоПериода, "ДФ=HH:mm");
	КонСтрВремя = Формат(ОкончаниеПериода, "ДФ=HH:mm");
	
	ОдинДень = (НачалоДня(НачалоПериода) = НачалоДня(ОкончаниеПериода));
	
	Если ВесьДень Тогда
		СтрПериод = НачСтрПериод + "." + ?(ОдинДень, "", " - " + КонСтрПериод + ".") + НСтр("ru=' весь день'");
	Иначе 
		СтрПериод = НачСтрПериод + "., " + НачСтрВремя + " - " + ?(ОдинДень, "", КонСтрПериод + "., ") + КонСтрВремя;
	КонецЕсли;
	
	Возврат СтрПериод;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьОбщиеСкрипты()
	
	Возврат "var eventName		= '';
	|       var eventParam		= [];
	|		var eventStrParam	= ''
	|		var eventCount		= 0;
	|		var eventDragId		= undefined;
	|
	|		function eventFor1C(Name, Param) {
	|			for (var i in eventParam) {
	|				if (eventStrParam !== '') {
	|					eventStrParam += '&';
	|				}
    |				eventStrParam = eventStrParam + eventParam[i];
	|			}
	|
	|			var elem = document.getElementById('eventData');
	|			elem.setAttribute('data-eventName'	, eventName);
	|			elem.setAttribute('data-eventParam'	, eventStrParam);
	|			elem.setAttribute('data-eventCount'	, eventCount);
	|			
	|			elem.innerHTML = 'plannerEvent';
	|			elem.click();
	|
	|			clearEventParam();
	|			elem.setAttribute('data-eventName'	, eventName);
	|			elem.setAttribute('data-eventParam'	, eventStrParam);
	|			elem.setAttribute('data-eventCount'	, eventCount);
	|		}
	|
	|		function clearEventParam() {
	|			eventName		= '';
	|			eventParam		= [];
	|			eventStrParam	= '';
	|			eventCount		= 0;
	|			eventDragId		= undefined;
	|		}
	|
	|		function getEventParam(x) {
	|			return eventParam[x];
	|		}
	|
	|		function execCommand() {
	|			var elem = document.getElementById('sendEvent');
	|			if (elem.innerHTML !== '') {
	|				alert(elem.innerHTML);
	|				var result = eval(elem.innerHTML);
	|			}
	|			elem.innerHTML = '';
	|		}";
	
КонецФункции

#КонецОбласти

#Область DHTMLX

Функция ПолучитьТекстСтраницыПланировщика_DHTMLX(ПараметрыКалендаря, ТаблицаСобытий, РежимПодбора)
	
	// PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'
	
	ТекстСтраницы = 
	"<!DOCTYPE html>
	|<html>
	|<head>
	|	<meta http-equiv='Content-Type' content='text/html;charset=utf-8'/>
	|	<meta http-equiv='X-UA-Compatible' content='IE=9'/>
    |		
	|" + ПолучитьСтрокуЗаголовкаСтраницыПланировщика_DHTMLX() + "
	|	<style type='text/css'>
	|	    html, body{
	|	        margin:0px;
	|	        padding:0px;
	|	        height:100%;
	|	        overflow:hidden;
	|	    }
	|		" + ПолучитьСтрокуНастройкиСтилейПланировщика_DHTMLX() + "
	|	</style>	
	|	<script type='text/javascript' charset='utf-8'>
	|		" + ПолучитьОбщиеСкрипты() + "
	|
	|		function init() {
	|			" + ПолучитьСтрокуНастройкиСтраницыПланировщика_DHTMLX(ПараметрыКалендаря, РежимПодбора) + "
	|			
	|			scheduler.parse(" + ПолучитьСтрокуСобытийСтраницыПланировщика_DHTMLX(ТаблицаСобытий) + ",""json"");
	|		}
	|	</script>
	|</head>
	|<body onload='init();'>
	|	<div id='scheduler_here' class='dhx_cal_container' style='width:100%; height:100%;'>
	|		<div class='dhx_cal_header'></div>
	|		<div class='dhx_cal_data'></div>
	|		<div class='dhx_cal_navline' style='visibility:hidden; margin:0; padding:0; height:0px;'>
	|			<div class='dhx_cal_prev_button'>&nbsp;</div>
	|			<div class='dhx_cal_next_button'>&nbsp;</div>
	|			<div class='dhx_cal_today_button'></div>
	|			<div class='dhx_cal_date'></div>
	|			<div class='dhx_cal_tab' name='day_tab' style='right:204px;'></div>
	|			<div class='dhx_cal_tab' name='week_tab' style='right:140px;'></div>
	|			<div class='dhx_cal_tab' name='month_tab' style='right:76px;'></div>
	|		</div>
	|	</div>
	|	<div id='eventData' data-eventName='' data-eventParam='' data-eventCount='0' style='display:none'></div>
	|   <input type='button' id='sendEvent' onclick='execCommand()' style='display:none'></input>
	|</body>
	|</html>";
	
	Возврат ТекстСтраницы;
	
КонецФункции

// Формирование HTML страницы календаря

Функция ПолучитьСтрокуНастройкиСтилейПланировщика_DHTMLX()
	Возврат "/* background color for whole container and it's border*/
	|		.my_event {
	|			background-color: #add8e6;
	|			border: 1px solid #778899;
	|			overflow: hidden;
	|		}
	|		/* disabling default color for select menu */
	|		.dhx_cal_select_menu.my_event div {
	|			border: 0;
	|			background-color: transparent;
	|			color: black;
	|		}
	|		/* styles for event content */
	|		.dhx_cal_event.my_event .my_event_body {
	|			padding-top: 2px;
	|			padding-left: 3px;
	|		}
	|		/* event's date information */
	|		.my_event .event_date {
	|			font-weight: bold;
	|			padding-right: 5px;
	|		}
	|		/* event's resizing section */
	|		.my_event_resize {
	|			position: absolute;
	|			text-align: center;
	|			bottom: -1px;
	|		}
	|		/* event's move section */
	|		.my_event_move {
	|			position: absolute;
	|			top: 0;
	|			height: 15px;
	|			cursor: pointer;
	|		}";
КонецФункции
	
Функция ПолучитьСтрокуЗаголовкаСтраницыПланировщика_DHTMLX()
	// Необходимые ссылки и документация
	
	Версия = "4.3.0";
	Если Версия = "4.3.0" Тогда
		Возврат	
		"	<script type='text/javascript' src='dhtmlxscheduler.js'></script>
		|	<link rel='stylesheet' type='text/css' href='dhtmlxscheduler.css'>";
		//Возврат	
		//"	<script type='text/javascript' src='http://docs.dhtmlx.com/scheduler/codebase/dhtmlxscheduler.js'></script>
		//|	<link rel='stylesheet' type='text/css' href='http://docs.dhtmlx.com/scheduler/codebase/dhtmlxscheduler.css'>";
	КонецЕсли;
	
	//|	<link rel='stylesheet' type='text/css' href='contextmenu.css'>
	//|	<script type='text/javascript' src='jquery.contextmenu.js'></script>
КонецФункции

Функция ПолучитьСтрокуНастройкиСтраницыПланировщика_DHTMLX(Параметры, РежимПодбора)
	#Если Клиент Тогда
	    ТекДатаСеанса = ОбщегоНазначенияКлиент.ДатаСеанса();
	#ИначеЕсли Сервер Тогда 
		ТекДатаСеанса = ТекущаяДатаСеанса();
	#Иначе
		ТекДатаСеанса = ТекущаяДата();
	#КонецЕсли 
	
	НачалоРабочегоДня	= ?(Параметры.Свойство("НачалоРабочегоДня"), Параметры.НачалоРабочегоДня, 0);
	КонецРабочегоДня	= ?(Параметры.Свойство("КонецРабочегоДня"), Параметры.КонецРабочегоДня, 24);
	ВидКалендаря		= ?(Параметры.Свойство("ВидКалендаря"), Параметры.ВидКалендаря, 1);
	ТекущийПериод		= ?(Параметры.Свойство("ТекущийПериод"), Параметры.ТекущийПериод, ТекДатаСеанса);
	
	Если НЕ ТипЗнч(ВидКалендаря) = Тип("Число") Тогда
		ВидКалендаря = 1;
	ИначеЕсли ВидКалендаря < 1 ИЛИ ВидКалендаря > 3 Тогда
		ВидКалендаря = 1;
	КонецЕсли;
	
	ВидыКалендаря = Новый Соответствие;
	ВидыКалендаря.Вставить(1, "'day'");
	ВидыКалендаря.Вставить(2, "'week'");
	ВидыКалендаря.Вставить(3, "'month'");
	
	МесяцПредставление = Новый Соответствие;
	МесяцПредставление.Вставить(1, Новый Структура("Полн, Сокр", НСтр("ru='Январь'"), НСтр("ru='Янв'")));
	МесяцПредставление.Вставить(2, Новый Структура("Полн, Сокр", НСтр("ru='Февраль'"), НСтр("ru='Фев'")));
	МесяцПредставление.Вставить(3, Новый Структура("Полн, Сокр", НСтр("ru='Март'"), НСтр("ru='Мар'")));
	МесяцПредставление.Вставить(4, Новый Структура("Полн, Сокр", НСтр("ru='Апрель'"), НСтр("ru='Апр'")));
	МесяцПредставление.Вставить(5, Новый Структура("Полн, Сокр", НСтр("ru='Май'"), НСтр("ru='Май'")));
	МесяцПредставление.Вставить(6, Новый Структура("Полн, Сокр", НСтр("ru='Июнь'"), НСтр("ru='Июн'")));
	МесяцПредставление.Вставить(7, Новый Структура("Полн, Сокр", НСтр("ru='Июль'"), НСтр("ru='Июл'")));
	МесяцПредставление.Вставить(8, Новый Структура("Полн, Сокр", НСтр("ru='Август'"), НСтр("ru='Авг'")));
	МесяцПредставление.Вставить(9, Новый Структура("Полн, Сокр", НСтр("ru='Сентябрь'"), НСтр("ru='Сен'")));
	МесяцПредставление.Вставить(10, Новый Структура("Полн, Сокр", НСтр("ru='Октябрь'"), НСтр("ru='Окт'")));
	МесяцПредставление.Вставить(11, Новый Структура("Полн, Сокр", НСтр("ru='Ноябрь'"), НСтр("ru='Ноя'")));
	МесяцПредставление.Вставить(12, Новый Структура("Полн, Сокр", НСтр("ru='Декабрь'"), НСтр("ru='Дек'")));
	
	ДеньНеделиПредставление = Новый Соответствие;
	ДеньНеделиПредставление.Вставить(1, Новый Структура("Полн, Сокр", НСтр("ru='Понедельник'"), НСтр("ru='Пн'"))); 
	ДеньНеделиПредставление.Вставить(2, Новый Структура("Полн, Сокр", НСтр("ru='Вторник'"), НСтр("ru='Вт'"))); 
	ДеньНеделиПредставление.Вставить(3, Новый Структура("Полн, Сокр", НСтр("ru='Среда'"), НСтр("ru='Ср'"))); 
	ДеньНеделиПредставление.Вставить(4, Новый Структура("Полн, Сокр", НСтр("ru='Четверг'"), НСтр("ru='Чт'"))); 
	ДеньНеделиПредставление.Вставить(5, Новый Структура("Полн, Сокр", НСтр("ru='Пятница'"), НСтр("ru='Пт'"))); 
	ДеньНеделиПредставление.Вставить(6, Новый Структура("Полн, Сокр", НСтр("ru='Суббота'"), НСтр("ru='Сб'"))); 
	ДеньНеделиПредставление.Вставить(7, Новый Структура("Полн, Сокр", НСтр("ru='Воскресенье'"), НСтр("ru='Вс'"))); 
	
	ПараметрыНастроек = Новый Структура;
	ПараметрыНастроек.Вставить("ТолькоПросмотр"		, Ложь);
	ПараметрыНастроек.Вставить("ОтображатьВыходные"	, Истина);
	ПараметрыНастроек.Вставить("Месяцы"				, МесяцПредставление);
	ПараметрыНастроек.Вставить("ДниНедели"			, ДеньНеделиПредставление);
	ПараметрыНастроек.Вставить("ВесьДень"			, НСтр("ru='Весь день'"));
	ПараметрыНастроек.Вставить("МинВремяСобытия"	, 30);
	ПараметрыНастроек.Вставить("НачалоРабочегоДня"	, НачалоРабочегоДня);
	ПараметрыНастроек.Вставить("КонецРабочегоДня"	, КонецРабочегоДня);
	ПараметрыНастроек.Вставить("НачальныйВид"		, ВидКалендаря);
	
	ПланировщикИнтерфейсКлиентСерверПереопределяемый.ПриУстановкеНастроекФормыПланировщика(ПараметрыНастроек);
	
	ТекстМесяцыПолн	= "";
	ТекстМесяцыСокр	= "";
	Для НомерМесяца = 1 По 12 Цикл
		Представление = ПараметрыНастроек.Месяцы.Получить(НомерМесяца);
		
		ТекстМесяцыПолн	= ТекстМесяцыПолн + ?(ПустаяСтрока(ТекстМесяцыПолн), "", ",") + 
			"'" + Представление.Полн + "'";
		ТекстМесяцыСокр	= ТекстМесяцыСокр + ?(ПустаяСтрока(ТекстМесяцыСокр), "", ",") + 
			"'" + Представление.Сокр + "'";
	КонецЦикла;
	
	// Подменим вс с 7-го на 0-й день
	НастройкиДниНедели	= ПараметрыНастроек.ДниНедели;
	НастройкиДниНедели.Вставить(0, НастройкиДниНедели.Получить(7));
	ПараметрыНастроек.Вставить("ДниНедели", НастройкиДниНедели);
	
	ТекстДниПолн = "";
	ТекстДниСокр = "";
	Для НомерДня = 1 По 7 Цикл
		Представление = ПараметрыНастроек.ДниНедели.Получить(НомерДня - 1);
		
		ТекстДниПолн	= ТекстДниПолн + ?(ПустаяСтрока(ТекстДниПолн), "", ",") + 
			"'" + Представление.Полн + "'";
		ТекстДниСокр	= ТекстДниСокр + ?(ПустаяСтрока(ТекстДниСокр), "", ",") + 
			"'" + Представление.Сокр + "'";
	КонецЦикла;
	
	СтрТекДата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("new Date(%1,%2,%3)",
		 Формат(Год(ТекущийПериод), "ЧГ="), Формат(Месяц(ТекущийПериод)-1, "ЧН=0; ЧГ="), Формат(День(ТекущийПериод), "ЧГ="));
	
	Возврат "
	|			scheduler.config.xml_date = '%Y-%m-%d %H:%i';
	|			scheduler.config.api_date = '%Y-%m-%d %H:%i';
	|			scheduler.config.multi_day = true;
	|
	|			" + ?(ПараметрыНастроек.НачалоРабочегоДня = 0, "", "scheduler.config.first_hour = " + ПараметрыНастроек.НачалоРабочегоДня + ";") + "
	|			" + ?(ПараметрыНастроек.КонецРабочегоДня = 24, "", "scheduler.config.last_hour = " + ПараметрыНастроек.КонецРабочегоДня + ";") + "
	|
	|			scheduler.config.start_on_monday = true;
	|			scheduler.config.time_step = " + ПараметрыНастроек.МинВремяСобытия + ";
	|
	|			scheduler.config.mark_now			= true;
	|			scheduler.config.full_day			= true;
	|			scheduler.config.max_month_events	= 5;
	|
	|			scheduler.config.details_on_create		= false;
	|			scheduler.config.details_on_dblclick	= false;
	|			scheduler.config.edit_on_create			= false;
	|			scheduler.config.dblclick_create		= false;
	|
	|			scheduler.locale={
	|				date:{
	|					month_full:[" + ТекстМесяцыПолн + "],
	|					month_short:[" + ТекстМесяцыСокр + "],
	|					day_full:[" + ТекстДниПолн + "],
	|					day_short:[" + ТекстДниСокр + "]},
	|				labels:{
	|					dhx_cal_today_button: 'Сегодня',
	|					day_tab:'День',
	|					week_tab:'Неделя',
	|					month_tab:'Месяц',
	|					new_event:'Новое событие',
	|					icon_save:'Сохранить',
	|					icon_cancel:'Отменить',
	|					icon_details:'Подробнее',
	|					icon_edit:'Редактировать',
	|					icon_delete:'Удалить',
	|					confirm_closing:'', //Your changes will be lost, are you sure?
	|					confirm_deleting:'Событие будет удалено. Продолжить?',
	|					section_description:'Заголовок',
	|					section_time:'Время'
	|				}};
	|
	|			scheduler.xy.min_event_height = 20; // 30 minutes is the shortest duration to be displayed as is
	|			scheduler.xy.nav_height = 0;
	|			
	|			" + ПолучитьСтрокуОбработчиковСтраницыПланировщика_DHTMLX(РежимПодбора) + "
	|
	|			scheduler.init('scheduler_here', " + СтрТекДата + ", " + ВидыКалендаря.Получить(ПараметрыНастроек.НачальныйВид) + ");
	|";
КонецФункции

Функция ПолучитьСтрокуСобытийСтраницыПланировщика_DHTMLX(ДанныеСобытий)
	Текст = "[";
	
	ШаблонСобытия = "{id: '%1', start_date: '%3', end_date: '%4', text: '%2', color: '%5', textColor: '%6', editable: %7}";
	
	Счетчик		= 0;
	Количество	= ДанныеСобытий.Количество();
	Для Каждого СтруктураСобытия Из ДанныеСобытий Цикл
		Счетчик = Счетчик + 1;
		
		Редактирование = ?(СтруктураСобытия.Свойство("Редактирование"), СтруктураСобытия.Редактирование, Истина);
		
		Наименование = СтруктураСобытия.Наименование;
		Наименование = СтрЗаменить(Наименование, Символы.ПС, " ");
		
		НачалоСобытия	= СтруктураСобытия.Начало;
		КонецСобытия	= ?(СтруктураСобытия.ВесьДень, КонецДня(СтруктураСобытия.Конец) + 1, СтруктураСобытия.Конец);
		
		ТекстСобытия = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСобытия,
			СтруктураСобытия.Идентификатор, 
			Наименование,
			Формат(НачалоСобытия, "ДФ='yyyy-MM-dd HH:mm'"),
			Формат(КонецСобытия, "ДФ='yyyy-MM-dd HH:mm'"),
			СтруктураСобытия.ЦветФонаHEX,
			СтруктураСобытия.ЦветТекстаHEX,
			?(Редактирование, "true", "false"));
		
		Текст = Текст + ТекстСобытия + ?(Счетчик = Количество, "", "," + Символы.ПС + "					");
	КонецЦикла;
	
	Возврат Текст + "]";
КонецФункции

Функция ПолучитьСтрокуОбработчиковСтраницыПланировщика_DHTMLX(РежимПодбора)
	ТекстОбработчиков = 
	"
	|			scheduler.templates.event_class = function(start, end, event) {
	|				return ""my_event"";
	|			};
	|  	
	|			scheduler.renderEvent = function(container, ev, width, height, header_content, body_content) {
	|				container.style.color = ev.textColor;
	|				if (ev.color !== undefined) {
	|					container.style.background = ev.color;
	|					container.style.border = ""1px "" + ev.color + "" solid"";
	|				}
	|				
	|				var str_style_w = ""style='width: "" + container.style.width + "";'"";
	|				var html = '';
	|
	|				// move section
	|				if (ev.editable == true) {
	|					html += ""<div class='dhx_event_move my_event_move' "" + str_style_w + ""></div>"";
	|				}
	|  	
	|				// container for event contents
	|				html+= ""<div class='my_event_body' "" + str_style_w + "">"";
	|					html += ""<span class='event_date'>"";
	|					
	|					// two options here: show only start date for short events or start+end for long
	|					if ((ev.end_date - ev.start_date) / 60000 > 40) { // if event is longer than 40 minutes
	|						html += scheduler.templates.event_header(ev.start_date, ev.end_date, ev);
	|						html += ""</span><br/>"";
	|					} else {
	|						html += scheduler.templates.event_date(ev.start_date) + ""</span>"";
	|					}
	|					// displaying event text
	|					html += ""<span>"" + scheduler.templates.event_text(ev.start_date, ev.end_date, ev) + ""</span>"";
	|				html += ""</div>"";
	|  	
	|				// resize section
	|				if (ev.editable == true) {
	|					html += ""<div class='dhx_event_resize my_event_resize' "" + str_style_w + "">=</div>"";
	|				}
	|  	
	|				container.innerHTML = html;
	|				return true; // required, true - we've created custom form; false - display default one instead
	|			};
	|
	|			scheduler.attachEvent(""onClick"", function (event_id, ev){
	|				eventName	= 'eventClick';
	|				eventParam	= [event_id];
	|				eventCount	= 1;
	|		
	|				eventFor1C();
	|				
	|				return false;
	|			});
	|
	|			scheduler.attachEvent(""onEmptyClick"", function (date, e){
	//|				if (eventName == 'select' && eventCount == 3) {
	//|					return false;
	//|				} // событие определено ранее
	//|               
	//|				var formatFunc	= scheduler.date.date_to_str(""%Y%m%d%H%i%s"");
	//|				var end_date = new Date(date);
	//|				end_date.setMinutes(30);
	//|				
	//|				eventName	= 'select';
	//|				eventParam	= [formatFunc(date), formatFunc(end_date), false];
	//|				eventCount	= 3;
	//|		        
	//|				eventFor1C();
	|				
	|				return false;
	|			});
	|
	|			scheduler.attachEvent(""onBeforeDrag"", function (id, mode, event){
	|				if (mode == ""create"") {
	|					eventName = 'select';
	|				} else if (mode == 'move') {
	|					var drag_ev = scheduler.getEvent(id);
	|
	|					if (drag_ev.editable == false) {
	|						return false;
	|					}
	|					
	|					eventName	= 'eventDragStart';
	|					eventParam	= [id, drag_ev.start_date, drag_ev.end_date];
	|				} else if (mode == 'resize') {
	|					var drag_ev = scheduler.getEvent(id);
	|
	|					if (drag_ev.editable == false) {
	|						return false;
	|					}
	|					
	|					eventName = 'eventResizeStart';
	|					eventParam	= [id, drag_ev.start_date, drag_ev.end_date];
	|				} else {
	|					return false;
	|				}
	|				
	|				eventDragId = id;
	|				
	|				return true;
	|			});
	|
	|			scheduler.attachEvent(""onEventDrag"", function (id, move, event){
	|				eventDragId = id;
	|				return true;
	|			});
	|
	|			scheduler.attachEvent(""onDragEnd"", function (){
	|				var drag_ev		= scheduler.getEvent(eventDragId);
	|				var formatFunc	= scheduler.date.date_to_str(""%Y%m%d%H%i%s"");
	|
	|				if (drag_ev == undefined) {
	|					return true
	|				}
	|				
	|				if (eventName == 'select') {
	|					eventParam	= [formatFunc(drag_ev.start_date), formatFunc(drag_ev.end_date), false];
	|					eventCount	= 3;
	|
	|					scheduler.deleteEvent(eventDragId);
	|				} else if (eventName == 'eventDragStart') {
	|					if (drag_ev.start_date == eventParam[1]) {
	|						eventName	= 'eventClick';
	|						eventParam	= [eventDragId];
	|						eventCount	= 1;
	|					} else {
	|						var secondDelta	= (drag_ev.start_date - eventParam[1]) / 1000;
	|						var dayDelta	= Math.floor(secondDelta / 86400);
	|						var minuteDelta	= Math.floor((secondDelta - dayDelta * 86400) / 60);
	|						
	|						eventName	= 'eventDrop';
	|						eventParam	= [eventDragId, dayDelta, minuteDelta, false];
	|						eventCount	= 4;
	|					}
	|				} else if (eventName == 'eventResizeStart') {
	|					if (drag_ev.end_date == eventParam[2]) {
	|						eventName	= 'eventClick';
	|						eventParam	= [eventDragId];
	|						eventCount	= 1;
	|					} else {
	|						var secondDelta	= (drag_ev.end_date - eventParam[2]) / 1000;
	|						var dayDelta	= Math.floor(secondDelta / 86400);
	|						var minuteDelta	= Math.floor((secondDelta - dayDelta * 86400) / 60);
	|						
	|						eventName	= 'eventResize';
	|						eventParam	= [eventDragId, dayDelta, minuteDelta];
	|						eventCount	= 3;
	|					}
	|				} else {
	|					return false;
	|				}
	|		
	|				eventFor1C();
	|				
	|				return true;
	|			});
	|
	|			scheduler.attachEvent('onViewChange', function (new_mode , new_date){
	|				var formatFunc	= scheduler.date.date_to_str(""%Y%m%d%H%i%s"");
	|				
	|				eventName	= 'onViewChange';
	|				eventParam	= [new_mode, formatFunc(new_date)];
	|				eventCount	= 2;
	|		
	|				eventFor1C();
	|			});
	|";
	
	Если НЕ РежимПодбора Тогда
		//ТекстОбработчиков = ТекстОбработчиков + ",
		//|	select: function(startDate, endDate, allDay, jsEvent, view) {
		//|		eventName	= 'select';
		//|		eventParam	= [$.fullCalendar.formatDate(startDate, 'yyyyMMddHHmmss'), $.fullCalendar.formatDate(endDate, 'yyyyMMddHHmmss'), allDay];
		//|		eventCount	= 3;
		//|		
		//|		eventFor1C();
		//|	},
		//|	eventClick: function(event) {
		//|		eventName	= 'eventClick';
		//|		eventParam	= [event.id];
		//|		eventCount	= 1;
		//|		
		//|		eventFor1C();
		//|	},
		//|	dayClick: function(date, allDay, jsEvent, view) {
		//|		eventName	= 'dayClick';
		//|		eventParam	= [$.fullCalendar.formatDate(date, 'yyyyMMddHHmmss'), allDay];
		//|		eventCount	= 2;
		//|		
		//|		eventFor1C();
		//|	}";
	КонецЕсли;
	
	Возврат	ТекстОбработчиков + Символы.ПС;
КонецФункции

#КонецОбласти

#Область Fullcalendar

Функция ПолучитьТекстСтраницыПланировщика_Fullcalendar(ПараметрыКалендаря, ТаблицаСобытий, РежимПодбора)
	// PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'
	ТекстСтраницы = 
	"<!DOCTYPE html>
	|<html>
	|<head>
	|	<meta http-equiv='Content-Type' content='text/html;charset=utf-8'/>
	|	<meta http-equiv='X-UA-Compatible' content='IE=9'/>
    |		
	|" + ПолучитьСтрокуЗаголовкаСтраницыПланировщика_Fullcalendar() + "
	|	<style>
	|		.fc-border-separate tr.fc-last th,
	|		.fc-border-separate tr.fc-last td {
	|			vertical-align: middle;}
	|
	|		.fc-event {
	|			font-size:8pt;}
	|		.fc-event-time {
	|			font-size:8pt;}
	|		.fc-event-vert .fc-event-time {
	|			font-size:8pt;}
	|
	|		.fc-day-header, .fc-widget-header {
	|			font-weight: normal;
	|			height: 20px;}
	|
	|		.fc-state-highlight {
	|			background: #FFF3A1;}
	|	</style>
	|	<script type='text/javascript'>
	|		" + ПолучитьОбщиеСкрипты() + "
	|
	|		$(document).ready(function() {
	|
	|			$('#calendar').fullCalendar({
	|
	|" + ПолучитьСтрокуНастройкиСтраницыПланировщика_Fullcalendar(ПараметрыКалендаря) + ",
	|" + ПолучитьСтрокуСобытийСтраницыПланировщика_Fullcalendar(ТаблицаСобытий) + ",
	|" + ПолучитьСтрокуОбработчиковСтраницыПланировщика_Fullcalendar(РежимПодбора) + "
	|
	|			})
	|		})
	|
	|	</script> 
	|</head>
	|<body>
	|	<div id='calendar' style='font-family:Tahoma; font-size:8pt;'></div>
	|	<div id='eventData' data-eventName='' data-eventParam='' data-eventCount='0' style='display:none'></div>
	|   <input type='button' id='sendEvent' onclick='execCommand()' style='display:none'></input>
	//|<div id='eventMenu' class='contextMenu'>
	//|	<ul style='font-family:Courier New; font-size:12px'>
	//|		<li id='info'>Информация</li>
	////|		<li id='copy'>Копировать</li>
	//|		<li id='delete'>Удалить</li>
	////|		<li id='send'>Отправить по e-mail</li>
	//|	</ul>
	//|</div>
	|
	|</body>
	|</html>";
	
	Возврат ТекстСтраницы;
	
КонецФункции

// Формирование HTML страницы календаря
Функция ПолучитьСтрокуЗаголовкаСтраницыПланировщика_Fullcalendar()
	// Необходимые ссылки и документация
	// fullcalendar: http://fullcalendar.io/
	// contextMenu: http://www.trendskitchens.co.nz/jquery/contextmenu/
	
	//http://cdnjs.cloudflare.com/ajax/libs/fullcalendar/1.6.4/fullcalendar.min.js
	//http://cdnjs.cloudflare.com/ajax/libs/fullcalendar/1.6.4/fullcalendar.min.css
	
	//http://progtb.ru/share/fullcalendar/1.5.4/fullcalendar.css
	//http://progtb.ru/share/fullcalendar/1.5.4/fullcalendar.min.js
	
	//http://progtb.ru/share/fullcalendar/1.6.7/fullcalendar.css
	//http://progtb.ru/share/fullcalendar/1.6.7/fullcalendar.min.js
	
	//http://progtb.ru/share/fullcalendar/2.2.3/fullcalendar.css
	//http://progtb.ru/share/fullcalendar/2.2.3/fullcalendar.min.js
	
	//Версия = "2.2.3";
	Версия = "1.6.7";
	
	Если Версия = "1.6.7" Тогда
		Возврат	
		"	<link rel='stylesheet' type='text/css' href='http://progtb.ru/share/fullcalendar/1.6.7/fullcalendar.css'>
		|	<script type='text/javascript' src='http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js'></script>
		|	<script type='text/javascript' src='http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js'></script>
		|	<script type='text/javascript' src='http://progtb.ru/share/fullcalendar/1.6.7/fullcalendar.min.js'></script>";
	ИначеЕсли Версия = "2.2.3" Тогда
		Возврат	
		"	<link rel='stylesheet' type='text/css' href='http://fullcalendar.io/js/fullcalendar-2.2.3/fullcalendar.css'>
		|	<script type='text/javascript' src='http://fullcalendar.io/js/fullcalendar-2.2.3/lib/jquery.min.js'></script>
		|	<script type='text/javascript' src='http://fullcalendar.io/js/fullcalendar-2.2.3/lib/moment.min.js'></script>
		|	<script type='text/javascript' src='http://fullcalendar.io/js/fullcalendar-2.2.3/fullcalendar.min.js'></script>";
	КонецЕсли;
	
	//|	<link rel='stylesheet' type='text/css' href='contextmenu.css'>
	//|	<script type='text/javascript' src='jquery.contextmenu.js'></script>
КонецФункции

Функция ПолучитьСтрокуНастройкиСтраницыПланировщика_Fullcalendar(Параметры)
	#Если Клиент Тогда
	    ТекДатаСеанса = ОбщегоНазначенияКлиент.ДатаСеанса();
	#ИначеЕсли Сервер Тогда 
		ТекДатаСеанса = ТекущаяДатаСеанса();
	#Иначе
		ТекДатаСеанса = ТекущаяДата();
	#КонецЕсли 
	
	НачалоРабочегоДня	= ?(Параметры.Свойство("НачалоРабочегоДня"), Параметры.НачалоРабочегоДня, 0);
	КонецРабочегоДня	= ?(Параметры.Свойство("КонецРабочегоДня"), Параметры.КонецРабочегоДня, 24);
	ВидКалендаря		= ?(Параметры.Свойство("ВидКалендаря"), Параметры.ВидКалендаря, 1);
	ТекущийПериод		= ?(Параметры.Свойство("ТекущийПериод"), Параметры.ТекущийПериод, ТекДатаСеанса);
	
	Если НЕ ТипЗнч(ВидКалендаря) = Тип("Число") Тогда
		ВидКалендаря = 1;
	ИначеЕсли ВидКалендаря < 1 ИЛИ ВидКалендаря > 3 Тогда
		ВидКалендаря = 1;
	КонецЕсли;
	
	ВидыКалендаря = Новый Соответствие;
	ВидыКалендаря.Вставить(1, "'agendaDay'");
	ВидыКалендаря.Вставить(2, "'agendaWeek'");
	ВидыКалендаря.Вставить(3, "'month'");
	
	МесяцПредставление = Новый Соответствие;
	МесяцПредставление.Вставить(1, Новый Структура("Полн, Сокр", НСтр("ru='Январь'"), НСтр("ru='Янв'")));
	МесяцПредставление.Вставить(2, Новый Структура("Полн, Сокр", НСтр("ru='Февраль'"), НСтр("ru='Фев'")));
	МесяцПредставление.Вставить(3, Новый Структура("Полн, Сокр", НСтр("ru='Март'"), НСтр("ru='Мар'")));
	МесяцПредставление.Вставить(4, Новый Структура("Полн, Сокр", НСтр("ru='Апрель'"), НСтр("ru='Апр'")));
	МесяцПредставление.Вставить(5, Новый Структура("Полн, Сокр", НСтр("ru='Май'"), НСтр("ru='Май'")));
	МесяцПредставление.Вставить(6, Новый Структура("Полн, Сокр", НСтр("ru='Июнь'"), НСтр("ru='Июн'")));
	МесяцПредставление.Вставить(7, Новый Структура("Полн, Сокр", НСтр("ru='Июль'"), НСтр("ru='Июл'")));
	МесяцПредставление.Вставить(8, Новый Структура("Полн, Сокр", НСтр("ru='Август'"), НСтр("ru='Авг'")));
	МесяцПредставление.Вставить(9, Новый Структура("Полн, Сокр", НСтр("ru='Сентябрь'"), НСтр("ru='Сен'")));
	МесяцПредставление.Вставить(10, Новый Структура("Полн, Сокр", НСтр("ru='Октябрь'"), НСтр("ru='Окт'")));
	МесяцПредставление.Вставить(11, Новый Структура("Полн, Сокр", НСтр("ru='Ноябрь'"), НСтр("ru='Ноя'")));
	МесяцПредставление.Вставить(12, Новый Структура("Полн, Сокр", НСтр("ru='Декабрь'"), НСтр("ru='Дек'")));
	
	ДеньНеделиПредставление = Новый Соответствие;
	ДеньНеделиПредставление.Вставить(1, Новый Структура("Полн, Сокр", НСтр("ru='Понедельник'"), НСтр("ru='Пн'"))); 
	ДеньНеделиПредставление.Вставить(2, Новый Структура("Полн, Сокр", НСтр("ru='Вторник'"), НСтр("ru='Вт'"))); 
	ДеньНеделиПредставление.Вставить(3, Новый Структура("Полн, Сокр", НСтр("ru='Среда'"), НСтр("ru='Ср'"))); 
	ДеньНеделиПредставление.Вставить(4, Новый Структура("Полн, Сокр", НСтр("ru='Четверг'"), НСтр("ru='Чт'"))); 
	ДеньНеделиПредставление.Вставить(5, Новый Структура("Полн, Сокр", НСтр("ru='Пятница'"), НСтр("ru='Пт'"))); 
	ДеньНеделиПредставление.Вставить(6, Новый Структура("Полн, Сокр", НСтр("ru='Суббота'"), НСтр("ru='Сб'"))); 
	ДеньНеделиПредставление.Вставить(7, Новый Структура("Полн, Сокр", НСтр("ru='Воскресенье'"), НСтр("ru='Вс'"))); 
	
	ПараметрыНастроек = Новый Структура;
	ПараметрыНастроек.Вставить("ТолькоПросмотр"		, Ложь);
	ПараметрыНастроек.Вставить("ОтображатьВыходные"	, Истина);
	ПараметрыНастроек.Вставить("Месяцы"				, МесяцПредставление);
	ПараметрыНастроек.Вставить("ДниНедели"			, ДеньНеделиПредставление);
	ПараметрыНастроек.Вставить("ВесьДень"			, НСтр("ru='Весь день'"));
	ПараметрыНастроек.Вставить("МинВремяСобытия"	, 30);
	ПараметрыНастроек.Вставить("НачалоРабочегоДня"	, НачалоРабочегоДня);
	ПараметрыНастроек.Вставить("КонецРабочегоДня"	, КонецРабочегоДня);
	ПараметрыНастроек.Вставить("НачальныйВид"		, ВидКалендаря);
	
	ПланировщикИнтерфейсКлиентСерверПереопределяемый.ПриУстановкеНастроекФормыПланировщика(ПараметрыНастроек);
	
	ТекстМесяцыПолн	= "";
	ТекстМесяцыСокр	= "";
	Для НомерМесяца = 1 По 12 Цикл
		Представление = ПараметрыНастроек.Месяцы.Получить(НомерМесяца);
		
		ТекстМесяцыПолн	= ТекстМесяцыПолн + ?(ПустаяСтрока(ТекстМесяцыПолн), "", ",") + 
			"'" + Представление.Полн + "'";
		ТекстМесяцыСокр	= ТекстМесяцыСокр + ?(ПустаяСтрока(ТекстМесяцыСокр), "", ",") + 
			"'" + Представление.Сокр + "'";
	КонецЦикла;
	
	// Подменим вс с 7-го на 0-й день
	НастройкиДниНедели	= ПараметрыНастроек.ДниНедели;
	НастройкиДниНедели.Вставить(0, НастройкиДниНедели.Получить(7));
	ПараметрыНастроек.Вставить("ДниНедели", НастройкиДниНедели);
	
	ТекстДниПолн = "";
	ТекстДниСокр = "";
	Для НомерДня = 1 По 7 Цикл
		Представление = ПараметрыНастроек.ДниНедели.Получить(НомерДня - 1);
		
		ТекстДниПолн	= ТекстДниПолн + ?(ПустаяСтрока(ТекстДниПолн), "", ",") + 
			"'" + Представление.Полн + "'";
		ТекстДниСокр	= ТекстДниСокр + ?(ПустаяСтрока(ТекстДниСокр), "", ",") + 
			"'" + Представление.Сокр + "'";
	КонецЦикла;
	
	Возврат 
	"	header: false,
	|	height: 1100,
	|	editable: " + ?(ПараметрыНастроек.ТолькоПросмотр, "false", "true") + ",
	|	selectable: " + ?(ПараметрыНастроек.ТолькоПросмотр, "false", "true") + ",
	|	selectHelper: " + ?(ПараметрыНастроек.ТолькоПросмотр, "false", "true") + ",
	|	firstDay: 1,
	|	weekends: " + ?(ПараметрыНастроек.ОтображатьВыходные, "true", "false") + ",
	|	monthNames: [" + ТекстМесяцыПолн + "],
	|	monthNamesShort: [" + ТекстМесяцыСокр + "],
	|	dayNames: [" + ТекстДниПолн + "],
	|	dayNamesShort: [" + ТекстДниСокр + "],
	|	allDayText: '" + ПараметрыНастроек.ВесьДень + "',
	|	axisFormat: 'HH:mm',
	|	columnFormat: 
	|		{
	|			month: 'dddd',
	|			week: 'ddd, MMMM d',
	|			day: 'dd MMMM yyyy'
	|		},
	|	timeFormat:
	|		{
	|			agenda: 'HH:mm{ - HH:mm}',
	|			'': 'HH:mm'
	|		},
	|	defaultEventMinutes: " + Формат(ПараметрыНастроек.МинВремяСобытия, "ЧГ=") + ",
	|	firstHour: 10,
	|	" + ?(ПараметрыНастроек.НачалоРабочегоДня = 0, "", "minTime: " + ПараметрыНастроек.НачалоРабочегоДня + ",") + "
	|	" + ?(ПараметрыНастроек.КонецРабочегоДня = 24, "", "maxTime: " + ПараметрыНастроек.КонецРабочегоДня + ",") + "
	|	defaultView: " + ВидыКалендаря.Получить(ПараметрыНастроек.НачальныйВид) + ",
	|	year: " + Формат(Год(ТекущийПериод), "ЧГ=") + ",
	|	month: " + Формат(Месяц(ТекущийПериод)-1, "ЧН=0; ЧГ=") + ",
	|	date: " + Формат(День(ТекущийПериод), "ЧГ=");
КонецФункции

Функция ПолучитьСтрокуСобытийСтраницыПланировщика_Fullcalendar(ДанныеСобытий)
	Текст = "	events: 
	|		[";
	
	ШаблонСобытия	= 
	"
	|			{
	|				id: '%1',
	|				title: '%2',
	|				allDay: %3,
	|				start: '%4',
	|				end: '%5',
	|				editable: %6,
	|				color: '%7',
	|				textColor: '%8',
	|				imgsrc: '%9'
	|			}";
	
	Счетчик		= 0;
	Количество	= ДанныеСобытий.Количество();
	Для Каждого СтруктураСобытия Из ДанныеСобытий Цикл
		Счетчик = Счетчик + 1;
		
		Редактирование = ?(СтруктураСобытия.Свойство("Редактирование"), СтруктураСобытия.Редактирование, Истина);
		
		Наименование = СтруктураСобытия.Наименование;
		Наименование = СтрЗаменить(Наименование, Символы.ПС, " ");
		
		ТекстСобытия = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСобытия,
			СтруктураСобытия.Идентификатор, 
			Наименование,
			?(СтруктураСобытия.ВесьДень, "true", "false"),
			Формат(СтруктураСобытия.Начало, "ДФ='yyyy-MM-dd HH:mm:ss'"),
			Формат(СтруктураСобытия.Конец, "ДФ='yyyy-MM-dd HH:mm:ss'"),
			?(Редактирование, "true", "false"),
			СтруктураСобытия.ЦветФонаHEX,
			СтруктураСобытия.ЦветТекстаHEX,
			?(СтруктураСобытия.Свойство("Картинка"), СтруктураСобытия.Картинка, ""));
		
		Текст = Текст + ТекстСобытия + ?(Счетчик = Количество, "", ",");
	КонецЦикла;
	
	Возврат Текст + "		]";
КонецФункции

Функция ПолучитьСтрокуОбработчиковСтраницыПланировщика_Fullcalendar(РежимПодбора)
	ТекстОбработчиков = 
	"	eventDragStart: function(event, jsEvent, ui, view) {
	|		eventName	= 'eventDragStart';
	|		eventParam	= [event.id];
	|		eventCount	= 1;
	|		
	|		eventFor1C();
	|	},
	|	eventDragStop: function(event, jsEvent, ui, view) {
	|		eventName	= 'eventDragStop';
	|		eventParam	= [event.id];
	|		eventCount	= 1;
	|		
	|		eventFor1C();
	|	},
	|	eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view) {
	|		eventName	= 'eventDrop';
	|		eventParam	= [event.id, dayDelta, minuteDelta, allDay];
	|		eventCount	= 4;
	|		
	|		eventFor1C();
	|	},
	|	eventResizeStart: function(event, jsEvent, ui, view) {
	|		eventName	= 'eventResizeStart';
	|		eventParam	= [event.id];
	|		eventCount	= 1;
	|		
	|		eventFor1C();
	|	},
	|	eventResizeStop: function(event, jsEvent, ui, view) {
	|		eventName	= 'eventResizeStop';
	|		eventParam	= [event.id];
	|		eventCount	= 1;
	|		
	|		eventFor1C();
	|	},
	|	eventResize: function(event, dayDelta, minuteDelta, revertFunc, jsEvent, ui, view) {
	|		eventName	= 'eventResize';
	|		eventParam	= [event.id, dayDelta, minuteDelta];
	|		eventCount	= 3;
	|		
	|		eventFor1C();
	|	},
	|	eventRender: function(event, eventElement) {
	|		if (event.imgsrc)
	|			{
	|				eventElement.find(""div.fc-event-inner"").prepend(""<img src='"" + event.imgsrc + ""' style='float:left; margin-right:2px; width:11px; height:11px;'>"");
	|			}
	|	}
	|";
	
	Если НЕ РежимПодбора Тогда
		ТекстОбработчиков = ТекстОбработчиков + ",
		|	select: function(startDate, endDate, allDay, jsEvent, view) {
		|		eventName	= 'select';
		|		eventParam	= [$.fullCalendar.formatDate(startDate, 'yyyyMMddHHmmss'), $.fullCalendar.formatDate(endDate, 'yyyyMMddHHmmss'), allDay];
		|		eventCount	= 3;
		|		
		|		eventFor1C();
		|	},
		|	eventClick: function(event) {
		|		eventName	= 'eventClick';
		|		eventParam	= [event.id];
		|		eventCount	= 1;
		|		
		|		eventFor1C();
		|	}";
	КонецЕсли;
	
	Возврат	ТекстОбработчиков + Символы.ПС;
КонецФункции

#КонецОбласти


