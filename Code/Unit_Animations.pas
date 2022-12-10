
Unit Unit_Animations;

Interface

Uses Unit_Types, sdl;

Procedure Animation_Refresh(Var Game : Type_Game);

Procedure Animation_Load(Var Animation : Type_Animation);

Implementation

Procedure Animation_Load(Var Animation : Type_Animation);
Begin

 // Animation.Constants[0] := 

End;


// Fonction appelée tout les 1/60 ème de seoncde pour annimer
Procedure Animation_Refresh(Var Game : Type_Game);

Var i, j : Byte;
Begin
  // Vérifie si le jeu n'est pas en pause.
  If (Game.Play_Pause_Button.State = true) Then
    Begin
          
      // Vérifie si des lignes existent.
      If (length(Game.Lines) > 0) Then
        Begin
          // Itère sur chaque ligne.
          For i := low(Game.Lines) To high(Game.Lines) Do
            Begin
              // Vérifie si des trains existent sur la ligne.
              If length(Game.Lines[i].Trains) > 0 Then
                Begin
                  // Itère sur chaque train.
                  For j := low(Game.Lines[i].Trains) To high(Game.Lines[i].Trains) Do
                    Begin
                      // Vérifie si le train est en mouvement.
                      If (Game.Lines[i].Trains[j].Driving = True) Then
                        Begin
                          // Fait progresser le train sur la ligne.
                          // TODO : Remplacer avec des équations horaire et des intégrales à partir de la vitesse max et de l'accélération (distance en fonction de t).
                          Game.Lines[i].Trains[j].Distance := (Time_Get_Elapsed(Game.Lines[i].Trains[j].Start_Time) * Train_Maximum_Speed) div 1000;

                          // Si le train est arrivé.
                          If (Game.Lines[i].Trains[j].Distance >= Game.Lines[i].Trains[j].Maximum_Distance) Then
                            Begin
                              // Arrête le train.
                              Game.Lines[i].Trains[j].Driving := False;
                              Game.Lines[i].Trains[j].Distance := Game.Lines[i].Trains[j].Maximum_Distance;

                            End;
                        End;

                    End;
                End;
            End;
        End;
    End;
End;

End.
