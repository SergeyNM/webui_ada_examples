--  Call JavaScript from Ada Example
--  https://webui.me/
--
--  Based on example for C
--  webui/examples/C/call_js_from_c/main.c

with Ada.Text_IO;
with Interfaces.C;

with Webui;

procedure Call_JS_From_Ada is
   package T_IO renames Ada.Text_IO;
   package C renames Interfaces.C;
   use all type Webui.Browser_Kind;
   use type C.C_bool;

   --  Nested procedures : begin
   --
   --  Close all opened windows
   procedure My_Procedure_Exit (E : access Webui.Event_t) is
      pragma Unreferenced (E);  --  GNAT RM
   begin
      Webui.Exit_All;
   end My_Procedure_Exit;

   --  This procedure gets called every time the user clicks on
   --   "my_function_count"
   procedure My_Procedure_Count (E : access Webui.Event_t) is
      --  Response : String (1 .. 63) := (others => '0');
      --  Response : array (0 .. 63) of Interfaces.C.char;
      --
      --  Create a buffer to hold the response
      --  char response[64];
      --  Response : C.char_array (0 .. 63);
      Response : C.char_array (0 .. 63) :=
        (others => C.To_C (Item => ASCII.NUL));
      --  Response : C.char_array :=
      --    (0 .. 63 => C.To_C (Item => ASCII.NUL));
   begin
      --  Run JavaScript
      --
      --  if not Webui.Script (E.window, "return GetCount();", 0,
      --   Response) then
      --  if not Webui.Script_2 (E.window, "return GetCount();", 0,
      --                         C_Str.To_Chars_Ptr (Response'Access), 64) then
      if not Webui.Script
        (E.window, "return GetCount();", 0, Response)
      then
         if not Webui.Is_Shown (E.window) then
            T_IO.Put_Line ("Window closed.");
         else
            T_IO.Put_Line ("JavaScript Error: " & C.To_Ada (Response));
         end if;
         return;
      end if;

      Counting :
      declare
         Count : Integer;
      begin
         --  Memo:
         --  https://rosettacode.org/wiki/Determine_if_a_string_is_numeric#Ada
         --  (https://craftofcoding.wordpress.com/2018/03/27/
         --  coding-ada-using-an-exception/)
         --
         --  Get the count
         --  int count = atoi(response);
         Count := Integer'Value (C.To_Ada (Response));
         --  Increment
         Count := Count + 1;

         Run_JS :
         declare
            --  Generate a JavaScript
            --  char js[64];
            --  sprintf(js, "SetCount(%d);", count);
            JS : constant String := "SetCount(" & Count'Image & ");";
         begin
            --  Run JavaScript (Quick Way)
            Webui.Run (E.window, JS);
         end Run_JS;

      exception
         when Constraint_Error =>
            T_IO.Put_Line ("Constraint_Error exception and Response is: " &
                             C.To_Ada (Response));
            return;

      end Counting;
   end My_Procedure_Count;
   --
   --  Nested procedures : end

   aWindow   : Webui.Window_Identifier;
   Temp_Bind : Webui.Bind_Identifier;
begin
   --  Create a window
   aWindow := Webui.New_Window;

   --  # Set_Root_Folder:
   --  TODO: Root Folder configuration variable
   --
   if Webui.Set_Root_Folder (aWindow, "../src/") then
   --  if Webui.Set_Root_Folder
   --   (aWindow,
   --   "/home/<user>/Projects/ada_webui_examples/src") then
      T_IO.Put_Line ("Root Folder is set.");
   else
      T_IO.Put_Line ("Root Folder is Not set. Check route to Root Folder.");
      raise Program_Error
        with "Root Folder is Not set. Check route to Root Folder.";
   end if;

   --  Bind HTML elements with Ada subprograms
   Temp_Bind :=
     Webui.Bind (aWindow, "my_function_count", My_Procedure_Count'Access);
   T_IO.Put_Line ("Temp_Bind is: " & Temp_Bind'Image);
   Temp_Bind :=
     Webui.Bind (aWindow, "my_function_exit", My_Procedure_Exit'Access);
   T_IO.Put_Line ("Temp_Bind is: " & Temp_Bind'Image);

   --  Show the window
   --  if Webui.Show (aWindow, "/call_js_from_ada/index_js_ada.html")
   --  Firefox ^ (in my environment)
   if Webui.Show_Browser
     (aWindow, "/call_js_from_ada/index_js_ada.html", Webui.Chromium)
     --  Webui.Browser'(Chromium))
   then
      T_IO.Put_Line ("Visible");
   else
      T_IO.Put_Line ("Invisible");
   end if;

   --  Wait until all windows get closed
   Webui.Wait;

   --  Free all memory resources (Optional)
   Webui.Clean;

end Call_JS_From_Ada;
