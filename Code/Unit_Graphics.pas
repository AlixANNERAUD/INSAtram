
Unit Unit_Graphics;

Interface

Uses Unit_Types, sdl, sdl_image, sdl_ttf, sysutils;

// - Constant definition

// - - Paths

Const Path_Image_Station_Circle = 'Ressources/Circle.png';

Const Path_Image_Station_Square = 'Ressources/Square.png';

Const Path_Image_Station_Triangle = 'Ressources/Triangle.png';

Const Path_Image_Station_Pentagon = 'Ressources/Pentagon.png';

Const Path_Image_Station_Lozenge = 'Ressources/Lozenge.png';

  // - - Size

Const Station_Width = 32;

Const Station_Height = 32;

Const Passenger_Width = 8;

Const Passenger_Height = 8;

  // - Function definition

  // - - Window

Procedure Graphics_Load(Var Game : Type_Game);
Procedure Graphics_Unload(Var Game : Type_Game);
Procedure Graphics_Refresh(Var Game : Type_Game);

// - - Entity

Procedure Station_Display(Var Station : Type_Station; Var Game : Type_Game);


Implementation

// - - Graphics

Var Station_Test : Type_Surface;
  Destination_Rectangle : Type_Rectangle;

Procedure Graphics_Load(Var Game : Type_Game);

Var Video_Informations : PSDL_VideoInfo;
Begin
  SDL_Init(SDL_INIT_VIDEO);
  // - Initialisation de la SDL
  Game.Window := SDL_SetVideoMode(0, 0, 32, SDL_FULLSCREEN);
  // - Création de la fenêtre
  SDL_FillRect(Game.Window, Nil, SDL_MapRGB(Game.Window^.format, 255, 255, 255));
  // - Obtention des informations de la fenêtre
  Video_Informations := SDL_GetVideoInfo();
  Game.Window_Size.X := Video_Informations^.current_w;
  Game.Window_Size.Y := Video_Informations^.current_h;
  // - Remplissage de la fenêtre en blanc
  // - Chargement des sprites
  Game.Sprites.Station_Square := IMG_Load(Path_Image_Station_Square);
  Game.Sprites.Station_Circle := IMG_Load(Path_Image_Station_Circle);
  Game.Sprites.Station_Triangle := IMG_Load(Path_Image_Station_Triangle);
  Game.Sprites.Station_Pentagon := IMG_Load(Path_Image_Station_Pentagon);
  Game.Sprites.Station_Lozenge := IMG_Load(Path_Image_Station_Lozenge);

  Game.Stations_Count := 0;

  Graphics_Refresh(Game);
End;

Procedure Graphics_Unload(Var Game : Type_Game);
Begin
  // Free the sprites in memory.
  SDL_FreeSurface(Game.Sprites.Station_Square);
  SDL_FreeSurface(Game.Sprites.Station_Circle);
  SDL_FreeSurface(Game.Sprites.Station_Triangle);
  SDL_FreeSurface(Game.Sprites.Station_Pentagon);
  SDL_FreeSurface(Game.Sprites.Station_Lozenge);
  // Free the window in memory.
  SDL_FreeSurface(Game.Window);
  Game.Window := Nil;
  SDL_Quit();
End;

Procedure Graphics_Refresh(Var Game : Type_Game);

Var i : Byte;
Begin

  If (Game.Stations_Count > 0) Then
    Begin
      For i := 0 To Game.Stations_Count - 1 Do
        Begin
          Station_Display(Game.Stations[i]^, Game);
        End;
    End;

  SDL_Flip(Game.Window);
End;

// - - Station

Procedure Station_Display(Var Station : Type_Station; Var Game : Type_Game);

Var Destination_Rectangle : Type_Rectangle;
  i : Byte;
Begin
  // - Display station
  Destination_Rectangle.x := Station.Coordinates.X;
  Destination_Rectangle.y := Station.Coordinates.Y;
  Destination_Rectangle.w := Station_Width;
  Destination_Rectangle.h := Station_Height;

  SDL_BlitSurface(Station.Sprite, Nil, Game.Window, @Destination_Rectangle);

  // - Display station passengers

  Destination_Rectangle.w := Passenger_Width;
  Destination_Rectangle.h := Passenger_Height;
  If (Station.Passengers_Count > 0) Then
    Begin
      For i := 0 To (Station.Passengers_Count - 1) Do
        Begin
          // - Determine x position
          If (i < 3) Then
            Destination_Rectangle.x := (Station.Coordinates.X - (2 * Passenger_Width))
          Else
            Destination_Rectangle.x := (Station.Coordinates.X + Station_Width + Passenger_Width);
          // - Determine y position
          Destination_Rectangle.y := Station.Coordinates.Y + ((i Mod 3) * (Passenger_Height + 4));

          SDL_BlitSurface(Station.Passengers[i]^.Sprite, Nil, Game.Window, @Destination_Rectangle);
        End;
    End;
End;


End.
