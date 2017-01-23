--------------------------------------------------------------------
---- Autor: AdaLogoTeam 2005                                      --
---- Datum: 16.8.2005                                             --
---- Dieses Programm zeichnet ein Mandala aus verschieden grossen --
---- Kreisen, die in verschiedene Richtungen gezeichnet werden.   --
--------------------------------------------------------------------

with Ada.Numerics.Float_Random;
use Ada.Numerics.Float_Random;

with Adalogo;
use Adalogo;


procedure Mandala is 

   -- Diese Prozedur zeichnet einen Kreis
   procedure Kreis (Groesse : Integer) is 
   begin
      for I in 1..360/9 loop
         Turn(1*9);
         Forward(Groesse*9);
      end loop;
   end Kreis;


   Ran   : Integer     := 361;  
   Valid : Boolean     := False;  
   Gen   : Generator;  -- Zufallsgenerator
   
begin
   
   -- Schildkroete und Zufallsgenerator initialisieren
   Turtle_Reset;
   Reset(Gen);
   
   -- 'Ran' ist eine zufaellige Zahl zwischen 10 und
   -- 90. 'Ran' wird so lange neu bestimmt, bis die Zahl
   -- 'Valid', ist, d.h. bis sie ein Teiler von 360 ist. 
   while not Valid loop
      Ran:=Integer(Random(Gen) * 80.0 + 10.0);
      if 360 mod Ran=0 then
         Valid:=True;
      end if;
   end loop;
   
   -- Die Schildkroete dreht sich in I Schritten (jeweils
   -- um I*Ran Grad) einmal um sich selbst und zeichnet 
   -- dabei in jeder Richtung einen Kreis mit der aktuellen
   -- Groesse, die von 1 bis 5 geht.
   for J in 1..5 loop
      for I in 1..360/Ran loop
         Turn_To(I*Ran);
         Kreis(J);
      end loop;
   end loop;

   -- Fertig ist das Mandala  
   Draw; 

end Mandala;