# Translit RU/DE — Russische Eingabe per deutscher Tastatur

Schreibe russische Buchstaben mit deinem **deutschen Layout** —
Translit-Regeln (`jo`/`ö` → ё, `shh` → щ, `ä` → э, `ja` → я, …).
Umschalten per Hotkey, Tray-Icon zeigt den Status.

Anders als die Webseite läuft die Konvertierung **systemweit** in jedem
Programm (Browser, Word, Notepad, Discord, Spiele …), nicht nur in einem
Textfeld auf der Webseite.

## Beispiele

| Du tippst (DE-Tastatur)   | erscheint              |
|---------------------------|------------------------|
| `privet`                  | `привет`               |
| `Schastlivogo dnja`       | `Счастливого дня`      |
| `Joshkin kot` / `Jöshkin kot` | `Ёшкин кот`       |
| `borshh`                  | `борщ`                 |
| `pod#ezd`                 | `подъезд`              |
| `den'`                    | `день`                 |

## Funktionsweise

Längster Treffer gewinnt: tippst `s` → erscheint `с`. Tippst dann `h` →
`с` wird durch `ш` ersetzt. Tippst noch ein `h` → `ш` wird durch `щ`
ersetzt (`shh` → щ). Sequenzen werden während des Tippens automatisch
zu russischen Buchstaben zusammengezogen — inline beim Schreiben.

## Installation

### Variante A — fertiges Setup (empfohlen, keine Vorinstallation nötig)

1. `TranslitRU-Setup.exe` aus dem
   [Releases-Tab](https://github.com/atombyte/TranslitRU/releases/latest)
   herunterladen.
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

`TranslitRU.exe` aus dem
[Releases-Tab](https://github.com/atombyte/TranslitRU/releases/latest)
laden (kompiliertes Skript, keine AHK-Installation nötig). Einfach
kopieren und starten. Verknüpfung in `shell:startup` für Autostart.

## Selbst bauen

```bash
# .exe (standalone)
"%ProgramFiles%\AutoHotkey\Compiler\Ahk2Exe.exe" \
  /in TranslitRU.ahk /out TranslitRU.exe \
  /base "%ProgramFiles%\AutoHotkey\v2\AutoHotkey64.exe"

# Setup (selbstextrahierender Installer)
copy /Y TranslitRU.exe installer\
"%SystemRoot%\System32\iexpress.exe" /N /Q installer\TranslitRU-Setup.sed
```

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
ё  via   jo   ö
ж  via   zh
з → z   и → i   й → j     к → k   л → l
м → m   н → n   о → o   п → p   р → r
с → s   т → t   у → u   ф → f
х  via   h   x
ц  via   c
ч  via   ch
ш  via   sh
щ  via   shh
ъ  via   #
ы → y
ь  via   '
э  via   ä
ю  via   ju   ü
я  via   ja
```

Groß-/Kleinschreibung wird übernommen: `Ja` → `Я`, `JA` → `Я`, `Sh` → `Ш`.

### Konfliktauflösung

Längster Treffer gewinnt. Beispiel: tippst du `s`, erscheint sofort `с`.
Tippst du dann `h`, wird `с` durch `ш` ersetzt. Tippst du noch ein `h`,
wird `ш` durch `щ` ersetzt (`shh` → щ).

`j` allein → `й`, aber `ja/jo/ju` → я/ё/ю.

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
