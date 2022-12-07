
Unit Unit_Mouse;

Interface

Uses Unit_Types, sdl, crt;


// - Chargement

Procedure Mouse_Load(Game : Type_Game);

// - Gestion des évènements.

Procedure Mouse_Event_Handler(Mouse_Event : TSDL_MouseButtonEvent; Var Game : Type_Game);

// - Attributs

Function Mouse_Get_Press_Position(Game : Type_Game) : Type_Coordinates;
Function Mouse_Get_Press_Position(Game : Type_Game; Size : Type_Coordinates) : Type_Coordinates;
Function Mouse_Get_Release_Position(Game : Type_Game) : Type_Coordinates;
Function Mouse_Get_Release_Position(Game : Type_Game; Size : Type_Coordinates) : Type_Coordinates;
Function Mouse_Get_Position() : Type_Coordinates;
Function Mouse_Is_Pressed(Game : Type_Game) : Boolean;


// - Détection de colisions / superposition.

Function Mouse_On_Panel(Mouse_Position : Type_Coordinates; Panel : Type_Panel) : Boolean;
Function Mouse_On_Object(Mouse_Position : Type_Coordinates; Object_Position, Object_Size : Type_Coordinates; Panel : Type_Panel) : Boolean;

// - 

Procedure Mouse_Line_Add_Train(Var Game : Type_Game);
Procedure Mouse_Line_Add_Station(Var Game : Type_Game);
Procedure Mouse_Line_Delete_Station(Var Game : Type_Game);
Procedure Mouse_Train_Add_Wagon(Var Game : Type_Game);

Function Mouse_Set_Mouse_Mode(Var Game : Type_Game);

Procedure Mouse_Pressed_On_Line(Var Game : Type_Game);

Implementation

Procedure Mouse_Line_Delete_Station(Var Game : Type_Game);
Var i : Byte;
    Selected_Line : Type_Line_Pointer;
Begin

End;

// Fonction qui vérifie que la sourie est sur une station et l'ajoute à la station actuellement maintenant par la souris.
Procedure Mouse_Line_Add_Station(Var Game : Type_Game);
Var i : Byte;
Begin
  For i := low(Game.Stations) To high(Game.Station) Do
  Begin
    If (Mouse_On_Object(Mouse_Get_Release_Position(), Game.Stations[i].Position, Game.Stations[i].Size)) Then
    Begin
      Line_Add_Station(Game.Mouse.Selected_Last_Station, @Game.Stations[i], Game.Mouse.Selected_Line);
      Break:
    End;
  End;
End;

// Procedure qui détermine le mode du curseur en fonction de la première interraction de l'utilisateur.
Function Mouse_Set_Mouse_Mode(Var Game : Type_Game);
Begin

End;


Procedure Mouse_Pressed_On_Line(Var Game : Type_Game);

Var Mouse_Size, Mouse_Position;
Begin
  // Vérifie si la souris se trouve sur une ligne.
  // Vérifie qu'il y a bien des lignes dans la partie.
  If (length(Game.Lines) > 0) Then
    Begin
      Mouse_Size.X := Mouse_Hit_Box_Size;
      Mouse_Size.Y := Mouse_Hit_Box_Size;
      Mouse_Position := Mouse_Get_Press_Position(Game, Mouse_Size).;
      // Itère parmis les lignes.
      // TODO : FAUX remplacer avec la ligne sélectionnée.
      For i := low(Game.Lines) To high(Game.Liens) Do
        Begin
          // Vérifie que la ligne contient des stations
          If (length(Game.Lines[i].Stations) > 0) Then
            Begin
              // Itère parmis les stations de la ligne.
              For j := low(Game.Lines[i].Stations) To high(Game.Lines[i].Stations) - 1 Do
                Begin
                  If (Line_Rectangle_Colliding(Game.Lines[i].Stations[j]^.Position_Centered, Game.Lines[i].Intermediate_Positions[j], Panel_Get_Relative_Position(Mouse_Get_Release_Position(
                     Game), Game.Panel_Right), Vehicle_Size)) Then
                    Begin
                      Game.Mouse.Selected_Line := @Game.Lines[i];
                      Game.Mouse.Selected_Last_Station := @Game.Lines[i].Stations[i];
                      Game.Mouse.Selected_Next_Station := @Game.Lines[i].Stations[i + 1];
                      Game.Mouse.Mode := Mouse_Mode_Line_Add_Station;
                      Break;
                      Break;
                    End;
                  // Vérifie que le pointeur est en collision avec la deuxième partie d'une ligne.
                  If (Line_Rectangle_Colliding(Game.Lines[i].Intermediate_Positions[j], Game.Lines[i].Stations[j + 1]^.Position_Centered, Panel_Get_Relative_Position(Mouse_Get_Release_Position
                     (Game), Game.Panel_Right), Vehicle_Size)) Then
                    Begin
                      Game.Mouse.Selected_Line := @Game.Lines[i];
                      Game.Mouse.Selected_Last_Station := @Game.Lines[i].Stations[i];
                      Game.Mouse.Selected_Next_Station := @Game.Lines[i].Stations[i + 1];
                      Game.Mouse.Mode := Mouse_Mode_Line_Add_Station;
                      Break;
                      Break;
                    End;
                End;
            End;
        End;
    End;
End;

// Fonction qui prend détermine si le souris est relaché sur une ligne et détermine comment ajouter le train.
Procedure Mouse_Line_Add_Train(Var Game : Type_Game);

Var Vehcile_Size : Type_Coordinates;
  i, j : Byte;
Begin
  If (length(Game.Lines) > 0) Then
    Begin
      Vehicle_Size.X := Game.Ressources.Vehicle_0_Degree^.w;
      Vehicle_Size.Y := Game.Ressources.Vehicle_0_Degree^.h;
      // Parcourt les lignes.
      For i := low(Game.Lines) To high(Game.Lines) Do
        Begin
          // Parcourt les stations (et point intermédiaires) d'une ligne.
          For j := low(Game.Lines[i].Stations) To high(Game.Lines[i].Stations) - 1 Do
            Begin
              // Vérifie que le pointeur est en collision avec la première partie d'une ligne.

              If (Line_Rectangle_Colliding(Game.Lines[i].Stations[j]^.Position_Centered, Game.Lines[i].Intermediate_Positions[j], Panel_Get_Relative_Position(Mouse_Get_Release_Position(
                 Game), Game.Panel_Right), Vehicle_Size))
                Then
                Begin
                  Train_Create(Game.Lines[i].Stations[j], false, Game.Lines[i], Game);
                  Break;
                  Break;
                End;
              // Vérifie que le pointeur est en collision avec la deuxième partie d'une ligne.
              If (Line_Rectangle_Colliding(Game.Lines[i].Intermediate_Positions[j], Game.Lines[i].Stations[j + 1]^.Position_Centered, Panel_Get_Relative_Position(Mouse_Get_Release_Position
                 (Game), Game.Panel_Right), Vehicle_Size)) Then
                Begin
                  Train_Create(Game.Lines[i].Stations[j + 1], true, Game.Lines[i], Game);

                  Break;
                  Break;
                End;
            End;
        End;
    End;
End;

Procedure Mouse_Train_Add_Wagon(Var Game : Type_Game);

Var i, j : Byte;
Begin
  If (length(Game.Lines)) Then
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
  Vehicle_Size : Type_Coordinates;
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
      Game.Mouse.Mode := Mouse_Mode_Normal;
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
      // Si la souri se trouve sur le panneau de droite.
      If (Mouse_On_Pannel(Mouse_Get_Release_Position(Game), Game.Panel_Right)) Then
        Begin
          Mouse_Pressed_On_Line(Game);
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
            Mouse_Add_Locomotive(Game);

          // Si le curseur est en mode ajout de wagons.
          Else If (Game.Mouse.Mode = Mouse_Mode_Add_Wagon) Then
                 Mouse_Train_Add_Wagon(Game);

          // Si le curseur est en mode ajout de station.
          Else If (Gaem.Mouse.Mode = Mouse_Mode_Line_Add_Station) Then
                  Mouse_Mode_Line_Add_Station(Game);

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

// Fonction qui calcule et retourne la position de la hit box de la souris.
Function Mouse_Get_Press_Position(Game : Type_Game; Size : Type_Coordinates) : Type_Coordinates;
Begin
  Mouse_Get_Press_Position.X := Mouse_Get_Press_Position(Game).X - round(0.5 * Size.X);
  Mouse_Get_Press_Position.Y := Mouse_Get_Press_Position(Game).Y - round(0.5 * Size.Y);
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
