
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

Type Type_Sprite_Table = Record
  Station_Square, Station_Circle, Station_Triangle, Station_Lozenge, Station_Pentagon : Type_Surface
  ;
End;

Type Type_Color = Record
  Red, Green, Blue : Byte;
End;


// - Entity
// - - Généraux

Type Type_Coordinates = Record
  X, Y : Integer;
End;

Type Type_Shape = (Square, Circle, Triangle, Lozenge, Pentagon);

  // - - Station

Type Type_Station = Record
  Shape : Type_Shape;
  Coordinates : Type_Coordinates;
  Sprite : Type_Surface;
End;

Type Type_Station_Pointer = ^Type_Station;

  // - Game

Type Type_Game = Record
  Window : Type_Surface;
  Sprite_Table : Type_Sprite_Table;
End;


// - Function declaration

// - - Station allocation

Procedure Station_Allocate(Var Station : Type_Station_Pointer);

// - - Time
Function Time_Get_Current(): Type_Time;
Function Time_Get_Elapsed(Start_Time : Type_Time) : Type_Time;

Implementation

// - Function definition

// - - Station

Procedure Station_Allocate(Var Station : Type_Station_Pointer);
Begin
  writeln('Station allocation');
  Station := GetMem(sizeof(Type_Station));
End;

Procedure Station_Deallocate(Var Station_Pointer : Type_Station_Pointer);
Begin
  If (Not(Station_Pointer = Nil)) Then
    Begin
      SDL_FreeSurface(Station_Pointer^.Sprite);
      FreeMem(Station_Pointer);
      Station_Pointer := Nil;
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
