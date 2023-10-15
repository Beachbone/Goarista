unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Sysutils,
  StrUtils, ComCtrls, Types, SQLite3Conn, Printers, PrintersDlgs;

type
    TUsedColors = record
       bg_inactive : TColor;
       bg_active : TColor;
       font_inactive : TColor;
       font_active : TColor;
    end;


    TConfiguration = record
    bonCount: integer;
    main_dish: integer;
    cash: array of single;
    cost: array of single;
    color_group: array of Integer;
    color: array of TUsedColors;
    dishes: array of String;
    ingredients: array of String;
    assignment: array of array of Integer;
    printed: boolean;
    minPrice: array of single;
    additionalDish: TStringList;
    end;

  { TForm1 }

  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Memo_Ausgabe: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel4: TPanel;
    pBratwurst: TPanel;
    pgWellfleisch: TPanel;
    pKartoffelsalat: TPanel;
    pSchnitzel: TPanel;
    pgChillisinCarne: TPanel;
    pBroetchen: TPanel;
    pBrot: TPanel;
    p1xLeberwurst: TPanel;
    p2xLeberwurst: TPanel;
    p1xBlutwurst: TPanel;
    p2xBlutwurst: TPanel;
    p1xSchwartenmagen: TPanel;
    p2xSchwartenmagen: TPanel;
    Panel2: TPanel;
    p1xWellfleisch: TPanel;
    p2xWellfleisch: TPanel;
    pGehacktes: TPanel;
    pZwiebeln: TPanel;
    pChilli: TPanel;
    pgEinzeln: TPanel;
    Panel3: TPanel;
    pgGehacktes: TPanel;
    pgSchlachtplatte: TPanel;
    pJaeger: TPanel;
    pSauerkraut: TPanel;
    pgSchnitzel: TPanel;
    pgBratwurst: TPanel;
    SQLite3Connection1: TSQLite3Connection;
    TSGerichte: TTabSheet;
    TSEinzeln: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Label2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label3Click(Sender: TObject);
    procedure p1xBlutwurstClick(Sender: TObject);
    procedure p1xLeberwurstClick(Sender: TObject);
    procedure p1xSchwartenmagenClick(Sender: TObject);
    procedure p1xWellfleischClick(Sender: TObject);
    procedure p2xBlutwurstClick(Sender: TObject);
    procedure p2xLeberwurstClick(Sender: TObject);
    procedure p2xSchwartenmagenClick(Sender: TObject);
    procedure p2xWellfleischClick(Sender: TObject);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseLeave(Sender: TObject);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel2MouseLeave(Sender: TObject);
    procedure Panel2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel3Click(Sender: TObject);
    procedure Panel3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel3MouseLeave(Sender: TObject);
    procedure Panel3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pBratwurstClick(Sender: TObject);
    procedure pBroetchenClick(Sender: TObject);
    procedure pBrotClick(Sender: TObject);
    procedure pChilliClick(Sender: TObject);
    procedure pgBratwurstClick(Sender: TObject);
    procedure pgChillisinCarneClick(Sender: TObject);
    procedure pGehacktesClick(Sender: TObject);
    procedure pgEinzelnClick(Sender: TObject);
    procedure pgGehacktesClick(Sender: TObject);
    procedure pgSchlachtplatteClick(Sender: TObject);
    procedure pgSchnitzelClick(Sender: TObject);
    procedure pgWellfleischClick(Sender: TObject);
    procedure pJaegerClick(Sender: TObject);
    procedure pKartoffelsalatClick(Sender: TObject);
    procedure pSauerkrautClick(Sender: TObject);
    procedure pSchnitzelClick(Sender: TObject);
    procedure pZwiebelnClick(Sender: TObject);
  private
    procedure changePanel(p: TPanel; tc: TColor=clDefault);
    procedure fillMemo(memo: TMemo);
    procedure FillMemoadditionalDish(memo: TMemo);
    procedure prereset(select: integer);
    procedure preselect(arr_select: integer);
    procedure resetall();
    procedure addDish;
    procedure setIngredients(select: integer);

  public

  end;

var
  Form1: TForm1;
  config: TConfiguration;


implementation

{$R *.lfm}

{ TForm1 }

procedure loadData();
var
  strList: TStringList;

begin
  strList := TStringList.create;
  try
    strList.LoadFromFile('goarista.txt');

  except
    strList.Add('0');
    strList.SaveToFile('goarista.txt');
  end;

  config.bonCount := StrToInt(strList[0]);
  strList.free;

end;

procedure saveData();
var
  strList: TStringList;

begin
  strList := TStringList.create;
  strList.Add (IntToStr(Config.bonCount));
  strList.SaveToFile('goarista.txt');

end;

procedure setConfiguration();
  begin
    loaddata();

    // Definieren der benötigten Array Größen


    setlength(config.dishes, 5);
    setlength(config.cash, 2);

    setlength(config.cost, 18);
    setlength(config.ingredients, 18);
    setlength(config.color_group,18);    // Zuordnung zur jeweiligen Farbgruppe

    setlength(config.color, 5);          // 5 Farbgruppen

    setlength(config.assignment, 6);      // 5 Komplettgerichte gibt es gesamt
    setlength(config.assignment[0],3);    //Gehacktes           3 Zutaten
    setlength(config.assignment[1],5);    //Schlachtplatte      5 Zutaten
    setlength(config.assignment[2],3);    //Schnitzel           3 Zutaten
    setlength(config.assignment[3],2);    //Bratwurst           2 Zutaten
    setlength(config.assignment[4],2);    //ChilliSinCarne      2 Zutaten
    setlength(Config.assignment[5],3);    //Wellfleisch         3 Zutaten

    setlength(Config.minPrice, 17);       // Mindestpreise ???

    //Belegen der einzelnen Variablen und Arrays
    config.main_dish := 0;
    config.cash[0] := 0;
    config.cash[1] := 0;
    config.dishes := ['Gehacktes', 'Schlachtplatte', 'Schnitzel', 'Bratwurst',
                     'Chilli', 'Wellfleisch'];
    config.ingredients := ['pJaeger', 'pSauerkraut', 'pBroetchen', 'pBrot',
                       'p1xLeberwurst', 'p2xLeberwurst',
                       'p1xBlutwurst', 'p2xBlutwurst', 'p1xSchwartenmagen',
                       'p2xSchwartenmagen', 'p1xWellfleisch', 'p2xWellfleisch',
                       'pZwiebeln', 'pChilli', 'pBratwurst', 'pSchnitzel',
                       'pGehacktes','pKartoffelsalat'];
    config.cost:= [0.50,0.50,0.50,0.50,1.50,3.00,1.50,3.00,1.50,3.00,2.00,4.00,0.50,7.00,2.00,7.00,4.50,0.50];
    config.assignment[0] := [0,2,16];
    config.assignment[1] := [1,2,4,6,8,10];
    config.assignment[2] := [0,2,15];
    config.assignment[3] := [2,14];
    config.assignment[4] := [2,13];
    config.assignment[5] := [1,2,10];
    config.color_group := [1,1,2,2,3,3,3,3,3,3,3,3,1,4,4,4,4,2];

    // Mindestpreise
    config.minPrice := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

    // Gruppe 0 - Grundfarben
    config.color[0].bg_inactive := $0093BCBA;
    config.color[0].bg_active := $0099E0F3;
    config.color[0].font_inactive := clDefault;
    config.color[0].font_active := clWhite;

    // Gruppe 1 Soßen und Beilagen
    config.color[1].bg_inactive := $0083BCBA;
    config.color[1].bg_active := $001A3DC7;
    config.color[1].font_inactive := clDefault;
    config.color[1].font_active := clWhite;

    // Gruppe 2 Brot und Broetchen
    config.color[2].bg_inactive := $0033B1E4;
    config.color[2].bg_active := $001A3DC7;
    config.color[2].font_inactive := clDefault;
    config.color[2].font_active := clWhite;

    // Gruppe 3 Hauptgerichte
    config.color[3].bg_inactive := $004779A6;
    config.color[3].bg_active := $001A3DC7;
    config.color[3].font_inactive := clDefault;
    config.color[3].font_active := clWhite;

    // Gruppe 4 Schlachtplatte
    config.color[4].bg_inactive := $00214284;
    config.color[4].bg_active := $001A3DC7;
    config.color[4].font_inactive := clDefault;
    config.color[4].font_active := clWhite;


    // Stringlist zum Zwischenspeichern des ersten Gerichtes

    config.additionalDish := TstringList.Create;

    // Drucker Setup
    printer.SetPrinter('Kasse');
    config.printed:= False;
  end;


procedure TForm1.changePanel(p:TPanel; tc:TColor = clDefault);


begin
  if p.BevelOuter = bvRaised then
     begin
     p.BevelOuter:= bvLowered;
     p.Color := config.color[0].bg_active;
     p.Font.color := config.color[0].font_active;
     if PageControl1.ActivePageIndex = 0 then
        begin
          config.main_dish:= 1;
        end
     end
   else
     begin
     p.BevelOuter:= bvRaised;
     p.Color:= config.color[0].bg_inactive ;
     p.Font.Color:= config.color[0].font_inactive;
     if PageControl1.ActivePageIndex = 0 then
        config.main_dish:= 0;
     end;

end;

procedure TForm1.preSelect(arr_select:integer);
var
  PanelNumber: integer;
  LComponent:TComponent;

begin

  for PanelNumber in config.assignment[arr_select] do
    begin
    LComponent:=FindComponent(config.ingredients[PanelNumber]);
    if assigned(LComponent) then
       begin
            TPanel(LComponent).BevelOuter := bvLowered;
            TPanel(LComponent).Color := config.color[config.color_group[PAnelNumber]].bg_active;
            TPanel(LComponent).Font.Color := config.color[config.color_group[PAnelNumber]].font_active;

       end;
    end;

end;

procedure TForm1.preReset(select: integer);
var
  PanelNumber: Integer;
  LComponent:TComponent;

begin

  for PanelNumber in config.assignment[select] do
    begin
    LComponent:=FindComponent(config.ingredients[PanelNumber]);
    if Not assigned(LComponent) then
       break;
    if TPanel(LComponent).BevelOuter = bvRaised then
       break;
    TPanel(LComponent).BevelOuter := bvRaised;
    TPanel(LComponent).Color := config.color[config.color_group[PanelNumber]].bg_inactive;
    TPanel(LComponent).Font.Color := config.color[config.color_group[PanelNumber]].font_inactive;
    end;
end;

procedure TForm1.setIngredients(select: integer);
var
    LComponent:TComponent;

begin
  LComponent:=FindComponent(config.ingredients[select]);
  if Not assigned(LComponent) then
     exit;
  if TPanel(LComponent).BevelOuter = bvLowered then
    begin
      TPanel(LComponent).BevelOuter := bvRaised;
      TPanel(LComponent).Color := config.color[config.color_group[select]].bg_inactive;
      TPanel(LComponent).Font.Color := config.color[config.color_group[select]].font_inactive;
    end
   else
    begin
    TPanel(LComponent).BevelOuter := bvLowered;
    TPanel(LComponent).Color := config.color[config.color_group[select]].bg_active;
    TPanel(LComponent).Font.Color := config.color[config.color_group[select]].font_active;
    end;
end;

procedure TForm1.resetAll();
var
  PanelName: String;
  LComponent: TComponent;
  i: Integer;
begin
  for i := 0 to high (config.ingredients) do
    begin
    PanelName := config.ingredients[i];
    LComponent:=FindComponent(PanelName);
    if Not assigned(LComponent) then
       continue;
    if TPanel(LComponent).BevelOuter = bvRaised then
       continue;
    TPanel(LComponent).BevelOuter := bvRaised;
    TPanel(LComponent).Color := config.color[config.color_group[i]].bg_inactive;
    TPanel(LComponent).Font.Color := config.color[config.color_group[i]].font_inactive;
  end;
  for i := 0 to high (config.dishes) do
      begin
      PanelName := 'pg'+config.dishes[i];
      LComponent:=FindComponent(PanelName);
      if Not assigned(LComponent) then
         continue;
      if TPanel(LComponent).BevelOuter = bvRaised then
         continue;
      TPanel(LComponent).BevelOuter := bvRaised;
      TPanel(LComponent).Color := config.color[config.color_group[0]].bg_inactive;
      TPanel(LComponent).Font.Color := config.color[config.color_group[0]].font_inactive;
  end;


end;

procedure TForm1.fillMemo(memo: TMemo);
var
  a,l,k, PanelName: String;
  LComponent: TComponent;
  i,m : Integer;
  j : Single;

begin
  config.cash[0] := 0;
  a:='';
  memo.Lines.Clear;
  memo.Lines.Add('^..^       Schlachtfest');
  memo.Lines.Add('(oo)          Kappel ');
  memo.Lines.Add(' `´       Sängerverinigung');
  memo.Lines.Add('------------------------------');
  memo.Lines.Add('');
  memo.Lines.Add('');
  memo.Lines.Add('Tisch Nr.');
  memo.Lines.Add('------------------------------');

  if config.cash[1] >0 then
     fillMemoadditionalDish(memo);

  for i := high (config.ingredients) downto 0 do
    begin
    PanelName := config.ingredients[i];
    LComponent:= FindComponent(PanelName);
    if Not assigned(LComponent) then
       continue;
    if TPanel(LComponent).BevelOuter = bvLowered then
       begin
         a := TPanel(LComponent).caption;
         j := config.cost[i];
//         delete(a,1,1);
         config.cash[0] := config.cash[0] + j;
//         l := FloatToStr(j)+' Eur';
//         m := 29 - length(l) - length(a);
//         a := a + dupestring('.',m) + l;

         memo.Lines.Add(a);
       end;
    end;
    memo.Lines.Add('');
    memo.Lines.Add('Einzelpreis:......');
    k := Format('%5.2f Euro',[config.cash[0]]);
    memo.Lines.Add(Format(' %29.10S ', [k]));

    memo.Lines.Add('');
    memo.Lines.Add('Gesamtsumme:........');
    k := Format('%5.2f Euro',[config.cash[0]+config.cash[1]]);

    memo.Lines.Add(Format(' %29.10S ', [k]));
end;

procedure TForm1.FillMemoadditionalDish(memo: TMemo);
var
  i: Integer;

begin
  for i :=0 to config.additionalDish.count-1 do
    begin
      memo.Lines.add(config.additionalDish[i]);
    end;
end;

procedure TForm1.addDish();
var
  i: Integer;
  a: String;
begin
    config.cash[1] := config.cash[1]+config.cash[0];

    config.additionalDish.clear;
    for i := 8 to Memo_Ausgabe.Lines.Count-3 do     // Start bei 8, ohne den Kopf des Bon
    begin
      config.additionalDish.Add(Memo_Ausgabe.Lines[i]);
    end;

    config.additionalDish.Add('');
    config.additionalDish.Add(dupestring('-',29));
    config.additionalDish.Add('');

end;


procedure TForm1.Panel2MouseDown(Sender: TObject; Button: TMouseButton;          // Neuer Bon
  Shift: TShiftState; X, Y: Integer);
begin
  changePanel(Panel2);

  if PageControl1.Visible AND not config.printed then
     if MessageDlg('Frage', 'Bon ist noch nicht ausgedruckt! Auswahl verwerfen und einen neuen Bon starten??',
                            mtConfirmation,[mbYes, mbNo],0) = mrNo  then
                              begin
                              changePanel(Panel2);
                              exit;

                              end
                              else
                              changePanel(Panel2);



   config.bonCount := config.bonCount +1;
   Label4.Caption := 'Count '+IntToStr(config.bonCount);
   pageControl1.Visible:= true;
   config.main_dish:=0;
   resetall();
   PageControl1.ActivePageIndex:=0;
   config.additionalDish.Clear;
   config.cash[1] :=0;
   fillMemo(Memo_Ausgabe);
   config.printed:=False;

end;

procedure TForm1.Panel2MouseLeave(Sender: TObject);
begin
   if Panel2.BevelOuter = bvLowered then changePanel(Panel2);
end;

procedure TForm1.Panel2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
        changePanel(Panel2);
end;

procedure TForm1.Panel3Click(Sender: TObject);
begin

end;

procedure TForm1.Panel3MouseDown(Sender: TObject; Button: TMouseButton;           // Drucken
  Shift: TShiftState; X, Y: Integer);

  const
    LEFTMARGIN = 1;
  var
    i,j, YPos, LineHeight, VerticalMargin: Integer;
    zeile: String;
  begin
    changePanel(Panel3);
    if config.printed then exit;
    Printer.Copies:=2;

    with Printer do
    try
      BeginDoc;
      Canvas.Font.Name := 'Courier New';
      Canvas.Font.Size := 10;
      Canvas.Font.Bold := true;
      Canvas.Font.Color := clBlack;
      LineHeight := Round(1.2 * Abs(Canvas.TextHeight('I')));
      VerticalMargin :=  3 * LineHeight;
      // There we go
      YPos := VerticalMargin;
      j :=  Memo_Ausgabe.Lines.Count-1;
      for i := 0 to j do
        begin
        zeile := Memo_Ausgabe.Lines[i];
         if i = Memo_Ausgabe.Lines.Count-1 then
            canvas.Font.Size:= 25 ;
            zeile := dupestring(' ',3) + trim(zeile);
        Canvas.TextOut(LEFTMARGIN, YPos, zeile);
        YPos := YPos + LineHeight;
        end;
      Canvas.Font.Size := 10;
      YPos := YPos + VerticalMargin;
      zeile := IntToStr(config.bonCount) + dupestring(' ',5)+ DateTimeToStr(Now);

      Canvas.TextOut(LEFTMARGIN, YPos, zeile);
    finally
      EndDoc;
      config.printed:=true;
      config.cash[1] :=0;
      config.additionalDish.Clear;
      config.main_dish:=0;
      resetall();
      config.additionalDish.Clear;
      PageControl1.ActivePageIndex:=0;
      fillMemo(Memo_Ausgabe);
    end;

end;

procedure TForm1.Panel3MouseLeave(Sender: TObject);
begin
     if Panel3.BevelOuter = bvLowered then changePanel(Panel3);

end;

procedure TForm1.Panel3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TForm1.Panel4MouseDown(Sender: TObject; Button: TMouseButton;          // Zusätzlicher Bon
  Shift: TShiftState; X, Y: Integer);
begin
     changePanel(Panel4);
       if not PageControl1.Visible then
          begin
          changePanel(Panel4);
          exit;
          end;
     addDish();
     config.bonCount := config.bonCount +1;
     Label4.Caption := 'Count '+IntToStr(config.bonCount);
     config.main_dish:=0;
     resetall();
     PageControl1.ActivePageIndex:=0;
     fillMemo(Memo_Ausgabe);
     config.printed:=False;
     changePanel(Panel4);


end;

procedure TForm1.pBratwurstClick(Sender: TObject);
begin
    setIngredients(14);
  fillMemo(Memo_Ausgabe);
end;

procedure TForm1.pBroetchenClick(Sender: TObject);
begin
    setIngredients(2);
  fillMemo(Memo_Ausgabe);
end;

procedure TForm1.pBrotClick(Sender: TObject);
begin
    setIngredients(3);
  fillMemo(Memo_Ausgabe);
end;

procedure TForm1.pChilliClick(Sender: TObject);
begin
    setIngredients(13);
  fillMemo(Memo_Ausgabe);
end;

procedure TForm1.pgBratwurstClick(Sender: TObject);
begin
  if (config.main_dish = 0) or (pgBratwurst.BevelOuter = bvLowered)then
     begin
       changePanel(pgBratwurst, clWhite);
     if config.main_dish >0 then
       begin
       PageControl1.ActivePageIndex:=1;
       preselect(3);
       end
     else
       prereset(3);
     end;
     fillMemo(Memo_Ausgabe);
end;

procedure TForm1.pgChillisinCarneClick(Sender: TObject);
begin
  if (config.main_dish = 0) or (pgChillisinCarne.BevelOuter = bvLowered) then
     begin
       changePanel(pgChillisinCarne, clWhite);
     if config.main_dish >0 then
       begin
       PageControl1.ActivePageIndex:=1;
       preselect(4);
       end
     else
       prereset(4);
     end;
        fillMemo(Memo_Ausgabe);

end;

procedure TForm1.pGehacktesClick(Sender: TObject);
begin
    setIngredients(16);
  fillMemo(Memo_Ausgabe);
end;

procedure TForm1.pgEinzelnClick(Sender: TObject);
begin
  if (config.main_dish = 0) or (pgEinzeln.BevelOuter = bvLowered)then
     begin
       changePanel(pgEinzeln, clWhite);
     if config.main_dish >0 then
       begin
       PageControl1.ActivePageIndex:=1;

       end
     else
       resetall();
     end;
     fillMemo(Memo_Ausgabe);
end;

procedure TForm1.pgGehacktesClick(Sender: TObject);

begin
  if (config.main_dish = 0) or (pgGehacktes.BevelOuter = bvLowered) then
     begin
       changePanel(pgGehacktes, clWhite);
     if config.main_dish >0 then
       begin
       PageControl1.ActivePageIndex:=1;
       preselect(0);
       end
     else
       prereset(0);
     end;
     fillMemo(Memo_Ausgabe);
end;

procedure TForm1.pgSchlachtplatteClick(Sender: TObject);
begin
  if (config.main_dish = 0) or (pgSchlachtplatte.BevelOuter = bvLowered) then
     begin
       changePanel(pgSchlachtplatte, clWhite);
       if config.main_dish >0 then
         begin
         PageControl1.ActivePageIndex:=1;
         preselect(1);
         end
       else
         prereset(1);
     end;
     fillMemo(Memo_Ausgabe);
end;

procedure TForm1.pgSchnitzelClick(Sender: TObject);
begin
  if (config.main_dish = 0) or (pgSchnitzel.BevelOuter = bvLowered) then
     begin
       changePanel(pgSchnitzel, clWhite);
       if config.main_dish >0 then
         begin
         PageControl1.ActivePageIndex:=1;
         preselect(2);
         end
       else
         prereset(2);
     end;
     fillMemo(Memo_Ausgabe);

end;

procedure TForm1.pgWellfleischClick(Sender: TObject);
begin

if (config.main_dish = 0) or (pgWellfleisch.BevelOuter = bvLowered) then
     begin
       changePanel(pgWellfleisch, clWhite);
       if config.main_dish >0 then
         begin
         PageControl1.ActivePageIndex:=1;
         preselect(5);
         end
       else
         prereset(5);
     end;
     fillMemo(Memo_Ausgabe);

end;

procedure TForm1.pJaegerClick(Sender: TObject);
begin
  setIngredients(0);
  fillMemo(Memo_Ausgabe);
end;

procedure TForm1.pKartoffelsalatClick(Sender: TObject);
begin
    setIngredients(17);
  fillMemo(Memo_Ausgabe);
end;

procedure TForm1.pSauerkrautClick(Sender: TObject);
begin
  setIngredients(1);
  fillMemo(Memo_Ausgabe);
end;

procedure TForm1.pSchnitzelClick(Sender: TObject);
begin
    setIngredients(15);
  fillMemo(Memo_Ausgabe);
end;

procedure TForm1.pZwiebelnClick(Sender: TObject);
begin
    setIngredients(12);
  fillMemo(Memo_Ausgabe);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     setConfiguration();
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     saveData();
     Config.additionalDish.free;
end;

procedure TForm1.Label2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  changePanel(Panel2);
end;

procedure TForm1.Label2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  changePanel(Panel2);
end;

procedure TForm1.Label3Click(Sender: TObject);
begin

end;

procedure TForm1.p1xBlutwurstClick(Sender: TObject);
begin
    if p2xBlutwurst.BevelOuter = bvLowered then setIngredients(7);
    setIngredients(6);
  fillMemo(Memo_Ausgabe);
end;

procedure TForm1.p1xLeberwurstClick(Sender: TObject);
begin
    if p2xLeberwurst.BevelOuter = bvLowered then setIngredients(5);
    setIngredients(4);
    fillMemo(Memo_Ausgabe);
end;

procedure TForm1.p1xSchwartenmagenClick(Sender: TObject);
begin

      if p2xSchwartenmagen.BevelOuter = bvLowered then setIngredients(9);
    setIngredients(8);
  fillMemo(Memo_Ausgabe);
end;

procedure TForm1.p1xWellfleischClick(Sender: TObject);
begin
      if p2xWellfleisch.BevelOuter = bvLowered then setIngredients(11);

    setIngredients(10);
  fillMemo(Memo_Ausgabe);
end;

procedure TForm1.p2xBlutwurstClick(Sender: TObject);
begin
      if p1xBlutwurst.BevelOuter = bvLowered then setIngredients(6);
    setIngredients(7);
  fillMemo(Memo_Ausgabe);
end;

procedure TForm1.p2xLeberwurstClick(Sender: TObject);
begin
      if p1xleberwurst.BevelOuter = bvLowered then setIngredients(4);
  setIngredients(5);
  fillMemo(Memo_Ausgabe);
end;

procedure TForm1.p2xSchwartenmagenClick(Sender: TObject);
begin
      if p1xSchwartenmagen.BevelOuter = bvLowered then setIngredients(8);
    setIngredients(9);
  fillMemo(Memo_Ausgabe);
end;

procedure TForm1.p2xWellfleischClick(Sender: TObject);
begin
      if p1xWellfleisch.BevelOuter = bvLowered then setIngredients(10);
    setIngredients(11);
  fillMemo(Memo_Ausgabe);
end;

procedure TForm1.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  changePanel(Panel1);
  resetAll();
  PageControl1.ActivePageIndex:=0;
end;

procedure TForm1.Panel1MouseLeave(Sender: TObject);
begin
     if Panel1.BevelOuter = bvLowered then changePanel(Panel1);

end;

procedure TForm1.Panel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ChangePanel(Panel1);
end;

end.

