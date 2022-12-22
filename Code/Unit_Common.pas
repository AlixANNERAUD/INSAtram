// Unité qui regroupe toutes les fonctions et procédures de base utilisées dans le programme.

Unit Unit_Common;

Interface

// - Définition des dépendances.

Uses sdl, sdl_gfx, sdl_ttf, sysutils, math, Unit_Types, Unit_Constants;

// - Déclaration des fonctions et procédures.

// - - Général

Function String_To_Characters(String_To_Convert : String) : pChar;

// - - Jeu

Procedure Game_Resume(Var Game : Type_Game);
Procedure Game_Pause(Var Game : Type_Game);
Procedure Game_Load(Var Game : Type_Game);
Procedure Game_Unload(Var Game : Type_Game);

// - - Graphismes

// - - - Général

Function Get_Distance(Position_1, Position_2 : Type_Coordinates) : Integer;
Function Get_Angle(Position_1, Position_2 : Type_Coordinates):   Real;
Function Graphics_Surface_Create(Width, Height : Integer) : PSDL_Surface;
Function Lines_Intersects(a1, a2, b1, b2 : Type_Coordinates) : Boolean;
Procedure Graphics_Draw_Filled_Circle(Surface : PSDL_Surface; Center : Type_Coordinates; Radius : Integer; Color : Type_Color);
Procedure Graphics_Draw_Filled_Rectangle(Surface : PSDL_Surface; Position, Size : Type_Coordinates; Color : Type_Color);
Function Get_Center_Position(Position, Size : Type_Coordinates) : Type_Coordinates;
Function Get_Centered_Position(Container_Size, Size : Integer) : Integer;
Function Graphics_Get_Direction(Angle : Real) : Integer;


// - - - Couleurs

Function Color_Get(Color_Name : Type_Color_Name) : Type_Color;
Function Color_Get(Color_Name : Type_Color_Name; Alpha : Byte) : Type_Color;
Function Color_Get(Red,Green,Blue,Alpha : Byte) : Type_Color;
operator = (x, y: Type_Color) b : Boolean;

// - - - Interface

// - - - - Bouton

Procedure Button_Set(Var Button : Type_Button; Surface_Pressed, Surface_Released : PSDL_Surface);

// - - - - Boutton à double état

Procedure Dual_State_Button_Set(Var Dual_State_Button : Type_Dual_State_Button; Surface_Pressed_Enabled, Surface_Pressed_Disabled, Surface_Released_Enable, Surface_Released_Disabled : PSDL_Surface);

// - - - - Image

Procedure Image_Set(Var Image : Type_Image; Surface : PSDL_Surface);

// - - - - Etiquette

Procedure Label_Set(Var Laabel : Type_Label; Text_String : String; Font : pTTF_Font; Color : Type_Color);
Procedure Label_Set_Color(Var Laabel : Type_Label; Color : Type_Color);
Procedure Label_Set_Text(Var Laabel : Type_Label; Text_String : String);
Procedure Label_Set_Font(Var Laabel : Type_Label; Font : pTTF_Font);
Procedure Label_Delete(Var Laabel : Type_Label);

// - - - - Panneau

Procedure Panel_Create(Var Panel : Type_Panel; X,Y, Width, Height : Integer);
Procedure Panel_Delete(Var Panel : Type_Panel);
Function Panel_Get_Relative_Position(Absolute_Position : Type_Coordinates; Panel : Type_Panel) : Type_Coordinates;
Procedure Panel_Set_Hidden(Hidden : Boolean; Var Panel : Type_Panel);

// - - - - Chronomètre

Procedure Pie_Create(Var Pie : Type_Pie; Radius : Integer; Color : Type_Color; Percentage : Real);
Procedure Pie_Set_Percentage(Var Pie : Type_Pie; Percentage : Real);
Procedure Pie_Delete(Var Pie : Type_Pie);


// - - Objets

// - - - Lignes

Function Line_Create(Var Game : Type_Game) : Boolean;
Procedure Line_Compute_Intermediate_Positions(Var Line : Type_Line);
Function Line_Add_Station(Station_Pointer : Type_Station_Pointer; Var Line : Type_Line; Var Game : Type_Game) : Boolean;
Function Line_Add_Station(Last_Station_Pointer, Station_Pointer : Type_Station_Pointer; Var Line : Type_Line; Var Game : Type_Game) : Boolean;
Function Line_Remove_Station(Station_Pointer : Type_Station_Pointer; Var Line : Type_Line; Var Game : Type_Game) : Boolean;
Function Line_Rectangle_Colliding(Line_A, Line_B, Rectangle_Position, Rectangle_Size : Type_Coordinates) : Boolean;
Function Lines_Get_Selected(Game : Type_Game) : Type_Line_Pointer;

// - Trains

Function Train_Create(Start_Station : Type_Station_Pointer; Direction : Boolean; Var Line : Type_Line; Var Game : Type_Game) : Boolean;
Procedure Train_Refresh_Label(Var Train : Type_Train);

// - Véhicules

Function Vehicle_Create(Var Train : Type_Train) : Boolean;
Function Vehicle_Delete(Var Train : Type_Train) : Boolean;


// - - Entités

Function Number_To_Shape(Number : Byte) : Type_Shape;

// - - - Rivière

Procedure River_Create(Var Game : Type_Game);

// - - - Station

Function Station_Create(Var Game: Type_Game) : Boolean;
Function Station_Get_Intermediate_Position(Position_1, Position_2 : Type_Coordinates) :   Type_Coordinates;

// - - - Passagers

Procedure Passenger_Create(Var Station : Type_Station; Var Game : Type_Game);
Function Passenger_Delete(Var Passenger : Type_Passenger_Pointer) : Boolean;

// - - Temps

Function Time_Get_Current(): Type_Time;
Function Time_Get_Elapsed(Start_Time : Type_Time) : Type_Time;
Function Day_To_String(Day : Type_Day) : String;
Function Time_Index_To_Day(Day_Index : Byte) : Type_Day;

// - Définition des fonctions et procédures

Implementation


// Procédure qui supprime les données d'une partie.
Procedure Game_Unload(Var Game : Type_Game);

Var i,j,k,l : Byte;
Begin

  // - Suppresion des stations et de ses passagers.

  // Itère parmi les stations
  For i := low(Game.Stations) To high(Game.Stations) Do
    Begin
      // Itère parmis les passagers d'une station.
      For j := low(Game.Stations[i]^.Passengers) To high(Game.Stations[i]^.Passengers) Do
        Begin
          // Suppression du passager.
          Passenger_Delete(Game.Stations[i]^.Passengers[j]);
        End;

      SetLength(Game.Stations[i]^.Passengers, 0);
      // Suppression de la station.
      Dispose(Game.Stations[i]);
    End;
  SetLength(Game.Stations, 0);

  // - Suppression des lignes et des passagers dans les trains de la ligne.

  // Vérifie qu'il y a bien des lignes.
  If (length(Game.Lines) > 0) Then
    // Itère parmi les lignes
    For i := low(Game.Lines) To high(Game.Lines) Do
      Begin
        // Vérifie qu'il y a bien des trains sur la ligne.
        If (length(Game.Lines[i].Trains) > 0) Then
          Begin
            // Itère parmi les trains de la ligne.
            For j := low(Game.Lines[i].Trains) To high(Game.Lines[i].Trains) Do
              Begin
                // Itère parmi les véhicules du train.
                For k := low(Game.Lines[i].Trains[j].Vehicles) To high(Game.Lines[i].Trains[j].Vehicles) Do
                  Begin
                    // Itère parmi les passagers du véhicule.
                    For l := 0 To Vehicle_Maximum_Passengers_Number - 1 Do
                      Begin
                        If (Game.Lines[i].Trains[j].Vehicles[k].Passengers[l] <> Nil) Then
                          Begin
                            Passenger_Delete(Game.Lines[i].Trains[j].Vehicles[k].Passengers[l]);
                            Game.Lines[i].Trains[j].Vehicles[k].Passengers[l] := Nil;
                          End;
                      End;
                  End;
              End;
          End;
      End;
      SetLength(Game.Lines, 0);

End;

// Fonction qui charge (initialize les attributs) la partie.
Procedure Game_Load(Var Game : Type_Game);
Var i,j : Byte;
Begin

  Game.Start_Time := Time_Get_Current();
  Game.Day := Day_Monday;
  Game.Stations_Timer := Time_Get_Current() + 25000;

  Game.Sound_Button.State := True;
  Game.Play_Pause_Button.State := True;

    Panel_Set_Hidden(True, Game.Panel_Reward);
    Panel_Set_Hidden(True, Game.Panel_Game_Over);
    Panel_Set_Hidden(False, Game.Panel_Right);
    Panel_Set_Hidden(False, Game.Panel_Left);
    Panel_Set_Hidden(False, Game.Panel_Top);
    Panel_Set_Hidden(False, Game.Panel_Bottom);

  Game.Player.Locomotive_Token := 1;
  Game.Player.Tunnel_Token := 1;
  Game.Player.Wagon_Token := 1;
  Game.Player.Score := 0;

  River_Create(Game);

  // Défintion de la carte d'occupation des stations.
  SetLength(Game.Stations_Map, Game.Panel_Right.Size.X Div 64);

  For i := low(Game.Stations_Map) To high(Game.Stations_Map) Do
    Begin
      SetLength(Game.Stations_Map[i], Game.Panel_Right.Size.Y Div 64);
      For j := low(Game.Stations_Map[i]) To high(Game.Stations_Map[i]) Do
        Game.Stations_Map[i][j] := false;
    End;

  // Création des 5 premères stations.
  For i := 1 To 5 Do
    Begin
      Station_Create(Game);
    End;


  // Création de la première ligne.
  Line_Create(Game);
  Line_Create(Game);

  For i := low(Game.Stations) To high(Game.Stations) Do
    Begin
      Line_Add_Station(Game.Stations[i], Game.Lines[0], Game);
    End;


{
  For i := high(Game.Stations) - 2 To high(Game.Stations) Do
    Begin
      Line_Add_Station(@Game.Stations[i], Game.Lines[1]);
    End;

  For i := high(Game.Stations) - 6 To high(Game.Stations) - 3 Do
    Begin
      Line_Add_Station(@Game.Stations[i], Game.Lines[2]);
    End;
}

  For i := low(Game.Stations) To high(Game.Stations) Do
      For j := 0 To Random(6) Do
          Passenger_Create(Game.Stations[i]^, Game);

  Passenger_Create(Game.Stations[0]^, Game);


  Train_Create(Game.Lines[0].Stations[0], true, Game.Lines[0], Game);
  //Train_Create(Game.Lines[0].Stations[3], false, Game.Lines[0], Game);
  //Train_Create(Game.Lines[1].Stations[low(Game.Lines[1].Stations)], true, Game.Lines[1], Game);

End;

// Procédure qui supprime une étiquette.
Procedure Label_Delete(Var Laabel : Type_Label);
Begin
  SDL_FreeSurface(Laabel.Surface);
End;

// Procédure qui supprime un chronomètre.
Procedure Pie_Delete(Var Pie : Type_Pie);
Begin
  SDL_FreeSurface(Pie.Surface);
End;

// Procédure qui supprime un panneau.
Procedure Panel_Delete(Var Panel : Type_Panel);
Begin
  SDL_FreeSurface(Panel.Surface);
End;

// Procédure qui crée (alloue la mémoire) et définit les attributs d'un panneau donné.
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

// Procédure qui définit tout les attributs d'un bouton.
Procedure Button_Set(Var Button : Type_Button; Surface_Pressed, Surface_Released : PSDL_Surface);
Begin
  Button.Surface_Pressed := Surface_Pressed;
  Button.Surface_Released := Surface_Released;
  Button.Size.X := Surface_Released^.w;
  Button.Size.Y := Surface_Released^.h;
End;

// Procédure qui qui définit tout les attributs d'une image.
Procedure Image_Set(Var Image : Type_Image; Surface : PSDL_Surface);
Begin
  Image.Size.X := Surface^.w;
  Image.Size.Y := Surface^.h;
  Image.Surface := Surface;
End;


Procedure Train_Refresh_Label(Var Train : Type_Train);

Var i, j, k : Byte;
Begin
  k := 0;
  For i := low(Train.Vehicles) To high(Train.Vehicles) Do
    For j := 0 To Vehicle_Maximum_Passengers_Number - 1 Do
      If Train.Vehicles[i].Passengers[j] <> Nil Then
        inc(k);

  Label_Set_Text(Train.Passengers_Label, IntToStr(k) + '/' + IntToStr(length(Train.Vehicles) * Vehicle_Maximum_Passengers_Number));
End;

// Fonction qui détermine l'indice d'une station au sein d'une ligne.
Function Line_Get_Station_Index(Station_Pointer : Type_Station_Pointer; Var Line : Type_Line) : Byte;

Var i : Byte;
Begin
  For i := 0 To Length(Line.Stations) - 1 Do
    If Line.Stations[i] = Station_Pointer Then
      Begin
        Line_Get_Station_Index := 1;
        Break;
      End
End;

// Procédure qui crée un chronomètre (timer).
Procedure Pie_Create(Var Pie : Type_Pie; Radius : Integer; Color : Type_Color; Percentage : Real);
Begin
  Pie.Color := Color;
  Pie.Percentage := Percentage;
  Pie.Size.X := Radius * 2;
  Pie.Size.Y := Radius * 2;
  Pie.Surface := Graphics_Surface_Create(Radius * 2, Radius * 2);
  Pie.Pre_Render := true;
End;

// Procédure qui définit le pourcentage d'avancement d'un chronomètre.
Procedure Pie_Set_Percentage(Var Pie : Type_Pie; Percentage : Real);
Begin
  Pie.Percentage := Percentage;
  Pie.Pre_Render := true;
End;

// Procédure qui génère aléatoirement une rivière.
Procedure River_Create(Var Game : Type_Game);

Var Side : Array[0 .. 1] Of Byte;
  i : Integer;
Begin

  // Nombre de points de la rivière.
  SetLength(Game.River, 2 * (Random(3) + 2) - 1);

  // Choix du côté de départ.
  Repeat
    Side[0] := Random(4);

    Case Side[0] Of 
      // Côté gauche.
      0 :
          Begin
            Game.River[low(Game.River)].X := 0 - River_Width;
            Game.River[low(Game.River)].Y := Random(Game.Panel_Right.Size.Y);
          End;
      // Côté haut.
      1 :
          Begin
            Game.River[low(Game.River)].X := Random(Game.Panel_Right.Size.X);
            Game.River[low(Game.River)].Y := 0 - River_Width;
          End;
      // Côté droit.
      2 :
          Begin
            Game.River[low(Game.River)].X := Game.Panel_Right.Size.X + River_Width;
            Game.River[low(Game.River)].Y := Random(Game.Panel_Right.Size.Y);
          End;
      // Côté bas.
      3 :
          Begin
            Game.River[low(Game.River)].X := Random(Game.Panel_Right.Size.X);
            Game.River[low(Game.River)].Y := Game.Panel_Right.Size.Y + River_Width;
          End;
    End;

    // Choix du côté d'arrivée.

    Repeat
      Side[1] := Random(4);
    Until Side[0] <> Side[1];

    Case Side[1] Of 
      // Côté gauche.
      0 :
          Begin
            Game.River[high(Game.River)].X := 0 - River_Width;
            Game.River[high(Game.River)].Y := Random(Game.Panel_Right.Size.Y);
          End;
      // Côté haut.
      1 :
          Begin
            Game.River[high(Game.River)].X := Random(Game.Panel_Right.Size.X);
            Game.River[high(Game.River)].Y := 0 - River_Width;
          End;
      // Côté droit.
      2 :
          Begin
            Game.River[high(Game.River)].X := Game.Panel_Right.Size.X + River_Width;
            Game.River[high(Game.River)].Y := Random(Game.Panel_Right.Size.Y);
          End;
      // Côté bas.
      3 :
          Begin
            Game.River[high(Game.River)].X := Random(Game.Panel_Right.Size.X);
            Game.River[high(Game.River)].Y := Game.Panel_Right.Size.Y + River_Width;
          End;
    End;
  Until Get_Distance(Game.River[low(Game.River)], Game.River[high(Game.River)]) > 600;

  // Détermination des coordonnées des points.
  For i := low(Game.River) + 1 To high(Game.River) - 1 Do
    Begin
      // Index paire (points de contrôle)
      If i Mod 2 = 0 Then
        Begin
          Game.River[i].X := Random(Game.Panel_Right.Size.X - River_Width) + River_Width;
          Game.River[i].Y := Random(Game.Panel_Right.Size.Y - River_Width) + River_Width;
        End
    End;

  // - Calcul des points intermédiaires.
  For i := low(Game.River) + 1 To high(Game.River) - 1 Do
    Begin
      // Index impaire (positions intermédiaires)
      If (i Mod 2) <> 0 Then
        Begin
          // Calcul de la position intermédiaire.
          Game.River[i] := Station_Get_Intermediate_Position(Game.River[i - 1], Game.River[i + 1]);
        End;
    End;

End;

// Procédure qui définit si un panneau est caché.
Procedure Panel_Set_Hidden(Hidden : Boolean; Var Panel : Type_Panel);
Begin
  Panel.Hidden := Hidden;
End;

// Procédure qui met le jeu en pause.
Procedure Game_Pause(Var Game : Type_Game);
Begin
  Game.Play_Pause_Button.State := False;

  Game.Pause_Time := Time_Get_Current();
End;

// Procédure qui relance le jeu (quitter le mode pause).
Procedure Game_Resume(Var Game : Type_Game);

Var i, j : Byte;
Begin

  Game.Play_Pause_Button.State := True;

  Game.Pause_Time := Time_Get_Current() - Game.Pause_Time;

  // - Mise à jour du temps de début du jeu.
  Game.Start_Time := Game.Start_Time + Game.Pause_Time;

  // - Mise à jour des temps de départ des trains.

  // Vérifie que la partie contient des lignes.
  If (length(Game.Lines) > 0) Then
    // Itère parmi les lignes.
    For i := low(Game.Lines) To high(Game.Lines) Do
      // Vérifie que la ligne contient des trains.
      If (length(Game.Lines[i].Trains) > 0) Then
        // Itère parmi les trains de la ligne.
        For j := low(Game.Lines[i].Trains) To high(Game.Lines[i].Trains) Do
          Game.Lines[i].Trains[j].Start_Time := Game.Lines[i].Trains[j].Start_Time + Game.Pause_Time;

  // - Mise à jour des chronomètres de surcharge des stations.

  // Itère parmi les stations.
  For i := low(Game.Stations) To high(Game.Stations) Do
    // Si la station est surchargée.
    If (Game.Stations[i]^.Overfill_Timer <> 0) Then
      Game.Stations[i]^.Overfill_Timer := Game.Stations[i]^.Overfill_Timer + Game.Pause_Time;

  Game.Pause_Time := 0;
End;


// Procédure qui définit tout les attributs d'un texte à la fois.
Procedure Label_Set(Var Laabel : Type_Label; Text_String : String; Font : pTTF_Font; Color : Type_Color);
Begin
  Laabel.Font := Font;
  Laabel.Color := Color;
  Laabel.Text := Text_String;
  Laabel.Pre_Render := true;
End;

// Procédure qui définit le texte d'un label. 
Procedure Label_Set_Text(Var Laabel : Type_Label; Text_String : String);
Begin
  Laabel.Text := Text_String;
  Laabel.Pre_Render := true;
End;

// Procédure qui définit la police du texte dans un label.
Procedure Label_Set_Font(Var Laabel : Type_Label; Font : pTTF_Font);
Begin
  Laabel.Font := Font;
  Laabel.Pre_Render := true;
End;

// Procédure qui définit la couleur dans un label.
Procedure Label_Set_Color(Var Laabel : Type_Label; Color : Type_Color);
Begin
  Laabel.Color := Color;
  Laabel.Pre_Render := true;
End;

// Procédure qui dessine un rectangle plein.
Procedure Graphics_Draw_Filled_Rectangle(Surface : PSDL_Surface; Position, Size : Type_Coordinates; Color : Type_Color);
Begin
  BoxRGBA(Surface, Position.X, Position.Y, Position.X + Size.X, Position.Y + Size.Y, Color.Red, Color.Green, Color.Blue, Color.Alpha);
End;

// Fonction qui retourne une structure couleur à partir de ses composantes.
Function Color_Get(Red,Green,Blue,Alpha : Byte) : Type_Color;
Begin
  Color_Get.Red := Red;
  Color_Get.Green := Green;
  Color_Get.Blue := Blue;
  Color_Get.Alpha := Alpha;
End;

// Procédure qui dessine un cercle plein.
Procedure Graphics_Draw_Filled_Circle(Surface : PSDL_Surface; Center : Type_Coordinates; Radius : Integer; Color : Type_Color);
Begin
  FilledCircleRGBA(Surface, Center.X, Center.Y, Radius, Color.Red, Color.Green, Color.Blue, Color.Alpha);
End;

// Procédure qui définit tout les attributs d'un bouton à double état.
Procedure Dual_State_Button_Set(Var Dual_State_Button : Type_Dual_State_Button; Surface_Pressed_Enabled, Surface_Pressed_Disabled, Surface_Released_Enable, Surface_Released_Disabled : PSDL_Surface);
Begin
  Dual_State_Button.Surface_Pressed[0] := Surface_Pressed_Disabled;
  Dual_State_Button.Surface_Pressed[1] := Surface_Pressed_Enabled;
  Dual_State_Button.Surface_Released[0] := Surface_Released_Disabled;
  Dual_State_Button.Surface_Released[1] := Surface_Released_Enable;
  Dual_State_Button.Size.X := Surface_Released_Disabled^.w;
  Dual_State_Button.Size.Y := Surface_Released_Disabled^.h;
  Dual_State_Button.State := False;
End;

// Fonction qui crée une surface SDL.
Function Graphics_Surface_Create(Width, Height : Integer) : PSDL_Surface;
Begin
  // Création d'une surface SDL avec les masques de couleurs appropriés.
  Graphics_Surface_Create := SDL_CreateRGBSurface(0, Width, Height, Color_Depth, Mask_Red, Mask_Green, Mask_Blue,Mask_Alpha);
End;

// Surcharge de l'opérateur = permet de comparer des couleurs.
operator = (x, y: Type_Color) b : Boolean;
Begin
  b := (x.Red = y.Red) And (x.Green = y.Green) And (x.Blue = y.Blue) And (x.Alpha = y.Alpha);
End;

// Fonction qui détermine la position relative d'un panneau.
Function Panel_Get_Relative_Position(Absolute_Position : Type_Coordinates; Panel : Type_Panel) : Type_Coordinates;
Begin
  Panel_Get_Relative_Position.X := Absolute_Position.X - Panel.Position.X;
  Panel_Get_Relative_Position.Y := Absolute_Position.Y - Panel.Position.Y;
End;

// Fonction qui renvoie la ligne actuellement sélectionnée ou Nil s'il y en a pas.
Function Lines_Get_Selected(Game : Type_Game) : Type_Line_Pointer;

Var i : Byte;
Begin
  // Vérifie si il y a des lignes.
  Lines_Get_Selected := Nil;

  If (length(Game.Lines) > 0) Then
    Begin
      For i := low(Game.Lines) To high(Game.Lines) Do
        Begin
          If (Game.Lines[i].Button.State = true) Then
            Begin
              Lines_Get_Selected := @Game.Lines[i];
              Break;
            End;
        End;
    End;
End;

// Fonction qui convertit le nom d'une couleur en la couleur associée selon la palette du material design.
Function Color_Get(Color_Name : Type_Color_Name) : Type_Color;
Begin
  Case Color_Name Of 
    Color_Black : Color_Get := Color_Get(0,0,0,255);
    Color_Red : Color_Get := Color_Get(244,64,54,255);
    Color_Purple : Color_Get := Color_Get(156,39,176,255);
    Color_Deep_Purple : Color_Get := Color_Get(103,58,183,255);
    Color_Indigo : Color_Get := Color_Get(63,81,181,255);
    Color_Blue : Color_Get := Color_Get(33,150,243,255);
    Color_Light_Blue : Color_Get := Color_Get(3,169,244,255);
    Color_Cyan : Color_Get := Color_Get(0,188,212,255);
    Color_Teal : Color_Get := Color_Get(0,150,136,255);
    Color_Green : Color_Get := Color_Get(76,175,80,255);
    Color_Light_Green : Color_Get := Color_Get(139,195,74,255);
    Color_Lime : Color_Get := Color_Get(205,220,57,255);
    Color_Yellow : Color_Get := Color_Get(255,235,59,255);
    Color_Amber : Color_Get := Color_Get(255,193,7,255);
    Color_Orange : Color_Get := Color_Get(255,152,0,255);
    Color_Deep_Orange : Color_Get := Color_Get(255,87,34,255);
    Color_Brown : Color_Get := Color_Get(121,85,72,255);
    Color_Grey : Color_Get := Color_Get(158,158,158,255);
    Color_Blue_Grey : Color_Get := Color_Get(96,125,139,255);
    Color_White : Color_Get := Color_Get(255,255,255,255);
  End;
End;

// Fonction identique à la précédente mais qui permet de définir l'opacité de la couleur.
Function Color_Get(Color_Name : Type_Color_Name; Alpha : Byte) : Type_Color;
Begin
  Color_Get := Color_Get(Color_Name);
  Color_Get.Alpha := Alpha;
End;

// Fonction qui détecte si un rectangle et une ligne sont en collision.
Function Line_Rectangle_Colliding(Line_A, Line_B, Rectangle_Position, Rectangle_Size : Type_Coordinates) : Boolean;

Var Temporary_Line : Array[0 .. 1] Of Type_Coordinates;
Begin
  // Les quatre côtés du rectangle sont décomposés en 4 lignes.
  // La détection se fait ensuite ligne par ligne.
  // Les détections sont imbriquées afin de ne pas faire de calculs inutiles.

  // Côté gauche du rectangle.
  Temporary_Line[0].X := Rectangle_Position.X;
  Temporary_Line[0].Y := Rectangle_Position.Y;
  Temporary_Line[1].X := Rectangle_Position.X;
  Temporary_Line[1].Y := Rectangle_Position.Y+Rectangle_Size.Y;

  If (Lines_Intersects(Line_A, Line_B, Temporary_Line[0], Temporary_Line[1]) = False) Then
    Begin
      // Côté droit du rectangle.
      Temporary_Line[0].X := Rectangle_Position.X+Rectangle_Size.X;
      Temporary_Line[0].Y := Rectangle_Position.Y;
      Temporary_Line[1].X := Rectangle_Position.X+Rectangle_Size.X;
      Temporary_Line[1].Y := Rectangle_Position.Y+Rectangle_Size.Y;

      If (Lines_Intersects(Line_A, Line_B, Temporary_Line[0], Temporary_Line[1]) = False) Then
        Begin

          // Côté haut du rectangle.
          Temporary_Line[0].X := Rectangle_Position.X;
          Temporary_Line[0].Y := Rectangle_Position.Y;
          Temporary_Line[1].X := Rectangle_Position.X + Rectangle_Size.X;
          Temporary_Line[1].Y := Rectangle_Position.Y;

          If (Lines_Intersects(Line_A, Line_B, Temporary_Line[0], Temporary_Line[1]) = False) Then
            Begin
              // Coté bas du rectangle.
              Temporary_Line[0].X := Rectangle_Position.X;
              Temporary_Line[0].Y := Rectangle_Position.Y+Rectangle_Size.Y;
              Temporary_Line[1].X := Rectangle_Position.X+Rectangle_Size.X;
              Temporary_Line[1].Y := Rectangle_Position.Y+Rectangle_Size.Y;

              If (Lines_Intersects(Line_A, Line_B, Temporary_Line[0], Temporary_Line[1]) = False) Then
                Line_Rectangle_Colliding := False
              Else
                Line_Rectangle_Colliding := True;
            End
          Else
            Line_Rectangle_Colliding := True;
        End
      Else
        Line_Rectangle_Colliding := True;
    End
  Else
    Line_Rectangle_Colliding := True;
End;

// Fonction qui détermine si il y a des intersections entre les lignes.
Function Lines_Intersects(a1, a2, b1, b2 : Type_Coordinates) : Boolean;

Var B, D, C : Type_Coordinates;
  BD, T : Real;
Begin
  B.X := a2.X - a1.X;
  B.Y := a2.Y - a1.Y;

  D.X := b2.X - b1.X;
  D.Y := b2.Y - b1.Y;

  BD := (B.X * D.Y) - (B.Y * D.X);

  // if b dot d == 0, it means the lines are parallel so have infinite intersection points
  If (BD = 0) Then
    Lines_Intersects := false
  Else
    Begin
      C.X := b1.X - a1.X;
      C.Y := b1.Y - a1.Y;

      T := ((C.X * D.Y) - (C.Y * D.X)) / BD;

      If ((T < 0) Or (T > 1)) Then
        Lines_Intersects := false
      Else
        Begin
          T := ((C.X * B.Y) - (C.Y * b.X)) / BD;

          If ((T < 0) Or (T > 1)) Then
            Lines_Intersects := false
          Else
            Lines_Intersects := true;
        End;
    End;
End;

// Fonction qui convertit le jour de Type_Day en un String.
Function Day_To_String(Day : Type_Day) : String;
Begin
  Case Day Of 
    Day_Monday : Day_To_String := 'Monday';
    Day_Tuesday : Day_To_String := 'Tuesday';
    Day_Wednesday : Day_To_String := 'Wednesday';
    Day_Thursday : Day_To_String := 'Thursday';
    Day_Friday : Day_To_String := 'Friday';
    Day_Saturday : Day_To_String := 'Saturday';
    Day_Sunday : Day_To_String := 'Sunday';
  End;
End;

// Fonction qui renvoie un jour selon l'indice du temps.
Function Time_Index_To_Day(Day_Index : Byte) : Type_Day;
Begin
  Case Day_Index Of 
    0 : Time_Index_To_Day := Day_Monday;
    1 : Time_Index_To_Day := Day_Tuesday;
    2 : Time_Index_To_Day := Day_Wednesday;
    3 : Time_Index_To_Day := Day_Thursday;
    4 : Time_Index_To_Day := Day_Friday;
    5 : Time_Index_To_Day := Day_Saturday;
    6 : Time_Index_To_Day := Day_Sunday;
  End;
End;

// Fonction qui calcule la distance entre deux points.
Function Get_Distance(Position_1, Position_2 : Type_Coordinates):   Integer;
Begin
  Get_Distance := round(sqrt(sqr(Position_2.X-Position_1.X)+sqr(Position_2.Y-Position_1.Y)));
End;

// - Définition des fonctions et procédures.

// Fonction qui renvoie l'angle entre deux points.
Function Get_Angle(Position_1, Position_2 : Type_Coordinates):   Real;
Begin
  Get_Angle := ArcTan2(-Position_2.Y + Position_1.Y,
               Position_2.X - Position_1.X);
End;

// Procédure qui calcule les positions intermédiaires séparant les stations d'une ligne.
Procedure Line_Compute_Intermediate_Positions(Var Line : Type_Line);
Var i : Byte;
Begin
  // Vérifie qu'il y a bien au moins une stations dans la ligne.
  If (length(Line.Stations) > 1) Then
    Begin
      // Définition de la taille du tableau.
      SetLength(Line.Intermediate_Positions, length(Line.Stations) - 1);
      // Itère parmi les stations.
      For i := low(Line.Stations) To (high(Line.Stations) - 1) Do
        Begin
          // Calcule la position intermédiaire.
          Line.Intermediate_Positions[i + low(Line.Intermediate_Positions)] := Station_Get_Intermediate_Position(Line.Stations[i]^.Position_Centered, Line.Stations[i + 1]^.Position_Centered);
        End;
    End;

End;

// Fonction déterminant l'orientation d'un angle parmi : 0, 45, 90, 135, 180, -45, -90, -135.
Function Graphics_Get_Direction(Angle : Real) : Integer;

Var Sign :   Integer;
Begin

  // Si l'angle est négatif (dans la partie inférieure du cercle trigonométrique),
  //Son signe est inversé, mais pris en compte pour plus tard afin de simplfier la disjonction des cas.
  If (Angle < 0) Then
    Begin
      Angle := -Angle;
      Sign := -1;
    End
    // Si l'angle est positif mais dans la partie inférieure du cercle trigonométrique,
    // On lui ajoute 2Pi afin d'obtenir son analogue négatif puis comme pour le cas précédent,
    // On annule son signe et on prend en compte son signe pour plus tard.
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
  // L'orientation est de 180°
End;

// Fonction qui calcule la position intermédiaire entre deux stations.
Function Station_Get_Intermediate_Position(Position_1, Position_2 : Type_Coordinates) :   Type_Coordinates;

Var Direction :   Integer;
  Angle : Real;
  Temporary_Position : Type_Coordinates;
Begin

  // Convention d'affichage


  //Direction := Graphics_Get_Direction(Get_Angle(Position_1, Position_2));
  Angle := Get_Angle(Position_1, Position_2);

  If (Angle < 0) Then
    Begin
      Temporary_Position := Position_1;
      Position_1 := Position_2;
      Position_2 := Temporary_Position;
      Angle := Get_Angle(Position_1, Position_2);
      //Angle := Get_Angle(Position_1, Position_2);
    End;

  Station_Get_Intermediate_Position := Position_1;


{
  Case Direction Of 
    0 :
      Station_Get_Intermediate_Position.X := Position_2.X - abs(Position_2.Y - Position_1.Y);

    45 :
      Station_Get_Intermediate_Position.Y := Position_2.Y - abs(Position_2.X - Position_1.X);
    
    90, 135 :
       Station_Get_Intermediate_Position.Y := Position_2.Y + abs(Position_2.X - Position_1.X);
      

    180 : 
        Station_Get_Intermediate_Position.X := Position_2.X + abs(Position_2.Y - Position_1.Y);
  End;
}

  //  45 - 90 - 135
  If ((Angle >= (Pi/4)) And (Angle <= ((3*Pi)/4))) Then
    Begin
      Station_Get_Intermediate_Position.X := Position_1.X;
      Station_Get_Intermediate_Position.Y := Position_2.Y + abs(Position_2.X - Position_1.X)
      ;
    End



    // - Angle entre -45° and -135° (inclus)
  Else If ((Angle <= (-Pi/4)) And (Angle >= ((-3*Pi)/4))) Then
         //-45 - -90 - -135
         Begin
           Station_Get_Intermediate_Position.X := Position_1.X;
           Station_Get_Intermediate_Position.Y := Position_2.Y - abs(Position_2.X -
                                                  Position_1.X);
         End
         // - Angle entre -45° and 45° (exclus)
  Else If (((Angle > (-Pi/4)) And (Angle < 0)) Or ((Angle < (Pi/4)) And (Angle
          >= 0))) Then
         Begin
           Station_Get_Intermediate_Position.Y := Position_1.Y;
           Station_Get_Intermediate_Position.X := Position_2.X - abs(Position_2.Y -
                                                  Position_1.Y);
         End
         // - Angle entre 135° and -135° (exclus)
  Else
    Begin
      Station_Get_Intermediate_Position.Y := Position_1.Y;
      Station_Get_Intermediate_Position.X := Position_2.X + abs(Position_2.Y - Position_1.Y);
    End;

End;

// Fonction qui convertit une chaîne de caractères (dyanmique) en un tableau de caractères (statique).
Function String_To_Characters(String_To_Convert : String) : pChar;
Var Characters : pChar;
Begin
  Characters := StrAlloc(length(String_To_Convert) + 1);
  StrPCopy(Characters, String_To_Convert);
  String_To_Characters := Characters;
End;

// - Définition des fonctions et procédures

// - Création

// Fonction qui détermine les coordonnées de la position centrée.
Function Get_Center_Position(Position, Size : Type_Coordinates) : Type_Coordinates;
Begin
  Position.X := Position.X + (Size.X Div 2);
  Position.Y := Position.Y + (Size.Y Div 2);
  Get_Center_Position := Position;
End;

// Fonction qui détermine la position centrée d'un objet dans un autre.
Function Get_Centered_Position(Container_Size, Size : Integer) : Integer;
Begin
  Get_Centered_Position := (Container_Size - Size) Div 2;
End;

// Fonction qui alloue de la mémoire pour une station et la référence dans le tableau dynamique, détermine sa forme, position aléatoirement et definit ses attributs.
Function Station_Create(Var Game : Type_Game) : Boolean;

Var Shape : Byte;
  Position : Type_Coordinates;
  i, j : Byte;
Begin
  If (length(Game.Stations) < Game_Maximum_Number_Stations) Then
    Begin
      // Allocation de la station dans le tableau.
      SetLength(Game.Stations, length(Game.Stations) + 1);
      // Définition de l'index de la station créée.
      i := high(Game.Stations);

      // Allocation de la mémoire au pointeur.
      New(Game.Stations[i]);

      // Initialisation des attributs par défaut.
      // Détermination de la forme de la station.
      If (length(Game.Stations) <= 5) Then
        // Les 5 premières stations doivent être de formes différentes pour permettre à tout type de passager d'arriver à destination.
        Shape := length(Game.Stations) - 1
      Else
        // Les stations suivantes peuvent avoir une forme aléatoire.
        Shape := Random(5);

      Game.Stations[i]^.Shape := Number_To_Shape(Shape);
      Game.Stations[i]^.Sprite := Game.Ressources.Stations[Shape];

      Game.Stations[i]^.Size.X := Game.Stations[i]^.Sprite^.w;
      Game.Stations[i]^.Size.Y := Game.Stations[i]^.Sprite^.h;

      // Détermination de la position de la station.
      Repeat
        // Détermination de la position aléatoire.
        Position.X := Random(length(Game.Stations_Map));
        Position.Y := Random(length(Game.Stations_Map[high(Game.Stations_Map)]));

        Game.Stations[i]^.Position.X := 64 * Position.X + (Game.Panel_Right.Size.X Mod 64) Div 2;
        Game.Stations[i]^.Position.Y := 64 * Position.Y + (Game.Panel_Right.Size.Y Mod 64) Div 2;

        If (Game.Stations_Map[Position.X][Position.Y] = false) Then
          Begin
            // Itère parmi les points de la rivière.
            For j := low(Game.River) + 1 To high(Game.River) Do
              Begin
                // Si il y a collision entre la rivière et la station,
                If (Line_Rectangle_Colliding(Game.River[j - 1], Game.River[j], Game.Stations[i]^.Position, Game.Stations[i]^.Size)) Then
                  Begin
                    // On marque l'emplacement comme occupé pour les prochaines stations créées.
                    Game.Stations_Map[Position.X][Position.Y] := true;
                    // On sort de la boucle.
                    break;
                  End;
              End;
          End;

      Until Game.Stations_Map[Position.X][Position.Y] = false;

      Game.Stations_Map[Position.X][Position.Y] := true;

      Game.Refresh_Graph_Table := true;

      SetLength(Game.Dijkstra_Table, length(Game.Stations));
      For j := low(Game.Dijkstra_Table) To high(Game.Dijkstra_Table) Do
        SetLength(Game.Dijkstra_Table[j], length(Game.Stations));

      // Calcul des coordoonées centrées de la station.
      Game.Stations[i]^.Position_Centered := Get_Center_Position(Game.Stations[i]^.Position, Game.Stations[i]^.Size);

      // Création du timer de la station.
      Pie_Create(Game.Stations[i]^.Timer, 10, Color_Get(Color_Blue_Grey), 80);

      Game.Stations[i]^.Timer.Position.X := Game.Stations[i]^.Position_Centered.X + Game.Stations[i]^.Size.Y Div 2;
      Game.Stations[i]^.Timer.Position.Y := Game.Stations[i]^.Position.Y - Game.Stations[i]^.Size.Y Div 2 - 10;
      Game.Stations[i]^.Overfill_Timer := 0;

      Station_Create := True;
    End
  Else
    Station_Create := False;
End;

// Fonction qui détermine le nombre nécessaires de tunnels quand il y a une intersection entre une ligne et une rivière.
Function Lines_Count_Necessary_Tunnel(Var Game : Type_Game) : Byte;

Var i, j, k : Byte;
  Intermediate_Position : Type_Coordinates;
  Count : Byte;
Begin

  Count := 0;

  For i := low(Game.Graph_Table) To high(Game.Graph_Table) - 1 Do
    For j := low(Game.Graph_Table[i]) + i + 1 To high(Game.Graph_Table[i]) Do
      If (length(Game.Graph_Table[i][j]) > 0) Then
        Begin
          // Vérifie s'il y a intersection.
          Intermediate_Position := Station_Get_Intermediate_Position(Game.Stations[i]^.Position_Centered, Game.Stations[j]^.Position_Centered);

          For k := low(Game.River) To high(Game.River) - 1 Do
            Begin
              If (Lines_Intersects(Game.River[k], Game.River[k + 1], Game.Stations[i]^.Position_Centered, Intermediate_Position)) Then
                Inc(Count);

              If (Lines_Intersects(Game.River[k], Game.River[k + 1], Intermediate_Position, Game.Stations[j]^.Position_Centered)) Then
                Inc(Count);
            End;

        End;

  writeln('Count : ', Count);

  Lines_Count_Necessary_Tunnel := Count;


End;

// Fonction qui crée une ligne.
Function Line_Create(Var Game : Type_Game) : Boolean;

Var i, j : Byte;
  Color_Used : Array[0 .. 7] Of Boolean;
  Center : Type_Coordinates;
Begin
  // Vérifie si la limite de ligne n'est pas atteinte.
  If (length(Game.Lines) < Game_Maximum_Lines_Number) Then
    Begin
      // Création de la ligne.
      SetLength(Game.Lines, length(Game.Lines) + 1);
      // Récupération de l'index de la ligne créée (dernier élément du tableau).
      i := high(Game.Lines);

      // - Détermination de la couleur.

      // TODO : Manière peu optimale de déterminer la couleur.

      // Initialisation du tableau des couleurs utilisées.
      For i := 0 To 7 Do
        Color_Used[i] := False;

      // Itère parmi les lignes.
      For j := low(Game.Lines) To high(Game.Lines) Do
        Begin
          // Si la couleur de la ligne est utilisée, on l'inscrit dans le tableau.
          If (Game.Lines[j].Color = Color_Get(Color_Red)) Then
            Color_Used[0] := True
          Else If (Game.Lines[j].Color = Color_Get(Color_Purple)) Then
                 Color_Used[1] := True
          Else If (Game.Lines[j].Color = Color_Get(Color_Indigo)) Then
                 Color_Used[2] := True
          Else If (Game.Lines[j].Color = Color_Get(Color_Teal)) Then
                 Color_Used[3] := True
          Else If (Game.Lines[j].Color = Color_Get(Color_Green)) Then
                 Color_Used[4] := True
          Else If (Game.Lines[j].Color = Color_Get(Color_Yellow)) Then
                 Color_Used[5] := True
          Else If (Game.Lines[j].Color = Color_Get(Color_Orange)) Then
                 Color_Used[6] := True
          Else If (Game.Lines[j].Color = Color_Get(Color_Brown)) Then
                 Color_Used[7] := True;
        End;

      // Itère parmi le tableau des couleurs utilisées.
      For i := 0 To 7 Do
        // Si la couleur n'est pas utilisée.
        If (Color_Used[i] = False) Then
          Begin
            // Convertit l'index en couleur et on l'assigne à la ligne.
            Case i Of 
              0 : Game.Lines[i].Color := Color_Get(Color_Red);
              1 : Game.Lines[i].Color := Color_Get(Color_Purple);
              2 : Game.Lines[i].Color := Color_Get(Color_Indigo);
              3 : Game.Lines[i].Color := Color_Get(Color_Teal);
              4 : Game.Lines[i].Color := Color_Get(Color_Green);
              5 : Game.Lines[i].Color := Color_Get(Color_Yellow);
              6 : Game.Lines[i].Color := Color_Get(Color_Orange);
              7 : Game.Lines[i].Color := Color_Get(Color_Brown);
            End;
            // On casse la boucle.
            Break;
          End;

      // Création du bouton
      Dual_State_Button_Set(Game.Lines[i].Button, Graphics_Surface_Create(32, 32), Graphics_Surface_Create(32, 32), Graphics_Surface_Create(32, 32), Graphics_Surface_Create(32, 32));

      Center.X := 16;
      Center.Y := 16;


      Graphics_Draw_Filled_Circle(Game.Lines[i].Button.Surface_Released[0], Center, 12, Game.Lines[i].Color);

      Graphics_Draw_Filled_Circle(Game.Lines[i].Button.Surface_Released[1], Center, 16, Game.Lines[i].Color);

      // - Recalcule les positions des boutons.

      // Centrage vertical du premier bouton.

      Game.Lines[i].Button.Position.Y := Get_Centered_Position(Game.Panel_Bottom.Size.Y, Game.Lines[i].Button.Size.Y);

      // Définition de la position du premier bouton. 
      Game.Lines[low(Game.Lines)].Button.Position.X := Get_Centered_Position(Game.Panel_Bottom.Size.X, (Game.Lines[i].Button.Size.X * length(Game.Lines)) + (16 * (length(Game.Lines) - 1)));

      If (length(Game.Lines) > 1) Then
        Begin
          // Itère parmi les lignes.
          For j := low(Game.Lines) + 1 To high(Game.Lines) Do
            Begin
              Game.Lines[j].Button.Position.Y := Game.Lines[j].Button.Position.Y;
              Game.Lines[j].Button.Position.X := Game.Lines[j - 1].Button.Position.X + Game.Lines[j - 1].Button.Size.X + 16;
            End;
        End;


      Game.Refresh_Graph_Table := True;

      Line_Create := True;
    End
  Else
    Line_Create := False;
End;

// Fonction qui ajoute une station à une ligne.
Function Line_Add_Station(Station_Pointer : Type_Station_Pointer; Var Line : Type_Line; Var Game : Type_Game) : Boolean;
Begin
  If (length(Line.Stations) < Lines_Maximum_Number_Stations) Then
    Begin
      // Agrandissement du tableau dynamique des stations de la ligne.
      SetLength(Line.Stations, length(Line.Stations) + 1);
      // Ajout du pointeur de la station.
      Line.Stations[high(Line.Stations)] := Station_Pointer;
      // Recalcule les positions intermédiaires de la ligne.
      Line_Compute_Intermediate_Positions(Line);

      Game.Refresh_Graph_Table := True;
      Game.Itinerary_Refresh := True;

      Line_Add_Station := True;
    End
  Else
    Line_Add_Station := False;
End;

// Fonction qui insère une station dans une ligne.
Function Line_Add_Station(Last_Station_Pointer, Station_Pointer : Type_Station_Pointer; Var Line : Type_Line; Var Game : Type_Game) : Boolean;

Var i : Byte;
  Temporary_Array : Array Of Type_Station_Pointer;
  Duplicate : Boolean;
Begin
  Line_Add_Station := false;
  If (length(Line.Stations) < Lines_Maximum_Number_Stations) Then
    Begin
      // Vérifie que la ligne contient des stations.
      If (length(Line.Stations) > 0) Then
        Begin
          Duplicate := false;
          // - Vérifie si la station n'a pas déjà été ajoutée.
          For i := low(Line.Stations) To high(Line.Stations) Do
            If (Line.Stations[i] = Station_Pointer) Then
              Duplicate := true;

          // - Insertion de la station dans la ligne.

          // Si la station n'a pas déjà été ajoutée.
          If (Duplicate = false) Then
            Begin
              // Itère parmi les stations de la ligne.
              For i := low(Line.Stations) To high(Line.Stations) Do
                Begin
                  If (Line.Stations[i] = Last_Station_Pointer) Then
                    Begin
                      // Agrandissement du tableau dynamique temporaire.
                      SetLength(Temporary_Array, 1);
                      // Ajout du pointeur de la station au tableau temporaire.
                      Temporary_Array[high(Temporary_Array)] := Station_Pointer;
                      // Insertion du pointeur de la station dans le tableau des stations de la ligne.
                      Insert(Temporary_Array, Line.Stations, i + 1);
                      // Recalcule les positions intermédiaires de la ligne.
                      Line_Compute_Intermediate_Positions(Line);

                      Game.Refresh_Graph_Table := True;
                      Game.Itinerary_Refresh := True;

                      Line_Add_Station := true;
                      Break;
                    End;
                End;
            End;
        End;
    End;
End;

// Fonction qui enlève une station d'une ligne.
Function Line_Remove_Station(Station_Pointer : Type_Station_Pointer; Var Line : Type_Line; Var Game : Type_Game) : Boolean;

Var i, j : Byte;
  Busy : Boolean;
Begin
  Line_Remove_Station := False;

  // Vérifie que la ligne contient des stations.
  If (length(Line.Stations) > 0) Then
    Begin
      For i := low(Line.Stations) To high(Line.Stations) Do
        If (Line.Stations[i] = Station_Pointer) Then
          Begin
            Busy := false;
            // Vérifie que la ligne contient des trains.
            If (length(Line.Trains) > 0) Then
              Begin
                // Itère parmi les trains de la ligne.
                For j := low(Line.Trains) To high(Line.Trains) Do
                  Begin
                    // Vérifie que tout les trains concernés ne sont pas en transit vers ou au départ de la station concernée.
                    If (Line.Trains[j].Last_Station = Station_Pointer) Or (Line.Trains[j].Next_Station = Station_Pointer) Then
                      Begin
                        Busy := true;
                        Break;
                      End;
                  End;
              End
            Else
              Busy := false;

            // Si un train n'est pas à destination ou au départ de la station, on peut enlever la station de la ligne.
            If Not(Busy) Then
              Begin
                // Enlève la station.
                Delete(Line.Stations, i, 1);
                // Si il n'y a plus qu'une station dans la ligne, alors, on supprime la seule station restante.
                If (length(Line.Stations) = 1) Then
                  SetLength(Line.Stations, 0);
                Line_Compute_Intermediate_Positions(Line);

                Game.Refresh_Graph_Table := True;
                Game.Itinerary_Refresh := True;

                Line_Remove_Station := True;
              End;

            Break;
          End;
    End;
End;

// Procédure qui crée un passager dans une station.
Procedure Passenger_Create(Var Station : Type_Station; Var Game : Type_Game);

Var Shape : Byte;
Begin
  SetLength(Station.Passengers, length(Station.Passengers) + 1);
  // Allocation de la mémoire.
  New(Station.Passengers[high(Station.Passengers)]);

  Repeat
    Shape := Random(Game_Shapes_Number);
  Until (Station.Shape <> Number_To_Shape(Shape));

  // Définition de la forme du passager.
  Station.Passengers[high(Station.Passengers)]^.Shape := Number_To_Shape(Shape);
  // Définition du sprite du passager.
  Station.Passengers[high(Station.Passengers)]^.Sprite := Game.Ressources.Passengers[Shape];
  // Définition de la taille du passager.
  Station.Passengers[high(Station.Passengers)]^.Size.X := Station.Passengers[high(Station.Passengers)]^.Sprite^.w;
  Station.Passengers[high(Station.Passengers)]^.Size.Y := Station.Passengers[high(Station.Passengers)]^.Sprite^.h;

  Game.Itinerary_Refresh := True;
End;

// Fonction qui crée un train dans une ligne.
Function Train_Create(Start_Station : Type_Station_Pointer; Direction : Boolean; Var Line : Type_Line; Var Game : Type_Game) : Boolean;

Var i : Byte;
  Maximum_Distance : Integer;
Begin
  If (length(Line.Trains) < Lines_Maximum_Number_Trains)Then
    Begin
      // Création d'un nouveau train dans le tableau.
      SetLength(Line.Trains, length(Line.Trains) + 1);

      Line.Trains[high(Line.Trains)].Distance := 0;
      Line.Trains[high(Line.Trains)].Direction := Direction;
      Line.Trains[high(Line.Trains)].Last_Station := Start_Station;

      // Détermination de la prochaine station.
      If (length(Line.Stations) > 0) Then
        Begin
          // Itère parmi les stations de la ligne.
          For i := low(Line.Stations) To high(Line.Stations) Do
            Begin
              If (Line.Stations[i] = Start_Station) Then
                Begin
                  // Si la station est la dernière ou la première station d'une ligne.
                  If (i = low(Line.Stations)) Then
                    Line.Trains[high(Line.Trains)].Direction := true

                  Else If (i = high(Line.Stations)) Then
                         // On inverse la direction.
                         Line.Trains[high(Line.Trains)].Direction := false;

                  If (Line.Trains[high(Line.Trains)].Direction = true) Then
                    Begin

                      Line.Trains[high(Line.Trains)].Next_Station := Line.Stations[i + 1];
                      // Calcul du point intermédiaire.
                      Line.Trains[high(Line.Trains)].Intermediate_Position := Station_Get_Intermediate_Position(Line.Trains[high(Line.Trains)].Last_Station^.Position_Centered, Line.Trains[high(Line.Trains)].Next_Station^.Position_Centered);
                    End
                  Else
                    Begin
                      Line.Trains[high(Line.Trains)].Next_Station := Line.Stations[i - 1];

                      // Calcul du point intermédiaire.
                      Line.Trains[high(Line.Trains)].Intermediate_Position := Station_Get_Intermediate_Position(Line.Trains[high(Line.Trains)].Next_Station^.Position_Centered, Line.Trains[high(Line.Trains)].Last_Station^.Position_Centered);
                    End;
                  Break;
                End;
            End;
        End;

      // Calcul de la distance du point intermédiaire.
      Line.Trains[high(Line.Trains)].Intermediate_Position_Distance := Get_Distance(Line.Trains[high(Line.Trains)].Last_Station^.Position_Centered, Line.Trains[high(Line.Trains)].Intermediate_Position);

      If (Line.Color = Color_Get(Color_Red)) Then
        Line.Trains[high(Line.Trains)].Color_Index := 0
      Else If (Line.Color = Color_Get(Color_Purple)) Then
             Line.Trains[high(Line.Trains)].Color_Index := 1
      Else If (Line.Color = Color_Get(Color_Indigo)) Then
             Line.Trains[high(Line.Trains)].Color_Index := 2
      Else If (Line.Color = Color_Get(Color_Teal)) Then
             Line.Trains[high(Line.Trains)].Color_Index := 3
      Else If (Line.Color = Color_Get(Color_Green)) Then
             Line.Trains[high(Line.Trains)].Color_Index := 4
      Else If (Line.Color = Color_Get(Color_Yellow)) Then
             Line.Trains[high(Line.Trains)].Color_Index := 5
      Else If (Line.Color = Color_Get(Color_Orange)) Then
             Line.Trains[high(Line.Trains)].Color_Index := 6
      Else If (Line.Color = Color_Get(Color_Brown)) Then
             Line.Trains[high(Line.Trains)].Color_Index := 7;

      Line.Trains[high(Line.Trains)].Driving := True;

      Label_Set(Line.Trains[high(Line.Trains)].Passengers_Label, '', Game.Ressources.Fonts[Font_Small][Font_Bold], Color_Get(Color_White));

      Line.Trains[high(Line.Trains)].Start_Time := Time_Get_Current();

      // Calcul de la distance maximale du train.

      Maximum_Distance := Get_Distance(Line.Trains[high(Line.Trains)].Last_Station^.Position_Centered, Line.Trains[high(Line.Trains)].Intermediate_Position) +  Get_Distance(Line.Trains[high(Line.Trains)].Intermediate_Position, Line.Trains[high(Line.Trains)].Next_Station^.Position_Centered);

      Line.Trains[high(Line.Trains)].Deceleration_Time := ((Maximum_Distance - (Train_Acceleration_Time * Train_Maximum_Speed)) / Train_Maximum_Speed) + Train_Acceleration_Time;

      Vehicle_Create(Line.Trains[high(Line.Trains)]);

      Train_Create := True;
    End
  Else
    Train_Create := False;
End;

// Fonction qui supprime un train d'une ligne.
Function Vehicle_Delete(Var Train : Type_Train) : Boolean;

Var i : Byte;
Begin
  // Vérifie que le train possède bien des véhicules.
  If (length(Train.Vehicles) > 1) Then
    Begin
      // - Déchargement des passagers dans la station précédente.

      // Itère parmi les passagers du dernier véhicule.
      For i := 0 To Vehicle_Maximum_Passengers_Number - 1 Do
        If (Train.Vehicles[high(Train.Vehicles)].Passengers[i] <> Nil) Then
          Begin
            // Création d'une nouvelle entrée dans le tableau des passagers de la station précédente.
            SetLength(Train.Last_Station^.Passengers, length(Train.Last_Station^.Passengers) + 1);
            // Ajout du passager dans la station précédente.
            Train.Last_Station^.Passengers[high(Train.Last_Station^.Passengers)] := Train.Vehicles[high(Train.Vehicles)].Passengers[i];
          End;

      // Suppression du dernier véhicule.
      SetLength(Train.Vehicles, length(Train.Vehicles) - 1);

      // Mise à jour de l'étiquette du train.

      Vehicle_Delete := True;
    End
  Else
    Vehicle_Delete := False;

End;

// Fonction qui crée un véhicule dans un train (wagon ou locomotive).
Function Vehicle_Create(Var Train : Type_Train) : Boolean;

Var i : Byte;

Begin
  // Vérifie que le train n'a pas atteint le nombre maximum de véhicules.
  If (length(Train.Vehicles) < Train_Maximum_Vehicles_Number) Then
    Begin
      // Création d'un nouveau véhicule.
      SetLength(Train.Vehicles, length(Train.Vehicles) + 1);

      // Itère parmi les places du véhicule créé.
      For i := 0 To Vehicle_Maximum_Passengers_Number - 1 Do
        Train.Vehicles[high(Train.Vehicles)].Passengers[i] := Nil;

      Train_Refresh_Label(Train);

      Vehicle_Create := True;
    End
  Else
    Vehicle_Create := False;
End;

// Fonction qui supprime un passager.
Function Passenger_Delete(Var Passenger : Type_Passenger_Pointer) : Boolean;
Begin
  If (Passenger <> Nil) Then
    Begin
      Dispose(Passenger);
      Passenger := Nil;
      Passenger_Delete := True;
    End
  Else
    Passenger_Delete := False;
End;

// - - Time

// Fonction qui renvoie le temps écoulé en millisecondes depuis le lancement du programme.
Function Time_Get_Current(): Type_Time;
Begin
  Time_Get_Current := SDL_GetTicks();
End;

// Fonction qui renvoie le temps écoulé entre le temps actuel et le temps passé en paramètre en millisecondes.
Function Time_Get_Elapsed(Start_Time : Type_Time) : Type_Time;
Begin
  Time_Get_Elapsed := SDL_GetTicks() - Start_Time;
End;

// - - Shape

// Fonction qui associe une forme à un chiffre.
Function Number_To_Shape(Number : Byte) : Type_Shape;
Begin
  Case Number Of 
    0 : Number_To_Shape := Circle;
    1 : Number_To_Shape := Lozenge;
    2 : Number_To_Shape := Pentagon;
    3 : Number_To_Shape := Square;
    4 : Number_To_Shape := Triangle;
  End;
End;

End.
