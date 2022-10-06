
Unit Unit_Logic;

Interface

// - Include internal units.

Uses Unit_Types, Unit_Graphics;

// - Function decleration

Procedure Logic_Load(Var Game : Type_Game);

Procedure Station_Create(Var Game : Type_Game);
Function Station_Get_Center_Position(Station : Type_Station) : Type_Coordinates;

Procedure Passenger_Create(Var Game : Type_Game);
Procedure Passenger_Delete(Var Passenger_Pointer : Type_Passenger_Pointer);

Implementation

// - Function definition

Procedure Logic_Load(Var Game : Type_Game);
Begin
  Randomize();
  Game.Stations_Count := 0;

End;

// - Passengers

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
  Game.Stations[Temporary]^.Passengers[Game.Stations[Temporary]^.
  Passengers_Count] := Passenger_Pointer;

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

Procedure Passenger_Delete(Var Passenger_Pointer : Type_Passenger_Pointer);
Begin
  Passenger_Deallocate(Passenger_Pointer);
  Passenger_Pointer := Nil;
End;



// - Function that allocate memory for station, add it's pointer into stations table and set it's shape and position randomly. 

Procedure Station_Create(Var Game : Type_Game);

Var Shape : Byte;
Begin
  If (Game.Stations_Count < Maximum_Number_Stations) Then
    Begin

      // Insert break point 

      Game.Stations[Game.Stations_Count] := Station_Allocate();

      // 5 first station are always of different shape.
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
              // Set station shape.
              Game.Stations[Game.Stations_Count]^.Sprite := Game.Sprites.
                                                            Station_Circle;
              // Assign sprite to station.
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

      Game.Stations[Game.Stations_Count]^.Coordinates.X := Random(Game.
                                                           Window_Size.X -
                                                           Station_Width);
      Game.Stations[Game.Stations_Count]^.Coordinates.Y := Random(Game.
                                                           Window_Size.Y -
                                                           Station_Height);

      Game.Stations[Game.Stations_Count]^.Passengers_Count := 0;

      inc(Game.Stations_Count);
    End;
End;

Function Station_Get_Center_Position(Station : Type_Station) : Type_Coordinates;
Begin
  Station_Get_Center_Position.X := Station.Coordinates.X + Station_Width Div 2;
  Station_Get_Center_Position.Y := Station.Coordinates.Y + Station_Height Div 2;
End;


End.
