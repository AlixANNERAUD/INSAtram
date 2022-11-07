
Unit Unit_Graphics;

Interface

Uses Unit_Types, Unit_Animations, sdl, sdl_image, sdl_ttf, sdl_gfx, sysutils, Math;

// - Constant definition

// - - Settings

Const Color_Depth =   32;

  // - - Paths

  // - - - Images

Const Path_Image_Station_Circle =   'Ressources/Images/Station_Circle.png';

Const Path_Image_Station_Square =   'Ressources/Images/Station_Square.png';

Const Path_Image_Station_Triangle =   'Ressources/Images/Station_Triangle.png';

Const Path_Image_Station_Pentagon =   'Ressources/Images/Station_Pentagon.png';

Const Path_Image_Station_Lozenge =   'Ressources/Images/Station_Lozenge.png';

Const Path_Image_Passenger_Circle =   'Ressources/Images/Passenger_Circle.png';

Const Path_Image_Passenger_Square =   'Ressources/Images/Passenger_Square.png';

Const Path_Image_Passenger_Triangle =   'Ressources/Images/Passenger_Triangle.png';

Const Path_Image_Passenger_Pentagon =   'Ressources/Images/Passenger_Pentagon.png';

Const Path_Image_Passenger_Lozenge =   'Ressources/Images/Passenger_Lozenge.png';

Const Path_Image_Locomotive =   'Ressources/Images/Locomotive.png';

  // - - - Fonts

Const Path_Font =   'Ressources/Fonts/FreeSans.ttf';

Const Path_Font_Bold =   'Ressources/Fonts/FreeSansBold.ttf';

  // - - Size

  // - - - Station

Const Station_Width =   32;

Const Station_Height =   32;

  // - - - Vehicle (Locomotive and Wagon)

Const Vehicle_Width =   32;

Const Vehicle_Height =   24;

  // - - - Passenger

Const Passenger_Width =   8;

Const Passenger_Height =   8;


  // - Function definition

  // - - Window

Procedure Graphics_Load(Var Game : Type_Game);
Procedure Graphics_Unload(Var Game : Type_Game);
Procedure Graphics_Refresh(Var Game : Type_Game);

Function Graphics_Get_Angle(Position_1, Position_2 : Type_Coordinates):   Real;
Function Graphics_Get_Direction(Angle : Real) :   Real;

Procedure Graphics_Draw_Line(Var Game : Type_Game; Position_1, Position_2 :
                             Type_Coordinates; Width : Integer; Color :
                             Type_Color);
Function Graphics_Get_Distance(Position_1, Position_2 : Type_Coordinates):   Integer;

// - - Entity

Procedure Station_Display(Var Station : Type_Station; Var Game : Type_Game);

Function Station_Get_Intermediate_Position(Position_1, Position_2 : Type_Coordinates) :   Type_Coordinates;

Procedure Line_Display(Position_1, Position_2 : Type_Coordinates; Var Game :
                       Type_Game);

Procedure Train_Display(Var Train : Type_Train; Var Line : Type_Line; Var Game :
                        Type_Game);


Implementation

// - - Graphics

Procedure Graphics_Load(Var Game : Type_Game);

Var Video_Informations :   PSDL_VideoInfo;
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

  Game.Sprites.Vehicle_0_Degree := SDL_CreateRGBSurface(0, Vehicle_Width, Vehicle_Height, Color_Depth, 0, 0, 0, 0);
  SDL_FillRect(Game.Sprites.Vehicle_0_Degree, Nil, SDL_MapRGB(Game.Window^.format, 0, 0, 0));

  Game.Sprites.Vehicle_45_Degree := rotozoomSurface(Game.Sprites.Vehicle_0_Degree, 45, 1, 1);

  Game.Sprites.Vehicle_90_Degree := SDL_CreateRGBSurface(0, Vehicle_Height, Vehicle_Width, Color_Depth, 0, 0, 0, 0);
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

Var i :   Byte;
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

Function Graphics_Get_Distance(Position_1, Position_2 : Type_Coordinates):   Integer;
Begin
  Graphics_Get_Distance := round(sqrt(sqr(Position_2.X-Position_1.X)+sqr(Position_2.Y-Position_1.Y)));
End;

Function Graphics_Get_Angle(Position_1, Position_2 : Type_Coordinates):   Real;
Begin
  Graphics_Get_Angle := ArcTan2(-Position_2.Y + Position_1.Y,
                        Position_2.X - Position_1.X);
End;

// Fonction déterminant l'orientation d'un angle parmis : 0, Pi/4, Pi/2, 3Pi/4, Pi, -Pi/4, -Pi/2, -3Pi/4.
Function Graphics_Get_Direction(Angle : Real) :   Real;

Var Sign :   Integer;
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
         Graphics_Get_Direction := Sign * (3*Pi/4)
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

Var Intermediate_Position :   Type_Coordinates;
  Color :   Type_Color;
Begin

  Intermediate_Position := Station_Get_Intermediate_Position(Position_1, Position_2);

  Color.Red := 0;
  Color.Green := 0;
  Color.Blue := 0;
  Color.Alpha := 255;

  Graphics_Draw_Line(Game, Position_1, Intermediate_Position, 0, Color);
  Graphics_Draw_Line(Game, Intermediate_Position, Position_2, 0, Color);
End;

Function Station_Get_Intermediate_Position(Position_1, Position_2 : Type_Coordinates) :   Type_Coordinates;

Var Angle :   Real;
Begin
  Angle := Graphics_Get_Angle(Position_1, Position_2);

  If ((Angle >= (Pi/4)) And (Angle <= ((3*Pi)/4))) Then
    Begin
      Station_Get_Intermediate_Position.X := Position_1.X;
      Station_Get_Intermediate_Position.Y := Position_2.Y + abs(Position_2.X - Position_1.X)
      ;
    End
    // - Angle between -45° and -135° (included)
  Else If ((Angle <= (-Pi/4)) And (Angle >= ((-3*Pi)/4))) Then
         Begin
           Station_Get_Intermediate_Position.X := Position_1.X;
           Station_Get_Intermediate_Position.Y := Position_2.Y - abs(Position_2.X -
                                                  Position_1.X);
         End
         // - Angle between -45° and 45° (excluded)
  Else If (((Angle > (-Pi/4)) And (Angle < 0)) Or ((Angle < (Pi/4)) And (Angle
          >= 0))) Then
         Begin
           Station_Get_Intermediate_Position.Y := Position_1.Y;
           Station_Get_Intermediate_Position.X := Position_2.X - abs(Position_2.Y -
                                                  Position_1.Y);
         End
         // - Angle between 135° and -135° (excluded)
  Else
    Begin
      Station_Get_Intermediate_Position.Y := Position_1.Y;
      Station_Get_Intermediate_Position.X := Position_2.X + abs(Position_2.Y - Position_1.Y);
    End;
End;

Procedure Train_Display(Var Train : Type_Train; Var Line : Type_Line; Var Game : Type_Game);

Var Destination_Rectangle :   Type_Rectangle;
  i :   Byte;
  Next_Station :   Type_Station_Pointer;
  Intermediate_Position :   Type_Coordinates;
  Intermediate_Position_Distance, Square_Side_Length :   Integer;
  Angle :   Real;
  Direction :   Real;
  Norme :   Integer;
  Centered_Position :   Type_Coordinates;

Begin

  // Dernière station
  // Station d'arrivée
  // -> Point intermédiaire -> longueur ou se situe le point intermédiaire.

  // - Détermination du point intermédiaire.
  // - Détermination de la station d'arrivée à partir de la station de départ.  
  For i := 0 To Line.Stations_Count - 1 Do
    Begin
      If (Line.Stations[i] = Train.Last_Station) Then
        Begin
          Next_Station := Line.Stations[i + 1];
          break;
        End;
    End;
  Intermediate_Position := Station_Get_Intermediate_Position(Train.Last_Station^.Position, Next_Station^.Position);

  Intermediate_Position_Distance := Graphics_Get_Distance(Train.Last_Station^.Position, Intermediate_Point);

  // - Détermination de la droite sur laquel le train se trouve et calcule l'angle du véhicule en conséquence.
  If (Train.Distance <= Intermediate_Position_Distance) Then // Si le train se trouve avant le point intermédiaire.
    Begin
      Angle := Graphics_Get_Angle(Train.Last_Station^.Position, Intermediate_Point);
      // - Détermination de l'orientation.
      Direction := Graphics_Get_Direction(Angle);

      Case Direction Of 
        0 :
            Begin
              Centered_Position.X := Train.Last_Station^.Position.X + Train.Distance;
              Centered_Position.Y := Train.Last_Station^.Position.Y;
              Train.Vehicle[0].Sprite := Game.Sprites.Vehicle_0_Degree;
            End;
        Pi :
             Begin
               Centered_Position.X := Train.Last_Station^.Position.X - Train.Distance;
               Centered_Position.Y := Train.Last_Station^.Position.Y;
               Train.Vehicle[0].Sprite := Game.Sprites.Vehicle_0_Degree;
             End;
        Pi/2 :
               Begin
                 Centered_Position.X := Train.Last_Station^.Position.X;
                 Centered_Position.Y := Train.Last_Station^.Position.Y - Train.Distance;
                 Train.Vehicle[0].Sprite := Game.Sprites.Vehicle_90_Degree;
               End;
        -Pi/2 :
                Begin
                  Centered_Position.X := Train.Last_Station^.Position.X;
                  Centered_Position.Y := Train.Last_Station^.Position.Y + Train.Distance;
                  Train.Vehicle[0].Sprite := Game.Sprites.Vehicle_90_Degree;
                End;
        Else
          Begin
            Norme := sqrt(sqr(Train.Distance*0.5));
            If (Drection < 0) Then // Partie inférieur du cercle trigonométrique (sens des y positifs).
              Begin
                Centered_Position.Y := Train.Last_Station^.Position.Y + Norme;
                If (Direction = -Pi/4) Then
                  Begin
                    Centered_Position.X := Train.Last_Station^.Position.X + Norme;
                    Train.Vehicle[0].Sprite := Game.Sprites.Vehicle_135_Degree;
                  End
                Else
                  Begin
                    Centered_Position.X := Train.Last_Station^.Position.X - Norme;
                    Train.Vehicle[0].Sprite := Game.Sprites.Vehicle_45_Degree;
                  End;
              End
            Else  // Partie supérieur du cercle trigonométrique (sens des y négatifs).
              Begin
                Centered_Position.Y := Train.Last_Station^.Position.Y - Norme;
                If (Direction = Pi/4) Then
                  Begin
                    Centered_Position.X := Train.Last_Station^.Position.X + Norme;
                    Train.Vehicle[0].Sprite := Game.Sprites.Vehicle_45_Degree;
                  End
                Else
                  Begin
                    Centered_Position.X := Train.Last_Station^.Position.X - Norme;
                    Train.Vehicle[0].Sprite := Game.Sprites.Vehicle_135_Degree;
                  End;
              End;
          End;
      End;
    End
  Else  // Si le train se trouve après le point intermédiaire.
    Begin

      // - Détermination de l'angle de la droite entre le point intermédiaire et la station d'arrivée.
      Angle := Graphics_Get_Angle(Intermediate_Point, Next_Station^.Position);
      // - Détermination de l'orientation.
      Direction := Graphics_Get_Direction(Angle);

      Case Direction Of 
        0 :
            Begin
              Centered_Position.X := Intermediate_Point_Position.X + Train.Distance;
              Centered_Position.Y := Intermediate_Point_Position.Y;
              Train.Vehicle[0].Sprite := Game.Sprites.Vehicle_0_Degree;
            End;
        Pi :
             Begin
               Centered_Position.X := Intermediate_Point_Position.X - Train.Distance;
               Centered_Position.Y := Intermediate_Point_Position.Y;
               Train.Vehicle[0].Sprite := Game.Sprites.Vehicle_0_Degree;
             End;
        Pi/2 :
               Begin
                 Centered_Position.X := Intermediate_Point_Position.X;
                 Centered_Position.Y := Intermediate_Point_Position.Y - Train.Distance;
                 Train.Vehicle[0].Sprite := Game.Sprites.Vehicle_90_Degree;
               End;
        -Pi/2 :
                Begin
                  Centered_Position.X := Intermediate_Point_Position.X;
                  Centered_Position.Y := Intermediate_Point_Position.Y + Train.Distance;
                  Train.Vehicle[0].Sprite := Game.Sprites.Vehicle_90_Degree;
                End;
        Else
          Begin
            Norme := sqrt(sqr(Train.Distance*0.5));
            If (Drection < 0) Then // Partie inférieur du cercle trigonométrique (sens des y positifs).
              Begin
                Centered_Position.Y := Intermediate_Point_Position.Y + Norme;
                If (Direction = -Pi/4) Then
                  Begin
                    Centered_Position.X := Intermediate_Point_Position.X + Norme;
                    Train.Vehicle[0].Sprite := Game.Sprites.Vehicle_135_Degree;
                  End
                Else
                  Begin
                    Centered_Position.X := Intermediate_Point_Position.X - Norme;
                    Train.Vehicle[0].Sprite := Game.Sprites.Vehicle_45_Degree;
                  End;
              End
            Else  // Partie supérieur du cercle trigonométrique (sens des y négatifs).
              Begin
                Centered_Position.Y := Intermediate_Point_Position.Y - Norme;
                If (Direction = Pi/4) Then
                  Begin
                    Centered_Position.X := Intermediate_Point_Position.X + Norme;
                    Train.Vehicle[0].Sprite := Game.Sprites.Vehicle_45_Degree;
                  End
                Else
                  Begin
                    Centered_Position.X := Intermediate_Point_Position.X - Norme;
                    Train.Vehicle[0].Sprite := Game.Sprites.Vehicle_135_Degree;
                  End;
              End;
          End;
      End;

      // - Détermination de la position absolue du train à partir des coordonnées centrées.
      If ((Direction = 0) And (Direction = Pi)) Then
        Begin
          Train.Vehicle[0].Position.X := Centered_Position.X - (Vehicle_Width*0.5);
          Train.Vehicle[0].Position.Y := Centered_Position.Y - (Vehicle_Height*0.5);
        End
      Else If ((Direction = Pi/2) And (Direction = -(Pi/2))) Then
             Begin

               Train.Vehicle[0].Position.Y := Centered_Position.Y - (Vehicle_Width*0.5);
               Train.Vehicle[0].Position.X := Centered_Position.X - (Vehicle_Height*0.5);
             End;
      Else
        Begin
          Square_Side_Length := sqrt(sqr(Vehicle_Width)*0.5)+sqrt(sqr(Vehicle_Height)*0.5) //Se référer au rapport du projet pour les explications
                                Train.Vehicle[0].Position.X := Centered_Position.X - Square_Side_Length*0.5;
          Train.Vehicle[0].Position.Y := Centered_Position.Y - Square_Side_Length*0.5;
        End;


    End;


  Destination_Rectangle.x := Train.Vehicle[0].Position.X;
  Destination_Rectangle.y := Train.Vehicle[0].Position.Y;
  // - Affiche la locomotive.
  SDL_BlitSurface(Train.Vehicle[0].Sprite, Nil, Game.Window, @Destination_Rectangle);
  // - Affiche les passagers. 
  If (Train.Passengers_Count > 0) Then
    Begin
      // - Display the passengers
    End;
End;

Procedure Station_Display(Var Station : Type_Station; Var Game : Type_Game);

Var Destination_Rectangle :   Type_Rectangle;
  i :   Byte;
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
