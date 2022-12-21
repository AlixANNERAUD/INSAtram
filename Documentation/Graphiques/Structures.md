```mermaid
classDiagram

class Type_Color {
  Red Green Blue Alpha : Byte
}

class Type_Label {
  Position Size : Type_Coordinates
  Text : String
  Font : pTTF_Font
  Color : Type_Color
  Surface : PSDL_Surface
  Pre_Render : Boolean
}

class Type_Panel {
  Position Size : Type_Coordinates
  Surface : PSDL_Surface
  Color : Type_Color
  Hidden : Boolean
}

class Type_Image {
  Position Size : Type_Coordinates
  Surface : PSDL_Surface
}

class Type_Button {
  Position Size : Type_Coordinates
  Pressed : Boolean
  Surface_Pressed : PSDL_Surface
  Surface_Released : PSDL_Surface
  Hidden : Boolean
}

class Type_Dual_State_Button {
  Position Size : Type_Coordinates
  Pressed : Boolean
  State : Boolean
  Surface_Pressed : array[0 .. 1] Of PSDL_Surface
  Surface_Released : array[0 .. 1] Of PSDL_Surface
}

class Type_Pie {
  Position Size : Type_Coordinates
  Surface : PSDL_Surface
  Color : Type_Color
  Percentage : Real
  Pre_Render : Boolean
}

class Type_Time {
   Type : Longword
}

class Type_Day { 
    <<enumeration>>
    Day_Monday
                 Day_Tuesday
                 Day_Wednesday
                 Day_Thursday
                 Day_Friday
                 Day_Saturday
                 Day_Sunday
}
    

class Type_Font_Size { 
    <<enumeration>>
Font_Small
Font_Medium Font_Big
}

class Type_Font_Weight {
    <<enumeration>>
Font_Normal 
Font_Bold
}

class Type_Color_Name { 
    <<enumeration>>
    Color_Black
                        Color_Red
                        Color_Purple
                        Color_Deep_Purple
                        Color_Indigo
                        Color_Blue
                        Color_Light_Blue
                        Color_Cyan
                        Color_Teal
                        Color_Green
                        Color_Light_Green
                        Color_Lime
                        Color_Yellow
                        Color_Amber
                        Color_Orange
                        Color_Deep_Orange
                        Color_Brown
                        Color_Grey
                        Color_Blue_Grey
                        Color_White
                       }


class Type_Ressources {
  Fonts : Array [Font_Small..Font_Big Font_Normal..Font_Bold] Of pTTF_Font
  Stations : Array [0 .. (Game_Shapes_Number - 1)] Of PSDL_Surface
  Passengers : Array [0 .. (Game_Shapes_Number - 1)] Of PSDL_Surface
  Vehicles : Array [0 .. 8 0 .. 3] Of PSDL_Surface
  Music : pMIX_MUSIC
}



class Type_Shape { <<enumeration>>
Circle 
Lozenge 
Pentagon
Square
Triangle
}

class Type_Station_Pointer {
    Type_Station
    }

 class Type_Passenger {
    Size : Type_Coordinates
    // Forme du passager (et donc sa station de destination).
    Shape : Type_Shape
    // Pointeur vers le sprite du passager.
    Sprite : PSDL_Surface
    // Itinéraire du passager.
    Itinerary : Array Of Type_Station_Pointer
  }

class Type_Passenger_Pointer {
    ^Type_Passenger
    }

  // - - Station

  class Type_Station {
    // Position position centrée et taille de la stations.
    Position Size Position_Centered : Type_Coordinates
    // Forme de la station.
    Shape : Type_Shape
    // Pointeur vers le sprite de la station.
    Sprite : PSDL_Surface
    // Passagers de la station.
    Passengers : array Of Type_Passenger_Pointer
    // 
    Timer : Type_Pie
    // 
    Overfill_Timer : Type_Time
  }

 class Type_Vehicle {
    // Passagers dans le véhicule.
    Passengers : Array[0 .. (Vehicle_Maximum_Passengers_Number - 1)] Of Type_Passenger_Pointer
  }

  Type_Train {
    // Position du train.
    Position Size : Type_Coordinates
    // Sprite du train.
    Sprite : PSDL_Surface
    Start_Time : Type_Time
    // Détermine si le train est à l'arrêt ou non.
    Driving : Boolean
    // Pointeur de la dernière station.
    Last_Station : Type_Station_Pointer
    // Pointeur de la prochaine station.
    Next_Station : Type_Station_Pointer
    // Distance parcourue depuis la dernière station en pixel.
    Distance : Integer
    // Copie de la position intermédiaire actuelle entre les stations.
    Intermediate_Position : Type_Coordinates
    // Distance de la prochaine position intermédiaire.
    Intermediate_Position_Distance : Integer
    // - Distance maximum
    Maximum_Distance : Integer
    // Direction directe ou indirecte du train (indexe des stations de la ligne croissant ou décroissant).
    Direction : Boolean
    // - Vitesse du train.
    Speed : Integer
    //  Tableau contenant les wagons du train.
    Vehicles : array Of Type_Vehicle
    // Etiquette 
    Passengers_Label : Type_Label
    // Indexe de la couleur du train.
    Color_Index : Byte

    Pre_Render : Boolean
  }

  Type_Train_Pointer = ^Type_Train
  // - - Line

class Type_Line_Colors { <<enumeration>>Red Purple Indigo Teal Green Yellow Orange Brown)

  Type_Line {
    // Couleur de la ligne.
    Color : Type_Color
    // Tableau dynamique de pointeur vers les stations.
    Stations : array Of Type_Station_Pointer
    // Tableau dynamique des positions intermédiaires pré-calculées.
    Intermediate_Positions : Array Of Type_Coordinates
    // Tableau dynamique contenant les trains.
    Trains : array Of Type_Train
    // Boutton de la ligne.
    Button : Type_Dual_State_Button
  }

  Type_Line_Pointer = ^Type_Line

  // Structure renfermant les données du joueur.

class Type_Player {
  // Score du joueur (nombre de passager transporté)
  Score : Integer
  // Locomotives du joueur.
  Locomotive_Token : Byte
  // Wagon du joueur.
  Wagon_Token : Byte
  // Tunnel du joueur.
  Tunnel_Token : Byte
}

// - Itineraries

class Type_Graph_Table = Array Of Array Of Array Of Type_Line_Pointer

class Type_Dijkstra_Cell {
  isConnected : Boolean
  isAvailable : Boolean
  comingFromStationIndex : Integer
  weight : Real
  isValidated : Boolean
}

class Type_Itinerary_Indexes = Array Of Integer


  // - - Souris

class Type_Mouse_Mode {
    <<enumeration>>
  Normal Delete_Locomotive 
  Add_Locomotive 
  Add_Wagon
  Line_Add_Station
  Line_Insert_Station
}

class Type_Mouse {
  Press_Position Release_Position : Type_Coordinates
  Mode : Type_Mouse_Mode
  State : Boolean
  Selected_Train : Type_Train_Pointer
  Selected_Line : Type_Line_Pointer
  Selected_Last_Station Selected_Next_Station : Type_Station_Pointer

}

class Type_Animation {
  Acceleration_Distance : Integer
}

class Type_Index_Table = Array of Integer
class Type_Dijkstra_Table = Array of Array of Type_Dijkstra_Cell

// - - Partie

class Type_Game {

  Performance : Type_Time

  Animation : Type_Animation

  Start_Time : Type_Time
  Day : Type_Day

  Pause_Time : Type_Time

  // Temporisateur déterminant rendre les graphismes.
  Graphics_Timer : Type_Time
  // Temporisateur déterminant quand générer un nouveau passager.
  Passengers_Timer : Type_Time
  // Temporisateur déterminant quand rafraishir la logique.
  Logic_Timer : Type_Time

  // Souris
  Mouse : Type_Mouse
  // Fenêtre du jeu.
  Window : Type_Panel
  // Panneau contenant le terrain de jeu. 
  Panel_Right : Type_Panel

  // Panneau de récompense.
  Panel_Reward : Type_Panel
  Title_Label : Type_Label
  Message_Label : Type_Label
  Reward_Buttons : Array[0 .. 1] Of Type_Button
  Reward_Labels : Array[0 .. 1] Of Type_Label

  // Panneau contenant l'interface du haut (score heure ...).
  Panel_Top : Type_Panel
  Escape_Button : Type_Button

  Play_Pause_Button : Type_Dual_State_Button
  Score_Label : Type_Label
  Score_Image : Type_Image
  Clock_Label : Type_Label
  Clock_Image : Type_Image

  // Panneau contenant l'interface du bas (selection des lignes).
  Panel_Bottom : Type_Panel

  // Panneau contenant l'interface de gauche (train wagon tunnel).
  Panel_Left : Type_Panel
  Locomotive_Button : Array[0 .. 2] Of Type_Button
  Wagon_Button : Array[0 .. 2] Of Type_Button
  Tunnel_Button : Array[0 .. 2] Of Type_Button

  // Structure contenant les sprites du jeu.
  Ressources : Type_Ressources
  // Inventaire
  Player : Type_Player
  // Stations
  // Tableau dymamique contenant les stations.
  Stations : Array Of Type_Station
  // Tableau des 
  River : Array Of Type_Coordinates
  // Un échiquier des stations dont la hauteur contient les lignes qui relient les dites stations.  
  Graph_Table : Type_Graph_Table
  // Carte des stations.
  Stations_Map : Array Of Array Of Boolean
  // Tableau de dijkstra.
  Dijkstra_Table : Array Of Array Of Type_Dijkstra_Cell


  // Lignes
  // Tableau dynamque contenant les lignes.
  Lines : array Of Type_Line
}

// Menu principal du jeu.

class Type_Menu {
  Logo : Type_Image
  Play_Label : Type_Label
  Play_Image : Type_Image

  Options_Label : Type_Label
  Options_Image : Type_Image

}

// Options du jeu.

class Type_Options {

  Sound_Button : Type_Button

}

class Type_Game_Pointer = ^Type_Game

```