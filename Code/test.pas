
Program Test;

Type Tableau = array Of integer;

Var T : Tableau;
    i : Byte;

Begin

SetLength(T, 10);


writeln('taille du tableau : ', length(T));
T[0] := 1;
T[1] := 2;
T[2] := 3;
T[3] := 4;
T[4] := 5;
T[5] := 6;
T[6] := 7;
T[7] := 8;
T[8] := 9;
T[9] := 10;

for i := low(T) to high(T) do
    writeln(T[i]);

SetLength(T, 5);

T[4] := T[9];

writeln('taille du tableau : ', length(T));
for i := low(T) to high(T) do
    writeln(T[i]);

End.
