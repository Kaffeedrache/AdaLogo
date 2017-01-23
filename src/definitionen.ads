------------------------------------------------------------------------------
-- Wiltrud Kessler, Softwarepraktikum  2005/2006                            --
------------------------------------------------------------------------------
-- Defininitionen, die von den Packages 'Queues', 'Adalogo' und             --
-- 'Adalogo_gtk' verwendet werden.                                          --
------------------------------------------------------------------------------


package Definitionen is


   ---------------------------------------------------------------------------
   -- Exception AdaLogo_Fehler                                              --
   ---------------------------------------------------------------------------
   -- Wird geworfen, wenn irgendwo etwas geparst wird / worden ist, das     --
   -- keine gueltige Aktion ist oder kein gueltiger Uebergabe-Parameter.    --
   ---------------------------------------------------------------------------
   Adalogo_Fehler : exception;


   ---------------------------------------------------------------------------
   -- Typendeklarationen                                                    --
   ---------------------------------------------------------------------------
   -- * Typ Bewegung
   -- Welcher Befehl aufgerufen wurde und ausgefuehrt werden soll
   -- Undef ist der Typ wenn etwas schiefgeht beim Parsen, tritt das im
   -- Programm auf, so wird Adalogo_Fehler geworfen.
   type Bewegung is (Turn, Turn_To, Forward, Pen_Up, Pen_Down, Move_To, 
      Reset, Undef);
      
   -- * Typ Wastun
   -- Art des Befehls und Werte
   -- Wert ist definiert bei Turn, Turn_To, Forward
   -- X_Koord, Y_Koord sind definiert bei Move_To
   type Wastun is record
      Art : Bewegung;
      Wert : Float;
      X_Koord, Y_Koord : Float;
   end record;
   
   -- * Typ Qrecord und Queue
   -- Liste fuer den Typ Wastun, wird im Package 'Queues' verwendet um eine
   -- Warteschlange auf diesem Typ zu definieren
   type Qrecord;
   type Queue is access Qrecord;
   type Qrecord is record
      Inhalt : Wastun;
      Danach : Queue;
   end record;


   ---------------------------------------------------------------------------
   -- Hoehe und Breite der Drawing_Area                                     --
   ---------------------------------------------------------------------------
   Hoehe  : Integer := 500;
   Breite : Integer := 600;


   ---------------------------------------------------------------------------
   -- Dateinamen                                                            --
   ---------------------------------------------------------------------------
   -- Log-Datei von Adalogo_Zeichnen
   Dateiname : String := "Adalogo.log";

   -- Adalogo-Source-Datei, vom Package Adalogo zu erstellen
   Datei_Src : String := "Adalogo.src";

   -- Log-Datei fuer das Parsen der Adalogo-Source-Datei
   Parslog   : String := "Pars.log";


end Definitionen;