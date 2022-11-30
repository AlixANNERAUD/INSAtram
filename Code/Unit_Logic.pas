
Unit Unit_Logic;

Interface

// - Inclut les unités internes au projet. 

Uses Unit_Types, Unit_Graphics, sdl, Unit_Mouse;

// - Déclaration des fonctions et procédures.

// - - Logique générale.
Procedure Logic_Load(Var Game : Type_Game);

Procedure Logic_Unload(Var Game : Type_Game);

Procedure Logic_Refresh(Var Game : Type_Game);

Procedure Train_Connection(Var Line : Type_Line; Var Train : Type_Train);

Function Passenger_Get_Off(Passenger : Type_Passenger_Pointer; Var Current_Station : Type_Station) : Boolean;

Function Passenger_Get_On(Passenger : Type_Passenger_Pointer; Var Next_Station : Type_Station) : Boolean;

// - Définition des fonctions et des procédures.

Implementation

// - - Fonctions et procédures relatives au passagers 





{
program dijkstra;

Type Type_Dijkstra_Cell = Record
//  connected_Station : Type_Station_Pointer;           (je crois que c'est inutile en fait)
    isConnected : Boolean;
    isAvailable : Boolean;
    comingFromStationIndex : Type_Station_Pointer;
    weight : Real;
    isValidated : Boolean;
End;

procedure Connect_Stations(rowToFill : Integer; indexStationToConnect : Integer; GraphTable : TypeGraphTable; Var DijkstraTable : Array Of Type_Dijkstra_Cell) // TypeGraphTable plutot que Type_Line parce que dans chaque case il y aura une record avec plusieurs lignes + la station avec laquelle la premiere station est reliée
Var i : Integer;
begin
    for i := low(GraphTable) to high(GraphTable) do
        begin
            if GraphTable[indexStationToConnect][i] <> NIL then     // Vérifie qu'une ligne relie bien les deux stations, i étant l'index de la deuxieme station.
                begin
                    if DijkstraTable[rowToFill][i].isAvailable = True then      // Vérifie que Dijkstra n'a pas interdit de retourner sur cette case.
                        begin
                            DijkstraTable[rowToFill][i].isConnected := True;        // Permet à Dijkstra de savoir s'il doit considérer cette station en particulier dans son calcul d'itinéraire.
//                          DijkstraTable[rowToFill][i].connected_Station := GraphTable[indexStationToConnect][i].connected_Station         (je crois que c'est inutile en fait)
                        end;
                end
            else
                begin
                    DijkstraTable[rowToFill][i].isConnected := False;
                end;
            i := i+1;
        end;
end;

procedure Dijkstra(Starting_Station_Index : Integer; Ending_Station_Index : Integer; Var DijkstraTable : Array Of Type_Dijkstra_Cell; GraphTable : TypeGraphTable)
Var row, column, iteration, indexStationToConnect, comingFromStationIndex : Integer;
begin
    indexStationToConnect := Starting_Station_Index;

    for row := low(DijkstraTable) to high(DijkstraTable) do
        begin
            for column := low(DijkstraTable) to high(DijkstraTable) do
                begin
                    DijkstraTable[i][j].isAvailable := True;            // Les cases sont a priori toutes disponibles avant d'être passé dessus.
                    column := column +1;
                end;
            row := row +1;
        end;
    
    comingFromStationIndex := Starting_Station_Index
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
            Connect_Stations(iteration, indexStationToConnect, GraphTable, DijkstraTable);
            for column := (low(DijkstraTable)) to (high(DijkstraTable)) do
                begin
                    if (DijkstraTable[iteration][column].isAvailable = True) and (DijkstraTable[iteration][column].isConnected = True) and (DijkstraTable[iteration][column].isValidated = False) then
                        begin
                            DijkstraTable[iteration][column].comingFromStationIndex := comingFromStationIndex;
                            DijkstraTable[iteration][column].weight := //TODO une fonction qui sort le poids d'une connection en sachant la station de départ et d'arrivée.
                        end;
                end;
        end;
end;
}

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

  Game.Quit := False;

  // Création des 5 premères stations
  For i := 1 To 5 Do
    Begin
      Station_Create(Game);
    End;

  // Création de la première ligne
  Line_Create(Game.Ressources.Palette[Color_Black], Game, Game.Stations[low(Game.Stations)], Game.Stations[low(Game.Stations)+1]);



  For i := low(Game.Stations) + 2 To high(Game.Stations) Do
    Begin
      Line_Add_Station(@Game.Stations[i], Game.Lines[0]);
    End;

  For i := low(Game.Stations) To high(Game.Stations) Do
    Begin
      For j := 0 To Random(5) Do
        Begin
          Passenger_Create(Game.Stations[i], Game);
        End;
    End;

  Train_Create(Game.Lines[0].Stations[0], true, Game.Lines[0], Game);

  Game.Lines[0].Trains[0].Next_Station := Game.Lines[0].Stations[1];

  Game.Lines[0].Trains[0].Last_Station := Game.Lines[0].Stations[0];

  Game.Lines[0].Trains[0].Driving := true;

  Game.Lines[0].Trains[0].Distance := 0;

  Train_Compute_Maximum_Distance(Game.Lines[0].Trains[0], Game.Lines[0]);

End;

// Procédure qui décharge la logique en libérant la mémoire des objets alloués.
Procedure Logic_Unload(Var Game : Type_Game);
Begin


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
                  Train_Connection(Game.Lines[i], Game.Lines[i].Trains[j]);
                End;
            End;
        End;
    End;

  Graphics_Refresh(Game);
End;

// Fonction qui effectue la correspondance du train arrivé à quais et change les attributs du trains pour sa prochaine destination.
Procedure Train_Connection(Var Line : Type_Line; Var Train : Type_Train);

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
            Train.Next_Station := Line.Stations[i + 1]
                                  // Si le train est dans le sens indirect (index des stations décroissant).
          Else
            Train.Next_Station := Line.Stations[i - 1];

          // On quitte la boucle.
          Break;
        End;
    End;

  // Calcul de la distance maximale.
  Train_Compute_Maximum_Distance(Train, Line);

  // Itère parmis les véhicules du train.
  For i := low(Train.Vehicles) To high(Train.Vehicles) Do
    Begin
      // Déchargement des passagers qui doivent descendre du train dans le tampon.
      For j := 0 To Vehicle_Maximum_Passengers_Number - 1 Do
        Begin
          If (Train.Vehicles[i].Passengers[j] <> Nil) Then
            Begin

              // Si le passager doit descendre du train, son pointeur est déplacé dans le tampon.
              If (Passenger_Get_Off(Train.Vehicles[i].Passengers[j], Train.Last_Station^)) Then
                Begin
                  // Copie du pointeur du passager dans le tampon.
                  SetLength(Passengers_Queue, length(Passengers_Queue) + 1);
                  Passengers_Queue[high(Passengers_Queue)] := Train.Vehicles[i].Passengers[j];
                  // Réinitialisation du pointeur du passager dans le train.
                  Train.Vehicles[i].Passengers[j] := Nil;
                End;
              // Suppression des passagers arrivés à destination.
              If (Train.Vehicles[i].Passengers[j]^.Shape = Train.Last_Station^.Shape) Then
                Passenger_Delete(Train.Vehicles[i].Passengers[j]);
            End;
        End;
    End;

  // Vérifie si la station contient des passagers.
  If (length(Train.Last_Station^.Passengers) > 0) Then
    Begin
      //  Chargement des passagers de la station dans le train.
      For i := low(Train.Vehicles) To high(Train.Vehicles) Do
        Begin
          For j := 0 To Vehicle_Maximum_Passengers_Number - 1 Do
            Begin
              // Le pointeur (donc la place) est vide.
              If (Train.Vehicles[i].Passengers[j] = Nil) Then
                Begin
                  // Itère parmis les passagers de la station.
                  writeln('j : ', j);
                  For k := low(Train.Last_Station^.Passengers) To high(Train.Last_Station^.Passengers) Do
                    Begin
                      writeln('k  : ', k);
                      //writeln('Passengers shape :', Train.Last_Station^.Passengers[k]^.Shape);
                      // Si le passager doit monter dans le train, son pointeur est déplacé dans le train.
                      If (Passenger_Get_On(Train.Last_Station^.Passengers[k], Train.Next_Station^)) Then
                        Begin
                          writeln('Passenger shape : ', Train.Last_Station^.Passengers[k]^.Shape);
                          // Copie du pointeur du passager dans le train.
                          Train.Vehicles[i].Passengers[j] := Train.Last_Station^.Passengers[k];
                          // Remplacement du pointeur du passager avec le dernier afin de diminuer la taille du tableau.
                          Train.Last_Station^.Passengers[k] := Train.Last_Station^.Passengers[high(Train.Last_Station^.Passengers)];
                          // Diminution de la taille du tableau.
                          SetLength(Train.Last_Station^.Passengers, length(Train.Last_Station^.Passengers) - 1);
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
  // Désallocation de la queue.
  SetLength(Passengers_Queue, 0);

  // Le train peut repartir.
  Train.Driving := true;
End;



End.
