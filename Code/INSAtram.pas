
Program INSAtram;

//Unit_Logic, Unit_Graphics, Unit_Types,

Uses Unit_Types, Unit_Mouse, Unit_Graphics, Unit_Logic, sdl_image, sdl;

Var Game : Type_Game;
  Timer : Type_Time;
  i : Byte;
  Quit : Boolean;
  Event : TSDL_Event;
  Coord : Type_Coordinates;
  Angle : Real;

Begin



  Logic_Load(Game);
  Graphics_Load(Game);
  Mouse_Load();


  //For i := 0 To 20 Do
  // Begin
  //    Passenger_Create(Game);
  //    Graphics_Refresh(Game);
  //  End;

        //For i := 0 To 10 Do
      //  Begin
          Station_Create(Game);
          Station_Create(Game);
      //    Graphics_Refresh(Game);
      //  End;


  Quit := False;

  While (Not(Quit)) Do
    Begin

      Timer := Time_Get_Current();

      SDL_PollEvent(@Event);


      If (Event.type_ = SDL_QUITEV) Then
        Quit := True
      Else If (Event.type_ = SDL_MOUSEBUTTONDOWN) Then
             writeln('Mouse Button Down');

    
      Coord := Mouse_Get_Position();

      Angle := Graphics_Get_Angle(Game.Stations[0]^.Coordinates, Coord);
      writeln('Angle: ', Angle);

      Graphics_Refresh(Game);

      // Limit fps to 60.
      If (Time_Get_Elapsed(Timer) < 1000/60) Then
        Begin
          SDL_Delay((1000 Div 60) - Time_Get_Elapsed(Timer));
        End;
    End;

  Graphics_Unload(Game);

End.
