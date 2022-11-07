
Program INSAtram;

//Unit_Logic, Unit_Graphics, Unit_Types,

Uses Unit_Types, Unit_Mouse, Unit_Graphics, Unit_Logic, sdl_image, sdl, sdl_gfx;

Var Game : Type_Game;
  Timer : Type_Time;
  i : Byte;
  Quit : Boolean;
  Event : TSDL_Event;
  Mouse_Position : Type_Coordinates;
  Color : Type_Color;

Begin



  Logic_Load(Game);
  Graphics_Load(Game);
  Mouse_Load();



  For i := 0 To 9 Do
    Begin
      Station_Create(Game);
    End;


  For i := 0 To 19 Do
    Begin
      Passenger_Create(Game);
    End;


  Quit := False;

  Color.Red := 255;
  Color.Green := 0;
  Color.Blue := 0;
  Color.Alpha := 255;

  While (Not(Quit)) Do
    Begin

      Timer := Time_Get_Current();

      SDL_PollEvent(@Event);


      If (Event.type_ = SDL_QUITEV) Then
        Quit := True
      Else If (Event.type_ = SDL_MOUSEBUTTONDOWN) Then
             Begin
               writeln('Mouse Button Down');
               Quit := True;
             End;

      Mouse_Position := Mouse_Get_Position();







      Graphics_Refresh(Game);

      // Limit fps to 60.
      If (Time_Get_Elapsed(Timer) < 1000/60) Then
        Begin
          SDL_Delay((1000 Div 60) - Time_Get_Elapsed(Timer));
        End;
    End;

  Graphics_Unload(Game);

End.
