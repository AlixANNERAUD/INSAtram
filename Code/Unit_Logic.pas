Unit Unit_Logic;

Interface

// - Include internal units.

Uses Unit_Types, Unit_Graphics;

// - Function decleration

Function Creer_Station() : Type_Station_Pointer;

Implementation

// - Function definition

Function Creer_Station() : Type_Station_Pointer;
var Station_Pointer : Type_Station_Pointer;
begin

    Station_Pointer := Station_Allocate();

    Station_Pointer^.Shape := Square;

    Station_Pointer^.Coordinates.X := 400;
    Station_Pointer^.Coordinates.Y := 600;   
end;


End.