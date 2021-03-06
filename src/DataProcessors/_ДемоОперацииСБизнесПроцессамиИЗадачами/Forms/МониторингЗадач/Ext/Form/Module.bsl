﻿
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УведомитьОПросроченныхЗадачах(Команда)
	БизнесПроцессыИЗадачиВызовСервера.ПроконтролироватьЗадачи();
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Мониторинг задач'"), ,
		НСтр("ru = 'Отправлены уведомления о просроченных задачах.'"),
		БиблиотекаКартинок.Информация32);
КонецПроцедуры

&НаКлиенте
Процедура УведомитьОНовыхЗадачах(Команда)
	БизнесПроцессыИЗадачиВызовСервера.УведомитьИсполнителейОНовыхЗадачах();
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Мониторинг задач'"),,
		НСтр("ru = 'Отправлены уведомления о новых задачах.'"),
		БиблиотекаКартинок.Информация32);
КонецПроцедуры

#КонецОбласти
