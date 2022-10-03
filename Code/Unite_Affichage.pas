
Unit Unite_Affichage;

Interface

Uses Unite_Types, sdl, sdl_image, sdl_ttf, sysutils;

// - Définition des constantes

Const Chemin_Image_Cercle = 'Ressources/Cercle.png';
Const Chemin_Image_Carre = 'Ressources/Carre.png';
Const Chemin_Image_Triangle = 'Ressources/Triangle.png';
Const Chemin_Image_Pentagone = 'Ressources/Pentagone.png';
Const Chemin_Image_Losange = 'Ressources/Losange.png';

Const Largeur_Station = 48;
Const Longeur_Station = 48;

Const Largeur_Train = 40;
Const Longeur_Train = 100;

Procedure Initialiser_SDL();
Procedure Deinitialiser_SDL();

Procedure Station_Load_Image(var Station : Type_Station);
Procedure Station_Display(var Station : Type_Station);

Function Create_Window() : Type_Surface;
Procedure Supprimer_Fenetre(Var Fenetre : Type_Surface);
Function Rafraichir_Fenetre()

Implementation

Procedure Charger_Image_Station(var Station : Type_Station);
Begin
  Station.Image := IMG_Load(Chemin_Image_Cercle);
End;

Procedure Afficher_Station(Station : Type_Station)
Begin

End;

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
