
Unit Unit_Graphics;

Interface

Uses Unit_Types, Unit_Animations, sdl, sdl_image, sdl_ttf, sdl_gfx, sysutils, Math;

// - Constant definition

// - - Settings

Const Color_Depth = 32;

  // - - Paths

  // - - - Images

Const Path_Image_Station_Circle = 'Ressources/Images/Station_Circle.png';

Const Path_Image_Station_Square = 'Ressources/Images/Station_Square.png';

Const Path_Image_Station_Triangle = 'Ressources/Images/Station_Triangle.png';

Const Path_Image_Station_Pentagon = 'Ressources/Images/Station_Pentagon.png';

Const Path_Image_Station_Lozenge = 'Ressources/Images/Station_Lozenge.png';

Const Path_Image_Passenger_Circle = 'Ressources/Images/Passenger_Circle.png';

Const Path_Image_Passenger_Square = 'Ressources/Images/Passenger_Square.png';

Const Path_Image_Passenger_Triangle = 'Ressources/Images/Passenger_Triangle.png';

Const Path_Image_Passenger_Pentagon = 'Ressources/Images/Passenger_Pentagon.png';

Const Path_Image_Passenger_Lozenge = 'Ressources/Images/Passenger_Lozenge.png';

Const Path_Image_Locomotive = 'Ressources/Images/Locomotive.png';

  // - - - Fonts

Const Path_Font = 'Ressources/Fonts/FreeSans.ttf';

Const Path_Font_Bold = 'Ressources/Fonts/FreeSansBold.ttf';

  // - - Size

  // - - - Station

Const Station_Width = 32;

Const Station_Height = 32;

  // - - - Vehicle (Locomotive and Wagon)

Const Vehicle_Width = 32;

Const Vehicle_Height = 24;

  // - - - Passenger

Const Passenger_Width = 8;

Const Passenger_Height = 8;


  // - Function definition

  // - - Window

Procedure Graphics_Load(Var Game : Type_Game);
Procedure Graphics_Unload(Var Game : Type_Game);
Procedure Graphics_Refresh(Var Game : Type_Game);

Function Graphics_Get_Angle(Position_1, Position_2 : Type_Coordinates): Real;
Procedure Graphics_Draw_Line(Var Game : Type_Game; Position_1, Position_2 :
                             Type_Coordinates; Width : Integer; Color :
                             Type_Color);
Function Graphics_Get_Distance(Position_1, Position_2 : Type_Coordinates): Integer;

// - - Entity

Procedure Station_Display(Var Station : Type_Station; Var Game : Type_Game);

Function Station_Get_Intermediate_Point(Position_1, Position_2 : Type_Coordinates) : Type_Coordinates;

Procedure Line_Display(Position_1, Position_2 : Type_Coordinates; Var Game :
                       Type_Game);

Procedure Train_Display(Var Train : Type_Train; Var Line : Type_Line; Var Game :
                        Type_Game);


Implementation

// - - Graphics

Procedure Graphics_Load(Var Game : Type_Game);

Var Video_Informations : PSDL_VideoInfo;
Begin
  SDL_Init(SDL_INIT_EVERYTHING);
  // - Initialisation de la SDL
  Game.Window := SDL_SetVideoMode(0, 0, Color_Depth, SDL_SWSURFACE);
  // - Création de la fenêtre
  SDL_FillRect(Game.Window, Nil, SDL_MapRGB(Game.Window^.format, 255, 255, 255))
  ;
  // - Obtention des informations de la fenêtre
  Video_Informations := SDL_GetVideoInfo();
  Game.Window_Size.X := Video_Informations^.current_w;
  Game.Window_Size.Y := Video_Informations^.current_h;
  // - Remplissage de la fenêtre en blanc
  // - Sprites loading

  // - - Station
  Game.Sprites.Station_Square := IMG_Load(Path_Image_Station_Square);
  Game.Sprites.Station_Circle := IMG_Load(Path_Image_Station_Circle);
  Game.Sprites.Station_Triangle := IMG_Load(Path_Image_Station_Triangle);
  Game.Sprites.Station_Pentagon := IMG_Load(Path_Image_Station_Pentagon);
  Game.Sprites.Station_Lozenge := IMG_Load(Path_Image_Station_Lozenge);

  // - - Passenger
  Game.Sprites.Passenger_Circle := IMG_Load(Path_Image_Passenger_Circle);
  Game.Sprites.Passenger_Square := IMG_Load(Path_Image_Passenger_Square);
  Game.Sprites.Passenger_Triangle := IMG_Load(Path_Image_Passenger_Triangle);
  Game.Sprites.Passenger_Pentagon := IMG_Load(Path_Image_Passenger_Pentagon);
  Game.Sprites.Passenger_Lozenge := IMG_Load(Path_Image_Passenger_Lozenge);

  // - - Véhicule (Locomotive et Wagon)

  Game.Sprites.Vehicle_0_Degree := SDL_CreateRGBSurface(0, Vehicule_Width, Vehicule_Height, Color_Depth, 0, 0, 0, 0);
  SDL_FillRect(Game.Sprites.Vehicle_0_Degree, Nil, SDL_MapRGB(Game.Window^.format, 0, 0, 0));

  Game.Sprites.Vehicle_45_Degree := rotozoomSurface(Game.Sprites.Vehicle_0_Degree, 45, 1, 1);

  Game.Sprites.Vehicle_90_Degree := SDL_CreateRGBSurface(0, Vehicule_Height, Vehicule_Width, Color_Depth, 0, 0, 0, 0);
  SDL_FillRect(Game.Sprites.Vehicle_0_Degree, Nil, SDL_MapRGB(Game.Window^.format, 0, 0, 0));

  Game.Sprites.Vehicle_135_Degree := rotozoomSurface(Game.Sprites.Vehicle_90_Degree, 45, 1, 1);


  // - Fonts loading
  Game.Fonts[0] := TTF_OPENFONT(Path_Font, 12);
  Game.Fonts[0] := TTF_OPENFONT(Path_Font_Bold, 12);

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

Function Graphics_Get_Distance(Position_1, Position_2 : Type_Coordinates): Integer;
Begin
  Graphics_Get_Distance := round(sqrt(sqr(Position_2.X-Position_1.X)+sqr(Position_2.Y-Position_1.Y)));
End;

Function Graphics_Get_Angle(Position_1, Position_2 : Type_Coordinates): Real;
Begin
  Graphics_Get_Angle := ArcTan2(-Position_2.Y + Position_1.Y,
                        Position_2.X - Position_1.X);
End;

Procedure Graphics_Draw_Line(Var Game : Type_Game; Position_1, Position_2 :
                             Type_Coordinates; Width : Integer; Color :
                             Type_Color);
Begin

  aalineRGBA(Game.Window, Position_1.X, Position_1.Y, Position_2.X, Position_2.Y
             , Color.Red, Color.Green, Color.Blue, Color.Alpha);

End;

// - - Station

// - Procedure that draw lines between stations with 0°, 45° and 90° angled lines.
Procedure Line_Display(Position_1, Position_2 : Type_Coordinates; Var Game :
                       Type_Game);

Var Angle : Real;
  Intermediate_Position : Type_Coordinates;
  Color : Type_Color;
Begin

  Angle := Graphics_Get_Angle(Position_1, Position_2);

  // - Angle between 45° and 135° (included)
  If ((Angle >= (Pi/4)) And (Angle <= ((3*Pi)/4))) Then
    Begin
      Intermediate_Position.X := Position_1.X;
      Intermediate_Position.Y := Position_2.Y + abs(Position_2.X - Position_1.X)
      ;
    End
    // - Angle between -45° and -135° (included)
  Else If ((Angle <= (-Pi/4)) And (Angle >= ((-3*Pi)/4))) Then
         Begin
           Intermediate_Position.X := Position_1.X;
           Intermediate_Position.Y := Position_2.Y - abs(Position_2.X -
                                      Position_1.X);
         End
         // - Angle between -45° and 45° (excluded)
  Else If (((Angle > (-Pi/4)) And (Angle < 0)) Or ((Angle < (Pi/4)) And (Angle
          >= 0))) Then
         Begin
           Intermediate_Position.Y := Position_1.Y;
           Intermediate_Position.X := Position_2.X - abs(Position_2.Y -
                                      Position_1.Y);
         End
         // - Angle between 135° and -135° (excluded)
  Else
    Begin
      Intermediate_Position.Y := Position_1.Y;
      Intermediate_Position.X := Position_2.X + abs(Position_2.Y - Position_1.Y)
      ;
    End;

  Color.Red := 0;
  Color.Green := 0;
  Color.Blue := 0;
  Color.Alpha := 255;

  Graphics_Draw_Line(Game, Position_1, Intermediate_Position, 0, Color);
  Graphics_Draw_Line(Game, Intermediate_Position, Position_2, 0, Color);
End;

Function Station_Get_Intermediate_Point(Position_1, Position_2 : Type_Coordinates) : Type_Coordinates;

Var Angle : Real;
Begin
  Angle := Graphics_Get_Angle(Position_1, Position_2);

  If ((Angle >= (Pi/4)) And (Angle <= ((3*Pi)/4))) Then
    Begin
      Station_Get_Intermediate_Point.X := Position_1.X;
      Station_Get_Intermediate_Point.Y := Position_2.Y + abs(Position_2.X - Position_1.X)
      ;
    End
    // - Angle between -45° and -135° (included)
  Else If ((Angle <= (-Pi/4)) And (Angle >= ((-3*Pi)/4))) Then
         Begin
           Station_Get_Intermediate_Point.X := Position_1.X;
           Station_Get_Intermediate_Point.Y := Position_2.Y - abs(Position_2.X -
                                               Position_1.X);
         End
         // - Angle between -45° and 45° (excluded)
  Else If (((Angle > (-Pi/4)) And (Angle < 0)) Or ((Angle < (Pi/4)) And (Angle
          >= 0))) Then
         Begin
           Station_Get_Intermediate_Point.Y := Position_1.Y;
           Station_Get_Intermediate_Point.X := Position_2.X - abs(Position_2.Y -
                                               Position_1.Y);
         End
         // - Angle between 135° and -135° (excluded)
  Else
    Begin
      Station_Get_Intermediate_Point.Y := Position_1.Y;
      Station_Get_Intermediate_Point.X := Position_2.X + abs(Position_2.Y - Position_1.Y);
    End;
End;

Procedure Train_Display(Var Train : Type_Train; Var Line : Line_Type; Var Game : Type_Game);

Var Destination_Rectangle : Type_Rectangle;
  i : Byte;
  Next_Station : Type_Station_Pointer;
  Intermediate_Point : Type_Coordinates;
  Angle : Real;
  Coord_Centre : Type_Coordinates;
Begin

  // Dernière station
  // Station d'arrivée
  // -> Point intermédiaire -> longueur ou se situe le point intermédiaire.

  // - Détermination de la station d'arrivée à partir de la station de départ.  
  For i := 0 To Line.Stations_Count - 1 Do
    Begin
      If (Line.Stations[i] = Train.Last_Station) Then
        Next_Station := Line.Stations[i + 1];
    End;

  // - Détermination du point intermédiaire.
  Station_Get_Intermediate_Point(Train.Last_Station^.Position, Next_Station^.Position);

  // - Détermination de la droite sur laquel le train se trouve et calcule l'angle du véhicule en conséquence.
  If (Train.Distance <= Graphics_Get_Distance(Train.Last_Station^.Position, Intermediate_Point)) Then
    Begin
      Angle := Graphics_Get_Angle(Train.Last_Station^.Position, Intermediate_Point);
    End
  Else
    Begin
      Angle := Graphics_Get_Angle(Intermediate_Point, Next_Station^.Position);
    End;

  // - Simplification de l'angle pour effectuer les comparaison dans les 2er quadrants.
  If (Angle < 0) Then
    Angle := Angle + Pi
  Else If (Angle > Pi) Then
         Angle := Angle - Pi;

  // - Détermination du sprite en fonction de l'angle.
  If ((Angle >= 0) And (Angle < (Pi/8)) or (Angle > (7*Pi/8))) Then // Si l'angle est entre 0° et 22.5° ou entre 157.5° et 180°
    Train.Locomotive.Sprite := Vehicle_0_Degree;                     // Le sprite est à 0°
    Coord_Centre.Y := Train.Last_Station^.Position.Y;
    Coord_Centre.X := Train.Distance
  Else If ((Angle >= (Pi/8) And (Angle < (3*Pi/8)))) Then           // Si l'angle est entre 22.5° et 67.5°
    Train.Locomotive.Sprite := Vehicle_45_Degree                    // Le sprite est à 45°.
    Coord_Centre.Y := round(sqrt(sqr(Train.Distance)*0.5));
    Coord_Centre.X := Coord_Centre.Y
  Else If ((Angle >= (3*Pi/8)) and (Angle < (5*Pi/8))) Then         // Si l'angle est entre 67.5° et 112.5°
    Train.Locomotive.Sprite := Vehicle_90_Degree                    // Le sprite est à 90°.
    Coord_Centre.Y := Train.Distance;
    Coord_Centre.X := Train.Last_Station^.Position.X
  Else If (Angle >= (5*Pi/8)) and (Angle < (7*Pi/8)) Then           // Si l'angle est entre 112.5° et 157.5°
    Train.Locomotive.Sprite := Vehicle_135_Degree;                  // Le sprite est à 135°.
    Coord_Centre.Y := round(sqrt(sqr(Train.Distance)*0.5));
    Coord_Centre.X := (-1)*Coord_Centre.Y;



  {
    Determination coordonnées cartésiennes :
    Si angle 0 ou Pi : horizontal : donc y = y_station (ou point intermédiaire)
    Si angle 45 : x = y, distance² = x² + y² = x² + x² = 2x² => x = y = sqrt(distance²/2) 
    Si angle 90 : verticale : donc x = x_station (ou point intermédiaire)  
  }


          Destination_Rectangle.x := Train.Locomotive.Position.X;
          Destination_Rectangle.y := Train.Locomotive.Position.Y;
          Destination_Rectangle.w := Locomotive_Width;
          Destination_Rectangle.h := Locomotive_Height;

          // - Affiche la locomotive.
          SDL_BlitSurface(Game.Sprites.Locomotive, Nil, Game.Window, @Destination_Rectangle);
          // - Affiche les passagers. 
          If (Train.Passengers_Count > 0) Then
         Begin
           // - Display the passengers
         End;
End;

End;

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
            Destination_Rectangle.x := (Station.Coordinates.X - (2 *
                                       Passenger_Width))
          Else
            Destination_Rectangle.x := (Station.Coordinates.X + Station_Width +
                                       Passenger_Width);
          // - Determine y position
          Destination_Rectangle.y := Station.Coordinates.Y + ((i Mod 3) * (
                                     Passenger_Height + 4));

          SDL_BlitSurface(Station.Passengers[i]^.Sprite, Nil, Game.Window, @
                          Destination_Rectangle);
        End;
    End;
End;

End.
