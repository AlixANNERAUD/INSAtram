
Unit Unit_Logic;

Interface

// - Inclut les unités internes au projet. 

Uses Unit_Types, Unit_Graphics, sdl, Unit_Mouse, sysutils;

// - Déclaration des fonctions et procédures.

// - - Logique générale.
Procedure Logic_Load(Var Game : Type_Game);

Procedure Logic_Unload(Var Game : Type_Game);

Procedure Logic_Refresh(Var Game : Type_Game);

Procedure Train_Connection(Var Line : Type_Line; Var Train : Type_Train; Var Game : Type_Game);

Function Passenger_Get_Off(Passenger : Type_Passenger_Pointer; Var Current_Station : Type_Station) : Boolean;

Function Passenger_Get_On(Passenger : Type_Passenger_Pointer; Var Next_Station : Type_Station) : Boolean;

// - Définition des fonctions et des procédures.

Implementation

// - - Fonctions et procédures relatives au passagers 

function get_Absolute_Index_From_Station_Pointer(station_Pointer : Type_Station_Pointer; stations_Table : array Of Type_Station):integer;
var iteration : Integer;
begin
    iteration := low(stations_Table);
    repeat
        if station_Pointer = @stations_Table[iteration] then
            begin
                get_Absolute_Index_From_Station_Pointer := iteration;
            end;
        iteration := iteration+1;
    until (station_Pointer = @stations_Table[iteration]) or (iteration = high(stations_Table));
end;

function get_Pointer_From_Absolute_Index(Index : Integer; Stations : Array of Type_Station_Pointer):Type_Station_Pointer;
begin
    get_Pointer_From_Absolute_Index := @Stations[Index];
end;

procedure Build_Graph_Table(Game : Type_Game);
var iteration, jiteration, kiteration, absolute_Index_First_Station, absolute_Index_Second_Station : Integer;
    couple_Stations : array[0..1] of Type_Station_Pointer; // Tableau temporaire dans lequel stocker les pointeurs des stations à relier dans la table une fois prélevées dans le tableau de pointeur de station de chaque ligne.
Begin
    // Définit les dimensions de la graph_Table
    SetLength(Game.graph_Table, length(Game.Stations));
    for iteration := low(Game.graph_Table) to high(Game.graph_Table) do
        begin
            SetLength(Game.graph_Table[iteration], length(Game.stations));        
        end;

    for iteration := low(Game.Stations) to high(Game.Stations) do // Initialise toutes les connections à NIL
        begin
            for jiteration := low(Game.Stations) to high(Game.Stations) do
                begin
                    for kiteration := low(Game.Lines) to high(Game.Lines) do
                        begin
                            Game.graph_Table[iteration][jiteration][kiteration] := NIL;
                        end;
                end;
        end;

    for iteration := low(Game.Lines) to high(Game.Lines) do // Pour chacune des lignes :
        begin
            for jiteration:= low(Game.Lines[iteration].Stations) to (high(Game.Lines[iteration].Stations)-1) do // Pour chacune des stations consécutivement connectées contenues dans le tableau :
                begin
                    if (Game.Lines[iteration].Stations[jiteration] <> NIL) then // Au début de la partie il y a des chances pour que certaines lignes soient vides, il ne faut pas accéder à cet emplacement mémoire s'il ne contient pas un pointeur sur station.
                    begin
                    couple_Stations[0]:=Game.Lines[iteration].Stations[jiteration];
                    couple_Stations[1]:=Game.Lines[iteration].Stations[jiteration+1];
                    absolute_Index_First_Station := get_Absolute_Index_From_Station_Pointer(couple_Stations[0], Game.Stations); // Je pense qu'on pourrait directement mettre la fonction en tant qu'index pour graph_Table mais pour la compréhension je trouve ca mieux comme ca, surtout si on relit le code dans longtemps.
                    absolute_Index_Second_Station := get_Absolute_Index_From_Station_Pointer(couple_Stations[1], Game.Stations);
                    Game.graph_Table[absolute_Index_First_Station][absolute_Index_Second_Station][iteration] := @Game.Lines[iteration];
                    Game.graph_Table[absolute_Index_Second_Station][absolute_Index_First_Station][iteration] := @Game.Lines[iteration]; // La graphTable est symétrique (l'axe étant sa diagonale)
                    end;
                end;
        end;

End;

procedure Connect_Stations(rowToFill : Integer; indexStationToConnect : Integer; GraphTable : Type_Graph_Table; Var DijkstraTable : Array Of Type_Dijkstra_Cell; Game : Type_Game); // TypeGraphTable plutot que Type_Line parce que dans chaque case il y aura une record avec plusieurs lignes + la station avec laquelle la premiere station est reliée
Var i, iteration_Lines : Integer;
begin
    for i := low(GraphTable) to high(GraphTable) do
        begin
            iteration_Lines := low(Game.Lines);
            repeat
                if GraphTable[indexStationToConnect][i][iteration_Lines] <> NIL then     // Vérifie qu'une ligne relie bien les deux stations, i étant l'index de la deuxieme station.
                    begin
                        if (DijkstraTable[rowToFill][i].isAvailable = True) then      // Vérifie que Dijkstra n'a pas interdit de retourner sur cette case.
                            begin
                                DijkstraTable[rowToFill][i].isConnected := True;        // Permet à Dijkstra de savoir s'il doit considérer cette station en particulier dans son calcul d'itinéraire.
                            end;
                    end
                else
                    begin
                        DijkstraTable[rowToFill][i].isConnected := False;
                    end;
                i := i+1;
                iteration_Lines=iteration_Lines+1;
            until (GraphTable[indexStationToConnect][i][iteration_Lines] <> NIL) or (iteration_Lines = high(Game.Lines));
        end;
end;

function get_Weight(first_Station_Pointer : Type_Station_Pointer; second_Station_Pointer : Type_Station_Pointer; Game : Type_Game):Integer; // pas besoin de la graph table qui donne des infos sur les lignes uniquement, et deux lignes qui desservent la meme station ont la meme longueur (elles sont parallèles)
var iteration : Integer;
begin
    get_Weight := Graphics_Get_Distance(^first_Station_Pointer.Position, Station_Get_Intermediate_Position(^first_Station_Pointer.Position, ^second_Station_Pointer.Position)) + Graphics_Get_Distance(Station_Get_Intermediate_Position(^first_Station_Pointer.Position, ^second_Station_Pointer.Position), ^second_Station_Pointer); //!\\ probleme ici : Station_Get_Intermediate_Position ne semble pas exister malgré son usage dans l'Unit_Graphics.
end;

procedure Dijkstra(Starting_Station_Index : Integer; Ending_Station_Index : Integer; Var DijkstraTable : Array Of Type_Dijkstra_Cell; var Itinerary_Indexes : Array of Integer; GraphTable : TypeGraphTable; Game : Type_Game)
Var row, column, iteration, indexStationToConnect, comingFromStationIndex, minimum_Weight, lightest_Station_Index, i, j : Integer;
   
begin
    indexStationToConnect := Starting_Station_Index;

    for row := low(DijkstraTable) to high(DijkstraTable) do
        begin
            for column := low(DijkstraTable) to high(DijkstraTable) do
                begin
                    DijkstraTable[i][j].isAvailable := True;            // Les cases sont a priori toutes disponibles avant d'être passé dessus.
            
                end;
           
        end;
    
    comingFromStationIndex := Starting_Station_Index;
    DijkstraTable[low(DijkstraTable)][Starting_Station_Index].weight := 0;
    DijkstraTable[low(DijkstraTable)][Starting_Station_Index].comingFromStationIndex := comingFromStationIndex;
    DijkstraTable[low(DijkstraTable)][Starting_Station_Index].isValidated := True;
    for iteration := low(DijkstraTable) to high(DijkstraTable) do
        begin
            DijkstraTable[low(DijkstraTable)][Starting_Station_Index].isAvailable := False;
            iteration := iteration+1;
        end;

    for iteration := (low(DijkstraTable)) to (high(DijkstraTable)) do
        begin
            Connect_Stations(iteration, comingFromStationIndex, GraphTable, DijkstraTable);
            for column := (low(DijkstraTable)) to (high(DijkstraTable)) do
                begin
                    if (DijkstraTable[iteration][column].isAvailable = True) and (DijkstraTable[iteration][column].isConnected = True) and (DijkstraTable[iteration][column].isValidated = False) then
                        begin
                            DijkstraTable[iteration][column].comingFromStationIndex := comingFromStationIndex;
                            DijkstraTable[iteration][column].weight := get_Weight(get_Pointer_From_Absolute_Index(comingFromStationIndex),get_Absolute_Index_From_Station_Pointer(indexStationToConnect), Game.Stations);
                        end;
                end;
        // - Compare et détermine l'index de la station dont le poids est le plus faible. 
            minimum_Weight := 2203; //diagonale d'un écran 1920*1080
            for i := (low(DijkstraTable)) to (high(DijkstraTable)) do
                begin
                    for column:= (low(DijkstraTable)) to (high(DijkstraTable)) do
                        begin
                            if (DijkstraTable[i][column].isConnected = True) and (DijkstraTable[iteration][column].isValidated = False) and (DijkstraTable[iteration][column].isAvailable = True) Then
                                begin
                                    If DijkstraTable[i][column].weight < minimum_Weight then 
                                        begin
                                            minimum_Weight := DijkstraTable[i][column].weight;
                                            lightest_Station_Index := column;
                                        end;
                                    
                                end;
                        end;
                end;
            DijkstraTable[iteration+1][lightest_Station_Index] := DijkstraTable[iteration][lightest_Station_Index];
            DijkstraTable[iteration+1][lightest_Station_Index].isValidated := True;
            for i:= iteration to high(DijkstraTable) do //On peut également commencer la boucle à iteration+2.
                begin
                    DijkstraTable[i][lightest_Station_Index].isAvailable := False;
                end;
            comingFromStationIndex := lightest_Station_Index;
        end;
        SetLength(Itinerary_Indexes, high(DijkstraTable));
        Itinerary_Indexes[0] := Starting_Station_Index;
        k:= 1;
        for iteration:= low(DijkstraTable) to high(DijkstraTable) do
            begin
                for column := low(DijkstraTable) to high(DijkstraTable) do
                    If (DijkstraTable[iteration][column].isValidated := True) and (Itinerary_Indexes[k-1] <> DijkstraTable[iteration][column].comingFromStationIndex) then
                        begin
                            Itinerary_Indexes[k] := DijkstraTable[iteration][column].comingFromStationIndex;
                            k:= k + 1;  
                        end;
                       
            end;
end;


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
  Graphics_Load(Game);

  Randomize();

  Game.Quit := False;

  Game.Play_Pause_Button.State := true;

   // Défintion de la carte d'occupation des stations..
  SetLength(Game.Stations_Map, Game.Panel_Right.Size.X Div 64);
  For i := low(Game.Stations_Map) To high(Game.Stations_Map) Do
    Begin
      SetLength(Game.Stations_Map[i], Game.Panel_Right.Size.Y Div 64);
      For j := low(Game.Stations_Map[i]) To high(Game.Stations_Map[i]) Do
        Game.Stations_Map[i][j] := false;
    End;

  // Création des 5 premères stations
  For i := 1 To 6 Do
    Begin
      Station_Create(Game);
    End;

  // Création de la première ligne
  Line_Create(Game.Ressources.Palette[Color_Orange], Game, Game.Stations[low(Game.Stations)], Game.Stations[low(Game.Stations)+1]);


  For i := low(Game.Stations) + 2 To high(Game.Stations) Do
    Begin
      Line_Add_Station(@Game.Stations[i], Game.Lines[0]);
    End;

  For i := low(Game.Stations) To high(Game.Stations) Do
    Begin
      For j := 0 To Random(11) Do
        Begin
          Passenger_Create(Game.Stations[i], Game);
        End;
    End;

  Train_Create(Game.Lines[0].Stations[0], true, Game.Lines[0], Game);
  Train_Create(Game.Lines[0].Stations[2], false, Game.Lines[0], Game);

  Mouse_Load(Game);

End;

// Procédure qui décharge la logique en libérant la mémoire des objets alloués.
Procedure Logic_Unload(Var Game : Type_Game);

Var i,j,k,l : Byte;
Begin
  Graphics_Unload(Game);

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

// Rafraichissement de la logique.
Procedure Logic_Refresh(Var Game : Type_Game);

Var i, j : Integer;
  Event : TSDL_Event;
Begin
  // Vérifie les évènements.
  SDL_PollEvent(@Event);

  // Si l'utilisateur demande la fermeture du programme.

  Case Event.type_ Of 
    SDL_QUITEV :
                 Game.Quit := True;
    SDL_MOUSEBUTTONDOWN :
                          //Mouse_Event_Handler(Event, Game);
                          Mouse_Event_Handler(Event.button, Game);
    SDL_MOUSEBUTTONUP :
                        // writeln('click released');
                        Mouse_Event_Handler(Event.button, Game);
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

  Graphics_Refresh(Game);
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
  Train.Intermediate_Position_Distance := Graphics_Get_Distance(Train.Last_Station^.Position_Centered, Train.Intermediate_Position);

  // Calcul de la distance entre la station de départ et d'arrivée.

  Train.Maximum_Distance := Graphics_Get_Distance(Train.Last_Station^.Position_Centered, Train.Intermediate_Position);


  Train.Maximum_Distance := Train.Maximum_Distance +  Graphics_Get_Distance(Train.Intermediate_Position, Train.Next_Station^.Position_Centered);

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

  //  Chargement des passagers de la station dans le train.
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
  Label_Set(Train.Passengers_Label, IntToStr(k) + '/' + IntToStr(length(Train.Vehicles)*Vehicle_Maximum_Passengers_Number), Game.Ressources.Fonts[Font_Small][Font_Normal], Game.Ressources.Palette[
  Color_White]);


  // Désallocation de la queue.
  SetLength(Passengers_Queue, 0);

  // Le train peut repartir.
  Train.Driving := true;
End;



End.
