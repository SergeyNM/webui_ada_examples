--  Call Ada from JavaScript Example
--  https://webui.me/
--
--  Based on example for C
--  webui/examples/C/call_c_from_js/main.c

with Ada.Text_IO;
with Interfaces.C;

with Webui;

procedure Call_Ada_From_JS is
   package T_IO renames Ada.Text_IO;
   package C renames Interfaces.C;
   use all type Webui.Browser_Kind;

   --  Nested procedures : begin
   --
   procedure My_Procedure_String (E : access Webui.Event_t) is
      Str_1 : constant String := Webui.Get_String (E);
      Str_2 : constant String := Webui.Get_String_At (E, 1);
   begin
      --  JavaScript:
      --  my_function_string('Hello', 'World`);

      --  const char * str_1 = webui_get_string (e);
      --  // Or webui_get_string_at(e, 0);
      --  const char * str_2 = webui_get_string_at (e, 1);
      --
      --  printf ("my_function_string 1: %s\n", str_1);  --  Hello
      --  printf ("my_function_string 2: %s\n", str_2);  --  World

      T_IO.Put_Line ("my_function_string 1: " & Str_1);
      T_IO.Put_Line ("my_function_string 2: " & Str_2);
   end My_Procedure_String;

   procedure My_Procedure_Integer (E : access Webui.Event_t) is
      Count : C.size_t;
      Number_1, Number_2, Number_3 : Long_Long_Integer;
      Float_1 : Long_Float;
   begin
      --  JavaScript:
      --  my_function_integer(123, 456, 789, 12345.6789);

      --  size_t count = webui_get_count (e);
      --  printf ("my_function_integer: There is
      --   %zu arguments in this event\n", count);  --  4
      Count := Webui.Get_Count (E);
      T_IO.Put_Line ("my_function_integer: There is " & Count'Image
                     & " arguments in this event");

      --  long long number_1 = webui_get_int (e);
      --  // Or webui_get_int_at(e, 0);
      --  long long number_2 = webui_get_int_at (e, 1);
      --  long long number_3 = webui_get_int_at (e, 2);
      --
      --  printf ("my_function_integer 1: %lld\n", number_1);  --  123
      --  printf ("my_function_integer 2: %lld\n", number_2);  --  456
      --  printf ("my_function_integer 3: %lld\n", number_3);  --  789
      Number_1 := Webui.Get_Int (E);   --  Or webui_get_int_at(e, 0);
      Number_2 := Webui.Get_Int_At (E, 1);
      Number_3 := Webui.Get_Int_At (E, 2);

      T_IO.Put_Line ("my_function_integer 1: " & Number_1'Image);
      T_IO.Put_Line ("my_function_integer 2: " & Number_2'Image);
      T_IO.Put_Line ("my_function_integer 3: " & Number_3'Image);

      --  double float_1 = webui_get_float_at (e, 3);
      --  printf ("my_function_integer 4: %f\n", float_1);  --  12345.6789
      Float_1 := Webui.Get_Float_At (E, 3);
      T_IO.Put_Line ("my_function_integer 4: " & Float_1'Image);
   end My_Procedure_Integer;

   procedure My_Procedure_Boolean (E : access Webui.Event_t) is
      Status_1 : Boolean;
      Status_2 : Boolean;
   begin
      --  JavaScript:
      --  my_function_boolean(true, false);

      --  bool status_1 = webui_get_bool(e); // Or webui_get_bool_at(e, 0);
      --  bool status_2 = webui_get_bool_at(e, 1);
      Status_1 := Webui.Get_Bool (E);
      Status_2 := Webui.Get_Bool_At (E, 1);

      --  printf("my_function_boolean 1: %s\n",
      --   (status_1 ? "True" : "False")); // True
      --  printf("my_function_boolean 2: %s\n",
      --   (status_2 ? "True" : "False")); // False
      T_IO.Put_Line ("my_function_boolean 1: " & Status_1'Image);
      T_IO.Put_Line ("my_function_boolean 2: " & Status_2'Image);
   end My_Procedure_Boolean;

   procedure My_Procedure_Raw_Binary (E : access Webui.Event_t) is
   begin
      --  JavaScript:
      --  my_function_raw_binary(new Uint8Array([0x41]), new Uint8Array([0x42, 0x43]));

      --  const unsigned char* raw_1 = (const unsigned char*)webui_get_string(e); // Or webui_get_string_at(e, 0);
      --  const unsigned char* raw_2 = (const unsigned char*)webui_get_string_at(e, 1);
      --
      --  int len_1 = (int)webui_get_size(e); // Or webui_get_size_at(e, 0);
      --  int len_2 = (int)webui_get_size_at(e, 1);

      --  Print raw_1
      --  printf("my_function_raw_binary 1 (%d bytes): ", len_1);
      --  for (size_t i = 0; i < len_1; i++)
      --    printf("0x%02x ", raw_1[i]);
      --  printf("\n");

      --  Check raw_2 (Big)
      --  [0xA1, 0x00..., 0xA2]
      --  bool valid = false;
      --  if (raw_2[0] == 0xA1 && raw_2[len_2 - 1] == 0xA2)
      --    valid = true;

      --  Print raw_2
      --  printf("my_function_raw_binary 2 big (%d bytes): valid data? %s\n", len_2, (valid ? "Yes" : "No"));
      null;
   end My_Procedure_Raw_Binary;

   procedure My_Procedure_With_Response (E : access Webui.Event_t) is
      Number, Times, Res : Long_Long_Integer;
   begin
      --  JavaScript:
      --  my_function_with_response(number, 2).then(...)

      --  long long number = webui_get_int(e); // Or webui_get_int_at(e, 0);
      --  long long times = webui_get_int_at(e, 1);
      Number := Webui.Get_Int (E);
      Times := Webui.Get_Int_At (E, 1);

      --  long long res = number * times;
      --  printf("my_function_with_response: %lld * %lld = %lld\n",
      --   number, times, res);
      Res := Number * Times;
      T_IO.Put_Line ("my_function_with_response: " &
                       Number'Image & " * " & Times'Image & " = " & Res'Image);

      --  Send back the response to JavaScript
      Webui.Return_Int (E, Res);
   end My_Procedure_With_Response;
   --
   --  Nested procedures : end

   aWindow : Webui.Window_Identifier;
   Temp_Bind : Webui.Bind_Identifier;
begin
   --  Create a window
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

   --  Bind HTML elements with Ada subprograms
   Temp_Bind := Webui.Bind (aWindow, "my_function_string",
                            My_Procedure_String'Access);
   Temp_Bind := Webui.Bind (aWindow, "my_function_integer",
                            My_Procedure_Integer'Access);
   Temp_Bind := Webui.Bind (aWindow, "my_function_boolean",
                            My_Procedure_Boolean'Access);
   Temp_Bind := Webui.Bind (aWindow, "my_function_with_response",
                            My_Procedure_With_Response'Access);
   Temp_Bind := Webui.Bind (aWindow, "my_function_raw_binary",
                            My_Procedure_Raw_Binary'Access);

   --  Show the window
   --  if Webui.Show (aWindow, "/call_ada_from_js/index_ada_js.html")
   if Webui.Show_Browser
     (aWindow, "/call_ada_from_js/index_ada_js.html",
      --  Webui.Browser_Kind'(Chromium))
      Webui.Chromium)
   then
      T_IO.Put_Line ("Visible");
   else
      T_IO.Put_Line ("Invisible");
   end if;

   --  Wait until all windows get closed
   Webui.Wait;

   --  Free all memory resources (Optional)
   Webui.Clean;

end Call_Ada_From_JS;
