
Unit Unit_Mouse;

Interface

Uses Unit_Types, sdl;


// - Chargement

Procedure Mouse_Load(Game : Type_Game);

// - Gestion des évènements.

Procedure Mouse_Event_Handler(Mouse_Event : TSDL_MouseButtonEvent; Var Game : Type_Game);

// - Attributs

Function Mouse_Get_Press_Position(Game : Type_Game) : Type_Coordinates;
Function Mouse_Get_Release_Position(Game : Type_Game) : Type_Coordinates;
Function Mouse_Get_Position() : Type_Coordinates;
Function Mouse_Is_Pressed(Game : Type_Game) : Boolean;

// - Détection de colisions / superposition.

Function Mouse_On_Panel(Mouse_Position : Type_Coordinates; Panel : Type_Panel) : Boolean;
Function Mouse_On_Object(Mouse_Position : Type_Coordinates; Object_Position, Object_Size : Type_Coordinates; Panel : Type_Panel) : Boolean;

Implementation

// Fonction qui vérifie si la souris se trouve sur un objet donné.
Function Mouse_On_Object(Mouse_Position : Type_Coordinates; Object_Position, Object_Size : Type_Coordinates; Panel : Type_Panel) : Boolean;
Begin
  If (Mouse_Position.X >= Object_Position.X + Panel.Position.X) And (Mouse_Position.X <= Object_Position.X + Object_Size.X + Panel.Position.X) And
     (Mouse_Position.Y >= Object_Position.Y + Panel.Position.Y) And (Mouse_Position.Y <= Object_Position.Y + Object_Size.Y + Panel.Position.Y) Then
    Mouse_On_Object := True
  Else
    Mouse_On_Object := False;
End;

// Fonction qui vérifie si la souris se trouve sur un panneau donné.
Function Mouse_On_Panel(Mouse_Position : Type_Coordinates; Panel : Type_Panel) : Boolean;
Begin
  If (Mouse_Position.X >= Panel.Position.X) And (Mouse_Position.X <= Panel.Position.X + Panel.Size.X) And
     (Mouse_Position.Y >= Panel.Position.Y) And (Mouse_Position.Y <= Panel.Position.Y + Panel.Size.Y) Then
    Mouse_On_Panel := True
  Else
    Mouse_On_Panel := False;
End;

// Procedure qui gère les interractions avec la souris.
Procedure Mouse_Event_Handler(Mouse_Event : TSDL_MouseButtonEvent; Var Game : Type_Game);

Var i, j, k : Byte;
Begin
  If (Mouse_Event.Button = SDL_BUTTON_LEFT) Then
    Begin
      // Si la souris à été pressé.
      If (Mouse_Event.state = SDL_PRESSED) Then
        Begin
          // Mise à jour des attributs.
          Game.Mouse.State := True;
          Game.Mouse.Press_Position.X := Mouse_Event.x;
          Game.Mouse.Press_Position.Y := Mouse_Event.y;
        End
        // Si la souris à été relachée.
      Else
        Begin
          // Mise à jour des attributs.
          Game.Mouse.State := False;
          Game.Mouse.Release_Position.X := Mouse_Event.x;
          Game.Mouse.Release_Position.Y := Mouse_Event.y;
        End;
    End;

  // Si la souris est pressé.
  If (Mouse_Is_Pressed(Game)) Then
    Begin
      // Si la souris se trouve dans le panneau de gauche.
      If (Mouse_On_Panel(Mouse_Get_Release_Position(Game), Game.Panel_Left)) Then
        Begin
          // Si la souris se trouve le boutton d'ajout d'une locomotive.
          If (Mouse_On_Object(Mouse_Get_Release_Position(Game), Game.Locomotive_Button.Position, Game.Locomotive_Button.Size, Game.Panel_Left)) Then
            Begin
              Game.Mouse.Mode := Mouse_Mode_Add_Locomotive;
            End
            // Si la souris se trouve sur le boutton d'ajout d'un wagon.
          Else If (Mouse_On_Object(Mouse_Get_Release_Position(Game), Game.Wagon_Button.Position, Game.Wagon_Button.Size, Game.Panel_Left)) Then
                 Begin
                   Game.Mouse.Mode := Mouse_Mode_Add_Wagon;
                 End
        End;


    End
    // Si la souris est relachée.
  Else
    Begin
      // Si il y a un clic dans le panneau du haut.
      If (Mouse_On_Panel(Mouse_Get_Release_Position(Game), Game.Panel_Top)) Then
        Begin
          // Vérifie si le clic est sur le bouton play pause.
          If (Mouse_On_Object(Mouse_Get_Release_Position(Game), Game.Play_Pause_Button.Position, Game.Play_Pause_Button.Size, Game.Panel_Top)) Then
            Game.Play_Pause_Button.State := Not(Game.Play_Pause_Button.State);
        End;


      // Si la souris se trouve sur le panneau de droite.
      If (Mouse_On_Panel(Mouse_Get_Release_Position(Game), Game.Panel_Right)) Then
        Begin
          // Si le curseur est en mode ajout de locomotive.
          If (Game.Mouse.Mode = Mouse_Mode_Add_Locomotive) Then
            Begin
              If (length(Game.Lines) > 0)
              Begin
              // Parcourt les lignes.
              For i := low(Game.Lines) To high(Game.Lines) Do
                Begin
                  // Parcourt les stations (et point intermédiaires) d'une ligne.
                  For j := low(Game.Lines[i].Stations) To high(Game.Lines[i].Stations) - 1 Do
                  Begin
                    // Vérifie que le pointeur est en collision avec la première partie d'une ligne.
                    If (Line_Rectangle_Colling(Game.Lines[i].Stations[j].Position, Game.Lines[i].Intermediate_Position[j], Mouse_Get_Release_Position(), Game.Ressources.Vehicle_0_Degree.Size))
                    Begin

                    End;
                    // Vérifie que le pointeur est en collision avec la deuxième partie d'une ligne.
                    If (Line_Rectangle_Colling(Game.Lines[i].Intermediate_Position[j], Game.Lines[i].Stations[j + 1].Position, Mouse_Get_Release_Position(), Game.Ressources.Vehicle_0_Degree.Size))
                    Begin

                    End;
                  End; 
                  End;

                End;
    
          // Si le curseur est en mode ajout de wagons.
          Else If (Game.Mouse.Mode = Mouse_Mode_Add_Wagon) Then
                 Begin
                   // Détecte si le pointeur est sur un train.
                   For i := low(Game.Lines) To high(Game.Lines) Do
                     Begin
                       For j := low(Game.Lines[i].Trains) To high(Game.Lines[i].Trains) Do
                         Begin
                           If (Mouse_On_Object(Mouse_Get_Release_Position(Game), Game.Lines[i].Trains[j].Position, Game.Lines[i].Trains[j].Size, Game.Panel_Right)) Then
                             Begin
                               Vehicle_Create(Game.Lines[i].Trains[j]);
                               Break;
                               Break;
                             End;
                         End;
                     End;
                 End;

        End;

      // Si la souris se trouve dans le panneau du bas.
      If (Mouse_On_Panel(Mouse_Get_Release_Position(Game), Game.Panel_Bottom)) Then
        Begin
          For i := 0 To Game_Maximum_Lines_Number - 1 Do
            Begin
              If (Mouse_On_Object(Mouse_Get_Release_Position(Game), Game.Lines_Buttons[i].Position, Game.Lines_Buttons[i].Size, Game.Panel_Bottom)) Then
                Game.Lines_Buttons[i].State := Not(Game.Lines_Buttons[i].State)
              Else
                Game.Lines_Buttons[i].State := False;

            End;
        End;

      Game.Mouse.Mode := Mouse_Mode_Normal;

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
