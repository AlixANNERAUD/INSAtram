
Unit Unit_Mouse;

Interface

// - Dépendances

Uses Unit_Types, Unit_Common, Unit_Constants, Unit_Sounds, sdl, crt;


// - Chargement

Procedure Mouse_Load(Var Mouse : Type_Mouse);

// - Gestion des événements.

Procedure Mouse_Event_Handler(Mouse_Event : TSDL_MouseButtonEvent; Var Game : Type_Game);

Function Mouse_Get_Position() : Type_Coordinates;


Implementation

// - Chargement de l'unité souris.

// Procédure qui initialise les attributs de l'unité.
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

// Fonction qui retourne la position de la souris lorsqu'elle a été pressée (pour la dernière fois).
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

// Fonction qui retourne si la souris est pressée ou relâchée.
Function Mouse_Is_Pressed(Game : Type_Game) : Boolean;
Begin
  Mouse_Is_Pressed := Game.Mouse.State;
End;

// Fonction qui retourne la position de la souris lorsqu'elle a été relâchée (pour la dernière fois).
Function Mouse_Get_Release_Position(Game : Type_Game) : Type_Coordinates;
Begin
  Mouse_Get_Release_Position := Game.Mouse.Release_Position;
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

// Fonction qui détermine si la souris est pressée sur une ligne et détermine la station précédente et la station suivante qui servira à l'insertion de la nouvelle station.
Function Mouse_Pressed_On_Line(Var Game : Type_Game) : Boolean;

Var Mouse_Position : Type_Coordinates;
  i : Byte;
  Line : Type_Line_Pointer;
Begin
  Mouse_Pressed_On_Line := false;

  Line := Lines_Get_Selected(Game);

  // Vérifie si il y a bien une ligne selectionnée.
  If (Line <> Nil) Then
    Begin
      // Calcul des coordonnées du pointeur dans le tableau.
      Mouse_Position := Panel_Get_Relative_Position(Mouse_Get_Press_Position(Game), Game.Panel_Right);

      // Prise en compte de la hit box de la souris.
      Mouse_Position.X := Mouse_Position.X - (Mouse_Size.X Div 2);
      Mouse_Position.Y := Mouse_Position.Y - (Mouse_Size.Y Div 2);

      // Vérifie que la ligne contient des stations
      If (length(Line^.Stations) > 0) Then
        Begin
          // Itère parmi les stations de la ligne selectionnée.
          For i := low(Line^.Stations) To high(Line^.Stations) - 1 Do
            Begin
              // Vérifie si le pointeur de la souris est en collision avec la ligne.
              If (Line_Rectangle_Colliding(Line^.Stations[i]^.Position_Centered, Line^.Intermediate_Positions[i], Mouse_Position, Mouse_Size)) Or (Line_Rectangle_Colliding(Line^.Intermediate_Positions
                 [i], Line^.Stations[i + 1]^.Position_Centered, Mouse_Position, Mouse_Size)) Then
                Begin
                  Game.Mouse.Selected_Line := Line;
                  Game.Mouse.Selected_Last_Station := Line^.Stations[i];
                  Game.Mouse.Selected_Next_Station := Line^.Stations[i + 1];
                  Game.Mouse.Mode := Type_Mouse_Mode.Line_Insert_Station;

                  Mouse_Pressed_On_Line := true;
                  Break;
                  Break;
                End;
            End;
        End;
    End;
End;



// - Panneau de droite.

// Fonction qui vérifie si la souris est sur une station et détermine la ligne actuellement sélectionnée.
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
              If (Mouse_On_Object(Mouse_Get_Press_Position(Game), Game.Stations[i]^.Position, Game.Stations[i]^.Size, Game.Panel_Right)) Then
                Begin

                  Game.Mouse.Selected_Line := Line;

                  Game.Mouse.Selected_Last_Station := Game.Stations[i];

                  Game.Mouse.Mode := Type_Mouse_Mode.Line_Add_Station;

                  Mouse_Pressed_On_Station := true;
                  Break;
                End;
            End;
        End
        // - Suppression d'une station de la ligne.

        // Si la ligne contient des stations,
      Else
        Begin
          For i := low(Line^.Stations) To high(Line^.Stations) Do
            Begin
              If (Mouse_On_Object(Mouse_Get_Press_Position(Game), Line^.Stations[i]^.Position, Line^.Stations[i]^.Size, Game.Panel_Right)) Then
                Begin
                  Line_Remove_Station(Line^.Stations[i], Line^, Game);
                  Mouse_Pressed_On_Station := true;
                  Break;
                End;
            End;
        End;
    End;

End;

// Fonction qui charge les images de manière optimisée pour le rendu.
Function Mouse_Pressed_On_Train(Var Game : Type_Game) : Boolean;

Var i, j : Byte;
Begin
  Mouse_Pressed_On_Train := false;
  // Vérifie qu'il y a bien des lignes dans la partie.
  If (length(Game.Lines) > 0) Then
    Begin
      // Itère parmi les lignes.
      For i := low(Game.Lines) To high(Game.Lines) Do
        Begin
          If (length(Game.Lines[i].Trains) > 0) Then
            Begin
              // Itère parmi les trains d'une ligne.
              For j := low(Game.Lines[i].Trains) To high(Game.Lines[i].Trains) Do
                Begin
                  // Détecte si le pointeur est sur un train.
                  If (Mouse_On_Object(Mouse_Get_Press_Position(Game), Game.Lines[i].Trains[j].Position, Game.Lines[i].Trains[j].Size, Game.Panel_Right)) Then
                    Begin
                      // Supprime un wagon au train.
                      Vehicle_Delete(Game.Lines[i].Trains[j]);
                      dec(Game.Player.Wagon_Token);
                      Mouse_Pressed_On_Train := true;
                      Break;
                      Break;
                    End;
                End;
            End;
        End;
    End;
End;

// Procédure qui prend en charge les appuis de la souris sur le panneau de droite.
Procedure Panel_Right_Pressed(Var Game : Type_Game);
Begin
  If Not(Mouse_Pressed_On_Station(Game)) Then
    If Not(Mouse_Pressed_On_Train(Game)) Then
      Mouse_Pressed_On_Line(Game);
End;

// - Panneau de gauche.

// Procédure qui prend en charge les appuis de la souris sur le panneau de gauche.
Procedure Panel_Left_Pressed(Var Game : Type_Game);
Begin
  // Si la souris se trouve sur le boutton d'ajout d'un train.
  If Mouse_On_Object(Mouse_Get_Press_Position(Game), Game.Locomotive_Button[0].Position, Game.Locomotive_Button[0].Size, Game.Panel_Left) Then
    Begin
      // Si le joueur a des jetons de train,
      If Game.Player.Locomotive_Token > 0 Then
        Game.Mouse.Mode := Type_Mouse_Mode.Add_Locomotive
    End
    // Si la souris se trouve sur le bouton d'ajout d'un wagon,
  Else If Mouse_On_Object(Mouse_Get_Press_Position(Game), Game.Wagon_Button[0].Position, Game.Wagon_Button[0].Size, Game.Panel_Left) Then
         Begin
           // Si le joueur a des jetons de wagon,
           If Game.Player.Wagon_Token > 0 Then
             Game.Mouse.Mode := Type_Mouse_Mode.Add_Wagon;
         End;
End;

// - Panneau des récompenses.

// Procédure qui prend en charge les appuis de la souris sur le panneau des récompenses.
Procedure Panel_Reward_Pressed(Var Game : Type_Game);

Var i : Byte;
Begin
  // Vérifie si le panneau des récompenses n'est pas dissimulé.
  If Not(Game.Panel_Reward.Hidden) Then
    Begin
      // Vérifie si la souris est sur le panneau des récompenses.
      If (Mouse_On_Panel(Mouse_Get_Press_Position(Game), Game.Panel_Reward)) Then
        Begin
          // Définition de la valeur par défaut pour i.
          i := 255;

          If (Mouse_On_Object(Mouse_Get_Press_Position(Game), Game.Reward_Buttons[0].Position, Game.Reward_Buttons[0].Size, Game.Panel_Reward)) Then
            i := 0
          Else If (Mouse_On_Object(Mouse_Get_Press_Position(Game), Game.Reward_Buttons[1].Position, Game.Reward_Buttons[1].Size, Game.Panel_Reward)) Then
                 i := 1;

          If (i <> 255) Then
            Begin
              Case Game.Reward_Labels[i].Text Of 
                'Train' : inc(Game.Player.Locomotive_Token);
                'Wagon' : inc(Game.Player.Wagon_Token);
                'Tunnel' : inc(Game.Player.Tunnel_Token);
                'Line' : Line_Create(Game);
              End;

              // Cache le panneau des récompenses.
              Panel_Set_Hidden(true, Game.Panel_Reward);
              // Reprend la partie.
              Game_Resume(Game);
            End;
        End;
    End;
End;

// Procédure qui prend en charge les appuis de la souris sur le panneau de game over.
Procedure Panel_Game_Over_Pressed(Var Game : Type_Game);

Var i : Byte;
Begin
  // Vérifie si le panneau des récompenses n'est pas dissimulé.
  If Not(Game.Panel_Game_Over.Hidden) Then
    Begin
      // Vérifie si la souris est sur le panneau des récompenses.
      If (Mouse_On_Panel(Mouse_Get_Press_Position(Game), Game.Panel_Game_Over)) Then
        Begin
          If (Mouse_On_Object(Mouse_Get_Press_Position(Game), Game.Game_Over_Quit_Button.Position, Game.Game_Over_Quit_Button.Size, Game.Panel_Game_Over)) Then
            Begin
              SDL_Quit();
            End
          Else If (Mouse_On_Object(Mouse_Get_Press_Position(Game), Game.Game_Over_Restart_Button.Position, Game.Game_Over_Restart_Button.Size, Game.Panel_Game_Over)) Then
                 Begin
                    Game_Unload(Game);
                    Game_Load(Game);
                 End;
        End;
    End;
End;


// Fonction qui vérifie que la souris est sur une station et l'ajoute à la ligne actuellement maintenue par la souris.
Procedure Mouse_Line_Add_Station(Var Game : Type_Game);

Var i : Byte;
  Mouse_Position : Type_Coordinates;
Begin
  Mouse_Position := Mouse_Get_Release_Position(Game);

  // Itère parmi toutes les stations.
  For i := low(Game.Stations) To high(Game.Stations) Do
    Begin
      // Si la souris se trouve sur une station,
      If (Mouse_On_Object(Mouse_Position, Game.Stations[i]^.Position, Game.Stations[i]^.Size, Game.Panel_Right)) Then
        Begin

          If (Game.Mouse.Mode = Type_Mouse_Mode.Line_Insert_Station) Then
            Begin

              Line_Add_Station(Game.Mouse.Selected_Last_Station, Game.Stations[i], Game.Mouse.Selected_Line^, Game);
            End
          Else If (Game.Mouse.Mode = Type_Mouse_Mode.Line_Add_Station) Then
                 Begin
                   Line_Add_Station(Game.Mouse.Selected_Last_Station, Game.Mouse.Selected_Line^, Game);
                   Line_Add_Station(Game.Stations[i], Game.Mouse.Selected_Line^, Game);
                 End;
          Break;
        End;
    End;
End;

// Procédure qui détermine si la souris est relâchée sur une ligne et détermine comment ajouter le train.
Procedure Mouse_Line_Add_Train(Var Game : Type_Game);

Var Mouse_Position : Type_Coordinates;
  j : Byte;
  Line : Type_Line_Pointer;
Begin

  Line := Lines_Get_Selected(Game);

  If (Line <> Nil) Then
    Begin
      Mouse_Position := Panel_Get_Relative_Position(Mouse_Get_Release_Position(Game), Game.Panel_Right);

      Mouse_Position.X := Mouse_Position.X - (Vehicle_Size.X Div 2);
      Mouse_Position.Y := Mouse_Position.Y - (Vehicle_Size.Y Div 2);

      // Parcourt les lignes.

      If (length(Line^.Stations) > 0) Then
        Begin
          // Parcourt les stations (et points intermédiaires) d'une ligne.
          For j := low(Line^.Stations) To high(Line^.Stations) - 1 Do
            Begin
              // Vérifie que le pointeur est en collision avec les deux parties d'une ligne.
              If (Line_Rectangle_Colliding(Line^.Stations[j]^.Position_Centered, Line^.Intermediate_Positions[j], Mouse_Position, Vehicle_Size) Or Line_Rectangle_Colliding(Line^.Intermediate_Positions
                 [j], Line^.Stations[j + 1]^.Position_Centered, Mouse_Position, Vehicle_Size))
                Then
                Begin
                  // Si le curseur est plus proche de la première station,
                  If (Get_Distance(Mouse_Position, Line^.Stations[j]^.Position_Centered) <= Get_Distance(Mouse_Position, Line^.Stations[j + 1]^.Position_Centered)) Then
                    Begin
                      // Crée un train qui part de la station précédente, dans le sens indirect.
                      Train_Create(Line^.Stations[j], false, Line^, Game);
                    End
                    // Si le curseur est plus proche de la seconde station,
                  Else
                    Begin
                      // Créer un train qui part de la station suivante, dans le sens direct.
                      Train_Create(Line^.Stations[j + 1], true, Line^, Game);
                    End;
                  dec(Game.Player.Locomotive_Token);
                  Break;
                  Break;
                End;
            End;
        End;

    End;
End;

// Procédure qui ajoute un wagon à un train.
Procedure Mouse_Train_Add_Wagon(Var Game : Type_Game);

Var i, j : Byte;
Begin
  // Vérifie qu'il y a bien des lignes dans la partie.
  If (length(Game.Lines) > 0) Then
    Begin
      // Itère parmi les lignes.
      For i := low(Game.Lines) To high(Game.Lines) Do
        Begin
          If (length(Game.Lines[i].Trains) > 0) Then
            Begin
              // Itère parmi les trains d'une ligne.
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

Procedure Panel_Top_Released(Var Game : Type_Game);
Begin
  // Vérifie si le clic est sur le bouton play/pause.
  If Mouse_On_Object(Mouse_Get_Release_Position(Game), Game.Play_Pause_Button.Position, Game.Play_Pause_Button.Size, Game.Panel_Top) Then
    Begin
      If (Game.Play_Pause_Button.State) Then
        Game_Pause(Game)
      Else
        Game_Resume(Game);
    End
  // Vérifie si le clic est sur le bouton de restart.
  Else If Mouse_On_Object(Mouse_Get_Release_Position(Game), Game.Restart_Button.Position, Game.Restart_Button.Size, Game.Panel_Top) Then
         Begin
           Game_Unload(Game);
           Game_Load(Game);
         End
  // Vérifie si le clic est sur le boutton de son.
  Else If Mouse_On_Object(Mouse_Get_Release_Position(Game), Game.Sound_Button.Position, Game.Sound_Button.Size, Game.Panel_Top) Then
         Begin
            Game.Sound_Button.State := Not(Game.Sound_Button.State);
           If (Game.Sound_Button.State) Then
              Sounds_Set_Volume(Sounds_Maximum_Volume)
           Else
             Sounds_Set_Volume(0);
         End
    // Vérifie si le clic est sur le bouton pour quitter.
  Else If Mouse_On_Object(Mouse_Get_Release_Position(Game), Game.Quit_Button.Position, Game.Quit_Button.Size, Game.Panel_Top) Then
         Begin
            SDL_Quit();
         End;
End;

Procedure Panel_Right_Released(Var Game : Type_Game);
Begin
  // Si le curseur est en mode ajout de locomotives.
  If (Game.Mouse.Mode = Type_Mouse_Mode.Add_Locomotive) Then
    Mouse_Line_Add_Train(Game)
    // Si le curseur est en mode ajout de wagons.
  Else If (Game.Mouse.Mode = Type_Mouse_Mode.Add_Wagon) Then
         Mouse_Train_Add_Wagon(Game)
         // Si le curseur est en mode ajout de stations.
  Else If (Game.Mouse.Mode = Type_Mouse_Mode.Line_Add_Station) Or (Game.Mouse.Mode = Type_Mouse_Mode.Line_Insert_Station) Then
         Mouse_Line_Add_Station(Game);
End;

Procedure Panel_Bottom_Released(Var Game : Type_Game);

Var i : Byte;
Begin
  For i := 0 To Game_Maximum_Lines_Number - 1 Do
    Begin
      If (Mouse_On_Object(Mouse_Get_Release_Position(Game), Game.Lines[i].Button.Position, Game.Lines[i].Button.Size, Game.Panel_Bottom)) Then
        Game.Lines[i].Button.State := Not(Game.Lines[i].Button.State)
      Else
        Game.Lines[i].Button.State := False;

    End;

End;

// Procédure qui gère les interractions avec la souris.
Procedure Mouse_Event_Handler(Mouse_Event : TSDL_MouseButtonEvent; Var Game : Type_Game);

Var i : Byte;
Begin
  If (Mouse_Event.Button = SDL_BUTTON_LEFT) Then
    Begin
      // Si la souris a été pressée,
      If (Mouse_Event.state = SDL_PRESSED) Then
        Begin
          // Mise à jour des attributs.
          Game.Mouse.State := True;
          Game.Mouse.Press_Position.X := Mouse_Event.x;
          Game.Mouse.Press_Position.Y := Mouse_Event.y;
        End
        // Si la souris a été relâchée,
      Else
        Begin
          // Mise à jour des attributs.
          Game.Mouse.State := False;
          Game.Mouse.Release_Position.X := Mouse_Event.x;
          Game.Mouse.Release_Position.Y := Mouse_Event.y;
        End;
    End;

  // Si la souris est pressée,
  If (Mouse_Is_Pressed(Game)) Then
    Begin
      Game.Mouse.Mode := Type_Mouse_Mode.Normal;

      // Si le panneau de récompenses n'est pas caché (on obstrue les appuis sur les autres panneaux).

      If Not(Game.Panel_Game_Over.Hidden) Then
        Begin
          If (Mouse_On_Panel(Mouse_Get_Press_Position(Game), Game.Panel_Game_Over)) Then
            Panel_Game_Over_Pressed(Game);
        End
      Else If Not(Game.Panel_Reward.Hidden) Then
        Begin
          // Si la pression de la souris se trouve dans le panneau de récompenses.
          If Mouse_On_Panel(Mouse_Get_Press_Position(Game), Game.Panel_Reward) Then
            Panel_Reward_Pressed(Game);
        End
        // Si la souris se trouve dans le panneau de gauche.
      Else If Mouse_On_Panel(Mouse_Get_Press_Position(Game), Game.Panel_Left) Then
             Begin
               Panel_Left_Pressed(Game);
             End
             // Si la souris se trouve sur le panneau de droite.
      Else If (Mouse_On_Panel(Mouse_Get_Press_Position(Game), Game.Panel_Right)) Then
             Panel_Right_Pressed(Game);

    End
    // Si la souris est relâchée.
  Else
    Begin

      // Vérifie si le panneau des récompenses n'est pas dissimulé.
      If Not(Game.Panel_Reward.Hidden) Then
        Begin

        End
        // Si il y a un clic dans le panneau du haut.
      Else If (Mouse_On_Panel(Mouse_Get_Release_Position(Game), Game.Panel_Top)) Then
             Panel_Top_Released(Game)

             // Si la souris se trouve sur le panneau de droite.
      Else If (Mouse_On_Panel(Mouse_Get_Release_Position(Game), Game.Panel_Right)) Then
             Panel_Right_Released(Game)

             // Si la souris se trouve dans le panneau du bas.
      Else If (Mouse_On_Panel(Mouse_Get_Release_Position(Game), Game.Panel_Bottom)) Then
             Panel_Bottom_Released(Game);

      Game.Mouse.Mode := Type_Mouse_Mode.Normal;

    End;
End;

End.
