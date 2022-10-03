
Program INSAtram;

Uses Unit_Logic, Unit_Graphics, Unit_Types, sdl_image, sdl;

Var Game : Type_Game;
    Station_Pointer : Type_Station_Pointer;
    Timer : Type_Time;

Begin

  Graphics_Load(Game);

  Station_Pointer := Creer_Station();


  While true Do
    Begin

      Timer := Time_Get_Current();

      Station_Display(Station_Pointer^, Game);

      Graphics_Refresh(Game);


      If Time_Get_Elapsed(Timer) < 1000/60 Then
        Begin
          SDL_Delay(20);
        End;


    End;
End.
