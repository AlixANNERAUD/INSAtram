
Unit Unit_Animations;

Interface

Uses Unit_Types, Unit_Common, Unit_Constants, sdl;

Procedure Animation_Refresh(Var Game : Type_Game);

Procedure Animation_Load(Var Animation : Type_Animation);

Implementation


// Fonction qui renvoi la distance durant la phase d'accélération.
Function Animation_Acceleration(t : Real) : Integer;
Begin
  // Conversion du temps en secondes.
  t := t / 1000;

  Animation_Acceleration := round(Train_Maximum_Speed * (((Train_Speed_Constant * t) - sin(Train_Speed_Constant * t)) / (2 * Train_Speed_Constant)));
End;

// Fonction qui renvoi la distance durant la phase de vitesse de croisière.
Function Animation_Constant_Speed(t : Real) : Integer;
Begin
  // Conversion du temps en secondes.
    t := (t - Train_Acceleration_Time) / 1000;

    Game.Lines[i].Trains[j].Distance := round(Game.Animation.Acceleration_Distance + (t * Train_Maximum_Speed));
End;

// Fonction qui renvoi la distance durant la phase de décélération.
Function Animation_Deceleration(t : Real) : Integer;
Begin

  t := (t - Train_Acceleration_Time) / 1000;

  Game.Lines[i].Trains[j].Distance := round(Game.Animation.Acceleration_Distance + (t * Train_Maximum_Speed));

End;

Procedure Animation_Load(Var Animation : Type_Animation);
Begin
  Animation.Acceleration_Distance := Animation_Acceleration(Train_Acceleration_Time);
End;

// Fonction appelée tout les 1/60 ème de seoncde pour annimer
Procedure Animation_Refresh(Var Game : Type_Game);

Var i, j : Byte;
  t : Real;
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
                          // Calcul du temps écouté depuis le départ du train en secondes.

                          // Si le train doit s'arrêter car il est arrivé.
                          If (Game.Lines[i].Trains[j].Distance >= Game.Lines[i].Trains[j].Maximum_Distance) Then
                            Begin
                              // Arrête le train.
                              Game.Lines[i].Trains[j].Driving := False;
                              Game.Lines[i].Trains[j].Distance := Game.Lines[i].Trains[j].Maximum_Distance;
                            End
                          // Si le train doit décélerer.
                          Else If (Game.Lines[i].Trains[j].Distance >= Game.Lines[i].Trains[j].Maximum_Distance - Train_Acceleration_Distance) Then
                            Begin

                              t := (Time_Get_Elapsed(Game.Lines[i].Trains[j].Start_Time) / 1000) - Train_Acceleration_Time;


                              Game.Lines[i].Trains[j].Distance := Train_Acceleration_Distance +



                                                                  round(Train_Maximum_Speed * (((Train_Speed_Constant * t) - sin(Train_Speed_Constant * t)) / (2 * Train_Speed_Constant)));
                            End

                            // Si le train est en vitesse de croisière.
                          Else If (Game.Lines[i].Trains[j].Distance < Game.Lines[i].Trains[j].Maximum_Distance - Game.Animation.Acceleration_Distance) Then
                                 Begin
                                   t := (Time_Get_Elapsed(Game.Lines[i].Trains[j].Start_Time) / 1000) - Train_Acceleration_Time;

                                 

                                 End

                                 // Si le train est en train d'accélérer.
                          Else If (Game.Lines[i].Trains[j].Distance < Game.Animation.Acceleration_Distance) Then
                                 Begin
                                   // sin ease in out
                                   t := Time_Get_Elapsed(Game.Lines[i].Trains[j].Start_Time) / 1000;

                                   Game.Lines[i].Trains[j].Distance := round(Train_Maximum_Speed * (((Train_Speed_Constant * t) - sin(Train_Speed_Constant * t)) / (2 * Train_Speed_Constant)));

                                 End;
                            


                        End;

                    End;
                End;
            End;
        End;
    End;
End;

End.
