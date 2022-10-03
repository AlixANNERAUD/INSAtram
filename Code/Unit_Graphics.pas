
Unit Unit_Graphics;

Interface

Uses Unit_Types, sdl, sdl_image, sdl_ttf, sysutils;

// - Définition des constantes

Const Path_Image_Station_Circle = 'Ressources/Circle.png';

Const Path_Image_Station_Square = 'Ressources/Square.png';

Const Path_Image_Station_Triangle = 'Ressources/Triangle.png';

Const Path_Image_Station_Pentagon = 'Ressources/Pentagon.png';

Const Path_Image_Station_Lozenge = 'Ressources/Lozenge.png';

Const Station_Width = 48;

Const Station_Height = 48;

  // - Function definition

  // - - Window

Procedure Graphics_Load(Var Game : Type_Game);
Procedure Graphics_Unload(Var Game : Type_Game);
Procedure Graphics_Refresh(Var Game : Type_Game);

// - - Station

Procedure Station_Display(Var Station : Type_Station; Var Game : Type_Game);

Implementation

// - - Graphics

Var Station_Test : Type_Surface;
  Destination_Rectangle : Type_Rectangle;

Procedure Graphics_Load(Var Game : Type_Game);

Begin
  SDL_Init(SDL_INIT_VIDEO);
  // - Initialisation de la SDL
  Game.Window := SDL_SetVideoMode(0, 0, 32, SDL_FULLSCREEN);
  // - Création de la fenêtre
  // SDL_FillRect(Game.Window, Nil, SDL_MapRGB(Game.Window^.format, 255, 255, 255));



  SDL_Flip(Game.Window);

  Graphics_Refresh(Game);
  // - Remplissage de la fenêtre en blanc
  // - Chargement des sprites
  Game.Sprite_Table.Station_Square := IMG_Load(Path_Image_Station_Square);
  Game.Sprite_Table.Station_Circle := IMG_Load(Path_Image_Station_Circle);
  Game.Sprite_Table.Station_Triangle := IMG_Load(Path_Image_Station_Triangle);
  Game.Sprite_Table.Station_Pentagon := IMG_Load(Path_Image_Station_Pentagon);
  Game.Sprite_Table.Station_Lozenge := IMG_Load(Path_Image_Station_Lozenge);
End;

Procedure Graphics_Unload(Var Game : Type_Game);
Begin
  SDL_FreeSurface(Game.Window);
  Game.Window := Nil;
  SDL_Quit();
End;

Procedure Graphics_Refresh(Var Game : Type_Game);
Begin
  SDL_Flip(Game.Window);
End;

// - - Station



Procedure Station_Display(Var Station : Type_Station; Var Game : Type_Game);

Var Destination_Rectangle : Type_Rectangle;
Begin
  writeln('Station_Display : Station.Shape = ', Station.Shape);

  Destination_Rectangle.x := Station.Coordinates.X;
  Destination_Rectangle.y := Station.Coordinates.Y;
  Destination_Rectangle.w := 225;
  Destination_Rectangle.h := 225;

  writeln('Station_Display : Destination_Rectangle.x = ', Destination_Rectangle.x);
  writeln('Station_Display : Destination_Rectangle.y = ', Destination_Rectangle.y);
  writeln('Station_Display : Destination_Rectangle.w = ', Destination_Rectangle.w);
  writeln('Station_Display : Destination_Rectangle.h = ', Destination_Rectangle.h);

  Case Station.Shape Of 
    Square : Station.Sprite := Game.Sprite_Table.Station_Square;
    Circle : Station.Sprite := Game.Sprite_Table.Station_Circle;
    Pentagon : Station.Sprite := Game.Sprite_Table.Station_Pentagon;
    Triangle : Station.Sprite := Game.Sprite_Table.Station_Triangle;
    Lozenge : Station.Sprite := Game.Sprite_Table.Station_Lozenge;
  End;

  SDL_BlitSurface(Station.Sprite, Nil, Game.Window, @Destination_Rectangle)
End;

End.
