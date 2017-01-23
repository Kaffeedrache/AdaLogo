-- Wiltrud Kessler, 13.1.05
----------------------------------------------------------------
-- Packet um eine Schlange von Typ Wastun zu erzeugen.        --
-- Der Typ Wastun sowie der Typ Queue sind in 'Definitionen'  --
-- deklariert um zyklische Abhaengigkeiten zu vermeiden.      --
----------------------------------------------------------------
-- Es wird eine einfach verkettete Ringliste verwendet, die   --
-- vorne und hinten mit null abschliesst.                     --
-- Es koennen vorne und hinten neue Elemente angefuegt werden --
-- und ausgelesen und entfernt werden. Als erstes sollte mit  --
-- Newqueue eine leere Liste erzeugt werden.                  --
----------------------------------------------------------------

with Ada.Unchecked_Deallocation;

package body Queues is
  
   procedure Free is
      new Ada.Unchecked_Deallocation(Qrecord, Queue);

   -- Erstellt eine neue leere Liste
   function Newqueue return Queue is 
   begin
      return null;
   end Newqueue;
   
   -- Prueft, ob die Liste leer ist
   function Isempty (Q : Queue) return Boolean is
   begin
      return Q = null;
   end Isempty;
   
   -- Fuegt ein neues Element X am Anfang der Liste ein
   procedure Insertfirst (X : Wastun; Q : in out Queue) is
      N,R: Queue;
   begin
      if Isempty(Q) then
         Q := new Qrecord;   -- Q einziges Listenelement
         Q.Inhalt := X;
      else
         N := Q;         -- Q wird vor N eingeschoben
         R := Q.Danach;
         Q := new Qrecord'(Inhalt => X, Danach => N);
      end if;
   end Insertfirst;
   
   -- Fuegt ein neues Element X am Ende der Liste ein
   procedure Insertlast (X : Wastun; Q : in out Queue) is
      p,m: Queue;
   begin
      if Isempty(Q) then
         Q := new Qrecord;   -- Q einziges Listenelement
         Q.Inhalt := X;
      else
         p := Q; 
         m := null;
         while p /= null loop 
            m := p;
            p := p.Danach;
         end loop;
         m.Danach := new Qrecord'(Inhalt => X, Danach => null);
      end if;
   end Insertlast;

   -- Gibt das erste Element der Liste aus
   function Getfirst (Q : Queue) return Wastun is
   begin
      return Q.Inhalt;
   end Getfirst;
   
   -- Gibt das letzte Element der Liste aus
   function Getlast (Q : Queue) return Wastun is
      m,p : Queue;
   begin
         p := Q; 
         m := null;
         while p /= null loop 
            m := p;
            p := p.Danach;
         end loop;
      return m.Inhalt;
   end Getlast; 

   -- Loescht das erste Element der Liste
   procedure Removefirst (Q : in out Queue) is
      R : Queue;
   begin
      if not Isempty(Q) then
         R := Q.Danach;
         if R = null then  -- Liste besteht nur aus einem Element
            Q := null;  -- Q zeigt auf nichts mehr -> Liste leer
            Free(Q);
         else
            R := Q.Danach; -- Q wird ausgeklinkt
            Free(Q);
            Q := R;         -- Q.Danach ist neues erstes Element
         end if;
      end if;
   end Removefirst; 

   -- Loescht das letzte Element der Liste
   procedure Removelast (Q : in out Queue) is
      N,m,p : Queue;
   begin
      if Q.Danach = null then  -- Liste besteht nur aus einem Element
         Q := null;  -- Q zeigt auf nichts mehr -> Liste leer
         Free(Q);
      else p := Q; 
         n := null;
         m := null;
         while p /= null loop 
            n := m;
            m := p;
            p := p.Danach;
         end loop;
         n.Danach := null;
         Free(M);
      end if;
   end Removelast; 
      
end Queues;