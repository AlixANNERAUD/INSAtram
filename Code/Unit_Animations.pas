
Unit Unit_Animations;

Interface

Uses Unit_Types;

Procedure Animation_Refresh(Var Game : Type_Game);

Implementation

// Fonction appelée tout les 1/60 ème de seoncde pour annimer
Procedure Animation_Refresh(Var Game : Type_Game);

Var i : Byte;
Begin

  // Anime les trains
  If length(Game.Trains) > 0 Then
    Begin
      For i := low(Game.Trains) To high(Game.Trains) Do
        Begin
          If (Game.Trains[i].Driving := True) Then
            Begin
                Game.Trains[i].Distance := Game.Trains[i].Distance + ((1 / 60) * Train_Maximum_Speed);
            
                If (Game.Trains[i].Distance >= Game.Trains[i].Distance_Maximum) Then
                Begin
                    Game.Trains[i].Driving := False;
                    Game.Trains[i].Distance := Game.Trains[i].Distance_Maximum;
                End;
            End;
            
        End;
    End;
End;

End.
