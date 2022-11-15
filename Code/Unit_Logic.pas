
Unit Unit_Logic;

Interface

// - Inclut les unités internes au projet. 

Uses Unit_Types, Unit_Graphics;

// - Déclaration des fonctions et procédures.

// - - Logqiue générale.
Procedure Logic_Load(Var Game : Type_Game);

// - - Lignes
Procedure Line_Create(Var Game : Type_Game);
Procedure Line_Add_Station(Var Line : Type_Line; Station : Type_Station_Pointer);
Procedure Line_Remove_Staton(Var Line : Type_Line; Station : Type_Station_Pointer);

// - - Passagers
Procedure Passenger_Create(Var Game : Type_Game);
Procedure Passenger_Delete(Var Passenger_Pointer : Type_Passenger_Pointer);

// - - Stations
Procedure Station_Create(Var Game : Type_Game);
Function Station_Get_Center_Position(Station : Type_Station) : Type_Coordinates;

// - - Trains
Procedure Train_Create(Var Line : Type_Line);
Procedure Train_Delete(Var Train_Pointer : Type_Train_Pointer; Var Line : Type_Line);
Procedure Train_Add_Vehicle(Var Train : Type_Train);
Procedure Train_Delete_Vehicle(Var Train : Type_Train);

Implementation

// - Définition des fonctions et des procédures.

// - - Fonctions et procédures relatives à la logique générale.

// Initialise la partie 
Procedure Logic_Load(Var Game : Type_Game);
Begin
  Randomize();
  Game.Stations_Count := 0;
  Game.Lines_Count := 0;
End;

// - - Fonctions et procédures relatives aux lignes.

// Procédure qui permet de créer une ligne.
Procedure Line_Create(Var Game : Type_Game);
Begin
  // Vérifie si la ligne créer ne dépasse pas du tableau (ne correspondant pas à la limite "temporaire" pour un joueur).
  If (Game.Lines_Count < Maximum_Number_Lines) Then
    Begin
      // Initialisation des attributs de la ligne.
      Game.Lines[Game.Lines_Count].Stations_Count := 0;
      Game.Lines[Game.Lines_Count].Trains_Count := 0;

      inc(Game.Lines_Count);
    End;
End;

// Procédure qui ajoute le pointeur d'une station à une ligne.
Procedure Line_Add_Station(Var Line : Type_Line; Station : Type_Station_Pointer);
Begin
  // 
  If (Line.Stations_Count < Maximum_Number_Stations_Per_Line) Then
    Begin;
      Line.Stations[Line.Stations_Count] := Station;
      inc(Line.Stations_Count);
    End;
End;

// Procédure qui supprime le pointeur d'une station au tableau des stations d'une ligne.
Procedure Line_Remove_Staton(Var Line : Type_Line; Station : Type_Station_Pointer);

Var i : Byte;
Begin
  For i := 0 To Line.Stations_Count - 1 Do
    Begin
      If (Line.Stations[i] = Station) Then
        Begin
          Line.Stations[i] := Line.Stations[Line.Stations_Count - 1];
          Line.Stations[Line.Stations_Count - 1] := Nil;
          dec(Line.Stations_Count);
          break;
        End;
    End;
End;

// -  - Fonctions et procédures relatives au passagers

// Fonction qui créer un passager.
Procedure Passenger_Create(Var Game : Type_Game);

Var Temporary, Shape : Byte;
  Passenger_Pointer : Type_Passenger_Pointer;
Begin
  // - Choose a random station
  Repeat
    Temporary := Random(Game.Stations_Count);
  Until (Game.Stations[Temporary]^.Passengers_Count < 6);


  // - Allocate memory to passenger.
  Passenger_Pointer := Passenger_Allocate();
  Game.Stations[Temporary]^.Passengers[Game.Stations[Temporary]^.Passengers_Count] := Passenger_Pointer;

  Shape := Random(5);

  Case Shape Of 
    0 :
        Begin
          Passenger_Pointer^.Shape := Circle;
          // Set station shape.
          Passenger_Pointer^.Sprite := Game.Sprites.Passenger_Circle;
          // Assign sprite to station.
        End;
    1 :
        Begin
          Passenger_Pointer^.Shape  := Lozenge;
          Passenger_Pointer^.Sprite := Game.Sprites.Passenger_Lozenge;
        End;
    2 :
        Begin
          Passenger_Pointer^.Shape  := Pentagon;
          Passenger_Pointer^.Sprite := Game.Sprites.Passenger_Pentagon;
        End;
    3 :
        Begin
          Passenger_Pointer^.Shape  := Square;
          Passenger_Pointer^.Sprite := Game.Sprites.Passenger_Square;
        End;
    4 :
        Begin
          Passenger_Pointer^.Shape  := Triangle;
          Passenger_Pointer^.Sprite := Game.Sprites.Passenger_Triangle;
        End;
  End;


  inc(Game.Stations[Temporary]^.Passengers_Count);
End;

// Fonction qui supprime un passager et libère sa mémoire allouée.
Procedure Passenger_Delete(Var Passenger_Pointer : Type_Passenger_Pointer);
Begin
  Passenger_Deallocate(Passenger_Pointer);
  Passenger_Pointer := Nil;
End;

// - - Fonctions et procédures relatives aux stations.

// Fonction qui alloue de la mémoire pour une station, qui ajoute son pointeur dans un tableau de pointeurs et détermine sa forme et position aléatoirement. 
Procedure Station_Create(Var Game : Type_Game);

Var Shape : Byte;
Begin
  If (Game.Stations_Count < Maximum_Number_Stations) Then
    Begin
      // Allocation de la mémoire pour la station.
      Game.Stations[Game.Stations_Count] := Station_Allocate();

      // Définition des attributs de la station

      Game.Stations[Game.Stations_Count]^.Size.X := Station_Width;
      Game.Stations[Game.Stations_Count]^.Size.Y := Station_Height;

      // Détermination de la forme de la station.
      // Les 5 premières stations sont de formes différentes.
      If (Game.Stations_Count > 4) Then
        Begin
          Shape := Random(5)
        End
      Else
        Begin
          Shape := Game.Stations_Count
        End;

      Case Shape Of 
        0 :
            Begin
              Game.Stations[Game.Stations_Count]^.Shape := Circle;
              // Détermine la forme de la station.
              Game.Stations[Game.Stations_Count]^.Sprite := Game.Sprites.
                                                            Station_Circle;
              // Assigne son 'sprite' à la station.
            End;
        1 :
            Begin
              Game.Stations[Game.Stations_Count]^.Shape := Lozenge;
              Game.Stations[Game.Stations_Count]^.Sprite := Game.Sprites.
                                                            Station_Lozenge;
            End;
        2 :
            Begin
              Game.Stations[Game.Stations_Count]^.Shape := Pentagon;
              Game.Stations[Game.Stations_Count]^.Sprite := Game.Sprites.
                                                            Station_Pentagon;
            End;
        3 :
            Begin
              Game.Stations[Game.Stations_Count]^.Shape := Square;
              Game.Stations[Game.Stations_Count]^.Sprite := Game.Sprites.
                                                            Station_Square;
            End;
        4 :
            Begin
              Game.Stations[Game.Stations_Count]^.Shape := Triangle;
              Game.Stations[Game.Stations_Count]^.Sprite := Game.Sprites.
                                                            Station_Triangle;
            End;
      End;

      Game.Stations[Game.Stations_Count]^.Position.X := Random(Game.
                                                        Window_Size.X -
                                                        Station_Width);
      Game.Stations[Game.Stations_Count]^.Position.Y := Random(Game.
                                                        Window_Size.Y -
                                                        Station_Height);

      Game.Stations[Game.Stations_Count]^.Passengers_Count := 0;

      inc(Game.Stations_Count);
    End;
End;

// Fonction qui permet d'obtenir le centre d'une station.
Function Station_Get_Center_Position(Station : Type_Station) : Type_Coordinates;
Begin
  Station_Get_Center_Position.X := Station.Position.X + Station_Width Div 2;
  Station_Get_Center_Position.Y := Station.Position.Y + Station_Height Div 2;
End;

// - - Fonctions et procédures relatives aux lignes.

Procedure Train_Create(Var Line : Type_Line);
Begin
  If (Line.Trains_Count < Maximum_Number_Trains_Per_Lines) Then
    Begin
      Line.Trains[Line.Trains_Count] := Train_Allocate();
      inc(Line.Trains_Count);
    End;
End;

Procedure Train_Delete(Var Train_Pointer : Type_Train_Pointer; Var Line : Type_Line);

Var i : Byte;
Begin
  If (Line.Trains_Count > 0) Then
    Begin

      For i := 0 To Line.Trains_Count - 1 Do
        Begin
          If (Line.Trains[i] = Train_Pointer) Then
            Line.Trains[i] := Line.Trains[Line.Trains_Count - 1];
        End;
      dec(Line.Trains_Count);
      Train_Deallocate(Train_Pointer);
    End;
End;

Procedure Train_Add_Vehicle(Var Train : Type_Train);
Begin
  if (Train.Vehicles_Count < Maximum_Number_Vehicles_Per_Train) Then
    inc(Train.Vehicles_Count);
End;

Procedure Train_Delete_Vehicle(Var Train : Type_Train);
Begin
  if (Train.Vehicles_Count > 0) Then
    dec(Train.Vehicles_Count);
End;

End.
