--  Ada WebUI and AG Charts
--  https://webui.me/
--  https://charts.ag-grid.com/react/quick-start/

with Ada.Directories, Ada.Text_IO;
with Ada.Sequential_IO;
--  with Interfaces.C;
with Interfaces.C.Strings;
with Interfaces.C.Extensions;

with Webui;

procedure Ag_Charts is
   package Dirs renames Ada.Directories;
   package T_IO renames Ada.Text_IO;
   --  package C renames Interfaces.C;
   package C_Str renames Interfaces.C.Strings;
   package C_Exts renames Interfaces.C.Extensions;
   use all type Webui.Browser_Kind;
   --  use type C_Ext.bool;

   --  F : T_IO.File_Type;
   --  FIXME: https://rosettacode.org/wiki/Read_entire_file#Ada
   --  This kind of solution is limited a bit by the fact that the GNAT
   --   implementation of Ada.Direct_IO first allocates a copy of the read
   --   object on the stack inside Ada.Direct_IO.Read. On Linux you can use
   --   the command "limit stacksize 1024M" to increase the available stack
   --   for your processes to 1Gb, which gives your program more freedom to
   --   use the stack for allocating objects.
   File_Name : constant String  := "../src/ag_charts_index.html";
   File_Size : constant Natural := Natural (Dirs.Size (File_Name));
   --  Contents : String (1 .. File_Size);

   subtype File_String is String (1 .. File_Size);
   package File_String_IO is new Ada.Sequential_IO (File_String);
   File     : File_String_IO.File_Type;
   Contents : File_String;

   aWindow : Interfaces.C.size_t;
   Is_Well : C_Exts.bool;

   --  FIXME: Include html file. Add the JavaScript.
   --  https://www.w3schools.com/howto/howto_html_include.asp
   --  (https://www.tutorialspoint.com/
   --  how-to-include-another-html-file-in-an-html-file)

begin
   --  T_IO.Open (F, T_IO.In_File, File_Name);
   --  while not T_IO.End_Of_File (F) loop
   --     T_IO.Put_Line (T_IO.Get_Line (F));
   --  end loop;
   --  T_IO.Put_Line (Contents'Length'Image);
   --  --  FIXME: raised ADA.IO_EXCEPTIONS.END_ERROR
   --  --  T_IO.Get (F, Contents);
   --  --  T_IO.Put (Contents);
   --  T_IO.Close (F);
   --  T_IO.New_Line;

   File_String_IO.Open
     (File, Mode => File_String_IO.In_File, Name => File_Name);
   File_String_IO.Read (File, Item => Contents);
   File_String_IO.Close (File);

   T_IO.Put (Contents);
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
   (aWindow, C_Str.New_String (Contents), Webui.Browser_Kind'Pos (Chromium));
   --  Is_Well := Webui.Show (aWindow, C_Str.New_String (Html));
   if Is_Well then
      T_IO.Put_Line ("Visible");
   else
      T_IO.Put_Line ("Invisible");
   end if;

   Webui.Wait;

end Ag_Charts;
