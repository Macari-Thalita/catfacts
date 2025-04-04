﻿unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.StdCtrls, REST.Types, REST.Client, Data.Bind.Components, System.JSON,
  Data.Bind.ObjectScope;

type
  TfrmCats = class(TForm)
    pnCatFacts: TPanel;
    imgCat: TImage;
    btCatFact: TButton;
    RESTClientCat: TRESTClient;
    RESTRequestCat: TRESTRequest;
    RESTResponseCat: TRESTResponse;
    function GetCatFact: string;
    function GetRandomCatBreed: string;
    procedure btCatFactClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
   frmCats: TfrmCats;

implementation

{$R *.dfm}


procedure TfrmCats.btCatFactClick(Sender: TObject);
var
   Fact, Breed: string;
begin
   Fact  := GetCatFact;
   Breed := GetRandomCatBreed;

   ShowMessage(
      '🐾 Random breed: ' + sLineBreak + Breed + sLineBreak + sLineBreak +
      '📖 Random fact:  ' + sLineBreak + Fact
);
end;

procedure TfrmCats.FormCreate(Sender: TObject);
begin
   Randomize;
end;

function TfrmCats.GetCatFact: string;
var
   JsonResp: TJSONObject;
begin
   RESTClientCat.BaseURL := 'https://catfact.ninja/fact';
   RESTRequestCat.Method := rmGET;
   RESTRequestCat.Execute;

   JsonResp := TJSONObject.ParseJSONValue(RESTResponseCat.Content) as TJSONObject;
   try
     if Assigned(JsonResp) then
        Result := JsonResp.GetValue<string>('fact')
     else
        Result := 'Deu ruim.';
   finally
      JsonResp.Free;
   end;
end;

function TfrmCats.GetRandomCatBreed: string;
var
   JsonResp: TJSONObject;
   BreedArray: TJSONArray;
   BreedObj: TJSONObject;
   RandomPage: Integer;
begin
   RandomPage := Random(98) + 1;

   RESTClientCat.BaseURL := 'https://catfact.ninja/breeds?limit=1&page=' + RandomPage.ToString;
   RESTRequestCat.Method := rmGET;
   RESTRequestCat.Execute;

   JsonResp := TJSONObject.ParseJSONValue(RESTResponseCat.Content) as TJSONObject;
   try
      if (Assigned(JsonResp)) then
      begin
         BreedArray := JsonResp.GetValue<TJSONArray>('data');
         BreedObj := BreedArray.Items[0] as TJSONObject;

         Result   := BreedObj.GetValue<string>('breed');
      end
      else
         Result := 'Deu ruim.';
   finally
      JsonResp.Free;
   end;
end;

end.




