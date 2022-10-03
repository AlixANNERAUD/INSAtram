
Unit Unit_Types;

Interface

// - Inclusion des libraries.

Uses sdl, sdl_image, sdl_ttf, sysutils;

// - Définition des constantes.

Const Profondeur_Couleur = 32;

// - Type definition

// - - Timer

Type Type_Time = Longword;

// - - SDL related objects

Type Type_Surface = PSDL_Surface;
Type Type_Rectangle = TSDL_Rect;

Type Type_Sprite_Table = record
  Station_Square, Station_Circle, Station_Triangle, Station_Lozenge, Station_Pentagon : Type_Surface;
end;


// - Entity
// - - Généraux

Type Type_Coordinates = Record
  X, Y : Integer;
End;

Type Type_Shape = (Square, Circle, Triangle, Lozenge, Pentagon);

// - - Station

Type Type_Station = record
  Shape : Type_Shape;
  Coordinates : Type_Coordinates;
  Sprite : Type_Surface;
end;

Type Type_Station_Pointer = ^Type_Station;

// - Game

Type Type_Game = record
  Window : Type_Surface;
  Sprite_Table : Type_Sprite_Table;
end;


// - Function declaration

// - - Station allocation

Function Station_Allocate() : Type_Station_Pointer;

// - - Time
Function Time_Get_Current(): Type_Time;
Function Time_Get_Elapsed(Start_Time : Type_Time) : Type_Time;

Implementation

// - Function definition

// - - Station

Function Station_Allocate() : Type_Station_Pointer;
Begin
  Station_Allocate := GetMem(sizeof(Type_Station));
End;

Procedure Station_Deallocate(var Station_Pointer : Type_Station_Pointer);
Begin
  if (not(Station_Pointer = nil)) then
  Begin
    SDL_FreeSurface(Station_Pointer^.Sprite);
    FreeMem(Station_Pointer);
    Station_Pointer := nil;
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

End.
