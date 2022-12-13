
Unit Unit_Logic;

Interface

// - Inclut les unités internes au projet. 

Uses Unit_Types, Unit_Sounds, Unit_Graphics, sdl, Unit_Mouse, sysutils;

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




Function get_Absolute_Index_From_Station_Pointer(station_Pointer : Type_Station_Pointer; stations_Table : Array Of Type_Station): integer;

Var iteration : Integer;
Begin
  iteration := low(stations_Table);
  Repeat
    If station_Pointer = @stations_Table[iteration] Then
      Begin
        get_Absolute_Index_From_Station_Pointer := iteration;
      End;
    iteration := iteration+1;
  Until (station_Pointer = @stations_Table[iteration]) Or (iteration = high(stations_Table));
End;

Function Station_Get_Pointer_From_Absolute_Index(Inndex : Integer; Stations : Array Of Type_Station_Pointer) : Type_Station_Pointer;
Begin
  Station_Get_Pointer_From_Absolute_Index := @Stations[Inndex];
End;

Procedure Build_Graph_Table(Game : Type_Game);

Var iteration, jiteration, k, absolute_Index_First_Station, absolute_Index_Second_Station : Integer;
  couple_Stations : array[0..1] Of Type_Station_Pointer;
  // Tableau temporaire dans lequel stocker les pointeurs des stations à relier dans la table une fois prélevées dans le tableau de pointeur de station de chaque ligne.
Begin
  // Définit les dimensions de la graph_Table
  SetLength(Game.graph_Table, length(Game.Stations));
  For iteration := low(Game.graph_Table) To high(Game.graph_Table) Do
    Begin
      SetLength(Game.graph_Table[iteration], length(Game.stations));
    End;

  For iteration := low(Game.Stations) To high(Game.Stations) Do
    // Initialise toutes les connections à NIL
    Begin
      For jiteration := low(Game.Stations) To high(Game.Stations) Do
        Begin
          For k := low(Game.Lines) To high(Game.Lines) Do
            Begin
              Game.graph_Table[iteration][jiteration][k] := Nil;
            End;
        End;
    End;

  For iteration := low(Game.Lines) To high(Game.Lines) Do
    // Pour chacune des lignes :
    Begin
      For jiteration:= low(Game.Lines[iteration].Stations) To (high(Game.Lines[iteration].Stations)-1) Do
        // Pour chacune des stations consécutivement connectées contenues dans le tableau :
        Begin
          If (Game.Lines[iteration].Stations[jiteration] <> Nil) Then
            // Au début de la partie il y a des chances pour que certaines lignes soient vides, il ne faut pas accéder à cet emplacement mémoire s'il ne contient pas un pointeur sur station.
            Begin
              couple_Stations[0] := Game.Lines[iteration].Stations[jiteration];
              couple_Stations[1] := Game.Lines[iteration].Stations[jiteration+1];
              absolute_Index_First_Station := get_Absolute_Index_From_Station_Pointer(couple_Stations[0], Game.Stations);













        // Je pense qu'on pourrait directement mettre la fonction en tant qu'index pour graph_Table mais pour la compréhension je trouve ca mieux comme ca, surtout si on relit le code dans longtemps.
              absolute_Index_Second_Station := get_Absolute_Index_From_Station_Pointer(couple_Stations[1], Game.Stations);
              Game.graph_Table[absolute_Index_First_Station][absolute_Index_Second_Station][iteration] := @Game.Lines[iteration];
              Game.graph_Table[absolute_Index_Second_Station][absolute_Index_First_Station][iteration] := @Game.Lines[iteration];
              // La graphTable est symétrique (l'axe étant sa diagonale)
            End;
        End;
    End;

End;

Procedure Connect_Stations(rowToFill : Integer; indexStationToConnect : Integer; Game : Type_Game);
// TypeGraphTable plutot que Type_Line parce que dans chaque case il y aura une record avec plusieurs lignes + la station avec laquelle la premiere station est reliée

Var i, iteration_Lines : Integer;
Begin
  For i := low(Game.Graph_Table) To high(Game.Graph_Table) Do
    Begin
      iteration_Lines := low(Game.Lines);
      Repeat
        If Game.Graph_Table[indexStationToConnect][i][iteration_Lines] <> Nil Then     // Vérifie qu'une ligne relie bien les deux stations, i étant l'index de la deuxieme station.
          Begin
            // Vérifie que Dijkstra n'a pas interdit de retourner sur cette case.
            If (Game.Dijkstra_Table[rowToFill][i].isAvailable = True) Then
              Begin
                // Permet à Dijkstra de savoir s'il doit considérer cette station en particulier dans son calcul d'itinéraire.
                Game.Dijkstra_Table[rowToFill][i].isConnected := True;
              End;
          End
          // Vérifie que Dijkstra n'a pas interdit de retourner sur cette case.
        Else
          Begin
            Game.Dijkstra_Table[rowToFill][i].isConnected := False;
          End;
        iteration_Lines := iteration_Lines + 1;
      Until (Game.Graph_Table[indexStationToConnect][i][iteration_Lines] <> Nil) Or (iteration_Lines = high(Game.Lines));
    End;
End;



// Procédure qui renvoie toute les stations qui ont la même forme que le passager donné.
Procedure Get_Ending_Stations_From_Shape(Game : Type_Game; Passenger : Type_Passenger_Pointer; Var Index_Table : Type_Index_Table);

Var i, counter : Integer;
Begin
  counter := 1;
  For i:= low(Game.Stations) To high(Game.Stations) Do
    Begin
      If Game.Stations[i].Shape = Passenger^.Shape Then
        Begin
          SetLength(Index_Table, counter);
          counter := counter+1;
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

Var k, row, column, iteration, indexStationToConnect, comingFromStationIndex, lightest_Station_Index, i, j : Integer;
  minimum_Weight : Real;

Begin
  indexStationToConnect := Starting_Station_Index;

  For i := low(Game.Dijkstra_Table) To high(Game.Dijkstra_Table) Do
    Begin
      For j := low(Game.Dijkstra_Table) To high(Game.Dijkstra_Table) Do
        Begin
          Game.Dijkstra_Table[i][j].isAvailable := True;
          // Les cases sont a priori toutes disponibles avant d'être passé dessus.

        End;

    End;

  comingFromStationIndex := Starting_Station_Index;
  Game.Dijkstra_Table[low(Game.Dijkstra_Table)][Starting_Station_Index].weight := 0;
  Game.Dijkstra_Table[low(Game.Dijkstra_Table)][Starting_Station_Index].comingFromStationIndex := comingFromStationIndex;
  Game.Dijkstra_Table[low(Game.Dijkstra_Table)][Starting_Station_Index].isValidated := True;
  For iteration := low(Game.Dijkstra_Table) To high(Game.Dijkstra_Table) Do
    Begin
      Game.Dijkstra_Table[iteration][Starting_Station_Index].isAvailable := False;
    End;
  iteration := low(Game.Dijkstra_Table);
  Repeat
    //  For iteration := (low(Game.Dijkstra_Table)) To (high(Game.Dijkstra_Table)) Do
    //    Begin
    Connect_Stations(iteration, comingFromStationIndex, Game);
    For column := (low(Game.Dijkstra_Table)) To (high(Game.Dijkstra_Table)) Do
      Begin
        If (Game.Dijkstra_Table[iteration][column].isAvailable = True) And (Game.Dijkstra_Table[iteration][column].isConnected = True) And (Game.Dijkstra_Table[iteration][column].isValidated = False
           ) Then
          Begin
            Game.Dijkstra_Table[iteration][column].comingFromStationIndex := comingFromStationIndex;

            Game.Dijkstra_Table[iteration][column].weight := Get_Weight(Station_Get_Pointer_From_Absolute_Index(comingFromStationIndex, Game.Lines[i].Stations)^,Station_Get_Pointer_From_Absolute_Index
                                                             (
                                                             indexStationToConnect, Game.Lines[i].Stations)^);
          End;
      End;
    // - Compare et détermine l'index de la station dont le poids est le plus faible. 
    minimum_Weight := 30000; {Plus gros entier}
    For i := (low(Game.Dijkstra_Table)) To (high(Game.Dijkstra_Table)) Do
      Begin
        For column:= (low(Game.Dijkstra_Table)) To (high(Game.Dijkstra_Table)) Do
          Begin
            If (Game.Dijkstra_Table[i][column].isConnected = True) And (Game.Dijkstra_Table[iteration][column].isValidated = False) And (Game.Dijkstra_Table[iteration][column].isAvailable = True)
              Then
              Begin
                If Game.Dijkstra_Table[i][column].weight < minimum_Weight Then
                  Begin
                    minimum_Weight := Game.Dijkstra_Table[i][column].weight;
                    lightest_Station_Index := column;
                  End;

              End;
          End;
      End;
    Game.Dijkstra_Table[iteration+1][lightest_Station_Index] := Game.Dijkstra_Table[iteration][lightest_Station_Index];
    Game.Dijkstra_Table[iteration+1][lightest_Station_Index].isValidated := True;
    For i:= iteration To high(Game.Dijkstra_Table) Do
      //On peut également commencer la boucle à iteration+2.
      Begin
        Game.Dijkstra_Table[i][lightest_Station_Index].isAvailable := False;
      End;
    comingFromStationIndex := lightest_Station_Index;
    //    End;
    iteration := iteration +1;
  Until ((iteration = high(Game.Dijkstra_Table)) Or (Destination_Reached(Ending_Station_Index, Game.Dijkstra_Table)=True));


  k := 1;
  SetLength(Itinerary_Indexes, k);

  Itinerary_Indexes[high(Itinerary_Indexes)] := Starting_Station_Index;

  For iteration:= low(Game.Dijkstra_Table) To high(Game.Dijkstra_Table) Do
    Begin
      writeln('Itération ', iteration);
      For column := low(Game.Dijkstra_Table) To high(Game.Dijkstra_Table) Do
        // ! : Bug, ne s'arrête pas ?
        If (Game.Dijkstra_Table[iteration][column].isValidated = True) And (Itinerary_Indexes[k-1] <> Game.Dijkstra_Table[iteration][column].comingFromStationIndex) Then
          Begin
            writeln('Column ', column);

            writeln('k : ', k);

            // ! : Ducoup la table vide.
            SetLength(Itinerary_Indexes, k);
            
            Itinerary_Indexes[k] := Game.Dijkstra_Table[iteration][column].comingFromStationIndex;
            inc(k);
          End;

    End;
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

              writeln(' Passenger pos : ', i);

              // Détermine les stations de destination possible pour un passager.
              Get_Ending_Stations_From_Shape(Game, Game.Stations[i].passengers[j], Index_Table_Of_Same_Shape);

              // 
              For k := low(Index_Table_Of_Same_Shape) To high(Index_Table_Of_Same_Shape) Do
                Begin

                  Dijkstra(i, k, Itinerary_Indexes, Game);

                  writeln('length Dij :  ', length(Itinerary_Indexes));

                  If k = low(Index_Table_Of_Same_Shape) Then
                    Lowest_Weight := Itinerary_Get_Weight(Game, Itinerary_Indexes)

                  Else If (Itinerary_Get_Weight(Game, Itinerary_Indexes) < Lowest_Weight) Then
                         Begin
                           Lowest_Weight := Itinerary_Get_Weight(Game, Itinerary_Indexes);
                           // Copie dans l'itinéraire le plus court.
                           Lowest_Itinerary_Indexes := copy(Itinerary_Indexes, low(Itinerary_Indexes), length(Itinerary_Indexes));

                         End;

                  // - Conversion de l'itinéraire en pointeurs de stations.

                  writeln('shape :', Game.Stations[i].Passengers[j]^.Shape);
                  writeln('length : ', length(Lowest_Itinerary_Indexes));

                  SetLength(Game.Stations[i].Passengers[j]^.Itinerary, length(Lowest_Itinerary_Indexes));

                  For l := low(Lowest_Itinerary_Indexes) To high(Lowest_Itinerary_Indexes) Do
                    Game.Stations[i].Passengers[j]^.Itinerary[l] := @Game.Stations[Lowest_Itinerary_Indexes[l]];
                End;
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
      Line_Add_Station(@Game.Stations[i], Game.Lines[0]);
      writeln(i, ' : ', Game.Stations[i].Shape);
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

  For i := low(Game.Stations) To high(Game.Stations) Do
    Begin
      For j := 0 To Random(12) Do
        Begin
          Passenger_Create(Game.Stations[i], Game);
        End;
    End;
}

  Passenger_Create(Game.Stations[0], Game);


  // Calcul des itinéaires des passagers crées.
  Passengers_Compute_Itinerary(Game);

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
                     HALT();
        SDL_MOUSEBUTTONDOWN, SDL_MOUSEBUTTONUP :
                                                 Mouse_Event_Handler(Event.button, Game);
      End;

    End;
End;

// Rafraichissement de la logique.
Procedure Logic_Refresh(Var Game : Type_Game);

Var i, j : Integer;
Begin

  // Si il faut rafraichir les graphismes.
  If (Game.Graphics_Timer < Time_Get_Current()) Then
    Begin
      Graphics_Refresh(Game);
      Logic_Event_Handler(Game);
      Game.Graphics_Timer := Time_Get_Current() + (1000 Div 60);
    End
    // Si il faut rafraichrir la logique et que la partie n'est pas en pause.
  Else If (Game.Logic_Timer < Time_Get_Current) And (Game.Play_Pause_Button.State = true) Then
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
                   //Passenger_Create(Game.Stations[Random(high(Game.Stations) + 1)], Game);

                   // Calcul des itinéaires des passagers crées.
                   //Passengers_Compute_Itinerary(Game);


                   // Détermination du prochain intervalle de temps avant la génération d'un nouveau passager.
                   Game.Passengers_Timer := Time_Get_Current() + round((exp(-1.5 * (Time_Get_Elapsed(Game.Start_Time) / (1000 * 60 * 60)) + 2) * 1000));

                 End;
             End;

           // Détecte les trains arrivés à quais.
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

           // - Vérification des stations encombrées.

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

  // Comptage des passagers dans le train.
  k := 0;
  For i := low(Train.Vehicles) To high(Train.Vehicles) Do
    Begin
      For j := 0 To Vehicle_Maximum_Passengers_Number - 1 Do
        Begin
          If (Train.Vehicles[i].Passengers[j] <> Nil) Then
            inc(k);
        End;
    End;
  // Mise à jour de l'étiquette.
  Label_Set_Text(Train.Passengers_Label, IntToStr(k) + '/' + IntToStr(length(Train.Vehicles)*Vehicle_Maximum_Passengers_Number));

  // Désallocation de la queue.
  SetLength(Passengers_Queue, 0);

  Train.Start_Time := Time_Get_Current();

  // Le train peut repartir.
  Train.Driving := true;
End;

End.
