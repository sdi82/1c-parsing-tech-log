#Область ДополнительныеОбработки

Функция СведенияОВнешнейОбработке() Экспорт
	
	МассивНазначений = Новый Массив;
	
	ПараметрыРегистрации = Новый Структура;
	ПараметрыРегистрации.Вставить("Вид", "ДополнительнаяОбработка");
	ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
	ПараметрыРегистрации.Вставить("Наименование", "Частотный анализ событий");
	ПараметрыРегистрации.Вставить("Версия", "2023.07.29");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
	ПараметрыРегистрации.Вставить("Информация", ИнформацияПоИсторииИзменений());
	ПараметрыРегистрации.Вставить("ВерсияБСП", "1.2.1.4");
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	ДобавитьКоманду(ТаблицаКоманд,
	                "Настройка 'Частотный анализ событий'",
					"НастройкаЧастотныйАнализСобытий",
					"ОткрытиеФормы",
					Истина,
					"",
					"ФормаНастроек"
					);
	ДобавитьКоманду(ТаблицаКоманд,
	                "ЧастотныйАнализСобытийФоново",
					"ЧастотныйАнализСобытийФоново",
					"ВызовСерверногоМетода",
					Ложь,
					"",
					"ФормаМонитора",
					Ложь
					);

	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

Функция ПолучитьТаблицуКоманд()
	
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	Команды.Колонки.Добавить("ПросмотрВсе", Новый ОписаниеТипов("Булево"));
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("ИмяФормы", Новый ОписаниеТипов("Строка"));
	
	Возврат Команды;
	
КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "", ИмяФормы="",ПросмотрВсе=Истина)
	
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
	НоваяКоманда.ИмяФормы = ИмяФормы;
	НоваяКоманда.ПросмотрВсе = ПросмотрВсе;
	
КонецПроцедуры

Функция ИнформацияПоИсторииИзменений()
	Возврат "
	| <div style='text-indent: 25px;'>Данная обработка позволяет выполнять частотную обработку данных</div>
	| <div style='text-indent: 25px;'>Форма Настройка 'Частотный анализ' выполнить настройку </div>
	| <hr />
	| <div style='text-indent: 25px;'>Автор идеи: Крючков Владимир.</div>
	| <div style='text-indent: 25px;'>Реализовали: Крючков Владимир.</div>
	| <hr />
	| Подробную информацию смотрите по адресу интернет: <a target='_blank' href='https://github.com/Polyplastic/1c-parsing-tech-log'>https://github.com/Polyplastic/1c-parsing-tech-log</a>";
	
КонецФункции

Процедура ВыполнитьКоманду(Знач ИдентификаторКоманды, ПараметрыКоманды=Неопределено) Экспорт
	
	Если ИдентификаторКоманды="ЧастотныйАнализСобытийФоново" Тогда
		
		// только при наличии параметров
		Если ПараметрыКоманды=Неопределено Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ЧастотныйАнализСобытий

Процедура ВыполнитьЗагрузкуДанных(Замер,ДополнительнаяОбработка=Неопределено) Экспорт
	
	ВыполнитьЧастотныйАнализСобытий(Замер);	
	
КонецПроцедуры

Функция ВыполнитьЧастотныйАнализСобытий(Замер) Экспорт
	
	// получим настройки загрузки
	мНастройка = УправлениеХранилищемНастроекВызовСервера.ДанныеИзБезопасногоХранилища(Замер);
	
	Если мНастройка=Неопределено Тогда
		ЗаписьЖурналаРегистрации("ЗагрузитьДанныеВЗамерСервер",УровеньЖурналаРегистрации.Ошибка,Неопределено,Замер,"Не созданы настройки для операции произвольной загрузки по замеру ("+Замер+")");
		Возврат 0;
	КонецЕсли;
	
	//ЗаписыватьРезультатОбработкиВИсходныйЗамер = мНастройка.ЗаписыватьРезультатОбработкиВИсходныйЗамер;
	
	РазмерФайла = 0;
	ПрочитаноСтрок = 0;
	
	
	//инициализация фильтров
	РеквизитыЗамера = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Замер, "ФильтрТипСобытия,ФильтрСвойстваСобытия,ФильтрСвойстваСобытияКроме,ФильтрДлительность,НачалоПериода,КонецПериода,ТипЗамера,ДополнительнаяОбработка");
	РеквизитыЗамера.Вставить("ФильтрТипСобытия", РеквизитыЗамера.ФильтрТипСобытия.Получить());
	НачалоПериода 	= РеквизитыЗамера.НачалоПериода;
	КонецПериода 	= РеквизитыЗамера.КонецПериода;
		

	АдресURL = "/ЧастотныйАнализСобытий/"+Строка(Замер.UUID()); 
				
	ФайлЗамера = Справочники.ФайлыЗамера.ПолучитьФайлПоПолномуИмени(Замер, АдресURL);
		
	//получим состояние чтения
	СостояниеЧтения = РегистрыСведений.СостояниеЧтения.ПолучитьСостояние(ФайлЗамера);
	
	
	//по факту - количество прочитанных данных
	ПрочитаноСтрок 						= СостояниеЧтения.ПрочитаноСтрок;
	ДатаПрочитанныхДанных 				= СостояниеЧтения.ДатаПрочитанныхДанных;
	ПоследнееОбработанноеСобытиеЗамера 	= СостояниеЧтения.СобытиеЗамера;
	
	
	// читаем в границе
	Если ДатаПрочитанныхДанных<НачалоПериода Тогда
		ДатаПрочитанныхДанных = НачалоПериода;
	КонецЕсли;

	КешСвертки = Новый Соответствие;
 	КешСверткиИзБазы = Новый Соответствие;

	// 1) обработка полученных данных
	ТаблицаДанных = ПолучитьДанныеНаСервере(мНастройка,ДатаПрочитанныхДанных);
	Если ТаблицаДанных.Количество()>0 Тогда
		ПоследнееОбработанноеСобытиеЗамера = ТаблицаДанных[ТаблицаДанных.Количество()-1].СобытиеЗамера;
		ДатаПрочитанныхДанных = ТаблицаДанных[ТаблицаДанных.Количество()-1].Дата;
		ПрочитаноСтрок = ПрочитаноСтрок+ТаблицаДанных.Количество();
	Иначе        
		// нет данных для обработки
		Возврат 0;
	КонецЕсли;
	
	ВыполнитьРасчетПолученныхДанных(ТаблицаДанных,КешСвертки,мНастройка);
	
	// 2) теперь добавим уже рассчитанные данные
	ТаблицаРассчитанныхДанных = ПолучитьТаблицуРассчитанныхДанных(Замер,мНастройка);
	СтруктураСвойств = Новый Структура;
	
	
	СтруктураСвойств.Вставить("Значение",СправочникиСерверПовтИсп.ПолучитьСвойство("Значение"));
	СтруктураСвойств.Вставить("ОбработанныйТекст",СправочникиСерверПовтИсп.ПолучитьСвойство("ОбработанныйТекст"));
	СтруктураСвойств.Вставить("КоличествоСовпадений",СправочникиСерверПовтИсп.ПолучитьСвойство("КоличествоСовпадений"));
	СтруктураСвойств.Вставить("Аналитика1",СправочникиСерверПовтИсп.ПолучитьСвойство("Аналитика1"));
	СтруктураСвойств.Вставить("Аналитика2",СправочникиСерверПовтИсп.ПолучитьСвойство("Аналитика2"));
	СтруктураСвойств.Вставить("ЗначениеАналитика1",СправочникиСерверПовтИсп.ПолучитьСвойство("ЗначениеАналитика1"));
	СтруктураСвойств.Вставить("ЗначениеАналитика2",СправочникиСерверПовтИсп.ПолучитьСвойство("ЗначениеАналитика2"));
	СтруктураСвойств.Вставить("ТипГруппировки",СправочникиСерверПовтИсп.ПолучитьСвойство("ТипГруппировки"));
	СтруктураСвойств.Вставить("ДатаГруппировки",СправочникиСерверПовтИсп.ПолучитьСвойство("ДатаГруппировки"));
	СтруктураСвойств.Вставить("Хеш",СправочникиСерверПовтИсп.ПолучитьСвойство("Хеш"));
	СтруктураСвойств.Вставить("ДатаПоследнейЗаписи",СправочникиСерверПовтИсп.ПолучитьСвойство("ДатаПоследнейЗаписи"));
	СтруктураСвойств.Вставить("ДлительностьМксМаксимум",СправочникиСерверПовтИсп.ПолучитьСвойство("ДлительностьМксМаксимум"));
	СтруктураСвойств.Вставить("ДлительностьМксСумма",СправочникиСерверПовтИсп.ПолучитьСвойство("ДлительностьМксСумма"));
	СтруктураСвойств.Вставить("ДополнительноеСвойство",СправочникиСерверПовтИсп.ПолучитьСвойство("ДополнительноеСвойство"));
	СтруктураСвойств.Вставить("ЗначениеДополнительноеСвойство",СправочникиСерверПовтИсп.ПолучитьСвойство("ЗначениеДополнительноеСвойство"));
	
	
	КлючиПоискаИмениПоСвойству = Новый Соответствие;
	Для каждого стр из СтруктураСвойств Цикл
		КлючиПоискаИмениПоСвойству.Вставить(стр.Значение,стр.Ключ);
	КонецЦикла;
	
	// сформируем таблицу из рассчитанных данных, кеш по ключу
	КешРассчитанных = Новый Соответствие;
	Для каждого стр из ТаблицаРассчитанныхДанных Цикл
		СтруктураСтроки = КешРассчитанных.Получить(стр.Ссылка);
		Если СтруктураСтроки=Неопределено Тогда
			СтруктураСтроки = Новый Структура;
			СтруктураСтроки.Вставить("СобытияЗамера",стр.Ссылка);
		КонецЕсли;         
		ИмяСвойства = КлючиПоискаИмениПоСвойству.Получить(стр.Свойство);
		Если ИмяСвойства=Неопределено Тогда
			Продолжить;
		КонецЕсли;
		СтруктураСтроки.Вставить(ИмяСвойства,стр.Значение);
		КешРассчитанных.Вставить(стр.Ссылка,СтруктураСтроки);
	КонецЦикла;	  
	
	// Сформируем ключи   
	Для каждого стр из КешРассчитанных Цикл    
		ТипГруппировки = "";
		ДатаГруппировки = "";
		ЗначениеАналитика1 = "";
		ЗначениеАналитика2 = "";    
		ЗначениеХеш = "";
		Если стр.Значение.Свойство("ЗначениеАналитика1") Тогда
			ЗначениеАналитика1 = стр.Значение.ЗначениеАналитика1;
		КонецЕсли;
		Если стр.Значение.Свойство("ЗначениеАналитика2") Тогда
			ЗначениеАналитика2 = стр.Значение.ЗначениеАналитика2;
		КонецЕсли;       
		Если стр.Значение.Свойство("ТипГруппировки") Тогда
			ТипГруппировки = стр.Значение.ТипГруппировки;
		КонецЕсли;       
		Если стр.Значение.Свойство("ДатаГруппировки") Тогда
			ДатаГруппировки = стр.Значение.ДатаГруппировки;
		КонецЕсли;       
		Если стр.Значение.Свойство("Хеш") Тогда
			ЗначениеХеш = стр.Значение.Хеш;
		КонецЕсли;       
		Ключ = НРег(Строка(ЗначениеХеш)+"->"+ТипГруппировки+":"+ДатаГруппировки+" "+ЗначениеАналитика1+" "+ЗначениеАналитика2);
		стр.Значение.Вставить("Ключ",Ключ);
		КешСверткиИзБазы.Вставить(Ключ,стр.Значение);
	КонецЦикла;    
	
	// 3) Выполним добавление и обмен
	// пройдемся по полученным данным
	Для каждого стр из КешСвертки Цикл
		
		СобытиеЗамераОбъект = Неопределено;
		
		// 1 найдем это новый или старый
		ЭлементИзБазы = КешСверткиИзБазы.Получить(стр.Ключ);
		Если ЭлементИзБазы=Неопределено Тогда
			СобытиеЗамераОбъект = Справочники.СобытияЗамера.СоздатьЭлемент();
			СобытиеЗамераОбъект.Владелец = Замер;
			СобытиеЗамераОбъект.Файл = ФайлЗамера;
			СобытиеЗамераОбъект.ДатаСобытия = стр.Значение.ДатаГруппировки;
			СобытиеЗамераОбъект.ДлительностьМкс = стр.Значение.ДлительностьМксМаксимум;
			
			// табличная часть
			Для каждого тч из стр.Значение Цикл
				// пропускаем свойства, которые нам не нужны
				Если СтруктураСвойств.Свойство(тч.Ключ)=Ложь Тогда
					Продолжить;
				КонецЕсли;                                 
				стр_н = СобытиеЗамераОбъект.КлючевыеСвойства.Добавить();
				стр_н.Свойство = СтруктураСвойств[тч.Ключ];
				Если ТипЗнч(тч.Значение)=Тип("Число") Тогда
					стр_н.ЗначениеЧисло = тч.Значение;  
					стр_н.Значение = XMLСтрока(тч.Значение);
				Иначе                                   
					стр_н.Значение = Строка(тч.Значение);
				КонецЕсли;
			КонецЦикла;
		Иначе     
			СобытиеЗамераОбъект = ЭлементИзБазы.СобытияЗамера.ПолучитьОбъект();
			// изменим КоличествоСовпадений
			мОтбор = новый Структура("Свойство",СтруктураСвойств.КоличествоСовпадений);
			строка_события = СобытиеЗамераОбъект.КлючевыеСвойства.НайтиСтроки(мОтбор);
			Если строка_события.Количество()>0 Тогда
				строка_события[0].ЗначениеЧисло = строка_события[0].ЗначениеЧисло+стр.Значение.КоличествоСовпадений;
				строка_события[0].Значение = строка_события[0].ЗначениеЧисло;
			КонецЕсли;
			// изменим ДатаПоследнейЗаписи
			мОтбор = новый Структура("Свойство",СтруктураСвойств.ДатаПоследнейЗаписи);
			строка_события = СобытиеЗамераОбъект.КлючевыеСвойства.НайтиСтроки(мОтбор);
			Если строка_события.Количество()>0 Тогда
				строка_события[0].Значение = стр.Значение.ДатаПоследнейЗаписи;
			КонецЕсли;
			// изменим ДлительностьМксМаксимум
			мОтбор = новый Структура("Свойство",СтруктураСвойств.ДлительностьМксМаксимум);
			строка_события = СобытиеЗамераОбъект.КлючевыеСвойства.НайтиСтроки(мОтбор);
			Если строка_события.Количество()>0 Тогда
				Если строка_события[0].ЗначениеЧисло<стр.Значение.ДлительностьМксМаксимум Тогда
					строка_события[0].ЗначениеЧисло = стр.Значение.ДлительностьМксМаксимум;
					строка_события[0].Значение = стр.Значение.ДлительностьМксМаксимум;
					СобытиеЗамераОбъект.ДлительностьМкс = стр.Значение.ДлительностьМксМаксимум;
				КонецЕсли;
			КонецЕсли;
			// изменим ДлительностьМксСумма
			мОтбор = новый Структура("Свойство",СтруктураСвойств.ДлительностьМксСумма);
			строка_события = СобытиеЗамераОбъект.КлючевыеСвойства.НайтиСтроки(мОтбор);
			Если строка_события.Количество()>0 Тогда
				строка_события[0].ЗначениеЧисло = строка_события[0].ЗначениеЧисло+стр.Значение.ДлительностьМксСумма;
				строка_события[0].Значение = строка_события[0].ЗначениеЧисло;
			КонецЕсли;
		КонецЕсли;
		
		Если НЕ СобытиеЗамераОбъект=Неопределено Тогда
			СобытиеЗамераОбъект.Записать();
		КонецЕсли;
		
	КонецЦикла;	
	
	// Обновление инфорации о количестве прочитанных строк
	РегистрыСведений.СостояниеЧтения.УстановитьСостояние(
		ФайлЗамера, 
		ДатаПрочитанныхДанных,
		ПрочитаноСтрок, 
		ДатаПрочитанныхДанных,
		РазмерФайла,
		ДатаПрочитанныхДанных,
		ПоследнееОбработанноеСобытиеЗамера);
		
	Возврат 1;
		
КонецФункции       

Процедура ВыполнитьРасчетПолученныхДанных(ТаблицаДанных,КешСвертки,мНастройка)
	
	Для каждого стр из ТаблицаДанных Цикл		
		
		Хеш = Новый ХешированиеДанных(ХешФункция.MD5);	
		ОбработанныйТекст = стр.Значение;
		ОбработанныйТекст = ОбработатьТекст(ОбработанныйТекст,мНастройка);
		Хеш.Добавить(стр.Значение);
		ЗначениеХеш = Хеш.ХешСумма;  
		
		// нет
		Если мНастройка.ГруппировкаБезПериода=Истина Тогда		
			ДатаГрупировки = Дата('00010101');                                                     
			ОбновитьКешПоГруппировке(ТаблицаДанных, мНастройка, ОбработанныйТекст, ЗначениеХеш, КешСвертки, стр, ДатаГрупировки, "Нет");
		КонецЕсли;
		
		// Год  
		Если мНастройка.ГруппировкаГод=Истина Тогда
			ДатаГрупировки = НачалоГода(стр.Дата);                                                     
			ОбновитьКешПоГруппировке(ТаблицаДанных, мНастройка, ОбработанныйТекст, ЗначениеХеш, КешСвертки, стр, ДатаГрупировки, "Год");
		КонецЕсли;
		// Месяц  
		Если мНастройка.ГруппировкаМесяц=Истина Тогда
			ДатаГрупировки = НачалоМесяца(стр.Дата);                                                     
			ОбновитьКешПоГруппировке(ТаблицаДанных, мНастройка, ОбработанныйТекст, ЗначениеХеш, КешСвертки, стр, ДатаГрупировки, "Месяц");
		КонецЕсли;
		// Неделя  
		Если мНастройка.ГруппировкаНеделя=Истина Тогда
			ДатаГрупировки = НачалоНедели(стр.Дата);                                                     
			ОбновитьКешПоГруппировке(ТаблицаДанных, мНастройка, ОбработанныйТекст, ЗначениеХеш, КешСвертки, стр, ДатаГрупировки, "Неделя");
		КонецЕсли;
		// День  
		Если мНастройка.ГруппировкаДень=Истина Тогда
			ДатаГрупировки = НачалоДня(стр.Дата);                                                     
			ОбновитьКешПоГруппировке(ТаблицаДанных, мНастройка, ОбработанныйТекст, ЗначениеХеш, КешСвертки, стр, ДатаГрупировки, "День");
		КонецЕсли;
		
	КонецЦикла; 
	
КонецПроцедуры

Функция ОбработатьТекст(Знач Текст,мНастройки)

	// удалить специ символы и цифры
	Текст = УбратьЛишниеСимволыИзСтроки(Текст,мНастройки.УдалятьСпецСимволы,мНастройки.УдалятьЦифры);
	
	Возврат Текст;
КонецФункции    

Функция УбратьЛишниеСимволыИзСтроки(Строка,УдалятьСпецСимволы=Истина,УдалятьЦифры=Истина) Экспорт
	
	Если УдалятьСпецСимволы=Ложь И УдалятьЦифры=Ложь Тогда
		Возврат Строка;
	КонецЕсли;
	
	РезультирующаяСтрока = "";
	Для н = 1 По СтрДлина(Строка) Цикл
		ДобавитьСимвол = Истина;   
		
		// УдалятьСпецСимволы
		Если УдалятьСпецСимволы=Истина
			И НЕ ((КодСимвола(Строка, н) >= 48 И КодСимвола(Строка, н) <= 57)
			ИЛИ (КодСимвола(Строка, н) >= 65 И КодСимвола(Строка, н) <= 90)
			ИЛИ (КодСимвола(Строка, н) >= 97 И КодСимвола(Строка, н) <= 122)
			ИЛИ (КодСимвола(Строка, н) >= 1040 И КодСимвола(Строка, н) <= 1103)) Тогда
			ДобавитьСимвол = Ложь;
		КонецЕсли; 
		
		// УдалятьЦифры
		Если УдалятьЦифры=Истина 
			И ( КодСимвола(Строка, н) >= 48 И КодСимвола(Строка, н) <= 57 ) Тогда
			ДобавитьСимвол = Ложь;
		КонецЕсли;
		
		Если ДобавитьСимвол=Истина Тогда	
			РезультирующаяСтрока = РезультирующаяСтрока + Сред(Строка, н, 1);
		КонецЕсли;
		
	КонецЦикла;
	Возврат РезультирующаяСтрока;
КонецФункции

Процедура ОбновитьКешПоГруппировке(ТаблицаДанных, мНастройка, ОбработанныйТекст, ЗначениеХеш, КешСвертки, Источник, ДатаГруппировки, ТипГруппировки="Нет")
	
	Перем Данные;
	
	Ключ = НРег(Строка(ЗначениеХеш)+"->"+ТипГруппировки+":"+ДатаГруппировки+" "+Источник.ЗначениеАналитика1+" "+Источник.ЗначениеАналитика2);
	Данные = КешСвертки.Получить(Ключ);
	Если Данные=Неопределено Тогда
		Данные = Новый Структура("КоличествоСовпадений,Хеш,Значение,ДатаПоследнейЗаписи,СобытиеЗамера",0,ЗначениеХеш,Источник.Значение,Источник.Дата,Источник.СобытиеЗамера);
		Данные.Вставить("ДатаГруппировки",ДатаГруппировки);
		Данные.Вставить("ТипГруппировки",ТипГруппировки);
		Данные.Вставить("ДлительностьМксМаксимум",Источник.ДлительностьМкс);
		Данные.Вставить("ДлительностьМксСумма",0);
		Данные.Вставить("Аналитика1",Источник.Аналитика1);
		Данные.Вставить("ЗначениеАналитика1",Источник.ЗначениеАналитика1);
		Данные.Вставить("Аналитика2",Источник.Аналитика2);
		Данные.Вставить("ЗначениеАналитика2",Источник.ЗначениеАналитика2);
		Данные.Вставить("ОбработанныйТекст",ОбработанныйТекст);
		Данные.Вставить("ДополнительноеСвойство",Источник.ДополнительноеСвойство);
		Данные.Вставить("ЗначениеДополнительноеСвойство",Источник.ЗначениеДополнительноеСвойство);
		КешСвертки.Вставить(Ключ,Данные);
	КонецЕсли;
	
	Данные.КоличествоСовпадений = Данные.КоличествоСовпадений+1;
	Данные.ДлительностьМксСумма = Данные.ДлительностьМксСумма+Источник.ДлительностьМкс;
	Если Данные.ДатаПоследнейЗаписи<=Источник.Дата И НЕ Данные.СобытиеЗамера = Источник.СобытиеЗамера Тогда
		Данные.ДатаПоследнейЗаписи = Источник.Дата;
		Данные.СобытиеЗамера = Источник.СобытиеЗамера;
	КонецЕсли;     
	Если Данные.ДлительностьМксМаксимум<Источник.ДлительностьМкс Тогда
		Данные.ДлительностьМксМаксимум=Источник.ДлительностьМкс;
	КонецЕсли;
	
	// доп свойство
	Если ЗначениеЗаполнено(мНастройка.ДополнительноеСвойство) Тогда
		Если мНастройка.ФункцияАгрегацииДополнительногоСвойства="Первое" Тогда
		ИначеЕсли мНастройка.ФункцияАгрегацииДополнительногоСвойства="Последнее" Тогда			
			Данные.Вставить("ЗначениеДополнительноеСвойство",Источник.ЗначениеДополнительноеСвойство);
		ИначеЕсли мНастройка.ФункцияАгрегацииДополнительногоСвойства="Максимум" Тогда			                            
			Если Источник.ЗначениеДополнительноеСвойство>Данные.ЗначениеДополнительноеСвойство Тогда
				Данные.Вставить("ЗначениеДополнительноеСвойство",Источник.ЗначениеДополнительноеСвойство);
			КонецЕсли;
		ИначеЕсли мНастройка.ФункцияАгрегацииДополнительногоСвойства="Минимум" Тогда			                            
			Если Источник.ЗначениеДополнительноеСвойство<Данные.ЗначениеДополнительноеСвойство Тогда
				Данные.Вставить("ЗначениеДополнительноеСвойство",Источник.ЗначениеДополнительноеСвойство);
			КонецЕсли;
		ИначеЕсли мНастройка.ФункцияАгрегацииДополнительногоСвойства="Слияние" Тогда			                            
			Данные.Вставить("ЗначениеДополнительноеСвойство",Строка(Данные.ЗначениеДополнительноеСвойство)+Символы.ПС+Строка(Источник.ЗначениеДополнительноеСвойство));
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьТаблицуРассчитанныхДанных(Замер,мНастройка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	КлючевыеСвойства.Ссылка КАК Ссылка,
	|	КлючевыеСвойства.Свойство.Наименование КАК ИмяСвойства,
	|	КлючевыеСвойства.Свойство КАК Свойство,
	|	КлючевыеСвойства.Значение КАК Значение,
	|	КлючевыеСвойства.ЗначениеЧисло КАК ЗначениеЧисло
	|ИЗ
	|	Справочник.СобытияЗамера.КлючевыеСвойства КАК КлючевыеСвойства
	|ГДЕ
	|	КлючевыеСвойства.Ссылка.Владелец = &Замер";
	Запрос.УстановитьПараметр("Замер",Замер);
	
	Возврат Запрос.Выполнить().Выгрузить();	
	
КонецФункции	

Функция ПолучитьДанныеНаСервере(мНастройки,ДатаНачалаЧтения) 
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1000
	|	СобытияЗамераКлючевыеСвойства.Ссылка КАК СобытиеЗамера,
	|	СобытияЗамераКлючевыеСвойства.Ссылка.Владелец КАК Замер,
	|	СобытияЗамераКлючевыеСвойства.Свойство КАК Свойство,
	|	СобытияЗамераКлючевыеСвойства.Значение КАК Значение,
	|	СобытияЗамераКлючевыеСвойства.ХешЗначения КАК Хеш,
	|	СобытияЗамераКлючевыеСвойства.Ссылка.ДатаСобытия КАК Дата,
	|	СобытияЗамераКлючевыеСвойства.Ссылка.ДлительностьМкс КАК ДлительностьМкс,
	|	&Аналитика1 КАК Аналитика1,
	|	НЕОПРЕДЕЛЕНО КАК ЗначениеАналитика1,
	|	&Аналитика2 КАК Аналитика2,
	|	НЕОПРЕДЕЛЕНО КАК ЗначениеАналитика2,
	|	&ДополнительноеСвойство КАК ДополнительноеСвойство,
	|	НЕОПРЕДЕЛЕНО КАК ЗначениеДополнительноеСвойство,
	|	"""" КАК ОбработанныйТекст
	|ИЗ
	|	Справочник.СобытияЗамера.КлючевыеСвойства КАК СобытияЗамераКлючевыеСвойства
	|ГДЕ
	|	СобытияЗамераКлючевыеСвойства.Ссылка.Владелец = &Замер
	|	И СобытияЗамераКлючевыеСвойства.Свойство = &Свойство
	|	И СобытияЗамераКлючевыеСвойства.Ссылка.ДатаСобытия > &ДатаНачалаЧтения
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	СобытияЗамераКлючевыеСвойства.Ссылка";
	Запрос.УстановитьПараметр("Замер",мНастройки.ЗамерИсточник);
	Запрос.УстановитьПараметр("Свойство",мНастройки.Свойство);
	Запрос.УстановитьПараметр("Аналитика1",мНастройки.Аналитика1);
	Запрос.УстановитьПараметр("Аналитика2",мНастройки.Аналитика2);
	Запрос.УстановитьПараметр("ДополнительноеСвойство",мНастройки.ДополнительноеСвойство);
	Запрос.УстановитьПараметр("ДатаНачалаЧтения",ДатаНачалаЧтения);
	
	Если мНастройки.РазмерПакета=0 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"ВЫБРАТЬ ПЕРВЫЕ 1000","ВЫБРАТЬ ");
	Иначе                                                                                                                   
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"ВЫБРАТЬ ПЕРВЫЕ 1000","ВЫБРАТЬ ПЕРВЫЕ "+XMLСтрока(мНастройки.РазмерПакета));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(мНастройки.Аналитика1) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"НЕОПРЕДЕЛЕНО КАК ЗначениеАналитика1,",
			"ЕстьNull(ЗнАн1.Значение,"""") КАК ЗначениеАналитика1,");
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"Справочник.СобытияЗамера.КлючевыеСвойства КАК СобытияЗамераКлючевыеСвойства",
		"Справочник.СобытияЗамера.КлючевыеСвойства КАК СобытияЗамераКлючевыеСвойства
		|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СобытияЗамера.КлючевыеСвойства КАК ЗнАн1
		|ПО ЗнАн1.Ссылка=СобытияЗамераКлючевыеСвойства.Ссылка
		| И ЗнАн1.Свойство=&Аналитика1"+Символы.ПС);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(мНастройки.Аналитика2) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"НЕОПРЕДЕЛЕНО КАК ЗначениеАналитика2,",
			"ЕстьNull(ЗнАн2.Значение,"""") КАК ЗначениеАналитика2,");
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"Справочник.СобытияЗамера.КлючевыеСвойства КАК СобытияЗамераКлючевыеСвойства",
		"Справочник.СобытияЗамера.КлючевыеСвойства КАК СобытияЗамераКлючевыеСвойства
		|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СобытияЗамера.КлючевыеСвойства КАК ЗнАн2
		|ПО ЗнАн2.Ссылка=СобытияЗамераКлючевыеСвойства.Ссылка
		| И ЗнАн2.Свойство=&Аналитика2"+Символы.ПС);
	КонецЕсли;      
	     
	Если ЗначениеЗаполнено(мНастройки.ДополнительноеСвойство) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"НЕОПРЕДЕЛЕНО КАК ЗначениеДополнительноеСвойство,",
			"ЕстьNull(ДопСв.Значение,"""") КАК ЗначениеДополнительноеСвойство,");
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"Справочник.СобытияЗамера.КлючевыеСвойства КАК СобытияЗамераКлючевыеСвойства",
		"Справочник.СобытияЗамера.КлючевыеСвойства КАК СобытияЗамераКлючевыеСвойства
		|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СобытияЗамера.КлючевыеСвойства КАК ДопСв
		|ПО ДопСв.Ссылка=СобытияЗамераКлючевыеСвойства.Ссылка
		| И ДопСв.Свойство=&ДополнительноеСвойство"+Символы.ПС);
	КонецЕсли;  
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции


#КонецОбласти
