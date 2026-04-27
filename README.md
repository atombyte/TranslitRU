# Translit RU/DE — Russische Eingabe per deutscher Tastatur

Schreibe russische Buchstaben mit deinem **deutschen Layout** — Regeln wie
auf <https://translit.net/> (`yo`/`jo`/`ö` → ё, `shch`/`shh` → щ,
`je`/`ye`/`ä` → э, `ja`/`ya` → я, …). Umschalten per Hotkey, Tray-Icon
zeigt den Status.

Anders als die Webseite läuft die Konvertierung **systemweit** in jedem
Programm (Browser, Word, Notepad, Discord, Spiele …), nicht nur in einem
Textfeld auf der Webseite.

## Beispiele

| Du tippst (DE-Tastatur)   | erscheint              |
|---------------------------|------------------------|
| `privet`                  | `привет`               |
| `Schastlivogo dnja`       | `Счастливого дня`      |
| `Joschkin kot` / `Jöschkin kot` | `Ёшкин кот`     |
| `borsch` / `borshh`       | `борщ`                 |
| `obyzvat'` / `ob##yzvat#` | `объызвать` / `обьызвать` (mit ##/' usw.) |

## Funktionsweise

Längster Treffer gewinnt: tippst `s` → erscheint `с`. Tippst dann `h` →
`с` wird durch `ш` ersetzt. Tippst dann `ch` → `ш ц` wird durch `щ`
ersetzt (`shch` → щ). Sequenzen werden während des Tippens automatisch
zu russischen Buchstaben zusammengezogen — wie auf translit.net, aber
inline beim Schreiben statt nach Klick auf "Konvertieren".

## Installation

### Variante A — fertiges Setup (empfohlen, keine Vorinstallation nötig)

1. `TranslitRU-Setup.exe` auf Zielrechner kopieren.
2. Doppelklick → Bestätigen → fertig.
3. Skript läuft sofort, Autostart aktiv, Tray-Icon erscheint.

Das Setup installiert nach `%LOCALAPPDATA%\TranslitRU\`, legt Start-Menü-
und Autostart-Verknüpfungen an. Deinstallation: Start-Menü → "TranslitRU
deinstallieren".

### Variante B — Skript ohne Setup

1. **AutoHotkey v2** installieren: <https://www.autohotkey.com/>.
2. Doppelklick auf `TranslitRU.ahk`. Tray-Icon erscheint.
3. Autostart optional: Verknüpfung in `shell:startup` (Win+R).

### Variante C — standalone .exe ohne Installer

`TranslitRU.exe` (kompiliertes Skript, keine AHK-Installation nötig)
einfach kopieren und starten. Verknüpfung in `shell:startup` für
Autostart.

## Bedienung

| Aktion                     | Tastenkombination          |
|----------------------------|----------------------------|
| RU/DE umschalten           | **Ctrl + Shift + Space**   |
| Status / Beenden / Reload  | Klick auf Tray-Icon        |

Beim Umschalten kurzer Tooltip (`RU translit AN` / `DE — translit AUS`).
Tray-Icon ändert sich.

## Translit-Regeln (Auswahl)

```
a → а   b → б   v/w → в   g → г   d → д   e → е
ё  via   yo   jo   ö
ж  via   zh
з → з   и → i   й → j     к → k   л → l
м → m   н → n   о → o   п → p   р → r
с → s   т → t   у → u   ф → f
х  via   h   x   kh
ц  via   c   ts
ч  via   ch
ш  via   sh
щ  via   shh   shch   sch   ß
ъ  via   #    ##    ''
ы → y
ь  via   '
э  via   je   ye   eh   ä
ю  via   yu   ju   ü
я  via   ya   ja   q
```

Groß-/Kleinschreibung wird übernommen: `Ya` → `Я`, `YA` → `Я`, `Sh` → `Ш`.

### Konfliktauflösung

Längster Treffer gewinnt. Beispiel: tippst du `s`, erscheint sofort `с`.
Tippst du dann `h`, wird `с` durch `ш` ersetzt. Tippst du danach `ch`,
wird `ш` + `ц` durch `щ` ersetzt (`shch` → щ).

`y` allein → `ы`, aber `ya/ye/yo/yu` → я/э/ё/ю.

## Anpassen

Tabelle in `TranslitRU.ahk` oben (`TranslitMap := Map(...)`). Nach
Änderung: Rechtsklick Tray-Icon → **Skript neu laden**.

Toggle-Hotkey ändern: Zeile `Hotkey("^+Space", ...)` —
`^` = Ctrl, `+` = Shift, `!` = Alt, `#` = Win.
Beispiel: `"!+Space"` für Alt+Shift+Space.

## Hinweise

- Funktioniert in jedem Programm, das Unicode-Eingabe per `SendInput`
  akzeptiert (Browser, Word, Notepad, Discord, …).
- Mehrzeichen-Sequenzen sind mit reinem Windows-Tastaturlayout
  (MSKLC/`.klc`) **nicht** möglich — daher AutoHotkey.
- Konflikt mit Windows-Layout-Wechsel (Alt+Shift): wenn du nur **eine**
  Windows-Tastatur konfiguriert hast, ist Alt+Shift frei und du kannst
  den Toggle-Hotkey im Skript darauf ändern.
