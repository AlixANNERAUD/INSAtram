
Unit Unit_Graphics;

Interface

// - Dépendances

Uses Unit_Types, Unit_Common, Unit_Constants, Unit_Animations, sdl, sdl_image, sdl_ttf, sdl_gfx, sysutils, Math, Unit_Mouse;

// - Défintion des fonctions.

// - - Graphismes généraux

Procedure Graphics_Load(Var Game : Type_Game);
Procedure Graphics_Unload(Var Game : Type_Game);
Procedure Graphics_Refresh(Var Game : Type_Game);

// - - - Outils


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
Procedure Line_Render(Var Line : Type_Line; Var Panel : Type_Panel; Mouse : Type_Mouse);

Procedure Train_Render(Var Train : Type_Train; Var Line : Type_Line; Ressources : Type_Ressources; Var Panel : Type_Panel);

Procedure Left_Panel_Render(Var Game : Type_Game; Var Destination_Panel : Type_Panel);
Procedure Panel_Right_Render(Var Game : Type_Game; Var Destination_Panel : Type_Panel);

Procedure Pie_Render(Pie : Type_Pie; Var Destination_Panel : Type_Panel);

Procedure Panel_Reward_Render(Var Game : Type_Game; Var Destination_Panel : Type_Panel);

Function Station_Get_Absolute_Index(Station_Pointer : Type_Station_Pointer; Var Game : Type_Game) : Byte;

Implementation

// Procédure qui desinne une lign épaisse entre deux points.
Procedure Graphics_Draw_Line(Position_1, Position_2 :
                             Type_Coordinates; Color :
                             Type_Color; Var Panel : Type_Panel);

Var Direction : Integer;
  i : ShortInt;
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

Procedure Graphics_Draw_Lines(Position_1, Position_2 : Type_Coordinates; Colors : Array Of Type_Color; Var Panel : Type_Panel);

Var Direction : Integer;
  i : Integer;
  Start_Position : Type_Coordinates;
  Temporary_Position : Type_Coordinates;
Begin


  Direction := Graphics_Get_Direction(Get_Angle(Position_1, Position_2));

  If (Direction < 0) Or (Direction > 135) Then
    Begin
      Temporary_Position := Position_1;
      Position_1 := Position_2;
      Position_2 := Temporary_Position;
      Direction := Graphics_Get_Direction(Get_Angle(Position_1, Position_2));

    End;


  // Offset each line around the center line

  i := 0;


  Case Direction Of 
    0 :
        Begin

          Position_1.Y := Position_1.Y - ((7 * length(Colors)) Div 2);
          Position_2.Y := Position_2.Y + ((7 * length(Colors)) Div 2);

          If (length(Colors) Mod 2) = 0 Then
            dec(Position_2.Y);

          While (Position_1.Y <= Position_2.Y) Do
            Begin
              lineRGBA(Panel.Surface, Position_1.X, Position_1.Y, Position_2.X, Position_1.Y, Colors[i Div 7].Red, Colors[i Div 7].Green, Colors[i Div 7].Blue, Colors[i Div 7].Alpha);
              inc(Position_1.Y);
              inc(i);
            End;
        End;
    90 :
         Begin

           Position_1.X := Position_1.X - ((7 * length(Colors)) Div 2);
           Position_2.X := Position_2.X + ((7 * length(Colors)) Div 2);

           If (length(Colors) Mod 2) = 0 Then
             dec(Position_2.X);

           While (Position_1.X <= Position_2.X) Do
             Begin
               lineRGBA(Panel.Surface, Position_1.X, Position_1.Y, Position_1.X, Position_2.Y, Colors[i Div 7].Red, Colors[i Div 7].Green, Colors[i Div 7].Blue, Colors[i Div 7].Alpha);
               inc(Position_1.X);
               inc(i);
             End;

         End;

{
          45 :
               Begin

                 For i := Position_1.Y - (2 * length(Colors)) To Position_1.Y + (2 * length(Colors)) Do
                   Begin


                   End;


                 For i := (-2 * length(Colors)) To 0 Do
                   Begin
                     i := (i + (2 * length(Colors))) Div (2 * length(Colors));
                     lineRGBA(Panel.Surface, Position_1.X + i, Position_1.Y + i, Position_2.X + i, Position_2.Y + i, Colors[i].Red, Colors[i].Green, Colors[i].Blue, Colors[i].Alpha);
                     lineRGBA(Panel.Surface, Position_1.X + i, Position_1.Y + i - 1, Position_2.X + i, Position_2.Y + i - 1, Colors[i].Red, Colors[i].Green, Colors[i].Blue, Colors[i].Alpha);
                   End;
                 For i := 0 To (2 * length(Colors)) Do
                   Begin
                     i := (i + (2 * length(Colors))) Div (2 * length(Colors));
                     lineRGBA(Panel.Surface, Position_1.X + i, Position_1.Y + i, Position_2.X + i, Position_2.Y + i, Colors[i].Red, Colors[i].Green, Colors[i].Blue, Colors[i].Alpha);
                     lineRGBA(Panel.Surface, Position_1.X + i + 1, Position_1.Y + i, Position_2.X + i + 1, Position_2.Y + i, Colors[i].Red, Colors[i].Green, Colors[i].Blue, Colors[i].Alpha);
                   End;
               End;


          135 :
           
                Begin
                  For i := (-2 * length(Colors)) To 0 Do
                    Begin
                      i := (i + (2 * length(Colors))) Div (2 * length(Colors));
                      lineRGBA(Panel.Surface, Position_1.X + i, Position_1.Y - i, Position_2.X + i, Position_2.Y - i, Colors[i].Red, Colors[i].Green, Colors[i].Blue, Colors[i].Alpha);
                      lineRGBA(Panel.Surface, Position_1.X + i, Position_1.Y - i + 1, Position_2.X + i, Position_2.Y - i + 1, Colors[i].Red, Colors[i].Green, Colors[i].Blue, Colors[i].Alpha);
                    End;
                  For i := 0 To (2 * length(Colors)) Do
                    Begin
                      i := (i + (2 * length(Colors))) Div (2 * length(Colors));
                      lineRGBA(Panel.Surface, Position_1.X + i, Position_1.Y - i, Position_2.X + i, Position_2.Y - i, Colors[i].Red, Colors[i].Green, Colors[i].Blue, Colors[i].Alpha);
                      lineRGBA(Panel.Surface, Position_1.X + i + 1, Position_1.Y - i, Position_2.X + i + 1, Position_2.Y - i, Colors[i].Red, Colors[i].Green, Colors[i].Blue, Colors[i].Alpha);
                    End;
                End;
}


  End;
End;

// Fonction qui renvoie l'index absolu (dans le tableau de stations du jeu) d'une station à partir de son pointeur.
Function Station_Get_Absolute_Index(Station_Pointer : Type_Station_Pointer; Var Game : Type_Game) : Byte;

Var i : Byte;
Begin
  For i := low(Game.Stations) To high(Game.Stations) Do
    Begin
      If Station_Pointer = @Game.Stations[i] Then
        Begin
          Station_Get_Absolute_Index := i;
          break;
        End;
    End;
End;

Procedure Panel_Reward_Render(Var Game : Type_Game; Var Destination_Panel : Type_Panel);

Var i : Byte;
Begin
  If (Not(Game.Panel_Reward.Hidden)) Then
    Begin
      // - Remplissage du panneau en blanc.
      SDL_FillRect(Game.Panel_Reward.Surface, Nil, Color_To_Longword(Color_Get(255, 255, 255, 255)));

      // - Rendu des bordures.
      For i := 0 To 5 Do
        Begin
          hlineRGBA(Game.Panel_Reward.Surface, 0, Game.Panel_Reward.Size.X, i, 0, 0, 0, 255);
          hlineRGBA(Game.Panel_Reward.Surface, 0, Game.Panel_Reward.Size.X, Game.Panel_Reward.Size.Y - i, 0, 0, 0, 255);
          vlineRGBA(Game.Panel_Reward.Surface, i, 0, Game.Panel_Reward.Size.Y, 0, 0, 0, 255);
          vlineRGBA(Game.Panel_Reward.Surface, Game.Panel_Reward.Size.X - i, 0, Game.Panel_Reward.Size.Y, 0, 0, 0, 255);
        End;


      Label_Render(Game.Title_Label, Game.Panel_Reward);
      Label_Render(Game.Message_Label, Game.Panel_Reward);

      Button_Render(Game.Reward_Buttons[0], Game.Panel_Reward);
      Button_Render(Game.Reward_Buttons[1], Game.Panel_Reward);

      Label_Render(Game.Reward_Labels[0], Game.Panel_Reward);
      Label_Render(Game.Reward_Labels[1], Game.Panel_Reward);

      Panel_Render(Game.Panel_Reward, Destination_Panel);
    End;
End;


Procedure Pie_Render(Pie : Type_Pie; Var Destination_Panel : Type_Panel);

Var Destination_Rectangle : TSDL_Rect;
  Angle : Integer;
Begin

  If (Pie.Pre_Render) Then
    Begin
      // Convertino du pourcentage en angle, Angle en degrés.
      Angle := round(360 * (Pie.Percentage / 100) - 90);

      // On efface la surface.
      SDL_FillRect(Pie.Surface, Nil, $00000000);

      // On dessine le .
      filledPieRGBA(Pie.Surface, Pie.Size.X Div 2, Pie.Size.Y Div 2, (Pie.Size.X Div 2 - 1), -90, Angle, Pie.Color.Red, Pie.Color.Green, Pie.Color.Blue, Pie.Color.Alpha);
      aacircleRGBA(Pie.Surface, Pie.Size.X Div 2, Pie.Size.Y Div 2, (Pie.Size.X Div 2 - 1), Pie.Color.Red, Pie.Color.Green, Pie.Color.Blue, Pie.Color.Alpha);

      Pie.Pre_Render := false;
    End;

  Destination_Rectangle.x := Pie.Position.X;
  Destination_Rectangle.y := Pie.Position.Y;

  SDL_BlitSurface(Pie.Surface, Nil, Destination_Panel.Surface, @Destination_Rectangle);
End;

// Fonction qui rend le panneau de droite dans la fenêtre principale.
Procedure Panel_Right_Render(Var Game : Type_Game; Var Destination_Panel : Type_Panel);

Var i, j, k : Byte;
  Intermediate_Position, Mouse_Position: Type_Coordinates;
  Indexes : Array [0..1] Of Byte;
  Colors : Array Of Type_Color;
Begin

  If (Game.Play_Pause_Button.State = true) Then
    Begin

      // Nettoyage du panneau de droite.
      SDL_FillRect(Game.Panel_Right.Surface, Nil, Color_To_Longword(Color_Get(255, 255, 255, 255)));

      // - Rendu de la rivière.
      For i := low(Game.River) + 1 To high(Game.River) Do
        Graphics_Draw_River(Game.River[i - 1], Game.River[i], Color_Get(Color_Cyan), Game.Panel_Right);


      // - Affichage des lignes 

      For i := low(Game.Graph_Table) To high(Game.Graph_Table) - 1 Do
        Begin
          For j := low(Game.Graph_Table[i]) + i + 1 To high(Game.Graph_Table[i]) Do
            Begin
              If (length(Game.Graph_Table[i][j]) > 0) Then
                Begin
                  SetLength(Colors, length(Game.Graph_Table[i][j]));
                  For k := low(Game.Graph_Table[i][j]) To high(Game.Graph_Table[i][j]) Do
                    Begin
                      If (Game.Mouse.Mode = Type_Mouse_Mode.Line_Insert_Station) And (Game.Graph_Table[i][j][k] = Game.Mouse.Selected_Line) And ((@Game.Stations[i] = Game.Mouse.Selected_Next_Station
                         )
                         Or (@Game.Stations[j] = Game.Mouse.Selected_Next_Station)) Then
                        Begin
                          Mouse_Position := Panel_Get_Relative_Position(Mouse_Get_Position(), Destination_Panel);

                          Intermediate_Position := Station_Get_Intermediate_Position(Game.Mouse.Selected_Last_Station^.Position_Centered, Mouse_Position);

                          Graphics_Draw_Line(Game.Mouse.Selected_Last_Station^.Position_Centered, Intermediate_Position, Game.Mouse.Selected_Line^.Color, Destination_Panel);
                          Graphics_Draw_Line(Intermediate_Position, Mouse_Position, Game.Mouse.Selected_Line^.Color, Destination_Panel);

                          Intermediate_Position := Station_Get_Intermediate_Position(Game.Mouse.Selected_Next_Station^.Position_Centered, Mouse_Position);

                          Graphics_Draw_Line(Game.Mouse.Selected_Next_Station^.Position_Centered, Intermediate_Position, Game.Mouse.Selected_Line^.Color, Destination_Panel);
                          Graphics_Draw_Line(Intermediate_Position, Mouse_Position, Game.Mouse.Selected_Line^.Color, Destination_Panel);
                        End
                      Else
                        Colors[low(Colors) + k ] := Game.Graph_Table[i][j][k]^.Color;
                    End;

                  Intermediate_Position := Station_Get_Intermediate_Position(Game.Stations[i].Position_Centered, Game.Stations[j].Position_Centered);

                  Graphics_Draw_Lines(Game.Stations[i].Position_Centered, Intermediate_Position, Colors, Game.Panel_Right);
                  Graphics_Draw_Lines(Intermediate_Position, Game.Stations[j].Position_Centered, Colors, Game.Panel_Right);

                End;
            End;
        End;

      // - Affichage des trains.

      // Vérifie qu'il y a bien des lignes dans la partie.
      If (length(Game.Lines) > 0) Then
        Begin
          // Itère parmis les lignes.
          For i := low(Game.Lines) To high(Game.Lines) Do
            Begin
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


      // Si le curseur est en mode ajout de station à une ligne.
      If (Game.Mouse.Mode = Type_Mouse_Mode.Line_Add_Station) Then
        Begin
          Mouse_Position := Panel_Get_Relative_Position(Mouse_Get_Position(), Game.Panel_Right);

          Intermediate_Position := Station_Get_Intermediate_Position(Game.Mouse.Selected_Last_Station^.Position_Centered, Mouse_Position);

          Graphics_Draw_Line(Game.Mouse.Selected_Last_Station^.Position_Centered, Intermediate_Position, Game.Mouse.Selected_Line^.Color, Game.Panel_Right);

          Graphics_Draw_Line(Intermediate_Position, Mouse_Position, Game.Mouse.Selected_Line^.Color, Game.Panel_Right);
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
  Mouse_Position : Type_Coordinates;
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
  Panel_Set_Hidden(false, Panel);
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

Procedure Label_Pre_Render(Var Laabel : Type_Label);

Var   Characters : pChar;
  SDL_Color : PSDL_Color;
Begin
  new(SDL_Color);



  SDL_Color^.r := Laabel.Color.Red;
  SDL_Color^.g := Laabel.Color.Green;
  SDL_Color^.b := Laabel.Color.Blue;

  SDL_FreeSurface(Laabel.Surface);

  // Conversion du string en pChar.
  Characters := String_To_Characters(Laabel.Text);

  Laabel.Surface := TTF_RENDERTEXT_BLENDED(Laabel.Font, Characters,
                    SDL_Color^);

  TTF_SizeText(Laabel.Font, Characters, Laabel.Size.X, Laabel.Size.Y);

  dispose(SDL_Color);
  strDispose(Characters);

End;


// Procédure qui pré-rend le texte dans une surface lorsqu'un attribut de l'étiquette est modifié (moins lourd pour l'affichage) puis rend dans le panneau de destination.
Procedure Label_Render(Var Laabel : Type_Label; Var Panel : Type_Panel);

Var Destination_Rectangle : TSDL_Rect;
Begin

  If (Laabel.Pre_Render) Then
    Begin
      Label_Pre_Render(Laabel);
      Laabel.Pre_Render := false;
    End;

  Destination_Rectangle.x := Laabel.Position.X;
  Destination_Rectangle.y := Laabel.Position.Y;

  SDL_BlitSurface(Laabel.Surface, Nil, Panel.Surface, @Destination_Rectangle);
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


  // - Panneau de haut.

  Image_Set(Game.Score_Image, Image_Load(Path_Image_People));
  Game.Score_Image.Position.Y := Get_Centered_Position(Game.Panel_Top.Size.Y, Game.Score_Image.Size.Y);
  Game.Score_Image.Position.X := Game.Panel_Top.Size.X Div 2 + 16;

  Label_Set(Game.Score_Label, '0', Game.Ressources.Fonts[Font_Medium][Font_Normal], Color_Get(Color_Black));

  Label_Pre_Render(Game.Score_Label);

  Game.Score_Label.Position.Y := Get_Centered_Position(Game.Panel_Top.Size.Y, Game.Score_Label.Size.Y);
  Game.Score_Label.Position.X := Game.Score_Image.Position.X + Game.Score_Image.Size.X + 16;

  Label_Set(Game.Clock_Label, 'Wednesday', Game.Ressources.Fonts[Font_Medium][Font_Normal], Color_Get(Color_Black));

  Label_Pre_Render(Game.Clock_Label);

  Game.Clock_Label.Position.Y := Get_Centered_Position(Game.Panel_Top.Size.Y, Game.Clock_Label.Size.Y);
  Game.Clock_Label.Position.X := Game.Panel_Top.Size.X Div 2 - 16 - Game.Clock_Label.Size.X;

  Label_Set_Text(Game.Clock_Label, 'Monday');

  Image_Set(Game.Clock_Image, Image_Load(Path_Image_Clock));
  Game.Clock_Image.Position.Y := Get_Centered_Position(Game.Panel_Top.Size.Y, Game.Clock_Image.Size.Y);
  Game.Clock_Image.Position.X := Game.Clock_Label.Position.X - 16 - Game.Clock_Image.Size.X;

  Button_Set(Game.Escape_Button, Image_Load(Path_Image_Button_Escape), Image_Load(Path_Image_Button_Escape));
  Game.Escape_Button.Position.Y := Get_Centered_Position(Game.Panel_Top.Size.Y, Game.Escape_Button.Size.Y);
  Game.Escape_Button.Position.X := 16;

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

  // Panneau des récompenses.

  Panel_Create(Game.Panel_Reward, 0, 0, 400, 240);

  Game.Panel_Reward.Position.X := Get_Centered_Position(Game.Window.Size.X, Game.Panel_Reward.Size.X);
  Game.Panel_Reward.Position.Y := Get_Centered_Position(Game.Window.Size.Y, Game.Panel_Reward.Size.Y);

  Label_Set(Game.Title_Label, 'Week : 00', Game.Ressources.Fonts[Font_Big][Font_Bold], Color_Get(Color_Black));

  // Calcul des coordonnées centré dans le panneau
  Game.Title_Label.Position.X := Get_Centered_Position(Game.Panel_Reward.Size.X, Game.Title_Label.Size.X);
  Game.Title_Label.Position.Y := 16;


  Label_Set(Game.Message_Label, 'Choose your reward :', Game.Ressources.Fonts[Font_Medium][Font_Normal], Color_Get(Color_Black));

  Button_Set(Game.Reward_Buttons[0], Image_Load(Path_Image_Button_Locomotive), Image_Load(Path_Image_Button_Locomotive));

  Button_Set(Game.Reward_Buttons[1], Image_Load(Path_Image_Button_Wagon), Image_Load(Path_Image_Button_Wagon));

  Game.Reward_Buttons[0].Position.X := Get_Centered_Position(Game.Panel_Reward.Size.X Div 2, Game.Reward_Buttons[0].Size.X);
  Game.Reward_Buttons[0].Position.Y := Game.Panel_Reward.Size.Y - 16 - Game.Reward_Buttons[0].Size.Y;

  Game.Reward_Buttons[1].Position.X := Get_Centered_Position(Game.Panel_Reward.Size.X Div 2, Game.Reward_Buttons[1].Size.X) + Game.Panel_Reward.Size.X Div 2;
  Game.Reward_Buttons[1].Position.Y := Game.Reward_Buttons[0].Position.Y;

  Label_Set(Game.Reward_Labels[0], 'Locomotive', Game.Ressources.Fonts[Font_Medium][Font_Normal], Color_Get(Color_Black));

  Game.Reward_Labels[0].Position.X := Get_Centered_Position(Game.Panel_Reward.Size.X Div 2, Game.Reward_Labels[0].Size.X);

  Game.Reward_Labels[0].Position.Y := Game.Reward_Buttons[0].Position.Y - 16 - Game.Reward_Labels[0].Size.Y;

  Label_Set(Game.Reward_Labels[1], 'Wagon', Game.Ressources.Fonts[Font_Medium][Font_Normal], Color_Get(Color_Black));

  Game.Reward_Labels[1].Position.X := Get_Centered_Position(Game.Panel_Reward.Size.X Div 2, Game.Reward_Labels[1].Size.X) + Game.Panel_Reward.Size.X Div 2;

  Game.Reward_Labels[1].Position.Y := Game.Reward_Labels[0].Position.Y;

  // Calcul des coordonnées centré dans le panneau
  Game.Message_Label.Position.X := Get_Centered_Position(Game.Panel_Reward.Size.X, Game.Message_Label.Size.X);
  Game.Message_Label.Position.Y := Game.Title_Label.Position.Y + Game.Title_Label.Size.Y + 16;


  Panel_Set_Hidden(True, Game.Panel_Reward);

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
  Button_Render(Game.Escape_Button, Game.Panel_Top);

  // - Rendu dans le panneau du bas.Game_Maximum_Lines_Number
  For i := low(Game.Lines) To high(Game.Lines) Do
    Dual_State_Button_Render(Game.Lines[i].Button, Game.Panel_Bottom);

  // - Panneau de gauche.




  Left_Panel_Render(Game, Game.Window);




  Panel_Right_Render(Game, Game.Window);

  Cursor_Render(Game.Mouse, Game.Window, Game);



  // - Regroupement des surfaces dans la fenêtre.

  Panel_Render(Game.Panel_Top, Game.Window);
  Panel_Render(Game.Panel_Bottom, Game.Window);

  Panel_Reward_Render(Game, Game.Window);


  SDL_Flip(Game.Window.Surface);
  Animation_Refresh(Game);

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




// - Procédure génère le rendu dans la fenêtre des traits entre les stations en utilisant que des angles de 0, 45 et 90 degrés.
Procedure Line_Render(Var Line : Type_Line; Var Panel : Type_Panel; Mouse : Type_Mouse);

Var Intermediate_Position, Mouse_Position :   Type_Coordinates;
  i, j : Byte;
  Indexes : Array[0 .. 1] Of Byte;
Begin
  // Si la ligne contient au moins une station.
  If (length(Line.Stations) > 0) Then
    Begin
      // Itère parmis les stations d'une ligne.
      For i := low(Line.Stations) + 1 To high(Line.Stations) Do
        Begin
          If (Mouse.Mode = Type_Mouse_Mode.Line_Insert_Station) And (@Line = Mouse.Selected_Line) And (Line.Stations[i] = Mouse.Selected_Next_Station) Then
            Begin

              Mouse_Position := Panel_Get_Relative_Position(Mouse_Get_Position(), Panel);

              Intermediate_Position := Station_Get_Intermediate_Position(Mouse.Selected_Last_Station^.Position_Centered, Mouse_Position);

              Graphics_Draw_Line(Mouse.Selected_Last_Station^.Position_Centered, Intermediate_Position, Mouse.Selected_Line^.Color, Panel);

              Graphics_Draw_Line(Intermediate_Position, Mouse_Position, Mouse.Selected_Line^.Color, Panel);

              Intermediate_Position := Station_Get_Intermediate_Position(Mouse.Selected_Next_Station^.Position_Centered, Mouse_Position);

              Graphics_Draw_Line(Mouse.Selected_Next_Station^.Position_Centered, Intermediate_Position, Mouse.Selected_Line^.Color, Panel);

              Graphics_Draw_Line(Intermediate_Position, Mouse_Position, Mouse.Selected_Line^.Color, Panel);
            End
          Else
            Begin
              // - Affichage des traits représentant la ligne à partir des coordonnées centrées des stations.
              Intermediate_Position := Station_Get_Intermediate_Position(Line.Stations[i - 1]^.Position_Centered, Line.Stations[i]^.Position_Centered);
              Graphics_Draw_Line(Line.Stations[i - 1]^.Position_Centered, Intermediate_Position, Line.Color, Panel);
              Graphics_Draw_Line(Intermediate_Position, Line.Stations[i]^.Position_Centered, Line.Color, Panel);
            End;
        End;
    End;
End;

Procedure Train_Render(Var Train : Type_Train; Var Line : Type_Line; Ressources : Type_Ressources; Var Panel : Type_Panel);

Var Destination_Rectangle : TSDL_Rect;
  Direction, Norme : Integer;
  i, j, k : Byte;
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

  // - Affichage de l'étiquette du train.

  // Définition du texte de l'étiquette.

  Train.Passengers_Label.Position.X := Destination_Rectangle.x + Get_Centered_Position(Train.Size.X, Train.Passengers_Label.Size.X);
  Train.Passengers_Label.Position.Y := Destination_Rectangle.y + Get_Centered_Position(Train.Size.Y, Train.Passengers_Label.Size.Y);

  Label_Render(Train.Passengers_Label, Panel);
End;

Procedure Station_Render(Var Station : Type_Station; Var Panel : Type_Panel);

Var Destination_Rectangle :   TSDL_Rect;
  i :   Byte;
Begin
  // - Affichage de la station.
  Destination_Rectangle.x := Station.Position.X;
  Destination_Rectangle.y := Station.Position.Y;
  Destination_Rectangle.w := Station.Size.X;
  Destination_Rectangle.h := Station.Size.Y;

  SDL_BlitSurface(Station.Sprite, Nil, Panel.Surface, @Destination_Rectangle);

  // - Affichage des passagers de la station.

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
                                              Station.Passengers[i]^.Size.X);

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
                                              Station.Passengers[i]^.Size.Y);
                 End;


          SDL_BlitSurface(Station.Passengers[i]^.Sprite, Nil, Panel.Surface, @
                          Destination_Rectangle);
        End;
    End;

  // Affichage du minuteur de la station.

  If (Station.Overfill_Timer <> 0) Then
    Begin
      Pie_Set_Percentage(Station.Timer, (Time_Get_Elapsed(Station.Overfill_Timer) / (Station_Overfill_Timer * 10)) mod 100);
      Pie_Render(Station.Timer, Panel);
    End;

End;

End.
