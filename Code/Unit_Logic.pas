
Unit Unit_Logic;

Interface

// - Inclut les unités internes au projet. 

Uses Unit_Types, Unit_Common, Unit_Constants, Unit_Sounds, Unit_Graphics, sdl, Unit_Mouse, sysutils;

// - Déclaration des fonctions et procédures.

// - - Logique générale.
Procedure Logic_Load(Var Game : Type_Game);

Procedure Logic_Refresh(Var Game : Type_Game);

Implementation



// - Définition des fonctions et procédures.

// Fonction qui renvoie l'index absolu (dans le tableau de stations du jeu) d'une station à partir de son pointeur.
Function Station_Get_Absolute_Index(Station_Pointer : Type_Station_Pointer; Var Game : Type_Game) : Byte;

Var i : Byte;
Begin
  Station_Get_Absolute_Index := 255;

  For i := low(Game.Stations) To high(Game.Stations) Do
    Begin
      If Station_Pointer = Game.Stations[i] Then
        Begin
          Station_Get_Absolute_Index := i;
          break;
        End;
    End;
End;

// Procédure qui renvoie l'index absolu (dans le tableau de lignes du jeu) d'une ligne à partir de son pointeur.
Procedure Panel_Game_Over_Load(Var Game : Type_Game);
Begin

  Panel_Set_Hidden(False, Game.Panel_Game_Over);

  Game_Pause(Game);

  // - Etiquette de titre.
  Label_Set_Text(Game.Game_Over_Title_Label, 'Game Over !');
  Label_Pre_Render(Game.Game_Over_Title_Label);
  Game.Game_Over_Title_Label.Position.X := Get_Centered_Position(Game.Panel_Game_Over.Size.X, Game.Game_Over_Title_Label.Size.X);
  Game.Game_Over_Title_Label.Position.Y := 16;


  // - Ettiquette de message.
  Label_Set_Text(Game.Game_Over_Message_Label, 'You have lost the game !');
  Label_Pre_Render(Game.Game_Over_Message_Label);
  Game.Game_Over_Message_Label.Position.X := Get_Centered_Position(Game.Panel_Game_Over.Size.X, Game.Game_Over_Message_Label.Size.X);
  Game.Game_Over_Message_Label.Position.Y := Game.Game_Over_Title_Label.Position.Y + Game.Game_Over_Title_Label.Size.Y + 16;


  // - Etiquette de score
  Label_Set_Text(Game.Game_Over_Score_Label, 'Score : ' + IntToStr(Game.Player.Score));
  Label_Pre_Render(Game.Game_Over_Score_Label);
  Game.Game_Over_Score_Label.Position.X := Get_Centered_Position(Game.Panel_Game_Over.Size.X, Game.Game_Over_Score_Label.Size.X);
  Game.Game_Over_Score_Label.Position.Y := Game.Game_Over_Message_Label.Position.Y + Game.Game_Over_Message_Label.Size.Y + 16;
End;


// - - Fonctions et procédures relatives au passagers 

Procedure Panel_Reward_Load(Var Game : Type_Game);

Var Rewards : Array[0 .. 1] Of Byte;
  i : Byte;
  Random_Draw : Boolean;
Begin

  Panel_Set_Hidden(False, Game.Panel_Reward);

  Game_Pause(Game);

  // - Tirage au sort des récompenses.

  Repeat
    Random_Draw := true;

    // Tire au sort les deux récompenses.
    Rewards[0] := Random(4);
    Rewards[1] := Random(4);

    // Vérifie que deux récompense différentes ont été tirées.
    If (Rewards[0] = Rewards[1]) Then
      Begin
        // Si non, on refait le tirage.
        Random_Draw := false;
      End;

    // Si une ligne figure dans un des choix,
    If (Rewards[0] = 0) Or (Rewards[1] = 0) Then
      Begin
        // On vérifie que le nombre maximal de lignes n'a pas été dépassé.
        If (length(Game.Lines) >= Game_Maximum_Lines_Number) Then
          Begin
            // On refait le tirage le cas échéant.
            Random_Draw := false;
          End;
      End;
  Until Random_Draw = true;

  // - Définition de l'affichage des récompenses.

  // - - Affichage de la semaine.

  Label_Set_Text(Game.Reward_Title_Label, 'Week : ' + IntToStr(Time_Get_Elapsed(Game.Start_Time) Div (1000 * Game_Day_Duration * 7) + 1));
  Label_Pre_Render(Game.Reward_Title_Label);
  Game.Reward_Title_Label.Position.X := Get_Centered_Position(Game.Panel_Reward.Size.X, Game.Reward_Title_Label.Size.X);
  Game.Reward_Title_Label.Position.Y := 16;

  // - - Affichage du message.

  Label_Set_Text(Game.Reward_Message_Label, 'Choose your reward : ');
  Label_Pre_Render(Game.Reward_Message_Label);
  Game.Reward_Message_Label.Position.X := Get_Centered_Position(Game.Panel_Reward.Size.X, Game.Reward_Message_Label.Size.X);
  Game.Reward_Message_Label.Position.Y := Game.Reward_Title_Label.Position.Y + Game.Reward_Title_Label.Size.Y + 16;

  // - - Affichage des récompenses.

  For i := 0 To 1 Do
    Begin

      Case Rewards[i] Of 
        // - Ligne
        0 :
            Begin
              Label_Set_Text(Game.Reward_Labels[i], 'Line');
              Button_Set(Game.Reward_Buttons[i], Game.Ressources.Line_Add, Game.Ressources.Line_Add);
            End;
        // - Train
        1 :
            Begin
              Label_Set_Text(Game.Reward_Labels[i], 'Train');
              Button_Set(Game.Reward_Buttons[i], Game.Ressources.Train_Add, Game.Ressources.Train_Add);
            End;
        // - Wagon
        2 :
            Begin
              Label_Set_Text(Game.Reward_Labels[i], 'Wagon');
              Button_Set(Game.Reward_Buttons[i], Game.Ressources.Wagon_Add, Game.Ressources.Wagon_Add);
            End;
        // - Tunnel
        3 :
            Begin
              Label_Set_Text(Game.Reward_Labels[i], 'Tunnel');
              Button_Set(Game.Reward_Buttons[i], Game.Ressources.Tunnel_Add, Game.Ressources.Tunnel_Add);
            End;

      End;

      Label_Pre_Render(Game.Reward_Labels[i]);

    End;

  Game.Reward_Buttons[0].Position.X := Get_Centered_Position(Game.Panel_Reward.Size.X Div 2, Game.Reward_Buttons[0].Size.X);
  Game.Reward_Buttons[0].Position.Y := Game.Panel_Reward.Size.Y - 16 - Game.Reward_Buttons[0].Size.Y;

  Game.Reward_Buttons[1].Position.X := Get_Centered_Position(Game.Panel_Reward.Size.X Div 2, Game.Reward_Buttons[1].Size.X) + Game.Panel_Reward.Size.X Div 2;
  Game.Reward_Buttons[1].Position.Y := Game.Reward_Buttons[0].Position.Y;

  Game.Reward_Labels[0].Position.X := Get_Centered_Position(Game.Panel_Reward.Size.X Div 2, Game.Reward_Labels[0].Size.X);
  Game.Reward_Labels[0].Position.Y := Game.Reward_Buttons[0].Position.Y - 16 - Game.Reward_Labels[0].Size.Y;

  Game.Reward_Labels[1].Position.X := Get_Centered_Position(Game.Panel_Reward.Size.X Div 2, Game.Reward_Labels[1].Size.X) + Game.Panel_Reward.Size.X Div 2;
  Game.Reward_Labels[1].Position.Y := Game.Reward_Labels[0].Position.Y;



End;


Procedure Game_Refresh_Graph_Table(Var Game : Type_Game);

Var i, j : Byte;
  Indexes : Array[0 .. 1] Of Byte;
Begin

  // - Définit les dimensions de la Graph_Table
  SetLength(Game.Graph_Table, length(Game.Stations));

  For i := low(Game.Graph_Table) To high(Game.Graph_Table) Do
    Begin
      SetLength(Game.Graph_Table[i], length(Game.Stations));
      For j := low(Game.Graph_Table[i]) To high(Game.Graph_Table[i]) Do
        SetLength(Game.Graph_Table[i][j], 0);
    End;

  // - Remplissage la Graph_Table par rapport aux lignes du jeu.

  For i := low(Game.Lines) To high(Game.Lines) Do
    // Pour chacune des lignes :
    Begin
      // Vérifie que la ligne contient bien des stations.
      If (length(Game.Lines[i].Stations) > 0) Then
        Begin
          // Itère parmi les stations de la ligne.
          For j:= low(Game.Lines[i].Stations) To high(Game.Lines[i].Stations) - 1 Do
            // Pour chacune des stations consécutivement connectées contenues dans le tableau :
            Begin
              // Obtient les indexes des stations dans le tableau de stations du jeu.
              Indexes[0] := Station_Get_Absolute_Index(Game.Lines[i].Stations[j], Game);
              Indexes[1] := Station_Get_Absolute_Index(Game.Lines[i].Stations[j + 1], Game);

              // Ajoute une case au tableau de pointeurs des lignes des stations concernées.

              SetLength(Game.Graph_Table[Indexes[0]][Indexes[1]], length(Game.Graph_Table[Indexes[0]][Indexes[1]]) + 1);

              SetLength(Game.Graph_Table[Indexes[1]][Indexes[0]], length(Game.Graph_Table[Indexes[1]][Indexes[0]]) + 1);

              // A partir des indexes, on remplit la Graph_Table de manière symétrique en ajoutant les pointeur des lignes correspondantes.

              Game.Graph_Table[Indexes[0]][Indexes[1]][high(Game.Graph_Table[Indexes[0]][Indexes[1]])] := @Game.Lines[i];
              Game.Graph_Table[Indexes[1]][Indexes[0]][high(Game.Graph_Table[Indexes[1]][Indexes[0]])] := @Game.Lines[i];

            End;
        End;
    End;

End;

// Procédure qui inscrit dans le tableau de Dijkstra avec quelles stations une station donnée peut se connecter.
Procedure Connect_Stations(Step : Byte; indexStationToConnect : Byte; Game : Type_Game);

Var i, j : Byte;
Begin

  i := indexStationToConnect;

  For j := low(Game.Graph_Table[i]) To high(Game.Graph_Table[i]) Do
    Begin
      // Itère parmi les lignes reliant les deux stations.
      If (length(Game.Graph_Table[i][j]) > 0) Then
        Begin
          // Vérifie que Dijkstra n'a pas interdit de retourner sur cette case.
          If (Game.Dijkstra_Table[Step][j].isAvailable = True) Then
            Begin
              // Permet à Dijkstra de savoir s'il doit considérer cette station en particulier dans son calcul d'itinéraire.
              Game.Dijkstra_Table[Step][j].isConnected := True;
            End
          Else
            Game.Dijkstra_Table[Step][j].isConnected := False;
        End
      Else
        Game.Dijkstra_Table[Step][j].isConnected := False;
    End;
End;

// Procédure qui renvoie toutes les stations qui ont la même forme que le passager donné.
Procedure Get_Ending_Stations_From_Shape(Game : Type_Game; Passenger : Type_Passenger_Pointer; Var Index_Table : Type_Index_Table);

Var i : Byte;
Begin
  SetLength(Index_Table, 0);

  // Parcourt le tableau de stations du jeu.
  For i:= low(Game.Stations) To high(Game.Stations) Do
    Begin
      // Vérifie si la forme de la station contenue dans la case où on se trouve correspond à la forme du passager.
      If Game.Stations[i]^.Shape = Passenger^.Shape Then
        Begin
          // Si c'est le cas, on ajoute cette station au tableau de stations de la même forme que le passager.
          SetLength(Index_Table, length(Index_Table) + 1);
          Index_Table[high(Index_Table)] := i;
        End;
    End;
End;

// Fonction qui signale à l'algorithme de Dijkstra que le calcul d'itinéraire est arrivé à destination.
Function Destination_Reached(Index_Ending_Station : Byte; Dijkstra_Table : Type_Dijkstra_Table): Boolean;

Var i : Byte;
Begin
  Destination_Reached := false;

  // Itère parmi la première dimension du tableau de dijkstra
  For i := low(Dijkstra_Table) To high(Dijkstra_Table) Do
    Begin
      If (Dijkstra_Table[i][Index_Ending_Station].isValidated = true) Then
        Begin
          Destination_Reached := true;
          break;
        End;
    End;
End;

// Fonction qui calcule le poids d'un trajet entre deux stations connectées.
Function Get_Weight(Var Station_1, Station_2 : Type_Station): Integer;

Var Intermediate_Position : Type_Coordinates;
Begin
  // Détermine la position intermédiaire entre deux stations données.
  Intermediate_Position := Station_Get_Intermediate_Position(Station_1.Position_Centered, Station_2.Position_Centered);
  // Le poids du trajet pour aller d'une station 1 à une station 2 est égal à la distance séparant les deux stations.
  Get_Weight := Get_Distance(Station_1.Position_Centered, Intermediate_Position) + Get_Distance(Intermediate_Position, Station_2.Position_Centered);
End;

// Fonction qui calcule le poids (la distance) d'un itinéraire.
Function Itinerary_Get_Weight(Game : Type_Game; Itinerary_Indexes : Type_Itinerary_Indexes) : Integer;

Var i : Byte;
  Weight : Integer;

Begin
  // Initialise le poids de l'itinéraire à 0.
  Weight := 0;

  // Parcourt le tableau contenant les stations constituant l'itinéraire.
  For i := low(Itinerary_Indexes) + 1 To high(Itinerary_Indexes) Do
    Begin
      // Fait appel à Get_Weight pour calculer le poids du trajet entre deux stations consécutives dans le tableau.
      Weight := Weight + Get_Weight(Game.Stations[Itinerary_Indexes[i - 1]]^, Game.Stations[Itinerary_Indexes[i]]^);
    End;

  Itinerary_Get_Weight := Weight;

End;

Procedure Dijkstra(Starting_Station_Index : Integer; Ending_Station_Index : Integer; Var Itinerary_Indexes : Type_Itinerary_Indexes; Var Reverse_Itinerary_Indexes : Type_Itinerary_Indexes; Game :
                   Type_Game; Var Station_Is_Isolated : Boolean);

Var i, j, column, Step, Last_Step, lightest_Station_Step, Coming_From_Station_Index, lightest_Station_Index, Previous_Index : Byte;
  minimum_Weight, Validated_Itinerary_Weight : Real;


Begin

  SetLength(Reverse_Itinerary_Indexes, 0);
  SetLength(Itinerary_Indexes, 0);

  // - Initialisation de la table de Dijkstra.

  // Initialisation du poids total de l'itinéraire calculé par Dijkstra.
  Validated_Itinerary_Weight := 0;

  // Itère parmi les lignes du tableau de dijkstra.
  For Step := low(Game.Dijkstra_Table) To high(Game.Dijkstra_Table) Do
    Begin
      // Itère parmi les colonnes du tableau de dijkstra.
      For j := low(Game.Dijkstra_Table[Step]) To high(Game.Dijkstra_Table[Step]) Do
        Begin
          // Les cases sont mises comme toutes disponibles.
          Game.Dijkstra_Table[Step][j].isAvailable := True;
          Game.Dijkstra_Table[Step][j].isConnected := False;
          Game.Dijkstra_Table[Step][j].isValidated := False;
          Game.Dijkstra_Table[Step][j].Weight := 0;
          Game.Dijkstra_Table[Step][j].Coming_From_Station_Index := 255;
        End;

      Game.Dijkstra_Table[Step][Starting_Station_Index].isAvailable := False;
    End;

  Coming_From_Station_Index := Starting_Station_Index;

  // Met le poids de la station de départ à l'étape 0 à 0.
  Game.Dijkstra_Table[low(Game.Dijkstra_Table)][Starting_Station_Index].Weight := 0;

  // Définit la station de départ de l'étape 0 comme étant la station de départ (itinénaire complet).
  Game.Dijkstra_Table[low(Game.Dijkstra_Table)][Starting_Station_Index].Coming_From_Station_Index := Coming_From_Station_Index;

  // Met la station de départ comme étant validée (dans l'itinéraire final).
  Game.Dijkstra_Table[low(Game.Dijkstra_Table)][Starting_Station_Index].isValidated := True;

  Step := low(Game.Dijkstra_Table) ;

  // - Résolution de l'itinéraire.

  While ((Step <= (high(Game.Dijkstra_Table))) And (Destination_Reached(Ending_Station_Index, Game.Dijkstra_Table)=False)) Do
    Begin

      // Connecte dans la Dijkstra_Table les stations qui sont reliées.
      Connect_Stations(Step, Coming_From_Station_Index, Game);

      For i := (low(Game.Dijkstra_Table[Step])) To (high(Game.Dijkstra_Table[Step])) Do
        Begin
          // Si la station est libre, connectée et non validée,
          If (Game.Dijkstra_Table[Step][i].isAvailable = True) And (Game.Dijkstra_Table[Step][i].isConnected = True) And (Game.Dijkstra_Table[Step][i].isValidated = False) Then
            Begin
              // Définit de quelle station on est parti pour atteindre la station actuelle.
              Game.Dijkstra_Table[Step][i].Coming_From_Station_Index := Coming_From_Station_Index;
              // Effectue le calcul de poids.
              Game.Dijkstra_Table[Step][i].Weight := Validated_Itinerary_Weight + Get_Weight(Game.Stations[Game.Dijkstra_Table[Step][i].Coming_From_Station_Index]^, Game.Stations[i]^);
              //!\\ Attention : Manipule directement la station, pas le pointeur.
            End;
        End;

      // - Compare et détermine l'index de la station dont le poids est le plus faible.

      // Initialise la variable stockant le poids le plus faible.
      minimum_Weight := 0;

      // Itère parmi les étapes (lignes) de la Dijkstra_Table.
      For i := low(Game.Dijkstra_Table) To Step Do
        Begin
          // Itère parmi les colonnes (stations) de la Dijkstra_Table.
          For column:= (low(Game.Dijkstra_Table[i])) To (high(Game.Dijkstra_Table[i])) Do
            Begin
              // Si la station est connectée, validée et libre,
              If (Game.Dijkstra_Table[i][column].isConnected = True) And (Game.Dijkstra_Table[Step][column].isValidated = False) And (Game.Dijkstra_Table[Step][column].isAvailable = True) Then
                Begin
                  If (minimum_Weight = 0) Then
                    // Si minimum_Weight est toujours égal à la valeur à laquelle on l'a initialisé, on lui attribue la valeur du poids de la station à laquelle on se trouve.
                    Begin
                      minimum_Weight := Game.Dijkstra_Table[i][column].weight;
                      lightest_Station_Index := column;
                      lightest_Station_Step := i;
                    End

                  Else If (Game.Dijkstra_Table[i][column].weight < minimum_Weight) Then


// Si minimum_Weight n'est pas nul, on compare la valeur du poids de la station où l'on se trouve à la valeur de minimum_Weight. Si il est plus petit que minimum_Weight, alors minimum_Weight prend la valeur de ce poids.
                         Begin
                           minimum_Weight := Game.Dijkstra_Table[i][column].weight;
                           lightest_Station_Index := column;
                           // Récupère l'indice de la station au plus petit poids.
                           lightest_Station_Step := i;
                         End;

                End;
            End;
        End;

      // Si toute la Dijkstra_Table a été parcourue et que la destination n'est pas atteinte, alors il n'y a pas de trajet. La station est isolée.
      If (Step = high(Game.Dijkstra_Table)) And Not(Destination_Reached(Ending_Station_Index, Game.Dijkstra_Table)) Then
        Begin
          Station_Is_Isolated := True;
        End
      Else
        Begin
          Station_Is_Isolated := False;
          Game.Dijkstra_Table[Step+1][lightest_Station_Index] := Game.Dijkstra_Table[lightest_Station_Step][lightest_Station_Index];
          Game.Dijkstra_Table[Step+1][lightest_Station_Index].isValidated := True;
          Validated_Itinerary_Weight := Game.Dijkstra_Table[lightest_Station_Step][lightest_Station_Index].weight;
        End;

      // - Met à jour les stations disponibles.

      // Itère parmi les lignes de la Dijkstra_Table
      For i:= low(Game.Dijkstra_Table) To high(Game.Dijkstra_Table) Do
        Begin
          // Met toutes les cases de la colonne de la station qu'on vient de valider comme étant indisponibles.
          Game.Dijkstra_Table[i][lightest_Station_Index].isAvailable := False;
        End;

      Coming_From_Station_Index := lightest_Station_Index;

      // L'étape est finie, on peut passer à l'étape suivante.
      Step := Step + 1;
      If Step-1 = high(Game.Dijkstra_Table) Then
        Last_Step := Step-1
      Else
        Last_Step := Step;
    End;

  //- Effectue une remontée pour récupérer toutes les stations de l'itinéraire.

  // Remplit la première case du tableau de l'itinéraire inversé avec la station de destination (inversé car récupéré avec une remontée).
  SetLength(Reverse_Itinerary_Indexes, 1);
  Reverse_Itinerary_Indexes[high(Reverse_Itinerary_Indexes)] := Ending_Station_Index;

  // Parcourt toutes les cases de l'étape afin de déterminer la case validée et de récupérer son Coming_From_Station_Index.
  For j := low(Game.Dijkstra_Table) To high(Game.Dijkstra_Table) Do
    Begin
      If Game.Dijkstra_Table[Last_Step][j].isValidated Then
        Begin
          Previous_Index := Game.Dijkstra_Table[Last_Step][j].Coming_From_Station_Index;
        End;
    End;

  // Remplit le reste du tableau avec les Previous_Index récupérés à l'étape précédente.
  If (Previous_Index <> Starting_Station_Index) Then
    Begin
      Repeat
        // Rajoute une case a Rverse_Itinerary_Indexes.
        SetLength(Reverse_Itinerary_Indexes, length(Reverse_Itinerary_Indexes) + 1);
        Reverse_Itinerary_Indexes[high(Reverse_Itinerary_Indexes)] := Previous_Index;
        // Prévention d'un bug.
        If Previous_Index = 255 Then
          Begin
            Previous_Index := Starting_Station_Index;
            Reverse_Itinerary_Indexes[high(Reverse_Itinerary_Indexes)] := Starting_Station_Index;
            Step := 0;
            Break;
          End;

        Previous_Index := Game.Dijkstra_Table[Last_Step - high(Reverse_Itinerary_Indexes)][Previous_Index].Coming_From_Station_Index;

      Until Reverse_Itinerary_Indexes[high(Reverse_Itinerary_Indexes)] = Starting_Station_Index;
    End;

  // Set la taille du tableau d'itinéraire (tableau stocké dans le passager) à la même taille que le tableau inversé de l'itinéraire.
  SetLength(Itinerary_Indexes, length(Reverse_Itinerary_Indexes));

  //Inverse le tableau inversé pour obtenir l'itinéaire dans le bon sens.
  For i:= high(Reverse_Itinerary_Indexes) Downto low(Reverse_Itinerary_Indexes) Do
    Begin
      Itinerary_Indexes[high(Reverse_Itinerary_Indexes)-i] := Reverse_Itinerary_Indexes[i];
    End;
End;


// Procédure qui calcule l'itinéaire des stations correspondant à la forme du passager, puis détermine la plus "proche" en prenant l'itinéraire le plus court.
Procedure Passengers_Compute_Itinerary(Game : Type_Game);

Var i,j,k,l, m : Byte;
  Index_Table_Of_Same_Shape, Itinerary_Indexes, Reverse_Itinerary_Indexes : Type_Itinerary_Indexes;
  Lowest_Weight : Integer;
  Shortest_Itinerary_Indexes : Type_Itinerary_Indexes;
  Station_Is_Isolated : Boolean;

Begin
  // Itère parmi les stations du jeu.
  For i:= low(Game.Stations) To high(Game.Stations) Do
    // Parcourt toutes les stations pour ensuite parcourir les passagers contenus dans ces stations.
    Begin
      // Si la station contient des passagers,
      If (length(Game.Stations[i]^.Passengers) > 0) Then
        Begin
          // Itère parmi les passagers d'une station.
          For j:= low(Game.Stations[i]^.passengers) To high(Game.Stations[i]^.passengers) Do
            // Parcourt les passagers de la station
            Begin
              // Détermine les stations de destination possibles pour un passager (stations ayant la même forme que le passager).
              Get_Ending_Stations_From_Shape(Game, Game.Stations[i]^.Passengers[j], Index_Table_Of_Same_Shape);

              // Parcourt le tableau contenant les destinations possibles pour le passager.
              For k := low(Index_Table_Of_Same_Shape) To high(Index_Table_Of_Same_Shape) Do
                Begin
                  // Appelle Dijkstra pour calculer le trajet le plus court pour se rendre à la destination sélectionnée dans le tableau.
                  Dijkstra(i, Index_Table_Of_Same_Shape[k], Itinerary_Indexes, Reverse_Itinerary_Indexes, Game, Station_Is_Isolated);

                  // Si on se trouve à la première case du tableau de destinations,
                  If k = low(Index_Table_Of_Same_Shape) Then
                    // Considère par défaut le trajet menant à cette destination comme le trajet le plus court pour le moment.
                    Begin
                      Lowest_Weight := Itinerary_Get_Weight(Game, Itinerary_Indexes);
                      Shortest_Itinerary_Indexes := copy(Itinerary_Indexes, low(Itinerary_Indexes), length(Itinerary_Indexes));
                    End

                    // Si on se trouve à une autre case du tableau de destinations.
                  Else If (Itinerary_Get_Weight(Game, Itinerary_Indexes) < Lowest_Weight) Then


                        // Compare le poids du trajet menant à la destination contenue dans la case où on se trouve au plus petit poids trouvé jusqu'à présent. Si ce poids est plus petit, on le considère comme le plus petit poids.
                         Begin
                           Lowest_Weight := Itinerary_Get_Weight(Game, Itinerary_Indexes);
                           // Copie l'itinéraire au plus petit poids dans l'itinéraire le plus court.
                           SetLength(Shortest_Itinerary_Indexes, length(Itinerary_Indexes));
                           Shortest_Itinerary_Indexes := copy(Itinerary_Indexes, low(Itinerary_Indexes), length(Itinerary_Indexes));
                           For m := low(Itinerary_Indexes) To high(Itinerary_Indexes) Do
                             Begin
                               Shortest_Itinerary_Indexes[m] := Itinerary_Indexes[m];
                             End;

                         End;

                End;

              // - Conversion de l'itinéraire en pointeurs de stations.

              SetLength(Game.Stations[i]^.Passengers[j]^.Itinerary, 1);

              For l := low(Shortest_Itinerary_Indexes) To high(Shortest_Itinerary_Indexes) Do
                Begin
                  Game.Stations[i]^.Passengers[j]^.Itinerary[l] := Game.Stations[Shortest_Itinerary_Indexes[l]];
                  SetLength(Game.Stations[i]^.Passengers[j]^.Itinerary, length(Game.Stations[i]^.Passengers[j]^.Itinerary)+1);
                End;
              SetLength(Game.Stations[i]^.Passengers[j]^.Itinerary, length(Game.Stations[i]^.Passengers[j]^.Itinerary)-1);

            End;
        End;
    End;
End;

// Fonction qui détermine si le passager doit descendre du train (autrement dit, si il a atteint sa destination).
Function Passenger_Get_Off(Passenger : Type_Passenger_Pointer; Var Next_Station : Type_Station; Var Current_Station : Type_Station) : Boolean;

Var i : Byte;

Begin
  Passenger_Get_Off := True;
writeln('!!!! Entrée dans Get_Off !!!!');
writeln('Ma CurrentStation = ', Current_Station.Shape);
writeln('Ma NextStation = ', Next_Station.Shape);
// Parcourt le tableau contenant l'itinéraire du passager.
for i := low(Passenger^.Itinerary) to high(Passenger^.Itinerary) do
  begin
    // Se localise dans son propre itinéraire et vérfie si il correspond à la station actuelle ou à la prochaine station (le second cas étant dans le scénario où l'itinéraire ne fait qu'une étape (la prochaine station)).
    if (Passenger^.Itinerary[i] = @Current_Station) or (Passenger^.Itinerary[i] = @Next_Station) then
      begin
        // Si la prochaine station du train correspond à la prochaine étape de l'itinéraire du passager.
        if @Next_Station = Passenger^.Itinerary[i+1] then
          begin
            // Le passager ne descend pas.
            Passenger_Get_Off := False;
            writeln(' Je ne vais pas descendre car Passenger^.Itinerary[i+1] = ', Passenger^.Itinerary[i+1]^.Shape, ' et Next_Station = ',Next_Station.Shape);
          end
        //Cas de l'itinéraire à une seule étape. Vérifie si l'unique étape de l'itinéraire correspond à la prochaine station du train,
        else if (@Next_Station = Passenger^.Itinerary[i]) and (length(Passenger^.Itinerary)< 2) then // le < 2 est pour s'assurer qu'on utilise cette condition uniquement dans le cas d'un itinéraire d'une seule étape.
          begin
            //Le passager ne descend pas.
            Passenger_Get_Off := False;
            writeln(' Je ne vais pas descendre car Passenger^.Itinerary[i] = ', Passenger^.Itinerary[i]^.Shape, ' et Next_Station = ', Next_Station.Shape);
          end;
      end;
  end;
end;
// Parcourt le tableau contenant l'itinéraire du passager et vérifie si la prochaine station du train correspond à la prochaine station dans l'itinéraire du passager.
{for i := low(Passenger^.Itinerary) to high(Passenger^.Itinerary) do
  begin
    if @Next_Station = Passenger^.Itinerary[i] then
      begin
        Passenger_Get_Off := False;
      end;
  end;
end;}

// Fonction qui détermine si le passager doit monter dans un train.
Function Passenger_Get_On(Passenger : Type_Passenger_Pointer; Var Next_Station : Type_Station; Var Current_Station : Type_Station) : Boolean;

Var i : Byte;
Begin
  writeln('====================================');

      writeln(' Passenger shape : ', Passenger^.Shape);
      writeln('Next station shape = ', Next_Station.Shape);
     
      Passenger_Get_On := False;
      writeln('Ma CurrentStation = ', Current_Station.Shape);
      writeln('Ma NextStation = ', Next_Station.Shape);
      // Parcourt le tableau contenant l'itinéraire du passager.
      for i := low(Passenger^.Itinerary) to high(Passenger^.Itinerary) do
        begin
          // Se localise dans son propre itinéraire et vérfie si il correspond à la station actuelle ou à la prochaine station (le second cas étant dans le scénario où l'itinéraire ne fait qu'une étape (la prochaine station)).
          if (Passenger^.Itinerary[i] = @Current_Station) or (Passenger^.Itinerary[i] = @Next_Station) then
            begin
              // Si la prochaine station du train correspond à la prochaine station dans l'itinéraire du passager,
              if @Next_Station = Passenger^.Itinerary[i+1] then
                begin
                  // Le passager monte dans le train.
                  Passenger_Get_On := True;
                  writeln(' Je monte car Passenger^.Itinerary[i+1] = ', Passenger^.Itinerary[i+1]^.Shape, ' et Next_Station = ',Next_Station.Shape);
                end
              // Cas de l'itinéraire à une seule étape. Vérifie que l'unique étape de l'itinéraire correspond à la prochaine station du train,
              else if (@Next_Station = Passenger^.Itinerary[i]) and (length(Passenger^.Itinerary)< 2) then
                begin
                  // Le passager monte dans le train.
                  Passenger_Get_On := True;
                  writeln(' Je monte car Passenger^.Itinerary[i] = ', Passenger^.Itinerary[i]^.Shape, ' et Next_Station = ',Next_Station.Shape);
                end;
            end;
        end;
      
      // Parcourt le tableau contenant l'itinéraire du passager et vérifie si la prochaine station du train correspond à la prochaine station dans l'itinéraire du passager.
      {for i := low(Passenger^.Itinerary) to high(Passenger^.Itinerary) do
        begin
          if @Next_Station = Passenger^.Itinerary[i] then
            begin
              Passenger_Get_On := True;
            end;
        end;}




{// Vérifie si la prochaine station du train correspond à la prochaine station dans l'itinéraire du passager.
      if Passenger^.Itinerary[low(Passenger^.itinerary)+1] = @Next_Station then
      begin
        Passenger_Get_On := True;
      end
      else if Passenger^.Itinerary[low(Passenger^.itinerary)] = @Next_Station then
      begin
        Passenger_Get_On := True;
      end
      else
      begin
        Passenger_Get_On := False;
      end;}

  For i := low(Passenger^.itinerary) To high(Passenger^.Itinerary) Do
    Begin
      writeln(' Itinerary : ', Passenger^.Itinerary[i]^.Shape);
    End;
End;

// - - Fonctions et procédures relatives à la logique générale.

// Procédure qui charge la logique.
Procedure Logic_Load(Var Game : Type_Game);
Begin

  Randomize();

  Graphics_Load(Game);

  Sounds_Load(Game);
  Sounds_Play(Game.Ressources.Music);
  Sounds_Set_Volume(Sounds_Maximum_Volume);

  Game_Load(Game);


  Mouse_Load(Game.Mouse);

End;

// Procédure qui décharge la logique en libérant la mémoire des objets alloués.
Procedure Logic_Unload(Var Game : Type_Game);
Begin
  Graphics_Unload(Game);

  Sounds_Unload(Game);

  Game_Unload(Game);


  // Pas besoin de supprimer les autres objets, ils seront automatiquement détruits lors de la suppression de l'objet Game.

  // Fermeture de la SDL.
  SDL_Quit();
End;

Procedure Logic_Event_Handler(Var Game : Type_Game);

Var Event : TSDL_Event;
Begin
  // Vérifie les événements.
  While (SDL_PollEvent(@Event) > 0) Do
    Begin
      // Si l'utilisateur demande la fermeture du programme.
      Case Event.type_ Of 
        // Si la fenêtre est fermée.
        SDL_QUITEV :
                     Begin
                       Logic_Unload(Game);
                       HALT();
                     End;
        SDL_MOUSEBUTTONDOWN, SDL_MOUSEBUTTONUP :
                                                 Mouse_Event_Handler(Event.button, Game);
      End;

    End;
End;


// Fonction qui effectue la correspondance du train arrivé à quai et change les attributs du train pour sa prochaine destination.
Procedure Train_Connection(Var Line : Type_Line; Var Train : Type_Train; Var Game : Type_Game);

Var i, j, k : Byte;
  Passengers_Queue : Array Of Type_Passenger_Pointer;
  Maximum_Distance : Integer;
Begin
  // Pour faire disparaître l'avertissement.
  SetLength(Passengers_Queue, 0);

  // La station d'arrivée devient la station de départ.
  Train.Last_Station := Train.Next_Station;
  // Réinitialisation de la distance.
  Train.Distance := 0;

  // - Détermination de la prochaine station du train.

  // Parcourt toutes les stations de la ligne du train.
  For i := low(Line.Stations) To high(Line.Stations) Do
    Begin
      // Cherche la station actuelle du train dans les stations d'une ligne.
      If (Train.Last_Station = Line.Stations[i]) Then
        Begin
          // Si la station est la dernière ou la première station d'une ligne.
          If ((i = high(Line.Stations)) Or (i = low(Line.Stations))) Then
            // On inverse la direction.
            Train.Direction := Not(Train.Direction);

          // Si le train est dans le sens direct (index des stations croissant).
          If (Train.Direction = true) Then
            Begin
              Train.Next_Station := Line.Stations[i + 1];
              // Calcul du point intermédiaire.
              Train.Intermediate_Position := Station_Get_Intermediate_Position(Train.Last_Station^.Position_Centered, Train.Next_Station^.Position_Centered);

            End
            // Si le train est dans le sens indirect (index des stations décroissant).
          Else
            Begin
              Train.Next_Station := Line.Stations[i - 1];
              // Calcul du point intermédiaire.
              Train.Intermediate_Position := Station_Get_Intermediate_Position(Train.Next_Station^.Position_Centered, Train.Last_Station^.Position_Centered);
            End;
          // On quitte la boucle.
          Break;
        End;
    End;


  // Calcul de la distance du point intermédiaire.
  Train.Intermediate_Position_Distance := Get_Distance(Train.Last_Station^.Position_Centered, Train.Intermediate_Position);


  // - Déchargement des passagers du train.

  // Itère parmi les véhicules du train.
  For i := low(Train.Vehicles) To high(Train.Vehicles) Do
    Begin
      // Déchargement des passagers qui doivent descendre du train dans le tampon.
      For j := 0 To Vehicle_Maximum_Passengers_Number - 1 Do
        Begin
          If (Train.Vehicles[i].Passengers[j] <> Nil) Then
            Begin
              // Suppression des passagers arrivés à destination.
              If (Train.Vehicles[i].Passengers[j]^.Shape = Train.Last_Station^.Shape) Then
                Begin
                  Passenger_Delete(Train.Vehicles[i].Passengers[j]);
                  // Incrémentation du score.
                  Game.Player.Score := Game.Player.Score + 1;
                  // Mise à jour de l'étiquette.
                  Label_Set_Text(Game.Score_Label, IntToStr(Game.Player.Score));
                End
                // Si le passager doit descendre du train, son pointeur est déplacé dans le tampon.
              Else If (Passenger_Get_Off(Train.Vehicles[i].Passengers[j], Train.Next_Station^, Train.Last_Station^)) Then
                     Begin
                       // Copie du pointeur du passager dans le tampon.
                       SetLength(Passengers_Queue, length(Passengers_Queue) + 1);
                       Passengers_Queue[high(Passengers_Queue)] := Train.Vehicles[i].Passengers[j];
                       // Réinitialisation du pointeur du passager dans le train.
                       Train.Vehicles[i].Passengers[j] := Nil;
                     End;
            End;
        End;
    End;

  // - Chargement des passagers de la station dans le train.

  // Itère parmi les véhicules d'un train.
  For i := low(Train.Vehicles) To high(Train.Vehicles) Do
    Begin
      // Itère parmi les places du véhicule.
      For j := 0 To Vehicle_Maximum_Passengers_Number - 1 Do
        Begin
          // Le pointeur (donc la place) est vide.
          If (Train.Vehicles[i].Passengers[j] = Nil) Then
            Begin
              // Vérifie si la station contient des passagers.
              If (length(Train.Last_Station^.Passengers) > 0) Then
                Begin
                  For k := low(Train.Last_Station^.Passengers) To high(Train.Last_Station^.Passengers) Do
                    Begin
                      // Si le passager doit monter dans le train, son pointeur est déplacé dans le train.
                      If (Passenger_Get_On(Train.Last_Station^.Passengers[k], Train.Next_Station^, Train.Last_Station^)) Then
                        Begin
                          // Copie du pointeur du passager dans le train.
                          Train.Vehicles[i].Passengers[j] := Train.Last_Station^.Passengers[k];
                          writeln('Le passager ', Train.Last_Station^.Passengers[k]^.Shape, ' est monté dans le train');
                          // Suppression du pointeur du passager de la station.
                          delete(Train.Last_Station^.Passengers, k, 1);
                          // On quitte la boucle.
                          Break;
                        End;
                    End;
                End;
            End;
        End;
    End;

  // Déchargement de la queue dans la station.
  If (Length(Passengers_Queue) > 0) Then
    Begin
      For i := low(Passengers_Queue) To high(Passengers_Queue) Do
        Begin
          // Ajout d'une place dans le tableau des passagers de la station.
          SetLength(Train.Last_Station^.Passengers, length(Train.Last_Station^.Passengers) + 1);
          // Déplacement du pointeur du passager dans la station.
          Train.Last_Station^.Passengers[high(Train.Last_Station^.Passengers)] := Passengers_Queue[i];
        End;
    End;

  Train_Refresh_Label(Train);

  // Désallocation de la queue.
  SetLength(Passengers_Queue, 0);

  Train.Start_Time := Time_Get_Current();


  // Calcul de la distance entre la station de départ et la station d'arrivée.

  Maximum_Distance := Get_Distance(Train.Last_Station^.Position_Centered, Train.Intermediate_Position) + Get_Distance(Train.Intermediate_Position, Train.Next_Station^.Position_Centered);


  Train.Deceleration_Time := ((Maximum_Distance - (Train_Acceleration_Time * Train_Maximum_Speed)) / Train_Maximum_Speed) + Train_Acceleration_Time;



  // Le train peut repartir.
  Train.Driving := true;
End;

// Rafraîchissement de la logique.
Procedure Logic_Refresh(Var Game : Type_Game);

Var i, j : Integer;
Begin

  // Si il faut rafraichrir la logique et que la partie n'est pas en pause.
  If (Game.Logic_Timer < Time_Get_Current) And (Game.Play_Pause_Button.State = true) Then
    Begin
      // Vérifie si le jour affiché est différent du jour actuel.
      If (Time_Index_To_Day(byte((Time_Get_Elapsed(Game.Start_Time) Div (1000 * Game_Day_Duration)) Mod 7)) <> Game.Day) Then
        Begin
          // Mise à jour de la variable du jour.
          Game.Day := Time_Index_To_Day(byte((Time_Get_Elapsed(Game.Start_Time) Div (1000 * Game_Day_Duration)) Mod 7));
          // Mise à jour de l'étiquette du jour.
          Label_Set_Text(Game.Clock_Label, Day_To_String(Game.Day));
          If (Game.Day = Day_Sunday) Then
            Panel_Reward_Load(Game);
        End;

      // Si le timer de génération de passagers a été dépassé.
      If (Game.Passengers_Timer < Time_Get_Current()) Then
        Begin
          // Génération aléatoire des passagers.
          // Vérifie si il y a bien des stations dans une partie.
          If (length(Game.Stations) > 0) Then
            Begin

              // Création d'un passager sur une station choisie aléatoirement.
              Passenger_Create(Game.Stations[Random(high(Game.Stations)) + 1]^, Game);

              // Détermination du prochain intervalle de temps avant la génération d'un nouveau passager.
              Game.Passengers_Timer := Time_Get_Current() + round((exp(-2 * (Time_Get_Elapsed(Game.Start_Time) / (1000 * 60 * 60)) + 1) * 1000));

            End;
        End;

      // Si le timer de génération de stations a été dépassé.
      If (Game.Stations_Timer < Time_Get_Current()) Then
        Begin
          // Génération aléatoire d'une station.
          // Vérifie si il y a bien des stations dans une partie.

          Station_Create(Game);

          Game.Stations_Timer := Time_Get_Current() + 25000;
        End;


      // - Reconstruction de la Graph_Table.

      If Game.Refresh_Graph_Table Then
        Begin
          Game_Refresh_Graph_Table(Game);
          Game.Refresh_Graph_Table := false;
        End;

      // - Calcul des itinéraires des passagers.

      If Game.Itinerary_Refresh Then
        Begin
          // Calcul des itinéraires des passagers.
          Passengers_Compute_Itinerary(Game);
          Game.Itinerary_Refresh := False;
        End;


      // - Gestion des trains arrivés à quai.

      // Vérifie qu'il existe une ligne.
      If (length(Game.Lines) > 0) Then
        Begin
          // Itère parmi les lignes.
          For i := low(Game.Lines) To high(Game.Lines) Do
            Begin
              // Itère parmi les trains.
              For j := low(Game.Lines[i].Trains) To high(Game.Lines[i].Trains) Do
                Begin
                  // Si le train est arrivé à quai.
                  If (Game.Lines[i].Trains[j].Driving = false) Then
                    Begin
                      // Effectue la correspondance du train arrivé à quai.
                      Train_Connection(Game.Lines[i], Game.Lines[i].Trains[j], Game);
                    End;
                End;
            End;
        End;

      // - Vérification de l'encombrement des stations.

      // Itère parmi les stations.
      For i := low(Game.Stations) To high(Game.Stations) Do
        Begin
          // Si la station est surchargée.
          If (length(Game.Stations[i]^.Passengers) > Station_Overfill_Passengers_Number) Then
            Begin
              // Si la station n'est pas encombrée avant la dernière vérification.
              If (Game.Stations[i]^.Overfill_Timer = 0) Then
                // On démarre le timer de la station.
                Game.Stations[i]^.Overfill_Timer := Time_Get_Current()
                                                    // Si la station était encombrée avant la dernière vérification et que son timer est dépassé.
              Else If (Time_Get_Elapsed(Game.Stations[i]^.Overfill_Timer) > Station_Overfill_Timer * 1000) Then
                     // La partie est terminée.
                    Panel_Game_Over_Load(Game);
              // TODO : Faire écran de game over.
            End
          Else
            Game.Stations[i]^.Overfill_Timer := 0;
        End;
      Game.Logic_Timer := Time_Get_Current() + 200;
    End
    // Si tout a été rafraîchi.
    // Si il faut rafraîchir les graphismes,
  Else If (Game.Graphics_Timer < Time_Get_Current()) Then
         Begin
           Graphics_Refresh(Game);
           Logic_Event_Handler(Game);
           Game.Graphics_Timer := Time_Get_Current() + (1000 Div 60);
         End
  Else
    // Mise en pause du jeu.
    SDL_Delay(10);

End;


End.
