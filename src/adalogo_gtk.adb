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
-- Befehle:                                                                 --
--   Turtle_Reset     : Setzt die Koordinaten, Winkel, Zoom, Sichtbarkeit,  --
--                      Offset auf Anfangswerte zurueck                     --
--   Forward(Strecke) : Geht um <Strecke> vorwaerts (negativ = rueckwaerts) --
--   Turn(Winkel)     : Dreht sich um <Winkel> gegen Uhrzeigersinn          --
--   Turn_To(Winkel)  : Dreht sich zu <Winkel>                              --
--   Pen_Up           : Laesst unsichtbar Zeichnen                          --
--   Pen_Down         : Macht das Zeichnen wieder sichtbar                  --
--   Move_To(X,Y)     : Springt zeichnend zum Punkt X | Y                   --
------------------------------------------------------------------------------


with Glib;              use Glib;
with Gdk;
with Gdk.Color;         use Gdk.Color;
with Gdk.Drawable;      use Gdk.Drawable;
with Gdk.Event;         use Gdk.Event;
with Gdk.GC;            use Gdk.GC;
with Gdk.Pixmap;        use Gdk.Pixmap;
with Gdk.Rectangle;     use Gdk.Rectangle;
with Gdk.Window;        use Gdk.Window;

with Gtk;               use Gtk;
with Gtk.Box;           use Gtk.Box;
with Gtk.Button;        use Gtk.Button;
with Gtk.Drawing_Area;  use Gtk.Drawing_Area;
with Gtk.Enums;         use Gtk.Enums;
with Gtk.Main;          use Gtk.Main;
with Gtk.Handlers;      use Gtk.Handlers;
with Gtk.Style;         use Gtk.Style;
with Gtk.Window;        use Gtk.Window;
with Gtk.Widget;        use Gtk.Widget;

with Gtkada.Dialogs;    use Gtkada.Dialogs;

with Ada.Exceptions;    use Ada.Exceptions;
with Ada.Float_Text_Io; use Ada.Float_Text_Io;
with Ada.Text_Io;       use Ada.Text_Io;

with Ada.Characters.Latin_1;
use Ada.Characters.Latin_1;
with Ada.Numerics.Elementary_Functions; 
use Ada.Numerics.Elementary_Functions;

with Definitionen;      use Definitionen;
with Queues;            use Queues;


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


package body Adalogo_gtk is
   
     
   ---------------------------------------------------------------------------
   -- generic instantiations                                                --
   ---------------------------------------------------------------------------
   package Configured is new Gtk.Handlers.Return_Callback
     (Widget_Type => Gtk_Drawing_Area_Record,
      Return_Type => Boolean);
   package Destroyed is new Gtk.Handlers.Callback
      (Widget_Type => Gtk_Window_Record);

   package Button_Cb is new Handlers.Callback (Gtk_Button_Record);
   

   ---------------------------------------------------------------------------
   -- Globale Variablen                                                     --
   ---------------------------------------------------------------------------

   -- Momentaner Standort des Schildkroetchens und momentane Ausrichtung
   -- und ob sichtbar gezeichnet wird (visible) und welcher Zoomfaktor und
   -- welcher X- und Y-Offset gerade aktuell ist.
   X_Wert, Y_Wert : Float;
   Winkel         : Float;
   Visible        : Boolean;
   Zoomfaktor     : Integer;
   X_Offset, Y_Offset : Float;

   -- Log-Datei (Dateiname steht in Definitionen.ads)
   Datei          : File_Type;

   -- Gtk-Objekte
   Drawing_Area   : Gtk_Drawing_Area;
   Pixmap         : Gdk_Pixmap;
   Window         : Gtk_Window;
   Vbox, HBox     : Gtk_Box;
   Button         : Gtk_Button;
  
   -- To_Do_Schlange: Dort werden alle Aktionen eingetragen, die noch 
   -- durchgefuehrt werden muessen
   -- Getan_Schlange: Dort werden alle Aktionen eingetragen, die schon
   -- durchgefuehrt wurden
   To_Do_Schlange, Getan_Schlange : Queue := Newqueue;


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


   ---------------------------------------------------------------------------
   -- Procedure Bye                                                         --
   ---------------------------------------------------------------------------
   -- Prozedur zum Schliessen des Hauptfensters                             --
   ---------------------------------------------------------------------------
   procedure Bye (Window : access Gtk.Window.Gtk_Window_Record'Class) is
      pragma Warnings (Off, Window);
       Achtung : Message_Dialog_Buttons;
   begin
      
      -- Abschiedsnachricht
      Achtung := Message_Dialog
                     (Msg => "Thanks for using AdaLogo.",
                      Dialog_Type => Custom,
                      Buttons => Button_OK,
                      Title => "AdaLogo - Goodbye!");      

      -- Schliesst das Hauptfenster
      Gtk.Main.Main_Quit;

   end Bye;


   ---------------------------------------------------------------------------
   -- Function Expose_Event                                                 --
   ---------------------------------------------------------------------------
   -- Funktion zum Sichtbarmachen der Drawing_Area                          --
   ---------------------------------------------------------------------------  
   function Expose_Event
        (Drawing_Area : access Gtk_Drawing_Area_Record'Class;
         Event : in Gdk.Event.Gdk_Event)
      return Boolean
   is
      Area : Gdk_Rectangle := Get_Area (Event);
   begin
      Draw_Drawable (Get_Window (Drawing_Area),
                   Get_Fg_GC (Get_Style (Drawing_Area), State_Normal),
                   Pixmap, Area.X, Area.Y, Area.X, Area.Y,
                   Gint (Area.Width), Gint (Area.Height));
      return True;
   end Expose_Event;


   ---------------------------------------------------------------------------
   -- Function Configure_Event                                              --
   ---------------------------------------------------------------------------
   -- Die Konfiguration des Fensters hat sich geaendert.                    --
   --------------------------------------------------------------------------- 
   function Configure_Event
        (Drawing_Area : access Gtk_Drawing_Area_Record'Class)
      return Boolean
   is
      Win    : Gdk_Window;
      Width  : Gint;
      Height : Gint;

   begin
      Win := Get_Window (Drawing_Area);
      Get_Size (Win, Width, Height);

      Gdk.Pixmap.Gdk_New (Pixmap, Win, Width, Height, -1);
      Draw_Rectangle (Pixmap, Get_White (Get_Style (Drawing_Area)),
                      True, 0, 0, Width, Height);
      return True;
   end Configure_Event;


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   

   ---------------------------------------------------------------------------
   -- Procedure Button_Move_Right_Clicked                                   --
   ---------------------------------------------------------------------------
   -- Legt fest, was passiert, wenn man auf den Button '>' klickt.          --
   --------------------------------------------------------------------------- 
   -- Die Zeichnung auf der Drawing Area wird nach links verschoben.        --
   --------------------------------------------------------------------------- 
   procedure Button_Move_Right_Clicked 
      (Widget : access Gtk_Button_Record'Class) is
   begin
      X_Offset := X_Offset - 10.0;
      Released(Widget);             -- Button loslassen
      Zeichne(true);                -- Neu zeichnen
   end Button_Move_Right_Clicked;
   

   ---------------------------------------------------------------------------
   -- Procedure Button_Move_Left_Clicked                                    --
   ---------------------------------------------------------------------------
   -- Legt fest, was passiert, wenn man auf den Button '<' klickt.          --
   --------------------------------------------------------------------------- 
   -- Die Zeichnung auf der Drawing Area wird nach rechts verschoben.       --
   --------------------------------------------------------------------------- 
   procedure Button_Move_Left_Clicked 
      (Widget : access Gtk_Button_Record'Class) is
   begin
      X_Offset := X_Offset + 10.0;
      Released(Widget);             -- Button loslassen
      Zeichne(true);                -- Neu zeichnen
   end Button_Move_Left_Clicked;
   

   ---------------------------------------------------------------------------
   -- Procedure Button_Move_Up_Clicked                                      --
   ---------------------------------------------------------------------------
   -- Legt fest, was passiert, wenn man auf den Button '<' klickt.          --
   --------------------------------------------------------------------------- 
   -- Die Zeichnung auf der Drawing Area wird nach unten verschoben.        --
   --------------------------------------------------------------------------- 
   procedure Button_Move_Up_Clicked 
      (Widget : access Gtk_Button_Record'Class) is
   begin
      Y_Offset := Y_Offset + 10.0;
      Released(Widget);             -- Button loslassen
      Zeichne(true);                -- Neu zeichnen
   end Button_Move_Up_Clicked;
   

   ---------------------------------------------------------------------------
   -- Procedure Button_Move_Down_Clicked                                    --
   ---------------------------------------------------------------------------
   -- Legt fest, was passiert, wenn man auf den Button '<' klickt.          --
   --------------------------------------------------------------------------- 
   -- Die Zeichnung auf der Drawing Area wird nach oben verschoben.         --
   --------------------------------------------------------------------------- 
   procedure Button_Move_Down_Clicked 
      (Widget : access Gtk_Button_Record'Class) is
   begin
      Y_Offset := Y_Offset - 10.0;
      Released(Widget);             -- Button loslassen
      Zeichne(true);                -- Neu zeichnen
   end Button_Move_Down_Clicked;
   

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


   ---------------------------------------------------------------------------
   -- Procedure Button_Zoom_In_Clicked                                      --
   ---------------------------------------------------------------------------
   -- Legt fest, was passiert, wenn man auf den Button 'Zoom_In' klickt.    --
   ---------------------------------------------------------------------------
   -- Erhoet den Zoomfaktor um eins und laesst dann neu zeichnen.           --
   ---------------------------------------------------------------------------    
   procedure Button_Zoom_In_Clicked 
      (Widget : access Gtk_Button_Record'Class) is
   begin    
      Zoomfaktor := Zoomfaktor + 1; -- Zoom in
      Released(Widget);             -- Button loslassen
      Zeichne(true);                -- Neu zeichnen
   end Button_Zoom_In_Clicked;


   ---------------------------------------------------------------------------
   -- Procedure Button_Zoom_Out_Clicked                                     --
   ---------------------------------------------------------------------------
   -- Legt fest, was passiert, wenn man auf den Button 'Zoom_Out' klickt.   --
   ---------------------------------------------------------------------------
   -- Erniedrigt den Zoomfaktor um eins und laesst dann neu zeichnen.       --
   ---------------------------------------------------------------------------   
   procedure Button_Zoom_Out_Clicked 
      (Widget : access Gtk_Button_Record'Class) is
   begin 
      Zoomfaktor := Zoomfaktor - 1; -- Zoom out
      Released(Widget);             -- Button loslassen
      Zeichne(true);                -- Neu zeichnen
   end Button_Zoom_Out_Clicked;


   ---------------------------------------------------------------------------
   -- Procedure Button_Reset_Clicked                                        --
   ---------------------------------------------------------------------------
   -- Legt fest, was passiert, wenn man auf den Button 'Reset' klickt.      --
   ---------------------------------------------------------------------------
   -- Setzt die Parameter auf die Anfangswerte zurueck und zeichnet neu.    --
   --------------------------------------------------------------------------- 
   procedure Button_Reset_Clicked 
      (Widget : access Gtk_Button_Record'Class) is
   begin
      Zoomfaktor := 1;
      X_Offset   := 0.0;
      Y_Offset   := 0.0;
      Released(Widget);             -- Button loslassen
      Zeichne(true);                -- Neu zeichnen
   end Button_Reset_Clicked;
   

   ---------------------------------------------------------------------------
   -- Procedure Button_About_Clicked                                        --
   ---------------------------------------------------------------------------
   -- Legt fest, was passiert, wenn man auf den Button 'About' klickt.      --
   ---------------------------------------------------------------------------
   -- Zeigt an, wer dieses wunderschoene Ding programmiert hat :)           --
   --------------------------------------------------------------------------- 
   procedure Button_About_Clicked (Widget : access Gtk_Button_Record'Class) is
      Achtung : Message_Dialog_Buttons;
      Message : Utf8_String :=  
         "AdaLogo entstand als Softwarepraktikum der Uni Stuttgart, " & lf &
         "Fakultaet 5, Abteilung FMI " & "im Jahre 2006 " & lf & lf &
         "Autor: Wiltrud Kessler" & lf &
         "Homepage: www.adalogo.de.vu";
   begin    
      Gtk.Main.Init;
      Achtung := Message_Dialog(Msg => Message,
                      Dialog_Type => Information,
                      Buttons => Button_OK,
                      Title => "About AdaLogo");
      Released(Widget);             -- Button loslassen
   end Button_About_Clicked;


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


   ---------------------------------------------------------------------------
   -- Procedure Init                                                        --
   ---------------------------------------------------------------------------
   -- Prozedur, die Gtkada initialisiert und die Logdatei erzeugt.          --
   --------------------------------------------------------------------------- 
   -- Es wird das Fenster, mit VBox, Buttons und Drawing_Area erzeugt und   --
   -- mit den Buttons die entsprechenden Funktionen verbunden.              --
   --------------------------------------------------------------------------- 
   procedure Init is
   begin
      
      Gtk.Main.Init;       -- Initialisiere Gtk-Ada
      Create(Datei,Out_File,Dateiname);  -- Logdatei erzeugen     

      ------------------------------------------------------------------------
      -- Fenster und VBox darin                                             --
      ------------------------------------------------------------------------

      -- Neues Fensterle erzeugen, Titel setzen und machen, dass es sich
      -- schliesst, wenn man auf's x-le klickt.
      Gtk.Window.Gtk_New(Window);
      Set_Title(Window, "AdaLogo");
      Destroyed.Connect (Window, "destroy",
                         Destroyed.To_Marshaller (Bye'Access));

      -- VBox erzeugen, ins Fenster packen und anzeigen
      Gtk_New_Vbox (Vbox, Homogeneous => False, Spacing => 0);
      Add (Window, Vbox);

      ------------------------------------------------------------------------
      -- Buttons fuer Move, HBox, Drawing_Area                              --
      ------------------------------------------------------------------------

      -- Alle Buttons erzeugen und jeweils in die VBox packen
      -- Button Move nach oben
      Gtk_New (Button, "/\");
      Pack_Start (Vbox, Button, Expand => True, Fill => False);
      Button_Cb.Object_Connect (Button, "clicked",
                           Button_Cb.To_Marshaller (Button_Move_Up_Clicked'access),
                           Button);      

      -- HBox erzeugen
      Gtk_New_HBox (Hbox, Homogeneous => False, Spacing => 0);
      
      -- Button Move left
      Gtk_New (Button, "<");
      Pack_Start (Hbox, Button, Expand => True, Fill => False);
      Button_Cb.Object_Connect (Button, "clicked",
                           Button_Cb.To_Marshaller (Button_Move_Left_Clicked'access),
                           Button);  

      -- Drawing-Area erzeugen und in die VBox packen und anzeigen
      Gtk_New (Drawing_Area);
      Size (Drawing_Area, Gint(Breite), Gint(Hoehe));
      Pack_Start (In_Box => HBox, Child => Drawing_Area);

      -- Aktionen damit verbinden    
      Set_Events (Drawing_Area, Exposure_Mask or Leave_Notify_Mask or
                   Pointer_Motion_Mask or
                  Pointer_Motion_Hint_Mask);

      -- Dass die Drawing_Area auch angezeigt wird
      Configured.Connect (Widget => Drawing_Area,
                          Name   => "expose_event",
                          Marsh  => Configured.To_Marshaller
                                   (Expose_Event'Access));

      -- Dass sie auch lang genug sichtbar bleibt um sie zu bemerken
      Configured.Connect (Widget => Drawing_Area,
                          Name   => "configure_event",
                          Marsh  => Configured.To_Marshaller
                                   (Configure_Event'Access));

      -- Button Move rechts
      Gtk_New (Button, ">");
      Pack_Start (Hbox, Button, Expand => True, Fill => False);
      Button_Cb.Object_Connect (Button, "clicked",
                           Button_Cb.To_Marshaller (Button_Move_Right_Clicked'access),
                           Button);  
         
      -- HBox in die VBox packen
      Pack_Start (Vbox, HBox, Expand => False, Fill => False);

      -- Button Move nach oben
      Gtk_New (Button, "\/");
      Pack_Start (Vbox, Button, Expand => True, Fill => False);
      Button_Cb.Object_Connect (Button,
                             "clicked",
                           Button_Cb.To_Marshaller (Button_Move_Down_Clicked'access),
                           Button);   

      ------------------------------------------------------------------------
      -- HBox und Buttons darin (Zoom, Reset, About)                        --
      ------------------------------------------------------------------------
      
      -- HBox erzeugen
      Gtk_New_HBox (Hbox, Homogeneous => False, Spacing => 0);

      -- Alle Buttons erzeugen und jeweils in die HBox packen
      Gtk_New (Button, "Zoom In");
      Pack_Start (Hbox, Button, Expand => False, Fill => False);
      Button_Cb.Object_Connect (Button, "clicked",
                           Button_Cb.To_Marshaller (Button_Zoom_In_Clicked'access),
                           Button);      

      Gtk_New (Button, "Zoom Out");
      Pack_Start (Hbox, Button, Expand => False, Fill => False);
      Button_Cb.Object_Connect (Button, "clicked",
                           Button_Cb.To_Marshaller (Button_Zoom_Out_Clicked'access),
                           Button);  

      Gtk_New (Button, "Reset");
      Pack_Start (Hbox, Button, Expand => False, Fill => False);
      Button_Cb.Object_Connect (Button, "clicked",
                           Button_Cb.To_Marshaller (Button_Reset_Clicked'access),
                           Button);  

      Gtk_New (Button, "About");
      Pack_Start (Hbox, Button, Expand => False, Fill => False);
      Button_Cb.Object_Connect (Button, "clicked", 
                           Button_Cb.To_Marshaller (Button_About_Clicked'access),
                           Button);  

      -- HBox in die VBox packen
      Pack_Start (Vbox, HBox, Expand => False, Fill => False);

      ------------------------------------------------------------------------
      -- Fenster anzeigen, Startwerte setzen, Log schreiben                 --
      ------------------------------------------------------------------------

      -- Zeig das Fensterle an mitsamt allem, wo grad drin ist
      Show_All (Window);

      -- Anfangswerte
      X_Wert     := Float(Breite)/2.0;
      Y_Wert     := Float(Hoehe)/2.0;
      Winkel     := 0.0;
      Visible    := True;
      Zoomfaktor := 1;
      X_Offset   := 0.0;
      Y_Offset   := 0.0;
         
      -- Log schreiben
      if not Is_Open(Datei) then
         Open(Datei,Append_File,Dateiname);
      end if;
      Put_Line(Datei,"Ready...");
      
   exception
      when E : others => --Fehlermeldung in Log-Datei eintragen
         if not Is_Open(Datei) then
            Open(Datei,Append_File,Dateiname);
         end if;
         New_Line(Datei);
         Put(Datei,Exception_Information(E));
         Put_Line(Datei,"Location: Procedure Init");
         Close(Datei);      

   end Init;
   

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   

   ---------------------------------------------------------------------------
   -- Hilfsfunktionen To_Gtk_Koords & To_Adalogo_Koords                     --
   ---------------------------------------------------------------------------
   -- Wandelt Gtk-Koordinaten (Mittelpunkt links oben, Y-Achse positiv nach --
   -- unten) in Adalogo-Koordinaten (Mittelpunkt in der Mitte des Fensters, --
   -- Y-Achse postiv nach oben) um und andersrum.                           --
   ---------------------------------------------------------------------------
   function To_Gtk_Koord (Koord: Float; X : Boolean) return Float is
      Win    : Gdk_Window;
      Width, Height  : Gint;
   begin
      Win := Get_Window (Drawing_Area);
      Get_Size (Win, Width, Height);
      if X then -- X-Wert
         return Koord + Float(Width/2);
      else -- Y-Wert
         return -Koord + Float(Height/2);
      end if;
   end To_Gtk_Koord;
   
   function To_Adalogo_Koord (Koord : Float; X : Boolean) return Float is
      Win    : Gdk_Window;
      Width, Height  : Gint;
   begin
      Win := Get_Window (Drawing_Area);
      Get_Size (Win, Width, Height);
      if X then -- X-Wert
         return Koord - Float(Width/2);
      else -- Y-Wert
         return -(Koord - Float(Height/2));
      end if;
   end To_Adalogo_Koord;  


   ---------------------------------------------------------------------------
   -- Hilfsfunktionen To_Gtk_Winkel & To_Adalogo_Winkel                     --
   ---------------------------------------------------------------------------
   -- Wandelt Gtk-Winkel (default im Uhrzeigersinn) in Adalogo-Winkel       --
   -- (gegen den Uhrzeigersinn) um und umgekehrt.                           --
   ---------------------------------------------------------------------------
   function To_Gtk_Winkel (Winkel : Float) return Float is
   begin
      return Winkel * (-1.0);
   end To_Gtk_Winkel;
   
   function To_Adalogo_Winkel (Winkel : Float) return Float is
   begin
      return Winkel * (-1.0);
   end To_Adalogo_Winkel;


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


   ---------------------------------------------------------------------------
   -- Procedure Draw_Turn                                                   --
   ---------------------------------------------------------------------------
   -- Laesst die kleine Schildkroete sich drehen um den Wert, der           --
   -- uebergeben wird.                                                      --
   ---------------------------------------------------------------------------
   -- Zur globalen Variable Winkel wird der uebergebenen Winkel addiert.    --
   ---------------------------------------------------------------------------   
   procedure Draw_Turn (Grad : Float; Logging : Boolean) is
   begin
      -- Der Winkel ist einfach das, was eingegeben wurde, er wird zum
      -- aktuell schon vorhandenen Winkel addiert.
      --  Wenn der Winkel danach groesser als 360 Grad ist,
      -- werden 360 Grad abgezogen, um zu vermeiden, dass die Zahl zu 
      -- gross wird. Analog fuer -360.0 Grad
      Winkel := Winkel + To_Gtk_Winkel(Grad);
      while Winkel > 360.0 loop
         Winkel := Winkel - 360.0;
      end loop;
      while Winkel < -360.0 loop
         Winkel := Winkel + 360.0;
      end loop;
      
      -- Log schreiben
      -- Format: Turn Grad (Winkel)
      if Logging then
         if not Is_Open(Datei) then
            Open(Datei,Append_File,Dateiname);
         end if;
         Put(Datei,"Turn ");
         Put(Datei,Grad,3,0,0);
         Put(Datei," (");
         Put(Datei,To_Adalogo_Winkel(Winkel),3,0,0);
         Put(Datei,")");
         New_Line(Datei);
      end if;
      
   exception
      when E : others => --Fehlermeldung in Log-Datei eintragen
         if not Is_Open(Datei) then
            Open(Datei,Append_File,Dateiname);
         end if;
         New_Line(Datei);
         Put(Datei,Exception_Information(E));
         Put_Line(Datei,"Location: Procedure Draw_Turn");
         Close(Datei);
         
   end Draw_Turn;
   

   ---------------------------------------------------------------------------
   -- Procedure Draw_Turn_To                                                --
   ---------------------------------------------------------------------------
   -- Laesst die Schildkroete sich drehen, bis sie in die angegebene        --
   -- Richtung ausgerichtet ist.                                            --
   ---------------------------------------------------------------------------
   -- Globale Variable Winkel wird auf den uebergebenen Winkel gesetzt.     --
   ---------------------------------------------------------------------------  
   procedure Draw_Turn_To (Grad : Float; Logging : Boolean) is
   begin
      -- Der Winkel wird auf minus das, was eingegeben wurde gesetzt.
      -- Wenn der Winkel groesser als 360 Grad ist, werden 360 Grad 
      -- abgezogen, um zu vermeiden, dass die Zahl zu gross wird.
      -- Analog fuer -360.0 Grad
      Winkel := To_Gtk_Winkel(Grad);
      while Winkel > 360.0 loop
         Winkel := Winkel - 360.0;
      end loop;
      while Winkel < -360.0 loop
         Winkel := Winkel + 360.0;
      end loop;
      
      -- Log schreiben wenn gewuenscht
      -- Format: Turn_To Grad
      if Logging then
         
         if not Is_Open(Datei) then
            Open(Datei,Append_File,Dateiname);
         end if;
         Put(Datei,"Turn_To ");
         Put(Datei,Grad,3,0,0);
         New_Line(Datei);
      end if;
       
   exception
      when E : others => --Fehlermeldung in Log-Datei eintragen
         if not Is_Open(Datei) then
            Open(Datei,Append_File,Dateiname);
         end if;
         New_Line(Datei);
         Put(Datei,Exception_Information(E));
         Put_Line(Datei,"Location: Procedure Draw_Turn_To");
         Close(Datei);
         
   end Draw_Turn_To;


   ---------------------------------------------------------------------------
   -- Procedure Draw_Forward                                                --
   ---------------------------------------------------------------------------
   -- Laesst die Schildkroete um Strecke vorwaerts laufen.                  --
   ---------------------------------------------------------------------------
   -- Berechnet den Endpunkt der Strecke und verbindet die beiden Punkte.   --
   ---------------------------------------------------------------------------  
   procedure Draw_Forward (Strecke : Float; Logging : Boolean) is
      X_Neu, Y_Neu : Float;
      X_Add, Y_Add : Float;   

   begin
      -- Endpunkte der Strecke berechnen
      X_Add := Cos(Winkel,360.0) * Strecke;
      Y_Add := Sin(Winkel,360.0) * Strecke;
      X_Neu := X_Wert + X_Add;
      Y_Neu := Y_Wert + Y_Add;
      
      -- Linie dahin zeichnen, wenn gezeichnet werden soll
      if Visible then
         Draw_Line(Pixmap,Get_Black (Get_Style (Drawing_Area)),
                Gint(X_Wert),Gint(Y_Wert),Gint(X_Neu),Gint(Y_Neu));
      end if;

      -- Log schreiben wenn gewuenscht
      -- Form: X_Alt Y_Alt - X_Neu Y_Neu
      if Logging then
         if not Is_Open(Datei) then
            Open(Datei,Append_File,Dateiname);
         end if;
         Put(Datei,"Forward ");
         Put(Datei,Strecke,3,0,0);
         Put(Datei," (");
         Put(Datei,To_Adalogo_Koord(X_Wert,true),3,0,0);
         Put(Datei," ");
         Put(Datei,To_Adalogo_Koord(Y_Wert,false),3,0,0);
         Put(Datei," - ");
         Put(Datei,To_Adalogo_Koord(X_Neu,true),3,0,0);
         Put(Datei," ");
         Put(Datei,To_Adalogo_Koord(Y_Neu,false),3,0,0);
         Put(Datei,")");
         New_Line(Datei);
      end if;   

      -- Endpunkte der Linie sind neuer Standpunkt
      X_Wert := X_Neu;
      Y_Wert := Y_Neu;
      
   exception
      when E : others => --Fehlermeldung in Log-Datei eintragen
         if not Is_Open(Datei) then
            Open(Datei,Append_File,Dateiname);
         end if;
         New_Line(Datei);
         Put(Datei,Exception_Information(E));
         Put_Line(Datei,"Location: Procedure Draw_Forward");
         Close(Datei);
         
   end Draw_Forward;


   ---------------------------------------------------------------------------
   -- Procedure Draw_Move_To                                                --
   ---------------------------------------------------------------------------
   -- Setz die Schildkroete auf den angegebenen Punkt.                      --
   ---------------------------------------------------------------------------
   -- Neue Koordinaten sind die uebergebenen Koordinaten, die allerdings    --
   -- vorher in das GTK-Koordinatensystem umgerechnet werden muessen.       --
   ---------------------------------------------------------------------------  
   procedure Draw_Move_To (X, Y : Float; Logging : Boolean) is
      X_Alt, Y_Alt : Float;
   begin
      
      -- Alte Werte zwischenspeichern
      X_Alt := X_Wert;
      Y_Alt := Y_Wert;

      -- Zahlen vom Adalogo-Koordinatensystem ins
      -- Gtk-Koordinatensystem umrechnen und Koordinaten setzen
      X_Wert := To_Gtk_Koord(X,true);
      Y_Wert := To_Gtk_Koord(Y,false);
            
      -- Linie von alten zu neuen Koordinaten zeichnen, falls visible
      if Visible then
         Draw_Line(Pixmap,Get_Black (Get_Style (Drawing_Area)),
                Gint(X_Alt),Gint(Y_Alt),Gint(X_Wert),Gint(Y_Wert));
      end if;

      -- Log schreiben wenn gewuenscht
      -- Format: Move_To X Y
      if Logging then
         if not Is_Open(Datei) then
            Open(Datei,Append_File,Dateiname);
         end if;   
         Put(Datei,"Move_To ");
         Put(Datei,To_Adalogo_Koord(X_Wert,true),3,0,0);
         Put(Datei," ");        
         Put(Datei,To_Adalogo_Koord(Y_Wert,false),3,0,0);
         New_Line(Datei);
      end if;

   exception
      when E : others => --Fehlermeldung in Log-Datei eintragen
         if not Is_Open(Datei) then
            Open(Datei,Append_File,Dateiname);
         end if;
         New_Line(Datei);
         Put(Datei,Exception_Information(E));
         Put_Line(Datei,"Location: Procedure Draw_Move_To");
         Close(Datei);
         
   end Draw_Move_To;


   ---------------------------------------------------------------------------
   -- Procedure Draw_Pen_Up                                                 --
   ---------------------------------------------------------------------------
   -- Nimmt den Stift vom Papier, es wird nichts sichtbar gezeichnet.       --
   ---------------------------------------------------------------------------
   -- Setzt die globale Variable Visible auf False                          --
   ---------------------------------------------------------------------------  
   procedure Draw_Pen_Up (Logging : Boolean) is
   begin
      -- Stift ist nicht mehr auf dem Papier =>
      -- Man sieht nicht mehr, was man malt
      Visible := False;
      
      -- Log schreiben wenn gewuenscht
      -- Format: Pen_Up
      if Logging then
         if not Is_Open(Datei) then
            Open(Datei,Append_File,Dateiname);
         end if;
         Put(Datei,"Pen_Up");
         New_Line(Datei);
      end if;
      
   exception
      when E : others => --Fehlermeldung in Log-Datei eintragen
         if not Is_Open(Datei) then
            Open(Datei,Append_File,Dateiname);
         end if;
         New_Line(Datei);
         Put(Datei,Exception_Information(E));
         Put_Line(Datei,"Location: Procedure Draw_Pen_Up");
         Close(Datei);
         
   end Draw_Pen_Up;


   ---------------------------------------------------------------------------
   -- Procedure Draw_Pen_Down                                               --
   ---------------------------------------------------------------------------
   -- Setzt den Stift wieder aufs Papier, so dass man sieht, was mal malt.  --
   --------------------------------------------------------------------------- 
   -- Setzt die globale Variable Visible auf True                           --
   ---------------------------------------------------------------------------  
   procedure Draw_Pen_Down (Logging : Boolean) is
   begin
      -- Stift ist wieder auf dem Papier =>
      -- Man sieht wieder, was man malt
      Visible := True;
      
      -- Log schreiben wenn gewuenscht
      -- Format: Pen_Down
      if Logging then
         if not Is_Open(Datei) then
            Open(Datei,Append_File,Dateiname);
         end if;
         Put(Datei,"Pen_Down");
         New_Line(Datei);
      end if;
      
   exception
      when E : others => --Fehlermeldung in Log-Datei eintragen
         if not Is_Open(Datei) then
            Open(Datei,Append_File,Dateiname);
         end if;
         New_Line(Datei);
         Put(Datei,Exception_Information(E));
         Put_Line(Datei,"Location: Procedure Draw_Pen_Down");
         Close(Datei);
         
   end Draw_Pen_Down;


   ---------------------------------------------------------------------------
   -- Procedure Draw_Kroete                                                 --
   ---------------------------------------------------------------------------
   -- Zeichnet die Schildkroete                                             --
   ---------------------------------------------------------------------------
   -- Die Schildkroete ist ein ausgefuellter gruener Kreis mit Nase.        --
   ---------------------------------------------------------------------------
   procedure Draw_Kroete (Logging : Boolean) is
      Radius : Gint := 10;

   begin
      -- Der Koerper der Schildkroete
      Draw_Arc (Pixmap, Get_Black (Get_Style (Drawing_Area)), False,
                Gint(X_Wert) - Radius, Gint(Y_Wert) - Radius, 
                2 * Radius, 2 * Radius, 0, 360 * 64);

      -- Die Nase der Schilkroete
      Draw_Pen_Up(false);
      Draw_Forward(10.0, false);
      Draw_Pen_Down(false);
      Draw_Forward(3.0, false);      

      -- Log schreiben wenn gewuenscht
      if Logging then
         if not Is_Open(Datei) then
            Open(Datei,Append_File,Dateiname);
         end if;
         Put(Datei,"Schildkroetle ruht sich nun hier aus.");
         Put(Datei," (");
         Put(Datei,To_Adalogo_Koord(X_Wert,true),3,0,0);
         Put(Datei," ");        
         Put(Datei,To_Adalogo_Koord(Y_Wert,false),3,0,0);
         Put(Datei," )");
         New_Line(Datei);
      end if;
      
   exception
      when E : others => --Fehlermeldung in Log-Datei eintragen
         if not Is_Open(Datei) then
            Open(Datei,Append_File,Dateiname);
         end if;
         New_Line(Datei);
         Put(Datei,Exception_Information(E));
         Put_Line(Datei,"Location: Procedure Draw_Kroete");
         Close(Datei);

   end Draw_Kroete;

     
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


   ---------------------------------------------------------------------------
   -- Procedure Empty_Drawing_Area                                          --
   ---------------------------------------------------------------------------
   -- Loescht den bisherigen Inhalt der Drawing_Area, indem ein weisses     --
   -- Rechteck dreuber gezeichnet wird.                                     --
   --------------------------------------------------------------------------- 
   procedure Empty_Drawing_Area is
      GC_White : Gdk_GC;
      Width, Height : Gint;
   begin
      Gdk_New(Gc_White, Get_Window(Drawing_Area));
      Set_Foreground(Gc_White, 
         Gdk.Color.White (Gtk.Widget.Get_Default_Colormap));
      Get_Size(Pixmap, Width, Height);
      Draw_Rectangle (Pixmap, Gc_White, True, 0, 0, Width, Height);
   end Empty_Drawing_Area;


   ---------------------------------------------------------------------------
   -- Procedure Zeichne                                                     --
   ---------------------------------------------------------------------------
   -- Prozedur, die die Warteschlange durchgeht und alles darin zeichnet.   --
   -- Auch Zoomfaktor und Offset werden beruecksichtigt.                    --
   --------------------------------------------------------------------------- 
   procedure Zeichne (Drawing_Area_Refresh : Boolean) is
      Aktion : Wastun;
      Tmpschlange : Queue := Newqueue;
      Faktor : Float := 1.0;
   begin
      
      -- Logdatei oeffnen
      if not Is_Open(Datei) then
         Open(Datei,Append_File,Dateiname);
      end if;
      
      -- Wenn noetig Drawing Area refreshen
      if Drawing_Area_Refresh then
         Empty_Drawing_Area;
      end if;

      -- Zoomfaktor bestimmen
      -- Ist der Zoomfaktor positiv, wird damit gezoomt,
      -- ist er negativ, wird 2 abgezogen (da 1 = neutral)
      -- und mit dem positiven Kehrwert gezoomt
      if Zoomfaktor > 0 then
         Faktor := Float(Zoomfaktor);                 -- Zoom in
      else Faktor := 1.0/Float(abs(Zoomfaktor - 2));  -- Zoom out
      end if;

      -- Getan-Schlange abarbeiten
      -- Wenn etwas in der Schlange drin steht, dann guck was das ist
      -- und fuehre die entsprechende Aktion durch
      -- es wird nicht ins Log geschrieben
      while not Isempty(Getan_Schlange) loop
        
         -- Hol das vorderste Element der Getan_Schlange,
         -- Loesche es dort
         -- Und fuege es in die temporaere Getan_Schlange ein
         Aktion := Getfirst (Getan_Schlange);
         Removefirst (Getan_Schlange);
         Insertlast (Aktion, Tmpschlange);

         -- Schaut, was getan werden soll und ruft die entsprechende
         -- Funktion auf, die es dann zeichnet
         case Aktion.Art is
            when Turn =>     -- Dreh dich, kleine Schildkroete
               Draw_Turn(Aktion.Wert, false);
            when Turn_To =>  -- Dreh dich dahin, kleine Schildkroete
               Draw_Turn_To(Aktion.Wert, false);
            when Forward =>  -- Lauf schon, kleine Schildkroete
               Draw_Forward(Aktion.Wert * Faktor, false);
            when Move_To =>  -- Gucksch, wo'd nalaufsch!
               Draw_Move_To((Aktion.X_Koord+X_Offset) * Faktor,
                            (Aktion.Y_Koord-Y_Offset) * Faktor, false);
            when Pen_Up =>   -- Redeverbot, kleine Schildkroete
               Draw_Pen_Up(false);                              
            when Pen_Down => -- Malen nach Zahlen
               Draw_Pen_Down(false);            
            when Reset => -- Kroetle zuruecksetzen aber kein Zoomfaktor/Offset
               -- daher nicht Draw_Turtle_Reset;
               X_Wert := Float(Breite)/2.0 + (X_Offset * Faktor);
               Y_Wert := Float(Hoehe)/2.0 + (Y_Offset * Faktor);
               Winkel := 0.0;
               Visible := True;
            when Undef => raise Adalogo_Fehler;
         end case;
                
      end loop; -- while Getan_Schlange not leer

      Getan_Schlange := TmpSchlange;

      -- To_Do-Schlange abarbeiten
      -- Wenn etwas in der Schlange drin steht, dann guck was das ist
      -- und fuehre die entsprechende Aktion durch
      -- Alles wird ins Log eingetragen
      while not Isempty(To_Do_Schlange) loop
        
         -- Hol das vorderste Element der To_Do_Schlange,
         -- Loesche es dort
         -- Und fuege es in die Getan_Schlange ein
         Aktion := Getfirst (To_Do_Schlange);
         Removefirst (To_Do_Schlange);
         Insertlast (Aktion, Getan_Schlange);
      
         -- Schaut, was getan werden soll und ruft die entsprechende
         -- Funktion auf, die es dann zeichnet
         case Aktion.Art is
            when Turn =>     -- Dreh dich, kleine Schildkroete
               Draw_Turn(Aktion.Wert, true);
            when Turn_To =>  -- Dreh dich dahin, kleine Schildkroete
               Draw_Turn_To(Aktion.Wert, true);
            when Forward =>  -- Lauf schon, kleine Schildkroete
               Draw_Forward(Aktion.Wert * Faktor,true);
            when Move_To =>  -- Gucksch, wo'd nalaufsch!
               Draw_Move_To((Aktion.X_Koord+X_Offset) * Faktor,
                            (Aktion.Y_Koord-Y_Offset) * Faktor, true);
            when Pen_Up =>   -- Redeverbot, kleine Schildkroete
               Draw_Pen_Up(true);                              
            when Pen_Down => -- Malen nach Zahlen
               Draw_Pen_Down(true);            
            when Reset => -- Kroetle zuruecksetzen aber kein Zoomfaktor/Offset
               -- daher nicht Draw_Turtle_Reset;
               X_Wert := Float(Breite)/2.0 + (X_Offset * Faktor);
               Y_Wert := Float(Hoehe)/2.0 + (Y_Offset * Faktor);
               Winkel := 0.0;
               Visible := True;
            when Undef => raise Adalogo_Fehler;
         end case;

      end loop; -- To_Do-Schlange

      -- Die Schildkroete dahin zeichnen, wo sie angekommen ist
      Draw_Kroete(true);

      -- Refresh der Drawing Area
      Draw(Drawing_Area);

      -- Logeintrag : Ich bin fertig!
      if not Is_Open(Datei) then
         Open(Datei,Append_File,Dateiname);
      end if;
      Put(Datei,"Zeichnen beendet");
      Close(Datei);

           
   exception
      when E : others => -- Fehlermeldung in Log-Datei eintragen
         if not Is_Open(Datei) then
            Open(Datei,Append_File,Dateiname);
         end if;
         New_Line(Datei);
         Put(Datei,Exception_Information(E));
         Put_Line(Datei,"Location: Procedure Zeichne");
         Close(Datei);
         
   end Zeichne;


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   ---------------------------------------------------------------------------
   -- Procedure Einfuegen                                                   --
   ---------------------------------------------------------------------------
   -- Fuegt das uebergebene Element in die To_Do_Schlange ein.              --
   --------------------------------------------------------------------------- 
   procedure Einfuegen (Element : Wastun) is
   begin
      Insertlast(Element, To_Do_Schlange);

   exception
      when E : others => -- Fehlermeldung in Log-Datei eintragen
         if not Is_Open(Datei) then
            Open(Datei,Append_File,Dateiname);
         end if;
         New_Line(Datei);
         Put(Datei,Exception_Information(E));
         Put_Line(Datei,"Location: Procedure Einfuegen");
         Close(Datei);
   end Einfuegen;
   
      

   ---------------------------------------------------------------------------
   -- Procedure Start                                                       --
   ---------------------------------------------------------------------------
   -- Startet den ganzen Zeichenkrust, dies wird von aussen aufgerufen.     --
   --------------------------------------------------------------------------- 
   -- Erzeugt die Logdatei, ruft das Parsen der Adalogo-Source-Datei auf,   --
   -- laesst das geparste Zeichnen.                                         --
   ---------------------------------------------------------------------------
   procedure Start is
   begin
      
      -- Oeffnet das grafische Fenster mit der Drawing_Area
      Init;
      
      -- Zeichnet die Liste (in der sollte ja schon alles drinstehen)
      Zeichne(true);

      -- Waiting for something interesting to happen
      Gtk.Main.Main;

   exception  
      when E : Device_Error => -- Fehlermeldung in Log-Datei eintragen
         if not Is_Open(Datei) then
            Open(Datei,Append_File,Dateiname);
         end if;
         New_Line(Datei);
         Put(Datei,Exception_Information(E));
         Put_Line(Datei,"Hier ist noch irgendwo ein dummes Put!");
         Put_Line(Datei,"Fatal Error - Quitting");
         Close(Datei);
         raise Adalogo_Fehler;

      when E : others => -- Fehlermeldung in Log-Datei eintragen
         if not Is_Open(Datei) then
            Open(Datei,Append_File,Dateiname);
         end if;
         New_Line(Datei);
         Put(Datei,Exception_Information(E));
         Put_Line(Datei,"Location: Adalogo_Gtk");
         Close(Datei);
      
   end Start;


end Adalogo_gtk;
