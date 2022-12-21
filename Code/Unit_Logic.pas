
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

Function Passenger_Get_Off(Passenger : Type_Passenger_Pointer; Var Next_Station : Type_Station) : Boolean;

Function Passenger_Get_On(Passenger : Type_Passenger_Pointer; Var Next_Station : Type_Station) : Boolean;

Procedure Logic_Event_Handler(Var Game : Type_Game);

Procedure Logic_Rewards(Var Game : Type_Game);

// - Définition des fonctions et des procédures.

Implementation

// - - Fonctions et procédures relatives au passagers 

Procedure Logic_Rewards(Var Game : Type_Game);

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

    // Si un des choix le joueur peut choisir une ligne,
    If (Rewards[0] = 0) Or (Rewards[1] = 0) Then
      Begin
        // On vérifie que le nombre de ligne n'a pas été dépassé.
        If (length(Game.Lines) >= Game_Maximum_Lines_Number) Then
          Begin
            // On refait le tirage le cas échéant.
            Random_Draw := false;
          End;
      End;
  Until Random_Draw = true;

  // - Définition de l'affichage des récompenses.

  // - - Affichage de la semaine.

  Label_Set_Text(Game.Title_Label, 'Week : ' + IntToStr(Time_Get_Elapsed(Game.Start_Time) Div (1000 * Game_Day_Duration * 7) + 1));
  Label_Pre_Render(Game.Title_Label);
  Game.Title_Label.Position.X := Get_Centered_Position(Game.Panel_Reward.Size.X, Game.Title_Label.Size.X);
  Game.Title_Label.Position.Y := 16;

  // - - Affichage du message.

  Label_Set_Text(Game.Message_Label, 'Choose your reward : ');
  Label_Pre_Render(Game.Message_Label);
  Game.Message_Label.Position.X := Get_Centered_Position(Game.Panel_Reward.Size.X, Game.Message_Label.Size.X);
  Game.Message_Label.Position.Y := Game.Title_Label.Position.Y + Game.Title_Label.Size.Y + 16;

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
              Button_Set(Game.Reward_Buttons[i], Game.Ressources.Train_Add, Game.Ressources.Train_Add)
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
              {writeln('Les stations d''index numero ',i,' et de numero ',j,' sont connectées à l''étape ', step);}
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

      If Game.Stations[i]^.Shape = Passenger^.Shape Then
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
      Weight := Weight + Get_Weight(Game.Stations[Itinerary_Indexes[i - 1]]^, Game.Stations[Itinerary_Indexes[i]]^);
    End;

  Itinerary_Get_Weight := Weight;

End;

Procedure Dijkstra(Starting_Station_Index : Integer; Ending_Station_Index : Integer; Var Itinerary_Indexes : Type_Itinerary_Indexes; Var Reverse_Itinerary_Indexes : Type_Itinerary_Indexes; Game :
                   Type_Game; Var Station_Is_Isolated : Boolean);

Var a, k, row, column, Step, indexStationToConnect, comingFromStationIndex, lightest_Station_Index, i, Previous_Index, j, Last_Step, lightest_Station_Step : Integer;
  minimum_Weight, Validated_Itinerary_Weight : Real;


Begin

  SetLength(Reverse_Itinerary_Indexes, 0);
  SetLength(Itinerary_Indexes, 0);

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
          Game.Dijkstra_Table[Step][j].comingFromStationIndex := 255;
        End;

      Game.Dijkstra_Table[Step][Starting_Station_Index].isAvailable := False;
    End;

  comingFromStationIndex := Starting_Station_Index;

  writeln('La station de départ est la station ',Starting_Station_Index,' et la station d''arrivée est la station ',Ending_Station_Index);

  // Met le poid de la station de départ à l'étape 0 à 0.
  Game.Dijkstra_Table[low(Game.Dijkstra_Table)][Starting_Station_Index].Weight := 0;

  // Définit la station de départ de l'étape 0 comme étant la station de départ (initénaire complet).
  Game.Dijkstra_Table[low(Game.Dijkstra_Table)][Starting_Station_Index].comingFromStationIndex := comingFromStationIndex;
  writeln('Ecriture manuelle de comingFromStationIndex = ', comingFromStationIndex,' aux coordonnées : ',low(Game.Dijkstra_Table),', ',Starting_Station_Index);


  // Met la station de départ comme étant validée (dans l'itinéraire final).
  Game.Dijkstra_Table[low(Game.Dijkstra_Table)][Starting_Station_Index].isValidated := True;

  Step := low(Game.Dijkstra_Table) {+ 1};
  // Pas completement certain du +1

  // - Résolution de l'itinéraire.

  While ((Step <= (high(Game.Dijkstra_Table))) And (Destination_Reached(Ending_Station_Index, Game.Dijkstra_Table)=False)) Do
    Begin

      Connect_Stations(Step, comingFromStationIndex, Game);

      For i := (low(Game.Dijkstra_Table[Step])) To (high(Game.Dijkstra_Table[Step])) Do
        Begin
          // Si la station est libre, connectée et non validée.
          If (Game.Dijkstra_Table[Step][i].isAvailable = True) And (Game.Dijkstra_Table[Step][i].isConnected = True) And (Game.Dijkstra_Table[Step][i].isValidated = False) Then
            Begin
              // TODO : Je ne suis pas fan de cette méthode, mais je ne vois pas comment faire autrement.
              Game.Dijkstra_Table[Step][i].comingFromStationIndex := comingFromStationIndex;
              writeln('Ecriture de comingFromStationIndex = ', comingFromStationIndex,' aux coordonnées : ',Step,', ',i);

              // on écrit d'où on vient dans la cell, comme on peut le voir sur la video d'Yvan

              // On effectue le calcul de poids.
              Game.Dijkstra_Table[Step][i].Weight := Validated_Itinerary_Weight + Get_Weight(Game.Stations[Game.Dijkstra_Table[Step][i].comingFromStationIndex]^, Game.Stations[i]^);
              //!\\ Attention : Manipule directement la station, pas le pointeur.
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
                      lightest_Station_Step := i;
                    End

                  Else If (Game.Dijkstra_Table[i][column].weight < minimum_Weight) Then
                         Begin
                           minimum_Weight := Game.Dijkstra_Table[i][column].weight;
                           lightest_Station_Index := column;
                           lightest_Station_Step := i;
                         End;

                End;
            End;
        End;

      If (Step = high(Game.Dijkstra_Table)) And Not(Destination_Reached(Ending_Station_Index, Game.Dijkstra_Table)) Then
        Begin
          Station_Is_Isolated := True;
        End
      Else
        Begin
          Station_Is_Isolated := False;
          Game.Dijkstra_Table[Step+1][lightest_Station_Index] := Game.Dijkstra_Table[lightest_Station_Step][lightest_Station_Index];
          Game.Dijkstra_Table[Step+1][lightest_Station_Index].isValidated := True;
          writeln('validation à ', Step+1,', ',lightest_Station_Index);
          Validated_Itinerary_Weight := Game.Dijkstra_Table[lightest_Station_Step][lightest_Station_Index].weight;
        End;



      // - Met à jour les stations disponibles.

      For i:= low(Game.Dijkstra_Table) To high(Game.Dijkstra_Table) Do
        //On peut également commencer la boucle à step+2.
        Begin
          Game.Dijkstra_Table[i][lightest_Station_Index].isAvailable := False;
        End;

      comingFromStationIndex := lightest_Station_Index;
      //    End;

      Step := Step + 1;
      If Step-1 = high(Game.Dijkstra_Table) Then
        Last_Step := Step-1
      Else
        Last_Step := Step;
      // Avant, cette ligne était avant step := step+1.
    End;




{if Last_Step = high(Game.Dijkstra_Table) then
  begin
    //writeln('je viens de rentrer dans la phase de correction du cas particulier, le lastStep vaut : ', Last_Step);
    For j := low(Game.Dijkstra_Table) To high(Game.Dijkstra_Table) Do
      Begin
        If Game.Dijkstra_Table[Last_Step][j].isValidated Then
          Begin
            Game.Dijkstra_Table[Last_Step][j].isValidated := False;
          end;
      end;
    For j := low(Game.Dijkstra_Table) To high(Game.Dijkstra_Table) Do
      Begin
        If Game.Dijkstra_Table[Last_Step-1][j].isValidated Then
          Begin
            //writeln('Je suis à la ligne ', Last_Step-1, ' et la colonne ', j);
            Game.Dijkstra_Table[Last_Step][Ending_Station_Index].comingFromStationIndex := j;
            Game.Dijkstra_Table[Last_Step][Ending_Station_Index].IsValidated := True;
            Game.Dijkstra_Table[Last_Step][Ending_Station_Index].isAvailable := False;
            Game.Dijkstra_Table[Last_Step][Ending_Station_Index].weight := Validated_Itinerary_Weight + Get_Weight(Game.Stations[Game.Dijkstra_Table[Last_Step][Ending_Station_Index].comingFromStationIndex]^, Game.Stations[Ending_Station_Index]^); //!\\ Attention : Manipule directement la station, pas le pointeur.
          end;
      end;  
     
  end;}

  SetLength(Reverse_Itinerary_Indexes, 1);
  {writeln('Taille de Reverse_Itinerary_Indexes',length(Reverse_Itinerary_Indexes));}
  Reverse_Itinerary_Indexes[high(Reverse_Itinerary_Indexes)] := Ending_Station_Index;
  For j := low(Game.Dijkstra_Table) To high(Game.Dijkstra_Table) Do
    Begin
    {writeln('IsValidated à la case ',Last_Step,', ',j,' vaut : ',Game.Dijkstra_Table[Last_Step][j].isValidated);}
    End;

  For j := low(Game.Dijkstra_Table) To high(Game.Dijkstra_Table) Do
    Begin
      If Game.Dijkstra_Table[Last_Step][j].isValidated Then
        Begin
          {Reverse_Itinerary_Indexes[high(Reverse_Itinerary_Indexes)] := Ending_Station_Index;}


// On a correctement identifié la dernière étape, on peut alors commencer la remontée en écrivant l'index de la station d'arrivée. Le 'comingFrom' de la dernière cell nous indique l'étape précédente.   
          Previous_Index := Game.Dijkstra_Table[Last_Step][j{+1}].comingFromStationIndex;


{writeln('Le premier PreviousIndex vaut : ',Previous_Index,' Il s''agit du comingFromStationIndex de la case Step = ',Last_Step,' colonne : ',j);
          writeln('Contenu de la premiere case de Reverse_Itinerary_Indexes : ',Reverse_Itinerary_Indexes[low(Reverse_Itinerary_Indexes)]);}
        End;
    End;


  If (Previous_Index <> Starting_Station_Index) Then
    Begin
      Repeat
        // Rajoute une case a RII
        SetLength(Reverse_Itinerary_Indexes, length(Reverse_Itinerary_Indexes) + 1);

        writeln('Taille de Reverse_Itinerary_Indexes : ',length(Reverse_Itinerary_Indexes));

        Reverse_Itinerary_Indexes[high(Reverse_Itinerary_Indexes)] := Previous_Index;

        writeln('Contenu de la case qu''on vient d'' ajouter : ',Reverse_Itinerary_Indexes[high(Reverse_Itinerary_Indexes)]);

        writeln(' etape actuelle : ', Last_Step - high(Reverse_Itinerary_Indexes), ' previous index : ', Previous_Index);

        {writeln('Ancien PreviousIndex : ',Previous_Index);}

      {
        If (Last_Step - high(Game.Dijkstra_Table)) < 0 Then
        begin
          writeln('!!!!!!!!!!!!!! EXTERMINATION !!!!!!!!!!!!!!!!!');
          Break;
        end;
}
        If Previous_Index = 255 Then
          Begin
            writeln('!!!!!!!!!!!!!! DOUBLE EXTERMINATION !!!!!!!!!!!!!!!!!');
            Previous_Index := Starting_Station_Index;
            Reverse_Itinerary_Indexes[high(Reverse_Itinerary_Indexes)] := Starting_Station_Index;
            Step := 0;
            Break;
          End;

        Previous_Index := Game.Dijkstra_Table[Last_Step - high(Reverse_Itinerary_Indexes)][Previous_Index].comingFromStationIndex;

        {writeln('Nouveau PreviousIndex : ',Previous_Index);}

      Until Reverse_Itinerary_Indexes[high(Reverse_Itinerary_Indexes)] = Starting_Station_Index;
    End;

  writeln('Reverse itinerary indexes :');

  For j := low(Reverse_Itinerary_Indexes) To high(Reverse_Itinerary_Indexes) Do
    Begin
      writeln(j, ' : ', Reverse_Itinerary_Indexes[j]);
    End;
  {writeln('taille de reverse_itinerary_indexes', length(reverse_itinerary_indexes));}


  SetLength(Itinerary_Indexes, length(Reverse_Itinerary_Indexes));



 //Inverse le tableau pour obtenir l'itinéaire.
  For i:= high(Reverse_Itinerary_Indexes) Downto low(Reverse_Itinerary_Indexes) Do
    Begin
      Itinerary_Indexes[high(Reverse_Itinerary_Indexes)-i] := Reverse_Itinerary_Indexes[i];
      writeln('indice d''itinerary indexes : ', high(Reverse_Itinerary_Indexes)-i);
      writeln('indice de reverse itinerary indexes : ', i);
    End;

  {For i := low(Reverse_Itinerary_Indexes) To high(Reverse_Itinerary_Indexes) Do
    // On se rend compte plus tard de l'utilité de garder sous forme reverse
    Begin
      Itinerary_Indexes[i] := Reverse_Itinerary_Indexes[i];
    End;}



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
  Index_Table_Of_Same_Shape, Itinerary_Indexes, Reverse_Itinerary_Indexes : Type_Itinerary_Indexes;
  Lowest_Weight, m : Integer;
  Shortest_Itinerary_Indexes : Type_Itinerary_Indexes;
  Station_Is_Isolated : Boolean;
  Suce : Integer;
Begin

  Suce := 0;

  // Itère parmi les stations.
  For i:= low(Game.Stations) To high(Game.Stations) Do
    // Parcourt toutes les stations pour ensuite parcourir les passagers contenus dans ces stations
    Begin
      If (length(Game.Stations[i]^.Passengers) > 0) Then
        Begin
          // Itère parmi les passagers d'une station.
          For j:= low(Game.Stations[i]^.passengers) To high(Game.Stations[i]^.passengers) Do
            // Parcourt les passagers de la station
            Begin

              writeln(' Passenger pos : ', i, ' - ', j);

              inc(Suce);

              writeln('!!!!!!!!!!!!!!!!!!!!!!!!! Passagers en train d etre sucee : ', Suce);

              // Détermine les stations de destination possible pour un passager.
              Get_Ending_Stations_From_Shape(Game, Game.Stations[i]^.Passengers[j], Index_Table_Of_Same_Shape);


              writeln(' Passenger shape : ', Game.Stations[i]^.Passengers[j]^.Shape);

              // 
              For k := low(Index_Table_Of_Same_Shape) To high(Index_Table_Of_Same_Shape) Do
                Begin
                  writeln(' Dest station shape : ', Game.Stations[Index_Table_Of_Same_Shape[k]]^.Shape);
                  {If Index_Table_Of_Same_Shape[k] < i Then
                    Begin
                      Dijkstra(Index_Table_Of_Same_Shape[k], i, Itinerary_Indexes, Reverse_Itinerary_Indexes, Game, Station_Is_Isolated);
                      writeln('J''ai été inversé !!!');
                      writeln('suis je isoléee ? ',Station_Is_Isolated);
                    End
                  Else if Index_Table_Of_Same_Shape[k] = i Then
                         Begin
                           writeln('!!!!!!!!!!!!!!!!!!! Je suis pareil !!!!!!!!!!!!!!!!!!!!!!!!!!!');

                         End
                  Else}
                    //Begin
                      Dijkstra(i, Index_Table_Of_Same_Shape[k], Itinerary_Indexes, Reverse_Itinerary_Indexes, Game, Station_Is_Isolated);
                   // End;

                  writeln('length Dij :  ', length(Itinerary_Indexes));



{writeln(' Solution ', k, ' de Dijkstra  : ');
                  For l := low(Itinerary_Indexes) To high(Itinerary_Indexes) Do
                    Begin
                      writeln('S : ', Itinerary_Indexes[l]);
                    End;

                  writeln('Weight : ', Itinerary_Get_Weight(Game, Itinerary_Indexes));}

                  If k = low(Index_Table_Of_Same_Shape) Then
                    Begin
                      Lowest_Weight := Itinerary_Get_Weight(Game, Itinerary_Indexes);
                      Shortest_Itinerary_Indexes := copy(Itinerary_Indexes, low(Itinerary_Indexes), length(Itinerary_Indexes));
                    End
                  Else If (Itinerary_Get_Weight(Game, Itinerary_Indexes) < Lowest_Weight) Then
                         Begin
                           Lowest_Weight := Itinerary_Get_Weight(Game, Itinerary_Indexes);
                           // Copie dans l'itinéraire le plus court.
                          {writeln('length(Itinerary_Indexes) : ',length(Itinerary_Indexes));}
                           SetLength(Shortest_Itinerary_Indexes, length(Itinerary_Indexes));
                           Shortest_Itinerary_Indexes := copy(Itinerary_Indexes, low(Itinerary_Indexes), length(Itinerary_Indexes));
                           For m := low(Itinerary_Indexes) To high(Itinerary_Indexes) Do
                             Begin
                               Shortest_Itinerary_Indexes[m] := Itinerary_Indexes[m];
                             End;

                         End;

                End;

              // - Conversion de l'itinéraire en pointeurs de stations.

              writeln('Length Shortest_Itinerary_Indexes : ', length(Shortest_Itinerary_Indexes));
              writeln('Passenger shape : ', Game.Stations[i]^.Passengers[j]^.Shape);

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

Function Passenger_Get_Off(Passenger : Type_Passenger_Pointer; Var Next_Station : Type_Station) : Boolean;

Var i : Byte;

Begin
Passenger_Get_Off := True;
for i := low(Passenger^.Itinerary) to high(Passenger^.Itinerary) do
  begin
    if @Next_Station = Passenger^.Itinerary[i] then
      begin
        Passenger_Get_Off := False;
        writeln('Descendre ? ', Passenger_Get_Off);
      end;
    {else
      Begin
        Passenger_Get_Off := True;    
        writeln('Descendre ? ', Passenger_Get_Off);  
      End;}
  end;
end;

    {if Passenger^.Itinerary[low(Passenger^.itinerary)+1] = @Next_Station then
    begin
      Passenger_Get_Off := False;
      writeln('Descendre ? ', Passenger_Get_Off);
    end
    else if Passenger^.Itinerary[low(Passenger^.itinerary)] = @Next_Station then
    begin
      Passenger_Get_Off := False;
      writeln('Descendre ? ', Passenger_Get_Off);
    end
    else
    begin
      Passenger_Get_Off := True;
      writeln('Descendre ? ', Passenger_Get_Off);
    end;}

  {If (Passenger^.Itinerary[high(Passenger^.Itinerary)] = @Current_Station) Then
    Passenger_Get_Off := True
  Else
    Passenger_Get_Off := False;}

  {If (length(Passenger^.Itinerary) > 0) Then
    SetLength(Passenger^.Itinerary, length(Passenger^.Itinerary)-1);}


{
  If random(2) = 0 Then
    Passenger_Get_Off := True
  Else
    Passenger_Get_Off := False;
}

Function Passenger_Get_On(Passenger : Type_Passenger_Pointer; Var Next_Station : Type_Station) : Boolean;
Var i : Byte;
Begin

  {for i := low(Passenger^.Itinerary) to high(Passenger^.Itinerary) do
    Begin
    begin
      if Passenger^.Itinerary[i+1] = @Next_Station then
        begin
          writeln('Passenger^.Itinerary[i+1] Shape : ', Passenger^.Itinerary[i+1]^.Shape);
          writeln('Next_Station Shape : ', Next_Station.Shape);
          Passenger_Get_On := True;
        end
      else
        begin
          Passenger_Get_On := False;
        end;
    end;}

      writeln('====================================');

      writeln(' Passenger shape : ', Passenger^.Shape);
      writeln('Next station shape = ', Next_Station.Shape);
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
      end;
  
  {For i := low(Passenger^.Itinerary) To high(Passenger^.Itinerary) Do
    Begin
      If (Passenger^.Itinerary[i] = @Next_Station) Then
        Passenger_Get_On := True
      Else
        Passenger_Get_On := False;
    End;}

  For i := low(Passenger^.itinerary) To high(Passenger^.Itinerary) Do
  Begin
    writeln(' Itinerary : ', Passenger^.Itinerary[i]^.Shape);
  End;


{
  If random(2) = 0 Then
    Passenger_Get_On := True
  Else
    Passenger_Get_On := False;
}
End;

// - - Fonctions et procédures relatives à la logique générale.

// Procédure qui charge la logique.
Procedure Logic_Load(Var Game : Type_Game);

Var i,j : Byte;
  Total : Integer;
Begin


  Randomize();

  Graphics_Load(Game);

  Sounds_Load(Game);

  Sounds_Set_Volume(Sounds_Maximum_Volume);

  Sounds_Play(Game.Ressources.Music);

  Game.Start_Time := Time_Get_Current();

  Game.Play_Pause_Button.State := True;

  Game.Player.Locomotive_Token := 1;
  Game.Player.Tunnel_Token := 1;
  Game.Player.Wagon_Token := 1;
  Game.Player.Score := 0;

  Game.Day := Day_Monday;

  Game.Stations_Timer := Time_Get_Current() + 25000;

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


  For i := low(Game.Stations) To high(Game.Stations) Do
    Begin
      Line_Add_Station(Game.Stations[i], Game.Lines[0], Game);
    End;


  Game_Refresh_Graph_Table(Game);



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


  Total := 0;

  For i := low(Game.Stations) To high(Game.Stations) Do
    Begin
      For j := 0 To 2 Do
        Begin
          inc(Total);
          Passenger_Create(Game.Stations[i]^, Game);
        End;
    End;

  writeln('!!!!!!!!!!!!!! NB DE PASSAGER A SUCER : ', Total);

  Passenger_Create(Game.Stations[0]^, Game);


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

      Stations_Delete(Game);

      // TODO : Suppresion des stations.
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
                            Passenger_Delete(Game.Lines[i].Trains[j].Vehicles[k].Passengers[l]);
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
                       Logic_Unload(Game);
                       HALT();
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
              // Passenger_Create(Game.Stations[Random(high(Game.Stations) + 1)], Game);

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

          Station_Create(Game);

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
          If (length(Game.Stations[i]^.Passengers) > Station_Overfill_Passengers_Number) Then
            Begin
              // Si la station n'est pas encombré avant la dernière vérification.
              If (Game.Stations[i]^.Overfill_Timer = 0) Then
                // On démare le timer de la station.
                Game.Stations[i]^.Overfill_Timer := Time_Get_Current()
                                                    // Si la station était encombré avant la dernière vérification et que son timer est dépassé.
              Else If (Time_Get_Elapsed(Game.Stations[i]^.Overfill_Timer) > Station_Overfill_Timer * 1000) Then
                     // La partie est terminée.
              ;
              // TODO : Faire écran de game over.
            End
          Else
            Game.Stations[i]^.Overfill_Timer := 0;
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
  Maximum_Distance : Integer;
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
              Else If (Passenger_Get_Off(Train.Vehicles[i].Passengers[j], Train.Next_Station^)) Then
                     Begin
                       // Copie du pointeur du passager dans le tampon.
                       writeln('Le passager ',Train.Vehicles[i].Passengers[j]^.Shape,' vient de descendre');
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
                          writeln('Le passager ', Train.Last_Station^.Passengers[k]^.Shape, ' est monté dans le train');
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


  // Calcul de la distance entre la station de départ et d'arrivée.

  Maximum_Distance := Get_Distance(Train.Last_Station^.Position_Centered, Train.Intermediate_Position) + Get_Distance(Train.Intermediate_Position, Train.Next_Station^.Position_Centered);


  Train.Deceleration_Time := ((Maximum_Distance - (Train_Acceleration_Time * Train_Maximum_Speed)) / Train_Maximum_Speed) + Train_Acceleration_Time;

  writeln('Train.Deceleration_Time : ', Train.Deceleration_Time);
  writeln('Train max distance : ', Maximum_Distance);



  // Le train peut repartir.
  Train.Driving := true;
End;

End.
