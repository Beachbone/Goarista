unit configuration;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, ExtCtrls, SysUtils;

type
  TStringArray= array of string;
  TStringArray2d= array of array of string;
  TIntArray= array of integer;
  TIntArray2D= array of array of integer;
  TSingleArray= array of single;

  TConfiguration = record
    main_dish: integer;
    cash: single;
    cost: TSingleArray;

    dishes: TStringArray;
    ingredients: TStringArray;
    assignment: TIntArray2D;

  end;
var

 config: TConfiguration;

implementation

procedure setConfiguration();
  begin
    // Definieren der benötigten Array Größen

    setlength(config.dishes, 5);
    setlength(config.ingredients, 17);
    setlength(config.cost, 17);
    setlength(config.assignment, 5);      // 5 Komplettgerichte gibt es gesamt
    setlength(config.assignment[0],3);    //Gehacktes           3 Zutaten
    setlength(config.assignment[1],5);    //Schlachtplatte      5 Zutaten
    setlength(config.assignment[2],3);    //Schnitzel           3 Zutaten
    setlength(config.assignment[3],2);    //Bratwurst           2 Zutaten
    setlength(config.assignment[4],2);    //ChilliSinCarne      2 Zutaten

    //Belegen der einzelnen Variablen und Arrays
    config.main_dish := 0;
    config.cash := 0;
    config.dishes := ['Gehacktes'; 'Schlachtplatte', 'Schnitzel', 'Bratwurst',
                     'Chilli'];
    config.ingredients := ['Jaeger', 'Sauerkraut', 'pBroetchen', 'Brot',
                       '1xLeberwurst', '2xLeberwurst', '1xBlutwurst',
                       '1xBlutwurst', '1xSchwartenmagen','2xSchwartenmagen',
                       '1xWellfleisch', '2xWellfleisch',
                       'Zwiebeln', 'Chilli', 'pBratwurst', 'Schnitzel', 'Gehacktes'];
    config.cost:= [0.5,0.5,0.5,0.5,1.5,3.0,1.5,3.0,1.5,3.0,2.0,4.0,0.5,7.0,2.0,7.0,4.5];
    config.assignment[0] := [0,2,16];
    config.assignment[1] := [1,2,4,6,8,10];
    config.assignment[2] := [0,2,15];
    config.assignment[3] := [2,14];
    config.assignment[4] := [2,13];

  end;

end.

