
Program INSAtram;

Uses Unit_Logic, Unit_Graphics, Unit_Types, sdl_image, sdl;

Var Game : Type_Game;
  Station_Pointer : Type_Station_Pointer;
  Timer : Type_Time;
  Window : Type_Surface;
  Test : Type_Surface;
  Drect : Type_Rectangle;

Begin

  //Graphics_Load(Game);

  SDL_Init(SDL_INIT_VIDEO);

  Window := SDL_SetVideoMode(1000, 1000, 32, SDL_SWSURFACE);

  //SDL_FillRect(Window, Nil, SDL_MapRGB(Window^.format, 255, 255, 255));

  Drect.x := 0;
  Drect.y := 0;
  Drect.w := 225;
  Drect.h := 225;

  Test := IMG_Load('images.jpg');

  SDL_BlitSurface(Test, Nil, Window, @Drect);

  SDL_Flip(Window);

  SDL_Delay(4000);

  //Station_Pointer := Station_Create();

  //Station_Display(Station_Pointer^, Game);

  //Graphics_Refresh(Game);

  //SDL_Delay(4000);

  //Graphics_Unload(Game);
End.
