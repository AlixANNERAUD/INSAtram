
Unit Unit_Mouse;

Interface

Uses Unit_Types, sdl;

Procedure Mouse_Load(Game : Type_Game);

Function Mouse_Get_Position() : Type_Coordinates;

Function Mouse_Is_Pressed(Game : Type_Game) : Boolean;

Procedure Mouse_Event_Handler(Mouse_Event : TSDL_MouseButtonEvent; Var Game : Type_Game);

Function Mouse_On_Object(Mouse_Position, Object_Position, Object_Size : Type_Coordinates) : Boolean;

Function Mouse_Get_Press_Position(Game : Type_Game) : Type_Coordinates;
Function Mouse_Get_Release_Position(Game : Type_Game) : Type_Coordinates;

Implementation

Function Mouse_On_Object(Mouse_Position, Object_Position, Object_Size : Type_Coordinates) : Boolean;
Begin
  If (Mouse_Position.X >= Object_Position.X) And (Mouse_Position.X <= Object_Position.X + Object_Size.X) And (Mouse_Position.Y >= Object_Position.Y) And (Mouse_Position.Y <= Object_Position.Y +
     Object_Size.Y) Then
    Mouse_On_Object := True
  Else
    Mouse_On_Object := False;
End;

// Procedure qui gère les interractions avec la souris.
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

  // Si la souris est pressé.
  If (Mouse_Is_Pressed(Game)) Then
    Begin
      // Si il y a un clic dans le panneau du haut.
      If (Mouse_On_Object(Mouse_Get_Press_Position(Game), Game.Panel_Top.Position, Game.Panel_Top.Size)) Then
        Begin
          // Vérifie si le clic est sur le bouton play pause.
          If (Mouse_On_Object(Mouse_Get_Press_Position(Game), Game.Play_Pause_Button.Position, Game.Play_Pause_Button.Size)) Then
              Game.Play_Pause_Button.State := Not(Game.Play_Pause_Button.State);
        End;

      // Si la souris se trouve dans le panneau de gauche.
      If (Mouse_On_Object(Mouse_Get_Press_Position(Game), Game.Panel_Left.Position, Game.Panel_Left.Size)) Then
        writeln('Mouse on panel left');
    End
    // Si la souris est relachée.
  Else
    Begin
      // Si la souris se trouve sur le panneau de droite.
      If (Mouse_On_Object(Mouse_Get_Release_Position(Game), Game.Panel_Right.Position, Game.Panel_Right.Size)) Then
        writeln('Mouse on panel right');
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
