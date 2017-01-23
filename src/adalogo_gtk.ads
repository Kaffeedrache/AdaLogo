------------------------------------------------------------------------------
-- Wiltrud Kessler, Softwarepraktikum  2005/2006                            --
------------------------------------------------------------------------------
-- AdaLogo ist eine Schildkroete, die mit den in dieser Datei aufgefuehrten --
-- Befehlen gesteuert werden kann. Sie gibt die Resultate grafisch auf      --
-- einer Zeichenflaeche aus. Alle Befehle koennen mit Integer und Float     --
-- aufgerufen werden.                                                       --
-- Alle Befehle werden in eine Liste (To_Do_Schlange) geschrieben, diese    --
-- Liste wird dann durchlaufen und alle Befehle werden nacheinander         --
-- ausgefuehrt. Schon ausgefuehrte Befehle werden in die Getan_Schlange     --
-- eingetragen, damit sie beim Klicken auf einen der Zoom- oder Move-       --
-- Buttons neu gezeichnet werden koennen.                                   --
------------------------------------------------------------------------------
-- Anfangswerte:                                                            --
--   Koordinaten :  0 | 0    entspricht dem Mittelpunkt der Zeichenflaeche  --
--   Winkel      :  0        entspricht waagerecht nach rechts              --
--   Visibility  : True      es wird sichtbar gezeichnet                    --
--   Zoom        : 1         Normalgroesse                                  --
--   Offset      : 0         Nicht verschoben                               --
------------------------------------------------------------------------------

with Definitionen;      use Definitionen;

package Adalogo_gtk is
   

   ---------------------------------------------------------------------------
   -- Procedure Init                                                        --
   ---------------------------------------------------------------------------
   -- Prozedur, die Gtkada initialisiert, muss am Anfang aufgerufen werden. --
   --------------------------------------------------------------------------- 
   procedure Init;
   
   ---------------------------------------------------------------------------
   -- Procedure Zeichne                                                     --
   ---------------------------------------------------------------------------
   -- Diese Prozedur sorgt dafuer, dass tatsaechlich gezeichnet wird.       --
   -- Ohne 'Zeichne' geschieht nichts Sichtbares!                           --
   --------------------------------------------------------------------------- 
   procedure Zeichne(Drawing_Area_Refresh : Boolean);

   ---------------------------------------------------------------------------
   -- Procedure Start                                                       --
   ---------------------------------------------------------------------------
   -- Ruft Init auf und Zeichnen und erzeugt die Befehlsliste - zu ersetzen --
   --------------------------------------------------------------------------- 
   procedure Start;
      

   procedure Einfuegen (Element : Wastun);


end Adalogo_gtk;
