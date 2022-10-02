
Unit Unite_Types;

Interface

Uses sdl, sdl_image, sdl_ttf, sysutils;

Type Type_Surface = PSDL_Surface;

Type Type_Rectangle = TSDL_Rect;

  //Type Type_Station = record
  //end;

  //Type Type_Surface = PSDL_Type_Surface;

Type Type_Temps = QWord;


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
