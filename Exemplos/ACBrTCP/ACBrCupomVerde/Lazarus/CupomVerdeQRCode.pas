unit CupomVerdeQRCode;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons;

type

  { TfrQRCodeCupomVerde }

  TfrQRCodeCupomVerde = class(TForm)
    btFluxoFinalizar: TBitBtn;
    btFluxoImprimirReduzido: TBitBtn;
    btFluxoImprimirCompleto: TBitBtn;
    Image1: TImage;
    imgQRCode: TImage;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure btFluxoImprimirCompletoClick(Sender: TObject);
    procedure btFluxoFinalizarClick(Sender: TObject);
    procedure btFluxoImprimirReduzidoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FQRCode: String;

  public
    property QRCode: String read FQRCode write FQRCode;
  end;

var
  frQRCodeCupomVerde: TfrQRCodeCupomVerde;

implementation

uses
  ACBrDelphiZXingQRCode, ACBrImage, Principal;

{$R *.lfm}

{ TfrQRCodeCupomVerde }

procedure TfrQRCodeCupomVerde.FormShow(Sender: TObject);
begin
  PintarQRCode(QRCode, imgQRCode.Picture.Bitmap, qrUTF8BOM);
end;

procedure TfrQRCodeCupomVerde.btFluxoFinalizarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrQRCodeCupomVerde.btFluxoImprimirReduzidoClick(Sender: TObject);
begin
  if Assigned(frPrincipal) then
    frPrincipal.ImprimirCupomVerdeNFCeAtual;
end;

procedure TfrQRCodeCupomVerde.btFluxoImprimirCompletoClick(Sender: TObject);
begin
  if Assigned(frPrincipal) then
    frPrincipal.ImprimirNFCeAtual;
end;

end.

