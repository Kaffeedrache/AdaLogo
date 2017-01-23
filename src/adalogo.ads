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


package Adalogo is
     

   ---------------------------------------------------------------------------
   -- Procedure Turtle_Reset                                                --
   ---------------------------------------------------------------------------
   -- Funktion, die den Urzustand der Schildkroete wiederherstellt:         --
   -- Winkel := 0;   Schildkroete laeuft gradeaus (waagerecht nach rechts)  --
   -- Schildkroete steht in der Mitte der Zeichenflaeche                    --
   -- Stift ist auf dem Papier (es wird sichtbar gezeichnet)                --
   --------------------------------------------------------------------------- 
   procedure Turtle_Reset;


   ---------------------------------------------------------------------------
   -- Procedure Turn                                                        --
   ---------------------------------------------------------------------------
   -- Turn laesst die Adalogo-Schildkroete sich um X Grad (gegen den        --
   -- Uhrzeigersinn) drehen.                                                --
   --------------------------------------------------------------------------- 
   procedure Turn (Grad : Integer);
   procedure Turn (Grad : Float);
   

   ---------------------------------------------------------------------------
   -- Procedure Turn_To                                                     --
   ---------------------------------------------------------------------------
   -- Mit Turn_To richtet sich die Schildkroete zur angegeben Richtung aus. --
   --------------------------------------------------------------------------- 
   procedure Turn_To (Grad : Integer);
   procedure Turn_To (Grad : Float);


   ---------------------------------------------------------------------------
   -- Procedure Forward                                                     --
   ---------------------------------------------------------------------------
   -- Prozedur, die die Adalogo-Schildkroete um X Schritte vorgehen laesst, --
   --------------------------------------------------------------------------- 
   procedure Forward (Strecke : Integer);
   procedure Forward (Strecke : Float);
   

   ---------------------------------------------------------------------------
   -- Procedure Move_To                                                     --
   ---------------------------------------------------------------------------
   -- Prozedur, die die Adalogo-Schildkroete zu dem Punkt mit den           --
   -- angegebenen Koordinaten springen laesst.                              --
   --------------------------------------------------------------------------- 
   procedure Move_To (X_Koordinate, Y_Koordinate : Integer);
   procedure Move_To (X_Koordinate, Y_Koordinate : Float);
   

   ---------------------------------------------------------------------------
   -- Procedure Pen_Up, Procedure Pen_Down                                  --
   ---------------------------------------------------------------------------
   -- Mit Pen_Up nimmt man den Stift, mit dem man sonst zeichnet hoch, es   --
   -- wird also nicht gezeichnet.                                           --
   -- Mit Pen_Down setzt man den Stift wieder runter zum weiter zeichnen.   --
   --------------------------------------------------------------------------- 
   procedure Pen_Up;
   procedure Pen_Down;


   ---------------------------------------------------------------------------
   -- Procedure Draw                                                        --
   ---------------------------------------------------------------------------
   -- Prozedur, die alles am Schluss zeichnen laesst (von Adalogo_gtk)      --
   --------------------------------------------------------------------------- 
   procedure Draw;

end Adalogo;
