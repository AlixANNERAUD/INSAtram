
Program INSAtram;

Uses Unite_Affichage, Unite_Types, sdl_image, sdl;

Var Fenetre : Type_Surface;
  Rectangle : Type_Rectangle;
  Temps_Dernier_Rafraissemnt : Type_Temps;

Begin

  Fenetre := Creer_Fenetre();

  While true Do
    Begin

      Temps_Dernier_Rafraissemnt := Obtenir_Temps_Actuel();

      Rectangle.x := 451;
      Rectangle.y := 451;
      Rectangle.w := 1280;
      Rectangle.h := 720;

      SDL_BlitSurface(Fenetre, @Rectangle, SDL_MapRGB(Fenetre^.format, 255, 255, 255));

      SDL_Flip(Fenetre);

      If Obtenir_Temps_Ecoule(Temps_Dernier_Rafraissemnt) < 1000/60 Then
        Begin
          SDL_Delay(20);
        End;

    End;
End.
