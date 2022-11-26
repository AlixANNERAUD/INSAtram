
Program INSAtram;

//Unit_Logic, Unit_Graphics, Unit_Types,

Uses sysutils, Unit_Types, Unit_Mouse, Unit_Graphics, Unit_Logic, sdl_image, sdl, sdl_gfx;

Var Game : Type_Game;
  Timer : Type_Time;

Begin

  Graphics_Load(Game);
  Logic_Load(Game);
  Mouse_Load(Game);

  While (Not(Game.Quit)) Do
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

  Logic_Unload(Game);

End.
