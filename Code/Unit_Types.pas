
Unit Unit_Types;

Interface

// - Inclusion des libraries.

Uses sdl, sdl_image, sdl_ttf, sysutils;

// - Définition des constantes.

Const Profondeur_Couleur = 32;

Const Maximum_Number_Stations = 200;

Const Maximum_Number_Stations_Per_Line = 20;

  // - Type definition

  // - - Timer

Type Type_Time = Longword;

  // - - SDL related objects

Type Type_Surface = PSDL_Surface;

Type Type_Rectangle = TSDL_Rect;

Type Type_Font = pTTF_Font;

Type Type_Sprite_Table = Record
  Station_Square, Station_Circle, Station_Triangle, Station_Lozenge,
  Station_Pentagon : Type_Surface;
  Passenger_Circle, Passenger_Square, Passenger_Triangle, Passenger_Lozenge,
  Passenger_Pentagon : Type_Surface
End;


// - Entity
// - - Généraux

Type Type_Coordinates = Record
  X, Y : LongInt;
End;

Type Type_Shape = (Circle, Lozenge, Pentagon, Square, Triangle);

  // - - Passengers

Type Type_Passenger = Record
  Shape : Type_Shape;
  Sprite : Type_Surface;
End;

Type Type_Passenger_Pointer = ^Type_Passenger;

  // - - Station

Type Type_Station = Record
  Shape : Type_Shape;
  Coordinates : Type_Coordinates;
  Sprite : Type_Surface;
  Passengers : array[0..5] Of Type_Passenger_Pointer;
  Passengers_Count : Byte;
End;

Type Type_Station_Pointer = ^Type_Station;

  // - - Train

Type Type_Train = Record
  Coordinates : Type_Coordinates;
  Speed : Type_Coordinates;
  Acceleration : Type_Coordinates;
  Locomotive_Sprite : Type_Surface;
  Wagons_Sprite : array[0..3] Of Type_Surface;
End;

Type Type_Train_Pointer = ^Type_Train;

// - - Line

Type Type_Line = Record
  Stations : array[0..Maximum_Number_Stations_Per_Line] Of Type_Station_Pointer;
  Trains : array[0..4] of Type_Train_Pointer;
  Stations_Count : Byte;
End;

// - Game

Type Type_Game = Record
  Window : Type_Surface;
  Window_Size : Type_Coordinates;
  Sprites : Type_Sprite_Table;
  Fonts : array[0..1] Of Type_Font;
  Stations : array[0..(Maximum_Number_Stations - 1)] Of Type_Station_Pointer;
  Stations_Count : Integer;
End;


// - Function declaration

// - - Station allocation

Function Passenger_Allocate() : Type_Passenger_Pointer;
Procedure Passenger_Deallocate(Passenger_Pointer : Type_Passenger_Pointer);

Function Station_Allocate() : Type_Station_Pointer;



// - - Time
Function Time_Get_Current(): Type_Time;
Function Time_Get_Elapsed(Start_Time : Type_Time) : Type_Time;

Implementation

// - Function definition

// - - Station

Function Passenger_Allocate() : Type_Passenger_Pointer;
Begin
  Passenger_Allocate := GetMem(SizeOf(Type_Passenger));
End;

Procedure Passenger_Deallocate(Passenger_Pointer : Type_Passenger_Pointer);
Begin
  FreeMem(Passenger_Pointer);
End;

Function Station_Allocate() : Type_Station_Pointer;
Begin
  Station_Allocate := GetMem(sizeof(Type_Station));
End;

Procedure Station_Deallocate(Station_Pointer : Type_Station_Pointer);
Begin
  FreeMem(Station_Pointer);
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

End.
