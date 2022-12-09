
Program INSAtram;



//Unit_Logic, Unit_Graphics, Unit_Types,

Uses sysutils, Unit_Types, Unit_Mouse, Unit_Graphics, Unit_Logic, sdl_image, sdl, sdl_gfx;

Var Game : Type_Game;

Begin
  Logic_Load(Game);

  While (True) Do
      Logic_Refresh(Game);

  Logic_Unload(Game);

End.
