{*******************************************************************************}
{ Projeto: ACBrMonitor                                                          }
{  Executavel multiplataforma que faz uso do conjunto de componentes ACBr para  }
{ criar uma interface de comunicação com equipamentos de automacao comercial.   }
{                                                                               }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida                }
{                                                                               }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr     }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr       }
{                                                                               }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la  }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela   }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério)  }
{ qualquer versão posterior.                                                    }
{                                                                               }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM    }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU       }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor }
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)               }
{                                                                               }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto }
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,   }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.           }
{ Você também pode obter uma copia da licença em:                               }
{ http://www.opensource.org/licenses/gpl-license.php                            }
{                                                                               }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br }
{        Rua Cel.Aureliano de Camargo, 963 - Tatuí - SP - 18270-170             }
{                                                                               }
{*******************************************************************************}
{$I ACBr.inc}
unit DoACBreSocialUnit;

interface

uses
  Classes, SysUtils, ACBrUtil.Base, ACBrUtil.FilesIO, ACBrUtil.Strings,
  ACBreSocial, ACBrMonitorConfig,
  ACBrMonitorConsts, CmdUnit, pcesConversaoeSocial, DoACBrDFeUnit,
  ACBrLibResposta, ACBrLibeSocialRespostas, ACBrLibeSocialConsts,
  ACBreSocialEventos;

type

{ TACBrObjetoeSocial }

TACBrObjetoeSocial = class(TACBrObjetoDFe)
private
  fACBreSocial: TACBreSocial;
public
  constructor Create(AConfig: TMonitorConfig; ACBreSocial: TACBreSocial); reintroduce;
  procedure Executar(ACmd: TACBrCmd); override;

  property ACBreSocial: TACBreSocial read fACBreSocial;
end;

{ TACBrCarregareSocial }

TACBrCarregareSocial = class(TACBrCarregarDFe)
protected
  procedure CarregarDFePath( const AValue: String ); override;
  procedure CarregarDFeXML( const AValue: String ); override;
  function ValidarDFe( const AValue: String ): Boolean; override;

public
  constructor Create(AACBreSocial: TACBreSocial; AXMLorFile: String ); reintroduce;
end;

{ TMetodoCriarEventoeSocial}

TMetodoCriarEventoeSocial = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoEnviareSocial}

TMetodoEnviareSocial = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoCriarEnviareSocial}

TMetodoCriarEnviareSocial = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoConsultareSocial}

TMetodoConsultareSocial = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoCarregarXMLEventoeSocial}

TMetodoCarregarXMLEventoeSocial = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoLimpareSocial}

TMetodoLimpareSocial = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoSetIDEmpregador}

TMetodoSetIDEmpregador = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoSetIDTransmissor}

TMetodoSetIDTransmissor = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoSetTipoEmpregador}

TMetodoSetTipoEmpregador = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoSetVersaoDF}

TMetodoSetVersaoDF = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoConsultaIdentificadoresEventosEmpregador }

TMetodoConsultaIdentificadoresEventosEmpregador = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoConsultaIdentificadoresEventosTabela }

TMetodoConsultaIdentificadoresEventosTabela = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoConsultaIdentificadoresEventosTrabalhador }

TMetodoConsultaIdentificadoresEventosTrabalhador = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoDownloadEventos }

TMetodoDownloadEventos = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoValidareSocial }

TMetodoValidareSocial = class(TACBrMetodo)
public
  procedure Executar; override;
end;

implementation

uses
  DoACBrUnit, Forms, typinfo, ACBrLibConfig;

{ TMetodoSetTipoEmpregador }

procedure TMetodoSetTipoEmpregador.Executar;
var
  nTipoEmpregador: integer;
begin
  nTipoEmpregador := StrToIntDef(fpCmd.Params(0),0);

  with TACBrObjetoeSocial(fpObjetoDono) do
  begin
    with MonitorConfig.DFE.ESocial do
      TipoEmpregador := GetEnumName( TypeInfo(TEmpregador), Integer(nTipoEmpregador) );

    MonitorConfig.SalvarArquivo;
  end;
end;

{ TMetodoSetVersaoDF }

{ Params: 0 - String contendo versão do Layout:
"02_04_01", "02_04_02", "02_05_00" ou "S01_00_00"
}
procedure TMetodoSetVersaoDF.Executar;
var
  eVersao: TVersaoeSocial;
  AVersao: String;
begin
  AVersao := fpCmd.Params(0);
  eVersao := StrToVersaoeSocialEX(AVersao);

  with TACBrObjetoeSocial(fpObjetoDono) do
  begin
    with MonitorConfig.DFE.WebService do
    begin
      VersaoeSocial := VersaoeSocialToStrEX(eVersao);
    end;

    MonitorConfig.SalvarArquivo;
  end;
end;

{ TMetodoDownloadEventos }

procedure TMetodoDownloadEventos.Executar;
var
  AIdEmpregador: String;
  AId: String;
  ANrRecibo: String;
  Resp : TConsultaEventos;
begin
  AIdEmpregador := fpCmd.Params(0);
  AId := fpCmd.Params(1);
  ANrRecibo := fpCmd.Params(2);

  with TACBrObjetoeSocial(fpObjetoDono) do
  begin
    if ( (EstaVazio(AIdEmpregador)) ) then
      raise Exception.Create(ACBrStr(SErroeSocialConsulta));

    ACBreSocial.Eventos.Clear;
    if ACBreSocial.DownloadEventos(AIdEmpregador, AID, ANrRecibo) then
    begin
      Resp := TConsultaEventos.Create(TpResp, codUTF8);
      try
        Resp.Processar(ACBreSocial);
        fpCmd.Resposta := Resp.Gerar;
      finally
        Resp.Free;
      end;
    end;

  end;
end;

{ TMetodoConsultaIdentificadoresEventosTrabalhador }

procedure TMetodoConsultaIdentificadoresEventosTrabalhador.Executar;
var
  AIdEmpregador: String;
  ACPFTrabalhador: String;
  ADataInicial, ADataFinal: TDateTime;
  Resp : TConsultaTotEventos;

begin
  AIdEmpregador := fpCmd.Params(0);
  ACPFTrabalhador := fpCmd.Params(1);
  ADataInicial := StrToDate(fpCmd.Params(2));
  ADataFinal := StrToDate(fpCmd.Params(3));

  with TACBrObjetoeSocial(fpObjetoDono) do
  begin
    if ( (EstaVazio(AIdEmpregador)) or ( EstaVazio(ACPFTrabalhador))
       or ( ADataInicial <= 0 )  or ( ADataFinal <= 0 ) ) then
      raise Exception.Create(ACBrStr(SErroeSocialConsulta));

    ACBreSocial.Eventos.Clear;
    if ACBreSocial.ConsultaIdentificadoresEventosTrabalhador(AIdEmpregador,
                       ACPFTrabalhador, ADataInicial, ADataFinal) then
    begin
      Resp := TConsultaTotEventos.Create(TpResp, codUTF8);
      try
        Resp.Processar(ACBreSocial);
        fpCmd.Resposta := Resp.Gerar;
      finally
        Resp.Free;
      end;

    end;

  end;
end;

{ TMetodoConsultaIdentificadoresEventosTabela }

procedure TMetodoConsultaIdentificadoresEventosTabela.Executar;
var
  AIdEmpregador: String;
  ATpEvento: Integer;
  AChave: String;
  ADataInicial, ADataFinal: TDateTime;
  Resp: TConsultaTotEventos;
begin
  AIdEmpregador := fpCmd.Params(0);
  ATpEvento := StrToIntDef(fpCmd.Params(1),0);
  AChave :=  fpCmd.Params(2);
  ADataInicial := StrToDateTime(fpCmd.Params(3));
  ADataFinal := StrToDate(fpCmd.Params(4));

  with TACBrObjetoeSocial(fpObjetoDono) do
  begin
    if ( (EstaVazio(AIdEmpregador)) or ( EstaVazio(AChave))
       or ( ADataInicial <= 0 )  or ( ADataFinal <= 0 ) ) then
      raise Exception.Create(ACBrStr(SErroeSocialConsulta));

    ACBreSocial.Eventos.Clear;
    if ACBreSocial.ConsultaIdentificadoresEventosTabela(AIdEmpregador,
                       TTipoEvento(ATpEvento), AChave, ADataInicial, ADataFinal) then
    begin
      Resp := TConsultaTotEventos.Create(TpResp, codUTF8);
      try
        Resp.Processar(ACBreSocial);
        fpCmd.Resposta := Resp.Gerar;
      finally
        Resp.Free;
      end;

    end;

  end;
end;

{ TMetodoConsultaIdentificadoresEventosEmpregador }

procedure TMetodoConsultaIdentificadoresEventosEmpregador.Executar;
var
  AIdEmpregador: String;
  APerApur: TDateTime;
  ATpEvento: Integer;
  Resp: TConsultaTotEventos;
begin
  AIdEmpregador := fpCmd.Params(0);
  ATpEvento := StrToIntDef(fpCmd.Params(1),0);
  APerApur := StrToDate( fpCmd.Params(2));

  with TACBrObjetoeSocial(fpObjetoDono) do
  begin
    if ((APerApur <= 0) or (EstaVazio(AIdEmpregador))) then
      raise Exception.Create(ACBrStr(SErroeSocialConsulta));

    ACBreSocial.Eventos.Clear;
    if ACBreSocial.ConsultaIdentificadoresEventosEmpregador(AIdEmpregador,
                       TTipoEvento(ATpEvento), APerApur) then
    begin
      Resp := TConsultaTotEventos.Create(TpResp, codUTF8);
      try
        Resp.Processar(ACBreSocial);
        fpCmd.Resposta := Resp.Gerar;
      finally
        Resp.Free;
      end;

    end;

  end;
end;

{ TACBrCarregareSocial }

procedure TACBrCarregareSocial.CarregarDFePath(const AValue: String);
begin
  if not ( TACBreSocial(FpACBrDFe).Eventos.LoadFromFile( AValue ) ) then
    raise Exception.Create(ACBrStr( Format(SErroeSocialAbrir, [AValue]) ) );
end;

procedure TACBrCarregareSocial.CarregarDFeXML(const AValue: String);
begin
  if not ( TACBreSocial(FpACBrDFe).Eventos.LoadFromString( AValue ) ) then
    raise Exception.Create(ACBrStr(SErroeSocialCarregar) );
end;

function TACBrCarregareSocial.ValidarDFe(const AValue: String): Boolean;
begin
  Result := False;
  if ( TACBreSocial(FpACBrDFe).Eventos.Count > 0 ) then
    Result:= True;

  if EstaVazio( FPathDFe )then
    FPathDFe := PathWithDelim(TACBreSocial(FpACBrDFe).Configuracoes.Arquivos.PathSalvar)
                + AValue;

end;

constructor TACBrCarregareSocial.Create(AACBreSocial: TACBreSocial;
  AXMLorFile: String);
begin
  inherited Create(AACBreSocial, AXMLorFile);
end;

{ TMetodoCarregarXMLEventoeSocial }

{ Params: 0 - pathXML - Uma String com pathXML ou XML completo
}
procedure TMetodoCarregarXMLEventoeSocial.Executar;
var
  APathorXML: String;
  CargaDFe: TACBrCarregareSocial;
begin
  APathorXML := fpCmd.Params(0);
  with TACBrObjetoeSocial(fpObjetoDono) do
  begin
    CargaDFe := TACBrCarregareSocial.Create(ACBreSocial , APathorXML);
    try
      fpCmd.Resposta := ACBrStr( Format(SMsgeSocialEventoAdicionado,[APathorXML]) )
    finally
      CargaDFe.Free;
    end;

  end;

end;

{ TMetodoConsultareSocial }

{ Params: 0 - Protocolo - Uma String com protocolo eSocial
}
procedure TMetodoConsultareSocial.Executar;
var
  AProtocolo: String;
  Resp: TConsulta;
begin
  AProtocolo := fpCmd.Params(0);

  with TACBrObjetoeSocial(fpObjetoDono) do
  begin
    ACBreSocial.Eventos.Clear;
    if ACBreSocial.Consultar(AProtocolo) then
    begin
      Resp := TConsulta.Create(TpResp, codUTF8);
      try
        Resp.Processar(ACBreSocial);
        fpCmd.Resposta := Resp.Gerar;
      finally
        Resp.Free;
      end;

    end;

  end;

end;

{ TMetodoCriarEnviareSocial }

{ Params: 0 - IniFile - Uma String com um Path completo arquivo .ini eSocial
                         ou Uma String com conteúdo txt do eSocial
          1 - ( Grupo: 1- Iniciais/Tabelas 2- Nao Periodicos 3- Periódicos )
}

procedure TMetodoCriarEnviareSocial.Executar;
var
  AIniFile, AGrupo, ArqeSocial, Resp : String;
  ASalvar : Boolean;
  iEvento : Integer;
  RespEnvio : TEnvioResposta;
begin
  AIniFile := fpCmd.Params(0);
  AGrupo := fpCmd.Params(1);

  if not FileExists(AIniFile) then
    raise Exception.Create(ACBrStr( Format(SErroeSocialAbrir, [AIniFile]) ));

  with TACBrObjetoeSocial(fpObjetoDono) do
  begin
    ACBreSocial.Eventos.LoadFromIni(AIniFile);

    ASalvar := ACBreSocial.Configuracoes.Geral.Salvar;
    if not ASalvar then
    begin
      ForceDirectories(PathWithDelim(ExtractFilePath(Application.ExeName)) + CPathLogs);
      ACBreSocial.Configuracoes.Arquivos.PathSalvar :=
        PathWithDelim(ExtractFilePath(Application.ExeName)) + CPathLogs;
    end;

    iEvento:= ACBreSocial.Eventos.Gerados.Count - 1;
    ArqeSocial:= ACBreSocial.Eventos.Gerados.Items[ iEvento ].PathNome + CExtensaoXML ;

    if not FileExists(ArqeSocial) then
      raise Exception.Create(ACBrStr( Format(SErroeSocialAbrir, [ArqeSocial]) ));

    Resp := ArqeSocial + sLineBreak + ACBrStr( Format(SMsgeSocialEventoAdicionado,
         [TipoEventoToStr(ACBreSocial.Eventos.Gerados.Items[iEvento].TipoEvento)]) ) +
         sLineBreak;

    fpCmd.Resposta := Resp;

    ACBreSocial.Enviar(TeSocialGrupo( StrToIntDef(AGrupo,1) ));
    Sleep(3000);

    RespEnvio := TEnvioResposta.Create(TpResp, codUTF8);
    try
      RespEnvio.Processar(ACBreSocial);
      fpCmd.Resposta := fpCmd.Resposta + RespEnvio.Gerar;
    finally
      RespEnvio.Free;
    end;

    ACBreSocial.Eventos.Clear;

  end;

end;

{ TMetodoEnviareSocial }

{ Params: 0 - Grupo: 1- Iniciais/Tabelas 2- Nao Periodicos 3- Periódicos
          1 - Assina: 1 para assinar XML
}

procedure TMetodoEnviareSocial.Executar;
var
  AGrupo: String;
  AAssina: Boolean;
  Resp: TEnvioResposta;
begin
  AGrupo := fpCmd.Params(0);
  AAssina := StrToBoolDef(fpCmd.Params(1), False);

  with TACBrObjetoeSocial(fpObjetoDono) do
  begin
    if (ACBreSocial.Eventos.Count <= 0) then
      raise Exception.Create(ACBrStr( SErroeSocialNenhumEvento ));

    if (AAssina) then
      ACBreSocial.AssinarEventos;

    ACBreSocial.Enviar(TeSocialGrupo( StrToIntDef(AGrupo,1) ));
    Sleep(3000);

    Resp := TEnvioResposta.Create(TpResp, codUTF8);
    try
      Resp.Processar(ACBreSocial);
      fpCmd.Resposta := Resp.Gerar;
    finally
      Resp.Free;
    end;

    ACBreSocial.Eventos.Clear;
  end;

end;


{ TMetodoCriarEventoeSocial }

{ Params: 0 - IniFile - Uma String com um Path completo arquivo .ini MDFe
                         ou Uma String com conteúdo txt do MDFe
          1 - RetornaXML: 1 para Retornar XML Gerado na Resposta
}

procedure TMetodoCriarEventoeSocial.Executar;
var
  ARetornaXML, ASalvar: Boolean;
  AIni, Resp, ArqeSocial: String;
  SL: TStringList;
  iEvento: Integer;
begin
  AIni := fpCmd.Params(0);
  ARetornaXML := StrToBoolDef(fpCmd.Params(1), False);

  if not FileExists(AIni) then
      raise Exception.Create(ACBrStr( Format(SErroeSocialAbrir, [AIni]) ));

  with TACBrObjetoeSocial(fpObjetoDono) do
  begin
    ACBreSocial.Eventos.LoadFromIni(AIni);

    ASalvar := ACBreSocial.Configuracoes.Geral.Salvar;
    if not ASalvar then
    begin
      ForceDirectories(PathWithDelim(ExtractFilePath(Application.ExeName)) + CPathLogs);
      ACBreSocial.Configuracoes.Arquivos.PathSalvar :=
        PathWithDelim(ExtractFilePath(Application.ExeName)) + CPathLogs;
    end;

    iEvento:= ACBreSocial.Eventos.Gerados.Count - 1;
    ArqeSocial:= ACBreSocial.Eventos.Gerados.Items[ iEvento ].PathNome + CExtensaoXML ;

    if not FileExists(ArqeSocial) then
      raise Exception.Create(ACBrStr( Format(SErroeSocialAbrir, [ArqeSocial]) ));

    Resp := ArqeSocial + sLineBreak + ACBrStr( Format(SMsgeSocialEventoAdicionado,
         [TipoEventoToStr(ACBreSocial.Eventos.Gerados.Items[iEvento].TipoEvento)]) );

    if ARetornaXML then
    begin
      SL := TStringList.Create;
      try
        SL.LoadFromFile(ArqeSocial);
        Resp := Resp + sLineBreak + SL.Text;
      finally
        SL.Free;
      end;
    end;
    fpCmd.Resposta := Resp;

  end;

end;

{ TMetodoLimpareSocial }

procedure TMetodoLimpareSocial.Executar;
begin
  with TACBrObjetoeSocial(fpObjetoDono) do
  begin
    ACBreSocial.Eventos.Clear;
    fpCmd.Resposta := SMsgeSocialLimparLista;
  end;

end;

{ TMetodoSetIDEmpregador }

{ Params: 0 - idEmpregador: String
}
procedure TMetodoSetIDEmpregador.Executar;
var
  nIDEmpregador: String;
begin
  nIDEmpregador := fpCmd.Params(0);

  if EstaVazio(nIDEmpregador) then
    raise Exception.Create('Valor Nulo.');

  with TACBrObjetoeSocial(fpObjetoDono) do
  begin
    with MonitorConfig.DFE.ESocial do
      IdEmpregador := nIDEmpregador;

    MonitorConfig.SalvarArquivo;
  end;

end;

{ TMetodoSetIDTransmissor }

{ Params: 0 - idTransmissor: String
}
procedure TMetodoSetIDTransmissor.Executar;
var
  nIDTransmissor: String;
begin
  nIDTransmissor := fpCmd.Params(0);

  if EstaVazio(nIDTransmissor) then
    raise Exception.Create('Valor Nulo.');

  with TACBrObjetoeSocial(fpObjetoDono) do
  begin
    with MonitorConfig.DFE.ESocial do
      IDTransmissor := nIDTransmissor;

    MonitorConfig.SalvarArquivo;
  end;

end;

{ TMetodoValidareSocial }
{ Params: 0 - XML - Uma String com um Path completo XML NFe
}

procedure TMetodoValidareSocial.Executar;
var
  CargaDFe: TACBrCarregareSocial;
  AXML: String;
begin
  AXML:= fpCmd.Params(0);

  with TACBrObjetoeSocial(fpObjetoDono) do
  begin
    ACBreSocial.Eventos.Clear;
    CargaDFe := TACBrCarregareSocial.Create(ACBreSocial, AXML);
    try
      ACBreSocial.Eventos.Validar;
    finally
      CargaDFe.Free;
    end;
  end;
end;

{ TACBrObjetoeSocial }

constructor TACBrObjetoeSocial.Create(AConfig: TMonitorConfig;
  ACBreSocial: TACBreSocial);
begin
  inherited Create(AConfig);

  fACBreSocial := ACBreSocial;

  ListaDeMetodos.Add(CMetodoCriarEventoeSocial);
  ListaDeMetodos.Add(CMetodoEnviareSocial);
  ListaDeMetodos.Add(CMetodoCriarEnviareSocial);
  ListaDeMetodos.Add(CMetodoConsultareSocial);
  ListaDeMetodos.Add(CMetodoLimpareSocial);
  ListaDeMetodos.Add(CMetodoCarregarXMLEventoeSocial);
  ListaDeMetodos.Add(CMetodoSetIDEmpregadoreSocial);
  ListaDeMetodos.Add(CMetodoSetIDTransmissoresocial);
  ListaDeMetodos.Add(CMetodoConsultaIdentEventosEmpreg);
  ListaDeMetodos.Add(CMetodoConsultaIdentEventosTabela);
  ListaDeMetodos.Add(CMetodoConsultaIdentEventosTrab);
  ListaDeMetodos.Add(CMetodoDownloadEventos);
  ListaDeMetodos.Add(CMetodoSetTipoEmpregadoreSocial);
  ListaDeMetodos.Add(CMetodoSetVersaoDF);
  ListaDeMetodos.Add(CMetodoValidareSocial);

  //DoACBrUnit
  ListaDeMetodos.Add(CMetodoObterCertificados);

end;

procedure TACBrObjetoeSocial.Executar(ACmd: TACBrCmd);
var
  AMetodoClass: TACBrMetodoClass;
  CmdNum: Integer;
  Ametodo: TACBrMetodo;
  AACBrUnit: TACBrObjetoACBr;
begin
  inherited Executar(ACmd);

  with fACBreSocial.Configuracoes.Geral do
  begin
    if EstaVazio(IdEmpregador) or EstaVazio(IdTransmissor) then
      raise Exception.Create(ACBrStr( SErroIDEmpregadorTransmissor ));
  end;

  CmdNum := ListaDeMetodos.IndexOf(LowerCase(ACmd.Metodo));
  AMetodoClass := Nil;

  case CmdNum of
    0  : AMetodoClass := TMetodoCriarEventoeSocial;
    1  : AmetodoClass := TMetodoEnviareSocial;
    2  : AMetodoClass := TMetodoCriarEnviareSocial;
    3  : AMetodoClass := TMetodoConsultareSocial;
    4  : AMetodoClass := TMetodoLimpareSocial;
    5  : AMetodoClass := TMetodoCarregarXMLEventoeSocial;
    6  : AMetodoClass := TMetodoSetIDEmpregador;
    7  : AMetodoClass := TMetodoSetIDTransmissor;
    8  : AMetodoClass := TMetodoConsultaIdentificadoresEventosEmpregador;
    9  : AMetodoClass := TMetodoConsultaIdentificadoresEventosTabela;
    10 : AMetodoClass := TMetodoConsultaIdentificadoresEventosTrabalhador;
    11 : AMetodoClass := TMetodoDownloadEventos;
    12 : AMetodoClass := TMetodoSetTipoEmpregador;
    13 : AMetodoClass := TMetodoSetVersaoDF;
    14 : AMetodoClass := TMetodoValidareSocial;

    else
      begin
        AACBrUnit := TACBrObjetoACBr.Create(Nil); //Instancia DoACBrUnit para validar métodos padrão para todos os objetos
        try
          AACBrUnit.Executar(ACmd);
        finally
          AACBrUnit.Free;
        end;

      end;

  end;

  if Assigned(AMetodoClass) then
  begin
    Ametodo := AMetodoClass.Create(ACmd, Self);
    try
      Ametodo.Executar;
    finally
      Ametodo.Free;
    end;
  end;

end;

end.

