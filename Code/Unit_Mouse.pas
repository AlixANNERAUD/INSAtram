Unit Unit_Mouse;

Interface

Uses Unit_Types, sdl;

Procedure Mouse_Load();

Function Mouse_Get_Position() : Type_Coordinates;


Implementation

Procedure Mouse_Load();
Begin
End;

Function Mouse_Get_Position() : Type_Coordinates;
Var Position : Type_Coordinates;
Begin
    SDL_GetMouseState(Position.X, Position.Y);
    Mouse_Get_Position := Position;
End;

End.