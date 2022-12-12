
Unit Unit_Mouse;

Interface

Uses Unit_Types, sdl, crt;


// - Chargement

Procedure Mouse_Load(Var Mouse : Type_Mouse);

// - Gestion des évènements.

Procedure Mouse_Event_Handler(Mouse_Event : TSDL_MouseButtonEvent; Var Game : Type_Game);

// - Attributs

Function Mouse_Get_Press_Position(Game : Type_Game) : Type_Coordinates;
Function Mouse_Get_Press_Position(Game : Type_Game; Size : Type_Coordinates) : Type_Coordinates;
Function Mouse_Get_Release_Position(Game : Type_Game) : Type_Coordinates;
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

Procedure Mouse_Set_Mouse_Mode(Var Game : Type_Game);

Function Mouse_Pressed_On_Line(Var Game : Type_Game) : Boolean;
Function Mouse_Pressed_On_Station(Var Game : Type_Game) : Boolean;


Implementation

// Fonction qui charge les images de manière optimisée pour le rendu.



Procedure Mouse_Line_Delete_Station(Var Game : Type_Game);

Var i : Byte;
  Selected_Line : Type_Line_Pointer;
Begin

End;

// Fonction qui vérifie que la souris est sur une station et l'ajoute à la ligne actuellement maintenue par la souris.
Procedure Mouse_Line_Add_Station(Var Game : Type_Game);

Var i : Byte;
  Mouse_Position : Type_Coordinates;
Begin
  Mouse_Position := Mouse_Get_Release_Position(Game);

  // Itère parmis toutes les stations.
  For i := low(Game.Stations) To high(Game.Stations) Do
    Begin
      // Si la souris se trouve sur une station.
      If (Mouse_On_Object(Mouse_Position, Game.Stations[i].Position, Game.Stations[i].Size, Game.Panel_Right)) Then
        Begin

          If (Game.Mouse.Mode = Type_Mouse_Mode.Line_Insert_Station) Then
            Begin
              writeln('Mouse release on sta');
              Line_Add_Station(Game.Mouse.Selected_Last_Station, @Game.Stations[i], Game.Mouse.Selected_Line^);
            End
          Else If (Game.Mouse.Mode = Type_Mouse_Mode.Line_Add_Station) Then
                 Begin

                   Line_Add_Station(Game.Mouse.Selected_Last_Station, Game.Mouse.Selected_Line^);
                   Line_Add_Station(@Game.Stations[i], Game.Mouse.Selected_Line^);
                 End;
          Break;
        End;
    End;
End;

// Procedure qui détermine le mode du curseur en fonction de la première interraction de l'utilisateur.
Procedure Mouse_Set_Mouse_Mode(Var Game : Type_Game);
Begin

End;

// Fonction uqui vérifie si la souris est sur une station et détermine la ligne actuellement sélectionnée.
Function Mouse_Pressed_On_Station(Var Game : Type_Game) : Boolean;

Var Line : Type_Line_Pointer;
  i : Byte;
Begin
  Line := Lines_Get_Selected(Game);

  Mouse_Pressed_On_Station := false;

  If (Line <> Nil) Then
    Begin
      // - Ajout des 2 premières stations à la ligne.
      // Vérifie si la ligne ne contient aucune station.
      If (length(Line^.Stations) = 0) Then
        Begin
          // Itère sur toutes les stations.
          For i := low(Game.Stations) To high(Game.Stations) Do
            Begin
              If (Mouse_On_Object(Mouse_Get_Press_Position(Game), Game.Stations[i].Position, Game.Stations[i].Size, Game.Panel_Right)) Then
                Begin
                  Game.Mouse.Selected_Line := @Game.Lines[i];
                  Game.Mouse.Selected_Last_Station := @Game.Stations[i];
                  Game.Mouse.Mode := Type_Mouse_Mode.Line_Add_Station;
                  Mouse_Pressed_On_Station := true;
                  Break;
                End;
            End;
        End
        // - Suppression d'une station de la ligne.
        // Si la ligne contient des stations.
      Else
        Begin
          For i := low(Line^.Stations) To high(Line^.Stations) Do
            Begin
              If (Mouse_On_Object(Mouse_Get_Press_Position(Game), Line^.Stations[i]^.Position, Line^.Stations[i]^.Size, Game.Panel_Right)) Then
                Begin










// ! Attention : La suppression de la station dans la ligne étant imédiate, il faudrait vérifier et / ou attendre que le train actuellement en transit sur l'axe passant par la station ait passé l'axe, au risque d'avoir des comportements étranges.
                  Line_Remove_Station(Line^.Stations[i], Line^);
                  Mouse_Pressed_On_Station := true;
                  Break;
                End;
            End;
        End;
    End;

End;

// Fonction qui prend détermine si le souris est pressé sur une ligne et détermine la station précédente et la station suivante qui servira à l'insertion de la nouvelle station.
Function Mouse_Pressed_On_Line(Var Game : Type_Game) : Boolean;

Var Mouse_Position : Type_Coordinates;
  i : Byte;
  Line : Type_Line_Pointer;
Begin
  Mouse_Pressed_On_Line := false;
  // Vérifie si la souris se trouve sur une ligne.

  // Vérifie qu'il y a bien des lignes dans la partie.

  Line := Lines_Get_Selected(Game);

  If (Line <> Nil) Then
    Begin



      Mouse_Position := Panel_Get_Relative_Position(Mouse_Get_Press_Position(Game), Game.Panel_Right);

      Mouse_Position.X := Mouse_Position.X - (Mouse_Size.X Div 2);
      Mouse_Position.Y := Mouse_Position.Y - (Mouse_Size.Y Div 2);


      // Vérifie que la ligne contient des stations
      If (length(Line^.Stations) > 0) Then
        Begin
          // Itère parmis les stations de la ligne selectionnée.
          For i := low(Line^.Stations) To high(Line^.Stations) - 1 Do
            Begin
              If (Line_Rectangle_Colliding(Line^.Stations[i]^.Position_Centered, Line^.Intermediate_Positions[i], Mouse_Position, Mouse_Size)) Or (Line_Rectangle_Colliding(Line^.Intermediate_Positions
                 [i], Line^.Stations[i + 1]^.Position_Centered, Mouse_Position, Mouse_Size)) Then
                Begin
                  Game.Mouse.Selected_Line := @Line^;
                  Game.Mouse.Selected_Last_Station := Line^.Stations[i];
                  Game.Mouse.Selected_Next_Station := Line^.Stations[i + 1];
                  Game.Mouse.Mode := Type_Mouse_Mode.Line_Insert_Station;

                  Mouse_Pressed_On_Line := true;

                  writeln('Mouse pressed on line');

                  Break;
                  Break;
                End;
            End;
        End;
    End;
End;

// Fonction qui prend détermine si le souris est relaché sur une ligne et détermine comment ajouter le train.
Procedure Mouse_Line_Add_Train(Var Game : Type_Game);

Var Mouse_Position : Type_Coordinates;
  i, j : Byte;
Begin
  If (length(Game.Lines) > 0) Then
    Begin
      Mouse_Position := Panel_Get_Relative_Position(Mouse_Get_Release_Position(Game), Game.Panel_Right);

      Mouse_Position.X := Mouse_Position.X - (Vehicle_Size.X Div 2);
      Mouse_Position.Y := Mouse_Position.Y - (Vehicle_Size.Y Div 2);

      // Parcourt les lignes.
      For i := low(Game.Lines) To high(Game.Lines) Do
        Begin
          If (length(Game.Lines[i].Stations) > 0) Then
            Begin
              // Parcourt les stations (et point intermédiaires) d'une ligne.
              For j := low(Game.Lines[i].Stations) To high(Game.Lines[i].Stations) - 1 Do
                Begin
                  // Vérifie que le pointeur est en collision avec les deux partie d'une ligne.
                  If (Line_Rectangle_Colliding(Game.Lines[i].Stations[j]^.Position_Centered, Game.Lines[i].Intermediate_Positions[j], Mouse_Position, Vehicle_Size) Or Line_Rectangle_Colliding(Game.
                     Lines[i].Intermediate_Positions[j], Game.Lines[i].Stations[j + 1]^.Position_Centered, Mouse_Position, Vehicle_Size))
                    Then
                    Begin
                      // Si le curseur est plus proche de la première station.
                      If (Get_Distance(Mouse_Position, Game.Lines[i].Stations[j]^.Position_Centered) <= Get_Distance(Mouse_Position, Game.Lines[i].Stations[j + 1]^.Position_Centered)) Then
                        Begin
                          // Créer un train qui par de la station précédente, dans le sens indirect.
                          Train_Create(Game.Lines[i].Stations[j], false, Game.Lines[i], Game);
                        End
                      // Si le curseur est plus proche de la seconde station.
                      Else
                        Begin
                          // Créer un train qui part de la station suivante, dans le sens direct.
                          Train_Create(Game.Lines[i].Stations[j + 1], true, Game.Lines[i], Game);
                        End;
                          dec(Game.Player.Locomotive_Token);
                      Break;
                      Break;
                    End;
                End;
            End;
        End;
    End;
End;

Procedure Mouse_Train_Add_Wagon(Var Game : Type_Game);

Var i, j : Byte;
Begin
  // Vérifie qu'il y a bien des lignes dans la partie.
  If (length(Game.Lines) > 0) Then
    Begin
      // Itère parmis les lignes.
      For i := low(Game.Lines) To high(Game.Lines) Do
        Begin
          If (length(Game.Lines[i].Trains) > 0) Then
            Begin
              // Itère parmis les trains d'une ligne.
              For j := low(Game.Lines[i].Trains) To high(Game.Lines[i].Trains) Do
                Begin
                  // Détecte si le pointeur est sur un train.
                  If (Mouse_On_Object(Mouse_Get_Release_Position(Game), Game.Lines[i].Trains[j].Position, Game.Lines[i].Trains[j].Size, Game.Panel_Right)) Then
                    Begin
                      // Ajoute un wagon au train.
                      Vehicle_Create(Game.Lines[i].Trains[j]);
                      dec(Game.Player.Wagon_Token);
                      Break;
                      Break;
                    End;
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

Var i : Byte;
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
      Game.Mouse.Mode := Type_Mouse_Mode.Normal;
      // Si la souris se trouve dans le panneau de gauche.
      If (Mouse_On_Panel(Mouse_Get_Press_Position(Game), Game.Panel_Left)) Then
        Begin
          // Si la souris se trouve le boutton d'ajout d'une locomotive.
          If (Mouse_On_Object(Mouse_Get_Press_Position(Game), Game.Locomotive_Button[0].Position, Game.Locomotive_Button[0].Size, Game.Panel_Left)) And (Game.Player.Locomotive_Token > 0) Then
            Game.Mouse.Mode := Type_Mouse_Mode.Add_Locomotive
                               // Si la souris se trouve sur le boutton d'ajout d'un wagon.
          Else If (Mouse_On_Object(Mouse_Get_Press_Position(Game), Game.Wagon_Button[0].Position, Game.Wagon_Button[0].Size, Game.Panel_Left)) And (Game.Player.Wagon_Token > 0) Then
                 Game.Mouse.Mode := Type_Mouse_Mode.Add_Wagon;
        End;
      // Si la souri se trouve sur le panneau de droite.
      If (Mouse_On_Panel(Mouse_Get_Press_Position(Game), Game.Panel_Right)) Then
        Begin
          Mouse_Pressed_On_Line(Game)
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
            Begin
              Game.Play_Pause_Button.State := Not(Game.Play_Pause_Button.State);
              If (Game.Play_Pause_Button.State) Then
                Game_Play(Game)
              Else
                Game_Pause(Game);
            End;
        End;

      // Si la souris se trouve sur le panneau de droite.
      If (Mouse_On_Panel(Mouse_Get_Release_Position(Game), Game.Panel_Right)) Then
        Begin
          // Si le curseur est en mode ajout de locomotive.
          If (Game.Mouse.Mode = Type_Mouse_Mode.Add_Locomotive) Then
            Mouse_Line_Add_Train(Game)

            // Si le curseur est en mode ajout de wagons.
          Else If (Game.Mouse.Mode = Type_Mouse_Mode.Add_Wagon) Then
                 Mouse_Train_Add_Wagon(Game)

                 // Si le curseur est en mode ajout de station.
          Else If (Game.Mouse.Mode = Type_Mouse_Mode.Line_Add_Station) Or (Game.Mouse.Mode = Type_Mouse_Mode.Line_Insert_Station) Then
                 Mouse_Line_Add_Station(Game);


        End;

      // Si la souris se trouve dans le panneau du bas.
      If (Mouse_On_Panel(Mouse_Get_Release_Position(Game), Game.Panel_Bottom)) Then
        Begin
          For i := 0 To Game_Maximum_Lines_Number - 1 Do
            Begin
              If (Mouse_On_Object(Mouse_Get_Release_Position(Game), Game.Lines[i].Button.Position, Game.Lines[i].Button.Size, Game.Panel_Bottom)) Then
                Game.Lines[i].Button.State := Not(Game.Lines[i].Button.State)
              Else
                Game.Lines[i].Button.State := False;

            End;
        End;

      Game.Mouse.Mode := Type_Mouse_Mode.Normal;

    End;
End;


Procedure Mouse_Load(Var Mouse : Type_Mouse);
Begin
  Mouse.Press_Position.X := 0;
  Mouse.Press_Position.Y := 0;
  Mouse.Release_Position.X := 0;
  Mouse.Release_Position.Y := 0;
  Mouse.State := False;
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
