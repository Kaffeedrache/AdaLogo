--------------------------------------------------------------------
---- Autor: Wiltrud Kessler                                       --
---- Datum: 12.06.2006                                            --
---- Kurze Demonstration von AdaLogo-Befehlen, jeder Befehl kommt --
---- mindestens einmal vor. Es sind allerdings keine Eingaben vom --
---- Benutzer noetig. Es wird das Haus den Nikolaus gezeichnet.   --
--------------------------------------------------------------------

with Ada.Text_Io;
use Ada.Text_IO;

-- Das Package AdaLogo wie jedes andere Package einbinden.
with Adalogo;
use Adalogo;


procedure Nikolaus is

begin
   

   -- In AdaLogo gibt es spezifische Befehle, die nur
   -- in AdaLogo vorhanden sind. Diese werden hier
   -- kurz erlaeutert. Dieses Programm sollte Schritt
   -- fuer Schritt ausgefuehrt werden und fuer das
   -- eigene Verstaendnis abgeaendert werden.
   
   -- Am Anfang eines jeden Programmes muss Turtle_Reset
   -- stehen. Dieses setzt die AdaLogo-Schildkroete
   -- in die Mitte des Bildes mit der Nase waagerecht
   -- nach 0 Grad.
   Turtle_Reset;
   
   -- Mit Forward kann man vorwaerts laufen.
   -- Der Wert dahinter bestimmt wie weit gelaufen wird.
   Forward(100);

   -- Turn laesst die AdaLogo-Schildkroete sich drehen. 
   -- Die Angaben muessen in Grad erfolgen, die Schildkroete
   -- dreht sich dann im Gegenuhrzeigersinn.
   Turn(90);
   Forward(100);
   
   -- Mit Pen_Up nimmt man den Stift, mit dem man sonst zeichnet
   -- hoch, d.h. es ist nicht sichtbar, was gezeichnet wird.
   Pen_Up;
   Turn(90);
   Forward(100);
   Turn(90);
   
   -- Mit Pen_Down setzt man den Stift wieder auf das Blatt.
   Pen_Down;
   Forward(100);
   
   -- Mit Move_To(X,Y) springt man zu dem Punkt mit den 
   -- Koordinaten (X,Y). Es wird gleichzeitig gezeichnet.
   Move_To(0,100);
   Turn(135);
   
   -- Forward kann auch mit Float-Werten aufgerufen werden,
   -- es koennen sogar ganze Rechenoperationen dort stehen.
   -- Turn kann auch mit negativen Zahlen aufgerufen werden,
   -- die AdaLogo-Schildkroete dreht sich dann in die andere
   -- Richtung (also mit dem Uhrzeigersinn). Auch Float oder
   -- Rechenausdruecke sind fuer Turn erlaubt.
   Forward(70.71);
   Turn(-90.0);
   Forward(141.42 / 2.0);
   
   -- Mit Turn_To kann man sich in eine bestimmte Richtung 
   -- ausrichten, die AdaLogo-Schildkroete wird dann in 
   -- dieser Richtung weiterlaufen.
   Turn_To(180);
   Forward(100);
   Turn_To(-45);
   Forward(141.42);
   
   -- Auch Move_To und Turn_To koennen mit negativen Werten
   -- oder Float aufgerufen werden. Man darf aber (wie bei Ada
   -- ueblich) nicht mischen, also eine Integer- und eine
   -- Float-Koordinate angeben. Soll bei Move_To nicht
   -- gezeichnet werden, muss vorher der Stift vom Blatt
   -- genommen werden.
   Pen_Up;
   Move_To(-10.0,-5.5);
   Move_To(0,0);
   Pen_Down;
   Turn_To(45);
   Forward(141.42);
  
   -- Jedes AdaLogo-Programm muss mit dem Befehl Zeichne
   -- abgeschlossen werden, dieser Befehl sorgt dafuer, dass
   -- tatsaechlich gezeichnet wird. Wenn dieser Befehl vergessen
   -- wird, geschieht nichts sichtbares.
   Draw;

   -- Am Schluss zeigt ein kleiner Kreis mit einer Nase die
   -- aktuelle Position (und Ausrichtung) der Schilkroete an.

end Nikolaus;

