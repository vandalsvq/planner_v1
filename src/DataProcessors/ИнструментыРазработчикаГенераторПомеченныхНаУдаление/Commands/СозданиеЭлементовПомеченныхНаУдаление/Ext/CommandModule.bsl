﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОткрытьФорму(
		"Обработка.ИнструментыРазработчикаГенераторПомеченныхНаУдаление.Форма.ОсновнаяФорма",
		Новый Структура,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность);
КонецПроцедуры

#КонецОбласти
