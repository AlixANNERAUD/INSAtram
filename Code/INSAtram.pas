
Program INSAtram;

//Unit_Logic, Unit_Graphics, Unit_Types,

Uses sysutils, Unit_Types, Unit_Mouse, Unit_Graphics, Unit_Logic, sdl_image, sdl, sdl_gfx;

Var Game : Type_Game;
  Timer : Type_Time;
  Quit : Boolean;
  Event : TSDL_Event;
  Color : Type_Color;

Begin

  Logic_Load(Game);
  Mouse_Load(Game);
  Graphics_Load(Game);

  Quit := False;

  While (Not(Quit)) Do
    Begin

      Timer := Time_Get_Current();


      Logic_Refresh(Game);

      Graphics_Refresh(Game);

      // Limit fps to 60.
      If (Time_Get_Elapsed(Timer) < 1000/60) Then
        Begin
          SDL_Delay((1000 Div 60) - Time_Get_Elapsed(Timer));
        End;
    End;

  Graphics_Unload(Game);

End.
