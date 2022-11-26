program dijkstra;

Type Type_Dijkstra_Cell = Record
//  connected_Station : Type_Station_Pointer;           (je crois que c'est inutile en fait)
    isConnected : Boolean;
    isAvailable : Boolean;
    comingFromStationIndex : Type_Station_Pointer;
    weight : Real;
    isValidated : Boolean;
End;

procedure Build_Graph_Table(Game : Type_Game);
var iteration, jiteration, kiteration : Integer;
    graph_Table : Array of Array of Array[0..Game_Maximum_Lines_Number-1]; // Un échiquier des stations dont la hauteur contient les lignes qui relient les dites stations.
Begin
    // Définit les dimensions de la graph_Table
    SetLength(graph_Table, length(Game.Stations));
    for iteration := low(graph_Table) to high(graph_Table) do
        begin
            SetLength(graph_Table[i], length(Game.stations));        
        end;

    for iteration := low(Game.Lines) to high(Game.Lines) do // Pour chacune des lignes :
        begin
            for jiteration:= low(Game.Lines.Stations) to high(Game.Lines.Stations) do
                begin
                    
                end;
        end;

    for iteration := low(Game.Stations) to high(Game.Stations) do
        begin
            for jiteration := low(Game.Stations) to high(Game.Stations) do
                begin
                    for kiteration := 0 to Game_Maximum_Lines_Number-1 do
                        begin
                            if 
                                graph_Table[iteration][jiteration][kiteration] :=                            
                        end;
 
                end;
        end;

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
