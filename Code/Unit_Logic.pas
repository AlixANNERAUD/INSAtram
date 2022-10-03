
Unit Unit_Logic;

Interface

// - Include internal units.

Uses Unit_Types, Unit_Graphics;

// - Function decleration

Function Station_Create() : Type_Station_Pointer;

Implementation

// - Function definition

Function Station_Create() : Type_Station_Pointer;

Var Station_Pointer : Type_Station_Pointer;
Begin

  Station_Allocate(Station_Pointer);

  Station_Pointer^.Shape := Circle;

  Station_Pointer^.Coordinates.X := 200;
  Station_Pointer^.Coordinates.Y := 200;

  Station_Create := Station_Pointer;
End;


End.
