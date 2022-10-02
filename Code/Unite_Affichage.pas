
Unit Unite_Affichage;

Interface

Uses Unite_Types, sdl, sdl_image, sdl_ttf, sysutils;


Procedure Initialiser_SDL();
Procedure Deinitialiser_SDL();
Function Creer_Fenetre() : Type_Surface;
Procedure Supprimer_Fenetre(Var Fenetre : Type_Surface);
Procedure Draw_Circle(Centre_X, Centre_Y, Rayon : Integer);
//Procedure Creer_Station(Var Station : Station);

Implementation

Procedure Initialiser_SDL();
Begin
  SDL_Init(SDL_INIT_VIDEO);
End;

Procedure Deinitialiser_SDL();
Begin
  SDL_Quit();
End;

Function Creer_Fenetre() : Type_Surface;
Begin
  Initialiser_SDL();
  Creer_Fenetre := SDL_SetVideoMode(0, 0, 32, SDL_FULLSCREEN);

End;

Procedure Supprimer_Fenetre(Var Fenetre : Type_Surface);
Begin
  SDL_FreeSurface(Fenetre);
  Fenetre := Nil;
  Deinitialiser_SDL();
End;

Procedure Draw_Circle(Centre_X, Centre_Y, Rayon : Integer);
Begin

End;

End.
