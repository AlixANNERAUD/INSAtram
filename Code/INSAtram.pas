
Program INSAtram;

//Unit_Logic, Unit_Graphics, Unit_Types,

Uses sysutils, Unit_Types, Unit_Mouse, Unit_Graphics, Unit_Logic, sdl_image, sdl, sdl_gfx;

Var Game : Type_Game;
  Timer : Type_Time;
  i, j : Byte;
  Quit : Boolean;
  Event : TSDL_Event;
  Mouse_Position : Type_Coordinates;
  Color : Type_Color;

Begin


  Color.Red := 0;
  Color.Green := 0;
  Color.Blue := 0;
  Color.Alpha := 255;

  Logic_Load(Game);

  Graphics_Load(Game);


  Mouse_Load();


  Line_Create(Color, Game);
  For i := 0 To 4 Do
    Begin
      Station_Create(Game);
    End;

  For i := low(Game.Stations) To high(Game.Stations) Do
    Begin
      For j := 0 To Random(5) Do
        Begin
          Passenger_Create(Game.Stations[i], Game);
        End;
      Line_Add_Station(@Game.Stations[i], Game.Lines[0]);
      
    End;



  Train_Create(Game.Lines[0].Stations[0], true, Game.Lines[0], Game);

  Game.Lines[0].Trains[0].Next_Station := Game.Lines[0].Stations[1];

  Game.Lines[0].Trains[0].Distance := 0;

  {For i := 0 To 2 Do
    Begin
      Passenger_Create(Game);
    End;
}

  Quit := False;

  While (Not(Quit)) Do
    Begin

      Timer := Time_Get_Current();

      SDL_PollEvent(@Event);


      If (Event.type_ = SDL_QUITEV) Then
        Quit := True
      Else If ((Event.type_ = SDL_MOUSEBUTTONDOWN)) Then
             Begin
               Label_Set_Text(Game.Score_Label, IntToStr(Game.Lines[0].Trains[0].Distance));
               inc(Game.Lines[0].Trains[0].Distance);
               inc(Game.Lines[0].Trains[0].Distance);
               inc(Game.Lines[0].Trains[0].Distance);

               //Quit := True;
             End;

      Mouse_Position := Mouse_Get_Position();


      Graphics_Refresh(Game);

      Logic_Refresh(Game);

      //inc(Game.Lines[0].Trains[0]^.Distance);




      // Limit fps to 60.
      If (Time_Get_Elapsed(Timer) < 1000/60) Then
        Begin
          SDL_Delay((1000 Div 60) - Time_Get_Elapsed(Timer));
        End;
    End;

  Graphics_Unload(Game);

End.
