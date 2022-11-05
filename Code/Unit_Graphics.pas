
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
Function Graphics_Get_Direction(Angle : Real) : Real;

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

// Fonction déterminant l'orientation d'un angle parmis : 0, Pi/4, Pi/2, 3Pi/4, Pi, -Pi/4, -Pi/2, -3Pi/4.
Function Graphics_Get_Direction(Angle : Real) : Real;

Var Sign : Integer;
Begin

  // Si l'angle est négatif (dans la partie inférieure du cercle),
  //son signe est inversé, mais pris en compte pour plus tard afin de simplfier la disjonction des cas.
  If (Angle < 0) Then
    Begin
      Angle := -Angle;
      Sign := -1;
    End
    // Si l'angle est positif mais dans la partie inférieur du cercle trigonométrique,
    // on lui ajoute 2Pi afin d'obtenir son analogue négatif puis comme pour le cas précédent,
    // on annule son signe et on prend en compte son signe pour plus tard.
  Else If (Angle > Pi) Then
         Begin
           Angle := -(Angle - (2*Pi));
           Sign := -1;
         End
  Else
    Sign := 1;

  If ((Angle >= 0) And (Angle < (Pi/8))) Then               // Si l'angle est entre 0° et 22.5° ou entre 157.5° et 180°
    Graphics_Get_Direction := 0                           // L'orientation est de 0°;
  Else If ((Angle >= (Pi/8)) And (Angle < (3*Pi/8))) Then   // Si l'angle est entre 22.5° et 67.5°
         Graphics_Get_Direction := Sign * (Pi/4)          // L'orientation est de 45° ou -45° (en fonction du signe).
  Else If ((Angle >= (3*Pi/8)) And (Angle < (5*Pi/8))) Then // Si l'angle est entre 67.5° et 112.5°
         Graphics_Get_Direction := Sign * (Pi/2)          // L'orientation est de 90° ou -90° (en fonction du signe).
  Else If ((Angle >= (5*Pi/8)) And (Angle < (7*Pi/8))) Then // Si l'angle est entre 112.5° et 157.5°
         Graphics_Get_Direction := Sign * (3*Pi/4);
  // L'orientation est de 135° ou -135° (en fonction du signe).
  Else If (Angle >= (7*Pi/8)) Then                          // Si l'angle est supérieur à 157.5°.
         Graphics_Get_Direction := Pi;
  // L'orientatino est de 180°
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
  Intermediate_Point : Type_Coordinates;
  Color : Type_Color;
Begin

  Intermediate_Point := Station_Get_Intermediate_Point(Position_1, Position_2);

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
  Intermediate_Point_Position : Type_Coordinates;
  Intermediate_Point_Distance : Integer;
  Angle : Real;
  Direction : Real;
  Norme : Integer;
  Centered_Position : Type_Coordinates;
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
  Intermediate_Point_Position := Station_Get_Intermediate_Point(Train.Last_Station^.Position, Next_Station^.Position);

  Intermediate_Point_Distance := Graphics_Get_Distance(Train.Last_Station^.Position, Intermediate_Point);

  // - Détermination de la droite sur laquel le train se trouve et calcule l'angle du véhicule en conséquence.
  If (Train.Distance <= Intermediate_Point_Distance) Then // Si le train se trouve avant le point intermédiaire.
    Begin
      Angle := Graphics_Get_Angle(Train.Last_Station^.Position, Intermediate_Point);

      // - Détermination de l'orientation.
      Direction := Graphics_Get_Direction(Angle);

      If ((Direction = 0) Or (Direction = Pi) Or (Direction = Pi/2) Or (Direction = -Pi/2)) Then
        Begin
          Norme := Distance;
        End
      Else
        Begin
          Norme := sqrt(sqr(Train.Distance*0.5));
        End;

    End
  Else  // Si le train se trouve après le point intermédiaire.
    Begin
      Angle := Graphics_Get_Angle(Intermediate_Point, Next_Station^.Position);

      // - Détermination de l'orientation.
      Direction := Graphics_Get_Direction(Angle);

      If ((Direction = 0) Or (Direction = Pi) Or (Direction = Pi/2) Or (Direction = -Pi/2)) Then
        Begin
          Norme := Distance - Intermediate_Point_Distance;
        End
      Else
        Begin
          Norme := sqrt(sqr((Train.Distance - Intermediate_Point_Distance)*0.5));
        End;
    End;


  If (Angle < 0) Or (Angle > Pi) Then
    //  -   Determinations des coordonnées centrales de la locomotive dans la moitiée inférieure du cercle.
    Begin

      If (((Angle >= Pi) And (Angle < (9*Pi/8))) Or ((Angle >= -Pi) And (Angle < ((-7)*Pi/8)))) Then
        // Si l'angle est à pi
        Begin
          Centered_Position.Y := Train.Last_Station^.Position.Y;
          Centered_Position.X := -Train.Distance
        End
      Else If (((Angle >= (9*Pi/8)) And (Angle < (11*Pi/8))) Or ((Angle >= (-7)*Pi/8) And (Angle < ((-5)*Pi/8)))) Then // Si l'angle est à 10pi/8 ou -6pi/8
             Begin
               Centered_Position.Y := -round(sqrt(sqr(Train.Distance)*0.5));
               Centered_Position.X := Centered_Position.Y
             End
      Else If (((Angle >= (11*Pi/8)) And (Angle < (13*Pi/8))) Or ((Angle >= (-5)*Pi/8) And (Angle < ((-3)*Pi/8)))) Then // Si l'angle est à 3pi/2 ou -pi/2
             Begin
               Centered_Position.Y := -Train.Distance;
               Centered_Position.X := Train.Last_Station^.Position.X
             End
      Else If (((Angle >= (13*Pi/8)) And (Angle < (15*Pi/8))) Or ((Angle >= (-3)*Pi/8) And (Angle < ((-1)*Pi/8)))) Then
             // Si l'angle est à 14pi/8 ou -2pi/8 (à -pi/4)
             Begin
               Centered_Position.Y := -round(sqrt(sqr(Train.Distance)*0.5));
               Centered_Position.X := -Centered_Position.Y
             End
      Else If (((Angle >= (15*Pi/8)) And (Angle < (16*Pi/8))) Or ((Angle >= (-1)*Pi/8) And (Angle < 0))) Then
             Begin
               // Si l'angle est à 0 ou 16pi/8
               Centered_Position.Y := Train.Last_Station^.Position.Y;
               Centered_Position.X := Train.Distance
             End;

      // - Simplification de l'angle pour se retrouver dans la partie supérieure du cercle trigonométrique.
      If (Angle < 0) Then
        Angle := Angle + Pi
      Else If (Angle > Pi) Then
             Angle := Angle - Pi;

      // - Détermination du sprite en fonction de l'angle.
      If (((Angle >= 0) And (Angle < (Pi/8))) Or (Angle > (7*Pi/8))) Then
        // Si l'angle est entre 0° et 22.5° ou entre 157.5° et 180°
        Train.Locomotive.Sprite := Vehicle_0_Degree                         // Le sprite est à 0°
      Else If ((Angle >= (Pi/8)) And (Angle < (3*Pi/8))) Then                 // Si l'angle est entre 22.5° et 67.5°
             Train.Locomotive.Sprite := Vehicle_45_Degree                        // Le sprite est à 45°.
      Else If ((Angle >= (3*Pi/8)) And (Angle < (5*Pi/8))) Then               // Si l'angle est entre 67.5° et 112.5°
             Train.Locomotive.Sprite := Vehicle_90_Degree                        // Le sprite est à 90°.
      Else If ((Angle >= (5*Pi/8)) And (Angle < (7*Pi/8))) Then               // Si l'angle est entre 112.5° et 157.5°
             Train.Locomotive.Sprite := Vehicle_135_Degree;
      // Le sprite est à 135°.

    End;
  Else
    Begin

      If (((Angle >= 0) And (Angle < (Pi/8))) Then                            // Si l'angle est entre 0° et 22.5°
        Train.Locomotive.Sprite := Vehicle_0_Degree;
      // Le sprite est à 0°
      Centered_Position.Y := Train.Last_Station^.Position.Y;
      Centered_Position.X := Train.Distance
      Else If (Angle > (7*Pi/8)) Then
             // Si l'angle est entre 157.5° et 180°
             Train.Locomotive.Sprite := Vehicle_0_Degree;
      // Le sprite est à 0°
      Centered_Position.Y := Train.Last_Station^.Position.Y;
      Centered_Position.X := (-1)*Train.Distance
      Else If ((Angle >= (Pi/8)) And (Angle < (3*Pi/8))) Then
             // Si l'angle est entre 22.5° et 67.5°
             Train.Locomotive.Sprite := Vehicle_45_Degree;
      // Le sprite est à 45°.
      Centered_Position.Y := round(sqrt(sqr(Train.Distance)*0.5));
      Centered_Position.X := Centered_Position.Y
      Else If ((Angle >= (3*Pi/8)) And (Angle < (5*Pi/8))) Then
             // Si l'angle est entre 67.5° et 112.5°
             Train.Locomotive.Sprite := Vehicle_90_Degree;
      // Le sprite est à 90°.
      Centered_Position.Y := Train.Distance;
      Centered_Position.X := Train.Last_Station^.Position.X
      Else If ((Angle >= (5*Pi/8)) And (Angle < (7*Pi/8))) Then
             // Si l'angle est entre 112.5° et 157.5°
             Train.Locomotive.Sprite := Vehicle_135_Degree;
      // Le sprite est à 135°.
      Centered_Position.Y := round(sqrt(sqr(Train.Distance)*0.5));
      Centered_Position.X := (-1)*Centered_Position.Y;

    End;


















{
    Determination coordonnées cartésiennes :
    Si angle 0 ou Pi : horizontal : donc y = y_station (ou point intermédiaire)
    Si angle 45 : x = y, distance² = x² + y² = x² + x² = 2x² => x = y = sqrt(distance²/2) 
    Si angle 90 : verticale : donc x = x_station (ou point intermédiaire)  
  }


  // - Affiche la locomotive.
  SDL_BlitSurface(Game.Sprites.Locomotive, Nil, Game.Window, @Destination_Rectangle);
  // - Affiche les passagers. 
  If (Train.Passengers_Count > 0) Then
    Begin
      // - Display the passengers
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
