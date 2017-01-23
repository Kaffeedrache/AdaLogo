--  $Id: koch_stern.adb 136 2006-11-19 22:10:09Z keulsn $

with Ada.Command_Line;
with Ada.Numerics.Elementary_Functions;
with Adalogo;

procedure Koch_Stern
is

   procedure Draw_Recursive
     (Depth  : in Natural;
      Length : in Float)
   is
   begin
      if Depth = 0 then
         Adalogo.Forward (Length);
      else
         Draw_Recursive (Depth - 1, Length / 3.0);
         Adalogo.Turn (60);
         Draw_Recursive (Depth - 1, Length / 3.0);
         Adalogo.Turn (-120);
         Draw_Recursive (Depth - 1, Length / 3.0);
         Adalogo.Turn (60);
         Draw_Recursive (Depth - 1, Length / 3.0);
      end if;
   end Draw_Recursive;

   package Numerics renames Ada.Numerics.Elementary_Functions;
   Total_Depth  : Natural := 5;
   Total_Length : Float := 200.0;
begin
   if Ada.Command_Line.Argument_Count >= 1 then
      Total_Depth := Integer'Value (Ada.Command_Line.Argument (1));
   end if;
   if Ada.Command_Line.Argument_Count >= 2 then
      Total_Length := Float'Value (Ada.Command_Line.Argument (2));
   end if;

   Adalogo.Turtle_Reset;
   Draw_Recursive (Total_Depth, Total_Length);
   Adalogo.Turn (-180 + 60);
   Draw_Recursive (Total_Depth, Total_Length);
   Adalogo.Turn (-180 + 60);
   Draw_Recursive (Total_Depth, Total_Length);

   Adalogo.Pen_Up;
   Adalogo.Turn (-180 + 30);
   Adalogo.Forward (Total_Length / Numerics.Sqrt (3.0));

   Adalogo.Draw;
end Koch_Stern;

