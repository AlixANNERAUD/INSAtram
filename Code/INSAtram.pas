// Programme principal appelant les fonctions du jeu.

Program INSAtram;

// Dépendances.
Uses Unit_Types, Unit_Logic;

Var Game : Type_Game;

Begin
  Logic_Load(Game);

  While (True) Do
      Logic_Refresh(Game);

End.
