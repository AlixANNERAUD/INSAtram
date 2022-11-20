
Unit Unit_Graphics;

Interface

Uses Unit_Types, Unit_Animations, sdl, sdl_image, sdl_ttf, sdl_gfx, sysutils, Math;

// - Function definition

// - - Window


Procedure Graphics_Load(Var Game : Type_Game);
Procedure Graphics_Unload(Var Game : Type_Game);
Procedure Graphics_Refresh(Var Game : Type_Game);

Function Graphics_Get_Angle(Position_1, Position_2 : Type_Coordinates):   Real;
Function Graphics_Get_Direction(Angle : Real) : Integer;

Procedure Graphics_Draw_Line(Var Game : Type_Game; Position_1, Position_2 :
                             Type_Coordinates; Width : Integer; Color :
                             Type_Color);
Function Graphics_Get_Distance(Position_1, Position_2 : Type_Coordinates):   Integer;

// - - Entity

Procedure Station_Render(Var Station : Type_Station; Var Game : Type_Game);

Function Station_Get_Intermediate_Position(Position_1, Position_2 : Type_Coordinates) :   Type_Coordinates;

Procedure Line_Render(Position_1, Position_2 : Type_Coordinates; Color : Type_Color; Var Game :
                      Type_Game);

Procedure Train_Render(Var Train : Type_Train; Var Line : Type_Line; Var Game :
                       Type_Game);

// - - Interface
// - - - Label
Procedure Label_Set(Var Laabel : Type_Label; Text_String : String; Font : Type_Font; Color : Type_Color);
Procedure Label_Set_Color(Var Laabel : Type_Label; Color : Type_Color);
Procedure Label_Set_Text(Var Laabel : Type_Label; Text_String : String);
Procedure Label_Set_Font(Var Laabel : Type_Label; Font : Type_Font);
Procedure Label_Pre_Render(Var Laabel : Type_Label);

Procedure Label_Render(Var Laabel : Type_Label; Var Render_Surface : Type_Surface);

Implementation

// Procédure pré-rendant le texte dans une surface. Cette fonction est appelé dès qu'un attribut d'une étiquette est modifié, pour que ces opérations ne soient pas à refaires lors de l'affichage.
Procedure Label_Pre_Render(Var Laabel : Type_Label);
Var Characters : pChar;
    SDL_Color : PSDL_Color;
Begin
  new(SDL_Color);


  SDL_Color^.r := Laabel.Color.Red;
  SDL_Color^.g := Laabel.Color.Green;
  SDL_Color^.b := Laabel.Color.Blue;

  SDL_FreeSurface(Laabel.Surface);
  // Conversion du string en pChar.
  Characters := String_To_Characters(Laabel.Text);
  Laabel.Surface := TTF_RENDERTEXT_BLENDED(Laabel.Font, Characters, 
 SDL_Color^);
  dispose(SDL_Color);
  strDispose(Characters);
  writeln('Label_Set');
End;

// Procédure qui définit tout les attributs d'un texte à la fois.
Procedure Label_Set(Var Laabel : Type_Label; Text_String : String; Font : Type_Font; Color : Type_Color);
Begin
  Laabel.Font := Font;
  Laabel.Color := Color;
  Laabel.Text := Text_String;
  Label_Pre_Render(Laabel);
End;

Procedure Label_Set_Text(Var Laabel : Type_Label; Text_String : String);
Begin
  Laabel.Text := Text_String;
  Label_Pre_Render(Laabel);
End;

Procedure Label_Set_Font(Var Laabel : Type_Label; Font : Type_Font);
Begin
  Laabel.Font := Font;
  Label_Pre_Render(Laabel);
End;

Procedure Label_Set_Color(Var Laabel : Type_Label; Color : Type_Color);
Begin
  Laabel.Color := Color;
  Label_Pre_Render(Laabel);
End;

Procedure Label_Render(Var Laabel : Type_Label; Var Render_Surface : Type_Surface);
Var Destionation_Rectangle : Type_Rectangle;
Begin
  Destionation_Rectangle.x := Laabel.Position.X;
  Destionation_Rectangle.y := Laabel.Position.Y;
  //Destionation_Rectangle.w := Laabel.Size.X;
  //Destionation_Rectangle.h := Laabel.Size.Y;
  SDL_BlitSurface(Laabel.Surface, NIL, Render_Surface, @Destionation_Rectangle);
End;

// - - Graphics

Procedure Graphics_Load(Var Game : Type_Game);

Var Video_Informations :   PSDL_VideoInfo;
Begin
  SDL_Init(SDL_INIT_EVERYTHING);
  TTF_INIT();
  // - Initialisation de la SDL
  Game.Window := SDL_SetVideoMode(960, 720, Color_Depth, SDL_SWSURFACE);
  // - Création de la fenêtre
  SDL_FillRect(Game.Window, Nil, SDL_MapRGB(Game.Window^.format, 255, 255, 255))
  ;
  // - Obtention des informations de la fenêtre
  Video_Informations := SDL_GetVideoInfo();
  Game.Window_Size.X := Video_Informations^.current_w;
  Game.Window_Size.Y := Video_Informations^.current_h;

  // - Chargement des ressources.

  // - - Station
  Game.Sprites.Stations[0] := IMG_Load(Path_Image_Station_Circle);
  Game.Sprites.Stations[1] := IMG_Load(Path_Image_Station_Lozenge);
  Game.Sprites.Stations[2] := IMG_Load(Path_Image_Station_Pentagon);
  Game.Sprites.Stations[3] := IMG_Load(Path_Image_Station_Square);
  Game.Sprites.Stations[4] := IMG_Load(Path_Image_Station_Triangle);

  // - - Passenger
  Game.Sprites.Passengers[0] := IMG_Load(Path_Image_Passenger_Circle);
  Game.Sprites.Passengers[1] := IMG_Load(Path_Image_Passenger_Lozenge);
  Game.Sprites.Passengers[2] := IMG_Load(Path_Image_Passenger_Pentagon);
  Game.Sprites.Passengers[3] := IMG_Load(Path_Image_Passenger_Square);
  Game.Sprites.Passengers[4] := IMG_Load(Path_Image_Passenger_Triangle);


  // - - Véhicule (Locomotive et Wagon)

  Game.Sprites.Vehicle_0_Degree := IMG_Load(Path_Image_Vehicle);
  Game.Sprites.Vehicle_45_Degree := rotozoomSurface(Game.Sprites.Vehicle_0_Degree, 45, 1, 1);
  Game.Sprites.Vehicle_90_Degree := rotozoomSurface(Game.Sprites.Vehicle_0_Degree, 90, 1, 1);
  Game.Sprites.Vehicle_135_Degree := rotozoomSurface(Game.Sprites.Vehicle_0_Degree, 135, 1, 1);

  // - Fonts loading
  Game.Fonts[0] := TTF_OPENFONT(Path_Font, Font_Size_Normal);
  Game.Fonts[1] := TTF_OPENFONT(Path_Font_Bold, Font_Size_Normal);

  Graphics_Refresh(Game);
End;

Procedure Graphics_Unload(Var Game : Type_Game);

Var i : Byte;
Begin
  // - Unload sprites
  For i := 0 To Shapes_Number - 1 Do
    Begin
      SDL_FreeSurface(Game.Sprites.Stations[i]);
      SDL_FreeSurface(Game.Sprites.Passengers[i]);
    End;
  // Free the window in memory.
  SDL_FreeSurface(Game.Window);
  Game.Window := Nil;
  SDL_Quit();
End;

// Procédure rafraissant tout les éléments graphiques de l'écrans.
Procedure Graphics_Refresh(Var Game : Type_Game);

Var i, j:   Byte;
    Destionation_Rectangle : Type_Rectangle;
Begin
  // - Rempli la fenêtre en blanc.
  SDL_FillRect(Game.Window, Nil, SDL_MapRGB(Game.Window^.format, 255, 255, 255));

  If (length(Game.Lines) > 0) Then
    Begin
      // - Affichage des lignes.
      For i := low(Game.Lines) To high(Game.Lines) Do
        Begin
          // - Affichage des traits représentant la ligne à partir des coordonnées centrées des stations.
          If (length(Game.Lines[i].Stations) > 0) Then
            Begin
              For j := low(Game.Lines[i].Stations) To high(Game.Lines[i].Stations) - 1 Do
                Begin
                  Line_Render(Game.Lines[i].Stations[j]^.Position_Centered, Game.Lines[i].Stations[j + 1]^.Position_Centered, Game.Lines[i].Color, Game);
                 
                End;
            End;
          // - Affichage des trains sur la ligne.
          If (length(Game.Lines[i].Trains) > 0) Then
            Begin
              For j := low(Game.Lines[i].Trains) To high(Game.Lines[i].Trains) Do
                Begin
                  Train_Render(Game.Lines[i].Trains[j], Game.Lines[i], Game);
                End;
            End;
        End;
    End;

  If (length(Game.Stations) > 0) Then
    Begin
      // - Affichage les stations.
      For i := low(Game.Stations) To high(Game.Stations) Do
        Begin
          Station_Render(Game.Stations[i], Game);
        End;
    End;

  // - Textes
  Label_Render(Game.Score, Game.Window);

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

// Fonction qui calcule les coordonnées centrée d'un objet à partir de sa position dans le repère et sa taille.

// Fonction déterminant l'orientation d'un angle parmis : 0, 45, 90, 135, 180, -45, -90, -135.
Function Graphics_Get_Direction(Angle : Real) : Integer;

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

  If ((Angle >= 0) And (Angle < (Pi/8))) Then               // Si l'angle est entre 0° et 22.5°
    Graphics_Get_Direction := 0                             // L'orientation est de 0°;
  Else If ((Angle >= (Pi/8)) And (Angle < (3*Pi/8))) Then   // Si l'angle est entre 22.5° et 67.5°
         Graphics_Get_Direction := Sign * 45                // L'orientation est de 45° ou -45° (en fonction du signe).
  Else If ((Angle >= (3*Pi/8)) And (Angle < (5*Pi/8))) Then // Si l'angle est entre 67.5° et 112.5°
         Graphics_Get_Direction := Sign * 90                // L'orientation est de 90° ou -90° (en fonction du signe).
  Else If ((Angle >= (5*Pi/8)) And (Angle < (7*Pi/8))) Then // Si l'angle est entre 112.5° et 157.5°
         Graphics_Get_Direction := Sign * 135
                                   // L'orientation est de 135° ou -135° (en fonction du signe).
  Else If (Angle >= (7*Pi/8)) Then                          // Si l'angle est supérieur à 157.5°.
         Graphics_Get_Direction := 180;
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

// - Procédure génère le rendu dans la fenêtre des traits entre les stations en utilisant que des angles de 0, 45 et 90 degrés.
Procedure Line_Render(Position_1, Position_2 : Type_Coordinates; Color : Type_Color; Var Game :
                      Type_Game);

Var Intermediate_Position :   Type_Coordinates;
Begin

  Intermediate_Position := Station_Get_Intermediate_Position(Position_1, Position_2);

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

Procedure Train_Render(Var Train : Type_Train; Var Line : Type_Line; Var Game : Type_Game);

Var Destination_Rectangle : Type_Rectangle;
  i : Byte;
  Intermediate_Position : Type_Coordinates;
  Intermediate_Position_Distance : Integer;
  Direction : Integer;
  Norme : Integer;
  Centered_Position :   Type_Coordinates;
  Stations_Centered_Position : array[0..1] Of Type_Coordinates;
  // 0 : Station de départ, 2 : Station d'arrivée.

Begin
  // Calcul des coordonnées centrée des stations de départ et d'arrivé.

  Stations_Centered_Position[0] := Train.Last_Station^.Position_Centered;
  Stations_Centered_Position[1] := Train.Next_Station^.Position_Centered;
  // - Détermination du point intermédiaire.
  Intermediate_Position := Station_Get_Intermediate_Position(Stations_Centered_Position[0], Stations_Centered_Position[1]);
  Intermediate_Position_Distance := Graphics_Get_Distance(Stations_Centered_Position[0], Intermediate_Position);


  // - Détermination de la droite sur laquel le train se trouve et calcule l'angle du véhicule en conséquence.
  If (Train.Distance <= Intermediate_Position_Distance) Then // Si le train se trouve avant le point intermédiaire.
    Begin

      // Determination de l'angle et de la direction (arrondissement de l'angle).
      Direction := Graphics_Get_Direction(Graphics_Get_Angle(Stations_Centered_Position[0], Intermediate_Position));


      writeln('Dis < Inter, Direction : ', Direction, ' Intermediate :', Intermediate_Position_Distance, ' Distance : ', Train.Distance);


      If (Direction = 0) Then
        Begin
          Centered_Position.X := Stations_Centered_Position[0].X + Train.Distance;
          Centered_Position.Y := Stations_Centered_Position[0].Y;
          Train.Vehicles[0].Sprite := Game.Sprites.Vehicle_0_Degree;
        End
      Else If (Direction = 180) Then
             Begin
               Centered_Position.X := Stations_Centered_Position[0].X - Train.Distance;
               Centered_Position.Y := Stations_Centered_Position[0].Y;
               Train.Vehicles[0].Sprite := Game.Sprites.Vehicle_0_Degree;
             End
      Else If (Direction = 90) Then
             Begin
               Centered_Position.X := Stations_Centered_Position[0].X;
               Centered_Position.Y := Stations_Centered_Position[0].Y - Train.Distance;
               Train.Vehicles[0].Sprite := Game.Sprites.Vehicle_90_Degree;
             End
      Else If (Direction = -90) Then
             Begin
               Centered_Position.X := Stations_Centered_Position[0].X;
               Centered_Position.Y := Stations_Centered_Position[0].Y + Train.Distance;
               Train.Vehicles[0].Sprite := Game.Sprites.Vehicle_90_Degree;
             End
      Else
        Begin
          Norme := round(sqrt(sqr(Train.Distance*0.5)));
          If (Direction < 0) Then // Partie inférieur du cercle trigonométrique (sens des y positifs).
            Begin
              Centered_Position.Y := Stations_Centered_Position[0].Y + Norme;
              If (Direction = -45) Then
                Begin
                  Centered_Position.X := Stations_Centered_Position[0].X + Norme;
                  Train.Vehicles[0].Sprite := Game.Sprites.Vehicle_135_Degree;
                End
              Else
                Begin
                  Centered_Position.X := Stations_Centered_Position[0].X - Norme;
                  Train.Vehicles[0].Sprite := Game.Sprites.Vehicle_45_Degree;
                End;
            End
          Else  // Partie supérieur du cercle trigonométrique (sens des y négatifs).
            Begin
              Centered_Position.Y := Stations_Centered_Position[0].Y - Norme;
              If (Direction = 45) Then
                Begin
                  Centered_Position.X := Stations_Centered_Position[0].X + Norme;
                  Train.Vehicles[0].Sprite := Game.Sprites.Vehicle_45_Degree;
                End
              Else
                Begin
                  Centered_Position.X := Stations_Centered_Position[0].X - Norme;
                  Train.Vehicles[0].Sprite := Game.Sprites.Vehicle_135_Degree;
                End;
            End;
        End;
    End
  Else  // Si le train se trouve après le point intermédiaire.
    Begin

      // - Détermination de l'angle de la droite entre le point intermédiaire et la station d'arrivée.
      Direction := Graphics_Get_Direction(Graphics_Get_Angle(Intermediate_Position, Stations_Centered_Position[1]));

      writeln('Dis > Inter, Direction : ', Direction, ' Intermediate :', Intermediate_Position_Distance, ' Distance : ', Train.Distance);


      If (Direction = 0) Then
        Begin
          Centered_Position.X := Intermediate_Position.X + (Train.Distance - Intermediate_Position_Distance);
          Centered_Position.Y := Intermediate_Position.Y;
          Train.Vehicles[0].Sprite := Game.Sprites.Vehicle_0_Degree;
        End
      Else If (Direction = 180) Then
             Begin
               Centered_Position.X := Intermediate_Position.X - (Train.Distance - Intermediate_Position_Distance);
               Centered_Position.Y := Intermediate_Position.Y;
               Train.Vehicles[0].Sprite := Game.Sprites.Vehicle_0_Degree;
             End
      Else If (Direction = 90) Then
             Begin
               Centered_Position.X := Intermediate_Position.X;
               Centered_Position.Y := Intermediate_Position.Y - (Train.Distance - Intermediate_Position_Distance);
               Train.Vehicles[0].Sprite := Game.Sprites.Vehicle_90_Degree;
             End
      Else If (Direction = -90) Then
             Begin
               Centered_Position.X := Intermediate_Position.X;
               Centered_Position.Y := Intermediate_Position.Y + (Train.Distance - Intermediate_Position_Distance);
               Train.Vehicles[0].Sprite := Game.Sprites.Vehicle_90_Degree;
             End
      Else
        Begin
          Norme := round(sqrt(sqr((Train.Distance - Intermediate_Position_Distance)*0.5)));
          If (Direction < 0) Then // Partie inférieur du cercle trigonométrique (sens des y positifs).
            Begin
              Centered_Position.Y := Intermediate_Position.Y + Norme;
              If (Direction = -45) Then
                Begin
                  Centered_Position.X := Intermediate_Position.X + Norme;
                  Train.Vehicles[0].Sprite := Game.Sprites.Vehicle_135_Degree;
                End
              Else
                Begin
                  Centered_Position.X := Intermediate_Position.X - Norme;
                  Train.Vehicles[0].Sprite := Game.Sprites.Vehicle_45_Degree;
                End;
            End
          Else  // Partie supérieur du cercle trigonométrique (sens des y négatifs).
            Begin
              Centered_Position.Y := Intermediate_Position.Y - Norme;
              If (Direction = 45) Then
                Begin
                  Centered_Position.X := Intermediate_Position.X + Norme;
                  Train.Vehicles[0].Sprite := Game.Sprites.Vehicle_45_Degree;
                End
              Else
                Begin
                  Centered_Position.X := Intermediate_Position.X - Norme;
                  Train.Vehicles[0].Sprite := Game.Sprites.Vehicle_135_Degree;
                End;
            End;
        End;

    End;


  // - Détermination de la position absolue du train à partir des coordonnées centrées.
  If Direction = 0 Then
    Begin
      Destination_Rectangle.x := round(Centered_Position.X - (Vehicle_Width*0.5));
      Destination_Rectangle.y := round(Centered_Position.Y + (Vehicle_Height*0.5));
    End
  Else If Direction = 180 Then
         Begin
           Destination_Rectangle.x := round(Centered_Position.X - (Vehicle_Width*0.5));
           Destination_Rectangle.y := round(Centered_Position.Y - (Vehicle_Height*0.5));
         End
  Else If Direction = 90 Then
         Begin
           Destination_Rectangle.x := round(Centered_Position.X - (Vehicle_Height*0.5));
           Destination_Rectangle.y := round(Centered_Position.Y - (Vehicle_Width*0.5));
         End
  Else If Direction = -90 Then
         Begin
           Destination_Rectangle.x := round(Centered_Position.X - (Vehicle_Height*0.5));
           Destination_Rectangle.y := round(Centered_Position.Y - (Vehicle_Width*0.5));
         End
  Else
    Begin















{
      Square_Side_Length := round(sqrt(sqr(Vehicle_Width)*0.5)+sqrt(sqr(Vehicle_Height)*0.5));
      //Se référer au rapport du projet pour les explications
      Train.Vehicle[0].Position.X := round(Centered_Position.X - Square_Side_Length*0.5);
      Train.Vehicle[0].Position.Y := round(Centered_Position.Y - Square_Side_Length*0.5);
}
      Destination_Rectangle.x := Centered_Position.X;
      Destination_Rectangle.y := Centered_Position.Y;
    End;


  // - Affiche la locomotive.
  SDL_BlitSurface(Train.Vehicles[0].Sprite, Nil, Game.Window, @Destination_Rectangle);
  // - Affiche les passagers. 
  {If (Train.Passengers_Count > 0) Then
    Begin
      // - Display the passengers
    End;
  }
End;

Procedure Station_Render(Var Station : Type_Station; Var Game : Type_Game);

Var Destination_Rectangle :   Type_Rectangle;
  i :   Byte;
Begin
  // Display station
  Destination_Rectangle.x := Station.Position.X;
  Destination_Rectangle.y := Station.Position.Y;
  Destination_Rectangle.w := Station_Width;
  Destination_Rectangle.h := Station_Height;

  SDL_BlitSurface(Station.Sprite, Nil, Game.Window, @Destination_Rectangle);

  // Display station passengers

  Destination_Rectangle.w := Passenger_Width;
  Destination_Rectangle.h := Passenger_Height;

  If (length(Station.Passengers) > 0) Then
    Begin
      For i := low(Station.Passengers) To high(Station.Passengers) Do
        Begin
          // - Determine x position
          If (i < 3) Then
            Destination_Rectangle.x := (Station.Position.X - (2 *
                                       Passenger_Width))
          Else
            Destination_Rectangle.x := (Station.Position.X + Station_Width +
                                       Passenger_Width);
          // - Determine y position
          Destination_Rectangle.y := Station.Position.Y + ((i Mod 3) * (
                                     Passenger_Height + 4));

          SDL_BlitSurface(Station.Passengers[i]^.Sprite, Nil, Game.Window, @
                          Destination_Rectangle);
        End;
    End;
End;

End.
