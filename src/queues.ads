-- Wiltrud Kessler, 13.1.05
----------------------------------------------------------------
-- Packet um eine Schlange von Typ Wastun zu erzeugen.        --
-- Der Typ Wastun sowie der Typ Queue sind in 'Definitionen'  --
-- deklariert um zyklische Abhaengigkeiten zu vermeiden.      --
----------------------------------------------------------------

with Definitionen;      use Definitionen;

package Queues is

   -- Bevor mit der Schlange gearbeitet werden kann,
   -- muss eine leere Schlange mit Newqueue erzeugt werden
   function Newqueue return Queue;

   -- Gibt 'true' zurueck, falls die Schlange leer ist, 
   -- sonst 'false'. Isempty(Newqueue) = 'true'
   function Isempty (Q : Queue) return Boolean; 

   -- Fuegt ein neues Element des Typs T am Anfang der Schlange ein
   procedure Insertfirst (X : Wastun; Q : in out Queue); 

   -- Fuegt ein neues Element des Typs T am Ende der Schlange ein
   procedure Insertlast (X : Wastun; Q : in out Queue); 

   -- Gibt das erste Element der Schlange aus
   function Getfirst (Q : Queue) return Wastun; 

   -- Gibt das letze Element der Schlange aus
   function Getlast (Q : Queue) return Wastun; 

   -- Entfernt das erste Element der Schlange
   procedure Removefirst (Q : in out Queue); 

   -- Entfernt das letzte Element der Schlange
   procedure Removelast (Q : in out Queue); 
  
end Queues;