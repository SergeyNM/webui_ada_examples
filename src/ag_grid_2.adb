--  Ada WebUI and AG Grid
--  https://webui.me/
--  https://www.ag-grid.com/javascript-data-grid/getting-started/

with Ada.Directories, Ada.Text_IO;
with Ada.Sequential_IO;
with Interfaces.C.Strings;
with Interfaces.C.Extensions;

with Webui;

procedure Ag_Grid_2 is
   package Dirs renames Ada.Directories;
   package T_IO renames Ada.Text_IO;
   package C_Str renames Interfaces.C.Strings;
   package C_Exts renames Interfaces.C.Extensions;
   use all type Webui.Browser_Kind;

   --  FIXME: https://rosettacode.org/wiki/Read_entire_file#Ada
   --  This kind of solution is limited a bit by the fact that the GNAT
   --   implementation of Ada.Direct_IO first allocates a copy of the read
   --   object on the stack inside Ada.Direct_IO.Read. On Linux you can use
   --   the command "limit stacksize 1024M" to increase the available stack
   --   for your processes to 1Gb, which gives your program more freedom to
   --   use the stack for allocating objects.
   File_Name : constant String  := "../src/ag_grid_2_index.html";
   File_Size : constant Natural := Natural (Dirs.Size (File_Name));

   subtype File_String is String (1 .. File_Size);
   package File_String_IO is new Ada.Sequential_IO (File_String);
   File     : File_String_IO.File_Type;
   Contents : File_String;

   Result_Name : constant String  := "../src/ag_grid_2.json";
   Result_Size : constant Natural := Natural (Dirs.Size (Result_Name));

   subtype Result_String is String (1 .. Result_Size);
   package Result_String_IO is new Ada.Sequential_IO (Result_String);
   Result_File     : Result_String_IO.File_Type;
   Result_Contents : Result_String;

   aWindow : Interfaces.C.size_t;
   Is_Well : C_Exts.bool;

begin
   File_String_IO.Open
     (File, Mode => File_String_IO.In_File, Name => File_Name);
   File_String_IO.Read (File, Item => Contents);
   File_String_IO.Close (File);

   T_IO.Put (Contents);
   T_IO.New_Line;

   Result_String_IO.Open
     (Result_File, Mode => Result_String_IO.In_File, Name => Result_Name);

   Result_String_IO.Read (Result_File, Item => Result_Contents);
   Result_String_IO.Close (Result_File);

   T_IO.Put (Result_Contents);
   T_IO.New_Line;

   aWindow := Webui.New_Window;

   --  # Set_Root_Folder:
   --  TODO: Root Folder configuration variable
   if Webui.Set_Root_Folder (aWindow, C_Str.New_String ("../src/")) then
      T_IO.Put_Line ("Root Folder is set.");
   else
      T_IO.Put_Line ("Root Folder is Not set. Check route to Root Folder.");
      raise Program_Error
        with "Root Folder is Not set. Check route to Root Folder.";
   end if;

   --  # Show_Browser:
   Is_Well :=
     Webui.Show_Browser
   --  (aWindow, C_Str.New_String (Contents),
   --   Webui.Browser_Kind'Pos (Firefox));
     (aWindow, C_Str.New_String (Contents),
      Webui.Browser_Kind'Pos (Chromium));
   if Is_Well then
      T_IO.Put_Line ("Visible");
   else
      T_IO.Put_Line ("Invisible");
   end if;

   Webui.Set_Timeout (60);
   Is_Well := Webui.Show (aWindow, C_Str.New_String (Contents));

   Webui.Send_Raw
     (Window => aWindow, JS_Func => C_Str.New_String ("agGridCreate"),
      raw    => Result_Contents'Address,
      size   => Interfaces.C.size_t (Result_Contents'Length));

   Webui.Wait;

end Ag_Grid_2;
