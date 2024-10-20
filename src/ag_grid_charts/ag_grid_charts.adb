--  Ada WebUI and AG Grid, AG Charts
--  https://webui.me/
--  https://www.ag-grid.com/javascript-data-grid/getting-started/
--  https://charts.ag-grid.com/react/quick-start/

with Ada.Text_IO;
with Ada.Directories, Ada.Sequential_IO;

with Webui;

procedure Ag_Grid_Charts is
   package Dirs renames Ada.Directories;
   package T_IO renames Ada.Text_IO;
   use all type Webui.Browser_Kind;

   Result_Name : constant String := "../src/ag_grid_charts/ag_grid.json";
   Result_Size : constant Natural := Natural (Dirs.Size (Result_Name));

   subtype Result_String is String (1 .. Result_Size);
   package Result_String_IO is new Ada.Sequential_IO (Result_String);
   Result_File : Result_String_IO.File_Type;
   Result_Contents : Result_String;

   aWindow : Webui.Window_Identifier;

begin
   Result_String_IO.Open
     (Result_File, Mode => Result_String_IO.In_File, Name => Result_Name);

   Result_String_IO.Read (Result_File, Item => Result_Contents);
   Result_String_IO.Close (Result_File);

   T_IO.Put (Result_Contents);
   T_IO.New_Line;

   aWindow := Webui.New_Window;

   --  # Set_Root_Folder:
   --  TODO: Root Folder configuration variable
   if Webui.Set_Root_Folder (aWindow, "../src/") then
      T_IO.Put_Line ("Root Folder is set.");
   else
      T_IO.Put_Line ("Root Folder is Not set. Check route to Root Folder.");
      raise Program_Error
        with "Root Folder is Not set. Check route to Root Folder.";
   end if;

   --  # Show_Browser:
   if Webui.Show_Browser
     (aWindow, "/ag_grid_charts/ag_index.html",
      Webui.Browser_Kind'(Chromium))
   then
      T_IO.Put_Line ("Visible");
   else
      T_IO.Put_Line ("Invisible");
   end if;

   --  FIXME: Problem with synchronization?
   --   Perhaps the page is in the process of loading and is not ready yet,
   --   and we are calling a JS_Func?
   --   Or after Webui.Show_Browser do not immediately call Webui.Show?
   --
   --  FIXME: Workarround
   --  delay 0.1;
   delay 0.5;  --  set more duration for slow computer?
   --
   --  Webui.Set_Timeout (60);
   --  Is_Well :=
   --    Webui.Show
   --  (aWindow, C_Str.New_String ("/ag_grid_charts/ag_index.html"));

   Webui.Send_Raw
     (Window => aWindow, JS_Func => "createGrid", Raw => Result_Contents);

   Webui.Wait;

end Ag_Grid_Charts;
