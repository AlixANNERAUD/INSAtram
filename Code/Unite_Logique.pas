Unit Unite_Logique;

Interface

Uses Unite_Type, Unite_Affichage;

Procedure Creer_Station(var Station : Type_Station);

Implementation

Procedure Creer_Station(var Station : Type_Station);
begin
    Station.Forme = Carre;

    Station.Coordonnees.X = 400;
    Station.Coordonnees.Y = 600;

    Charger_Image_Station(Station);

    


end;


End.