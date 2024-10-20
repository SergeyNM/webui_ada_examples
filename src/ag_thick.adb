--  also see ag_grid.adb

with Ada.Directories, Ada.Text_IO;
with Ada.Sequential_IO;

with Webui;

procedure Ag_Thick is
   package Dirs renames Ada.Directories;
   package T_IO renames Ada.Text_IO;
   use all type Webui.Browser_Kind;

   File_Name : constant String  := "../src/ag_grid_index.html";
   File_Size : constant Natural := Natural (Dirs.Size (File_Name));

   subtype File_String is String (1 .. File_Size);
   package File_String_IO is new Ada.Sequential_IO (File_String);
   File     : File_String_IO.File_Type;
   Contents : File_String;

   aWindow : Webui.Window_Identifier;

begin
   File_String_IO.Open
     (File, Mode => File_String_IO.In_File, Name => File_Name);
   File_String_IO.Read (File, Item => Contents);
   File_String_IO.Close (File);

   T_IO.Put (Contents);
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
   if Webui.Show_Browser (aWindow, Contents, Webui.Browser_Kind'(Chromium))
   then
      T_IO.Put_Line ("Visible");
   else
      T_IO.Put_Line ("Invisible");
   end if;

   Webui.Wait;

end Ag_Thick;
