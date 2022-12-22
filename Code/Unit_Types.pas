// Unité contenant les types de données du jeu.

Unit Unit_Types;

Interface

// - Dépéndances

Uses sdl, sdl_mixer, sdl_gfx, sdl_image, sdl_ttf, sysutils, Math, Unit_Constants;

// - - Graphismes

// Structure de couleur
Type Type_Color = Record
    Red, Green, Blue, Alpha : Byte;
End;

// - - - Interface

// Structure d'étiquette
Type Type_Label = Record
  Position, Size : Type_Coordinates;
  Text : String;
  Font : pTTF_Font;
  Color : Type_Color;
  Surface : PSDL_Surface;
  Pre_Render : Boolean;
End;

// Structure de panneau
Type Type_Panel = Record
  Position, Size : Type_Coordinates;
  Surface : PSDL_Surface;
  Color : Type_Color;
  Hidden : Boolean;
End;

// Structure d'image
Type Type_Image = Record
  Position, Size : Type_Coordinates;
  Surface : PSDL_Surface;
End;

// Structure de bouton
Type Type_Button = Record
  Position, Size : Type_Coordinates;
  Pressed : Boolean;
  Surface_Pressed : PSDL_Surface;
  Surface_Released : PSDL_Surface;
  Hidden : Boolean;
End;

// Structure de bouton à deux états
Type Type_Dual_State_Button = Record
  Position, Size : Type_Coordinates;
  Pressed : Boolean;
  State : Boolean;
  Surface_Pressed : array[0 .. 1] Of PSDL_Surface;
  Surface_Released : array[0 .. 1] Of PSDL_Surface;
End;

// Structure de diagramme
Type Type_Pie = Record
  Position, Size : Type_Coordinates;
  Surface : PSDL_Surface;
  Color : Type_Color;
  Percentage : Real;
  Pre_Render : Boolean;
End;

// - - Temps

Type Type_Time = Longword;

// Enumération des jours.
Type Type_Day = (Day_Monday,
                 Day_Tuesday,
                 Day_Wednesday,
                 Day_Thursday,
                 Day_Friday,
                 Day_Saturday,
                 Day_Sunday);

// Structure contenant tout les pointeurs des sprites du jeu.

// Enumération des tailles de police.
Type Type_Font_Size = (Font_Small, Font_Medium, Font_Big);

// Enumération des épaisseurs de police.
Type Type_Font_Weight = (Font_Normal, Font_Bold);

// Enumération des couleurs.
Type Type_Color_Name = (Color_Black,
                        Color_Red,
                        Color_Purple,
                        Color_Deep_Purple,
                        Color_Indigo,
                        Color_Blue,
                        Color_Light_Blue,
                        Color_Cyan,
                        Color_Teal,
                        Color_Green,
                        Color_Light_Green,
                        Color_Lime,
                        Color_Yellow,
                        Color_Amber,
                        Color_Orange,
                        Color_Deep_Orange,
                        Color_Brown,
                        Color_Grey,
                        Color_Blue_Grey,
                        Color_White
                       );


// - - Jeu


// - - Entités du jeu.

// Enumération des formes.
Type Type_Shape = (Circle, Lozenge, Pentagon, Square, Triangle);

// Type pointeur de station.
Type Type_Station_Pointer = ^Type_Station;

// Structure de passager
  Type_Passenger = Record
    // Taille du passager.
    Size : Type_Coordinates;
    // Forme du passager (et donc sa station de destination).
    Shape : Type_Shape;
    // Pointeur vers le sprite du passager.
    Sprite : PSDL_Surface;
    // Itinéraire du passager.
    Itinerary : Array Of Type_Station_Pointer;
  End;

// Pointeur de passager
  Type_Passenger_Pointer = ^Type_Passenger;

  // Structure de station
  Type_Station = Record
    // Coordonnées de la station.
    Position, Size, Position_Centered : Type_Coordinates;
    // Forme de la station.
    Shape : Type_Shape;
    // Pointeur vers le sprite de la station.
    Sprite : PSDL_Surface;
    // Tableau des pointeurs  passagers présents à la station.
    Passengers : array Of Type_Passenger_Pointer;
    Timer : Type_Pie;
    Overfill_Timer : Type_Time;
  End;

  // Structure de véhicule
  Type_Vehicle = Record
    Passengers : Array[0 .. (Vehicle_Maximum_Passengers_Number - 1)] Of Type_Passenger_Pointer;
  End;

  // Structure de train
  Type_Train = Record
    Position, Size : Type_Coordinates;
    Sprite : PSDL_Surface;
    Start_Time : Type_Time;
    Deceleration_Time : Real;
    Driving : Boolean;
    Last_Station : Type_Station_Pointer;
    Next_Station : Type_Station_Pointer;
    Distance : Integer;
    Intermediate_Position : Type_Coordinates;
    Intermediate_Position_Distance : Integer;
    Direction : Boolean;
    Speed : Integer;
    Vehicles : array Of Type_Vehicle;
    Passengers_Label : Type_Label;
    Color_Index : Byte;
  End;

  // Type pointeur de train.
  Type_Train_Pointer = ^Type_Train;
  
  // - - Line

// Structure de ligne
Type  Type_Line = Record
    // Couleur de la ligne.
    Color : Type_Color;
    // Tableau dynamique de pointeur vers les stations.
    Stations : array Of Type_Station_Pointer;
    // Tableau dynamique des positions intermédiaires pré-calculées.
    Intermediate_Positions : Array Of Type_Coordinates;
    // Tableau dynamique contenant les trains.
    Trains : array Of Type_Train;
    // Bouton de la ligne.
    Button : Type_Dual_State_Button;
  End;

// Type pointeur de ligne.
  Type_Line_Pointer = ^Type_Line;

// Structure renfermant les données du joueur.
Type Type_Player = Record
  // Score du joueur (nombre de passagers transportés)
  Score : Integer;
  // Locomotives du joueur.
  Locomotive_Token : Byte;
  // Wagons du joueur.
  Wagon_Token : Byte;
  // Tunnels du joueur.
  Tunnel_Token : Byte;
  // Tunnels utilisés.
  Tunnels_Used : Byte;
End;

// - Itinéraires

// Type de tableau de graphes.
Type Type_Graph_Table = Array Of Array Of Array Of Type_Line_Pointer;

// Structure de cellule de Dijkstra.
Type Type_Dijkstra_Cell = Record
  isConnected : Boolean;
  isAvailable : Boolean;
  isValidated : Boolean;
  Coming_From_Station_Index : Byte;
  Weight : Real;
End;

// Type de tableau de cellule de Dijkstra.
Type Type_Itinerary_Indexes = Array Of Integer;


  // - - Souris

Type 
  {$scopedEnums on}
  Type_Mouse_Mode = (Normal, Delete_Locomotive, Add_Locomotive, Add_Wagon, Line_Add_Station, Line_Insert_Station);

Type Type_Mouse = Record
  Press_Position, Release_Position : Type_Coordinates;
  Mode : Type_Mouse_Mode;
  State : Boolean;
  Selected_Train : Type_Train_Pointer;
  Selected_Line : Type_Line_Pointer;
  Selected_Last_Station, Selected_Next_Station : Type_Station_Pointer;

End;

Type Type_Animation = Record
  Acceleration_Distance : Integer;
End;

Type Type_Index_Table = Array of Integer;
Type Type_Dijkstra_Table = Array of Array of Type_Dijkstra_Cell;


Type Type_Ressources = Record
  // Polices de caractères.
  Fonts : Array [Font_Small..Font_Big, Font_Normal..Font_Bold] Of pTTF_Font;
  // Stations (5 formes différentes).
  Stations : Array [0 .. (Game_Shapes_Number - 1)] Of PSDL_Surface;
  // Passagers (5 formes différentes).
  Passengers : Array [0 .. (Game_Shapes_Number - 1)] Of PSDL_Surface;
  // Vehicules (locomotives et wagons), la première dimension est pour les couleurs et la deuxième pour l'orientation (0, 45, 90 et 135 degrés).
  Vehicles : Array [0 .. 8, 0 .. 3] Of PSDL_Surface;
  // Boutons
  Train_Add, Wagon_Add, Tunnel_Add, Line_Add : PSDL_Surface;
  // Sons
  Music : pMIX_MUSIC;
End;


// - - Partie

// Structure de type jeu
Type Type_Game = Record

  Animation : Type_Animation;

  Start_Time : Type_Time;
  Day : Type_Day;

  Pause_Time : Type_Time;

  // Temporisateur déterminant quand rendre les graphismes.
  Graphics_Timer : Type_Time;
  // Temporisateur déterminant quand générer un nouveau passager.
  Passengers_Timer : Type_Time;
  // Temporisateur déterminant quand générer une nouvelle station.
  Stations_Timer : Type_Time;
  // Temporisateur déterminant quand rafraîchir la logique.
  Logic_Timer : Type_Time;

  // Souris
  Mouse : Type_Mouse;
  // Fenêtre du jeu.
  Window : Type_Panel;
  // Panneau contenant le terrain de jeu. 
  Panel_Right : Type_Panel;

  // Panneau de récompenses.
  Panel_Reward : Type_Panel;
  Title_Label : Type_Label;
  Message_Label : Type_Label;
  Reward_Buttons : Array[0 .. 1] Of Type_Button;
  Reward_Labels : Array[0 .. 1] Of Type_Label;

  // Panneau contenant l'interface du haut (score, heure ...).
  Panel_Top : Type_Panel;
  Escape_Button : Type_Button;

  Play_Pause_Button : Type_Dual_State_Button;
  Score_Label : Type_Label;
  Score_Image : Type_Image;
  Clock_Label : Type_Label;
  Clock_Image : Type_Image;

  // Panneau contenant l'interface du bas (selection des lignes).
  Panel_Bottom : Type_Panel;

  // Panneau contenant l'interface de gauche (trains, wagons, tunnels).
  Panel_Left : Type_Panel;
  Locomotive_Button : Array[0 .. 2] Of Type_Button;
  Wagon_Button : Array[0 .. 2] Of Type_Button;
  Tunnel_Button : Array[0 .. 2] Of Type_Button;

  Ressources : Type_Ressources;
  Player : Type_Player;
  Stations : Array Of Type_Station_Pointer;
  River : Array Of Type_Coordinates;
  // Un échiquier des stations dont la hauteur contient les lignes qui relient les dites stations.  
  Graph_Table : Type_Graph_Table;

  Refresh_Graph_Table : Boolean;
  // Carte des stations.
  Stations_Map : Array Of Array Of Boolean;
  // Tableau de dijkstra.
  Dijkstra_Table : Array Of Array Of Type_Dijkstra_Cell;


  // Lignes
  // Tableau dynamique contenant les lignes.
  Lines : array Of Type_Line;
End;

// Menu principal du jeu.

Type Type_Menu = Record
  Logo : Type_Image;
  Play_Label : Type_Label;
  Play_Image : Type_Image;

  Options_Label : Type_Label;
  Options_Image : Type_Image;

End;

// Options du jeu.

Type Type_Options = Record

  Sound_Button : Type_Button;

End;

Type Type_Game_Pointer = ^Type_Game;

Implementation

End.