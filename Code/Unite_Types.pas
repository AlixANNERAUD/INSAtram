
Unit Unite_Types;

Interface

// - Inclusion des libraries.

Uses sdl, sdl_image, sdl_ttf, sysutils;

// - Définition des constantes.

Const Profondeur_Couleur = 32;



  // - Définition des types.

// Timer

Type Type_Time = QWord;

// - Graphismes

Type Type_Surface = PSDL_Surface;
Type Type_Rectangle = TSDL_Rect;

// - Entités

// - - Généraux

Type Type_Coordinates = Record
  X, Y : Integer;
End;

Type Type_Shape = (Square, Circle, Triangle, Losange, Pentagone);

// - - Station

Type Type_Station = record
  Forme : Type_Forme;
  Coordonnees : Type_Coordonnees;
  Image : Type_Surface;  
end;

  //Type Type_Surface = PSDL_Type_Surface;




Function Obtenir_Temps_Actuel(): Type_Temps;
Function Obtenir_Temps_Ecoule(Temps_Debut : Type_Temps) : Type_Temps;

Implementation

Function Obtenir_Temps_Actuel(): Type_Temps;
Begin
  Obtenir_Temps_Actuel := SDL_GetTicks();
End;

Function Obtenir_Temps_Ecoule(Temps_Debut : Type_Temps) : Type_Temps;
Begin
  Obtenir_Temps_Ecoule := SDL_GetTicks() - Temps_Debut;
End;

End.
