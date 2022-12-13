// Cette unité contient toutes les fonctions et procédures qui gèrent le sons.

Unit Unit_Sounds;

Interface

Uses Unit_Types, Unit_Constants, sdl_mixer;

Procedure Sounds_Load(Var Game : Type_Game);
Procedure Sounds_Unload(Var Game : Type_Game);

Procedure Sounds_Set_Volume(Volume : Byte);

Procedure Sounds_Play(Var Sound : pMIX_MUSIC);

Implementation


Procedure Sounds_Load(Var Game : Type_Game);
Begin
  If MIX_OpenAudio(Sounds_Sampling_Rate, Sounds_Format, Sounds_Channels, Sounds_Chunck_Size) = -1 Then
    HALT;

    // Chargement des sons en mémoire.
    Game.Ressources.Music := Mix_LoadMUS(Path_Sounds_Music);


End;

Procedure Sounds_Unload(Var Game : Type_Game);
Begin
    MIX_FREEMUSIC(Game.Ressources.Music);
    Mix_CloseAudio();

End;

Procedure Sounds_Play(Var Sound : pMIX_MUSIC);
Begin
  Mix_PlayMusic(Sound, -1);
End;

Procedure Sounds_Set_Volume(Volume : Byte);
Begin
  Mix_VolumeMusic(Volume);
End;

End.
