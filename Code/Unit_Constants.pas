// Cette unité contient toutes les constantes du jeu (et un type).

Unit Unit_Constants;

Interface

uses sdl, sdl_mixer;

// 
Type Type_Coordinates = Record
  X, Y : LongInt;
End;


// - - Réglages généraux

// - - - Graphismes

Const Color_Depth =   32;

Const Full_Screen =  False;

Const Screen_Width =  960;

Const Screen_Height =  720;

Const Mask_Alpha =  $FF000000;

Const Mask_Red =  $000000FF;

Const Mask_Green =  $0000FF00;

Const Mask_Blue =  $00FF0000;

  // - - - Répertoires des ressources.

  // - - - - Images

Const Path_Ressources =  'Resources/';

Const Path_Images =  Path_Ressources + 'Images/';

Const Path_Image_Station_Circle =   Path_Images + 'Station_Circle.png';

Const Path_Image_Station_Square =   Path_Images + 'Station_Square.png';

Const Path_Image_Station_Triangle =   Path_Images + 'Station_Triangle.png';

Const Path_Image_Station_Pentagon =   Path_Images + 'Station_Pentagon.png';

Const Path_Image_Station_Lozenge =   Path_Images + 'Station_Lozenge.png';

Const Path_Image_Passenger_Circle =   Path_Images + 'Passenger_Circle.png';

Const Path_Image_Passenger_Square =   Path_Images + 'Passenger_Square.png';

Const Path_Image_Passenger_Triangle =   Path_Images + 'Passenger_Triangle.png';

Const Path_Image_Passenger_Pentagon =   Path_Images + 'Passenger_Pentagon.png';

Const Path_Image_Passenger_Lozenge =   Path_Images + 'Passenger_Lozenge.png';

Const Path_Image_Vehicle =   Path_Images + 'Vehicle.png';

Const Path_Image_People = Path_Images + 'People.png';

Const Path_Image_Clock = Path_Images + 'Clock.png';

Const Path_Image_Play = Path_Images + 'Play.png';

Const Path_Image_Pause = Path_Images + 'Pause.png';

Const Path_Image_Button_Locomotive = Path_Images + 'Locomotive.png';

Const Path_Image_Button_Wagon = Path_Images + 'Wagon.png';

Const Path_Image_Button_Tunnel = Path_Images + 'Tunnel.png';

Const Path_Image_Button_Escape = Path_Images + 'Escape.png';

  // - - - - Polices

Const Path_Fonts = Path_Ressources + 'Fonts/';

Const Path_Font =   Path_Fonts + '/TitilliumWeb-Regular.ttf';

Const Path_Font_Bold = Path_Fonts + '/TitilliumWeb-Bold.ttf';

  // - - - - Sons

Const Path_Sounds = Path_Ressources + 'Sounds/';

Const Path_Sounds_Music = Path_Sounds + 'Sounds.wav';

Const Mouse_Size : Type_Coordinates = (
                                       X :  8;
                                       Y :  8;
                                      );

Const Vehicle_Size : Type_Coordinates = (
                                         X :  32;
                                         Y :  24;
                                        );

Const Origin_Coordinates : Type_Coordinates = (
                                               X :  0;
                                               Y :  0;
                                              );

Const River_Width = 32;


  // - Sons

Const Sounds_Sampling_Rate = 22050;
  Sounds_Format : Word = AUDIO_S16;
  Sounds_Channels : INTEGER = 2;
  Sounds_Chunck_Size : INTEGER = 4096;
  Sounds_Maximum_Volume = 128;


  // - - - Jeux

  // - - - - Entités

Const Game_Maximum_Lines_Number = 8;

Const Maximum_Number_Stations = 200;

Const Game_Day_Duration =  10;

  // - - - Shapes

Const Shapes_Number = 5;

Const Station_Overfill_Timer = 20;

Const Station_Overfill_Passengers_Number = 6;

  // - - - Station

  // - - - Trains

  // - - - - Vehicles


Const Vehicle_Maximum_Passengers_Number = 6;

Const Train_Maximum_Vehicles_Number = 3;

  // - - - Lignes

Const Lines_Maximum_Number_Stations = 20;

Const Lines_Maximum_Number_Trains = 4;

  // - Définition des types

Const Train_Maximum_Speed = 80;

Const Train_Acceleration_Time = 3;

Const Train_Speed_Constant : Real = Pi / Train_Acceleration_Time;

Implementation

End.
