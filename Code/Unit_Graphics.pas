
Unit Unit_Graphics;

Interface

// - Dépendances

Uses Unit_Types, Unit_Animations, sdl, sdl_image, sdl_ttf, sdl_gfx, sysutils, Math, Unit_Mouse;

// - Défintion des fonctions.

// - - Graphismes généraux

Procedure Graphics_Load(Var Game : Type_Game);
Procedure Graphics_Unload(Var Game : Type_Game);
Procedure Graphics_Refresh(Var Game : Type_Game);

// - - - Outils

Function Graphics_Get_Direction(Angle : Real) : Integer;
Procedure Graphics_Draw_Line(Position_1, Position_2 :
                             Type_Coordinates; Color :
                             Type_Color; Var Panel : Type_Panel);
Procedure Graphics_Draw_River(Position_1, Position_2 :
                              Type_Coordinates; Color :
                              Type_Color; Var Panel : Type_Panel);

// - - Objets liées à l'interface graphique.

// - - - Ressources

Procedure Ressources_Load(Var Ressources : Type_Ressources);

// - - - Curseur

Procedure Cursor_Render(Mouse : Type_Mouse; Var Destination_Panel : Type_Panel; Var Game : Type_Game);

// - - - Bouton

Procedure Button_Render(Var Button : Type_Button; Destination_Panel : Type_Panel);
Procedure Button_Set(Var Button : Type_Button; Surface_Pressed, Surface_Released : PSDL_Surface);
Procedure Button_Set_Hidden(Hidden : Boolean; Var Button : Type_Button);

// - - - Bouton à deux états.

Procedure Dual_State_Button_Render(Var Button : Type_Dual_State_Button; Destination_Panel : Type_Panel);


// - - - Images

Procedure Image_Render(Var Image : Type_Image; Destination_Panel : Type_Panel);
Procedure Image_Set(Var Image : Type_Image; Surface : PSDL_Surface);

// - - - Couleurs

Function Color_To_Longword(Color : Type_Color) : Longword;

// - - - Etiquette


// - - - Panneaux

Procedure Panel_Create(Var Panel : Type_Panel; X,Y, Width, Height : Integer);
Procedure Panel_Delete(Var Panel : Type_Panel);
Procedure Label_Render(Var Laabel : Type_Label; Var Panel : Type_Panel);
Procedure Panel_Render(Var Panel, Destination_Panel : Type_Panel);


// - - Entités du jeux.

Procedure Station_Render(Var Station : Type_Station; Var Panel : Type_Panel);
Procedure Line_Render(Line : Type_Line; Var Panel : Type_Panel);

Procedure Train_Render(Var Train : Type_Train; Var Line : Type_Line; Ressources : Type_Ressources; Var Panel : Type_Panel);

Procedure Left_Panel_Render(Var Game : Type_Game; Var Destination_Panel : Type_Panel);
Procedure Right_Panel_Render(Var Game : Type_Game; Var Destination_Panel : Type_Panel);

Function Image_Load(Path : String) : PSDL_Surface;

Implementation

// Fonction qui rend le panneau de droite dans la fenêtre principale.
Procedure Right_Panel_Render(Var Game : Type_Game; Var Destination_Panel : Type_Panel);

Var i, j : Byte;
Begin

  // Nettoyage du panneau de droite.
  SDL_FillRect(Game.Panel_Right.Surface, Nil, Color_To_Longword(Color_Get(255, 255, 255, 255)));

  // - Rendu de la rivière.
  For i := low(Game.River) + 1 To high(Game.River) Do
    Graphics_Draw_River(Game.River[i - 1], Game.River[i], Color_Get(Color_Cyan), Game.Panel_Right);


  // - Affichage des lignes et des trains.

  // Vérifie qu'il y a bien des lignes dans la partie.
  If (length(Game.Lines) > 0) Then
    Begin
      // Itère parmis les lignes.
      For i := low(Game.Lines) To high(Game.Lines) Do
        Begin

          Line_Render(Game.Lines[i], Game.Panel_Right);

          // Si la ligne contient des trains.
          If (length(Game.Lines[i].Trains) > 0) Then
            Begin
              // Itère parmis les trains d'une ligne.
              For j := low(Game.Lines[i].Trains) To high(Game.Lines[i].Trains) Do
                Begin
                  // Affichage des trains sur la ligne.
                  Train_Render(Game.Lines[i].Trains[j], Game.Lines[i], Game.Ressources, Game.Panel_Right);
                End;
            End;
        End;
    End;

  // - Rendu des stations

  // Vérifie qu'il y a bien des stations dans la partie.
  If (length(Game.Stations) > 0) Then
    Begin
      // - Affichage les stations.
      For i := low(Game.Stations) To high(Game.Stations) Do
        Begin
          Station_Render(Game.Stations[i], Game.Panel_Right);
        End;
    End;


  Panel_Render(Game.Panel_Right, Game.Window);

End;

Function Image_Load(Path : String) : PSDL_Surface;

Var Image : PSDL_Surface;
  Optimized_Image : PSDL_Surface;
  Color_Key : Longword;
Begin
  Image := IMG_Load(String_To_Characters(Path));

  Optimized_Image := SDL_DisplayFormatAlpha(Image);

  SDL_FreeSurface(Image);

  Color_Key := SDL_MapRGBA(Optimized_Image^.Format, 255, 0, 255, 255);
  SDL_SetColorKey(Optimized_Image, SDL_SRCCOLORKEY, Color_Key);

  Image_Load := Optimized_Image;
End;

Procedure Button_Set_Hidden(Hidden : Boolean; Var Button : Type_Button);
Begin
  Button.Hidden := Hidden;
End;

Procedure Left_Panel_Render(Var Game : Type_Game; Var Destination_Panel : Type_Panel);

Var i : Byte;
Begin
  SDL_FillRect(Game.Panel_Left.Surface, Nil, Color_To_Longword(Color_Get(255, 255, 255, 255)));

  For i := 2 Downto 0 Do
    Begin
      If (i < Game.Player.Locomotive_Token) Then
        Begin
          Button_Render(Game.Locomotive_Button[i], Game.Panel_Left);
        End;

      If (i < Game.Player.Wagon_Token) Then
        Begin
          Button_Render(Game.Wagon_Button[i], Game.Panel_Left);
        End;
      If (i < Game.Player.Tunnel_Token) Then
        Begin
          Button_Render(Game.Tunnel_Button[i], Game.Panel_Left);

        End;
    End;

  Panel_Render(Game.Panel_Left, Destination_Panel);
End;

// Procédure qui charge les ressources graphiques.
Procedure Ressources_Load(Var Ressources : Type_Ressources);

Var Position : Type_Coordinates;
  i : Byte;
  Color : Type_Color_Name;
Begin

  // - - Station
  Ressources.Stations[0] := Image_Load(Path_Image_Station_Circle);
  Ressources.Stations[1] := Image_Load(Path_Image_Station_Lozenge);
  Ressources.Stations[2] := Image_Load(Path_Image_Station_Pentagon);
  Ressources.Stations[3] := Image_Load(Path_Image_Station_Square);
  Ressources.Stations[4] := Image_Load(Path_Image_Station_Triangle);

  // - - Passenger
  Ressources.Passengers[0] := Image_Load(Path_Image_Passenger_Circle);
  Ressources.Passengers[1] := Image_Load(Path_Image_Passenger_Lozenge);
  Ressources.Passengers[2] := Image_Load(Path_Image_Passenger_Pentagon);
  Ressources.Passengers[3] := Image_Load(Path_Image_Passenger_Square);
  Ressources.Passengers[4] := Image_Load(Path_Image_Passenger_Triangle);


  // - - Véhicule (Locomotive et Wagon)

  Position.X := 0;
  Position.Y := 0;

  // Itère parmis les couleurs de véhicule.
  For i := 0 To 7 Do
    Begin

      Case i Of 
        0 : Color := Color_Red;
        1 : Color := Color_Purple;
        2 : Color := Color_Indigo;
        3 : Color := Color_Teal;
        4 : Color := Color_Green;
        5 : Color := Color_Yellow;
        6 : Color := Color_Orange;
        7 : Color := Color_Brown;
      End;

      // Crée la surface de base (orientation 0 degrée).
      Ressources.Vehicles[i][0] := Graphics_Surface_Create(Vehicle_Size.X, Vehicle_Size.Y);
      Graphics_Draw_Filled_Rectangle(Ressources.Vehicles[i][0], Position, Vehicle_Size, Color_Get(Color));

      // Génère la deuxième surface (orientation 45 degrée).
      Ressources.Vehicles[i][1] := rotozoomSurface(Ressources.Vehicles[i][0], 45, 1, 1);
      Ressources.Vehicles[i][2] := rotozoomSurface(Ressources.Vehicles[i][0], 90, 1, 1);
      Ressources.Vehicles[i][3] := rotozoomSurface(Ressources.Vehicles[i][0], 135, 1, 1);
    End;

  Ressources.Vehicles[8][0] := Graphics_Surface_Create(Vehicle_Size.X, Vehicle_Size.Y);
  Graphics_Draw_Filled_Rectangle(Ressources.Vehicles[8][0], Position, Vehicle_Size, Color_Get(Color_Black));

  // Génère la deuxième surface (orientation 45 degrée).
  Ressources.Vehicles[8][1] := rotozoomSurface(Ressources.Vehicles[8][0], 45, 1, 1);
  Ressources.Vehicles[8][2] := rotozoomSurface(Ressources.Vehicles[8][0], 90, 1, 1);
  Ressources.Vehicles[8][3] := rotozoomSurface(Ressources.Vehicles[8][0], 135, 1, 1);

  // - Fonts loading
  Ressources.Fonts[Font_Small][Font_Normal] := TTF_OpenFont(Path_Font, 12);
  Ressources.Fonts[Font_Medium][Font_Normal] := TTF_OpenFont(Path_Font, 24);
  Ressources.Fonts[Font_Big][Font_Normal] := TTF_OpenFont(Path_Font, 32);

  Ressources.Fonts[Font_Small][Font_Bold] := TTF_OpenFont(Path_Font_Bold, 12);
  Ressources.Fonts[Font_Medium][Font_Bold] := TTF_OpenFont(Path_Font_Bold, 24);
  Ressources.Fonts[Font_Big][Font_Bold] := TTF_OpenFont(Path_Font_Bold, 32);
End;

Procedure Cursor_Render(Mouse : Type_Mouse; Var Destination_Panel : Type_Panel; Var Game : Type_Game);

Var Destination_Rectangle : TSDL_Rect;
  Intermediate_Position : Type_Coordinates;
Begin
  // Si le curseur est en mode ajout de locomotive.
  If (Mouse.Mode = Type_Mouse_Mode.Add_Locomotive) Then
    Begin
      Destination_Rectangle.x := Mouse_Get_Position().X - Vehicle_Size.X Div 2;
      Destination_Rectangle.y := Mouse_Get_Position().Y - Vehicle_Size.Y Div 2;

      SDL_BlitSurface(Game.Ressources.Vehicles[8][0], Nil, Game.Window.Surface, @Destination_Rectangle);
    End
    // Si le curseur est en mode ajout de wagon.
  Else If (Mouse.Mode = Type_Mouse_Mode.Add_Wagon) Then
         Begin
           Destination_Rectangle.x := Mouse_Get_Position().X - Vehicle_Size.X Div 2;
           Destination_Rectangle.y := Mouse_Get_Position().Y - Vehicle_Size.Y Div 2;
           SDL_BlitSurface(Game.Ressources.Vehicles[8][0], Nil, Game.Window.Surface, @Destination_Rectangle);
         End
         // Si le curseur est en mode ajout de station à une ligne.
  Else If (Mouse.Mode = Type_Mouse_Mode.Line_Insert_Station) Then
         Begin
           Intermediate_Position := Station_Get_Intermediate_Position(Mouse.Selected_Last_Station^.Position_Centered, Mouse_Get_Position());

           Graphics_Draw_Line(Mouse.Selected_Last_Station^.Position_Centered, Intermediate_Position, Mouse.Selected_Line^.Color, Destination_Panel);

           Graphics_Draw_Line(Intermediate_Position, Mouse_Get_Position, Mouse.Selected_Line^.Color, Destination_Panel);

           Intermediate_Position := Station_Get_Intermediate_Position(Mouse.Selected_Next_Station^.Position_Centered, Mouse_Get_Position());

           Graphics_Draw_Line(Mouse.Selected_Next_Station^.Position_Centered, Intermediate_Position, Mouse.Selected_Line^.Color, Destination_Panel);

           Graphics_Draw_Line(Intermediate_Position, Mouse_Get_Position, Mouse.Selected_Line^.Color, Destination_Panel);

         End
         // Si le curseur est en mode ajout de station à une ligne.
  Else If (Mouse.Mode = Type_Mouse_Mode.Line_Add_Station) Then
         Begin
           Intermediate_Position := Station_Get_Intermediate_Position(Mouse.Selected_Last_Station^.Position_Centered, Mouse_Get_Position());
           Graphics_Draw_Line(Mouse.Selected_Last_Station^.Position_Centered, Intermediate_Position, Mouse.Selected_Line^.Color, Destination_Panel);
           Graphics_Draw_Line(Intermediate_Position, Mouse_Get_Position(), Mouse.Selected_Line^.Color, Destination_Panel);
         End;

End;

// Fonction qui rend un button à double état.
Procedure Dual_State_Button_Render(Var Button : Type_Dual_State_Button; Destination_Panel : Type_Panel);

Var Destination_Rectangle : TSDL_Rect;
Begin
  Destination_Rectangle.x := Button.Position.X;
  Destination_Rectangle.y := Button.Position.Y;
  Destination_Rectangle.w := Button.Size.X;
  Destination_Rectangle.h := Button.Size.Y;

  If Button.Pressed Then
    If (Button.State = False) Then
      SDL_BlitSurface(Button.Surface_Pressed[0], Nil, Destination_Panel.Surface, @Destination_Rectangle)
  Else
    SDL_BlitSurface(Button.Surface_Pressed[1], Nil, Destination_Panel.Surface, @Destination_Rectangle)
  Else
    If (Button.State = False) Then
      SDL_BlitSurface(Button.Surface_Released[0], Nil, Destination_Panel.Surface, @Destination_Rectangle)
  Else
    SDL_BlitSurface(Button.Surface_Released[1], Nil, Destination_Panel.Surface, @Destination_Rectangle);
End;





Procedure Button_Set(Var Button : Type_Button; Surface_Pressed, Surface_Released : PSDL_Surface);
Begin
  Button.Surface_Pressed := Surface_Pressed;
  Button.Surface_Released := Surface_Released;
  Button.Size.X := Surface_Released^.w;
  Button.Size.Y := Surface_Released^.h;
  Button_Set_Hidden(False, Button);
End;

Procedure Image_Set(Var Image : Type_Image; Surface : PSDL_Surface);
Begin
  Image.Size.X := Surface^.w;
  Image.Size.Y := Surface^.h;
  Image.Surface := Surface;
End;

Procedure Panel_Delete(Var Panel : Type_Panel);
Begin
  SDL_FreeSurface(Panel.Surface);
End;

Function Color_To_Longword(Color : Type_Color) : Longword;
Begin

  Color_To_Longword := (Color.Red << 16) Or (Color.Green << 8) Or (Color.Blue) Or (Color.Alpha << 24);
End;


Procedure Button_Render(Var Button : Type_Button; Destination_Panel : Type_Panel);

Var Destination_Rectangle : TSDL_Rect;
Begin
  If (Not(Button.Hidden)) Then
    Begin
      Destination_Rectangle.x := Button.Position.X;
      Destination_Rectangle.y := Button.Position.Y;
      Destination_Rectangle.w := Button.Size.X;
      Destination_Rectangle.h := Button.Size.Y;

      If Button.Pressed Then
        SDL_BlitSurface(Button.Surface_Pressed, Nil, Destination_Panel.Surface, @Destination_Rectangle)
      Else
        SDL_BlitSurface(Button.Surface_Released, Nil, Destination_Panel.Surface, @Destination_Rectangle);
    End;
End;

Procedure Image_Render(Var Image : Type_Image; Destination_Panel : Type_Panel);

Var Destination_Rectangle : TSDL_Rect;
Begin
  Destination_Rectangle.x := Image.Position.X;
  Destination_Rectangle.y := Image.Position.Y;
  Destination_Rectangle.w := Image.Size.X;
  Destination_Rectangle.h := Image.Size.Y;

  SDL_BlitSurface(Image.Surface, Nil, Destination_Panel.Surface, @Destination_Rectangle);
End;

Procedure Panel_Create(Var Panel : Type_Panel; X,Y, Width, Height : Integer);

Var Surface : PSDL_Surface;
  Color_Key : Longword;
Begin
  Panel.Position.X := X;
  Panel.Position.Y := Y;
  Panel.Size.X := Width;
  Panel.Size.Y := Height;
  Surface := Graphics_Surface_Create(Width, Height);
  // Optimisation de la surface.
  Panel.Surface := SDL_DisplayFormat(Surface);
  Color_Key := SDL_MapRGB(Panel.Surface^.format, 255, 0, 255);
  SDL_SetColorKey(Panel.Surface, SDL_SRCCOLORKEY, Color_Key);
  // Libération de la surface temporaire.
  SDL_FreeSurface(Surface);


  Panel.Surface := SDL_DisplayFormat(Graphics_Surface_Create(Width, Height));
  Panel_Set_Hidden(True,Panel);
  Panel.Hidden := false;
End;

Procedure Panel_Render(Var Panel, Destination_Panel : Type_Panel);

Var Destination_Rectangle : TSDL_Rect;
Begin
  If (Not(Panel.Hidden)) Then
    Begin
      Destination_Rectangle.x := Panel.Position.X;
      Destination_Rectangle.y := Panel.Position.Y;
      Destination_Rectangle.w := Panel.Size.X;
      Destination_Rectangle.h := Panel.Size.Y;

      SDL_BlitSurface(Panel.Surface, Nil, Destination_Panel.Surface, @Destination_Rectangle);
    End;
End;

Procedure Label_Render(Var Laabel : Type_Label; Var Panel : Type_Panel);

Var Destionation_Rectangle : TSDL_Rect;
Begin
  Destionation_Rectangle.x := Laabel.Position.X;
  Destionation_Rectangle.y := Laabel.Position.Y;
  //Destionation_Rectangle.w := Laabel.Size.X;
  //Destionation_Rectangle.h := Laabel.Size.Y;
  SDL_BlitSurface(Laabel.Surface, Nil, Panel.Surface, @Destionation_Rectangle);
End;

// - - Graphics

Procedure Graphics_Load(Var Game : Type_Game);

Var Video_Informations :   PSDL_VideoInfo;
  i : Byte;
Begin
  // - Initialisation de la SDL
  SDL_Init(SDL_INIT_EVERYTHING);
  TTF_INIT();

  // - Création du panneau fenêtre.
  If Full_Screen Then
    Game.Window.Surface := SDL_SetVideoMode(0, 0, Color_Depth, SDL_HWSURFACE Or SDL_FULLSCREEN)
  Else
    Game.Window.Surface := SDL_SetVideoMode(Screen_Width, Screen_Height, Color_Depth, SDL_HWSURFACE);

  // - Obtention des informations de la fenêtre.
  Video_Informations := SDL_GetVideoInfo();
  Game.Window.Size.X := Video_Informations^.current_w;
  Game.Window.Size.Y := Video_Informations^.current_h;
  Game.Window.Position.X := 0;
  Game.Window.Position.Y := 0;

  // - Création des sous-panneaux.
  Panel_Create(Game.Panel_Top, 0, 0, Game.Window.Size.X, 64);
  Panel_Create(Game.Panel_Bottom, 0, Game.Window.Size.Y - 64, Game.Window.Size.X, 64);
  Panel_Create(Game.Panel_Left, 0, Game.Panel_Top.Size.Y, 64, Game.Window.Size.Y - Game.Panel_Top.Size.Y - Game.Panel_Bottom.Size.Y);
  Panel_Create(Game.Panel_Right, Game.Panel_Left.Size.X, Game.Panel_Top.Size.Y, Game.Window.Size.X - Game.Panel_Left.Size.X, Game.Window.Size.Y - Game.Panel_Top.Size.Y - Game.Panel_Bottom.Size.Y);

  // - Chargement des ressources.
  Ressources_Load(Game.Ressources);

  // - Panneau de droite.

  Create_River(Game);


  // - Panneau de haut.

  Image_Set(Game.Score_Image, Image_Load(Path_Image_People));
  Game.Score_Image.Position.Y := Get_Centered_Position(Game.Panel_Top.Size.Y, Game.Score_Image.Size.Y);
  Game.Score_Image.Position.X := Game.Panel_Top.Size.X Div 2 + 16;

  Label_Set(Game.Score_Label, '0', Game.Ressources.Fonts[Font_Medium][Font_Normal], Color_Get(Color_Black));
  Game.Score_Label.Position.Y := Get_Centered_Position(Game.Panel_Top.Size.Y, Game.Score_Label.Size.Y);
  Game.Score_Label.Position.X := Game.Score_Image.Position.X + Game.Score_Image.Size.X + 16;

  Label_Set(Game.Clock_Label, 'Wednesday', Game.Ressources.Fonts[Font_Medium][Font_Normal], Color_Get(Color_Black));
  Game.Clock_Label.Position.Y := Get_Centered_Position(Game.Panel_Top.Size.Y, Game.Clock_Label.Size.Y);
  Game.Clock_Label.Position.X := Game.Panel_Top.Size.X Div 2 - 16 - Game.Clock_Label.Size.X;
  Label_Set_Text(Game.Clock_Label, 'Monday');

  Image_Set(Game.Clock_Image, Image_Load(Path_Image_Clock));
  Game.Clock_Image.Position.Y := Get_Centered_Position(Game.Panel_Top.Size.Y, Game.Clock_Image.Size.Y);
  Game.Clock_Image.Position.X := Game.Clock_Label.Position.X - 16 - Game.Clock_Image.Size.X;

  Dual_State_Button_Set(Game.Play_Pause_Button, Image_Load(Path_Image_Pause), Image_Load(Path_Image_Play), Image_Load(Path_Image_Pause), Image_Load(Path_Image_Play));

  Game.Play_Pause_Button.Position.Y := Get_Centered_Position(Game.Panel_Top.Size.Y, Game.Play_Pause_Button.Size.Y);
  Game.Play_Pause_Button.Position.X := Game.Panel_Top.Size.X - 16 - Game.Play_Pause_Button.Size.X;

  // Panneau de gauche

  For i := 0 To 2 Do
    Begin
      Button_Set(Game.Locomotive_Button[i], Image_Load(Path_Image_Button_Locomotive), Image_Load(Path_Image_Button_Locomotive));
      Button_Set(Game.Wagon_Button[i], Image_Load(Path_Image_Button_Wagon), Image_Load(Path_Image_Button_Wagon));
      Button_Set(Game.Tunnel_Button[i], Image_Load(Path_Image_Button_Tunnel), Image_Load(Path_Image_Button_Tunnel));
    End;

  Game.Locomotive_Button[0].Position.X := Get_Centered_Position(Game.Panel_Left.Size.X, Game.Locomotive_Button[0].Size.X);
  Game.Locomotive_Button[0].Position.Y := Get_Centered_Position(Game.Panel_Left.Size.Y, Game.Locomotive_Button[0].Size.X * 3 + 2 * 16);

  Game.Wagon_Button[0].Position.X := Get_Centered_Position(Game.Panel_Left.Size.X, Game.Wagon_Button[0].Size.X);
  Game.Wagon_Button[0].Position.Y := Game.Locomotive_Button[0].Position.Y + Game.Locomotive_Button[0].Size.Y + 16;

  Game.Tunnel_Button[0].Position.X := Get_Centered_Position(Game.Panel_Left.Size.X, Game.Tunnel_Button[0].Size.X);
  Game.Tunnel_Button[0].Position.Y := Game.Wagon_Button[0].Position.Y + Game.Wagon_Button[0].Size.Y + 16;

  For i := 1 To 2 Do
    Begin

      Game.Locomotive_Button[i].Position.X := Game.Locomotive_Button[0].Position.X + (i * 8);
      Game.Locomotive_Button[i].Position.Y := Game.Locomotive_Button[0].Position.Y;

      Game.Wagon_Button[i].Position.X := Game.Wagon_Button[0].Position.X + (i * 8);
      Game.Wagon_Button[i].Position.Y := Game.Wagon_Button[0].Position.Y;

      Game.Tunnel_Button[i].Position.X := Game.Tunnel_Button[0].Position.X + (i * 8);
      Game.Tunnel_Button[i].Position.Y := Game.Tunnel_Button[0].Position.Y;

    End;

  Animation_Load(Game.Animation);

End;

Procedure Graphics_Unload(Var Game : Type_Game);

Var i, j : Byte;
Begin
  // Libération de la mémoire des sprites.

  For i := 0 To 8 Do
    For j := 0 To 3 Do
      SDL_FreeSurface(Game.Ressources.Vehicles[i][j]);

  For i := 0 To Shapes_Number - 1 Do
    Begin
      SDL_FreeSurface(Game.Ressources.Stations[i]);
      SDL_FreeSurface(Game.Ressources.Passengers[i]);
    End;


  // Libération des polices de caractères.
  TTF_CloseFont(Game.Ressources.Fonts[Font_Small][Font_Normal]);
  TTF_CloseFont(Game.Ressources.Fonts[Font_Medium][Font_Normal]);
  TTF_CloseFont(Game.Ressources.Fonts[Font_Big][Font_Normal]);
  TTF_CloseFont(Game.Ressources.Fonts[Font_Small][Font_Bold]);
  TTF_CloseFont(Game.Ressources.Fonts[Font_Medium][Font_Bold]);
  TTF_CloseFont(Game.Ressources.Fonts[Font_Big][Font_Bold]);
End;

// Procédure rafraissant tout les éléments graphiques de l'écrans.
Procedure Graphics_Refresh(Var Game : Type_Game);

Var i, j : Byte;
Begin

  // - Nettoyage des panneaux
  // TODO : Remplacer avec Panel.Color.
  SDL_FillRect(Game.Window.Surface, Nil, SDL_MapRGBA(Game.Window.Surface^.format, 255, 255, 255, 255));
  SDL_FillRect(Game.Panel_Top.Surface, Nil, Color_To_Longword(Color_Get(255, 255, 255, 255)));
  SDL_FillRect(Game.Panel_Bottom.Surface, Nil, Color_To_Longword(Color_Get(255, 255, 255, 255)));

  // - Rendu dans le panneau du haut.

  Label_Render(Game.Score_Label, Game.Panel_Top);
  Image_Render(Game.Score_Image, Game.Panel_Top);
  Label_Render(Game.Clock_Label, Game.Panel_Top);
  Image_Render(Game.Clock_Image, Game.Panel_Top);
  Dual_State_Button_Render(Game.Play_Pause_Button, Game.Panel_Top);

  // - Rendu dans le panneau du bas.Game_Maximum_Lines_Number
  For i := low(Game.Lines) To high(Game.Lines) Do
    Dual_State_Button_Render(Game.Lines[i].Button, Game.Panel_Bottom);

  // - Panneau de gauche.

  Left_Panel_Render(Game, Game.Window);
  Right_Panel_Render(Game, Game.Window);

  // - Regroupement des surfaces dans la fenêtre.

  Panel_Render(Game.Panel_Top, Game.Window);
  Panel_Render(Game.Panel_Bottom, Game.Window);


  Cursor_Render(Game.Mouse, Game.Window, Game);


  SDL_Flip(Game.Window.Surface);
  Animation_Refresh(Game);

End;




// Fonction qui calcule les coordonnées centrée d'un objet à partir de sa position dans le repère et sa taille.

// Fonction déterminant l'orientation d'un angle parmis : 0, 45, 90, 135, 180, -45, -90, -135.
Function Graphics_Get_Direction(Angle : Real) : Integer;

Var Sign :   Integer;
Begin

  // Si l'angle est négatif (dans la partie inférieure du cercle),
  //son signe est inversé, mais pris en compte pour plus tard afin de simplfier la disjonction des cas.
  If (Angle < 0) Then
    Begin
      Angle := -Angle;
      Sign := -1;
    End
    // Si l'angle est positif mais dans la partie inférieur du cercle trigonométrique,
    // on lui ajoute 2Pi afin d'obtenir son analogue négatif puis comme pour le cas précédent,
    // on annule son signe et on prend en compte son signe pour plus tard.
  Else If (Angle > Pi) Then
         Begin
           Angle := -(Angle - (2*Pi));
           Sign := -1;
         End
  Else
    Sign := 1;

  If ((Angle >= 0) And (Angle < (Pi/8))) Then               // Si l'angle est entre 0° et 22.5°
    Graphics_Get_Direction := 0                             // L'orientation est de 0°;
  Else If ((Angle >= (Pi/8)) And (Angle < (3*Pi/8))) Then   // Si l'angle est entre 22.5° et 67.5°
         Graphics_Get_Direction := Sign * 45                // L'orientation est de 45° ou -45° (en fonction du signe).
  Else If ((Angle >= (3*Pi/8)) And (Angle < (5*Pi/8))) Then // Si l'angle est entre 67.5° et 112.5°
         Graphics_Get_Direction := Sign * 90                // L'orientation est de 90° ou -90° (en fonction du signe).
  Else If ((Angle >= (5*Pi/8)) And (Angle < (7*Pi/8))) Then // Si l'angle est entre 112.5° et 157.5°
         Graphics_Get_Direction := Sign * 135
                                   // L'orientation est de 135° ou -135° (en fonction du signe).
  Else If (Angle >= (7*Pi/8)) Then                          // Si l'angle est supérieur à 157.5°.
         Graphics_Get_Direction := 180;
  // L'orientatino est de 180°
End;

// Procédure qui dessine une ligne très épaisse (rivière entre deux points).
Procedure Graphics_Draw_River(Position_1, Position_2 :
                             Type_Coordinates; Color :
                             Type_Color; Var Panel : Type_Panel);

Var Direction : Integer;
  i : Integer;
Begin

  Direction := Graphics_Get_Direction(Get_Angle(Position_1, Position_2));

  // Index_Max  := Width / (sqrt(2) * 2)

  Case Direction Of 
    0, 180 :
             Begin
               For i := -20 To 20 Do
                 lineRGBA(Panel.Surface, Position_1.X, Position_1.Y  + i, Position_2.X, Position_2.Y + i, Color.Red, Color.Green, Color.Blue, Color.Alpha);
             End;
    45, -135 :
               Begin
                 For i := -14 To 0 Do
                   Begin
                     lineRGBA(Panel.Surface, Position_1.X + i, Position_1.Y + i, Position_2.X + i, Position_2.Y + i, Color.Red, Color.Green, Color.Blue, Color.Alpha);
                     lineRGBA(Panel.Surface, Position_1.X + i, Position_1.Y + i - 1, Position_2.X + i, Position_2.Y + i - 1, Color.Red, Color.Green, Color.Blue, Color.Alpha);
                   End;
                 For i := 0 To 14 Do
                   Begin
                     lineRGBA(Panel.Surface, Position_1.X + i, Position_1.Y + i, Position_2.X + i, Position_2.Y + i, Color.Red, Color.Green, Color.Blue, Color.Alpha);
                     lineRGBA(Panel.Surface, Position_1.X + i + 1, Position_1.Y + i, Position_2.X + i + 1, Position_2.Y + i, Color.Red, Color.Green, Color.Blue, Color.Alpha);
                   End;
               End;
    90, -90 :
              Begin
                For i := -20 To 20 Do
                  lineRGBA(Panel.Surface, Position_1.X + i, Position_1.Y, Position_2.X + i, Position_2.Y, Color.Red, Color.Green, Color.Blue, Color.Alpha);
              End;
    135, -45 :
               Begin
                 For i := -14 To 0 Do
                   Begin
                     lineRGBA(Panel.Surface, Position_1.X + i, Position_1.Y - i, Position_2.X + i, Position_2.Y - i, Color.Red, Color.Green, Color.Blue, Color.Alpha);
                     lineRGBA(Panel.Surface, Position_1.X + i, Position_1.Y - i + 1, Position_2.X + i, Position_2.Y - i + 1, Color.Red, Color.Green, Color.Blue, Color.Alpha);
                   End;
                 For i := 0 To 14 Do
                   Begin
                     lineRGBA(Panel.Surface, Position_1.X + i, Position_1.Y - i, Position_2.X + i, Position_2.Y - i, Color.Red, Color.Green, Color.Blue, Color.Alpha);
                     lineRGBA(Panel.Surface, Position_1.X + i + 1, Position_1.Y - i, Position_2.X + i + 1, Position_2.Y - i, Color.Red, Color.Green, Color.Blue, Color.Alpha);
                   End;
               End;
  End;

    Graphics_Draw_Filled_Circle(Panel.Surface, Position_1, 20, Color);

End;

// Procédure qui desinne une lign épaisse entre deux points.
Procedure Graphics_Draw_Line(Position_1, Position_2 :
                             Type_Coordinates; Color :
                             Type_Color; Var Panel : Type_Panel);

Var Direction : Integer;
  i : Integer;
Begin

  Direction := Graphics_Get_Direction(Get_Angle(Position_1, Position_2));

  Case Direction Of 
    0, 180 :
             Begin
               For i := -3 To 3 Do
                 lineRGBA(Panel.Surface, Position_1.X, Position_1.Y  + i, Position_2.X, Position_2.Y + i, Color.Red, Color.Green, Color.Blue, Color.Alpha);
             End;
    45, -135 :
               Begin
                 For i := -2 To 0 Do
                   Begin
                     lineRGBA(Panel.Surface, Position_1.X + i, Position_1.Y + i, Position_2.X + i, Position_2.Y + i, Color.Red, Color.Green, Color.Blue, Color.Alpha);
                     lineRGBA(Panel.Surface, Position_1.X + i, Position_1.Y + i - 1, Position_2.X + i, Position_2.Y + i - 1, Color.Red, Color.Green, Color.Blue, Color.Alpha);
                   End;
                 For i := 0 To 2 Do
                   Begin
                     lineRGBA(Panel.Surface, Position_1.X + i, Position_1.Y + i, Position_2.X + i, Position_2.Y + i, Color.Red, Color.Green, Color.Blue, Color.Alpha);
                     lineRGBA(Panel.Surface, Position_1.X + i + 1, Position_1.Y + i, Position_2.X + i + 1, Position_2.Y + i, Color.Red, Color.Green, Color.Blue, Color.Alpha);
                   End;
               End;
    90, -90 :
              Begin
                For i := -3 To 3 Do
                  lineRGBA(Panel.Surface, Position_1.X + i, Position_1.Y, Position_2.X + i, Position_2.Y, Color.Red, Color.Green, Color.Blue, Color.Alpha);
              End;
    135, -45 :
               Begin
                 For i := -2 To 0 Do
                   Begin
                     lineRGBA(Panel.Surface, Position_1.X + i, Position_1.Y - i, Position_2.X + i, Position_2.Y - i, Color.Red, Color.Green, Color.Blue, Color.Alpha);
                     lineRGBA(Panel.Surface, Position_1.X + i, Position_1.Y - i + 1, Position_2.X + i, Position_2.Y - i + 1, Color.Red, Color.Green, Color.Blue, Color.Alpha);
                   End;
                 For i := 0 To 2 Do
                   Begin
                     lineRGBA(Panel.Surface, Position_1.X + i, Position_1.Y - i, Position_2.X + i, Position_2.Y - i, Color.Red, Color.Green, Color.Blue, Color.Alpha);
                     lineRGBA(Panel.Surface, Position_1.X + i + 1, Position_1.Y - i, Position_2.X + i + 1, Position_2.Y - i, Color.Red, Color.Green, Color.Blue, Color.Alpha);
                   End;
               End;
  End;

End;

// - - Station

// - Procédure génère le rendu dans la fenêtre des traits entre les stations en utilisant que des angles de 0, 45 et 90 degrés.
Procedure Line_Render(Line : Type_Line; Var Panel : Type_Panel);

Var Intermediate_Position :   Type_Coordinates;
  i : Byte;
Begin
  // Si la ligne contient au moins une station.
  If (length(Line.Stations) > 0) Then
    Begin
      // Itère parmis les stations d'une ligne.
      For i := low(Line.Stations) + 1 To high(Line.Stations) Do
        Begin
          // - Affichage des traits représentant la ligne à partir des coordonnées centrées des stations.
          Intermediate_Position := Station_Get_Intermediate_Position(Line.Stations[i - 1]^.Position_Centered, Line.Stations[i]^.Position_Centered);
          Graphics_Draw_Line(Line.Stations[i - 1]^.Position_Centered, Intermediate_Position, Line.Color, Panel);
          Graphics_Draw_Line(Intermediate_Position, Line.Stations[i]^.Position_Centered, Line.Color, Panel);
        End;
    End;
End;

Procedure Train_Render(Var Train : Type_Train; Var Line : Type_Line; Ressources : Type_Ressources; Var Panel : Type_Panel);

Var Destination_Rectangle : TSDL_Rect;
  Direction : Integer;
  Norme : Integer;
Begin

  If (Train.Distance < Train.Maximum_Distance) Or (Train.Driving = false) Then
    Begin
      If (Train.Distance <= Train.Intermediate_Position_Distance) Then // Si le train se trouve avant le point intermédiaire.
        Begin
          // Calcul de l'angle et de la direction (arrondissement de l'angle à 45 degré près).
          Direction := Graphics_Get_Direction(Get_Angle(Train.Last_Station^.Position_Centered, Train.Intermediate_Position));
          Train.Position := Train.Last_Station^.Position_Centered;

          If ((Direction = 0) Or (Direction = 180) Or (Direction = 90) Or (Direction = -90)) Then
            Norme := Train.Distance
          Else
            Norme := round(sqrt(sqr(Train.Distance) * 0.5));
        End
      Else // Si le train se trouve après le point intermédiaire.
        Begin
          // - Détermination de l'angle de la droite entre le point intermédiaire et la station d'arrivée.
          Direction := Graphics_Get_Direction(Get_Angle(Train.Intermediate_Position, Train.Next_Station^.Position_Centered));

          Train.Position := Train.Intermediate_Position;

          If ((Direction = 0) Or (Direction = 180) Or (Direction = 90) Or (Direction = -90)) Then
            Norme := Train.Distance - Train.Intermediate_Position_Distance
          Else
            Norme := round(sqrt(sqr((Train.Distance - Train.Intermediate_Position_Distance)) * 0.5));

        End;

      Case Direction Of 
        0 :
            Begin
              Train.Position.X := Train.Position.X + Norme;
              Train.Sprite := Ressources.Vehicles[Train.Color_Index][0];
            End;
        180 :
              Begin
                Train.Position.X := Train.Position.X - Norme;
                Train.Sprite := Ressources.Vehicles[Train.Color_Index][0];
              End;
        90 :
             Begin
               Train.Position.Y := Train.Position.Y - Norme;
               Train.Sprite := Ressources.Vehicles[Train.Color_Index][2];
             End;
        -90 :
              Begin
                Train.Position.Y := Train.Position.Y + Norme;
                Train.Sprite := Ressources.Vehicles[Train.Color_Index][2];
              End;
        -45 :
              Begin
                Train.Position.X := Train.Position.X + Norme;
                Train.Position.Y := Train.Position.Y + Norme;
                Train.Sprite := Ressources.Vehicles[Train.Color_Index][3];
              End;
        -135 :
               Begin
                 Train.Position.X := Train.Position.X - Norme;
                 Train.Position.Y := Train.Position.Y + Norme;
                 Train.Sprite := Ressources.Vehicles[Train.Color_Index][1];
               End;
        45:
            Begin
              Train.Position.X := Train.Position.X + Norme;
              Train.Position.Y := Train.Position.Y - Norme;
              Train.Sprite := Ressources.Vehicles[Train.Color_Index][1];

            End;
        135:
             Begin
               Train.Position.X := Train.Position.X - Norme;
               Train.Position.Y := Train.Position.Y - Norme;
               Train.Sprite := Ressources.Vehicles[Train.Color_Index][3];
             End;
      End;


      Train.Position.X := round(Train.Position.X - (Train.Size.X*0.5));
      Train.Position.Y := round(Train.Position.Y - (Train.Size.X*0.5));

    End;

  Train.Size.X := Train.Sprite^.w;
  Train.Size.Y := Train.Sprite^.h;


  Destination_Rectangle.x := Train.Position.X;
  Destination_Rectangle.y := Train.Position.Y;

  SDL_BlitSurface(Train.Sprite, Nil, Panel.Surface, @Destination_Rectangle);

  // Affichage de l'étiquette du train.
  Destination_Rectangle.x := Destination_Rectangle.x + Get_Centered_Position(Train.Size.X, Train.Passengers_Label.Size.X);
  Destination_Rectangle.y := Destination_Rectangle.y + Get_Centered_Position(Train.Size.Y, Train.Passengers_Label.Size.Y);

  SDL_BlitSurface(Train.Passengers_Label.Surface, Nil, Panel.Surface, @Destination_Rectangle);
End;

Procedure Station_Render(Var Station : Type_Station; Var Panel : Type_Panel);

Var Destination_Rectangle :   TSDL_Rect;
  i :   Byte;
Begin
  // Display station
  Destination_Rectangle.x := Station.Position.X;
  Destination_Rectangle.y := Station.Position.Y;
  Destination_Rectangle.w := Station.Size.X;
  Destination_Rectangle.h := Station.Size.Y;

  SDL_BlitSurface(Station.Sprite, Nil, Panel.Surface, @Destination_Rectangle);

  // Display station passengers

  Destination_Rectangle.w := Passenger_Width;
  Destination_Rectangle.h := Passenger_Height;

  If (length(Station.Passengers) > 0) Then
    Begin
      For i := low(Station.Passengers) To high(Station.Passengers) Do
        Begin

          If (i < (low(Station.Passengers) + 3)) Then
            Begin
              Destination_Rectangle.x := (Station.Position.X - (2 *
                                         Station.Passengers[i]^.Size.X));
              Destination_Rectangle.y := Station.Position.Y + ((i Mod 3) * (
                                         Station.Passengers[i]^.Size.Y + 4));
            End
          Else If (i < (low(Station.Passengers) + 6)) Then
                 Begin
                   Destination_Rectangle.x := (Station.Position.X + Station.Size.X +
                                              Passenger_Width);

                   Destination_Rectangle.y := Station.Position.Y + ((i Mod 3) * (
                                              Station.Passengers[i]^.Size.Y + 4));
                 End
          Else If (i < (low(Station.Passengers) + 9)) Then
                 Begin
                   Destination_Rectangle.x := Station.Position.X + ((i Mod 3) * (
                                              Station.Passengers[i]^.Size.X + 4));

                   Destination_Rectangle.y := (Station.Position.Y - (2 *
                                              Station.Passengers[i]^.Size.Y));
                 End
          Else If (i < (low(Station.Passengers) + 12)) Then
                 Begin
                   Destination_Rectangle.x := Station.Position.X + ((i Mod 3) * (
                                              Station.Passengers[i]^.Size.X + 4));

                   Destination_Rectangle.y := (Station.Position.Y + Station.Size.Y +
                                              Passenger_Width);
                 End;


          SDL_BlitSurface(Station.Passengers[i]^.Sprite, Nil, Panel.Surface, @
                          Destination_Rectangle);
        End;
    End;
End;

End.
