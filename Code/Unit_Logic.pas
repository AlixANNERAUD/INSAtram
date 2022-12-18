
Unit Unit_Logic;

Interface

// - Inclut les unités internes au projet. 

Uses Unit_Types, Unit_Common, Unit_Constants, Unit_Sounds, Unit_Graphics, sdl, Unit_Mouse, sysutils;

// - Déclaration des fonctions et procédures.

// - - Logique générale.
Procedure Logic_Load(Var Game : Type_Game);

Procedure Logic_Unload(Var Game : Type_Game);

Procedure Logic_Refresh(Var Game : Type_Game);

Procedure Train_Connection(Var Line : Type_Line; Var Train : Type_Train; Var Game : Type_Game);

Function Passenger_Get_Off(Passenger : Type_Passenger_Pointer; Var Current_Station : Type_Station) : Boolean;

Function Passenger_Get_On(Passenger : Type_Passenger_Pointer; Var Next_Station : Type_Station) : Boolean;

Procedure Logic_Event_Handler(Var Game : Type_Game);

Procedure Logic_Rewards(Var Game : Type_Game);

// - Définition des fonctions et des procédures.

Implementation



// - - Fonctions et procédures relatives au passagers 

Procedure Logic_Rewards(Var Game : Type_Game);
Begin




{
  Panel_Set_Hidden(Game.Panel_Reward, True);

  Label_Set_Text('Week : ' + IntToStr(Time_Get_Elapsed(Game.Start_Time) Div (1000 * Game_Day_Duration * 7)), Game.Title_Label));

  Label_Set_Text('Choose your reward : ', Game.Message_Label);




  Panel_Set_Hidden(Game.Panel_Reward, True);
}
End;



Function Station_Get_Pointer_From_Absolute_Index(Inndex : Integer; Stations : Array Of Type_Station_Pointer) : Type_Station_Pointer;
Begin
  Station_Get_Pointer_From_Absolute_Index := @Stations[Inndex];
End;

Procedure Game_Refresh_Graph_Table(Var Game : Type_Game);

Var i, j, k : Byte;
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
          // Itère parmis les stations de la ligne.
          For j:= low(Game.Lines[i].Stations) To high(Game.Lines[i].Stations) - 1 Do
            // Pour chacune des stations consécutivement connectées contenues dans le tableau :
            Begin
              // Obtient les indexes des stations dans le tableau de stations du jeu.
              Indexes[0] := Station_Get_Absolute_Index(Game.Lines[i].Stations[j], Game);
              Indexes[1] := Station_Get_Absolute_Index(Game.Lines[i].Stations[j + 1], Game);

              // Ajoute une case au tableau de pointeurs des lignes des stations concernées.

              SetLength(Game.Graph_Table[Indexes[0]][Indexes[1]], length(Game.Graph_Table[Indexes[0]][Indexes[1]]) + 1);

              SetLength(Game.Graph_Table[Indexes[1]][Indexes[0]], length(Game.Graph_Table[Indexes[1]][Indexes[0]]) + 1);

              // A partir des indexes, on remplit Graph_Table de manière symétrique en ajoutant les pointeur des lignes corrspondantes.

              Game.Graph_Table[Indexes[0]][Indexes[1]][high(Game.Graph_Table[Indexes[0]][Indexes[1]])] := @Game.Lines[i];
              Game.Graph_Table[Indexes[1]][Indexes[0]][high(Game.Graph_Table[Indexes[1]][Indexes[0]])] := @Game.Lines[i];

            End;
        End;
    End;

End;

// Procédure qui inscrit dans le tableau de Dijkstra avec quels stations une station donnée peut se connecter.
Procedure Connect_Stations(Step : Byte; indexStationToConnect : Integer; Game : Type_Game);
// TypeGraphTable plutot que Type_Line parce que dans chaque case il y aura une record avec plusieurs lignes + la station avec laquelle la premiere station est reliée

Var i, j : Integer;
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
              writeln('Les stations d''index numero ',i,' et de numero ',j,' sont connectées');
            End
          Else
            // ! : Ligne rajoutée, à vérifier par HUGO.
            Game.Dijkstra_Table[Step][j].isConnected := False;
        End
      Else
        Game.Dijkstra_Table[Step][j].isConnected := False;
    End;
End;

// Procédure qui renvoie toute les stations qui ont la même forme que le passager donné.
Procedure Get_Ending_Stations_From_Shape(Game : Type_Game; Passenger : Type_Passenger_Pointer; Var Index_Table : Type_Index_Table);

Var i, counter : Integer;
Begin
  SetLength(Index_Table, 0);

  For i:= low(Game.Stations) To high(Game.Stations) Do
    Begin

      If Game.Stations[i].Shape = Passenger^.Shape Then
        Begin

          SetLength(Index_Table, length(Index_Table) + 1);
          Index_Table[high(Index_Table)] := i;

        End;
    End;
End;

// Fonction qui signale à l'algorithme de Dijkstra que le calcul d'itinéraire est arrivé à destination.
Function Destination_Reached(Index_Ending_Station : Integer; Dijkstra_Table : Type_Dijkstra_Table): Boolean;

Var i : Integer;
Begin
  Destination_Reached := false;
  // Itère parmis la première dimension du tableau de dijkstra
  For i := low(Dijkstra_Table) To high(Dijkstra_Table) Do
    // En cas de soucis, on peut utiliser high(Game.Stations) qui lui représente un tableau à une dimension.
    Begin
      If (Dijkstra_Table[i][Index_Ending_Station].isValidated = true) Then
        Begin
          Destination_Reached := true;
          break;
        End;
    End;
End;

Function Get_Weight(Var Station_1, Station_2 : Type_Station): Integer;
// pas besoin de la graph table qui donne des infos sur les lignes uniquement, et deux lignes qui desservent la meme station ont la meme longueur (elles sont parallèles)

Var Intermediate_Position : Type_Coordinates;
Begin

  Intermediate_Position := Station_Get_Intermediate_Position(Station_1.Position_Centered, Station_2.Position_Centered);

  Get_Weight := Get_Distance(Station_1.Position_Centered, Intermediate_Position) + Get_Distance(Intermediate_Position, Station_2.Position_Centered);
End;

// Fonction qui calcule le poids (la distance) d'un itinéraire.
Function Itinerary_Get_Weight(Game : Type_Game; Itinerary_Indexes : Type_Itinerary_Indexes) : Integer;

Var i : Byte;
  Weight : Integer;
  Intermediate_Position : Type_Coordinates;
Begin
  Weight := 0;
  For i := low(Itinerary_Indexes) + 1 To high(Itinerary_Indexes) Do
    Begin
      Weight := Weight + Get_Weight(Game.Stations[Itinerary_Indexes[i - 1]], Game.Stations[Itinerary_Indexes[i]]);
    End;

  Itinerary_Get_Weight := Weight;

End;

Procedure Dijkstra(Starting_Station_Index : Integer; Ending_Station_Index : Integer; Var Itinerary_Indexes : Type_Itinerary_Indexes; Game : Type_Game);

Var k, row, column, Step, indexStationToConnect, comingFromStationIndex, lightest_Station_Index, i, Previous_Index, j, Last_Step : Integer;
  minimum_Weight, Validated_Itinerary_Weight : Real;
  Reverse_Itinerary_Indexes : Type_Itinerary_Indexes;

Begin


  // - Initialisation de la table de Dijkstra.
  Validated_Itinerary_Weight := 0;

  // Initialisation de la première ligne du tableau de dijkstra.
  indexStationToConnect := Starting_Station_Index;

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
        End;

      Game.Dijkstra_Table[Step][Starting_Station_Index].isAvailable := False;
    End;

  comingFromStationIndex := Starting_Station_Index;

  writeln('La station de départ est la station ',Starting_Station_Index,' et la station d''arrivée est la station ',Ending_Station_Index);

  // Met le poid de la station de départ à l'étape 0 à 0.
  Game.Dijkstra_Table[low(Game.Dijkstra_Table)][Starting_Station_Index].Weight := 0;

  // Définit la station de départ de l'étape 0 comme étant la station de départ (initénaire complet).
  Game.Dijkstra_Table[low(Game.Dijkstra_Table)][Starting_Station_Index].comingFromStationIndex := comingFromStationIndex;

  // Met la station de départ comme étant validée (dans l'itinéraire final).
  Game.Dijkstra_Table[low(Game.Dijkstra_Table)][Starting_Station_Index].isValidated := True;

  Step := low(Game.Dijkstra_Table) + 1;
  // Pas completement certain du +1

  // - Résolution de l'itinéraire.

  Repeat

    Connect_Stations(Step, comingFromStationIndex, Game);

    For i := (low(Game.Dijkstra_Table[Step])) To (high(Game.Dijkstra_Table[Step])) Do
      Begin
        // Si la station est libre, connectée et non validée.
        If (Game.Dijkstra_Table[Step][i].isAvailable = True) And (Game.Dijkstra_Table[Step][i].isConnected = True) And (Game.Dijkstra_Table[Step][i].isValidated = False) Then
          Begin
            // TODO : Je ne suis pas fan de cette méthode, mais je ne vois pas comment faire autrement.
            Game.Dijkstra_Table[Step][i].comingFromStationIndex := comingFromStationIndex;
            // on écrit d'où on vient dans la cell, comme on peut le voir sur la video d'Yvan

            // On effectue le calcul de poids.
            Game.Dijkstra_Table[Step][i].Weight := Validated_Itinerary_Weight + Get_Weight(Game.Stations[Game.Dijkstra_Table[Step][i].comingFromStationIndex], Game.Stations[i]);
          End;
      End;

    // - Compare et détermine l'index de la station dont le poids est le plus faible.

    minimum_Weight := 0;

    For i := low(Game.Dijkstra_Table) To Step Do
      Begin

        For column:= (low(Game.Dijkstra_Table[i])) To (high(Game.Dijkstra_Table[i])) Do
          Begin
            If (Game.Dijkstra_Table[i][column].isConnected = True) And (Game.Dijkstra_Table[Step][column].isValidated = False) And (Game.Dijkstra_Table[Step][column].isAvailable = True)
              Then
              Begin
                If (minimum_Weight = 0) Then
                  Begin
                    minimum_Weight := Game.Dijkstra_Table[i][column].weight;
                    lightest_Station_Index := column;
                  End
                Else If (Game.Dijkstra_Table[i][column].weight < minimum_Weight) Then
                       Begin
                         minimum_Weight := Game.Dijkstra_Table[i][column].weight;
                         lightest_Station_Index := column;
                       End;

              End;
          End;
      End;

    Game.Dijkstra_Table[Step+1][lightest_Station_Index] := Game.Dijkstra_Table[Step][lightest_Station_Index];
    Game.Dijkstra_Table[Step+1][lightest_Station_Index].isValidated := True;
    Validated_Itinerary_Weight := Game.Dijkstra_Table[Step][lightest_Station_Index].weight;


    // - Met à jour les stations disponibles.

    For i:= Step To high(Game.Dijkstra_Table) Do
      //On peut également commencer la boucle à iteration+2.
      Begin
        Game.Dijkstra_Table[i][lightest_Station_Index].isAvailable := False;
      End;

    comingFromStationIndex := lightest_Station_Index;
    //    End;
    Last_Step := Step;
    // je le mets avant le +1 car je crois que on dépasse d'une ligne la final step à la fin quoi qu'il arrive.
    Step := Step + 1;

  Until ((Step = high(Game.Dijkstra_Table)) Or (Destination_Reached(Ending_Station_Index, Game.Dijkstra_Table)=True));
  
  SetLength(Reverse_Itinerary_Indexes, 1);
  writeln('Taille de Reverse_Itinerary_Indexes',length(Reverse_Itinerary_Indexes));
  For j := low(Game.Dijkstra_Table) To high(Game.Dijkstra_Table) Do
    Begin
      If Game.Dijkstra_Table[Last_Step][j].isValidated Then
        Begin
          Reverse_Itinerary_Indexes[high(Reverse_Itinerary_Indexes)] := Ending_Station_Index;


// On a correctement identifié la dernière étape, on peut alors commencer la remontée en écrivant l'index de la station d'arrivée. Le 'comingFrom' de la dernière cell nous indique l'étape précédente.   
          Previous_Index := Game.Dijkstra_Table[Last_Step][j].comingFromStationIndex;
          writeln('Le premier PreviousIndex vaut : ',Previous_Index);
          writeln('Contenu de la premiere case de Reverse_Itinerary_Indexes : ',Reverse_Itinerary_Indexes[low(Reverse_Itinerary_Indexes)]);
        End;
    End;


  If Previous_Index <> Ending_Station_Index Then
    Begin
      Repeat
        // Rajoute une case a RII
        SetLength(Reverse_Itinerary_Indexes, length(Reverse_Itinerary_Indexes)+1);

        writeln('Taille de Reverse_Itinerary_Indexes : ',length(Reverse_Itinerary_Indexes));

        Reverse_Itinerary_Indexes[high(Reverse_Itinerary_Indexes)] := Previous_Index;

      writeln('Contenu de la case qu''on vient d'' ajouter : ',Reverse_Itinerary_Indexes[high(Reverse_Itinerary_Indexes)]);

     // writeln(' etape actuelle : ', Last_Step - high(Reverse_Itinerary_Indexes), ' previous index : ', Previous_Index);
      
      writeln('Ancien PreviousIndex : ',Previous_Index);

        Previous_Index := Game.Dijkstra_Table[Last_Step - high(Reverse_Itinerary_Indexes)][Previous_Index].comingFromStationIndex;

      writeln('Nouveau PreviousIndex : ',Previous_Index);

    Until Reverse_Itinerary_Indexes[high(Reverse_Itinerary_Indexes)] = Starting_Station_Index;
  end;

  writeln('Reverse itinerary indexes :');

  For j := low(Reverse_Itinerary_Indexes) To high(Reverse_Itinerary_Indexes) Do
    Begin
      writeln(j, ' : ', Reverse_Itinerary_Indexes[j]);
    End;

  SetLength(Reverse_Itinerary_Indexes, length(Reverse_Itinerary_Indexes)+1);
  Reverse_Itinerary_Indexes[high(Reverse_Itinerary_Indexes)] := Starting_Station_Index;

  SetLength(Itinerary_Indexes, length(Reverse_Itinerary_Indexes));
  // On copie la taille de Reverse_Itinerary_Indexes
  For i:= high(Reverse_Itinerary_Indexes) Downto low(Reverse_Itinerary_Indexes) Do
    Begin
      Itinerary_Indexes[high(Reverse_Itinerary_Indexes)-i] := Reverse_Itinerary_Indexes[i];
    End;








{Itinerary_Indexes[high(Itinerary_Indexes)] := Starting_Station_Index;

  For Step := low(Game.Dijkstra_Table) To high(Game.Dijkstra_Table) Do
    Begin
      For column := low(Game.Dijkstra_Table[Step]) To high(Game.Dijkstra_Table[Step]) Do
        writeln('I / C : ', Step, ' - ', column);
      // ! : Bug, ne s'arrête pas ?
      If (Game.Dijkstra_Table[Step][column].isValidated) And (Itinerary_Indexes[high(Itinerary_Indexes) - 1] <> Game.Dijkstra_Table[Step][column].comingFromStationIndex) Then
        Begin

          writeln('Itinerary_Indexes[high] ', high(Itinerary_Indexes));

          // ! : Ducoup la table vide.

          SetLength(Itinerary_Indexes, length(Itinerary_Indexes)+1);

          Itinerary_Indexes[high(Itinerary_Indexes)] := Game.Dijkstra_Table[Step][column].comingFromStationIndex;
        End;

    End;}
  // TODO: à supprimer si nouvel algo ok


End;






{Function Passenger_Get_Off(Passenger : Type_Passenger_Pointer; Var Current_Station : Type_Station; Game : Type_Game) : Boolean;
Var Current_Station_Index, Passenger_Shape_Station_Index : Integer;


End;

Function Passenger_Get_On(Passenger : Type_Passenger; Game : Type_Game; StationIndex : Integer; Train : Type_Train) : Boolean; //StationIndex sert à rien je crois grace à ma détermination de OwnStationIndex.

Var i, j, Own_Station_Index, Next_Passenger_Station_Index : Integer;
Begin // tout ce bordel est à refaire j'arrive plus à réfléchir mais on y est presque
  Own_Station_Index := get_Absolute_Index_From_Station_Pointer(Train.Next_Station, Game.Stations) - 1;
  for i := low(Passenger.Itinerary) to high(Passenger.Itinerary) do
    begin
      if get_Absolute_Index_From_Station_Pointer(Passenger.Itinerary[i], Game.Stations) = Own_Station_Index then
        begin
          Next_Passenger_Station_Index := get_Absolute_Index_From_Station_Pointer(Passenger.Itinerary[i+1], Game.Stations);
        end; 
    end;
  if get_Absolute_Index_From_Station_Pointer(Train.Next_Station, Game.Stations) = Next_Passenger_Station_Index then
    begin
      Passenger_Get_On := True;
    end
  else
    begin
      Passenger_Get_On := False;
    end;
End;}


// Procédure qui calcule l'itinéaire des stations correspondant à la forme du passager, puis détermine la plus "proche" en prenant l'intéraire le plus court..
Procedure Passengers_Compute_Itinerary(Game : Type_Game);

Var i,j,k,l : Byte;
  Index_Table_Of_Same_Shape, Itinerary_Indexes : Type_Itinerary_Indexes;
  Lowest_Weight : Integer;
  Lowest_Itinerary_Indexes : Type_Itinerary_Indexes;
Begin

  // Itère parmi les stations.
  For i:= low(Game.Stations) To high(Game.Stations) Do
    // Parcourt toutes les stations pour ensuite parcourir les passagers contenus dans ces stations
    Begin
      If (length(Game.Stations[i].Passengers) > 0) Then
        Begin
          // Itère parmi les passagers d'une station.
          For j:= low(Game.Stations[i].passengers) To high(Game.Stations[i].passengers) Do
            // Parcourt les passagers de la station
            Begin

              writeln(' Passenger pos : ', i, ' - ', j);

              // Détermine les stations de destination possible pour un passager.
              Get_Ending_Stations_From_Shape(Game, Game.Stations[i].Passengers[j], Index_Table_Of_Same_Shape);

              // 
              For k := low(Index_Table_Of_Same_Shape) To high(Index_Table_Of_Same_Shape) Do
                Begin

                  writeln('length Dij :  ', length(Itinerary_Indexes));

                  Dijkstra(i, Index_Table_Of_Same_Shape[k], Itinerary_Indexes, Game);

                  writeln(' Solution ', k, ' de Dijkstra  : ');
                  For l := low(Itinerary_Indexes) To high(Itinerary_Indexes) Do
                    Begin
                      writeln('S : ', Itinerary_Indexes[l]);
                    End;

                  writeln('Weight : ', Itinerary_Get_Weight(Game, Itinerary_Indexes));

                  If k = low(Index_Table_Of_Same_Shape) Then
                    Lowest_Weight := Itinerary_Get_Weight(Game, Itinerary_Indexes)

                  Else If (Itinerary_Get_Weight(Game, Itinerary_Indexes) < Lowest_Weight) Then
                         Begin
                           Lowest_Weight := Itinerary_Get_Weight(Game, Itinerary_Indexes);
                           // Copie dans l'itinéraire le plus court.
                           Lowest_Itinerary_Indexes := copy(Itinerary_Indexes, low(Itinerary_Indexes), length(Itinerary_Indexes));

                         End;

                End;


              // - Conversion de l'itinéraire en pointeurs de stations.

              writeln('Length Itinerary : ', length(Lowest_Itinerary_Indexes));

              writeln(' Passenger shape : ', Game.Stations[i].Passengers[j]^.Shape);

              SetLength(Game.Stations[i].Passengers[j]^.Itinerary, length(Lowest_Itinerary_Indexes));

              For l := low(Lowest_Itinerary_Indexes) To high(Lowest_Itinerary_Indexes) Do
                Game.Stations[i].Passengers[j]^.Itinerary[l] := @Game.Stations[Lowest_Itinerary_Indexes[l]];
            End;
        End;
    End;
End;

Function Passenger_Get_Off(Passenger : Type_Passenger_Pointer; Var Current_Station : Type_Station) : Boolean;
Begin
  If random(2) = 0 Then
    Passenger_Get_Off := True
  Else
    Passenger_Get_Off := False;
End;

Function Passenger_Get_On(Passenger : Type_Passenger_Pointer; Var Next_Station : Type_Station) : Boolean;
Begin
  If random(2) = 0 Then
    Passenger_Get_On := True
  Else
    Passenger_Get_On := False;
End;

// - - Fonctions et procédures relatives à la logique générale.

// Procédure qui charge la logique.
Procedure Logic_Load(Var Game : Type_Game);

Var i,j : Byte;
Begin
  Randomize();

  Graphics_Load(Game);

  Sounds_Load(Game);

  Sounds_Set_Volume(Sounds_Maximum_Volume);

  Sounds_Play(Game.Ressources.Music);

  Game.Start_Time := Time_Get_Current();

  Game.Play_Pause_Button.State := true;

  Game.Player.Locomotive_Token := 3;
  Game.Player.Tunnel_Token := 3;
  Game.Player.Wagon_Token := 3;
  Game.Player.Score := 0;

  Game.Day := Day_Monday;


  River_Create(Game);


  // Défintion de la carte d'occupation des stations..
  SetLength(Game.Stations_Map, Game.Panel_Right.Size.X Div 64);

  For i := low(Game.Stations_Map) To high(Game.Stations_Map) Do
    Begin
      SetLength(Game.Stations_Map[i], Game.Panel_Right.Size.Y Div 64);
      For j := low(Game.Stations_Map[i]) To high(Game.Stations_Map[i]) Do
        Game.Stations_Map[i][j] := false;
    End;

  // Création des 5 premères stations
  For i := 1 To 5 Do
    Begin
      Station_Create(Game);
    End;

  // Création de la première ligne
  Line_Create(Game);
  Line_Create(Game);
  Line_Create(Game);
  Line_Create(Game);
  Line_Create(Game);
  Line_Create(Game);
  Line_Create(Game);
  Line_Create(Game);


  For i := low(Game.Stations) To high(Game.Stations) Do
    Begin
      Line_Add_Station(@Game.Stations[i], Game.Lines[0], Game);
    End;


  For i := low(Game.Stations) + 1 To high(Game.Stations) - 1 Do
    Begin
      Line_Add_Station(@Game.Stations[i], Game.Lines[1], Game);
    End;




{
  For i := high(Game.Stations) - 2 To high(Game.Stations) Do
    Begin
      Line_Add_Station(@Game.Stations[i], Game.Lines[1]);
    End;

  For i := high(Game.Stations) - 6 To high(Game.Stations) - 3 Do
    Begin
      Line_Add_Station(@Game.Stations[i], Game.Lines[2]);
    End;
}

  For i := low(Game.Stations) To high(Game.Stations) Do
    Begin
      For j := 0 To Random(12) Do
        Begin
          Passenger_Create(Game.Stations[i], Game);
        End;
    End;


  Passenger_Create(Game.Stations[0], Game);


  // Calcul des itinéaires des passagers crées.
  //Passengers_Compute_Itinerary(Game);

  Train_Create(Game.Lines[0].Stations[0], true, Game.Lines[0], Game);
  //Train_Create(Game.Lines[0].Stations[3], false, Game.Lines[0], Game);
  //Train_Create(Game.Lines[1].Stations[low(Game.Lines[1].Stations)], true, Game.Lines[1], Game);

  Mouse_Load(Game.Mouse);

End;

// Procédure qui décharge la logique en libérant la mémoire des objets alloués.
Procedure Logic_Unload(Var Game : Type_Game);

Var i,j,k,l : Byte;
Begin
  Graphics_Unload(Game);

  Sounds_Unload(Game);


  // Suppresion des passagers des stations.
  // Itère parmis les stations
  For i := low(Game.Stations) To high(Game.Stations) Do
    Begin
      // Itère parmis les passagers de la station.
      For j := low(Game.Stations[i].Passengers) To high(Game.Stations[i].Passengers) Do
        Begin
          FreeMem(Game.Stations[i].Passengers[j]);
        End;
      // Vidage du tableau.
      SetLength(Game.Stations[i].Passengers, 0);
    End;

  SetLength(Game.Stations, 0);

  // Suppresion des passagers dans les véhicules des trains.
  // Vérifie qu'il y a bien des lignes.
  If (length(Game.Lines) > 0) Then
    // Itère parmis les lignes
    For i := low(Game.Lines) To high(Game.Lines) Do
      Begin
        // Vérifie qu'il y a bien des trains sur la ligne.
        If (length(Game.Lines[i].Trains) > 0) Then
          Begin
            // Itère parmis les trains de la ligne
            For j := low(Game.Lines[i].Trains) To high(Game.Lines[i].Trains) Do
              Begin
                // Itère parmis les véhicules du train
                For k := low(Game.Lines[i].Trains[j].Vehicles) To high(Game.Lines[i].Trains[j].Vehicles) Do
                  Begin
                    // Itère parmis les passagers du véhicule.
                    For l := 0 To Vehicle_Maximum_Passengers_Number - 1 Do
                      Begin
                        If (Game.Lines[i].Trains[j].Vehicles[k].Passengers[l] <> Nil) Then
                          Begin
                            FreeMem(Game.Lines[i].Trains[j].Vehicles[k].Passengers[l]);
                            Game.Lines[i].Trains[j].Vehicles[k].Passengers[l] := Nil;
                          End;
                      End;
                  End;
              End;
          End;
      End;

  // Suppression des panneaux de l'interface graphique.
  Panel_Delete(Game.Panel_Left);
  Panel_Delete(Game.Panel_Right);
  Panel_Delete(Game.Panel_Top);
  Panel_Delete(Game.Panel_Bottom);
  Panel_Delete(Game.Window);

  // Pas besoin de supprimer les autres objets, ils seront automatiquements détruit lors de la suppression de l'objet Game.

  // Fermeture de la SDL.
  SDL_Quit();
End;

Procedure Logic_Event_Handler(Var Game : Type_Game);

Var Event : TSDL_Event;
Begin
  // Vérifie les évènements.
  While (SDL_PollEvent(@Event) > 0) Do
    Begin
      // Si l'utilisateur demande la fermeture du programme.
      Case Event.type_ Of 
        // Si la fenêtre est fermée.
        SDL_QUITEV :
                     Begin
                       HALT();
                       Logic_Unload(Game);
                     End;
        SDL_MOUSEBUTTONDOWN, SDL_MOUSEBUTTONUP :
                                                 Mouse_Event_Handler(Event.button, Game);
      End;

    End;
End;

// Rafraichissement de la logique.
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
                 Logic_Rewards(Game);
             End;

           // Si le timer de génération de passager à été dépassé.
           If (Game.Passengers_Timer < Time_Get_Current()) Then
             Begin
               // Génération aléatoire des passagers.
               // Vérifie si il y a bien des stations dans une partie.
               If (length(Game.Stations) > 0) Then
                 Begin

                   // Création d'un passager sur une station choisie aléatoirement.
                   Passenger_Create(Game.Stations[Random(high(Game.Stations) + 1)], Game);

                   // Calcul des itinéaires des passagers crées.
                   //Passengers_Compute_Itinerary(Game);


                   // Détermination du prochain intervalle de temps avant la génération d'un nouveau passager.
                   Game.Passengers_Timer := Time_Get_Current() + round((exp(-1.5 * (Time_Get_Elapsed(Game.Start_Time) / (1000 * 60 * 60)) + 2) * 1000));

                 End;
             End;

        // Si le timer de génération de stations à été dépassé.
           If (Game.Stations_Timer < Time_Get_Current()) Then
             Begin
               // Génération aléatoire d'une station.
               // Vérifie si il y a bien des stations dans une partie.

               //Station_Create(Game);
               
            // ! : L'allocation dynamique des stations est problématique car cela déplace les adresses mémoires des stations déjà existantes en cas d'allocation supplémentaire. Or elles ne sont pas et ne peuvent pas être mises à jour dans les lignes, ni dans les trains ... Il faut donc revoir la gestion de la mémoire des stations. Probablement en utilisant plutot des tableaux statiques ou dynamiques (mais avec des pointeurs). Cependant, au vu du nombre d'occurences de Game.Stations, cela risque d'être très long à faire.

                Game.Stations_Timer := Time_Get_Current() + 25000;
             End;

            

           // - Gestion des trains arrivés à quais.

           // Vérifié qu'il existe une ligne.
           If (length(Game.Lines) > 0) Then
             Begin
               // Itère parmis les lignes
               For i := low(Game.Lines) To high(Game.Lines) Do
                 Begin
                   // Itère parmis les trains
                   For j := low(Game.Lines[i].Trains) To high(Game.Lines[i].Trains) Do
                     Begin
                       // Si le train est arrivé à quais.
                       If (Game.Lines[i].Trains[j].Driving = false) Then
                         Begin
                           // Effectue la correspondance du train arrivé à quais.
                           Train_Connection(Game.Lines[i], Game.Lines[i].Trains[j], Game);
                         End;
                     End;
                 End;
             End;

           // - Reconstruction de la graph table.

           If (Game.Refresh_Graph_Table) Then
             Begin
               Game_Refresh_Graph_Table(Game);
               Game.Refresh_Graph_Table := false;
             End;

           // - Vérification de l'encombrement des stations.

           // Itère parmis les stations.
           For i := low(Game.Stations) To high(Game.Stations) Do
             Begin
               // Si la station est surchargée.
               If (length(Game.Stations[i].Passengers) > Station_Overfill_Passengers_Number) Then
                 Begin
                   // Si la station n'est pas encombré avant la dernière vérification.
                   If (Game.Stations[i].Overfill_Timer = 0) Then
                     // On démare le timer de la station.
                     Game.Stations[i].Overfill_Timer := Time_Get_Current()
                                                        // Si la station était encombré avant la dernière vérification et que son timer est dépassé.
                   Else If (Time_Get_Elapsed(Game.Stations[i].Overfill_Timer) > Station_Overfill_Timer * 1000) Then
                          // La partie est terminée.
                   ;
                   // TODO : Faire écran de game over.
                 End
               Else
                 Game.Stations[i].Overfill_Timer := 0;
             End;
           Game.Logic_Timer := Time_Get_Current() + 200;
         End
         // Si tout à été rafraichit.
   // Si il faut rafraichir les graphismes.
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

// Fonction qui effectue la correspondance du train arrivé à quais et change les attributs du trains pour sa prochaine destination.
Procedure Train_Connection(Var Line : Type_Line; Var Train : Type_Train; Var Game : Type_Game);

Var i, j, k : Byte;
  Passengers_Queue : Array Of Type_Passenger_Pointer;
Begin
  // Pour faire disparaitre l'avertissement.
  SetLength(Passengers_Queue, 0);

  // La station d'arrivée devient la station de départ.
  Train.Last_Station := Train.Next_Station;
  // Réinitialisation de la distance.
  Train.Distance := 0;

  // - Détermination de la prochaine station du train.

  // Parcourt toute les station de la ligne du train.
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

  // Calcul de la distance entre la station de départ et d'arrivée.

  Train.Maximum_Distance := Get_Distance(Train.Last_Station^.Position_Centered, Train.Intermediate_Position);


  Train.Maximum_Distance := Train.Maximum_Distance +  Get_Distance(Train.Intermediate_Position, Train.Next_Station^.Position_Centered);

  // - Déchargement des passagers du train.

  // Itère parmis les véhicules du train.
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
              Else If (Passenger_Get_Off(Train.Vehicles[i].Passengers[j], Train.Last_Station^)) Then
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

  // Itère parmis les véhicules d'un train.
  For i := low(Train.Vehicles) To high(Train.Vehicles) Do
    Begin
      // Itère parmis les places du véhicule.
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
                      If (Passenger_Get_On(Train.Last_Station^.Passengers[k], Train.Next_Station^)) Then
                        Begin
                          // Copie du pointeur du passager dans le train.
                          Train.Vehicles[i].Passengers[j] := Train.Last_Station^.Passengers[k];
                          // Suppresion du pointeur du passager de la station.
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

  // Le train peut repartir.
  Train.Driving := true;
End;

End.
