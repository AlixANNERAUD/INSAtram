
Program INSAtram;

Uses Unite_Logique, Unite_Affichage, Unite_Types, sdl_image, sdl;

Var Fenetre : Type_Surface;
  Rectangle_Surface : Type_Surface;
  Rectangle : Type_Rectangle;
  Temps_Dernier_Rafraichissement : Type_Temps;

Begin

  Fenetre := Creer_Fenetre();


  Rectangle.x := 451;
  Rectangle.y := 451;
  Rectangle.w := 1280;
  Rectangle.h := 720;

  Rectangle_Surface := SDL_CreateRGBSurface(0,1280, 720, Profondeur_Couleur, 0, 0, 0, 0);
  SDL_FillRect(Rectangle_Surface, Nil, SDL_MapRGB(Rectangle_Surface^.format, 255, 255, 255));


  While true Do
    Begin

      Temps_Dernier_Rafraichissement := Obtenir_Temps_Actuel();

      SDL_BlitSurface(Rectangle_Surface, Nil, Fenetre, @Rectangle);

      SDL_Flip(Fenetre);

      SDL_Delay(1000);

      If Obtenir_Temps_Ecoule(Temps_Dernier_Rafraichissement) < 1000/60 Then
        Begin
          SDL_Delay(20);
        End;


    End;
End.
