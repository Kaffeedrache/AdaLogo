------------------------------------------------------------------
-- Autor: Wiltrud Kessler                                       --
-- Datum: 21.06.2006                                            --
-- Dieses Programm erzeugt rekursiv einen Stapel von Boxen.     --
-- Jede Box ist halb so gross wie die Box unter ihr. Werden die --
-- Boxen zu klein um vernuenftig gezeichnet zu werden, wird die --
-- Rekursion abgebrochen.                                       --
------------------------------------------------------------------

with Ada.Text_Io, Ada.Integer_Text_Io;
use Ada.Text_Io, Ada.Integer_Text_Io;

with Adalogo;
use Adalogo;


procedure boxes is

   -- Zeichnet ein Viereck mit der angegebenen Hoehe
   -- und der doppelten Breite.
   -- Die Schildkroete befindet sich danach wieder in 
   -- der Ausgangsposition und -ausrichtung.
   procedure Viereck (Hoehe : Natural) is
   begin
      Forward(2 * Hoehe);
      Turn(90);
      Forward(Hoehe);
      Turn(90);
      Forward(2 * Hoehe);
      Turn(90);
      Forward(Hoehe);
      Turn(90);
   end Viereck;
   
   -- Stapelt Boxen aufeinander, bis sie zu klein werden.
   Procedure Boxen_Stapeln (Hoehe : Natural) is
   begin
      if Hoehe > 3 then
         -- Viereck dieser Groesse zeichnen
         Viereck(Hoehe);
         -- an obere Ecke des Vierecks gehen (unsichtbar)
         -- und dort Richtung zuruecksetzen
         Pen_Up;
         Turn(90);
         Forward(Hoehe);
         Turn(-90);
         Forward(Hoehe / 2);
         Pen_Down;
         -- Naechstkleinere Box zeichnen
         Boxen_Stapeln(Hoehe / 2);
      end if;
   end Boxen_Stapeln;     


   -- Anfangshoehe festlegen
   Hoehe : Natural := 200;
     
begin

   -- Schildkroete zuruecksetzen
   Turtle_Reset;

   -- Ein Stueck nach unten gehen, dass man auch was sieht
   Pen_Up;
   Move_To(-250,-250);
   Pen_Down;

   -- Ein paar Boxen aufeinanderstapeln
   Boxen_Stapeln(Hoehe);

   -- Endergebnis zeichnen
   Draw;

end boxes;
