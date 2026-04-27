#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn All, Off

;================================================================
;  Translit RU/DE — Russische Eingabe per deutscher Tastatur
;  Regeln nach translit.net (yo/jo/ö -> ё, shch -> щ usw.)
;
;  Umschalten:  Ctrl+Shift+Space   (oder Tray-Menü)
;  Tray-Icon zeigt Status (DE / RU)
;================================================================

global TranslitOn := false
global History := []   ; Eintrag: {latin, russian, ulen}

;---- Translit-Tabelle (Schluessel klein) ----
global TranslitMap := Map(
    "shch","щ",  "sch","щ",  "shh","щ",
    "yo","ё",    "jo","ё",
    "ya","я",    "ja","я",
    "yu","ю",    "ju","ю",
    "ye","э",    "je","э",   "eh","э",
    "zh","ж",
    "ch","ч",
    "sh","ш",
    "kh","х",
    "ts","ц",
    "''","ъ",    "##","ъ",
    "a","а", "b","б", "c","ц", "d","д", "e","е",
    "f","ф", "g","г", "h","х", "i","и", "j","й",
    "k","к", "l","л", "m","м", "n","н", "o","о",
    "p","п", "q","я", "r","р", "s","с", "t","т",
    "u","у", "v","в", "w","в", "x","х", "y","ы",
    "z","з",
    "'","ь", "#","ъ",
    "ö","ё", "ü","ю", "ä","я", "ß","щ"
)

;---- Tray ----
A_TrayMenu.Delete()
A_TrayMenu.Add("Translit umschalten (Ctrl+Shift+Space)", (*) => Toggle())
A_TrayMenu.Add()
A_TrayMenu.Add("Skript neu laden", (*) => Reload())
A_TrayMenu.Add("Beenden", (*) => ExitApp())
A_TrayMenu.Default := "Translit umschalten (Ctrl+Shift+Space)"
A_TrayMenu.ClickCount := 1

UpdateTray()

;---- Toggle-Hotkey (immer aktiv) ----
Hotkey("^+Space", (*) => Toggle())

;---- Translit-Hotkeys (nur wenn TranslitOn) ----
HotIf((*) => TranslitOn)

for letter in StrSplit("abcdefghijklmnopqrstuvwxyz", "") {
    Hotkey(letter,        HandleKey.Bind(letter, false))
    Hotkey("+" letter,    HandleKey.Bind(letter, true))
}

; deutsche Sondertasten via Scancode
Hotkey("SC028",  HandleKey.Bind("ä", false))   ; ä
Hotkey("+SC028", HandleKey.Bind("ä", true))    ; Ä
Hotkey("SC027",  HandleKey.Bind("ö", false))   ; ö
Hotkey("+SC027", HandleKey.Bind("ö", true))    ; Ö
Hotkey("SC01A",  HandleKey.Bind("ü", false))   ; ü
Hotkey("+SC01A", HandleKey.Bind("ü", true))    ; Ü
Hotkey("SC00C",  HandleKey.Bind("ß", false))   ; ß
Hotkey("SC02B",  HandleKeySpecial.Bind("#"))   ; #
Hotkey("+SC02B", HandleKeySpecial.Bind("'"))   ; '

; Backspace-Korrektur
Hotkey("BackSpace", HandleBackspace)

; Whitespace -> Historie zuruecksetzen, Taste durchreichen
Hotkey("~Space", ResetHistory)
Hotkey("~Enter", ResetHistory)
Hotkey("~Tab",   ResetHistory)
Hotkey("~Esc",   ResetHistory)

HotIf()  ; Kontext beenden

;================================================================
;  Handler
;================================================================

HandleKey(latin, shifted, *) {
    caps := GetKeyState("CapsLock", "T")
    upper := (shifted != caps)
    if (latin = "ß")          ; kein Grossbuchstabe fuer ß
        upper := false
    ProcessChar(latin, upper)
}

HandleKeySpecial(ch, *) {
    ProcessChar(ch, false)
}

ProcessChar(latin, upper) {
    global History, TranslitMap
    actualLatin := upper ? StrUpper(latin) : latin

    ; laengste Uebereinstimmung zuerst (4, 3, 2, 1)
    Loop 4 {
        matchLen   := 5 - A_Index
        prevNeeded := matchLen - 1

        accumLatin := ""
        sum := 0
        firstIdx := History.Length + 1
        entriesUsed := 0
        i := History.Length
        while (sum < prevNeeded && i >= 1) {
            sum += StrLen(History[i].latin)
            firstIdx := i
            entriesUsed++
            i--
        }
        if (sum != prevNeeded)
            continue

        Loop entriesUsed {
            accumLatin .= History[firstIdx + A_Index - 1].latin
        }
        accumLatin .= actualLatin

        keyLower := StrLower(accumLatin)
        if !TranslitMap.Has(keyLower)
            continue

        rusBase := TranslitMap[keyLower]
        firstChar := SubStr(accumLatin, 1, 1)
        firstUpper := (firstChar != StrLower(firstChar))
        rus := firstUpper ? StrUpper(rusBase) : rusBase

        bsCount := 0
        Loop entriesUsed {
            entry := History.Pop()
            bsCount += entry.ulen
        }
        if (bsCount > 0)
            Send("{BS " bsCount "}")
        SendText(rus)

        History.Push({latin: accumLatin, russian: rus, ulen: StrLen(rus)})
        ScheduleReset()
        return
    }

    ; Fallback (sollte nicht passieren — alle Buchstaben sind in der Map)
    SendText(actualLatin)
    History.Push({latin: actualLatin, russian: actualLatin, ulen: StrLen(actualLatin)})
    ScheduleReset()
}

HandleBackspace(*) {
    global History
    if (History.Length > 0) {
        last := History.Pop()
        Send("{BS " last.ulen "}")
    } else {
        Send("{BS}")
    }
}

ResetHistory(*) {
    global History
    History := []
}

ScheduleReset() {
    SetTimer(ResetHistory, -2000)   ; nach 2s Inaktivitaet zuruecksetzen
}

Toggle(*) {
    global TranslitOn, History
    TranslitOn := !TranslitOn
    History := []
    UpdateTray()
    msg := TranslitOn ? "RU translit AN" : "DE — translit AUS"
    ToolTip(msg, , , 7)
    SetTimer(() => ToolTip(, , , 7), -900)
}

UpdateTray() {
    global TranslitOn
    if TranslitOn {
        try TraySetIcon("shell32.dll", 14)
        A_IconTip := "Translit RU aktiv  (Ctrl+Shift+Space zum Umschalten)"
    } else {
        try TraySetIcon("shell32.dll", 175)
        A_IconTip := "Translit DE  (Ctrl+Shift+Space zum Umschalten)"
    }
}
