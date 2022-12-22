
Unit Unit_Animations;

Interface

Uses Unit_Types, Unit_Common, Unit_Constants, sdl;

Procedure Animation_Refresh(Var Game : Type_Game);

Procedure Animation_Load(Var Animation : Type_Animation);

Implementation

// Procédure qui initialise l'animation.
Procedure Animation_Load(Var Animation : Type_Animation);
Begin
  Animation.Acceleration_Distance := round(0.5 * Train_Speed_Constant * Train_Acceleration_Time * Train_Acceleration_Time);
End;

// Procédure appelée tout les 1/60 ème de seconde pour animer les entités.
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
                          // Calcul du temps écoulé depuis le départ du train en secondes.

                          t := Time_Get_Elapsed(Game.Lines[i].Trains[j].Start_Time) / 1000;
                          
                          // Si le train doit s'arrêter car il est arrivé.
                          If (t >= (Game.Lines[i].Trains[j].Deceleration_Time + Train_Acceleration_Time)) Then
                              // Arrête le train.
                              Game.Lines[i].Trains[j].Driving := False
                          Else If (t > Game.Lines[i].Trains[j].Deceleration_Time) Then 
                          Begin
                              Game.Lines[i].Trains[j].Distance := round(Game.Animation.Acceleration_Distance + ((Game.Lines[i].Trains[j].Deceleration_Time - Train_Acceleration_Time) * Train_Maximum_Speed));

                              t := t - Game.Lines[i].Trains[j].Deceleration_Time;

                              Game.Lines[i].Trains[j].Distance := Game.Lines[i].Trains[j].Distance + round(t * Train_Maximum_Speed - (((Train_Maximum_Speed * t * t)) / (2 * Train_Acceleration_Time)));
                          End

                          Else If (t > Train_Acceleration_Time) Then
                            Begin
                              t := t - Train_Acceleration_Time;

                              Game.Lines[i].Trains[j].Distance := round(Game.Animation.Acceleration_Distance + (t * Train_Maximum_Speed));

                            End
                          Else
                            Begin
                              Game.Lines[i].Trains[j].Distance := round(0.5 * Train_Speed_Constant * t * t);
                            End;

                        End;

                    End;
                End;
            End;
        End;
    End;
End;

End.
