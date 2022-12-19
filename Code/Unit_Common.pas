// Unité qui regroupe toutes les fonctions et procédures de base utilisées dans le programme.

Unit Unit_Common;

Interface

// - Définition d

Uses sdl, sdl_gfx, sdl_ttf, sysutils, math, Unit_Types, Unit_Constants;

// - Déclaration des fonctions et procédures.


Function Get_Center_Position(Position, Size : Type_Coordinates) : Type_Coordinates;

Function Get_Centered_Position(Container_Size, Size : Integer) : Integer;


// - - Station.

Function Station_Create(Var Game: Type_Game) : Boolean;
Procedure Stations_Delete(Var Game : Type_Game);

// - Lines

Function Line_Create(Var Game : Type_Game) : Boolean;
Function Line_Delete(Var Line : Type_Line; Var Game : Type_Game) : Boolean;
Procedure Line_Compute_Intermediate_Positions(Var Line : Type_Line);

Function Line_Add_Station(Station_Pointer : Type_Station_Pointer; Var Line : Type_Line; Var Game : Type_Game) : Boolean;
Function Line_Add_Station(Last_Station_Pointer, Station_Pointer : Type_Station_Pointer; Var Line : Type_Line; Var Game : Type_Game) : Boolean;

Function Line_Remove_Station(Station_Pointer : Type_Station_Pointer; Var Line : Type_Line; Var Game : Type_Game) : Boolean;

Function Line_Rectangle_Colliding(Line_A, Line_B, Rectangle_Position, Rectangle_Size : Type_Coordinates) : Boolean;
Function Lines_Colliding(Line_1, Line_2, Line_3, Line_4 : Type_Coordinates) : Boolean;

Function Lines_Get_Selected(Game : Type_Game) : Type_Line_Pointer;


// - Train

Function Train_Create(Start_Station : Type_Station_Pointer; Direction : Boolean; Var Line : Type_Line; Var Game : Type_Game) : Boolean;

// - Vehicle

Function Vehicle_Create(Var Train : Type_Train) : Boolean;
// - Passenger

Procedure Passenger_Create(Var Station : Type_Station; Var Game : Type_Game);
Function Passenger_Delete(Var Passenger : Type_Passenger_Pointer) : Boolean;

// - - Time

Function Time_Get_Current(): Type_Time;
Function Time_Get_Elapsed(Start_Time : Type_Time) : Type_Time;

// - - Shape



Function Number_To_Shape(Number : Byte) : Type_Shape;

Function String_To_Characters(String_To_Convert : String) : pChar;

Function Get_Angle(Position_1, Position_2 : Type_Coordinates):   Real;

Function Get_Distance(Position_1, Position_2 : Type_Coordinates) : Integer;
Function Station_Get_Intermediate_Position(Position_1, Position_2 : Type_Coordinates) :   Type_Coordinates;

Function Time_Index_To_Day(Day_Index : Byte) : Type_Day;

Function Day_To_String(Day : Type_Day) : String;

Function Panel_Get_Relative_Position(Absolute_Position : Type_Coordinates; Panel : Type_Panel) : Type_Coordinates;

Function Lines_Intersects(a1, a2, b1, b2 : Type_Coordinates) : Boolean;

Procedure Graphics_Draw_Filled_Circle(Surface : PSDL_Surface; Center : Type_Coordinates; Radius : Integer; Color : Type_Color);

Procedure Graphics_Draw_Filled_Rectangle(Surface : PSDL_Surface; Position, Size : Type_Coordinates; Color : Type_Color);


Function Color_Get(Color_Name : Type_Color_Name) : Type_Color;
Function Color_Get(Color_Name : Type_Color_Name; Alpha : Byte) : Type_Color;
Function Color_Get(Red,Green,Blue,Alpha : Byte) : Type_Color;

operator = (x, y: Type_Color) b : Boolean;

Procedure Dual_State_Button_Set(Var Dual_State_Button : Type_Dual_State_Button; Surface_Pressed_Enabled, Surface_Pressed_Disabled, Surface_Released_Enable, Surface_Released_Disabled : PSDL_Surface);

Function Graphics_Surface_Create(Width, Height : Integer) : PSDL_Surface;

// - Etiquettes

Procedure Label_Set(Var Laabel : Type_Label; Text_String : String; Font : pTTF_Font; Color : Type_Color);
Procedure Label_Set_Color(Var Laabel : Type_Label; Color : Type_Color);
Procedure Label_Set_Text(Var Laabel : Type_Label; Text_String : String);
Procedure Label_Set_Font(Var Laabel : Type_Label; Font : pTTF_Font);

Procedure Game_Play(Var Game : Type_Game);
Procedure Game_Pause(Var Game : Type_Game);

Procedure Panel_Set_Hidden(Hidden : Boolean; Var Panel : Type_Panel);

Procedure River_Create(Var Game : Type_Game);

Procedure Pie_Create(Var Pie : Type_Pie; Radius : Integer; Color : Type_Color; Percentage : Real);
Procedure Pie_Set_Percentage(Var Pie : Type_Pie; Percentage : Real);

Function Vehicle_Delete(Var Train : Type_Train) : Boolean;

Function Graphics_Get_Direction(Angle : Real) : Integer;

Procedure Train_Refresh_Label(Var Train : Type_Train);

Implementation

Procedure Train_Refresh_Label(Var Train : Type_Train);

Var i, j, k : Byte;
Begin
  k := 0;
  For i := low(Train.Vehicles) To high(Train.Vehicles) Do
      For j := 0 To Vehicle_Maximum_Passengers_Number - 1 Do
          If Train.Vehicles[i].Passengers[j] <> nil Then
            inc(k);

  Label_Set_Text(Train.Passengers_Label, IntToStr(k) + '/' + IntToStr(length(Train.Vehicles) * Vehicle_Maximum_Passengers_Number));
End;

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

Procedure Pie_Create(Var Pie : Type_Pie; Radius : Integer; Color : Type_Color; Percentage : Real);
Begin
  Pie.Color := Color;
  Pie.Percentage := Percentage;
  Pie.Size.X := Radius * 2;
  Pie.Size.Y := Radius * 2;
  Pie.Surface := Graphics_Surface_Create(Radius * 2, Radius * 2);
  Pie.Pre_Render := true;
End;


Procedure Pie_Set_Percentage(Var Pie : Type_Pie; Percentage : Real);
Begin
  Pie.Percentage := Percentage;
  Pie.Pre_Render := true;
End;

// Fonction qui génère aléatoire une rivière.
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
      0 :
          Begin
            Game.River[high(Game.River)].X := 0 - River_Width;
            Game.River[high(Game.River)].Y := Random(Game.Panel_Right.Size.Y);
          End;
      1 :
          Begin
            Game.River[high(Game.River)].X := Random(Game.Panel_Right.Size.X);
            Game.River[high(Game.River)].Y := 0 - River_Width;
          End;
      2 :
          Begin
            Game.River[high(Game.River)].X := Game.Panel_Right.Size.X + River_Width;
            Game.River[high(Game.River)].Y := Random(Game.Panel_Right.Size.Y);
          End;
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
      // Index pair (points de contrôle)
      If i Mod 2 = 0 Then
        Begin
          Game.River[i].X := Random(Game.Panel_Right.Size.X - River_Width) + River_Width;
          Game.River[i].Y := Random(Game.Panel_Right.Size.Y - River_Width) + River_Width;
        End
    End;

  // - Calcul des points intermédiaires.
  For i := low(Game.River) + 1 To high(Game.River) - 1 Do
    Begin
      // Index impair (positions intermédiaires)
      If (i Mod 2) <> 0 Then
        Begin
          // Calcul de la position intermédiaire.
          Game.River[i] := Station_Get_Intermediate_Position(Game.River[i - 1], Game.River[i + 1]);
        End;
    End;

End;

Procedure Panel_Set_Hidden(Hidden : Boolean; Var Panel : Type_Panel);
Begin
  Panel.Hidden := Hidden;
End;

Procedure Game_Pause(Var Game : Type_Game);
Begin
  Game.Pause_Time := Time_Get_Current();
End;

Procedure Game_Play(Var Game : Type_Game);

Var i, j : Byte;
Begin
  Game.Pause_Time := Time_Get_Current() - Game.Pause_Time;

  // - Mise à jour du temps de début du jeu.
  Game.Start_Time := Game.Start_Time + Game.Pause_Time;

  // - Mise à jour des temps de départ des trains.

  // Vérifie que la partie contient des lignes.
  If (length(Game.Lines) > 0) Then
    // Itère parmis les lignes.
    For i := low(Game.Lines) To high(Game.Lines) Do
      // Vérifie que la ligne contient des trains.
      If (length(Game.Lines[i].Trains) > 0) Then
        // Itère parmis les trains de la ligne.
        For j := low(Game.Lines[i].Trains) To high(Game.Lines[i].Trains) Do
          Game.Lines[i].Trains[j].Start_Time := Game.Lines[i].Trains[j].Start_Time + Game.Pause_Time;

  // - Mise à jour des timer de surcharge des stations.

  // Itère parmis les stations.
  For i := low(Game.Stations) To high(Game.Stations) Do
    // Si la station est surchargée.
    If (Game.Stations[i].Overfill_Timer <> 0) Then
      Game.Stations[i].Overfill_Timer := Game.Stations[i].Overfill_Timer + Game.Pause_Time;


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

Procedure Label_Set_Text(Var Laabel : Type_Label; Text_String : String);
Begin
  Laabel.Text := Text_String;
  Laabel.Pre_Render := true;
End;

Procedure Label_Set_Font(Var Laabel : Type_Label; Font : pTTF_Font);
Begin
  Laabel.Font := Font;
  Laabel.Pre_Render := true;
End;

Procedure Label_Set_Color(Var Laabel : Type_Label; Color : Type_Color);
Begin
  Laabel.Color := Color;
  Laabel.Pre_Render := true;
End;

Procedure Graphics_Draw_Filled_Rectangle(Surface : PSDL_Surface; Position, Size : Type_Coordinates; Color : Type_Color);
Begin
  BoxRGBA(Surface, Position.X, Position.Y, Position.X + Size.X, Position.Y + Size.Y, Color.Red, Color.Green, Color.Blue, Color.Alpha);
End;

Function Color_Get(Red,Green,Blue,Alpha : Byte) : Type_Color;
Begin
  Color_Get.Red := Red;
  Color_Get.Green := Green;
  Color_Get.Blue := Blue;
  Color_Get.Alpha := Alpha;
End;

Procedure Graphics_Draw_Filled_Circle(Surface : PSDL_Surface; Center : Type_Coordinates; Radius : Integer; Color : Type_Color);
Begin
  FilledCircleRGBA(Surface, Center.X, Center.Y, Radius, Color.Red, Color.Green, Color.Blue, Color.Alpha);
End;

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

Function Graphics_Surface_Create(Width, Height : Integer) : PSDL_Surface;
Begin
  // Création d'une surface SDL avec les masques de couleurs aproriés.
  Graphics_Surface_Create := SDL_CreateRGBSurface(0, Width, Height, Color_Depth, Mask_Red, Mask_Green, Mask_Blue,Mask_Alpha);
End;


// Surcharge de l'opérateur = permetant de comparer des couleurs.
operator = (x, y: Type_Color) b : Boolean;
Begin
  b := (x.Red = y.Red) And (x.Green = y.Green) And (x.Blue = y.Blue) And (x.Alpha = y.Alpha);
End;

Function Panel_Get_Relative_Position(Absolute_Position : Type_Coordinates; Panel : Type_Panel) : Type_Coordinates;
Begin
  Panel_Get_Relative_Position.X := Absolute_Position.X - Panel.Position.X;
  Panel_Get_Relative_Position.Y := Absolute_Position.Y - Panel.Position.Y;
End;


// Fonction qui renvoie la ligne actuellement sélectionnée où Nil s'il y en a pas.
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

// Fonction qui converti le nom d'une couleur en la couleur associée.
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

Function Color_Get(Color_Name : Type_Color_Name; Alpha : Byte) : Type_Color;
Begin
  Color_Get := Color_Get(Color_Name);
  Color_Get.Alpha := Alpha;
End;

// Fonction qui détecte si un rectangle et une ligne sont en colision.
Function Line_Rectangle_Colliding(Line_A, Line_B, Rectangle_Position, Rectangle_Size : Type_Coordinates) : Boolean;

Var 
  Temporary_Line : Array[0 .. 1] Of Type_Coordinates;
Begin
  // Les quatres côtés du rectangles sont décomposés en 4 lignes.
  // La détection se fait ensuite ligne par ligne.
  // Les détections sont imbriqués afin de ne pas faire de calculs inutiles.

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

          // Côté en haut du rectangle.

          Temporary_Line[0].X := Rectangle_Position.X;
          Temporary_Line[0].Y := Rectangle_Position.Y;
          Temporary_Line[1].X := Rectangle_Position.X + Rectangle_Size.X;
          Temporary_Line[1].Y := Rectangle_Position.Y;

          If (Lines_Intersects(Line_A, Line_B, Temporary_Line[0], Temporary_Line[1]) = False) Then
            Begin
              // Coté en bas du rectangle.
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


// a1 is line1 start, a2 is line1 end, b1 is line2 start, b2 is line2 end
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


// Fonction qui détecte si deux lignes sont sécantes.
Function Lines_Colliding(Line_1, Line_2, Line_3, Line_4 : Type_Coordinates) : Boolean;

Var Coeffcient_A, Coeffcient_B : Real;
Begin

  Coeffcient_A := ((Line_4.X-Line_3.X)*(Line_1.Y-Line_3.Y) - (Line_4.Y-Line_3.Y)*(Line_1.X-Line_3.X)) / ((Line_4.Y-Line_3.Y)*(Line_2.X-Line_1.X) - (Line_4.X-Line_3.X)*(Line_2.Y-Line_1.Y));

  Coeffcient_B := ((Line_2.X-Line_1.X)*(Line_1.Y-Line_3.Y) - (Line_2.Y-Line_1.Y)*(Line_1.X-Line_3.X)) / ((Line_4.Y-Line_3.Y)*(Line_2.X-Line_1.X) - (Line_4.X-Line_3.X)*(Line_2.Y-Line_1.Y));

  If ((Coeffcient_A  >= 0) And (Coeffcient_A <= 1) And (Coeffcient_B >= 0) And (Coeffcient_B <= 1)) Then
    Lines_Colliding := true
  Else
    Lines_Colliding := false;
End;


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

Function Get_Distance(Position_1, Position_2 : Type_Coordinates):   Integer;
Begin
  Get_Distance := round(sqrt(sqr(Position_2.X-Position_1.X)+sqr(Position_2.Y-Position_1.Y)));
End;

// - Définition des fonctions et procédures.

// Fonction qui renvoi l'angle entre deux points.
Function Get_Angle(Position_1, Position_2 : Type_Coordinates):   Real;
Begin
  Get_Angle := ArcTan2(-Position_2.Y + Position_1.Y,
               Position_2.X - Position_1.X);
End;

// Fonction qui calcule les positions intermédiaires spérant les stations d'une ligne.
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
          Line.Intermediate_Positions[i + low(Line.Intermediate_Positions)] := Station_Get_Intermediate_Position(Line.Stations[i]^.Position_Centered, Line.Stations[i + 1]^.
                                                                               Position_Centered);
        End;
    End;

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
      Direction := Graphics_Get_Direction(Get_Angle(Position_1, Position_2));
      Angle := Get_Angle(Position_1, Position_2);
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



    // - Angle between -45° and -135° (included)
  Else If ((Angle <= (-Pi/4)) And (Angle >= ((-3*Pi)/4))) Then
         //-45 - -90 - -135
         Begin
           Station_Get_Intermediate_Position.X := Position_1.X;
           Station_Get_Intermediate_Position.Y := Position_2.Y - abs(Position_2.X -
                                                  Position_1.X);
         End
         // - Angle between -45° and 45° (excluded)
  Else If (((Angle > (-Pi/4)) And (Angle < 0)) Or ((Angle < (Pi/4)) And (Angle
          >= 0))) Then
         Begin
           Station_Get_Intermediate_Position.Y := Position_1.Y;
           Station_Get_Intermediate_Position.X := Position_2.X - abs(Position_2.Y -
                                                  Position_1.Y);
         End
         // - Angle between 135° and -135° (excluded)
  Else
    Begin
      Station_Get_Intermediate_Position.Y := Position_1.Y;
      Station_Get_Intermediate_Position.X := Position_2.X + abs(Position_2.Y - Position_1.Y);
    End;

End;

// Fonction supprimant les stations d'une partie.
Procedure Stations_Delete(Var Game : Type_Game);

Var i, j : Byte;
Begin

  // Itère parmis les stations d'une partie.
  For i := low(Game.Stations) To high(Game.Stations) Do
    Begin
      // Itère parmis les passagers d'une station.
      For j := low(Game.Stations[i].Passengers) To high(Game.Stations[i].Passengers) Do
        Begin
          // Suppression du passager.
          Passenger_Delete(Game.Stations[i].Passengers[j]);
          // Suppression de l'emplacement du passager dans la station.
          delete(Game.Stations[i].Passengers, j, 1);
        End;
      // Suppression de la station.
      delete(Game.Stations, i, 1);
    End;
End;

Function String_To_Characters(String_To_Convert : String) : pChar;

Var Characters : pChar;
Begin
  Characters := StrAlloc(length(String_To_Convert) + 1);
  StrPCopy(Characters, String_To_Convert);
  String_To_Characters := Characters;
End;

// - Définition des fonctions et procédures

// - Création

Function Get_Center_Position(Position, Size : Type_Coordinates) : Type_Coordinates;
Begin
  Position.X := Position.X + (Size.X Div 2);
  Position.Y := Position.Y + (Size.Y Div 2);
  Get_Center_Position := Position;
End;

Function Get_Centered_Position(Container_Size, Size : Integer) : Integer;
Begin
  Get_Centered_Position := (Container_Size - Size) Div 2;
End;

// Procédure qui alloue de la mémoire pour une station et le référence dans le tableau dynamique, détermine sa forme et position aléatoirement et defini ses attributs.
Function Station_Create(Var Game : Type_Game) : Boolean;

Var Shape : Byte;
  Position : Type_Coordinates;
  i, j : Byte;
Begin
  If (length(Game.Stations) < Maximum_Number_Stations) Then
    Begin
      // Allocation de la station dans le tableau.
      SetLength(Game.Stations, length(Game.Stations) + 1);
      // Définition de l'index de la station créee.
      i := high(Game.Stations);

      // Initialisation des attributs par défaut.
      // Détermination de la forme de la station.
      If (length(Game.Stations) <= 5) Then
        // Les 5 premières stations doivent être de forme différentes pour pemetre à tout type de passager d'arriver à destionation.
        Shape := length(Game.Stations) - 1
      Else
        // Les stations suivantes peuvent avoir une forme aléatoire.
        Shape := Random(5);

      Game.Stations[i].Shape := Number_To_Shape(Shape);
      Game.Stations[i].Sprite := Game.Ressources.Stations[Shape];


      Game.Stations[i].Size.X := Game.Stations[i].Sprite^.w;

      Game.Stations[i].Size.Y := Game.Stations[i].Sprite^.h;

      // Détermination de la position de la station.
      Repeat
        // Détermination de la position aléatoire.
        Position.X := Random(length(Game.Stations_Map));
        Position.Y := Random(length(Game.Stations_Map[high(Game.Stations_Map)]));

        Game.Stations[i].Position.X := 64 * Position.X + (Game.Panel_Right.Size.X Mod 64) Div 2;
        Game.Stations[i].Position.Y := 64 * Position.Y + (Game.Panel_Right.Size.Y Mod 64) Div 2;

        If (Game.Stations_Map[Position.X][Position.Y] = false) Then
          Begin
            // Itère parmis les points de la rivière.
            For j := low(Game.River) + 1 To high(Game.River) Do
              Begin
                // Si il y a collision entre la rivière et la station.
                If (Line_Rectangle_Colliding(Game.River[j - 1], Game.River[j], Game.Stations[i].Position, Game.Stations[i].Size)) Then
                  Begin
                    // On maruqe l'emplacement comme occupé pour les prochaines stations crées.
                    Game.Stations_Map[Position.X][Position.Y] := true;
                    // On sort de la boucle.
                    break;
                  End;
              End;
          End;

      Until Game.Stations_Map[Position.X][Position.Y] = false;

      Game.Stations_Map[Position.X][Position.Y] := true;

      // ! : Ajouter la mise à jour de la Graph_Table

      SetLength(Game.Dijkstra_Table, length(Game.Stations));
      For j := low(Game.Dijkstra_Table) To high(Game.Dijkstra_Table) Do
        SetLength(Game.Dijkstra_Table[j], length(Game.Stations));

      // Calcul les coordoonées centré de la station.
      Game.Stations[i].Position_Centered := Get_Center_Position(Game.Stations[i].Position, Game.Stations[i].Size);

      // Création du timer de la station.
      Pie_Create(Game.Stations[i].Timer, 10, Color_Get(Color_Blue_Grey), 80);

      Game.Stations[i].Timer.Position.X := Game.Stations[i].Position_Centered.X + Game.Stations[i].Size.Y Div 2;
      Game.Stations[i].Timer.Position.Y := Game.Stations[i].Position.Y - Game.Stations[i].Size.Y Div 2 - 10;



      Game.Stations[i].Overfill_Timer := 0;

      Station_Create := True;
    End
  Else
    Station_Create := False;
End;

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
          // Vérifie s'il y intersection.
          
          Intermediate_Position := Station_Get_Intermediate_Position(Game.Stations[i].Position_Centered, Game.Stations[j].Position_Centered);

          For k := low(Game.River) To high(Game.River) - 1 Do
          Begin
            If (Lines_Intersects(Game.River[k], Game.River[k + 1], Game.Stations[i].Position_Centered, Intermediate_Position)) Then
                Inc(Count);

            If (Lines_Intersects(Game.River[k], Game.River[k + 1], Intermediate_Position, Game.Stations[j].Position_Centered)) Then
                Inc(Count);
          End; 

        End;

  writeln('Count : ', Count);

  Lines_Count_Necessary_Tunnel := Count;


End;

// Procédure qui créer une ligne.
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
      // Récupération de l'index de la ligne crée (dernier élément du tableau).
      i := high(Game.Lines);

      // - Détermination de la couleur.

      // TODO : Manière peu optimale de déterminer la couleur.

      // Initialisation du tableau des couleurs utilisées.
      For i := 0 To 7 Do
        Color_Used[i] := False;

      // Itère parmis les lignes.
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

      // Itère parmis le tableau des couleurs utilisées.
      For i := 0 To 7 Do
        // Si la couleur n'est pas utilisée.
        If (Color_Used[i] = False) Then
          Begin
            // On converti l'index en couleur et on l'assigne à la ligne.
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


      // Création du boutton
      Dual_State_Button_Set(Game.Lines[i].Button, Graphics_Surface_Create(32, 32), Graphics_Surface_Create(32, 32), Graphics_Surface_Create(32, 32), Graphics_Surface_Create(32, 32));

      Center.X := 16;
      Center.Y := 16;


      Graphics_Draw_Filled_Circle(Game.Lines[i].Button.Surface_Released[0], Center, 12, Game.Lines[i].Color);

      Graphics_Draw_Filled_Circle(Game.Lines[i].Button.Surface_Released[1], Center, 16, Game.Lines[i].Color);

      // - Recalcul des positions des boutons.

      // Centrage vertical du premier boutton.

      Game.Lines[i].Button.Position.Y := Get_Centered_Position(Game.Panel_Bottom.Size.Y, Game.Lines[i].Button.Size.Y);

      // Définition de la position du premier boutton. 
      Game.Lines[low(Game.Lines)].Button.Position.X := Get_Centered_Position(Game.Panel_Bottom.Size.X, (Game.Lines[i].Button.Size.X * length(Game.Lines)) + (16 * (length(Game.Lines) - 1)));

      If (length(Game.Lines) > 1) Then
        Begin
          // Itère parmis les lignes.
          For j := low(Game.Lines) + 1 To high(Game.Lines) Do
            Begin
              Game.Lines[j].Button.Position.Y := Game.Lines[j].Button.Position.Y;
              Game.Lines[j].Button.Position.X := Game.Lines[j - 1].Button.Position.X + Game.Lines[j - 1].Button.Size.X + 16;
            End;
        End;

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
      // Recalcul des positions intermédiaires de la ligne.
      Line_Compute_Intermediate_Positions(Line);

      Game.Refresh_Graph_Table := True;

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
          // - Vérifie si la station n'as pas déjà été ajoutée.
          For i := low(Line.Stations) To high(Line.Stations) Do
            If (Line.Stations[i] = Station_Pointer) Then
              Duplicate := true;

          // - Insertion de la station dans la ligne.

          // Si il la station n'as pas déjà été ajoutée.
          If (Duplicate = false) Then
            Begin
              // Itère parmis les stations de la ligne.
              For i := low(Line.Stations) To high(Line.Stations) Do
                Begin
                  If (Line.Stations[i] = Last_Station_Pointer) Then
                    Begin
                      // Agrandissement du tableau dynamique temporaire.
                      SetLength(Temporary_Array, 1);
                      // Ajout du pointeur de la station au tableau temporarie.
                      Temporary_Array[high(Temporary_Array)] := Station_Pointer;
                      // Insertion du pointeur de la station dans le tableau des stations de la ligne.
                      Insert(Temporary_Array, Line.Stations, i + 1);
                      // Recalcul des positions intermédiaires de la ligne.
                      Line_Compute_Intermediate_Positions(Line);

                      Game.Refresh_Graph_Table := True;

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
                // Itère parmis les trains de la ligne.
                For j := low(Line.Trains) To high(Line.Trains) Do
                  Begin
                    // Vérifie que tous les trains concerné ne sont pas en trainsit i un train est en transit vers où au départ de la station concerné.
                    If (Line.Trains[j].Last_Station = Station_Pointer) Or (Line.Trains[j].Next_Station = Station_Pointer) Then
                      Begin
                        Busy := true;
                        Break;
                      End;
                  End;
              End
            Else
              Busy := false;

            // Si la station n'est pas destionation où départ d'un train, on peut enlever la station de la ligne.
            If Not(Busy) Then
              Begin
                // Enlève la station.
                Delete(Line.Stations, i, 1);
                // Si il n'y a plus qu'une station dans la ligne, alors, on supprime la seule station restante.
                If (length(Line.Stations) = 1) Then
                  SetLength(Line.Stations, 0);
                Line_Compute_Intermediate_Positions(Line);

                Game.Refresh_Graph_Table := True;
            
                Line_Remove_Station := True;
              End;

            Break;
          End;
    End;
End;

// Fonction qui créer un passager dans une station.
Procedure Passenger_Create(Var Station : Type_Station; Var Game : Type_Game);

Var Shape : Byte;
Begin
  SetLength(Station.Passengers, length(Station.Passengers) + 1);
  // Allocation de la mémoire.
  Station.Passengers[high(Station.Passengers)] := GetMem(SizeOf(Type_Passenger));

  Repeat
    Shape := Random(Shapes_Number);
  Until (Station.Shape <> Number_To_Shape(Shape));

  // Définition de la forme du passager.
  Station.Passengers[high(Station.Passengers)]^.Shape := Number_To_Shape(Shape);
  // Définition du sprite du passager.
  Station.Passengers[high(Station.Passengers)]^.Sprite := Game.Ressources.Passengers[Shape];
  // Définition de la taille du passager.
  Station.Passengers[high(Station.Passengers)]^.Size.X := Station.Passengers[high(Station.Passengers)]^.Sprite^.w;
  Station.Passengers[high(Station.Passengers)]^.Size.Y := Station.Passengers[high(Station.Passengers)]^.Sprite^.h;
End;

Function Train_Create(Start_Station : Type_Station_Pointer; Direction : Boolean; Var Line : Type_Line; Var Game : Type_Game) : Boolean;

Var i : Byte;
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
          // Itère parmis les stations de la ligne.
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
                      Line.Trains[high(Line.Trains)].Intermediate_Position := Station_Get_Intermediate_Position(Line.Trains[high(Line.Trains)].Last_Station^.Position_Centered, Line.Trains[high(Line.
                                                                              Trains)].Next_Station^.Position_Centered);
                    End
                  Else
                    Begin
                      Line.Trains[high(Line.Trains)].Next_Station := Line.Stations[i - 1];

                      // Calcul du point intermédiaire.
                      Line.Trains[high(Line.Trains)].Intermediate_Position := Station_Get_Intermediate_Position(Line.Trains[high(Line.Trains)].Next_Station^.Position_Centered, Line.Trains[high(Line.
                                                                              Trains)].Last_Station^.Position_Centered);
                    End;
                  Break;
                End;
            End;
        End;

      // Calcul de la distance du point intermédiaire.
      Line.Trains[high(Line.Trains)].Intermediate_Position_Distance := Get_Distance(Line.Trains[high(Line.Trains)].Last_Station^.Position_Centered, Line.Trains[high(Line.Trains)].
                                                                       Intermediate_Position);

      // Calcul de la distance maximale du train.

      Line.Trains[high(Line.Trains)].Maximum_Distance := Get_Distance(Line.Trains[high(Line.Trains)].Last_Station^.Position_Centered, Line.Trains[high(Line.Trains)].Intermediate_Position);
      Line.Trains[high(Line.Trains)].Maximum_Distance := Line.Trains[high(Line.Trains)].Maximum_Distance
                                                         +  Get_Distance(Line.Trains[high(Line.Trains)].Intermediate_Position, Line.Trains[high
                                                         (Line.Trains)].Next_Station^.Position_Centered);

    


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

    Line.Trains[high(Line.Trains)].Deceleration_Time := ((Line.Trains[high(Line.Trains)].Maximum_Distance - (Train_Acceleration_Time * Train_Maximum_Speed)) / Train_Maximum_Speed) + Train_Acceleration_Time + (Line.Trains[high(Line.Trains)].Start_Time / 1000);

    writeln(' Max distance : ', Line.Trains[high(Line.Trains)].Maximum_Distance);
    writeln(' Acceleration time : ', Line.Trains[high(Line.Trains)].Deceleration_Time);




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

      // Itère parmis les passagers du dernier véhicule.
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

Function Vehicle_Create(Var Train : Type_Train) : Boolean;

Var i, j, k : Byte;

Begin
  // Vérifie que le train n'a pas atteint le nombre maximum de véhicules.
  If (length(Train.Vehicles) < Train_Maximum_Vehicles_Number) Then
    Begin
      // Création d'un nouveau véhicule.
      SetLength(Train.Vehicles, length(Train.Vehicles) + 1);


      // Itère parmis les places du véhicule crée.
      For i := 0 To Vehicle_Maximum_Passengers_Number - 1 Do
        Train.Vehicles[high(Train.Vehicles)].Passengers[i] := Nil;

      Train_Refresh_Label(Train);

      Vehicle_Create := True;
    End
  Else
    Vehicle_Create := False;
End;

// - - Object deletion.

Function Line_Delete(Var Line : Type_Line; Var Game : Type_Game) : Boolean;

Var i : Byte;
Begin
  If (length(Line.Trains) > 0) Then
    Begin
      For i := low(Game.Lines) To high(Game.Lines) Do
        Begin
          If (@Game.Lines[i] = @Line) Then
            Begin
              Game.Lines[i] := Game.Lines[high(Game.Lines)];
              SetLength(Game.Lines, length(Game.Lines) - 1);
              Line_Delete := True;
              Break;
            End;
        End;
    End
  Else
    Line_Delete := False;
End;

Function Passenger_Delete(Var Passenger : Type_Passenger_Pointer) : Boolean;
Begin
  If (Passenger <> Nil) Then
    Begin
      FreeMem(Passenger);
      Passenger := Nil;
      Passenger_Delete := True;
    End
  Else
    Passenger_Delete := False;
End;

// - - Time

Function Time_Get_Current(): Type_Time;
Begin
  Time_Get_Current := SDL_GetTicks();
End;

Function Time_Get_Elapsed(Start_Time : Type_Time) : Type_Time;
Begin
  Time_Get_Elapsed := SDL_GetTicks() - Start_Time;
End;

// - - Shape

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
