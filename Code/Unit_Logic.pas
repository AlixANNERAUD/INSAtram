
Unit Unit_Logic;

Interface

// - Inclut les unités internes au projet. 

Uses Unit_Types, Unit_Graphics;

// - Déclaration des fonctions et procédures.

// - - Logique générale.
Procedure Logic_Load(Var Game : Type_Game);

Procedure Logic_Refresh(Var Game : Type_Game);

Procedure Passengers_Exchange(Var Train : Type_Train);

Procedure Train_Drive(Var Train : Type_Train, Line : Type_Line);

Implementation

// - Définition des fonctions et des procédures.

// - - Fonctions et procédures relatives à la logique générale.

// Initialise la partie 
Procedure Logic_Load(Var Game : Type_Game);
Begin
  Randomize();
End;

// Rafraichissement de la logique.
Procedure Logic_Refresh(Var Game : Type_Game);

Var i, j : Integer;
Begin
  // - Détecte les trains arrivés à quais.
  If (length(Game.Lines) > 0) Then
    Begin
      For i := low(Game.Lines) To high(Game.Lines) Do
        Begin
          For j := low(Game.Lines[i].Trains) To high(Game.Lines[i].Trains) Do
            Begin
              Begin
                If (Game.Lines[i].Trains[j].Driving = false) Then
                  Begin
                    Passengers_Exchange(Game.Lines[i].Trains[j]);
                    Train_Drive(Game.Lines[i].Trains[j], Game.Lines[i].Trains[j]);
                  End;
              End;
            End;
        End;
    End;

End;

Procedure Passengers_Exchange(Var Train : Type_Train);

Var i, k, Maximum : Byte;
  Passengers_Queue : Array[0 .. 5] Of Type_Passenger_Pointer;
  Passengers_Queue_Size : Integer;
Begin

  For k := low(Train.Vehicles) To high(Train.Vehicles) Do
    Begin
      If (length(Train.Vehicles[k].Passengers) > 0) Then
        Begin
          Passengers_Queue_Size := 0;
          // Déchargement des passagers du train dans le tampon.
          For i:= low(Train.Vehicles[k].Passengers) To high(Train.Vehicles[k].Passengers) Do
            Begin
              Passengers_Queue[i] := Train.Vehicles[k].Passengers[i];
              inc(Passengers_Queue_Size);
            End;
          SetLength(Train.Vehicles[k].Passengers, 0);
          //  Chargement des passagers de la station dans le train.
          If (length(Train.Next_Station^.Passengers) < 6) Then
            Maximum := high(Train.Next_Station^.Passengers)
          Else
            Maximum := low(Train.Next_Station^.Passengers) + 5;
          For i := low(Train.Next_Station^.Passengers) To Maximum Do
            Begin
              Train.Vehicles[k].Passengers[i] := Train.Next_Station^.Passengers[i];
            End;
          For i:= Maximum To (length(Train.Next_Station^.Passengers)-1) Do
            Begin
              Train.Next_Station^.Passengers[i] := Train.Next_Station^.Passengers[i+1];
              SetLength(Train.Next_Station^.Passengers,length(Train.Next_Station^.Passengers)-1);
            End;
          // Déchargement de la queue dans la station  
          For i:= 0 To Passengers_Queue_Size Do
            Begin
              Train.Next_Station^.Passengers[(length(Train.Next_Station^.Passengers) + i)] := Passengers_Queue[i];

            End;
        End;

    End;
  // Défragmentation de la station. 
  
End;

// Fonction qui calcule
Procedure Train_Drive(Var Train : Type_Train, Line : Type_Line);
Var i : Integer;
Begin
  // La station d'arrivée devient la station de départ.
  Train.Last_Station := Train.Next_Station;
  // Réinitialisation de la distance.
  Train.Distance := 0;
  For i := low(Line.Stations) To high(Line.Stations) Do
    Begin
      // Cherche la station actuelle du train dans les stations d'une ligne.
      If (Train.Last_Station = Line.Stations[i]) Then
        Begin
          // Si la station est la dernière ou la première station d'une ligne.
          If (i = high(Line.Stations) Or i = low(Line.Stations)) Then
            // On inverse la direction.
            Train.Direction := Not(Train.Direction);

          // Si le train est dans le sens direct (index des stations croissant).
          If (Train.Direction = true) Then
            Train.Next_Station := Line.Stations[i + 1]
                                  // Si le train est dans le sens indirect (index des stations décroissant).
          Else
            Train.Next_Station := Line.Stations[i - 1];

          Train.Maximum_Distance
          // On quitte la boucle.
          Break;
        End;
    End;
End;

// - - Fonctions et procédures relatives aux lignes.




// -  - Fonctions et procédures relatives au passagers



// - - Fonctions et procédures relatives aux stations.

// Fonction qui permet d'obtenir le centre d'une station.

End.
