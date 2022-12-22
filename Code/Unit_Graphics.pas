
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

Procedure Label_Pre_Render(Var Laabel : Type_Label);



Implementation



// Procédure qui rend le curseur dans le fenêtre principale.
Procedure Cursor_Render(Mouse : Type_Mouse; Var Destination_Panel : Type_Panel; Var Game : Type_Game);
Var Destination_Rectangle : TSDL_Rect;
Begin
  // Si le curseur est en mode ajout de locomotives ou de wagons.
  If (Mouse.Mode = Type_Mouse_Mode.Add_Locomotive) Or (Mouse.Mode = Type_Mouse_Mode.Add_Wagon) Then
    Begin
      Destination_Rectangle.x := Mouse_Get_Position().X - Vehicle_Size.X Div 2;
      Destination_Rectangle.y := Mouse_Get_Position().Y - Vehicle_Size.Y Div 2;

      SDL_BlitSurface(Game.Ressources.Vehicles[8][0], Nil, Game.Window.Surface, @Destination_Rectangle);
    End
End;

// Procédure qui rend un bouton à double état.
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




// Procédure qui rend un bouton dans un panneau donné.
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

// Procédure qui rend un image dans un panneau donnée.
Procedure Image_Render(Var Image : Type_Image; Destination_Panel : Type_Panel);

Var Destination_Rectangle : TSDL_Rect;
Begin
  Destination_Rectangle.x := Image.Position.X;
  Destination_Rectangle.y := Image.Position.Y;
  Destination_Rectangle.w := Image.Size.X;
  Destination_Rectangle.h := Image.Size.Y;

  SDL_BlitSurface(Image.Surface, Nil, Destination_Panel.Surface, @Destination_Rectangle);
End;



// Procédure qui rend un panneau dans un autre panneau donné.
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

// Procédure qui effectue un rendu anticipé d'une étiquette (pré-rendu).
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


// Fonction qui convertit une structure couleur en un nombre.
Function Color_To_Longword(Color : Type_Color) : Longword;
Begin
  Color_To_Longword := (Color.Red << 16) Or (Color.Green << 8) Or (Color.Blue) Or (Color.Alpha << 24);
End;


// Procédure qui dessine une ligne épaisse entre deux points.
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

// Procédure qui trace les lignes parrallèelement les unes aux autres.
Procedure Graphics_Draw_Lines(Position_1, Position_2 : Type_Coordinates; Colors : Array Of Type_Color; Var Panel : Type_Panel);

Var Direction : Integer;
  i : Integer;
  Temporary_Position : Type_Coordinates;

  Intermediate_Position : Type_Coordinates;
  Intermediate_Position_2 : Type_Coordinates;

  P : Type_Coordinates;

Begin


  If (Get_Angle(Position_1, Position_2) < 0) Then
    Begin
      Temporary_Position := Position_1;
      Position_1 := Position_2;
      Position_2 := Temporary_Position;
      Direction := Graphics_Get_Direction(Get_Angle(Position_1, Position_2));
    End;

  // - Traçage du segment entre la postion de la première station et la position intermédiaire.

  Intermediate_Position := Station_Get_Intermediate_Position(Position_1, Position_2);
  Intermediate_Position_2 := Station_Get_Intermediate_Position(Position_2, Position_1);

  Direction := Graphics_Get_Direction(Get_Angle(Position_1, Intermediate_Position));

  If (Position_1.Y < Position_2.Y) Then
    P.X := 1
  Else
    P.X := -1;

  If (Position_1.X < Position_2.X) Then
    P.Y := -1
  Else
    P.Y := 1;

  Case Direction Of 
    0 : P.Y := -1;
    180 : P.Y := 1;
    90 : P.X := -1;
    -90 : P.X := 1;
  End;

  i := 0;

  Position_1.X := Position_1.X - P.X * (7 * length(Colors) Div 2);
  Position_1.Y := Position_1.Y - P.Y * (7 * length(Colors) Div 2);

  Intermediate_Position.X := Intermediate_Position.X - P.X * (7 * length(Colors) Div 2);
  Intermediate_Position.Y := Intermediate_Position.Y - P.Y * (7 * length(Colors) Div 2);

  Repeat
    lineRGBA(Panel.Surface, Position_1.X, Position_1.Y, Intermediate_Position.X, Intermediate_Position.Y, Colors[i Div 7].Red, Colors[i Div 7].Green, Colors[i Div 7].Blue, Colors[i Div 7].Alpha);

    Position_1.X := Position_1.X + P.X;
    Position_1.Y := Position_1.Y + P.Y;
    Intermediate_Position.X := Intermediate_Position.X + P.X;
    Intermediate_Position.Y := Intermediate_Position.Y + P.Y;

    inc(i);
  Until i >= 7 * length(Colors);


  Position_1.X := Position_1.X - P.X * (7 * length(Colors) Div 2);
  Position_1.Y := Position_1.Y - P.Y * (7 * length(Colors) Div 2);

  Intermediate_Position := Intermediate_Position_2;


  // Traçage du segment entre le point intermédiaire et la seconde station.

  Direction := Graphics_Get_Direction(Get_Angle(Intermediate_Position, Position_2));

  If (Direction > 0) Then
    P.X := -1
  Else
    P.X := 1;

  If (Direction = 45) Or (Direction = -45) Then
    P.Y := -1
  Else
    P.Y := 1;

  i := 0;

  Intermediate_Position.X := Intermediate_Position.X - P.X * (5 * length(Colors) Div 2);
  Intermediate_Position.Y := Intermediate_Position.Y - P.Y * (5 * length(Colors) Div 2);
  Position_2.X := Position_2.X - P.X * (5 * length(Colors) Div 2);
  Position_2.Y := Position_2.Y - P.Y * (5 * length(Colors) Div 2);

  Repeat
    lineRGBA(Panel.Surface, Intermediate_Position.X, Intermediate_Position.Y, Position_2.X, Position_2.Y, Colors[i Div 5].Red, Colors[i Div 5].Green, Colors[i Div 5].Blue, Colors[i Div 5].Alpha);

    Intermediate_Position.X := Intermediate_Position.X + P.X;
    Position_2.X := Position_2.X + P.X;

    lineRGBA(Panel.Surface, Intermediate_Position.X, Intermediate_Position.Y, Position_2.X, Position_2.Y, Colors[i Div 5].Red, Colors[i Div 5].Green, Colors[i Div 5].Blue, Colors[i Div 5].Alpha);

    Intermediate_Position.Y := Intermediate_Position.Y + P.Y;
    Position_2.Y := Position_2.Y + P.Y;

    lineRGBA(Panel.Surface, Intermediate_Position.X, Intermediate_Position.Y, Position_2.X, Position_2.Y, Colors[i Div 5].Red, Colors[i Div 5].Green, Colors[i Div 5].Blue, Colors[i Div 5].Alpha);

    inc(i);
  Until i >= 5 * length(Colors);

End;


// Procédure qui dessine le panneau des récompenses.
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


      Label_Render(Game.Reward_Title_Label, Game.Panel_Reward);
      Label_Render(Game.Reward_Message_Label, Game.Panel_Reward);

      Button_Render(Game.Reward_Buttons[0], Game.Panel_Reward);
      Button_Render(Game.Reward_Buttons[1], Game.Panel_Reward);

      Label_Render(Game.Reward_Labels[0], Game.Panel_Reward);
      Label_Render(Game.Reward_Labels[1], Game.Panel_Reward);

      Panel_Render(Game.Panel_Reward, Destination_Panel);
    End;
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



// Procédure qui affiche le timer des stations.
Procedure Pie_Render(Pie : Type_Pie; Var Destination_Panel : Type_Panel);

Var Destination_Rectangle : TSDL_Rect;
    Angle : Integer;
Begin

  If (Pie.Pre_Render) Then
    Begin
      // Conversion du pourcentage en angle, Angle en degrés.
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

// Procédure qui rend un train dans un panneau donné.
Procedure Train_Render(Var Train : Type_Train; Var Line : Type_Line; Ressources : Type_Ressources; Var Panel : Type_Panel);

Var Destination_Rectangle : TSDL_Rect;
    Direction, Norme : Integer;
  
Begin
  // Si le train est en mouvement (évite de refaire les calculs inutilement).
  If (Train.Driving) Then
    Begin
      // Si le train se trouve avant le point intermédiaire.
      If (Train.Distance <= Train.Intermediate_Position_Distance) Then
        Begin
          // Calcul de l'angle et de la direction (arrondissement de l'angle à 45 degré près).
          Direction := Graphics_Get_Direction(Get_Angle(Train.Last_Station^.Position_Centered, Train.Intermediate_Position));

          Train.Position := Train.Last_Station^.Position_Centered;

          If ((Direction = 0) Or (Direction = 180) Or (Direction = 90) Or (Direction = -90)) Then
            Norme := Train.Distance
          Else
            Norme := round(sqrt(sqr(Train.Distance) * 0.5));
        End
        // Si le train se trouve après le point intermédiaire.
      Else
        Begin
          // - Détermination de l'angle de la droite entre le point intermédiaire et la station d'arrivée.
          Direction := Graphics_Get_Direction(Get_Angle(Train.Intermediate_Position, Train.Next_Station^.Position_Centered));

          Train.Position := Train.Intermediate_Position;

          If ((Direction = 0) Or (Direction = 180) Or (Direction = 90) Or (Direction = -90)) Then
            Norme := Train.Distance - Train.Intermediate_Position_Distance
          Else
            Norme := round(sqrt(sqr((Train.Distance - Train.Intermediate_Position_Distance)) * 0.5));

        End;

      // - Application de la norme en fonction de la direction du train et modification de son sprite en conséquence.

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

      // Transformation des coordonnées centrées en coordonnées en haut à gauche.
      Train.Position.X := round(Train.Position.X - (Train.Size.X*0.5));
      Train.Position.Y := round(Train.Position.Y - (Train.Size.Y*0.5));

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

// Procédure qui rend une station dans un panneau donné.
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


// Procédure qui rend le panneau de droite dans la fenêtre principale.
Procedure Panel_Right_Render(Var Game : Type_Game; Var Destination_Panel : Type_Panel);

Var i, j, k : Byte;
  Intermediate_Position, Mouse_Position: Type_Coordinates;
  Colors : Array Of Type_Color;
  Mouse_Colors : Array Of Type_Color;
Begin

  If (Game.Play_Pause_Button.State = true) Then
    Begin

      // Nettoyage du panneau de droite.
      SDL_FillRect(Game.Panel_Right.Surface, Nil, Color_To_Longword(Color_Get(255, 255, 255, 255)));

      // - Rendu de la rivière.
      For i := low(Game.River) + 1 To high(Game.River) Do
        Graphics_Draw_River(Game.River[i - 1], Game.River[i], Color_Get(Color_Cyan), Game.Panel_Right);


      // - Affichage des lignes 

      If (length(Game.Graph_Table) > 0) Then
        Begin

          For i := low(Game.Graph_Table) To high(Game.Graph_Table) - 1 Do
            Begin
              For j := low(Game.Graph_Table[i]) + i + 1 To high(Game.Graph_Table[i]) Do
                Begin
                  If (length(Game.Graph_Table[i][j]) = 1) Then
                    Begin
                      SetLength(Colors, 0);
                      For k := low(Game.Graph_Table[i][j]) To high(Game.Graph_Table[i][j]) Do
                        Begin
                          If (Game.Mouse.Mode = Type_Mouse_Mode.Line_Insert_Station) And (Game.Graph_Table[i][j][k] = Game.Mouse.Selected_Line) And (((Game.Stations[i] = Game.Mouse.
                             Selected_Last_Station)
                             And (Game.Stations[j] = Game.Mouse.Selected_Next_Station)) Or ((Game.Stations[j] = Game.Mouse.Selected_Last_Station)
                             And (Game.Stations[i] = Game.Mouse.Selected_Next_Station))) Then
                            Begin


                              Mouse_Position := Panel_Get_Relative_Position(Mouse_Get_Position(), Game.Panel_Right);

                              Intermediate_Position := Station_Get_Intermediate_Position(Game.Mouse.Selected_Last_Station^.Position_Centered, Mouse_Position);

                              Graphics_Draw_Line(Game.Mouse.Selected_Last_Station^.Position_Centered, Intermediate_Position, Game.Mouse.Selected_Line^.Color, Game.Panel_Right);
                              Graphics_Draw_Line(Intermediate_Position, Mouse_Position, Game.Mouse.Selected_Line^.Color, Game.Panel_Right);

                              Intermediate_Position := Station_Get_Intermediate_Position(Game.Mouse.Selected_Next_Station^.Position_Centered, Mouse_Position);

                              Graphics_Draw_Line(Game.Mouse.Selected_Next_Station^.Position_Centered, Intermediate_Position, Game.Mouse.Selected_Line^.Color, Game.Panel_Right);
                              Graphics_Draw_Line(Intermediate_Position, Mouse_Position, Game.Mouse.Selected_Line^.Color, Game.Panel_Right);
                            End
                          Else
                            Begin
                              SetLength(Colors, length(Colors) + 1);
                              Colors[high(Colors)] := Game.Graph_Table[i][j][k]^.Color;
                            End;
                        End;

                      If (length(Colors) > 0) Then
                        Begin
                          Graphics_Draw_Lines(Game.Stations[i]^.Position_Centered, Game.Stations[j]^.Position_Centered, Colors, Game.Panel_Right);
                        End;
                    End;
                End;
            End;

          For i := low(Game.Graph_Table) To high(Game.Graph_Table) - 1 Do
            Begin
              For j := low(Game.Graph_Table[i]) + i + 1 To high(Game.Graph_Table[i]) Do
                Begin
                  If (length(Game.Graph_Table[i][j]) = 2) Then
                    Begin
                      SetLength(Colors, 0);
                      For k := low(Game.Graph_Table[i][j]) To high(Game.Graph_Table[i][j]) Do
                        Begin
                          If (Game.Mouse.Mode = Type_Mouse_Mode.Line_Insert_Station) And (Game.Graph_Table[i][j][k] = Game.Mouse.Selected_Line) And (((Game.Stations[i] = Game.Mouse.
                             Selected_Last_Station)
                             And (Game.Stations[j] = Game.Mouse.Selected_Next_Station)) Or ((Game.Stations[j] = Game.Mouse.Selected_Last_Station)
                             And (Game.Stations[i] = Game.Mouse.Selected_Next_Station))) Then
                            Begin
                              Mouse_Position := Panel_Get_Relative_Position(Mouse_Get_Position(), Game.Panel_Right);

                              Intermediate_Position := Station_Get_Intermediate_Position(Game.Mouse.Selected_Last_Station^.Position_Centered, Mouse_Position);

                              Graphics_Draw_Line(Game.Mouse.Selected_Last_Station^.Position_Centered, Intermediate_Position, Game.Mouse.Selected_Line^.Color, Game.Panel_Right);
                              Graphics_Draw_Line(Intermediate_Position, Mouse_Position, Game.Mouse.Selected_Line^.Color, Game.Panel_Right);

                              Intermediate_Position := Station_Get_Intermediate_Position(Game.Mouse.Selected_Next_Station^.Position_Centered, Mouse_Position);

                              Graphics_Draw_Line(Game.Mouse.Selected_Next_Station^.Position_Centered, Intermediate_Position, Game.Mouse.Selected_Line^.Color, Game.Panel_Right);
                              Graphics_Draw_Line(Intermediate_Position, Mouse_Position, Game.Mouse.Selected_Line^.Color, Game.Panel_Right);
                            End
                          Else
                            Begin
                              SetLength(Colors, length(Colors) + 1);
                              Colors[high(Colors)] := Game.Graph_Table[i][j][k]^.Color;
                            End;
                        End;

                      If (length(Colors) > 0) Then
                        Begin
                          Graphics_Draw_Lines(Game.Stations[i]^.Position_Centered, Game.Stations[j]^.Position_Centered, Colors, Game.Panel_Right);
                        End;
                    End;
                End;
            End;

          For i := low(Game.Graph_Table) To high(Game.Graph_Table) - 1 Do
            Begin
              For j := low(Game.Graph_Table[i]) + i + 1 To high(Game.Graph_Table[i]) Do
                Begin
                  If (length(Game.Graph_Table[i][j]) = 3) Then
                    Begin
                      SetLength(Colors, 0);
                      For k := low(Game.Graph_Table[i][j]) To high(Game.Graph_Table[i][j]) Do
                        Begin
                          If (Game.Mouse.Mode = Type_Mouse_Mode.Line_Insert_Station) And (Game.Graph_Table[i][j][k] = Game.Mouse.Selected_Line) And (((Game.Stations[i] = Game.Mouse.
                             Selected_Last_Station)
                             And (Game.Stations[j] = Game.Mouse.Selected_Next_Station)) Or ((Game.Stations[j] = Game.Mouse.Selected_Last_Station)
                             And (Game.Stations[i] = Game.Mouse.Selected_Next_Station))) Then
                            Begin
                              Mouse_Position := Panel_Get_Relative_Position(Mouse_Get_Position(), Game.Panel_Right);

                              Intermediate_Position := Station_Get_Intermediate_Position(Game.Mouse.Selected_Last_Station^.Position_Centered, Mouse_Position);

                              Graphics_Draw_Line(Game.Mouse.Selected_Last_Station^.Position_Centered, Intermediate_Position, Game.Mouse.Selected_Line^.Color, Game.Panel_Right);
                              Graphics_Draw_Line(Intermediate_Position, Mouse_Position, Game.Mouse.Selected_Line^.Color, Game.Panel_Right);

                              Intermediate_Position := Station_Get_Intermediate_Position(Game.Mouse.Selected_Next_Station^.Position_Centered, Mouse_Position);

                              Graphics_Draw_Line(Game.Mouse.Selected_Next_Station^.Position_Centered, Intermediate_Position, Game.Mouse.Selected_Line^.Color, Game.Panel_Right);
                              Graphics_Draw_Line(Intermediate_Position, Mouse_Position, Game.Mouse.Selected_Line^.Color, Game.Panel_Right);
                            End
                          Else
                            Begin
                              SetLength(Colors, length(Colors) + 1);
                              Colors[high(Colors)] := Game.Graph_Table[i][j][k]^.Color;
                            End;
                        End;

                      If (length(Colors) > 0) Then
                        Begin
                          Graphics_Draw_Lines(Game.Stations[i]^.Position_Centered, Game.Stations[j]^.Position_Centered, Colors, Game.Panel_Right);
                        End;
                    End;
                End;
            End;


        End;

      // - Affichage des trains.

      // Vérifie qu'il y a bien des lignes dans la partie.
      If (length(Game.Lines) > 0) Then
        Begin
          // Itère parmi les lignes.
          For i := low(Game.Lines) To high(Game.Lines) Do
            Begin
              // Si la ligne contient des trains.
              If (length(Game.Lines[i].Trains) > 0) Then
                Begin
                  // Itère parmi les trains d'une ligne.
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
          // - Affichage des stations.
          For i := low(Game.Stations) To high(Game.Stations) Do
            Begin
              Station_Render(Game.Stations[i]^, Game.Panel_Right);
            End;
        End;
    End;

  Panel_Render(Game.Panel_Right, Game.Window);

End;

// Fonction qui charge une image à partir d'un fichier de manière optimisée.
Function Image_Load(Path : String) : PSDL_Surface;

Var Image : PSDL_Surface;
  Optimized_Image : PSDL_Surface;
  Color_Key : Longword;
  Path_Characters : pChar;
Begin
  // Conversion de la chaîne de caractères en tableau de caractères.
  Path_Characters := String_To_Characters(Path);
  // Chargement de l'image.
  Image := IMG_Load(Path_Characters);
  // Optimisation de l'image.
  Optimized_Image := SDL_DisplayFormatAlpha(Image);
  // Libération de l'image non optimisée.
  SDL_FreeSurface(Image);
  // Suppression de la chaîne de caractères.
  strDispose(Path_Characters);
  // Définition de la clé couleur.
  Color_Key := SDL_MapRGBA(Optimized_Image^.Format, 255, 0, 255, 255);
  SDL_SetColorKey(Optimized_Image, SDL_SRCCOLORKEY, Color_Key);

  Image_Load := Optimized_Image;
End;

// Procédure qui rend le panneau de gauche dans la fenêtre principale.
Procedure Panel_Left_Render(Var Game : Type_Game; Var Destination_Panel : Type_Panel);

Var i : Byte;
Begin
  // Nettoyage du panneau de gauche.
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

Procedure Ressources_Unload(Var Ressources : Type_Ressources);
Var i, j : Byte;
Begin

  // Libération de la mémoire des sprites.
  For i := 0 To 8 Do

    For j := 0 To 3 Do
      SDL_FreeSurface(Ressources.Vehicles[i][j]);

  For i := 0 To Game_Shapes_Number - 1 Do
    Begin
      SDL_FreeSurface(Ressources.Stations[i]);
      SDL_FreeSurface(Ressources.Passengers[i]);
    End;

  SDL_FreeSurface(Ressources.Train_Add);
  SDL_FreeSurface(Ressources.Wagon_Add );
  SDL_FreeSurface(Ressources.Tunnel_Add);
  SDL_FreeSurface(Ressources.Line_Add);
  SDL_FreeSurface(Ressources.Clock);
  SDL_FreeSurface(Ressources.Play);
  SDL_FreeSurface(Ressources.Pause);

  // Libération des polices de caractères.
  TTF_CloseFont(Ressources.Fonts[Font_Small][Font_Normal]);
  TTF_CloseFont(Ressources.Fonts[Font_Medium][Font_Normal]);
  TTF_CloseFont(Ressources.Fonts[Font_Big][Font_Normal]);
  TTF_CloseFont(Ressources.Fonts[Font_Small][Font_Bold]);
  TTF_CloseFont(Ressources.Fonts[Font_Medium][Font_Bold]);
  TTF_CloseFont(Ressources.Fonts[Font_Big][Font_Bold]);

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

  // - - Passager
  Ressources.Passengers[0] := Image_Load(Path_Image_Passenger_Circle);
  Ressources.Passengers[1] := Image_Load(Path_Image_Passenger_Lozenge);
  Ressources.Passengers[2] := Image_Load(Path_Image_Passenger_Pentagon);
  Ressources.Passengers[3] := Image_Load(Path_Image_Passenger_Square);
  Ressources.Passengers[4] := Image_Load(Path_Image_Passenger_Triangle);


  // - - Véhicule (Locomotive et Wagon)

  Position.X := 0;
  Position.Y := 0;

  // Itère parmi les couleurs de véhicule.
  For i := 0 To 8 Do
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
        8 : Color := Color_Black;
      End;

      // Crée la surface de base (orientation 0 degré).
      Ressources.Vehicles[i][0] := Graphics_Surface_Create(Vehicle_Size.X, Vehicle_Size.Y);
      // Dessine un rectangle plein de la couleur du véhicule.
      Graphics_Draw_Filled_Rectangle(Ressources.Vehicles[i][0], Position, Vehicle_Size, Color_Get(Color));

      // Génère les 3 autres surfaces qui sont l'image par rotation de la première surface (45, 90 et 135°).
      Ressources.Vehicles[i][1] := rotozoomSurface(Ressources.Vehicles[i][0], 45, 1, 1);
      Ressources.Vehicles[i][2] := rotozoomSurface(Ressources.Vehicles[i][0], 90, 1, 1);
      Ressources.Vehicles[i][3] := rotozoomSurface(Ressources.Vehicles[i][0], 135, 1, 1);
    End;


  // - Chargement des images des boutons de l'interface.

  Ressources.Sound[0] := Image_Load(Path_Image_Button_Sound_On);
  Ressources.Sound[1] := Image_Load(Path_Image_Button_Sound_Off);
  Ressources.Restart := Image_Load(Path_Image_Button_Restart);
  Ressources.Train_Add := Image_Load(Path_Image_Button_Locomotive);
  Ressources.Wagon_Add := Image_Load(Path_Image_Button_Wagon);
  Ressources.Tunnel_Add := Image_Load(Path_Image_Button_Tunnel);
  Ressources.Play := Image_Load (Path_Image_Play);
  Ressources.Pause := Image_Load(Path_Image_Pause);
  Ressources.Clock := Image_Load(Path_Image_Clock);

  Position.X := 16;
  Position.Y := 16;

  Ressources.Line_Add := Graphics_Surface_Create(32, 32);
  Graphics_Draw_Filled_Circle(Ressources.Line_Add, Position, 16, Color_Get(Color_Black));

  // - Chargement des polices.
  Ressources.Fonts[Font_Small][Font_Normal] := TTF_OpenFont(Path_Font, 12);
  Ressources.Fonts[Font_Medium][Font_Normal] := TTF_OpenFont(Path_Font, 24);
  Ressources.Fonts[Font_Big][Font_Normal] := TTF_OpenFont(Path_Font, 32);

  Ressources.Fonts[Font_Small][Font_Bold] := TTF_OpenFont(Path_Font_Bold, 12);
  Ressources.Fonts[Font_Medium][Font_Bold] := TTF_OpenFont(Path_Font_Bold, 24);
  Ressources.Fonts[Font_Big][Font_Bold] := TTF_OpenFont(Path_Font_Bold, 32);


End;

// - - Graphics

// Procédure qui charge les graphismes.
Procedure Graphics_Load(Var Game : Type_Game);

Var Video_Informations :   PSDL_VideoInfo;
  i : Byte;
Begin
  // - Initialisation de la SDL
  SDL_Init(SDL_INIT_EVERYTHING);
  TTF_INIT();

  // - Création du panneau fenêtre.
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

  Image_Set(Game.Clock_Image, Game.Ressources.Clock);
  Game.Clock_Image.Position.Y := Get_Centered_Position(Game.Panel_Top.Size.Y, Game.Clock_Image.Size.Y);
  Game.Clock_Image.Position.X := Game.Clock_Label.Position.X - 16 - Game.Clock_Image.Size.X;

  // - - Boutton de pause.

  Dual_State_Button_Set(Game.Play_Pause_Button, Game.Ressources.Pause, Game.Ressources.Play, Game.Ressources.Pause, Game.Ressources.Play);
  Game.Play_Pause_Button.Position.Y := Get_Centered_Position(Game.Panel_Top.Size.Y, Game.Play_Pause_Button.Size.Y);
  Game.Play_Pause_Button.Position.X := Game.Panel_Top.Size.X - 16 - Game.Play_Pause_Button.Size.X;

  // - - Boutton de restart.

  Button_Set(Game.Restart_Button, Game.Ressources.Restart, Game.Ressources.Restart);
  Game.Restart_Button.Position.Y := Get_Centered_Position(Game.Panel_Top.Size.Y, Game.Restart_Button.Size.Y);
  Game.Restart_Button.Position.X := Game.Play_Pause_Button.Position.X - 16 - Game.Restart_Button.Size.X;

  // - - Boutton de son.

  Dual_State_Button_Set(Game.Sound_Button, Game.Ressources.Sound[0], Game.Ressources.Sound[1], Game.Ressources.Sound[0], Game.Ressources.Sound[1]);
  Game.Sound_Button.Position.Y := Get_Centered_Position(Game.Panel_Top.Size.Y, Game.Sound_Button.Size.Y);
  Game.Sound_Button.Position.X := 16;

  // Panneau de gauche

  For i := 0 To 2 Do
    Begin
      Button_Set(Game.Locomotive_Button[i], Game.Ressources.Train_Add, Game.Ressources.Train_Add);
      Button_Set(Game.Wagon_Button[i], Game.Ressources.Wagon_Add, Game.Ressources.Wagon_Add);
      Button_Set(Game.Tunnel_Button[i], Game.Ressources.Tunnel_Add, Game.Ressources.Tunnel_Add);
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

  // - Panneau des récompenses.

  // - - Définition du panneau.
  Panel_Create(Game.Panel_Reward, 0, 0, 400, 240);

  Game.Panel_Reward.Position.X := Get_Centered_Position(Game.Window.Size.X, Game.Panel_Reward.Size.X);
  Game.Panel_Reward.Position.Y := Get_Centered_Position(Game.Window.Size.Y, Game.Panel_Reward.Size.Y);

  // - - Définition des polices et couleurs des titres.

  Label_Set(Game.Reward_Title_Label, '', Game.Ressources.Fonts[Font_Big][Font_Bold], Color_Get(Color_Black));
  Label_Set(Game.Reward_Message_Label, '', Game.Ressources.Fonts[Font_Medium][Font_Normal], Color_Get(Color_Black));
  Label_Set(Game.Reward_Labels[0], '', Game.Ressources.Fonts[Font_Medium][Font_Normal], Color_Get(Color_Black));
  Label_Set(Game.Reward_Labels[1], '', Game.Ressources.Fonts[Font_Medium][Font_Normal], Color_Get(Color_Black));


  Panel_Set_Hidden(True, Game.Panel_Reward);

  Animation_Load(Game.Animation);

End;

// Procédure qui rend le panneau du haut.
Procedure Panel_Top_Render(Var Game : Type_Game; Var Destination_Panel : Type_Panel);
Begin
  // Nettoyage du panneau.
  SDL_FillRect(Game.Panel_Top.Surface, Nil, Color_To_Longword(Color_Get(255, 255, 255, 255)));

  Label_Render(Game.Score_Label, Game.Panel_Top);
  Image_Render(Game.Score_Image, Game.Panel_Top);
  Label_Render(Game.Clock_Label, Game.Panel_Top);
  Image_Render(Game.Clock_Image, Game.Panel_Top);
  Dual_State_Button_Render(Game.Play_Pause_Button, Game.Panel_Top);
  Button_Render(Game.Restart_Button, Game.Panel_Top);
  Dual_State_Button_Render(Game.Sound_Button, Game.Panel_Top);

  Panel_Render(Game.Panel_Top, Destination_Panel);
End;

// Procédure qui rend le panneau du bas.
Procedure Panel_Bottom_Render(Var Game : Type_Game; Var Destination_Panel : Type_Panel);
Var i : Byte;
Begin

  SDL_FillRect(Game.Panel_Bottom.Surface, Nil, Color_To_Longword(Color_Get(255, 255, 255, 255)));

  For i := low(Game.Lines) To high(Game.Lines) Do
    Dual_State_Button_Render(Game.Lines[i].Button, Game.Panel_Bottom);

  Panel_Render(Game.Panel_Bottom, Destination_Panel);
End;

// Procédure rafraîchissant tout les éléments graphiques de l'écran.
Procedure Graphics_Refresh(Var Game : Type_Game);
Begin

  // - Nettoyage des panneaux
  // TODO : Remplacer avec Panel.Color.
  SDL_FillRect(Game.Window.Surface, Nil, SDL_MapRGBA(Game.Window.Surface^.format, 255, 255, 255, 255));

  // - Rendu des panneaux.

  Panel_Top_Render(Game, Game.Window);
  Panel_Bottom_Render(Game, Game.Window);
  Panel_Left_Render(Game, Game.Window);
  Panel_Right_Render(Game, Game.Window);
  Panel_Reward_Render(Game, Game.Window);

  // - Rendu du curseur

  Cursor_Render(Game.Mouse, Game.Window, Game);

  // - Regroupement des surfaces dans la fenêtre.



  SDL_Flip(Game.Window.Surface);
  Animation_Refresh(Game);

End;


// - Procédure qui génère le rendu dans la fenêtre des traits entre les stations en utilisant que des angles de 0, 45 et 90 degrés.
Procedure Line_Render(Var Line : Type_Line; Var Panel : Type_Panel; Mouse : Type_Mouse);

Var Intermediate_Position, Mouse_Position :   Type_Coordinates;
  i : Byte;
Begin
  // Si la ligne contient au moins une station.
  If (length(Line.Stations) > 0) Then
    Begin
      // Itère parmi les stations d'une ligne.
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

// Procédure qui décharge les graphismes de l'écran.
Procedure Graphics_Unload(Var Game : Type_Game);
Begin
  Ressources_Unload(Game.Ressources);

  Label_Delete(Game.Reward_Title_Label);
  Label_Delete(Game.Reward_Message_Label);

  Label_Delete(Game.Reward_Labels[0]);
  Label_Delete(Game.Reward_Labels[1]);
  

  Label_Delete(Game.Score_Label);
  Label_Delete(Game.Clock_Label);


  // Suppression des panneaux de l'interface graphique.
  Panel_Delete(Game.Panel_Left);
  Panel_Delete(Game.Panel_Right);
  Panel_Delete(Game.Panel_Top);
  Panel_Delete(Game.Panel_Bottom);
  Panel_Delete(Game.Panel_Reward);
  Panel_Delete(Game.Window);

End;

End.
