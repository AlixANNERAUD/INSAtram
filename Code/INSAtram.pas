
Program INSAtram;

//Unit_Logic, Unit_Graphics, Unit_Types,

Uses Unit_Types, Unit_Graphics, Unit_Logic, sdl_image, sdl;

Var Game : Type_Game;
  Station_Pointer : Type_Station_Pointer;
  Timer : Type_Time;
  i : Byte;

Begin

  Randomize();

  Logic_Load(Game);
  Graphics_Load(Game);

  For i := 0 To 10 Do
    Begin
      Station_Create(Game);
      Graphics_Refresh(Game);
    End;


  Graphics_Unload(Game);
End.
