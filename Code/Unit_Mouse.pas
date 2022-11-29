
Unit Unit_Mouse;

Interface

Uses Unit_Types, sdl;

Procedure Mouse_Load(Game : Type_Game);

Function Mouse_Get_Position() : Type_Coordinates;

Function Mouse_Is_Pressed(Game : Type_Game) : Boolean;

Procedure Mouse_Event_Handler(Mouse_Event : TSDL_MouseButtonEvent; Var Game : Type_Game);

Implementation


Procedure Mouse_Event_Handler(Mouse_Event : TSDL_MouseButtonEvent; Var Game : Type_Game);
Begin
  If (Mouse_Event.Button = SDL_BUTTON_LEFT) Then
    Begin
      If (Mouse_Event.state = SDL_PRESSED) Then
        Begin
          Game.Mouse.State := True;
          Game.Mouse.Press_Position.X := Mouse_Event.x;
          Game.Mouse.Press_Position.Y := Mouse_Event.y;
        End
      Else
        Begin
          Game.Mouse.State := False;
          Game.Mouse.Release_Position.X := Mouse_Event.x;
          Game.Mouse.Release_Position.Y := Mouse_Event.y;
        End;
    End;
End;


Procedure Mouse_Load(Game : Type_Game);
Begin
  Game.Mouse.Press_Position.X := 0;
  Game.Mouse.Press_Position.Y := 0;
  Game.Mouse.Release_Position.X := 0;
  Game.Mouse.Release_Position.Y := 0;
  Game.Mouse.State := False;
End;

// Fonction qui retourne la position actuelle de la souris.
Function Mouse_Get_Position() : Type_Coordinates;

Var Position : Type_Coordinates;
Begin
  SDL_GetMouseState(Position.X, Position.Y);
  Mouse_Get_Position := Position;
End;

// Fonction qui retourne la position de la souris losqu'elle a été pressée (pour la dernière fois).
Function Mouse_Get_Press_Position(Game : Type_Game) : Type_Coordinates;
Begin
  Mouse_Get_Press_Position := Game.Mouse.Press_Position;
End;

// Fonction qui retourne si la souri est pressé ou relachée.
Function Mouse_Is_Pressed(Game : Type_Game) : Boolean;
Begin
  Mouse_Is_Pressed := Game.Mouse.State;
End;

// Fonction qui retourne la position de la souris losqu'elle a été relachée (pour la dernière fois).
Function Mouse_Get_Release_Position(Game : Type_Game) : Type_Coordinates;
Begin
  Mouse_Get_Release_Position := Game.Mouse.Release_Position;
End;

End.
