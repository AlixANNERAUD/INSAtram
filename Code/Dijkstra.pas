program dijkstra;

Type Type_Dijkstra_Cell = Record
//  connected_Station : Type_Station_Pointer;           (je crois que c'est inutile en fait)
    isConnected : Boolean;
    isAvailable : Boolean;
    comingFromStationIndex : Type_Station_Pointer;
    weight : Real;
    isValidated : Boolean;
End;

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

function get_Pointer_From_Absolute_Index(Index : Integer; Stations : Array of Type_Station_Pointer);
begin
    get_Pointer_From_Absolute_Index := @Stations[Index];
end;

procedure Build_Graph_Table(Game : Type_Game);
var iteration, jiteration, kiteration, absolute_Index_First_Station, absolute_Index_Second_Station : Integer;
    couple_Stations : array[0..1] of Type_Station_Pointer; // Tableau temporaire dans lequel stocker les pointeurs des stations à relier dans la table une fois prélevées dans le tableau de pointeur de station de chaque ligne.
    graph_Table : Array of Array of Array[0..Game_Maximum_Lines_Number-1]; // Un échiquier des stations dont la hauteur contient les lignes qui relient les dites stations.
Begin
    // Définit les dimensions de la graph_Table
    SetLength(graph_Table, length(Game.Stations));
    for iteration := low(graph_Table) to high(graph_Table) do
        begin
            SetLength(graph_Table[i], length(Game.stations));        
        end;

    for iteration := low(Game.Stations) to high(Game.Stations) do // Initialise toutes les connections à NIL
        begin
            for jiteration := low(Game.Stations) to high(Game.Stations) do
                begin
                    for kiteration := low(Game.Lines) to high(Game.Lines) do
                        begin
                            graph_Table[iteration][jiteration][kiteration] := NIL;
                        end;
                end;
        end;

    for iteration := low(Game.Lines) to high(Game.Lines) do // Pour chacune des lignes :
        begin
            for jiteration:= low(Game.Lines.Stations) to (high(Game.Lines.Stations)-1) do // Pour chacune des stations consécutivement connectées contenues dans le tableau :
                begin
                    if (Game.Lines.Stations[jiteration] <> NIL) then // Au début de la partie il y a des chances pour que certaines lignes soient vides, il ne faut pas accéder à cet emplacement mémoire s'il ne contient pas un pointeur sur station.
                    begin
                    couple_Stations[0]:=Game.Lines.Stations[jiteration];
                    couple_Stations[1]:=Game.Lines.Stations[jiteration+1];
                    absolute_Index_First_Station := get_Absolute_Index_From_Station_Pointer(couple_Stations[0], Game.Stations); // Je pense qu'on pourrait directement mettre la fonction en tant qu'index pour graph_Table mais pour la compréhension je trouve ca mieux comme ca, surtout si on relit le code dans longtemps.
                    absolute_Index_Second_Station := get_Absolute_Index_From_Station_Pointer(couple_Stations[1], Game.Stations);
                    graph_Table[absolute_Index_First_Station][absolute_Index_Second_Station][iteration] := Game.Lines[iteration];
                    graph_Table[absolute_Index_Second_Station][absolute_Index_First_Station][iteration] := Game.Lines[iteration]; // La graphTable est symétrique (l'axe étant sa diagonale)
                    end;
                end;
        end;

End;

procedure Connect_Stations(rowToFill : Integer; indexStationToConnect : Integer; GraphTable : TypeGraphTable; Var DijkstraTable : Array Of Type_Dijkstra_Cell) // TypeGraphTable plutot que Type_Line parce que dans chaque case il y aura une record avec plusieurs lignes + la station avec laquelle la premiere station est reliée
Var i, iteration_Lines : Integer;
begin
    for i := low(GraphTable) to high(GraphTable) do
        begin
            iteration_Lines := low(Game.Lines);
            repeat
                if GraphTable[indexStationToConnect][i][iteration_Lines] <> NIL then     // Vérifie qu'une ligne relie bien les deux stations, i étant l'index de la deuxieme station.
                    begin
                        if DijkstraTable[rowToFill][i].isAvailable = True then      // Vérifie que Dijkstra n'a pas interdit de retourner sur cette case.
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
