{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{																			   }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

unit Frm_Feriados;

interface

uses
  Windows, Messages, SysUtils, Variants,
  Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    btnBuscar: TButton;
    Label1: TLabel;
    cboWebService: TComboBox;
    Label2: TLabel;
    edtAno: TEdit;
    edtUF: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edtCidade: TEdit;
    mmResultado: TMemo;
    Label5: TLabel;
    edtToken: TEdit;
    Label6: TLabel;
    edtArquivo: TEdit;
    Button1: TButton;
    procedure btnBuscarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure BuscaEfetuadaFeriado(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

uses
  ACBrFeriado;

{$R *.dfm}

procedure TForm1.BuscaEfetuadaFeriado(Sender: TObject);
var
  Feriados: TACBrFeriado;
  ListaFeriados: TStringList;
  i: Integer;
  Evento: TACBrFeriadoEvento;
  sDiaSemana: String;
  sTipo: String;
  sLegislacao: String;
  sLink: String;
begin
  Feriados := TACBrFeriado(Sender);

  if (Feriados.Eventos.Count > 0) then
  begin
    ListaFeriados := TStringList.Create;
    try
      for i := 0 to Feriados.Eventos.Count - 1 do
      begin
        Evento := Feriados.Eventos.Objects[i];
        if not(Evento.Tipo in [ftNenhum, ftDiaConvencional]) then
        begin
          sDiaSemana := FormatDateTime(', ddd,', Evento.Data);

          case Evento.Tipo of
            ftNacional:    sTipo := '(Feriado Nacional)';
            ftEstadual:    sTipo := '(Feriado Estadual)';
            ftMunicipal:   sTipo := '(Feriado Municipal)';
            ftFacultativo: sTipo := '(Ponto Facultativo)';
          end;
          sLegislacao := '';
          if (Evento.Legislacao <> '') then
            sLegislacao := 'Legisla��o: '+ Evento.Legislacao;
          sLink := '';
          if (Evento.Link <> '') then
            sLink := '('+ Evento.Link + ')';
          ListaFeriados.Add(DateToStr(Evento.Data) + ' ' +
                            sDiaSemana + ' ' +
                            Evento.Nome + ' ' +
                            sTipo + ' ' +
                            Evento.Descricao + ' ' +
                            sLegislacao + ' ' +
                            sLink);
        end;
      end;
      ListaFeriados.Insert(0, 'Lista de Feriados:');
      mmResultado.Lines.Text := ListaFeriados.Text;
    finally
      ListaFeriados.Free;
    end;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    OpenDialog.Title := 'Procurar arquivo de feriados e eventos';
    if (edtArquivo.Text <> '') then
      OpenDialog.InitialDir := ExtractFilePath(edtArquivo.Text)
    else
      OpenDialog.InitialDir := ExtractFilePath(ParamStr(0));
    OpenDialog.Filter := 'Arquivo JSON|*.json';
    OpenDialog.DefaultExt := 'json';
    if (OpenDialog.Execute) then
      edtArquivo.Text := OpenDialog.FileName;
  finally
    OpenDialog.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Caminho: String;
begin
  Caminho := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'ACBrFeriadoEventos.json';
  if (FileExists(Caminho)) then
    edtArquivo.Text := Caminho;
  edtAno.Text := FormatDateTime('yyyy', Now);
end;

procedure TForm1.btnBuscarClick(Sender: TObject);
var
  Feriados: TACBrFeriado;
begin
  mmResultado.Clear;

  Feriados := TACBrFeriado.Create(nil);
  try
    Feriados.OnBuscaEfetuada := BuscaEfetuadaFeriado;

    case cboWebService.ItemIndex of
      0:
      begin
        Feriados.WebService := wsfCalendario;
        Feriados.Token := edtToken.Text;
      end;
      1:
      begin
        Feriados.WebService := wsfJSON;
        Feriados.PathArquivo := edtArquivo.Text;
      end;
    end;

    Feriados.Buscar(StrToIntDef(edtAno.Text, 0), edtUF.Text, edtCidade.Text);
  finally
    Feriados.Free;
  end;
end;

end.
