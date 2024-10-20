with Ada.Text_IO;
with Interfaces.C.Strings;
with Interfaces.C.Extensions;

with Webui;

procedure Hello is
   package T_IO renames Ada.Text_IO;
   --  package C renames Interfaces.C;
   package C_Str renames Interfaces.C.Strings;
   package C_Exts renames Interfaces.C.Extensions;
   use all type Webui.Browser_Kind;

   aWindow : Interfaces.C.size_t;
   Is_Well : C_Exts.bool;
begin
   aWindow := Webui.New_Window;

   --  # Show_Browser:
   --  Is_Well := Webui.Show
   --    (aWindow,
   --     C_Str.New_String
   --       ("<html><head><script src=""webui.js""></script>
   --  </head> Hello Ada World ! </html>"));
   Is_Well :=
     Webui.Show_Browser
       (aWindow,
        C_Str.New_String
          ("<html><head><script src=""webui.js""></script>"
           & "</head> Hello Ada World ! </html>"),
        Webui.Browser_Kind'Pos (Chromium));
   if Is_Well then
         T_IO.Put_Line ("Visible");
   else
         T_IO.Put_Line ("Invisible");
   end if;

   --  FIXME: How to use log.
   Webui.Run (aWindow, C_Str.New_String ("webui.setLogging(true);"));
   Webui.Run (aWindow,
              C_Str.New_String ("console.log(""Hello Ada World!"");"));
   --  FIXME: Why dont work?
   Webui.Run (aWindow, C_Str.New_String ("alert('Hello Ada World!');"));

   Webui.Wait;

end Hello;
