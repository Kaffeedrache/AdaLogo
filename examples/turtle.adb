--------------------------------------------------------------------
---- Autor: Wiltrud Kessler                                       --
---- Datum: 03.11.2006                                            --
---- Eine Schildkroete (das Logo von AdaLogo ;) wird gezeichnet.  --
--------------------------------------------------------------------

with Ada.Numerics.Elementary_Functions;
use  Ada.Numerics.Elementary_Functions;

with Adalogo;
use  Adalogo;


procedure Turtle is 
  

   -- Zeichnet eine Ellipse mit Groesse als Laenge
   procedure Ellipse (Groesse: Integer) is
      Wieviel : Float;
   begin
      Wieviel := Float(Groesse) * Tan(1.0,360.0);
      -- Ein bisschen grade
      Forward(Groesse/6);
      -- Halbkreis
      for i in 1..180 loop
         Turn(1);
         Forward(Wieviel);
      end loop;
      -- Ein bisschen grade
      Forward(Groesse/3);
      -- Halbkreis
      for i in 1..180 loop
         Turn(1);
         Forward(Wieviel);
      end loop;
      -- Ein bisschen grade
      Forward(Groesse/6);
   end Ellipse;


   -- Zeichnet ein ausgefuelltes Viereck, steht danach in der
   -- selben Richtung und am selben Ort wie davor
   procedure Viereck (Groesse: Integer) is
   begin
      for i in 1..(Groesse/4) loop
         Forward(Groesse);
         Turn(90);
         Forward(0.5);
         Turn(90);

         Forward(Groesse);
         Turn(-90);
         Forward(0.5);
         Turn(-90);
      end loop;
      if ((Groesse/4) mod 2) /= 0 then
         Turn(180);
         Pen_Up;
         Forward(Groesse);
         Pen_Down;
      end if;
      Pen_Up;
      Turn(90);
      Forward(Groesse/2);
      Turn(90);
      Pen_Down;
   end Viereck;


   Schildzahl : Integer := 40;
   Schildzahl_2 : Integer := Schildzahl;
   Abstand : Integer := Schildzahl/2;

begin
   
   Turtle_Reset;

   -- Schildkroete Zeichnen
   
   -- Panzer = 3 Ellipsen
   Pen_Up;
   Forward(Schildzahl);
   Turn(90);
   Pen_Down;
   Ellipse (Schildzahl);
   
   Pen_Up;
   Move_To(0,0);
   Turn_To(0);
   Schildzahl_2 := Schildzahl + Schildzahl/2;
   Forward(Schildzahl_2);
   Turn(90);
   Pen_Down;
   Ellipse (Schildzahl_2);
   
   Pen_Up;
   Move_To(0,0);
   Turn_To(0);
   Schildzahl_2 := Schildzahl * 2;
   Forward(Schildzahl_2);
   Turn(90);
   Pen_Down;
   Ellipse (Schildzahl_2);
   Turn(90);
   
   -- Beine
   Pen_Up;
   Move_To(0,0);
   Turn_To(60);
   Forward(Schildzahl_2 + Abstand);
   Pen_Down;
   Viereck(Schildzahl);

   Pen_Up;
   Move_To(0,0);
   Turn_To(240);
   Forward(Schildzahl_2 + Abstand);
   Pen_Down;
   Viereck(Schildzahl);
   
   Pen_Up;
   Move_To(0,0);
   Turn_To(120);
   Forward(Schildzahl_2 + Abstand);
   Pen_Down;
   Viereck(Schildzahl);

   Pen_Up;
   Move_To(0,0);
   Turn_To(300);
   Forward(Schildzahl_2 + Abstand);
   Pen_Down;
   Viereck(Schildzahl);

   -- Eine Nase
   Pen_Up;
   Move_To(0,Schildzahl_2 + (2 * Abstand));
   Turn_To(90);
   Pen_Down;

   -- Sichtbar zeichnen
   Draw;

end Turtle;
