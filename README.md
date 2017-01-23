# AdaLogo

AdaLogo ist ein Package für Ada, mit dem man eine ''Schildkröte'' auf einer Zeichenfläche laufen lassen kann. Man kann so Ergebnisse von Programmen quasi grafisch darstellen.

Softwarepraktikum 2005/2006. Keine Garantien!


## 1. Installation von AdaLogo

### Windows
Mindestens GNAT 3.15 muss installiert sein. 

Installation von GTK-Ada für Windows:

1. Datei `gtkada-2.4.0.exe` von https://libre2.adacore.com/GtkAda/ herunterladen (man muss sich dazu leider registrieren), man bekommt diese Version wenn man `2005` und `Windows` wählt.
Achtung! GtkAda 2.8 läuft noch nicht zuverlässig unter Windows, daher GtkAda 2.4.0 herunterladen.
2. Datei `gtkada-2.4.0.exe` aufrufen und die Dateien nach GtkAda-2.4.0. entpacken.
3. Die Installationsanweisung (für Linux) öffnet sich, wie dort steht in Eingabeaufforderung (Start - Ausführen - dort `cmd` eintippen) eintragen (`<prefix>` steht fuer den Pfad, wo GtkAda installiert wurde): 
    
       cd <prefix> 
       gnatmake -Pinclude/gtkada/gtkada 
       
4.  Warten bis es fertig compiliert. Je nach Computer kann das dauern... 
5. Einstellungen - Systemsteuerung - System - Erweitert - Umgebungsvariablen.
6. Bei ''Systemvariablen'' unter ''Path'' `C:\GtkAda-2.4.0\bin` hinzufügen (; am Schluss nicht vergessen).
7. Neu starten.
8. Die AdaLogo-Dateien nach `C:\GtkAda-2.4.0\include\adalogo` entpacken.
9. Die AdaLogo-Dateien mit der `build.bat` compilieren, indem man in der Eingabeaufforderung mit `cd` in dieses Verzeichnis wechselt und `build` eintippt. Eventuell muss der Pfad angepasst werden. 
10. Nun können AdaLogo-Programme nach den Anleitungen unten compiliert und ausgeführt werden.


### Linux
Mindestens GNAT 3.15 muss installiert sein. 

Installation von GTK-Ada für Linux: 
1. Packete für Gtklib und Gtk+ herunterladen von http://www.gtk.org, compilieren und installieren.
2. `PATH`-Variable anpassen.
3. GtkAda von https://libre2.adacore.com/GtkAda/ herunterladen.
4. In der Konsole eingeben:

       ./configure 
       make install
       
    Der Installationsort kann mit `--prefix` verändert werden.
5. Auf einem der drei folgenden Wege den Pfad setzen:
      * `ldconfig` ausführen, falls du GtkAda am Standard-Ort installiert hast und Super-user bist.
      * Datei `/etc/ld.conf` editieren, wenn du Super-user bist, hier den Pfad, der `libgtkada` enthält, ändern.
      * Als einfacher User zur Umgebungsvariable `LD_LIBRARY_PATH` den Pfad zu `libgtkada` hinzufügen.
6. Die AdaLogo-Dateien nach `<prefix>include/adalogo` entpacken.
7. Die AdaLogo-Dateien compilieren.
8. Nun können AdaLogo-Programme nach den Anleitungen unten compiliert und ausgeführt werden.


## 2. Compilieren mit AdaLogo

### Konsole
Um mit AdaLogo compilieren zu können, muss man angeben, wo die Packete von GtkAda und AdaLogo zu finden sind. Dann bindet man sie (beide) mit der Compileroption `-I` ein. 

Bsp: 
Unter Windows: GtkAda in `C:\/GtkAda-2.4.0` installiert, die AdaLogo Packete wurden nach `C:/GtkAda-2.4.0/include/adalogo` kopiert. Wir wollen die Datei `nikolaus.adb` compilieren (zwischen -IC:... und -IC:... muss ein Leerzeichen stehen!):

    gnatmake -IC:/GtkAda-2.4.0/include/gtkada -IC:/GtkAda-2.4.0/include/adalogo nikolaus -largs -mwindows

Unter Linux: 

    gnatmake -Ipath/to/adalogo `gtkada-config` nikolaus.adb

### AdaGide
Um aus dem AdaGide mit AdaLogo compilieren zu können, muss man auch dort angeben, wo die Packete von GtkAda und AdaLogo zu finden sind. Dazu trägt man unter ''Tools - Project settings in current directory'' auf der Registerkarte ''Debug settings'' folgendes ein: 
* unter ''Compiler options'' : den Pfad zu Gktada sowie zu AdaLogo. 
Bsp: `-IC:/GtkAda-2.4.0/include/gtkada -IC:/GtkAda-2.4.0/include/adalogo `
* unter ''Gnatmake'' : `-largs -mwindows `

Diese Optionen werden im Verzeichnis des Programms in einer Datei `gnat.ago` gespeichert, so dass man in Zukunft einfach diese Datei in jedes Verzeichnis kopieren kann, in dem ein AdaLogo-Programm liegt.

### Debugging mit `Put` und `Get`
Leider sperrt GtkAda die Konsole, daher sind **keine Put und Get-Anweisungen** in einem AdaLogo-Programm möglich. Sind solche Anweisungen vorhanden, öffnet sich das grafische Fenster einfach gar nicht.



## 3. Befehle in AdaLogo

AdaLogo ist ein Package für Ada, mit dem man eine ''Schildkröte'' auf einer Zeichenfläche laufen lassen kann. Man kann so Ergebnisse von Programmen quasi grafisch darstellen.

AdaLogo wird wie jedes andere Package in Ada mit with und use am Anfang der Datei eingebunden:

    with Adalogo;
    use Adalogo;

AdaLogo enthält eine Reihe eigener Befehle zur Steuerung der Schildkröte, die hier kurz erläutert sind. Es empfiehlt sich auch die Beispieleprogramme einmal auszuprobieren.


### `Turtle_Reset`
Am Anfang eines jeden AdaLogo-Programmes muss `Turtle_Reset` stehen. Dieses setzt die AdaLogo-Schildkröte in den Urzustand zurück. Die Schildkröte steht dann in die Mitte der Zeichenfläche (Koordinaten 0/0) mit der Nase waagerecht rechts (Winkel 0 Grad). 
Bsp:

    Turtle_Reset;


### `Forward(Strecke)`
Mit `Forward` kann man vorwärts laufen, dabei bestimmt der übergebene Wert wie weit gelaufen wird. `Forward` kann auch mit Float-Werten oder negativen Zahlen aufgerufen werden, es können sogar ganze Rechenoperationen dort stehen. Bei negativer Strecke geht die Schildkröte rückwärts. 
Bsp:

    Forward(100);
    Forward(3.1415);
    Forward(- 68.23 / 9.3);


### `Turn(Winkel)`
`Turn` lässt die AdaLogo-Schildkröte sich drehen. Die Angaben müssen in Grad erfolgen, die Schildkröte dreht sich dann im Gegenuhrzeigersinn. Auch `Turn` kann mit Float-Werten, negativen Zahlen und Rechenausdrücken aufgerufen werden. Bei negativen Werten dreht sich die Schildkröte in die andere Richtung (also im Uhrzeigersinn). Es können auch Werte größer als 360 Grad angegeben werden, die Schildkröte dreht sich dann eben mehrmals im Kreis.
Bsp:

    Turn(-890);
    Turn(1.23);
    Turn(160 / 57);


### `Turn_To(Winkel)`
Mit `Turn_To` kann man die Schildkröte in eine bestimmte Richtung drehen. Die Schildkröte läuft dann in dieser Richtung weiter. Dabei ist 0 Grad waagerecht nach rechts, 90 Grad nach oben, usw. Auch `Turn_To` kann mit Float, negativen Zahlen, Zahlen über 360 und komplizierten Rechnungen aufgerufen werden.
Bsp:

    Turn_To(65);
    Turn(79.04);
    Turn(1 + 1);

### `Pen_Up`
Mit `Pen_Up` nimmt man den Stift, mit dem man sonst zeichnet hoch, d.h. es ist nicht sichtbar, was gezeichnet wird. 
Bsp:

    Pen_Up;
    Forward(100); -- es ist nichts sichtbar

### `Pen_Down`
Mit `Pen_Down` setzt man den Stift wieder auf das Blatt, es wird wieder sichtbar gezeichnet. 
Bsp:

    Pen_Up;
    Forward(100);   -- nicht sichtbar
    Pen_Down;
    Forward(40.2);  -- sichtbar

### `Move_To(X,Y)`
Mit `Move_To(X,Y)` springt man zu dem Punkt mit den Koordinaten (X,Y). Es wird im Normalfall gleichzeitig gezeichnet. Auch `Move_To` kann mit Float, negativen Zahlen und Rechenausdrücken aufgerufen werden. Man darf aber (wie bei Ada üblich) nicht Integer und Float mischen, also eine Integer- und eine Float-Koordinate angeben. Soll bei `Move_To` nicht gezeichnet werden, muss vorher der Stift vom Blatt genommen werden.
Bsp:

    Move_To(100,50);      -- sichtbar
    Pen_Up;
    Move_To(30.5,20.1);   -- nicht sichtbar
    -- Move_To(1, 0.123); -- hier wuerde der Compiler einen Fehler bringen

### `Draw`
Jedes AdaLogo-Programm muss mit dem Befehl `Draw` abgeschlossen werden, dieser Befehl sorgt dafür, dass tatsächlich gezeichnet wird. Wenn dieser Befehl vergessen wird, geschieht nichts sichtbares.
Bsp:

    Draw;
