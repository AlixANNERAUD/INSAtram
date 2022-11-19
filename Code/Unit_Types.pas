
Unit Unit_Types;

// Cette unité contient :
// - les constantes parametrant le jeu.
// - les types de données principaux (alias, structures).
// - les fonctions et procédures pour l'allocation et désallocation de ses types.

Interface

// - Libraries inclusion.

Uses sdl, sdl_image, sdl_ttf, sysutils;

// - Constants declaration.

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

Const Path_Image_Vehicle =   'Ressources/Images/Vehicle.png';

  // - - - Fonts

Const Path_Font =   'Ressources/Fonts/FreeSans.ttf';

Const Path_Font_Bold =   'Ressources/Fonts/FreeSansBold.ttf';

  // - - Object constants

  // - - - Font

  Const Font_Size_Normal =  12;

  // - - - Game

Const Game_Maximum_Lines_Number = 8;

Const Maximum_Number_Stations = 200;

  // - - - Shapes

Const Shapes_Number = 5;

  // - - - Station


Const Station_Width =   32;

Const Station_Height =   32;

  // - - - Véhicules (locomotive et wagon).

Const Vehicle_Width =   32;

Const Vehicle_Height =   24;

  // - - - Passagers

Const Passenger_Width =   8;

Const Passenger_Height =   8;

  // - - - Trains

Const Train_Maximum_Vehicles_Number = 3;

  // - - - Lignes

Const Lines_Maximum_Number_Stations = 20;

Const Lines_Maximum_Number_Trains = 4;

  // - Type definition

  // - - General

Type Long_Integer_Pointer = ^LongInt;

  // - - Timer

Type Type_Time = Longword;

  // - - SDL related objects

Type Type_Surface = PSDL_Surface;

Type Type_Rectangle = TSDL_Rect;

Type Type_Font = pTTF_Font;

  // - - Graphics

Type Type_Color = Record
  Red, Green, Blue, Alpha : Byte;
End;

// Structure contenant tous pointeurs des sprites du jeu.

Type Type_Sprite_Table = Record
  // Font
  Font : Type_Font;
  // Stations (5 formes différentes).
  Stations : Array [0 .. (Shapes_Number - 1)] Of Type_Surface;
  // Passagers (5 formes différentes).
  Passengers : Array [0 .. (Shapes_Number - 1)] Of Type_Surface;
  // Vehicles (locomotive et wagon).
  Vehicle_0_Degree, Vehicle_45_Degree, Vehicle_90_Degree, Vehicle_135_Degree : Type_Surface;
End;

// - - Animation

// Animation structure used by animation function in order to animate objects.

Type Type_Animation = Record

  Delay_Time : Type_Time;
  Variable : Long_Integer_Pointer;
  Minimum_Value, Maximum_Value : LongInt;
  //Path : Type_Animation_Path;
  Enabled : Boolean;

End;

//Type Type_Animation_Path = function(var Animation : Type_Animation) : LongInt;

// - Entity
// - - Généraux

Type Type_Coordinates = Record
  X, Y : LongInt;
End;

Type Type_Shape = (Circle, Lozenge, Pentagon, Square, Triangle);


  // - - Passengers

Type Type_Passenger = Record
  // Forme du passager (et donc sa station de destination).
  Shape : Type_Shape;
  // Pointeur vers le sprite du passager.
  Sprite : Type_Surface;
  // Itinéraire du passager.
  //Itinerary : Array of Type_Station_Pointer;
End;

Type Type_Passenger_Pointer = ^Type_Passenger;

  // - - Station

Type Type_Station = Record
  Position, Size, Position_Centered : Type_Coordinates;
  Shape : Type_Shape;
  Sprite : Type_Surface;
  Passengers : array Of Type_Passenger_Pointer;
End;

Type Type_Station_Pointer = ^Type_Station;

  // - - Train

Type Type_Vehicule_State = (Stopped, Driving);

Type Type_Vehicle = Record
  Position, Size : Type_Coordinates;
  Sprite : Type_Surface;
  Driving : Boolean;
End;

Type Type_Train = Record

  // - Pointeur de la dernière station.
  Last_Station : Type_Station_Pointer;
  // - Pointeur de la prochaine station.
  Next_Station : Type_Station_Pointer;
  // - Distance parcourue depuis la dernière station en pixel.
  Distance : Integer;
  // Direction directe ou indirecte du train (indexe des stations de la ligne croissant ou décroissant).
  Direction : Boolean;

  // - Vitesse du train.
  Speed : Integer;
  // - Accélération du train.
  Acceleration : Integer;

  //  Nombre de wagons.
  Vehicles : array Of Type_Vehicle;
  //  Pointeur vers les wagons du train.
End;
// - - Line

Type Type_Line = Record
  // Couleur de la ligne.
  Color : Type_Color;
  // Tableau dynamique de pointeur vers les stations.
  Stations : array Of Type_Station_Pointer;
  // Tableau dynamique contenant les trains.
  Trains : array Of Type_Train;
End;

Type Type_Player = Record
  Score : Integer;
  Locomotive_Token : Byte;
  Wagon_Token : Byte;
  Tunnel_Token : Byte;
End;

// - Interface graphique

Type Type_Image = Record
  Position, Size : Type_Coordinates;
  Surface : Type_Surface;
End;

Type Type_Button = Record
  Position, Size : Type_Coordinates;
  Surface : Type_Surface;
End;

Type Type_Text = Record
  Position, Size : Type_Coordinates;
  Text : String;
  Color : Type_Color;
End;

Type Type_Text_Ponter = ^Type_Text;

Type Type_Interface = Record
  Lines_Buttons : Array[0 .. (Game_Maximum_Lines_Number - 1)] Of Type_Button;
  
  Score : Type_Text;

End;

// - Game

Type Type_Game = Record
  // Fenêtre du jeu.

  

  Window : Type_Surface;
  Window_Size : Type_Coordinates;
  // Structure contenant les sprites du jeu.
  Sprites : Type_Sprite_Table;
  Fonts : array[0..1] Of Type_Font;
  // Inventaire
  Player : Type_Player;
  // Stations
  // Tableau dymamique contenant les stations.
  Stations : array Of Type_Station;
  // Lignes
  // Tableau dynamque contenant les lignes.
  Lines : array Of Type_Line;
End;

Type Type_Game_Pointer = ^Type_Game;


// - Function declaration

Function Get_Centered_Position(Position, Size : Type_Coordinates) : Type_Coordinates;

// - - Object creation.

Function Text_Create(Position, Size : Type_Coordinates; Texte : String; Color : Type_Color) : Type_Text_Pointer;

Function Station_Create(Var Game: Type_Game) : Boolean;
Function Line_Create(Color : Type_Color; Var Game : Type_Game) : Boolean;
Procedure Passenger_Create(Var Station : Type_Station; Var Game : Type_Game);
Function Train_Create(Start_Station : Type_Station_Pointer; Direction : Boolean; Var Line : Type_Line; Var Game : Type_Game) : Boolean;
Function Vehicle_Create(Var Train : Type_Train; Var Game : Type_Game) : Boolean;



// - - Object deletion.

Procedure Text_Delete(Var Text : Type_Text_Pointer);
Function Line_Delete(Var Line : Type_Line; Var Game : Type_Game) : Boolean;
Function Line_Add_Station(Station_Pointer : Type_Station_Pointer; Var Line : Type_Line) : Boolean;
Function Line_Remove_Station(Station_Pointer : Type_Station_Pointer; Var Line : Type_Line) : Boolean;

Function Passenger_Delete(Var Passenger : Type_Passenger; Var Station : Type_Station) : Boolean;
//Function Train_Delete(Var Train : Type_Train; Var Line : Type_Train) : Boolean;
//Function Vehicle_Delete(Var Vehicle : Type_Vehicle; Var Train : Type_Train) : Boolean;

// - - Time

Function Time_Get_Current(): Type_Time;
Function Time_Get_Elapsed(Start_Time : Type_Time) : Type_Time;

// - - Shape

Function Number_To_Shape(Number : Byte) : Type_Shape;

Implementation

// - Définition des fonctions et procédures

// - Création

Function Get_Centered_Position(Position, Size : Type_Coordinates) : Type_Coordinates;
Begin
  Position.X := Position.X + (Size.X Div 2);
  Position.Y := Position.Y + (Size.Y Div 2);
  Get_Centered_Position := Position;
End;

Function Text_Create(Position, Size : Type_Coordinates; Text : String; Color : Type_Color) : Type_Text_Pointer;
Var Text : Type_Text_Pointer;
Begin
  Text := GetMem(SizeOf(Type_Text));
  Text^.Position := Position;
  Text^.Size := Size;
  Text^.Text := Text;
  Text^.Color := Color;
End;

// Procédure qui alloue de la mémoire pour une station et le référence dans le tableau dynamique, détermine sa forme et position aléatoirement et defini ses attributs.
Function Station_Create(Var Game : Type_Game) : Boolean;

Var Shape : Byte;
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
      Game.Stations[high(Game.Stations)].Sprite := Game.Sprites.Stations[Shape];


      Game.Stations[high(Game.Stations)].Size.X := Station_Width;
      Game.Stations[high(Game.Stations)].Size.Y := Station_Height;

      Game.Stations[high(Game.Stations)].Position.X := Random(Game.
                                                       Window_Size.X -
                                                       Station_Width);
      Game.Stations[high(Game.Stations)].Position.Y := Random(Game.
                                                       Window_Size.Y -
                                                       Station_Height);

      // Calcul les coordoonées centré de la station.
      Game.Stations[high(Game.Stations)].Position_Centered := Get_Centered_Position(Game.Stations[high(Game.Stations)].Position, Game.Stations[high(Game.Stations)].Size);

      Station_Create := True;
    End
  Else
    Station_Create := False;
End;

// Procédure qui créer une ligne.
Function Line_Create(Color : Type_Color; Var Game : Type_Game) : Boolean;
Begin
  If (length(Game.Lines) < Game_Maximum_Lines_Number) Then
    Begin
      // Création de la ligne.
      SetLength(Game.Lines, length(Game.Lines) + 1);
      // Détermination des valeurs par défaut.
      Game.Lines[high(Game.Lines)].Color := Color;

      Line_Create := True;
    End
  Else
    Line_Create := False;
End;

Function Line_Add_Station(Station_Pointer : Type_Station_Pointer; Var Line : Type_Line) : Boolean;
Begin
  If (length(Line.Stations) < Lines_Maximum_Number_Stations) Then
    Begin
      SetLength(Line.Stations, length(Line.Stations) + 1);
      Line.Stations[high(Line.Stations)] := Station_Pointer;
      Line_Add_Station := True;
    End
  Else
    Line_Add_Station := False;
End;

Function Line_Remove_Station(Station_Pointer : Type_Station_Pointer; Var Line : Type_Line) : Boolean;

Var i : Byte;
Begin
  If (length(Line.Stations) > 0) Then
    Begin
      For i := low(Line.Stations) To high(Line.Stations) Do
        If (Line.Stations[i] = Station_Pointer) Then
          Begin

            FreeMem(Line.Stations[i]);
            Line.Stations[i] := Line.Stations[high(Line.Stations)];

            SetLength(Line.Stations, length(Line.Stations) - 1);
            Break;
          End;
      Line_Remove_Station := True;
    End
  Else
    Line_Remove_Station := False;
End;

// Fonction qui créer un passager dans une station.
Procedure Passenger_Create(Var Station : Type_Station; Var Game : Type_Game);

Var Shape : Byte;
Begin
  SetLength(Station.Passengers, length(Station.Passengers) + 1);

  Shape := Random(Shapes_Number - 1);
  // Set shape.
  Station.Passengers[high(Station.Passengers)]^.Shape := Number_To_Shape(Shape);
  // Set sprite.
  Station.Passengers[high(Station.Passengers)]^.Sprite := Game.Sprites.Passengers[Shape];
End;

Function Train_Create(Start_Station : Type_Station_Pointer; Direction : Boolean; Var Line : Type_Line; Var Game : Type_Game) : Boolean;
Begin
  If (length(Line.Trains) < Lines_Maximum_Number_Trains) Then
    Begin
      SetLength(Line.Trains, length(Line.Trains) + 1);

      Line.Trains[high(Line.Trains)].Distance := 0;
      Line.Trains[high(Line.Trains)].Direction := Direction;
      Line.Trains[high(Line.Trains)].Last_Station := Start_Station;
      Vehicle_Create(Line.Trains[high(Line.Trains)], Game);
      Train_Create := True;
    End
  Else
    Train_Create := False;
End;

Function Vehicle_Create(Var Train : Type_Train; Var Game : Type_Game) : Boolean;
Begin
  If (length(Train.Vehicles) < Train_Maximum_Vehicles_Number) Then
    Begin
      SetLength(Train.Vehicles, length(Train.Vehicles) + 1);
      Train.Vehicles[high(Train.Vehicles)].Position.X := 0;
      Train.Vehicles[high(Train.Vehicles)].Position.Y := 0;
      Train.Vehicles[high(Train.Vehicles)].Size.X := Vehicle_Width;
      Train.Vehicles[high(Train.Vehicles)].Size.Y := Vehicle_Height;
      Train.Vehicles[high(Train.Vehicles)].Sprite := Game.Sprites.Vehicle_0_Degree;
      Train.Vehicles[high(Train.Vehicles)].Driving := False;
      Vehicle_Create := True;
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

Function Passenger_Delete(Var Passenger : Type_Passenger; Var Station : Type_Station) : Boolean;

Var i : Byte;
Begin
  If (length(Station.Passengers) > 0) Then
    Begin
      For i := low(Station.Passengers) To high(Station.Passengers) Do
        Begin
          If (@Station.Passengers[i] = @Passenger) Then
            Begin
              Station.Passengers[i] := Station.Passengers[high(Station.Passengers)];
              SetLength(Station.Passengers, length(Station.Passengers) - 1);
              Passenger_Delete := True;
              Break;
            End;
        End;
    End
  Else
    Begin
      Passenger_Delete := False;
    End;
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
