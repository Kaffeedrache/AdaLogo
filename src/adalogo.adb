------------------------------------------------------------------------------
-- Wiltrud Kessler, Softwarepraktikum  2005/2006                            --
------------------------------------------------------------------------------
-- AdaLogo ist eine Schildkroete, die mit den in dieser Datei aufgefuehrten --
-- Befehlen gesteuert werden kann. Sie gibt die Resultate grafisch auf      --
-- einer Zeichenflaeche aus. Alle Befehle koennen mit Integer und Float     --
-- aufgerufen werden. Um sichtbar zu zeichnen muss nach dem Ausfuehren      --
-- dieses Packages das Programm 'Adalogo_Zeichnen' aufgerufen werden.       --
------------------------------------------------------------------------------
-- Anfangswerte:                                                            --
--   Koordinaten: 0 | 0     entspricht dem Mittelpunkt der Zeichenflaeche.  --
--   Winkel:      0         entspricht waagerecht nach rechts               --
------------------------------------------------------------------------------
-- Dieses Package packt Art des Befehls und die Werte, mit denen er         --
-- aufgerufen wurde (als Floats) in eine Liste, am Schluss wird mit 'Start' --
-- aus Adalogo_gtk alles gezeichnet.                                        --
------------------------------------------------------------------------------


with Definitionen;      use Definitionen;
with Adalogo_Gtk;       use Adalogo_Gtk;


package body Adalogo is


   ---------------------------------------------------------------------------
   -- Function Turtle_Reset                                                 --
   ---------------------------------------------------------------------------
   -- Funktion, die den Urzustand wiederherstellt:                          --
   -- Winkel := 0;        Schildkroete laeuft gradeaus                      --
   -- X_Wert, Y_Wert      auf Mitte der Zeichenflaeche                      --
   -- Visible := True;    Stift ist auf dem Papier                          --
   -- Zoomfaktor := 1;    Normale Groesse                                   --
   --------------------------------------------------------------------------- 
   procedure Turtle_Reset is
      Was : Wastun;
   begin
      Was.Art := Reset;
      Einfuegen(Was);
   end Turtle_Reset;


   ---------------------------------------------------------------------------
   -- Procedure Turn                                                        --
   ---------------------------------------------------------------------------
   -- Prozedur, die die Adalogo-Schildkroete sich um X Grad drehen laesst   --
   --------------------------------------------------------------------------- 
   procedure Turn (Grad : Integer) is
      Was : Wastun;
   begin
      Was.Art := Turn;
      Was.Wert := Float(Grad);
      Einfuegen(Was);
   end Turn;

   procedure Turn (Grad : Float) is
      Was : Wastun;
   begin
      Was.Art := Turn;
      Was.Wert := Grad;
      Einfuegen(Was);
   end Turn;


   ---------------------------------------------------------------------------
   -- Procedure Turn_To                                                     --
   ---------------------------------------------------------------------------
   -- Prozedur, die die Adalogo-Schildkroete sich zu X Grad drehen laesst   --
   --------------------------------------------------------------------------- 
   procedure Turn_To (Grad : Integer) is
      Was : Wastun;
   begin
      Was.Art := Turn_To;
      Was.Wert := Float(Grad);
      Einfuegen(Was);
   end Turn_To;

   procedure Turn_To (Grad : Float) is
      Was : Wastun;
   begin
      Was.Art := Turn_To;
      Was.Wert := Grad;
      Einfuegen(Was);
   end Turn_To;
   

   ---------------------------------------------------------------------------
   -- Procedure Forward (Integer)                                           --
   ---------------------------------------------------------------------------
   -- Prozedur, die die Adalogo-Schildkroete um X Schritte vorgehen laesst  --
   --------------------------------------------------------------------------- 
   procedure Forward (Strecke : Integer) is
      Was : Wastun;
   begin
      Was.Art := Forward;
      Was.Wert := Float(Strecke);
      Einfuegen(Was);
   end Forward;
   
   procedure Forward (Strecke : Float) is
      Was : Wastun;
   begin
      Was.Art := Forward;
      Was.Wert := Strecke;
      Einfuegen(Was);
   end Forward;
   

   ---------------------------------------------------------------------------
   -- Procedure Move_To (Integer)                                           --
   ---------------------------------------------------------------------------
   -- Prozedur, die die Adalogo-Schildkroete zum Punkt X|Y gehen laesst     --
   --------------------------------------------------------------------------- 
   procedure Move_To (X_Koordinate, Y_Koordinate : Integer) is
      Was : Wastun;
   begin
      Was.Art := Move_To;
      Was.X_Koord := Float(X_Koordinate);
      Was.Y_Koord := Float(Y_Koordinate);
      Einfuegen(Was);
   end Move_To;

   procedure Move_To (X_Koordinate, Y_Koordinate : Float) is
      Was : Wastun;
   begin
      Was.Art := Move_To;
      Was.X_Koord := X_Koordinate;
      Was.Y_Koord := Y_Koordinate;
      Einfuegen(Was);
   end Move_To;


   ---------------------------------------------------------------------------
   -- Procedure Pen_Up                                                      --
   ---------------------------------------------------------------------------
   -- Prozedur, die aufhoeren laesst sichtbar zu zeichnen                   --
   --------------------------------------------------------------------------- 
   procedure Pen_Up is
      Was : Wastun;
   begin
      Was.Art := Pen_Up;
      Einfuegen(Was);
   end Pen_Up;
   

   ---------------------------------------------------------------------------
   -- Procedure Pen_Down                                                    --
   ---------------------------------------------------------------------------
   -- Prozedur, die wieder sichtbar zeichnen laesst                         --
   --------------------------------------------------------------------------- 
   procedure Pen_Down is
      Was : Wastun;
   begin
      Was.Art := Pen_Down;
      Einfuegen(Was);
   end Pen_Down;
   

   ---------------------------------------------------------------------------
   -- Procedure Draw                                                        --
   ---------------------------------------------------------------------------
   -- Prozedur, die alles am Schluss zeichnen laesst (von Adalogo_gtk)      --
   --------------------------------------------------------------------------- 
   procedure Draw is
   begin
      Start;  -- Ruft Init auf, dann Zeichnen, enthaelt auch die Gtk.Main
   end Draw;


end Adalogo;
