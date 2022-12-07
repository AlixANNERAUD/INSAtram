
Unit Unit_Types;

// Cette unité contient :
// - les constantes parametrant le jeu.
// - les types de données principaux (alias, structures).
// - les fonctions et procédures pour l'allocation et désallocation de ses types.

Interface

// - Dépendances

Uses sdl, sdl_mixer, sdl_image, sdl_ttf, sysutils, Math;

// - Déclaration des constantes

// - - Réglages généraux

// - - - Graphismes

Const Color_Depth =   32;

Const Full_Screen =  False;

Const Screen_Width =  960;

Const Screen_Height =  720;

Const Mask_Alpha =  $FF000000;

Const Mask_Red =  $000000FF;

Const Mask_Green =  $0000FF00;

Const Mask_Blue =  $00FF0000;

  // - - - Répertoires des ressources.

  // - - - - Images

Const Path_Ressources =  'Resources/';

Const Path_Images =  Path_Ressources + 'Images/';

Const Path_Image_Station_Circle =   Path_Images + 'Station_Circle.png';

Const Path_Image_Station_Square =   Path_Images + 'Station_Square.png';

Const Path_Image_Station_Triangle =   Path_Images + 'Station_Triangle.png';

Const Path_Image_Station_Pentagon =   Path_Images + 'Station_Pentagon.png';

Const Path_Image_Station_Lozenge =   Path_Images + 'Station_Lozenge.png';

Const Path_Image_Passenger_Circle =   Path_Images + 'Passenger_Circle.png';

Const Path_Image_Passenger_Square =   Path_Images + 'Passenger_Square.png';

Const Path_Image_Passenger_Triangle =   Path_Images + 'Passenger_Triangle.png';

Const Path_Image_Passenger_Pentagon =   Path_Images + 'Passenger_Pentagon.png';

Const Path_Image_Passenger_Lozenge =   Path_Images + 'Passenger_Lozenge.png';

Const Path_Image_Vehicle =   Path_Images + 'Vehicle.png';

Const Path_Image_People = Path_Images + 'People.png';

Const Path_Image_Clock = Path_Images + 'Clock.png';

Const Path_Image_Play = Path_Images + 'Play.png';

Const Path_Image_Pause = Path_Images + 'Pause.png';

Const Path_Image_Button_Locomotive = Path_Images + 'Locomotive.png';

Const Path_Image_Button_Wagon = Path_Images + 'Wagon.png';

Const Path_Image_Button_Tunnel = Path_Images + 'Tunnel.png';

  // - - - - Polices

Const Path_Fonts = Path_Ressources + 'Fonts/';

Const Path_Font =   Path_Fonts + '/FreeSans.ttf';

Const Path_Font_Bold = Path_Fonts + '/FreeSansBold.ttf';

  // - - - - Sons

Const Path_Sounds = Path_Ressources + 'Sounds/';

Const Path_Sounds_Music = Path_Sounds + 'Sounds.wav';

Const Mouse_Hit_Box_Size =  10;


  // - Sons

Const Sounds_Sampling_Rate = 22050;
  Sounds_Format : Word = AUDIO_S16;
  Sounds_Channels : INTEGER = 2;
  Sounds_Chunck_Size : INTEGER = 4096;
  Sounds_Maximum_Volume = 128;


  // - - - Jeux

  // - - - - Entités

Const Game_Maximum_Lines_Number = 8;

Const Maximum_Number_Stations = 200;

Const Game_Day_Duration =  10;

  // - - - Shapes

Const Shapes_Number = 5;

  // - - - Station

  // - - - Véhicules (locomotive et wagon).

Const Vehicle_Width =   32;

Const Vehicle_Height =   24;

  // - - - Passagers

Const Passenger_Width =   8;

Const Passenger_Height =   8;

  // - - - Trains

  // - - - - Vehicles

Const Vehicle_Maximum_Passengers_Number = 6;

Const Train_Maximum_Vehicles_Number = 3;

  // Vitesse maximum d'un train en px/s.

Const Train_Maximum_Speed = 4;

  // Acceleration d'un train.

Const Train_Acceleration = 2;

  // Distance d'accélaration (equation horaires).

Const Train_Acceleration_Distance = 0.5 * ((Train_Maximum_Speed*Train_Maximum_Speed) / Train_Acceleration);


  // - - - Lignes

Const Lines_Maximum_Number_Stations = 20;

Const Lines_Maximum_Number_Trains = 4;

  // - Définition des types



  // - - Graphismes

Type Type_Color = Record
  Red, Green, Blue, Alpha : Byte;
End;

Type Type_Coordinates = Record
  X, Y : LongInt;
End;

// - - - Interface graphique

Type Type_Label = Record
  Position, Size : Type_Coordinates;
  Text : String;
  Font : pTTF_Font;
  Color : Type_Color;
  Surface : PSDL_Surface;
End;

Type Type_Panel = Record
  Position, Size : Type_Coordinates;
  Surface : PSDL_Surface;
  Color : Type_Color;
End;

Type Type_Image = Record
  Position, Size : Type_Coordinates;
  Surface : PSDL_Surface;
End;

Type Type_Button = Record
  Position, Size : Type_Coordinates;
  Pressed : Boolean;
  Surface_Pressed : PSDL_Surface;
  Surface_Released : PSDL_Surface;
End;

Type Type_Dual_State_Button = Record
  Position, Size : Type_Coordinates;
  Pressed : Boolean;
  State : Boolean;
  Surface_Pressed : array[0 .. 1] Of PSDL_Surface;
  Surface_Released : array[0 .. 1] Of PSDL_Surface;
End;

// - - Temps

Type Type_Time = Longword;

Type Type_Day = (Day_Monday,
                 Day_Tuesday,
                 Day_Wednesday,
                 Day_Thursday,
                 Day_Friday,
                 Day_Saturday,
                 Day_Sunday
                );

  // Structure contenant tous pointeurs des sprites du jeu.

Type Type_Font_Size = (Font_Small, Font_Medium, Font_Big);

Type Type_Font_Weight = (Font_Normal, Font_Bold);

Type Type_Color_Name = (Color_Black,
                        Color_Red,
                        Color_Purple,
                        Color_Deep_Purple,
                        Color_Indigo,
                        Color_Blue,
                        Color_Light_Blue,
                        Color_Cyan,
                        Color_Teal,
                        Color_Green,
                        Color_Light_Green,
                        Color_Lime,
                        Color_Yellow,
                        Color_Amber,
                        Color_Orange,
                        Color_Deep_Orange,
                        Color_Brown,
                        Color_Grey,
                        Color_Blue_Grey,
                        Color_White
                       );


Type Type_Ressources = Record
  // Polices de caractères.
  Fonts : Array [Font_Small..Font_Big, Font_Normal..Font_Bold] Of pTTF_Font;
  // Stations (5 formes différentes).
  Stations : Array [0 .. (Shapes_Number - 1)] Of PSDL_Surface;
  // Passagers (5 formes différentes).
  Passengers : Array [0 .. (Shapes_Number - 1)] Of PSDL_Surface;
  // Vehicles (locomotive et wagon).
  Vehicle_0_Degree, Vehicle_45_Degree, Vehicle_90_Degree, Vehicle_135_Degree : PSDL_Surface;
  // Sons
  Music : pMIX_MUSIC; 
  =  =  =  =  =  =  = 
                      >>>>>>> Stashed changes
End;

// - - Entités du jeux.

Type Type_Shape = (Circle, Lozenge, Pentagon, Square, Triangle);

Type Type_Station_Pointer = ^Type_Station;

  Type_Passenger = Record
    // Taille du passager.
    Size : Type_Coordinates;
    // Forme du passager (et donc sa station de destination).
    Shape : Type_Shape;
    // Pointeur vers le sprite du passager.
    Sprite : PSDL_Surface;
    // Itinéraire du passager.
    Itinerary : Array Of Type_Station_Pointer;
  End;

  Type_Passenger_Pointer = ^Type_Passenger;

  // - - Station

  Type_Station = Record
    // Position, position centrée et taille de la stations.
    Position, Size, Position_Centered : Type_Coordinates;
    // Forme de la station.
    Shape : Type_Shape;
    // Pointeur vers le sprite de la station.
    Sprite : PSDL_Surface;
    // Passagers de la station.
    Passengers : array Of Type_Passenger_Pointer;
  End;

  Type_Vehicle = Record
    // Passagers dans le véhicule.
    Passengers : Array[0 .. (Vehicle_Maximum_Passengers_Number - 1)] Of Type_Passenger_Pointer;
  End;

  Type_Train = Record
    // Position du train.
    Position, Size : Type_Coordinates;
    // Sprite du train.
    Sprite : PSDL_Surface;
    Timer : Type_Time;
    // Détermine si le train est à l'arrêt ou non.
    Driving : Boolean;
    // Pointeur de la dernière station.
    Last_Station : Type_Station_Pointer;
    // Pointeur de la prochaine station.
    Next_Station : Type_Station_Pointer;
    // Distance parcourue depuis la dernière station en pixel.
    Distance : Integer;
    // Copie de la position intermédiaire actuelle entre les stations.
    Intermediate_Position : Type_Coordinates;
    // Distance de la prochaine position intermédiaire.
    Intermediate_Position_Distance : Integer;
    // - Distance maximum;
    Maximum_Distance : Integer;
    // Direction directe ou indirecte du train (indexe des stations de la ligne croissant ou décroissant).
    Direction : Boolean;
    // - Vitesse du train.
    Speed : Integer;
    //  Tableau contenant les wagons du train.
    Vehicles : array Of Type_Vehicle;
    // Etiquette 
    Passengers_Label : Type_Label;

  End;

  Type_Train_Pointer = ^Type_Train;
  // - - Line

Type Type_Line_Colors = (Red, Purple, Indigo, Teal, Green, Yellow, Orange, Brown);

  Type_Line = Record
    // Couleur de la ligne.
    Color : Type_Color;
    // Tableau dynamique de pointeur vers les stations.
    Stations : array Of Type_Station_Pointer;
    // Tableau dynamique des positions intermédiaires pré-calculées.
    Intermediate_Positions : Array Of Type_Coordinates;
    // Tableau dynamique contenant les trains.
    Trains : array Of Type_Train;
    // Boutton de la ligne.
    Button : Type_Dual_State_Button;
  End;

  Type_Line_Pointer = ^Type_Line;

Type Type_Player = Record
  Score : Integer;
  Locomotive_Token : Byte;
  Wagon_Token : Byte;
  Tunnel_Token : Byte;
  Show : Boolean;
End;

// - Itineraries

Type Type_Graph_Table = Array Of Array Of Array[0..Game_Maximum_Lines_Number-1] Of Type_Line_Pointer;

Type Type_Dijkstra_Cell = Record
  isConnected : Boolean;
  isAvailable : Boolean;
  comingFromStationIndex : Integer;
  weight : Real;
  isValidated : Boolean;
End;

Type Type_Itinerary_Indexes = Array Of Integer;


  // - - Souris

Type Type_Mouse_Mode = (Normal, Delete_Locomotive, Add_Locomotive, Add_Wagon, Line_Add_Station, Line_Insert_Station);

Type Type_Mouse = Record
  Press_Position, Release_Position : Type_Coordinates;
  Mode : Type_Mouse_Mode;
  State : Boolean;
  Selected_Train : Type_Train_Pointer;
  Selected_Line : Type_Line_Pointer;
  Selected_Last_Station, Selected_Next_Station : Type_Line_Station;

End;

// - - Partie

Type Type_Game = Record

  Start_Time : Type_Time;
  Day : Type_Day;

  // Temporisateur déterminant rendre les graphismes.
  Graphics_Timer : Type_Time;
  // Temporisateur déterminant quand générer un nouveau passager.
  Passengers_Timer : Type_Time;

  // Souris
  Mouse : Type_Mouse;
  // Fenêtre du jeu.
  Window : Type_Panel;
  // Panneau contenant le terrain de jeu. 
  Panel_Right : Type_Panel;

  // Panneau contenant l'interface du haut (score, heure ...).
  Panel_Top : Type_Panel;
  Play_Pause_Button : Type_Dual_State_Button;
  Score_Label : Type_Label;
  Score_Image : Type_Image;
  Clock_Label : Type_Label;
  Clock_Image : Type_Image;

  // Panneau contenant l'interface du bas (selection des lignes).
  Panel_Bottom : Type_Panel;

  // Panneau contenant l'interface de gauche (train, wagon, tunnel).
  Panel_Left : Type_Panel;
  Locomotive_Button : Type_Button;
  Wagon_Button : Type_Button;
  Tunnel_Button : Type_Button;

  // Structure contenant les sprites du jeu.
  Ressources : Type_Ressources;
  // Inventaire
  Player : Type_Player;
  // Stations
  // Tableau dymamique contenant les stations.
  Stations : Array Of Type_Station;
  // Tableau des 
  River_Points : Array Of Type_Coordinates;
  // Un échiquier des stations dont la hauteur contient les lignes qui relient les dites stations.  
  Graph_Table : Type_Graph_Table;
  // Carte des stations.
  Stations_Map : Array Of Array Of Boolean;
  // Tableau de dijkstra.
  Dijkstra_Table : Array Of Array Of Type_Dijkstra_Cell;


  // Lignes
  // Tableau dynamque contenant les lignes.
  Lines : array Of Type_Line;
End;

// Menu principal du jeu.

Type Type_Menu = Record
  Logo : Type_Image;
  Play_Label : Type_Label;
  Play_Image : Type_Image;

  Options_Label : Type_Label;
  Options_Image : Type_Image;

End;

// Options du jeu.

Type Type_Options = Record

  Sound_Button : Type_Button;

End;

Type Type_Game_Pointer = ^Type_Game;


  // - Function declaration

Function Get_Center_Position(Position, Size : Type_Coordinates) : Type_Coordinates;

Function Get_Centered_Position(Container_Size, Size : Integer) : Integer;


// - - Object creation.

Function Station_Create(Var Game: Type_Game) : Boolean;
Function Line_Create(Var Game : Type_Game) : Boolean;
Procedure Passenger_Create(Var Station : Type_Station; Var Game : Type_Game);
Function Train_Create(Start_Station : Type_Station_Pointer; Direction : Boolean; Var Line : Type_Line; Var Game : Type_Game) : Boolean;
Function Vehicle_Create(Var Train : Type_Train) : Boolean;



// - - Object deletion.


Procedure Line_Compute_Intermediate_Positions(Var Line : Type_Line);
Function Line_Delete(Var Line : Type_Line; Var Game : Type_Game) : Boolean;
Function Line_Add_Station(Station_Pointer : Type_Station_Pointer; Var Line : Type_Line) : Boolean;
Function Line_Add_Station(Last_Station_Pointer, Station_Pointer : Type_Station_Pointer; Var Line : Type_Line) : Boolean;
Function Line_Remove_Station(Station_Pointer : Type_Station_Pointer; Var Line : Type_Line) : Boolean;

//Function Train_Delete(Var Train : Type_Train; Var Line : Type_Train) : Boolean;
//Function Vehicle_Delete(Var Vehicle : Type_Vehicle; Var Train : Type_Train) : Boolean;

Function Passenger_Delete(Var Passenger : Type_Passenger_Pointer) : Boolean;

// - - Time

Function Time_Get_Current(): Type_Time;
Function Time_Get_Elapsed(Start_Time : Type_Time) : Type_Time;

// - - Shape

Function Lines_Colliding(Line_1, Line_2, Line_3, Line_4 : Type_Coordinates) : Boolean;
Function Line_Rectangle_Colliding(Line_A, Line_B, Rectangle_Position, Rectangle_Size : Type_Coordinates) : Boolean;

Function Number_To_Shape(Number : Byte) : Type_Shape;

Function String_To_Characters(String_To_Convert : String) : pChar;

Function Get_Angle(Position_1, Position_2 : Type_Coordinates):   Real;

Function Get_Distance(Position_1, Position_2 : Type_Coordinates) : Integer;
Function Station_Get_Intermediate_Position(Position_1, Position_2 : Type_Coordinates) :   Type_Coordinates;

Function Time_Index_To_Day(Day_Index : Byte) : Type_Day;

Function Day_To_String(Day : Type_Day) : String;

Function Panel_Get_Relative_Position(Absolute_Position : Type_Coordinates; Panel : Type_Panel) : Type_Coordinates;

Function Lines_Intersects(a1, a2, b1, b2 : Type_Coordinates) : Boolean;

Implementation

Function Panel_Get_Relative_Position(Absolute_Position : Type_Coordinates; Panel : Type_Panel) : Type_Coordinates;
Begin
  Panel_Get_Relative_Position.X := Absolute_Position.X - Panel.Position.X;
  Panel_Get_Relative_Position.Y := Absolute_Position.Y - Panel.Position.Y;
End;

// Fonction qui détecte si un rectangle et une ligne sont en colision.
Function Line_Rectangle_Colliding(Line_A, Line_B, Rectangle_Position, Rectangle_Size : Type_Coordinates) : Boolean;
Function Color_Get() : Type_Color;

Function Lines_Get_Selected(Game : Type_Game) : Type_Line_Pointer;

Implementation

// Fonction qui renvoie la ligne actuellement sélectionnée où Nil s'il y en a pas.
Function Lines_Get_Selected(Game : Type_Game) : Type_Line_Pointer;

Var i : Byte;
Begin
  // Vérifie si il y a des lignes.
  Lines_Get_Selected := Nil;
  If (length(Game.Lines) > 0) Then
    Begin
      For i := low(Game.Lines) To high(Game.Lines) Do
        Begin
          If (Game.Lines[i].Button.State = true) Then
            Begin
              Lines_Get_Selected := @Game.Lines[i];
              Break;
            End;
        End;
    End;
End;

Function Color_Get(Color : Type_Color_Name) : Type_Color;
Begin
  Case Color Of 
    Color_Black : Color_Get := Color_Get(0, 0, 0, 255);
    Color_Red : Color_Get := Color_Get(244, 64, 54, 255);
    Color_Purple : Color_Get := Color_Get(156, 39, 176, 255);
    Color_Deep_Purple : Color_Get := Color_Get(103, 58, 183, 255);
    Color_Indigo : Color_Get := Color_Get(63, 81, 181, 255);
    Color_Blue : Color_Get := Color_Get(33, 150, 243, 255);
    Color_Light_Blue : Color_Get := Color_Get(3, 169, 244, 255);
    Color_Cyan : Color_Get := Color_Get(0, 188, 212, 255);
    Color_Teal : Color_Get := Color_Get(0, 150, 136, 255);
    Color_Green : Color_Get := Color_Get(76, 175, 80, 255);
    Color_Light_Green : Color_Get := Color_Get(139, 195, 74, 255);
    Color_Lime : Color_Get := Color_Get(205, 220, 57, 255);
    Color_Yellow : Color_Get := Color_Get(255, 235, 59, 255);
    Color_Amber : Color_Get := Color_Get(255, 193, 7, 255);
    Color_Orange : Color_Get := Color_Get(255, 152, 0, 255);
    Color_Deep_Orange : Color_Get := Color_Get(255, 87, 34, 255);
    Color_Brown : Color_Get := Color_Get(121, 85, 72, 255);
    Color_Grey : Color_Get := Color_Get(158, 158, 158, 255);
    Color_Blue_Grey : Color_Get := Color_Get(96, 125, 139, 255);
    Color_White : Color_Get := Color_Get(255, 255, 255, 255);
  End;







{
    // - Set colors from palette (from Google's Material Design palette).
  Game.Ressources.Palette[Color_Black] := Color_Get(0, 0, 0, 255);
  Game.Ressources.Palette[Color_Red] := Color_Get(244, 64, 54, 255);
  Game.Ressources.Palette[Color_Purple] := Color_Get(156, 39, 176, 255);
  Game.Ressources.Palette[Color_Deep_Purple] := Color_Get(103, 58, 183, 255);
  Game.Ressources.Palette[Color_Indigo] := Color_Get(63, 81, 181, 255);
  Game.Ressources.Palette[Color_Blue] := Color_Get(33, 150, 243, 255);
  Game.Ressources.Palette[Color_Light_Blue] := Color_Get(3, 169, 244, 255);
  Game.Ressources.Palette[Color_Cyan] := Color_Get(0, 188, 212, 255);
  Game.Ressources.Palette[Color_Teal] := Color_Get(0, 150, 136, 255);
  Game.Ressources.Palette[Color_Green] := Color_Get(76, 175, 80, 255);
  Game.Ressources.Palette[Color_Light_Green] := Color_Get(139, 195, 74, 255);
  Game.Ressources.Palette[Color_Lime] := Color_Get(205, 220, 57, 255);
  Game.Ressources.Palette[Color_Yellow] := Color_Get(255, 235, 59, 255);
  Game.Ressources.Palette[Color_Amber] := Color_Get(255, 193, 7, 255);
  Game.Ressources.Palette[Color_Orange] := Color_Get(255, 152, 0, 255);
  Game.Ressources.Palette[Color_Deep_Orange] := Color_Get(255, 87, 34, 255);
  Game.Ressources.Palette[Color_Brown] := Color_Get(121, 85, 72, 255);
  Game.Ressources.Palette[Color_Grey] := Color_Get(158, 158, 158, 255);
  Game.Ressources.Palette[Color_Blue_Grey] := Color_Get(96, 125, 139, 255);
  Game.Ressources.Palette[Color_White] := Color_Get(255, 255, 255, 255);
}
End;

// Fonction qui détecte si un rectangle et une ligne sont en colision.
Function Line_Rectangle_Colling(Line_A, Line_B, Rectangle_Position, Rectangle_Size : Type_Coordinates) : Boolean;

Var 
  Temporary_Line : Array[0 .. 1] Of Type_Coordinates;
Begin
  // Les quatres côtés du rectangles sont décomposés en 4 lignes.
  // La détection se fait ensuite ligne par ligne.
  // Les détections sont imbriqués afin de ne pas faire de calculs inutiles.

  // Côté gauche du rectangle.
  Temporary_Line[0].X := Rectangle_Position.X;
  Temporary_Line[0].Y := Rectangle_Position.Y;
  Temporary_Line[1].X := Rectangle_Position.X;
  Temporary_Line[1].Y := Rectangle_Position.Y+Rectangle_Size.Y;

  If (Lines_Intersects(Line_A, Line_B, Temporary_Line[0], Temporary_Line[1]) = False) Then
    Begin
      // Côté droit du rectangle.
      Temporary_Line[0].X := Rectangle_Position.X+Rectangle_Size.X;
      Temporary_Line[0].Y := Rectangle_Position.Y;
      Temporary_Line[1].X := Rectangle_Position.X+Rectangle_Size.X;
      Temporary_Line[1].Y := Rectangle_Position.Y+Rectangle_Size.Y;

      If (Lines_Intersects(Line_A, Line_B, Temporary_Line[0], Temporary_Line[1]) = False) Then
        Begin

          // Côté en haut du rectangle.

          Temporary_Line[0].X := Rectangle_Position.X;
          Temporary_Line[0].Y := Rectangle_Position.Y;
          Temporary_Line[1].X := Rectangle_Position.X + Rectangle_Size.X;
          Temporary_Line[1].Y := Rectangle_Position.Y;

          If (Lines_Intersects(Line_A, Line_B, Temporary_Line[0], Temporary_Line[1]) = False) Then
            Begin
              // Coté en bas du rectangle.
              Temporary_Line[0].X := Rectangle_Position.X;
              Temporary_Line[0].Y := Rectangle_Position.Y+Rectangle_Size.Y;
              Temporary_Line[1].X := Rectangle_Position.X+Rectangle_Size.X;
              Temporary_Line[1].Y := Rectangle_Position.Y+Rectangle_Size.Y;

              If (Lines_Intersects(Line_A, Line_B, Temporary_Line[0], Temporary_Line[1]) = False) Then
                Line_Rectangle_Colliding := False
              Else
                Line_Rectangle_Colliding := True;
            End
          Else
            Line_Rectangle_Colliding := True;
        End
      Else
        Line_Rectangle_Colliding := True;
    End
  Else
    Line_Rectangle_Colliding := True;
End;


// a1 is line1 start, a2 is line1 end, b1 is line2 start, b2 is line2 end
Function Lines_Intersects(a1, a2, b1, b2 : Type_Coordinates) : Boolean;

Var B, D, C : Type_Coordinates;
  BD, T : Real;
Begin
  B.X := a2.X - a1.X;
  B.Y := a2.Y - a1.Y;

  D.X := b2.X - b1.X;
  D.Y := b2.Y - b1.Y;

  BD := (B.X * D.Y) - (B.Y * D.X);

  // if b dot d == 0, it means the lines are parallel so have infinite intersection points
  If (BD = 0) Then
    Lines_Intersects := false
  Else
    Begin
      C.X := b1.X - a1.X;
      C.Y := b1.Y - a1.Y;

      T := ((C.X * D.Y) - (C.Y * D.X)) / BD;

      If ((T < 0) Or (T > 1)) Then
        Lines_Intersects := false
      Else
        Begin
          T := ((C.X * B.Y) - (C.Y * b.X)) / BD;

          If ((T < 0) Or (T > 1)) Then
            Lines_Intersects := false
          Else
            Lines_Intersects := true;
        End;
    End;
End;


// Fonction qui détecte si deux lignes sont sécantes.
Function Lines_Colliding(Line_1, Line_2, Line_3, Line_4 : Type_Coordinates) : Boolean;

Var Coeffcient_A, Coeffcient_B : Real;
Begin
  writeln('Line_1.X : ', Line_1.X, ' Line_1.Y : ', Line_1.Y);
  writeln('Line_2.X : ', Line_2.X, ' Line_2.Y : ', Line_2.Y);
  writeln('Line_3.X : ', Line_3.X, ' Line_3.Y : ', Line_3.Y);
  writeln('Line_4.X : ', Line_4.X, ' Line_4.Y : ', Line_4.Y);


  Coeffcient_A := ((Line_4.X-Line_3.X)*(Line_1.Y-Line_3.Y) - (Line_4.Y-Line_3.Y)*(Line_1.X-Line_3.X)) / ((Line_4.Y-Line_3.Y)*(Line_2.X-Line_1.X) - (Line_4.X-Line_3.X)*(Line_2.Y-Line_1.Y));

  Coeffcient_B := ((Line_2.X-Line_1.X)*(Line_1.Y-Line_3.Y) - (Line_2.Y-Line_1.Y)*(Line_1.X-Line_3.X)) / ((Line_4.Y-Line_3.Y)*(Line_2.X-Line_1.X) - (Line_4.X-Line_3.X)*(Line_2.Y-Line_1.Y));

  If ((Coeffcient_A  >= 0) And (Coeffcient_A <= 1) And (Coeffcient_B >= 0) And (Coeffcient_B <= 1)) Then
    Lines_Colliding := true
  Else
    Lines_Colliding := false;
End;


Function Day_To_String(Day : Type_Day) : String;
Begin
  Case Day Of 
    Day_Monday : Day_To_String := 'Monday';
    Day_Tuesday : Day_To_String := 'Tuesday';
    Day_Wednesday : Day_To_String := 'Wednesday';
    Day_Thursday : Day_To_String := 'Thursday';
    Day_Friday : Day_To_String := 'Friday';
    Day_Saturday : Day_To_String := 'Saturday';
    Day_Sunday : Day_To_String := 'Sunday';
  End;
End;

Function Time_Index_To_Day(Day_Index : Byte) : Type_Day;
Begin
  Case Day_Index Of 
    0 : Time_Index_To_Day := Day_Monday;
    1 : Time_Index_To_Day := Day_Tuesday;
    2 : Time_Index_To_Day := Day_Wednesday;
    3 : Time_Index_To_Day := Day_Thursday;
    4 : Time_Index_To_Day := Day_Friday;
    5 : Time_Index_To_Day := Day_Saturday;
    6 : Time_Index_To_Day := Day_Sunday;
  End;
End;

Function Get_Distance(Position_1, Position_2 : Type_Coordinates):   Integer;
Begin
  Get_Distance := round(sqrt(sqr(Position_2.X-Position_1.X)+sqr(Position_2.Y-Position_1.Y)));
End;

// - Définition des fonctions et procédures.

// Fonction qui renvoi l'angle entre deux points.
Function Get_Angle(Position_1, Position_2 : Type_Coordinates):   Real;
Begin
  Get_Angle := ArcTan2(-Position_2.Y + Position_1.Y,
               Position_2.X - Position_1.X);
End;

// Fonction qui calcule les positions intermédiaires spérant les stations d'une ligne.
Procedure Line_Compute_Intermediate_Positions(Var Line : Type_Line);

Var i : Byte;
Begin
  // Définition de la taille du tableau.
  SetLength(Line.Intermediate_Positions, length(Line.Stations) - 1);
  // Vérifie qu'il y a bien au moins une stations dans la ligne.
  If (length(Line.Stations) > 1) Then
    Begin
      // Itère parmi les stations.
      For i := low(Line.Stations) To (high(Line.Stations) - 1) Do
        Begin
          // Calcule la position intermédiaire.
          Line.Intermediate_Positions[i + low(Line.Intermediate_Positions)] := Station_Get_Intermediate_Position(Line.Stations[i]^.Position_Centered, Line.Stations[i + 1]^.
                                                                               Position_Centered);
        End;
    End;

End;

// Fonction qui calcule la position intermédiaire entre deux stations.
Function Station_Get_Intermediate_Position(Position_1, Position_2 : Type_Coordinates) :   Type_Coordinates;

Var Angle :   Real;
Begin
  Angle := Get_Angle(Position_1, Position_2);

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

// Fonction supprimant une station
Procedure Stations_Delete(Var Station : Type_Station; Var Game : Type_Game);

Var 
  i : Byte;
Begin

















  <<<<<<< Updated upstream 

  =  =  =  =  =  =  = 
                      >>>>>>> Stashed changes










{ 
  For i := low(Station.Passengers) To high(Station.Passengers) Do
    Passenger_Delete(Station.Passengers[i]^, Station);

  For i := low(Game.Stations) To high(Game.Stations) Do
    Begin
      If Game.Stations[i] = Station Then
        Begin
          Game.Stations[i] := Game.Stations[high(Game.Stations)];
          SetLength(Game.Stations, Length(Game.Stations) - 1);
          Break;
        End;


    End;
}
End;

Function String_To_Characters(String_To_Convert : String) : pChar;

Var Characters : pChar;
Begin
  Characters := StrAlloc(length(String_To_Convert) + 1);
  StrPCopy(Characters, String_To_Convert);
  String_To_Characters := Characters;
End;

// - Définition des fonctions et procédures

// - Création

Function Get_Center_Position(Position, Size : Type_Coordinates) : Type_Coordinates;
Begin
  Position.X := Position.X + (Size.X Div 2);
  Position.Y := Position.Y + (Size.Y Div 2);
  Get_Center_Position := Position;
End;

Function Get_Centered_Position(Container_Size, Size : Integer) : Integer;
Begin
  Get_Centered_Position := (Container_Size - Size) Div 2;
End;

// Procédure qui alloue de la mémoire pour une station et le référence dans le tableau dynamique, détermine sa forme et position aléatoirement et defini ses attributs.
Function Station_Create(Var Game : Type_Game) : Boolean;

Var Shape : Byte;
  Position : Type_Coordinates;
  i : Byte;
Begin
  If (length(Game.Stations) < Maximum_Number_Stations) Then
    Begin
      // Allocation de la station dans le tableau.
      SetLength(Game.Stations, length(Game.Stations) + 1);

      // Initialisation des attributs par défaut.
      // Détermination de la forme de la station.
      If (length(Game.Stations) <= 5) Then
        // Les 5 premières stations doivent être de forme différentes pour pemetre à tout type de passager d'arriver à destionation.
        Shape := length(Game.Stations) - 1
      Else
        // Les stations suivantes peuvent avoir une forme aléatoire.
        Shape := Random(5);

      Game.Stations[high(Game.Stations)].Shape := Number_To_Shape(Shape);
      Game.Stations[high(Game.Stations)].Sprite := Game.Ressources.Stations[Shape];


      Game.Stations[high(Game.Stations)].Size.X := Game.Stations[high(Game.Stations)].Sprite^.w;

      Game.Stations[high(Game.Stations)].Size.Y := Game.Stations[high(Game.Stations)].Sprite^.h;

      // Détermination de la position de la station.
      Repeat
        Position.X := Random(length(Game.Stations_Map));
        Position.Y := Random(length(Game.Stations_Map[high(Game.Stations_Map)]));
      Until Game.Stations_Map[Position.X][Position.Y] = false;

      Game.Stations_Map[Position.X][Position.Y] := true;

      Game.Stations[high(Game.Stations)].Position.X := 64 * Position.X;
      Game.Stations[high(Game.Stations)].Position.Y := 64 * Position.Y;

      // Augmentation du nombre d'entrée dans le tableau de résolutions.
      SetLength(Game.Graph_Table, length(Game.Stations));
      For i := low(Game.Graph_Table) To high(Game.Graph_Table) Do
        SetLength(Game.Graph_Table[i], length(Game.Stations));

      SetLength(Game.Dijkstra_Table, length(Game.Stations));
      For i := low(Game.Dijkstra_Table) To high(Game.Dijkstra_Table) Do
        SetLength(Game.Dijkstra_Table[i], length(Game.Stations));

      // Calcul les coordoonées centré de la station.
      Game.Stations[high(Game.Stations)].Position_Centered := Get_Center_Position(Game.Stations[high(Game.Stations)].Position, Game.Stations[high(Game.Stations)].Size);

      Station_Create := True;
    End
  Else
    Station_Create := False;
End;

// Procédure qui créer une ligne.
Function Line_Create(Var Game : Type_Game) : Boolean;

Var i, j : Byte;
  Colors : Set Of (Color_Red, Color_Purple, Color_Indigo, Color_Teal, Color_Green, Color_Yellow, Color_Orange, Color_Brown);
  Color : Type_Color;
Begin
  If (length(Game.Lines) < Game_Maximum_Lines_Number) Then
    Begin
      // Création de la ligne.
      SetLength(Game.Lines, length(Game.Lines) + 1);
      // Récupération de l'index de la ligne crée (dernier élément du tableau).
      i := high(Game.Lines);
      // Détermination de la couleur.
      For j := low(Game.Lines) To high(Game.Lines) Do
        Begin
          If (Game.Lines[j].Color = Game.Ressources.Palette[Color_Red]) Then
            Exclude(Colors, Color_Red)
          Else If (Game.Lines[j].Color = Game.Ressources.Palette[Color_Purple]) Then
                 Exclude(Colors, Color_Purple)
          Else If (Game.Lines[j].Color = Game.Ressources.Palette[Color_Indigo]) Then
                 Exclude(Colors, Color_Indigo)
          Else If (Game.Lines[j].Color = Game.Ressources.Palette[Color_Teal]) Then
                 Exclude(Colors, Color_Teal)
          Else If (Game.Lines[j].Color = Game.Ressources.Palette[Color_Green]) Then
                 Exclude(Colors, Color_Green)
          Else If (Game.Lines[j].Color = Game.Ressources.Palette[Color_Yellow]) Then
                 Exclude(Colors, Color_Yellow)
          Else If (Game.Lines[j].Color = Game.Ressources.Palette[Color_Orange]) Then
                 Exclude(Colors, Color_Orange)
          Else If (Game.Lines[j].Color = Game.Ressources.Palette[Color_Brown]) Then
                 Exclude(Colors, Color_Brown);
        End;

      For Color In Colors Do
        Begin
          Game.Lines[i].Color := Color;
          Break;
        End;

      // Création du boutton
      Dual_State_Button_Set(Game.Lines[i].Button, Graphics_Surface_Create(32, 32), Graphics_Surface_Create(32, 32), Graphics_Surface_Create(32, 32), Graphics_Surface_Create(32, 32));

      FilledCircleRGBA(Game.Lines[i].Button.Surface_Released[0], 16, 16, 12, Color_Get(Color).Red, Color_Get[Color].Green, Color_Get(Color).Blue, 255);

      FilledCircleRGBA(Game.Lines[i].Button.Surface_Released[1], 16, 16, 16, Color_Get(Color).Red, Color_Get[Color].Green, Color_Get(Color).Blue, 255);

      // Recalcul des positions des boutons.
      Game.Lines[i].Button.Position.Y := Get_Centered_Position(Game.Panel_Bottom.Size.Y, Game.Lines[i].Button.Position.Y);

      Game.Lines[low(Game.Lines)].Button.Position.X := Get_Centered_Position(Game.Panel_Bottom.Size.X, (Game.Lines[i].Button.Size.X * length(Game.Lines)) + (16 * (length(Game.Lines) - 1)));

      If (length(Game.Lines) > 1) Then
        Begin
          For j := low(Game.Lines) + 1 To high(Game.Lines) Do
            Begin
              Game.Lines[j].Button.Position.Y := Game.Lines[j].Button.Position.Y;
              Game.Lines[j].Button.Position.X := Game.Lines[j - 1].Button.Position.X + Game.Lines[j - 1].Button.Size.X + 16;
            End;
        End;

      Line_Create := True;
    End
  Else
    Line_Create := False;
End;

// Fonction qui ajoute une station à une ligne.
Function Line_Add_Station(Station_Pointer : Type_Station_Pointer; Var Line : Type_Line) : Boolean;
Begin
  If (length(Line.Stations) < Lines_Maximum_Number_Stations) Then
    Begin
      // Agrandissement du tableau dynamique des stations de la ligne.
      SetLength(Line.Stations, length(Line.Stations) + 1);
      // Ajout du pointeur de la station.
      Line.Stations[high(Line.Stations)] := Station_Pointer;
      // Recalcul des positions intermédiaires de la ligne.
      Line_Compute_Intermediate_Positions(Line);
      Line_Add_Station := True;
    End
  Else
    Line_Add_Station := False;
End;

// Fonction qui insert une station dans une ligne.
Function Line_Add_Station(Last_Station_Pointer, Station_Pointer : Type_Station_Pointer; Var Line : Type_Line) : Boolean;

Var i : Byte;
  Temporary_Array : Array Of Stations;
  Duplicate : Boolean;
Begin
  Line_Add_Station := false;
  If (length(Line.Stations) < Lines_Maximum_Number_Stations) Then
    Begin
      If (length(Line.Stations) > 0) Then
        Begin
          Duplicate := false;
          // Vérifie si la station n'as pas déjà été ajoutée.
          For i := low(Line.Stations) To high(Line.Stations) Do
            If (Line.Statios[i] = Last_Station_Pointer) Then
              Duplicate := true;

          If (Duplicate = false) Then
            Begin
              For i := low(Line.Stations) To high(Line.Stations) Do
                Begin
                  If (Line.Stations = Last_Station_Pointer) Then
                    Begin
                      SetLength(Temporary_Array, 1);
                      Temporary_Array[high(Temporary_Array)] := Station_Pointer;
                      Insert(Temporary_Array, Line.Stations, i);
                      Line_Compute_Intermediate_Positions(Line);
                      Line_Add_Station := true;
                      Break;
                    End;
                End;
            End;
        End;
    End;
End;

// Fonction qui enlève une station d'une ligne.
Function Line_Remove_Station(Station_Pointer : Type_Station_Pointer; Var Line : Type_Line) : Boolean;

Var i : Byte;
Begin
  Line_Remove_Station := False;
  If (length(Line.Stations) > 0) Then
    Begin
      For i := low(Line.Stations) To high(Line.Stations) Do
        If (Line.Stations[i] = Station_Pointer) Then
          Begin
            // Enlève la station.
            Delete(Line.Stations, i, 1);
            // Si il n'y a plus qu'une station dans la ligne, alors, on supprime la seule station restante.
            If (length(Line.Stations) = 1) Then
              SetLength(Line.Stations, 0);
            Line_Compute_Intermediate_Positions(Line);
            Line_Remove_Station := True;
            Break;
          End;
    End;
End;

// Fonction qui créer un passager dans une station.
Procedure Passenger_Create(Var Station : Type_Station; Var Game : Type_Game);

Var Shape : Byte;
Begin
  SetLength(Station.Passengers, length(Station.Passengers) + 1);
  // Allocation de la mémoire.
  Station.Passengers[high(Station.Passengers)] := GetMem(SizeOf(Type_Passenger));

  Shape := Random(Shapes_Number - 1);
  // Définition de la forme du passager.
  Station.Passengers[high(Station.Passengers)]^.Shape := Number_To_Shape(Shape);
  // Définition du sprite du passager.
  Station.Passengers[high(Station.Passengers)]^.Sprite := Game.Ressources.Passengers[Shape];
  // Définition de la taille du passager.
  Station.Passengers[high(Station.Passengers)]^.Size.X := Station.Passengers[high(Station.Passengers)]^.Sprite^.w;
  Station.Passengers[high(Station.Passengers)]^.Size.Y := Station.Passengers[high(Station.Passengers)]^.Sprite^.h;
End;

Function Train_Create(Start_Station : Type_Station_Pointer; Direction : Boolean; Var Line : Type_Line; Var Game : Type_Game) : Boolean;

Var i : Byte;
Begin
  If (length(Line.Trains) < Lines_Maximum_Number_Trains) Then
    Begin
      // Création d'un nouveau train dans le tableau.
      SetLength(Line.Trains, length(Line.Trains) + 1);

      Line.Trains[high(Line.Trains)].Distance := 0;
      Line.Trains[high(Line.Trains)].Direction := Direction;
      Line.Trains[high(Line.Trains)].Last_Station := Start_Station;

      If (length(Line.Stations) > 0) Then
        Begin
          // Itère parmis les stations de la ligne.
          For i := low(Line.Stations) To high(Line.Stations) Do
            Begin
              If (Line.Stations[i] = Start_Station) Then
                Begin
                  If (Line.Trains[high(Line.Trains)].Direction = true) Then
                    Begin
                      Line.Trains[high(Line.Trains)].Next_Station := Line.Stations[i + 1];
                      // Calcul du point intermédiaire.
                      Line.Trains[high(Line.Trains)].Intermediate_Position := Station_Get_Intermediate_Position(Line.Trains[high(Line.Trains)].Last_Station^.Position_Centered, Line.Trains[high(Line.
                                                                              Trains)].Next_Station^.Position_Centered);
                    End
                  Else
                    Begin
                      Line.Trains[high(Line.Trains)].Next_Station := Line.Stations[i - 1];

                      // Calcul du point intermédiaire.
                      Line.Trains[high(Line.Trains)].Intermediate_Position := Station_Get_Intermediate_Position(Line.Trains[high(Line.Trains)].Next_Station^.Position_Centered, Line.Trains[high(Line.
                                                                              Trains)].Last_Station^.Position_Centered);
                    End;
                  Break;
                End;
            End;
        End;

      // Calcul de la distance du point intermédiaire.
      Line.Trains[high(Line.Trains)].Intermediate_Position_Distance := Get_Distance(Line.Trains[high(Line.Trains)].Last_Station^.Position_Centered, Line.Trains[high(Line.Trains)].
                                                                       Intermediate_Position);

      // Calcul de la distance maximale du train.

      Line.Trains[high(Line.Trains)].Maximum_Distance := Get_Distance(Line.Trains[high(Line.Trains)].Last_Station^.Position_Centered, Line.Trains[high(Line.Trains)].Intermediate_Position);
      Line.Trains[high(Line.Trains)].Maximum_Distance := Line.Trains[high(Line.Trains)].Maximum_Distance
                                                         +  Get_Distance(Line.Trains[high(Line.Trains)].Intermediate_Position, Line.Trains[high
                                                         (Line.Trains)].Next_Station^.Position_Centered);


      Line.Trains[high(Line.Trains)].Driving := True;

      Vehicle_Create(Line.Trains[high(Line.Trains)]);

      Train_Create := True;
    End
  Else
    Train_Create := False;
End;

Function Vehicle_Create(Var Train : Type_Train) : Boolean;

Var i : Byte;
Begin
  If (length(Train.Vehicles) < Train_Maximum_Vehicles_Number) Then
    Begin
      SetLength(Train.Vehicles, length(Train.Vehicles) + 1);
      Vehicle_Create := True;
      For i := 0 To Vehicle_Maximum_Passengers_Number - 1 Do
        Train.Vehicles[high(Train.Vehicles)].Passengers[i] := Nil;
    End
  Else
    Vehicle_Create := False;
End;

// - - Object deletion.

Function Line_Delete(Var Line : Type_Line; Var Game : Type_Game) : Boolean;

Var i : Byte;
Begin
  If (length(Line.Trains) > 0) Then
    Begin
      For i := low(Game.Lines) To high(Game.Lines) Do
        Begin
          If (@Game.Lines[i] = @Line) Then
            Begin
              Game.Lines[i] := Game.Lines[high(Game.Lines)];
              SetLength(Game.Lines, length(Game.Lines) - 1);
              Line_Delete := True;
              Break;
            End;
        End;
    End
  Else
    Line_Delete := False;
End;

Function Passenger_Delete(Var Passenger : Type_Passenger_Pointer) : Boolean;
Begin
  If (Passenger <> Nil) Then
    Begin
      FreeMem(Passenger);
      Passenger := Nil;
      Passenger_Delete := True;
    End
  Else
    Passenger_Delete := False;
End;

// - - Time

Function Time_Get_Current(): Type_Time;
Begin
  Time_Get_Current := SDL_GetTicks();
End;

Function Time_Get_Elapsed(Start_Time : Type_Time) : Type_Time;
Begin
  Time_Get_Elapsed := SDL_GetTicks() - Start_Time;
End;

// - - Shape

Function Number_To_Shape(Number : Byte) : Type_Shape;
Begin
  Case Number Of 
    0 : Number_To_Shape := Circle;
    4 : Number_To_Shape := Lozenge;
    3 : Number_To_Shape := Pentagon;
    1 : Number_To_Shape := Square;
    2 : Number_To_Shape := Triangle;
  End;
End;

End.
