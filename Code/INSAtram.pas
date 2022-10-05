
Program INSAtram;

//Unit_Logic, Unit_Graphics, Unit_Types,

Uses Unit_Types, Unit_Graphics, Unit_Logic, sdl_image, sdl;

Var Game : Type_Game;
  Station_Pointer : Type_Station_Pointer;
  Timer : Type_Time;
  i : Byte;
  Quit : Boolean;
  Event : TSDL_Event;

Begin

  Randomize();

  Quit := False;

  While (Not(Quit)) Do
    Begin

      SDL_PollEvent(@Event);


      if (Event.type_ = SDL_QUITEV) Then
          Quit := True
      else if (Event.type_ = SDL_MOUSEBUTTONDOWN) Then
          writeln('Mouse Button Down');


      Logic_Load(Game);
      Graphics_Load(Game);

      For i := 0 To 10 Do
        Begin
          Station_Create(Game);
          Graphics_Refresh(Game);
        End;

      //For i := 0 To 20 Do
      //  Begin
      //    Passenger_Create(Game);
      //    Graphics_Refresh(Game);
      //  End;


      SDL_Delay(5000);

    End;

  Graphics_Unload(Game);

End.
