
Unit Unit_Logic;

Interface

// - Inclut les unités internes au projet. 

Uses Unit_Types, Unit_Graphics;

// - Déclaration des fonctions et procédures.

// - - Logique générale.
Procedure Logic_Load(Var Game : Type_Game);

Procedure Logic_Refresh(Var Game : Type_Game);

Procedure Train_Connection(Var Line : Type_Line; Var Train : Type_Train);

Function Passenger_Get_Off(Passenger : Type_Passenger; Var Current_Station : Type_Station) : Boolean;

Function Passenger_Get_On(Passenger : Type_Passenger; Var Next_Station : Type_Station) : Boolean;

// - Définition des fonctions et des procédures.

Implementation

// - - Fonctions et procédures relatives au passagers 

Function Passenger_Get_Off(Passenger : Type_Passenger; Var Current_Station : Type_Station) : Boolean;

Begin
  If random(2) = 0 Then
    Passenger_Get_Off := True
  Else
    Passenger_Get_Off := False;
End;

Function Passenger_Get_On(Passenger : Type_Passenger; Var Next_Station : Type_Station) : Boolean;
Begin
  If random(2) = 0 Then
    Passenger_Get_On := True
  Else
    Passenger_Get_On := False;
End;

// - - Fonctions et procédures relatives à la logique générale.

// Procédure qui charge la logique.
Procedure Logic_Load(Var Game : Type_Game);
Begin
  Randomize();

  Game.Quit := False;

  // Création des 5 premères stations
  For i := 1 To 5 Do
    Begin
      Station_Create(Game);
    End;

  // Création de la première ligne
  Line_Create(Game.Ressources.Palette[Color_Black], Game);
  
  For i := low(Game.Stations) To high(Game.Stations) Do
    Begin
      For j := 0 To 5 {Random(5)} Do
        Begin
          Passenger_Create(Game.Stations[i], Game);
        End;
      Line_Add_Station(@Game.Stations[i], Game.Lines[0]);

    End;



  Train_Create(Game.Lines[0].Stations[0], true, Game.Lines[0], Game);

  Game.Lines[0].Trains[0].Next_Station := Game.Lines[0].Stations[1];

  Game.Lines[0].Trains[0].Distance := 0;

End;

// Rafraichissement de la logique.
Procedure Logic_Refresh(Var Game : Type_Game);

Var i, j : Integer;
    Event : TSDL_Event;
Begin
  // Vérifie les évènements.
  SDL_PollEvent(@Event);

  // Si l'utilisateur demande la fermeture du programme.
  If (Event.type_ = SDL_QUITEV) Then
    Game.Quit := True
  // Si la souris est pressé.
  Else If ((Event.type_ = SDL_MOUSEBUTTONDOWN) Or (Event.type_ = SDL_MOUSEBUTTONUP)) Then
         Begin
           Mouse_Event_Handler(Event, Game);
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

          Train.Maximum_Distance := Train.Maximum_Distance + Graphics_Get_Distance(Train.Last_Station^.Position, Station_Get_Intermediate_Position(Train.Last_Station^.Position, Train.Next_Station^.
                                    Position)) + Graphics_Get_Distance(Train.Next_Station^.Position, Station_Get_Intermediate_Position(Train.Last_Station^.Position, Train.Next_Station^.Position));
          // On quitte la boucle.
          Break;
        End;
    End;

  For i := low(Train.Vehicles) To high(Train.Vehicles) Do
    Begin
      // Déchargement des passagers qui doivent descendre du train dans le tampon.
      For j := 0 To Vehicle_Maximum_Passengers_Number - 1 Do
        Begin
          If (Train.Vehicles[i].Passengers[j] <> Nil) Then
            Begin

              // Si le passager doit descendre du train, son pointeur est déplacé dans le tampon.
              If (Passenger_Get_Off(Train.Vehicles[i].Passengers[j]^, Train.Last_Station^)) Then
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
                  For k := low(Train.Last_Station^.Passengers) To high(Train.Last_Station^.Passengers) Do
                    Begin
                      writeln('length(Train.Last_Station^.Passengers) : ', length(Train.Last_Station^.Passengers));
                      writeln('k : ', k);
                      If (Train.Last_Station <> Nil) Then
                        writeln('Station');
                      If (Train.Last_Station^.Passengers[k] <> Nil) Then
                        writeln('Passager');
                      // Si le passager doit monter dans le train, son pointeur est déplacé dans le train.
                      If (Passenger_Get_On(Train.Last_Station^.Passengers[k]^, Train.Last_Station^)) Then
                        Begin
                          writeln('Passager monte dans le train');
                          // Copie du pointeur du passager dans le train.
                          Train.Vehicles[i].Passengers[j] := Train.Last_Station^.Passengers[k];
                          // Réinitialisation du pointeur du passager dans la station.
                          Train.Last_Station^.Passengers[k] := Train.Last_Station^.Passengers[high(Train.Last_Station^.Passengers)];
                          SetLength(Train.Last_Station^.Passengers, length(Train.Last_Station^.Passengers) - 1);
                        End;
                    End;
                End;
            End;
        End;
    End;

  // Déchargement de la queue dans la station.
  For i := low(Train.Last_Station^.Passengers) To high(Train.Last_Station^.Passengers) Do
    Begin
      SetLength(Train.Last_Station^.Passengers, length(Train.Last_Station^.Passengers) + 1);
      Train.Last_Station^.Passengers[high(Train.Last_Station^.Passengers)] := Passengers_Queue[i];
      SetLength(Passengers_Queue, length(Passengers_Queue) - 1);
    End;

  // Le train peut repartir.
  Train.Driving := true;
End;

End.
