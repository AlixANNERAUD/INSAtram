// Unité contenant toutes les constantes du jeu (et un type).

Unit Unit_Constants;

Interface

// - Dépendances

Uses sdl, sdl_mixer;

// - Structure

Type Type_Coordinates = Record
      X, Y : LongInt;
End;

// - Constantes

// - - Graphismes

Const Color_Depth =   32;
      Screen_Width =  960;
      Screen_Height =  720;
      Mask_Alpha =  $FF000000;
      Mask_Red =  $000000FF;
      Mask_Green =  $0000FF00;
      Mask_Blue =  $00FF0000;
      Origin_Coordinates : Type_Coordinates = ( X :  0; Y :  0;);

  // - - Son

Const Sounds_Sampling_Rate = 44100;
      Sounds_Format : Word = AUDIO_S16;
      Sounds_Channels : INTEGER = 2;
      Sounds_Chunck_Size : INTEGER = 4096;
      Sounds_Maximum_Volume = 64;

  // - - Souris

Const Mouse_Size : Type_Coordinates = (
                                       X :  8;
                                       Y :  8;
                                      );

  // - - Jeu

Const Game_Maximum_Lines_Number = 8;
      Game_Day_Duration =  10;
      Game_Maximum_Number_Stations = 50;
      Game_Shapes_Number = 5;

  // - - Entités

  // - - - Fleuve

Const River_Width = 32;

  // - - Objets

  // - - - Stations

Const Station_Overfill_Timer = 20;
      Station_Overfill_Passengers_Number = 6;

  // - - - Lignes

Const Lines_Maximum_Number_Stations = 20;
      Lines_Maximum_Number_Trains = 4;

  // - - - Trains

Const Train_Maximum_Vehicles_Number = 3;
      Train_Maximum_Speed = 80;
      Train_Acceleration_Time = 3;
      Train_Speed_Constant : Real = Train_Maximum_Speed / Train_Acceleration_Time;
      Vehicle_Size : Type_Coordinates = (X :  32; Y :  24;);
      Vehicle_Maximum_Passengers_Number = 6;

  // - - Ressources

  // - - - Images

Const Path_Ressources =  'Resources/';
      Path_Images =  Path_Ressources + 'Images/';
      Path_Image_Station_Circle =   Path_Images + 'Station_Circle.png';
      Path_Image_Station_Square =   Path_Images + 'Station_Square.png';
      Path_Image_Station_Triangle =   Path_Images + 'Station_Triangle.png';
      Path_Image_Station_Pentagon =   Path_Images + 'Station_Pentagon.png';
      Path_Image_Station_Lozenge =   Path_Images + 'Station_Lozenge.png';
      Path_Image_Passenger_Circle =   Path_Images + 'Passenger_Circle.png';
      Path_Image_Passenger_Square =   Path_Images + 'Passenger_Square.png';
      Path_Image_Passenger_Triangle =   Path_Images + 'Passenger_Triangle.png';
      Path_Image_Passenger_Pentagon =   Path_Images + 'Passenger_Pentagon.png';
      Path_Image_Passenger_Lozenge =   Path_Images + 'Passenger_Lozenge.png';
      Path_Image_People = Path_Images + 'People.png';
      Path_Image_Clock = Path_Images + 'Clock.png';
      Path_Image_Button_Play = Path_Images + 'Play.png';
      Path_Image_Button_Pause = Path_Images + 'Pause.png';
      Path_Image_Button_Locomotive = Path_Images + 'Locomotive.png';
      Path_Image_Button_Wagon = Path_Images + 'Wagon.png';
      Path_Image_Button_Tunnel = Path_Images + 'Tunnel.png';
      Path_Image_Button_Restart = Path_Images + 'Restart.png';
      Path_Image_Button_Sound_Off = Path_Images + 'Sound_Off.png';
      Path_Image_Button_Sound_On = Path_Images + 'Sound_On.png';
      Path_Image_Button_Quit = Path_Images + 'Quit.png';

  // - - - Polices

Const Path_Fonts = Path_Ressources + 'Fonts/';
      Path_Font =   Path_Fonts + '/TitilliumWeb-Regular.ttf';
      Path_Font_Bold = Path_Fonts + '/TitilliumWeb-Bold.ttf';

  // - - - Son

Const Path_Sounds = Path_Ressources + 'Sounds/';
      Path_Sounds_Music = Path_Sounds + 'Sound.wav';

Implementation

End.
