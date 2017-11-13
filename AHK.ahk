#IfWinActive GTA:SA:MP
#IfWinActive ahk_group Game
#ErrorStdOut
#SingleInstance Force
GroupAdd, Game, GTA:SA:MP
GroupAdd, Game, MTA: San Andreas
GroupAdd, Game, Multi Theft Auto
GroupAdd, Game, GTA: San Andreas
#ErrorStdOut
#include SAMP.ahk



Utf8ToAnsi(ByRef Utf8String, CodePage = 1251)
{
    If (NumGet(Utf8String) & 0xFFFFFF) = 0xBFBBEF
        BOM = 3
    Else
        BOM = 0

    UniSize := DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
                    , "UInt", &Utf8String + BOM, "Int", -1
                    , "Int", 0, "Int", 0)
    VarSetCapacity(UniBuf, UniSize * 2)
    DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
                    , "UInt", &Utf8String + BOM, "Int", -1
                    , "UInt", &UniBuf, "Int", UniSize)

    AnsiSize := DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0
                    , "UInt", &UniBuf, "Int", -1
                    , "Int", 0, "Int", 0
                    , "Int", 0, "Int", 0)
    VarSetCapacity(AnsiString, AnsiSize)
    DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0
                    , "UInt", &UniBuf, "Int", -1
                    , "Str", AnsiString, "Int", AnsiSize
                    , "Int", 0, "Int", 0)
    Return AnsiString
}
WM_HELP(){
    IniRead, vupd, %a_temp%/verahk.ini, UPD, v
    IniRead, desupd, %a_temp%/verahk.ini, UPD, des
    desupd := Utf8ToAnsi(desupd)
    IniRead, updupd, %a_temp%/verahk.ini, UPD, upd
    updupd := Utf8ToAnsi(updupd)
    msgbox, , Список изменений версии %vupd%, %updupd%
    return
}

OnMessage(0x53, "WM_HELP")
Gui +OwnDialogs

SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nПроверяем наличие обновлений.
URLDownloadToFile, %downllen%, %a_temp%/verahk.ini
IniRead, buildupd, %a_temp%/verahk.ini, UPD, build
if buildupd =
{
    SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nОшибка. Нет связи с сервером.
    sleep, 2000
}
if buildupd > % buildscr
{
    IniRead, vupd, %a_temp%/verahk.ini, UPD, v
    SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nОбнаружено обновление до версии %vupd%!
    sleep, 2000
    IniRead, desupd, %a_temp%/verahk.ini, UPD, des
    desupd := Utf8ToAnsi(desupd)
    IniRead, updupd, %a_temp%/verahk.ini, UPD, upd
    updupd := Utf8ToAnsi(updupd)
    SplashTextoff
    msgbox, 16384, Обновление скрипта до версии %vupd%, %desupd%
    IfMsgBox OK
    {
        msgbox, 1, Обновление скрипта до версии %vupd%, Хотите ли Вы обновиться?
        IfMsgBox OK
        {
            put2 := % A_ScriptFullPath
            RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\SAMP ,put2 , % put2
            SplashTextOn, , 60,Автообновление, Обновление. Ожидайте..`nОбновляем скрипт до версии %vupd%!
            URLDownloadToFile, %downlurl%, %a_temp%/updt.exe
            sleep, 1000
            run, %a_temp%/updt.exe
            exitapp
        }
    }
}
SplashTextoff




DIR = OptionAHK
FileCreateDir, %DIR%

IfNotExist, %DIR%\*.ini
{
    SplashTextOn, , 60,AHK by FOX,Наберитесь терпения`nидёт установка нужных файлов...
    UrlDownloadToFile, https://www.dropbox.com/s/ue8derksy8hhefq/info.ini?dl=1, %DIR%\info.ini 
    UrlDownloadToFile, https://www.dropbox.com/s/xz6gounw8gmzyi8/blacklist.txt?dl=1, %DIR%\blacklist.txt
    SplashTextoff
}

;ini
IniRead, rang, OptionAHK/info.ini,INFO,rang
IniRead, grav, OptionAHK/info.ini,INFO,grav
IniRead, tag1, OptionAHK/info.ini,INFO,tag1
IniRead, tag2, OptionAHK/info.ini,INFO,tag2
IniRead, sex, OptionAHK/info.ini,INFO,sex
IniRead, army, OptionAHK/info.ini,INFO,army
IniRead, number, OptionAHK/info.ini,INFO,number
IniRead, drang, OptionAHK/info.ini,INFO,drang
IniRead, musurl, OptionAHK/info.ini,INFO,musurl

SetTimer, Chat, 100
EngineState := false
SetTimer, RPEngine, 500
SetTimer, RadioAD, 600000

RadioAD:
Random, randt, 1, 6
if (randt = 1) {
addChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Для настройки AHK используйте клавишу: {FF0000}F12")
}
if (randt = 2) {
addChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Незабывайте надевать бронижилет, нарушение реформы!")
}
if (randt = 3) {
addChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}195.000 патрон - запрещено брать норму ГРУ, даже офицеру")
}
if (randt = 4) {
addChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Незабывайте надевать бронижилет, нарушение реформы!")
}
return

RPEngine:
if (isPlayerDriver()) {
    if (getVehicleEngineState() == 1 and EngineState = false) {
	if sex = M
	{
        	SendChat("/me вставил ключ в замок зажигание и завел " getVehicleModelName())
        }
	if sex = F
	{
		SendChat("/me вставила ключ в замок зажигание и завела " getVehicleModelName())
	}
	EngineState := true
    }else if (getVehicleEngineState() == 0 and EngineState = true) {
	if sex = M
	{
        	SendChat("/me заглушил " getVehicleModelName() ", после вытащил ключи из замка зажигания")
        }
	if sex = F
	{
		SendChat("/me заглушила " getVehicleModelName() ", после вытащила ключи из замка зажигания")
	}
	EngineState := false
    }
}
Return


chat:
chat=%A_MyDocuments%/GTA San Andreas User Files/SAMP/chatlog.txt 
FileRead, chatlog, % chat 

if (RegExMatch(chatlog, "\]\s+Игрок не состоит в Вашей организации"))
{
	save(chatlog)
	addChatMessageEx("48D1CC", "{48D1CC}ВВС - AHK: {FFFFFF}Игрок не состоит в Вашей организации")
	reload
}
if (RegExMatch(chatlog, "\]\s+Нет входящих вызовов"))
{
	save(chatlog)
	addChatMessageEx("48D1CC", "{48D1CC}ВВС - AHK: {FFFFFF}Нет входящих вызовов")
	reload
}
if (RegExMatch(chatlog, "\]\s+Такого игрока нет"))
{
	save(chatlog)
	addChatMessageEx("48D1CC", "{48D1CC}ВВС - AHK: {FFFFFF}Такого игрока нет")
	reload
} 
if (RegExMatch(chatlog, "\]\s+Вы не обладаете достаточными полномочиями для увольнения игроков"))
{
	save(chatlog)
	addChatMessageEx("48D1CC", "{48D1CC}ВВС - AHK: {FFFFFF}Вы не обладаете достаточными полномочиями для увольнения игроков")
	reload
}
if (RegExMatch(chatlog, "\]\s+Вам недоступна данная функция"))
{
	save(chatlog)
	addChatMessageEx("48D1CC", "{48D1CC}ВВС - AHK: {FFFFFF}Вам недоступна данная функция")
	reload
}
if (RegExMatch(chatlog, "\]\s+Вы использовали аптечку. Здоровье пополнено на 60 единиц"))
{
	save(chatlog)
	if sex = M
	{
		RPName:=RegExReplace(getUsername(), "_", " ")
		SendChat("/do Аптечка в правом кармане в брюке у " RPName ".")
		SendChat("/me достал аптечку из правого кармана брюк, затем использовал её")
	}
	if sex = F
	{
		RPName:=RegExReplace(getUsername(), "_", " ")
		SendChat("/do Аптечка в правом кармане в брюке у " RPName ".")
		SendChat("/me достала аптечку из правого кармана брюк, затем использовала её")
	}
	reload
}
if (RegExMatch(chatlog, "\]\s+Вы надели маску. Чтобы её снять, введите {FFCD00}/end"))
{
	save(chatlog)
	if sex = M
	{
		RPName:=RegExReplace(getUsername(), "_", " ")
		SendChat("/do Маска в левом кармане в брюке у " RPName ".")
		SendChat("/me достал маску из левого кармана брюк, затем надел на лицо маску")
		SendChat("/do Маска на лице у " RPname ".")
	}
	if sex = F
	{
		RPName:=RegExReplace(getUsername(), "_", " ")
		SendChat("/do Маска в левом кармане в брюке у " RPName ".")
		SendChat("/me достала маску из левого кармана брюк, затем надела на лицо маску")
		SendChat("/do Маска на лице у " RPname ".")
	}
	reload
}
if (RegExMatch(chatlog, "\]\s+Телефон отключён"))
{
	save(chatlog)
	if sex = M
	{
		RPName:=RegExReplace(getUsername(), "_", " ")
		SendChat("/do Телефон в левом кармане брюк у " RPName ".")
		SendChat("/me достал телефон из левого кармана брюк, затем отключил его и убрал назад")
	}
	if sex = F
	{
		RPName:=RegExReplace(getUsername(), "_", " ")
		SendChat("/do Телефон в левом кармане брюк у " RPName ".")
		SendChat("/me достала телефон из левого кармана брюк, затем отключила его и убрала назад")
	}
	reload
}
if (RegExMatch(chatlog, "\]\s+Вы передали патроны игроку"))
{
	save(chatlog)
	if sex = M
	{
		RPname:=RegExReplace(getUsername(), "_", " ")
		SendChat("/do Рюкзак на спине у " RPname ".")
		SendChat("/me снял рюкзак и растегнул его, достал пачку патрон")
		SendChat("/me передал бойцу пачку патрон")
	}
	if sex = F
	{
		RPname:=RegExReplace(getUsername(), "_", " ")
		SendChat("/do Рюкзак на спине у " RPname ".")
		SendChat("/me сняла рюкзак и растегнула его, достала пачку патрон")
		SendChat("/me передала бойцу пачку патрон")
	}
	reload
}
if (RegExMatch(chatlog, "\]\s+Телефон включён"))
{
	save(chatlog)
	if sex = M
	{
		RPname:=RegExReplace(getUsername(), "_", " ")
		SendChat("/do Телефон в левом кармане брюк у " RPName ".")
		SendChat("/me достал телефон из левого кармана брюк, затем включил его и убрал назад")
	}
	if sex = F
	{
		RPname:=RegExReplace(getUsername(), "_", " ")
		SendChat("/do Телефон в левом кармане брюк у " RPName ".")
		SendChat("/me достала телефон из левого кармана брюк, затем включила его и убрала назад")
	}
	reload
}
return

:?:/hp0::
setHP(0)
return

;=============================================
; Обнуление переменной при нажатии ESC и F6
;=============================================
~ESC::
~F6::
menu:=0
return

;=============================================
; Кнопки вызова диалогов
;=============================================
F12::
sleep 1000
menu := 1
ShowDialog(4, "{48D1CC}Настройки {FFFFFF}| {FA8072}AHK", "{48D1CC}1 | {FFFFFF}Название Вашего ранга`n{48D1CC}2 | {FFFFFF}Название Вашей организации`n{48D1CC}3 | {FFFFFF}Должность в Вашей организации`n{48D1CC}4 | {FFFFFF}Рация Вашего подразделение (/r) [Тег]`n{48D1CC}5 | {FFFFFF}Рация всех подразделение (/f) [Тег]`n{48D1CC}6 | {FFFFFF}Ваш игровой пол`n{48D1CC}7 | {FFFFFF}Ваш игровой номер телефона`n{48D1CC}8 | {FFFFFF}Гравировка Ваших часов`n{006400}[ Проверить настройки AHK ]", "Закрыть")
return

~LButton::
Time := A_TickCount
while(isDialogOpen())
{
    if (A_TickCount - Time > 500)
    {
  Return
    }
}
if (menu == 1)
{	
    sleep 1000
    menu := 0
    line_num  := getDialogLineNumber()
    line_text  := getDialogLine(line_num)
    	if (line_num == 9)
	{
		sleep 1000
		RPname:=RegExReplace(getUsername(), "_", " ")
		pid:= getPlayerIdByName(getUsername())
		dout:=""
		dout .= "{FFFFFF}Ваш игровой ник: {48D1CC}" RPName " {FFFFFF}(ID: {48D1CC}" pid "{FFFFFF})`n"
		dout .= "{FFFFFF}Ранг: {48D1CC}" rang "`n"
		dout .= "{FFFFFF}Отыгровка включена на: {48D1CC}" sex "`n"
		dout .= "{FFFFFF}Тег - /r: {48D1CC}" tag1 "`n"
		dout .= "{FFFFFF}Тег - /f: {48D1CC}" tag2 "`n"
		dout .= "{FFFFFF}Гравирока для /time: {48D1CC}" grav "`n"
		dout .= "{FFFFFF}Номер - /uds: {48D1CC}" number "`n"
		dout .= "{FFFFFF}Должность - /uds: {48D1CC}" drang "`n"
		dout .= "{FFFFFF}Организация - /uds: {48D1CC}" army "`n"
		showDialog(0, "{48D1CC}Настройки AHK {FFFFFF}| {FA8072}AHK ", dout "", "{FFF300}ОК")
	}
	if (line_num == 1)
	{
		sleep 1000
		showDialog("1", "{48D1CC}ВВС - AHK: {FFFFFF}Название ранга", "{FFFFFF}Введите ниже Ваше название ранга`nСейчас сохранено: {48D1CC}" rang "{FFFFFF} (Если пусто, не настроили)`nЧтобы принять текст, нажмите клавишу: ENTER", "Закрыть")
		input, rang, V, {enter}
		if Rang =
		{
		goto ERRORCODE
		}
		IniWrite, %rang%, info.ini, INFO, rang
		addChatMessageEx("48D1CC","{48D1CC}ВВС - AHK: {FFFFFF}Название ранга: {48D1CC}" rang " {FFFFFF}| Выполнено: {FF8989}[Удачно]")
	}
	if (line_num == 2)
	{
		sleep 1000
		showDialog("1", "{48D1CC}ВВС - AHK: {FFFFFF}Название Вашей организации", "{FFFFFF}Введите ниже Вашей название организации`nСейчас сохранено: {48D1CC}" army "{FFFFFF} (Если пусто, не настроили)`nЧтобы принять текст, нажмите клавишу: ENTER", "Закрыть")
		input, army, V, {enter}
		if army =
		{
		goto ERRORCODE
		}
		IniWrite, %army%, info.ini, INFO, army
		addChatMessageEx("48D1CC","ВВС - AHK: {FFFFFF}Название Вашей организации: {48D1CC}" army " {FFFFFF}| Выполнено: {FF8989}[Удачно]")
	}
	if (line_num == 3)
	{
		sleep 1000
		showDialog("1", "{48D1CC}ВВС - AHK: {FFFFFF}Должность в Вашей организации", "{FFFFFF}Введите ниже Вашу должность в организации`nСейчас сохранено: {48D1CC}" drang "{FFFFFF} (Если пусто, не настроили)`nЧтобы принять текст, нажмите клавишу: ENTER", "Закрыть")
		input, drang, V, {enter}
		if drang =
		{
		goto ERRORCODE
		}
		IniWrite, %drang%, info.ini, INFO, drang
		addChatMessageEx("48D1CC","ВВС - AHK: {FFFFFF}Должность в Вашей организации: {48D1CC}" drang " {FFFFFF}| Выполнено: {FF8989}[Удачно]")
	}
	if (line_num == 4)
	{
		sleep 1000
		showDialog("1", "{48D1CC}ВВС - AHK: {FFFFFF}Рация Вашего подразделение (/r)", "{FFFFFF}Введите ниже тег в рацию /r`nСейчас сохранено: {48D1CC}" tag1 "{FFFFFF} (Если пусто, не настроили)`nЧтобы принять текст, нажмите клавишу: ENTER`nПример текста: [S.E.A.L/Кобра]", "Закрыть")
		input, tag1, V, {enter}
		if tag1 =
		{
		goto ERRORCODE
		}
		IniWrite, %tag1%, info.ini, INFO, tag1
		addChatMessageEx("48D1CC","ВВС - AHK: {FFFFFF}Рация Вашего подразделение (/r): {48D1CC}" tag1 " {FFFFFF}| Выполнено: {FF8989}[Удачно]")
	}
	if (line_num == 5)
	{
		sleep 1000
		showDialog("1", "{48D1CC}ВВС - AHK: {FFFFFF}Рация Вашего подразделение (/f)", "{FFFFFF}Введите ниже тег в рацию /f`nСейчас сохранено: {48D1CC}" tag2 "{FFFFFF} (Если пусто, не настроили)`nЧтобы принять текст, нажмите клавишу: ENTER`nПример текста: [ВМФ | S.E.A.L/Кобра]", "Закрыть")
		input, tag2, V, {enter}
		if tag2 =
		{
		goto ERRORCODE
		}
		IniWrite, %tag2%, info.ini, INFO, tag2
		addChatMessageEx("48D1CC","ВВС - AHK: {FFFFFF}Рация Вашего подразделение (/f): {48D1CC}" tag2 " {FFFFFF}| Выполнено: {FF8989}[Удачно]")
	}
	if (line_num == 6)
	{
		sleep 1000
		showDialog("1", "{48D1CC}ВВС - AHK: {FFFFFF}Ваш игровой пол", "{FFFFFF}Выберите Ваш игровой пол: F - Женский , M - Мужской`nСейчас сохранено: {48D1CC}" sex "{FFFFFF} (Если пусто, не настроили)`nЧтобы принять текст, нажмите клавишу: ENTER", "Закрыть")
		input, sex, V, {enter}
		if sex =
		{
		goto ERRORCODE
		}
		IniWrite, %sex%, info.ini, INFO, sex
		addChatMessageEx("48D1CC","ВВС - AHK: {FFFFFF}Ваш игровой пол: {48D1CC}" sex " {FFFFFF}| Выполнено: {FF8989}[Удачно]")
	}
	if (line_num == 7)
	{
		sleep 1000
		showDialog("1", "{48D1CC}ВВС - AHK: {FFFFFF}Ваш игровой номер телефона", "{FFFFFF}Введите ниже Ваш игровой номер телефона`nСейчас сохранено: {48D1CC}" number "{FFFFFF} (Если пусто, не настроили)`nЧтобы принять текст, нажмите клавишу: ENTER", "Закрыть")
		input, number, V, {enter}
		if number =
		{
		goto ERRORCODE
		}
		IniWrite, %number%, info.ini, INFO, number
		addChatMessageEx("48D1CC","ВВС - AHK: {FFFFFF}Ваш игровой номер телефона: {48D1CC}" number " {FFFFFF}| Выполнено: {FF8989}[Удачно]")
	}
	if (line_num == 8)
	{
		sleep 1000
		showDialog("1", "{48D1CC}ВВС - AHK: {FFFFFF}Гравировка Ваших часов", "{FFFFFF}Введите ниже гравировку Ваших часов`nСейчас сохранено: {48D1CC}" grav "{FFFFFF} (Если пусто, не настроили)`nЧтобы принять текст, нажмите клавишу: ENTER", "Закрыть")
		input, grav, V, {enter}
		if grav =
		{
		goto ERRORCODE
		}
		IniWrite, %grav%, info.ini, INFO, grav
		addChatMessageEx("48D1CC","ВВС - AHK: {FFFFFF}Гравировка Ваших часов: {48D1CC}" grav " {FFFFFF}| Выполнено: {FF8989}[Удачно]")
	}
    return
}
return


ERRORCODE:
sleep 1000
addChatMessageEx("48D1CC","ВВС - AHK: {FFFFFF}Вы ничего не ввели! Ошибка #1 {FFFFFF}| Выполнено: {800000}[Не удачно] ")
reload


RButton & 1::
id := getIdByPed(getTargetPed())
RPN := RegExReplace(GetPlayerNameByid(id), "_", " ")
if sex = M
{
	SendChat("Здравия желаю, товарищ " RPN)
	SendChat("/me выполнил воинское привествие")
	SendChat("/anim 58")
	sleep 1000
	SendChat(")")
}
if sex = F
{
	SendChat("Здравия желаю, товарищ " RPN)
	SendChat("/me выполнила воинское привествие")
	SendChat("/anim 58")
	sleep 1000
	SendChat(")")
}
return
    RButton & 2::
    {
        suid:= getIdByPed(getTargetPed())
        if(suid!=-1)
        {
            if(getDist(GetCoordinates(),getPedCoordinates(getPedById(suid)))<23)
            {
                Wordesss := getPlayerNameById(suid)
                FileRead, Str, blacklist.txt
                StringReplace, Str, Str, `r`n, `n, 1
                StringReplace, Str, Str, `r, `n, 1
                SendChat("Отлично, теперь я проверю Вас на ЧС МО.")
                sleep 1000
		if sex = M
		{
                	SendChat("/me достал КПК-" army " из кармана и включил его")
                	sleep 1000
                	SendChat("/me зашёл на портал штата - Chocolate State")
                	sleep 1000
                	SendChat("/me смотрит раздел [Чёрный список Министерства Обороны]")
		}
		if sex = F
		{
                	SendChat("/me достала КПК-" army " из кармана и включила его")
                	sleep 1000
                	SendChat("/me зашла на портал штата - Chocolate State")
                	sleep 1000
                	SendChat("/me смотрит раздел [Чёрный список Министерства Обороны]")
		}
                if Str not contains `n%Wordesss%`n
                {
                    SendChat("/history " Wordesss)
                AddchatmessageEx("48D1CC","ВВС - AHK: {FFD700}[BlackList] {48D1CC}Не нажимайте esc. Пока не выдаст информацию.")
                    sleep 3000
                    Wordesdwa =
                    Wordesdwa := getdialogtext()
                Wordesdwa := RegexReplace(Wordesdwa, "^{FFFFFF}")
                    FileDelete, blacklistcode.txt
                    FileAppend,%Wordesdwa%`n,blacklistcode.txt
                    FileRead, Stroka, blacklistcode.txt
                    FileDelete, blacklistcode.txt
                    StringReplace, Wordesdwa, Wordesdwa, `n, `n, UseErrorLevel
                    loop, %ErrorLevel%
                    {
                        RegExMatch(Stroka, "^(.*)`r`n", hister)
                        if Str contains `n%hister1%`n
                        {
                        AddchatmessageEx("48D1CC","ВВС - AHK: {FFD700}[BlackList] {48D1CC}" Wordesss " состоит в чёрном списке. Под ником: " hister1)
				hister11 := RegExReplace(hister1, "_", " ")
                            SendChat("/do Человек " hister11 " есть в Чёрном списке Министерства Обороны.")
                            sleep 1000
                            SendChat("Простите, Вы нам не подходите, Вы в Чёрном списке Министерства Обороны.")
                            sleep 1000
			    if sex = M
			    {
                            	SendChat("/me выключил КПК-" army " и убрал его в карман.")
                            }
			    if sex = F
			    {
                            	SendChat("/me выключила КПК-" army " и убрала его в карман.")
                            }
                            return
                        }
                        Stroka := RegexReplace(Stroka, "^.*`r`n")
                    }
                AddchatmessageEx("48D1CC","ВВС - AHK: {FFD700}[BlackList] {48D1CC}" Wordesss " не состоит в чёрном списке.") 
			hister4 := RegExReplace(Wordesss, "_", " ")
                    SendChat("/do Человека " hister4 " нет в Чёрном списке Министерства Обороны.")
                    sleep 1000
		    if sex = M
		    {
                    	SendChat("/me выключил КПК-" army " и убрал его в карман.")
		    }
		    if sex = F
		    {
                    	SendChat("/me выключила КПК-" army " и убрала его в карман.")		
		    }
                    sleep 1000
                    SendChat("Отлично, Вас нет в чёрном списке Министерства Обороны.")
                }
                else
                {
                AddchatmessageEx("48D1CC","ВВС - AHK: {FFD700}[BlackList] {48D1CC}" Wordesss " состоит в чёрном списке.")
                    sleep 1000
			hister5 := RegExReplace(Wordesss, "_", " ")
                    SendChat("/do Человек " hister5 " есть в чёрном списке Министерства Обороны.")
                    sleep 1000
                    SendChat("Простите, Вы нам не подходите, вы в Чёрном списке Министерства Обороны.")
                    sleep 1000
		    if sex = M
		    {
                    	SendChat("/me выключил КПК-" army " и убрал его в карман.")
		    }
		    if sex = F
		    {
                    	SendChat("/me выключила КПК-" army " и убрала его в карман.")		
		    }
                }
            }
            else
            {
            addChatMessageEx("48D1CC","ВВС - AHK: {FFD700}[BlackList] {48D1CC}Вы не видите ник игрока, подойдите ближе!")
            }
        }
        else
        {
        AddchatmessageEx("48D1CC","ВВС - AHK: {FFD700}[BlackList] {48D1CC}Не найден id игрока!")
        }
    }
    return

F4::
KeyWait, Enter
SendChat("/p")
sleep 1000
RPname:=RegExReplace(getUsername(), "_", " ")
SendChat("Вы позвонили - " RPName ", но в данный момент я не могу ответить Вам.")
SendChat("Перезвоните пожалуйста мне позже, спасибо за внимание.")
SendChat("/h")
return

F3::
KeyWait, Enter
m = 60
m -= %A_Min%
hour:=getServerHour()
sleep 300
if sex = M
{
	SendChat("/me посмотрел на часы с гравировкой " grav)
	SendChat("/do (Время: " hour ":" A_Min ":" A_Sec ") | До зарплаты осталось ровно (" m " мин)")
	sleep 699
	SendChat("/c 060")
}
if sex = F
{
	SendChat("/me посмотрела на часы с гравировкой " grav)
	SendChat("/do (Время: " hour ":" A_Min ":" A_Sec ") | До зарплаты осталось ровно (" m " мин)")
	sleep 699
	SendChat("/c 060")
}
return

$~Enter:: 
sleep, 30 
if (isInChat() = 0) or (isDialogOpen() = 1) 
return 
sleep 150 
dwAddress := dwSAMP + 0x12D8F8 
chatInput := readString(hGTA, dwAddress, 256)
if (RegExMatch(chatInput, "^/myhelp"))
{
sleep 1000
RPname:=RegExReplace(getUsername(), "_", " ")
dout:=""
dout .= "{48D1CC}/rr {A9A9A9}[Сообщение]{FFFFFF} - IC рация для своей волны /r`n"
dout .= "{48D1CC}/ff {A9A9A9}[Сообщение]{FFFFFF} - IC рация для общей волны /f`n"
dout .= "{48D1CC}/rb {A9A9A9}[Сообщение]{FFFFFF} - ООС рация для своей волны /r`n"
dout .= "{48D1CC}/fb {A9A9A9}[Сообщение]{FFFFFF} - ООС рация для общей волны /f`n"
dout .= "{48D1CC}/hist {A9A9A9}[ID]{FFFFFF} - узнать историю ников игрока`n"
dout .= "{48D1CC}/met {A9A9A9}[Кол-во]{FFFFFF} - взять металл`n"
dout .= "{48D1CC}/автомат {A9A9A9}[Код]{FFFFFF} - сборка/разборка автомата`n"
dout .= "{48D1CC}/relahk{FFFFFF} - перезагрузить скрипт`n"
dout .= "{48D1CC}(F3){FFFFFF} - рп часы`n"
dout .= "{48D1CC}/uds{FFFFFF} - рп удостоверение`n"
dout .= "{48D1CC}/dk {A9A9A9}[Пост КПП(A)] [Состояние]{FFFFFF} - дежурство на КИТе`n"
dout .= "{48D1CC}/bd {A9A9A9}[Пункт] [Состояние]{FFFFFF} - объезд баз и территорий МО`n"
dout .= "{48D1CC}/nabor{FFFFFF} - узнать команды призыва`n"
dout .= "{48D1CC}/blist{FFFFFF} - список пунктов доклада /bd`n"
dout .= "{48D1CC}/цуп{FFFFFF} - команды ЦУП диспетчер`n"
dout .= "{4BD1CC}ПКМ + 1{FFFFFF} - здравия желаю`n"
dout .= "{4BD1CC}ПКМ + 2{FFFFFF} - проверить игрока на ЧС МО`n"
dout .= "{48D1CC}/fvig {A9A9A9}[ID] [Причина]{FFFFFF} - выдать наряд бойцу"
showDialog(0, "{48D1CC}Команды AutoHotKey by Fox {FFFFFF}| {FA8072}AHK ", dout, "Закрыть")
}
if (RegExMatch(chatInput, "^/nabor"))
{
RPname:=RegExReplace(getUsername(), "_", " ")
sleep 1000
dout2:=""
dout2 .= "{48D1CC}/pz1 {FFFFFF}- Представиться, попросить документы`n"
dout2 .= "{48D1CC}/pz2 {FFFFFF}- По рп взять документы и проверить их`n"
dout2 .= "{48D1CC}/pz3 {FFFFFF}- Рандомные вопросы`n"
dout2 .= "{48D1CC}/pz4 {FFFFFF}- Проверка РП терминов`n"
showDialog(0, "{48D1CC}Команды призыва {FFFFFF}| {FA8072}AHK ", dout2, "Закрыть")
}
if (RegExMatch(chatInput, "^/цуп"))
{
RPname:=RegExReplace(getUsername(), "_", " ")
sleep 1000
dout2:=""
dout2 .= "{48D1CC}/dv1 {FFFFFF}| Начать дежурство в ЦУПе`n"
dout2 .= "{48D1CC}/dv2 {FFFFFF}| Закончить дежурство в ЦУПе`n"
dout2 .= "{48D1CC}/dv3 {FFFFFF}| Продолжаю дежурство в ЦУПе`n"
dout2 .= "{48D1CC}/pilot {FFFFFF}| Разрешение взлёт/посадка`n"
dout2 .= "{48D1CC}/lec {FFFFFF}| [1 - Лекция] [2 - Лекция]`n"
showDialog(0, "{48D1CC}ЦУП команды {FFFFFF}| {FA8072}AHK ", dout2, "Закрыть")
}
if (RegExMatch(chatInput, "^/blist"))
{
RPname:=RegExReplace(getUsername(), "_", " ")
sleep 1000
dout3:=""
dout3 .= "{A9A9A9}1 {FFFFFF}- Начало`n"
dout3 .= "{A9A9A9}2 {FFFFFF}- ВВС`n"
dout3 .= "{A9A9A9}3 {FFFFFF}- Гора ВВС`n"
dout3 .= "{A9A9A9}4 {FFFFFF}- СВ`n"
dout3 .= "{A9A9A9}5 {FFFFFF}- 24/7 у СВ`n"
dout3 .= "{A9A9A9}6 {FFFFFF}- ВМФ`n"
dout3 .= "{A9A9A9}7 {FFFFFF}- КИТ`n"
dout3 .= "{A9A9A9}8 {FFFFFF}- Закончить"
showDialog(0, "{48D1CC}Пункты доклада {FFFFFF}| {FA8072}AHK ", dout3, "Закрыть")
}
if (RegExMatch(chatInput, "^/rr"))
{
	if (RegExMatch(chatInput, "/rr (.*)", out))
	{
		if sex = M
		{
			RPname:=RegExReplace(getUsername(), "_", " ")
			SendChat("/do Рация на поясе у " RPname ".")
			sleep 1000
			SendChat("/me снял рацию с пояса, затем нажал [R] и сказал что-то в неё:")
			SendChat("/r " tag1 " " out1)
			sleep 1000
			SendChat("/me отжал [R] и повесил рацию на пояс")
		}
		if sex = F
		{
			RPname:=RegExReplace(getUsername(), "_", " ")
			SendChat("/do Рация на поясе у " RPname ".")
			sleep 1000
			SendChat("/me сняла рацию с пояса, затем нажала [R] и сказала что-то в неё:")
			SendChat("/r " tag1 " " out1)
			sleep 1000
			SendChat("/me отжала [R] и повесила рацию на пояс")
		}
	}
	else
	{
		AddChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Команда: {48D1CC}/rr [Сообщение]{FFFFFF} - IC рация для своей волны /r")
                return
	}
}
if (RegExMatch(chatInput, "^/ff"))
{
	if (RegExMatch(chatInput, "/ff (.*)", out))
	{
		if sex = M
		{
			RPname:=RegExReplace(getUsername(), "_", " ")
			SendChat("/do Рация на поясе у " RPname ".")
			sleep 1000
			SendChat("/me снял рацию с пояса, затем нажал [F] и сказал что-то в неё:")
			SendChat("/f " tag2 " " out1)
			sleep 1000
			SendChat("/me отжал [F] и повесил рацию на пояс")
		}
		if sex = F
		{
			RPname:=RegExReplace(getUsername(), "_", " ")
			SendChat("/do Рация на поясе у " RPname ".")
			sleep 1000
			SendChat("/me сняла рацию с пояса, затем нажала [F] и сказала что-то в неё:")
			SendChat("/f " tag2 " " out1)
			sleep 1000
			SendChat("/me отжала [F] и повесила рацию на пояс")
		}
	} 
	else
	{
		AddChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Команда: {48D1CC}/ff [Сообщение]{FFFFFF} - IC рация для общей волны /f")
                return
	}
}
if (RegExMatch(chatInput, "^/met"))
{ 
	if (RegExMatch(chatInput, "/met (.*)", out))
	{
		RPname:=RegExReplace(getUsername(), "_", " ")
		if sex = M
		{
			SendChat("/do Рюкзак на спине у " RPName ".")
			SendChat("/me снял рюкзак и растегнул его, закинул " out1 " кг металла")
			SendChat("/takem " out1)
			sleep 1000
			SendChat("/me застегнул рюкзак, затем повесил за спину")
		}
		if sex = F
		{
			SendChat("/do Рюкзак на спине у " RPName ".")
			SendChat("/me снял рюкзак и растегнул его, закинула " out1 " кг металла")
			SendChat("/takem " out1)
			sleep 1000
			SendChat("/me застегнула рюкзак, затем повесила за спину")
		}
	}
	else
	{
		AddChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Команда: {48D1CC}/met [Кол-во]{FFFFFF} - взять металл")
                return
	}
}
if (RegExMatch(chatInput, "^/sc"))
{ 
	AddChatMessageEx("48D1CC", "ВВС - AHK: {A9A9A9}АвтоСкрин - пожалуйста не нажимайте {FF6666}ESC {A9A9A9}или {FF6666}F6")
	sleep 1000
	SendChat("/c 060")
	AddChatMessageEx("48D1CC", "ВВС - AHK: {A9A9A9}АвтоСкрин - {FF3333}сделан!")
	sleep 1000
	Send {F8}
}
if (RegExMatch(chatInput, "^/rahk"))
{
	save(chatlog)
	addChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Перезагрузка скрипта..")
	addChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Ожидайте 5 секунд!")
	sleep 5000
	addChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Перезагрузка готова!")
	reload
}
if (RegExMatch(chatInput, "^/dk"))
{
	if (RegExMatch(chatInput, "/dk (.*) (.*)", out))
	{
		RPname:=RegExReplace(getUsername(), "_", " ")
		pid:= getPlayerIdByName(getUsername())
		SendChat("/f " tag2 " Задание: Охрана Авианосца | Пост: " out1 " | Состояние: " out2)
		SendChat("/pass " pid)
	}
	else 
	{
		AddChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Команда: {48D1CC}/dk [Пост КПП(A)] [Состояние]{FFFFFF} - Дежурство на КИТе")
		return
	}
}
if (RegExMatch(chatInput, "^/автомат"))
{
	if (RegExMatch(chatInput, "/автомат (.*)", out))
	{
		if (out1 == 1)
		{
			if sex = M
			{
				RPN:=RegExReplace(getUsername(), "_", " ")
				SendChat("/me отделил магазин")
				sleep 1000
				SendChat("/me вынул пенал принадлежности из гнезда приклада")
				sleep 1000
				SendChat("/me отделил шомпол")
				sleep 1000
				SendChat("/me отделил крышку ствольной коробки")
				sleep 1000
				SendChat("/me отделил возвратный механизм")
				sleep 1000
				SendChat("/me отделил затворную раму с затвором")
				sleep 1000
				SendChat("/me отделил затвор от затворной рамы")
				sleep 1000
				SendChat("/me отделил газовую трубку со ствольной накладкой")
				SendChat(rang " " RPN " закончил разборку автомата!")
				sleep 1000
				SendChat(")")
			}
			if sex = F
			{
				RPN:=RegExReplace(getUsername(), "_", " ")
				SendChat("/me отделила магазин")
				sleep 1000
				SendChat("/me вынула пенал принадлежности из гнезда приклада")
				sleep 1000
				SendChat("/me отделила шомпол")
				sleep 1000
				SendChat("/me отделила крышку ствольной коробки")
				sleep 1000
				SendChat("/me отделила возвратный механизм")
				sleep 1000
				SendChat("/me отделила затворную раму с затвором")
				sleep 2500
				SendChat("/me отделила затвор от затворной рамы")
				sleep 1000
				SendChat("/me отделила газовую трубку со ствольной накладкой")
				SendChat(rang " " RPN " закончила разборку автомата!")
				sleep 1000
				SendChat(")")
			}
		}
		if (out1 == 2)
		{
			if sex = M
			{
				RPN:=RegExReplace(getUsername(), "_", " ")
				SendChat("/me взял макет автомата, приступил к сборке автомата")
				sleep 1000
				SendChat("/me присоединил газовую трубку со ствольной накладкой")
				sleep 1000
				SendChat("/me присоединил затвор к затворной рам")
				sleep 1000
				SendChat("/me присоединил затворную раму с затвором к ствольной коробки")
				sleep 1000
				SendChat("/me присоединил возвратный механизм")
				sleep 1000
				SendChat("/me присоединил крышку ствольной коробки")
				sleep 1000
				SendChat("/me спустил курок с боевого взвода и поставил на предохранитель")
				sleep 1000
				SendChat("/me присоединил шомпол")
				sleep 1000
				SendChat("/me вложил пенал в гнездо приклада")
				sleep 1000
				SendChat("/me закончил сборку автомата")
				SendChat(rang " " RPN " закончил сборку автомата!")
				sleep 1000
				SendChat(")")
			}
			if sex = F
			{
				RPN:=RegExReplace(getUsername(), "_", " ")
				SendChat("/me взяла макет автомата, приступила к сборке автомата")
				sleep 1000
				SendChat("/me присоединила газовую трубку со ствольной накладкой")
				sleep 1000
				SendChat("/me присоединила затвор к затворной рам")
				sleep 1000
				SendChat("/me присоединила затворную раму с затвором к ствольной коробки")
				sleep 1000
				SendChat("/me присоединила возвратный механизм")
				sleep 1000
				SendChat("/me присоединила крышку ствольной коробки")
				sleep 1000
				SendChat("/me спустила курок с боевого взвода и поставила на предохранитель")
				sleep 1000
				SendChat("/me присоединила шомпол")
				sleep 1000
				SendChat("/me вложила пенал в гнездо приклада")
				sleep 1000
				SendChat("/me закончила сборку автомата")
				SendChat(rang " " RPN " закончила сборку автомата!")
				sleep 1000
				SendChat(")")
			}
		}
	}
	else 
	{
		AddChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Команда: {48D1CC}/автомат [Код]")
		AddChatMessageEx("48D1CC", "ВВС - AHK: {A9A9A9}1 {FFFFFF} - Разобрать | {A9A9A9}2 {FFFFFF}- Собрать")
		return
	}
}
if (RegExMatch(chatInput, "^/bd"))
{
	if (RegExMatch(chatInput, "/bd ([0-9]{0,3}) (.*)", out))
	{
		if (out1 == 1)
		{
			pid:= getPlayerIdByName(getUsername())
			SendChat("/f " tag2 " Задача: Воздушный патруль | Состав: " out2 " | Состояние: Начали патруль.")
			SendChat("/pass " pid)
		}
		if (out1 == 2)
		{
			pid:= getPlayerIdByName(getUsername())
			SendChat("/f " tag2 " Задача: Воздушный патруль | База: Военно-Воздушные Силы | Состояние: " out2)
			SendChat("/pass " pid)
		}
		if (out1 == 3)
		{
			pid:= getPlayerIdByName(getUsername())
			SendChat("/f " tag2 " Задача: Воздушный патруль | База: Гора у Военно-Воздушных Сил | Состояние: " out2)
			SendChat("/pass " pid)
		}
		if (out1 == 4)
		{
			pid:= getPlayerIdByName(getUsername())
			SendChat("/f " tag2 " Задача: Воздушный патруль | База: Сухопутные Войска | Состояние: " out2)
			SendChat("/pass " pid)
		}
		if (out1 == 5)
		{
			pid:= getPlayerIdByName(getUsername())
			SendChat("/f " tag2 " Задача: Воздушный патруль | База: 24/7 у Сухопутных Войск | Состояние: " out2)
			SendChat("/pass " pid)
		}
		if (out1 == 6)
		{
			pid:= getPlayerIdByName(getUsername())
			SendChat("/f " tag2 " Задача: Воздушный патруль | База: Военно-Морской Флот | Состояние: " out2)
			SendChat("/pass " pid)
		}
		if (out1 == 7)
		{
			pid:= getPlayerIdByName(getUsername())
			SendChat("/f " tag2 " Задача: Воздушный патруль | База: КИТ | Состояние: " out2)
			SendChat("/pass " pid)
		}
		if (out1 == 8)
		{
			pid:= getPlayerIdByName(getUsername())
			SendChat("/f " tag2 " Задача: Воздушный патруль | Состав: " out2 " | Состояние: Закончили патруль.")
			SendChat("/pass " pid)
		}
	}
	else 
	{
		AddChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Команда: {48D1CC}/bd [Код] [Состояние]")
		AddChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Команда: {48D1CC}/bd 1 [Кол-во] {A9A9A9}| {48D1CC}8 [Кол-во]")
		AddChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Список всех пунктов доклада: {48D1CC}/plist")
		return
	}
}
if (RegExMatch(chatInput, "^/hist"))
{
	if (RegExMatch(chatInput, "/hist ([0-9]{0,3})", out))
	{
		Nick:=GetPlayerNameByid(out1)
		SendChat("/history " Nick)
	}
	else
	{
		AddChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Команда: {48D1CC}/hist [ID]{FFFFFF} - узнать историю ников игрока")
                return
	}
}
if (RegExMatch(chatInput, "^/rb"))
{
	if (RegExMatch(chatInput, "/rb (.*)", out))
	{
		SendChat("/r (( " out1 " ))")
	}
	else
	{
		AddChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Команда: {48D1CC}/rb [Сообщение]{FFFFFF} - ООС рация для своей волны /r")
                return
	}
}
if (RegExMatch(chatInput, "^/fb"))
{
	if (RegExMatch(chatInput, "/fb (.*)", out))
	{
		SendChat("/f (( " out1 " ))")
	}
	else
	{
		AddChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Команда: {48D1CC}/fb [Сообщение]{FFFFFF} - ООС рация для общей волны /f")
                return
	}
}
if (RegExMatch(chatInput, "^/find"))
{
	SendChat("/find")
	Loop
	{
		if(isDialogOpen()==1)
		break
	} 
	text:=getDialogText()
	RegExMatch(text, "Из них онлайн:\s+([0-9]+)", online)
	if sex = M
	{
		SendChat("/me достал из кармана КПК-" army)
		SendChat("/do Сотрудников " army " в штате сейчас > [" online1 "]")
	}
	if sex = F
	{
		SendChat("/me досталa из кармана КПК-" army)
		SendChat("/do Сотрудников " army " в штате сейчас > [" online1 "]")
	}
}
if (RegExMatch(chatInput, "^/sos"))
{
	zona:=getPlayerZone()
	city:=getPlayerCity()
	if(city == "Неизвестно")
	{
		addChatMessageEx("48D1CC","{48D1CC}ВВС - AHK: {FFFFFF}Вы в городе: {48D1CC}Unknow {FFFFFF}| В районе: {48D1CC}" zona)
		SendChat("/r " tag1 " Требуется эвакуация, мое местонахождение " zona)
	}
	if(zona == "Неизвестно")
	{
		addChatMessageEx("48D1CC","{48D1CC}ВВС - AHK: {FFFFFF}Вы в городе: {48D1CC}" city " {FFFFFF}| В районе: {48D1CC}Unknow")
		SendChat("/r " tag1 " Требуется эвакуация, мое местонахождение " city)
	}
	if(zona == "Неизвестно" && city == "Неизвестно")
	{
		addChatMessageEx("48D1CC","{48D1CC}ВВС - AHK: {FFFFFF}Вы в городе: {48D1CC}Unknow {FFFFFF}| В районе: {48D1CC}Unknow")
	}
	else
	{
		addChatMessageEx("48D1CC","{48D1CC}ВВС - AHK: {FFFFFF}Вы в городе: {48D1CC}" city " {FFFFFF}| В районе: {48D1CC}" zona)
		SendChat("/r " tag1 " Требуется эвакуация, мое местонахождение " city " " zona)
	}
}
if (RegExMatch(chatInput, "^/pz1"))
{
	pid:= getPlayerIdByName(getUsername())
	RPN:=RegExReplace(getUsername(), "_", " ")
	SendChat("Здравия желаю. Я солдат " army)
	SendChat("Я, " rang " " RPN ".")
	sleep 1000
	SendChat("Предьявите пожалуйста, Ваш паспорт, пакет лицензии и повестку")
	SendChat("/n /pass " pid " | /lic " pid " | /me показал(а) повестку")
	}
if (RegExMatch(chatInput, "^/pz2"))
{
	if sex = M
	{
	SendChat("/me взял повестку из рук человека на против")
	SendChat("/anim 21")
	sleep 1000
	SendChat("/me изучает поветску, затем положил на стол")
	sleep 1000
	SendChat("/me взял из рук призывника пасопрт и изучает его")
	Sleep 1000
	SendChat("Всё хорошо, теперь несколько вопросов.")
	}
	if sex = F
	{
	SendChat("/me взяла повестку из рук человека на против")
	SendChat("/anim 21")
	sleep 1000
	SendChat("/me изучает поветску, затем положила на стол")
	sleep 1000
	SendChat("/me взяла из рук призывника пасопрт и изучает его")
	Sleep 1000
	SendChat("Всё хорошо, теперь несколько вопросов.")
	}
}
if (RegExMatch(chatInput, "^/pz3"))
{
	Random, randt, 1, 9
	if (randt = 1) 
	{
		SendChat("Что такое по Вашему ТК?")
	}
	if (randt = 2) 
	{
		SendChat("Что такое по Вашему МГ?")
	}
	if (randt = 3) 
	{
		SendChat("Что такое по Вашему РП?")
	}
	if (randt = 4) 
	{
		SendChat("Что такое по Вашему ДБ?")
	}
	if (randt = 5) 
	{
		SendChat("Что у меня в руке?")
	}
	if (randt = 6) 
	{
		SendChat("Что у меня над головой?")
	}
	if (randt = 7) 
	{
		SendChat("Как меня зовут?")
	}
	if (randt = 8) 
	{
		SendChat("Сколько Вы раз умирали?")
	}
	if (randt = 9) 
	{
		SendChat("Сколько Вы лет в штате?")
	}
}
if (RegExMatch(chatInput, "^/pz4"))
{
	Random, randt, 1, 3
	if (randt = 1) 
	{
		SendChat("/n /sms " number " DM MG")
	}
	if (randt = 2) 
	{
		SendChat("/n /sms " number " DB RP")
	}
	if (randt = 3) 
	{
		SendChat("/n /sms " number " PG TK")
	}
}
if (RegExMatch(chatInput, "^/uds"))
{
	RPname:=RegExReplace(getUsername(), "_", " ")
	pid:= getPlayerIdByName(getUsername())
	if sex = M
	{
	SendChat("/me достал из внутреннего кармана формы удостверение №" pid)
	Sleep 1000
	SendChat("/do — Имя и Фамилия: " RPname " | Номер телефона: " number)
	SendChat("/do — Сотрудник: " army " | Звание сотрудника: " rang)
	SendChat("/do — Должность сотрудника " army ": " drang)
	Sleep 1000
	SendChat("/me убрал удостверение во внутренний карман формы")
	}
	if sex = F
	{
	SendChat("/me достала из внутреннего кармана формы удостверение №" pid)
	Sleep 1000
	SendChat("/do — Имя и Фамилия: " RPname " | Номер телефона: " number)
	SendChat("/do — Сотрудница: " army " | Звание сотрудницы: " rang)
	SendChat("/do — Должность сотрудницы " army ": " drang)
	Sleep 1000
	SendChat("/me убрала удостверение во внутренний карман формы")
	}
}
if (RegExMatch(chatInput, "^/dv1"))
{
	RPname:=RegExReplace(getUsername(), "_", " ")
	pid:= getPlayerIdByName(getUsername())
	if sex = M
	{
	SendChat("/anim 57")
	sleep 1000
	SendChat("/do Устройство связи на столе отключено.")
	sleep 1000
	SendChat("/do На устройство подается питание.")
	sleep 1000
	SendChat("/me нажал на кнопку включения передатчика")
	sleep 1000
	SendChat("/do Передатчик включен.")
	sleep 1000
	SendChat("/do На передатчике лежат накладные наушники.")
	sleep 1000
	SendChat("/me надел наушники на голову")
	SendChat("/r " tag1 " " rang " " RPname " заступил на дежурство в ЦУПе.")
	}
	if sex = F
	{
	SendChat("/anim 57")
	sleep 1000
	SendChat("/do Устройство связи на столе отключено.")
	sleep 1000
	SendChat("/do На устройство подается питание.")
	sleep 1000
	SendChat("/me нажала на кнопку включения передатчика")
	sleep 1000
	SendChat("/do Передатчик включен.")
	sleep 1000
	SendChat("/do На передатчике лежат накладные наушники.")
	sleep 1000
	SendChat("/me надела наушники на голову")
	SendChat("/r " tag1 " " rang " " RPname " заступила на дежурство в ЦУПе.")
	}
}
if (RegExMatch(chatInput, "^/dv2"))
{
	RPname:=RegExReplace(getUsername(), "_", " ")
	pid:= getPlayerIdByName(getUsername())
	if sex = M
	{
	SendChat("/do Передатчик включен.")
	sleep 1000
	SendChat("/me снял наушники с головы и положил их перед собой")
	sleep 1000
	SendChat("/me нажал на кнопку выключения передатчика")
	sleep 1000
	SendChat("/do Передатчик отключился.")
	sleep 1000
	SendChat("/r " tag1 " " rang " " RPname " дежурство в ЦУПе окончил.")
	}
	if sex = F
	{
	SendChat("/do Передатчик включен.")
	sleep 1000
	SendChat("/me сняла наушники с головы и положила их перед собой")
	sleep 1000
	SendChat("/me нажала на кнопку выключения передатчика")
	sleep 1000
	SendChat("/do Передатчик отключился.")
	sleep 1000
	SendChat("/r " tag1 " " rang " " RPname " дежурство в ЦУПе окончила.")
	}
}
if (RegExMatch(chatInput, "^/pilot"))
{
	if (RegExMatch(chatInput, "/pilot ([0-9]{0,3})", out))
	{
		RPname:=RegExReplace(getUsername(), "_", " ")
		pid:= getPlayerIdByName(getUsername())
		if (out1 == 1)
		{
			if sex = M
			{
				SendChat("/me нажал на кнопку [Связь]")
				sleep 1000
				SendChat("Взлет разрешаю")
				sleep 1000
				SendChat("/me убрал палец с кнопки [Связь]")
			}
			if sex = F
			{
				SendChat("/me нажала на кнопку [Связь]")
				sleep 1000
				SendChat("Взлет разрешаю")
				sleep 1000
				SendChat("/me убрала палец с кнопки [Связь]")
			}
		}
		if (out1 == 2)
		{
			if sex = M
			{
				SendChat("/me нажал на кнопку [Связь]")
				sleep 1000
				SendChat("Посадку разрешаю")
				sleep 1000
				SendChat("/me убрал палец с кнопки [Связь]")
			}
			if sex = F
			{
				SendChat("/me нажала на кнопку [Связь]")
				sleep 1000
				SendChat("Посадку разрешаю")
				sleep 1000
				SendChat("/me убрала палец с кнопки [Связь]")
			}
		}
	}
	else
	{
		AddChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Команда: {48D1CC}/pilot [1 - Разрешить взлёт] [2 - Разрешить посадку]")
                return
	}
}
if (RegExMatch(chatInput, "^/dv3"))
{
	RPname:=RegExReplace(getUsername(), "_", " ")
	pid:= getPlayerIdByName(getUsername())
	SendChat("/r " tag1 " " rang " " RPname " продолжаю нести дежурство в ЦУПе.")
}
if (RegExMatch(chatInput, "^/gt"))
{
	if sex = M
	{	
		SendChat("/me сунул руку в карман, после нажал на кнопку (Close/Open)")
		SendChat("/gate")
	}
	if sex = F
	{
		SendChat("/me сунула руку в карман, после нажала на кнопку (Close/Open)")
		SendChat("/gate")
	}
}
if (RegExMatch(chatInput, "^/lec"))
{
	if (RegExMatch(chatInput, "/lec ([0-9]{0,3})", out))
	{
		RPname:=RegExReplace(getUsername(), "_", " ")
		pid:= getPlayerIdByName(getUsername())
		if (out1 == 1)
		{
			SendChat("/r " tag1 " Пилоты, слушаем внимательно!")
			sleep 3000
			SendChat("/r " tag1 " Прежде чем взлететь, либо приземлиться, вы обязаны запросить разрешение.")
			sleep 3000
			SendChat("/r " tag1 " Форма: Запрашиваю разрешение на взлет/посадку. Курс: КИТ. ТС: Шамал.")
			sleep 3000
			SendChat("/r (( Разрешение запрашивать в обычный чат, сидя на месте пилота за штурвалом ))")
			sleep 3000
			SendChat("/r " tag1 " Кто будет взлетать без запроса - предупреждение, затем увольнение.")
			sleep 1000
			addChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Конец: {FF0000}/sc")
		}
		if (out1 == 2)
		{
			SendChat("/r " tag1 " Пилоты, слушаем внимательно!")
			sleep 3000
			SendChat("/r " tag1 " При посадке на КИТ на любом летательном средстве.")
			sleep 3000
			SendChat("/r " tag1 " Разрешено использовать только ВПП корабля.")
			sleep 3000
			SendChat("/r " tag1 " Любой пилот, нарушивший это правило сразу получает наряд.")
			sleep 1000
			addChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Конец: {FF0000}/sc")
		}
	}
	else
	{
		AddChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Команда: {48D1CC}/lec [1 - Лекция] [2 - Лекция]")
                return
	}
}
if (RegExMatch(chatInput, "^/fvig"))
{
	if (RegExMatch(chatInput, "/fvig ([0-9]{0,3}) (.*)", out))
	{
		RPN := RegExReplace(GetPlayerNameByid(out1), "_", " ")
		{
			SendChat("/r " tag1 " " RPN ", получает наряд. Причина: " out2)
		}
	}
	else
	{
		AddChatMessageEx("48D1CC", "ВВС - AHK: {FFFFFF}Команда: {48D1CC}/fvig [ID] [Причина]")
                return
	}
}
return