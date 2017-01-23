--------------------------------------------------------------------
---- Autor: AdaLogoTeam 2005                                      --
---- Datum: 13.8.2005                                             --
---- Dieses Programm zeichnet eine Pusteblume :)                  --
--------------------------------------------------------------------


with Adalogo;
use Adalogo;


procedure Pusteblume is 

   -- Diese Prozedur zeichnet ein gleichseitiges Dreieck   
   -- mit der angegebenen Seitelaenge
   procedure Dreieck (Laenge : Integer) is 
   begin
      for I in 1..3 loop
         Forward(Laenge);
         Turn(-120);
      end loop;
   end Dreieck;

   -- Diese Prozedur zeichnet einen Kreis aus 36
   -- Dreiecken, die mit der Grundseite aneinander sitzen
   procedure Kreis (Schritt : Integer) is 
   begin
      for J in 1..36 loop
         Dreieck(Schritt);
         Pen_Up;
         Forward(Schritt);
         Pen_Down;
         Turn(10);
      end loop;
   end Kreis;

   -- Diese Prozedur zeichnet den Stil der Pusteblume
   procedure Stil (Laenge : Integer; Breite : Integer) is 
   begin
      for L in 1..Breite/2 loop
         Forward(Laenge);
         Turn(90);
         Forward(1);
         Turn(90);

         Forward(Laenge);
         Turn(-90);
         Forward(1);
         Turn(-90);
      end loop;
   end Stil;


begin

   -- Schildkroete auf Anfangsposition setzen
   Turtle_Reset;

   -- 5 unterschiedlich grosse Kreise ineinander zeichnen
   -- (= die Blume)
   for K in reverse 1..5 loop
      Pen_Up;
      Move_To(0,-K*40);
      Pen_Down;
      Kreis(K*8);
   end loop;

   -- Stil zeichnen
   Pen_Up;
   Move_To(-10,0);
   Turn_To(270);
   Pen_Down;
   Stil(800,20);

   -- Zeichne!
   Draw;

end Pusteblume;