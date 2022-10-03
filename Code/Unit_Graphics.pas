
Unit Unit_Graphics;

Interface

Uses Unit_Types, sdl, sdl_image, sdl_ttf, sysutils;

// - Définition des constantes

Const Path_Image_Station_Circle = 'Ressources/Cercle.png';
Const Path_Image_Station_Square = 'Ressources/Carre.png';
Const Path_Image_Station_Triangle = 'Ressources/Triangle.png';
Const Path_Image_Station_Pentagon = 'Ressources/Pentagone.png';
Const Path_Image_Station_Lozenge = 'Ressources/Lozenge.png';

Const Station_Width = 48;
Const Station_Height = 48;

// - Function definition

// - - Window

Procedure Graphics_Load(Var Game : Type_Game);
Procedure Graphics_Unload(Var Game : Type_Game);
Procedure Graphics_Refresh(Var Game : Type_Game);

// - - Station

Procedure Station_Display(var Station : Type_Station; var Game : Type_Game);

Implementation

// - - Graphics

Procedure Graphics_Load(var Game : Type_Game);
Begin
  SDL_Init(SDL_INIT_VIDEO);
  Game.Window := SDL_SetVideoMode(0, 0, 32, SDL_FULLSCREEN);
  Game.Sprite_Table.Station_Square := IMG_Load(Path_Image_Station_Square);
  Game.Sprite_Table.Station_Circle := IMG_Load(Path_Image_Station_Circle);
  Game.Sprite_Table.Station_Triangle := IMG_Load(Path_Image_Station_Triangle);
  Game.Sprite_Table.Station_Pentagon := IMG_Load(Path_Image_Station_Pentagon);
  Game.Sprite_Table.Station_Lozenge := IMG_Load(Path_Image_Station_Lozenge);

End;

Procedure Graphics_Unload(var Game : Type_Game);
Begin
  SDL_FreeSurface(Game.Window);
  Game.Window := Nil;
  SDL_Quit();
End;

Procedure Graphics_Refresh(var Game : Type_Game);
Begin
  SDL_Flip(Game.Window);
End;

// - - Station

Procedure Station_Display(var Station : Type_Station; var Game : Type_Game);
var Destination_Rectangle : Type_Rectangle;
Begin
  Destination_Rectangle.x := Station.Coordinates.X;
  Destination_Rectangle.y := Station.Coordinates.Y;
  Destination_Rectangle.w := Station_Width;
  Destination_Rectangle.h := Station_Height;
  
  case Station.Shape of
    Square : Station.Sprite := Game.Sprite_Table.Station_Square;
    Circle : Station.Sprite := Game.Sprite_Table.Station_Circle;
    Pentagon : Station.Sprite := Game.Sprite_Table.Station_Pentagon;
    Triangle : Station.Sprite := Game.Sprite_Table.Station_Triangle;
    Lozenge : Station.Sprite := Game.Sprite_Table.Station_Lozenge;
  end;

  SDL_BlitSurface(Station.Sprite, Nil, Game.Window, @Destination_Rectangle)
End;

End.
