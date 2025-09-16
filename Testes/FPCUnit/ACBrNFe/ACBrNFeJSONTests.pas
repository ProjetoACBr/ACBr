unit ACBrNFeJSONTests;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  SysUtils,
  ACBrTests.Util,
  ACBrNFe.JSONReader,
  ACBrNFe,
  ACBrNFeNotasFiscais,
  ACBrNFe.Classes,
  ACBrNFe.EnvEvento,
  pcnConversao,
  pcnConversaoNFe,
  ACBrDFe.Conversao,
  ACBrUtil.Strings,
  ACBrJSON;

const
  CAMINHO_XML_DFE = '..\..\..\..\Recursos\Arquivos-Comparacao\NFeNFCe\XML';
  CAMINHO_INI_DFE = '..\..\..\..\Recursos\Arquivos-Comparacao\NFeNFCe\INI';
  CAMINHO_JSON_DFE = '..\..\..\..\Recursos\Arquivos-Comparacao\NFeNFCe\JSON';
  CAMINHO_INVALIDOOUEMBRANCO = '..\..\..\..\Recursos\Arquivos-Comparacao\InvalidoOuEmBranco';
  CAMINHO_XML_EVENTOS = '..\..\..\..\Recursos\Arquivos-Comparacao\Eventos\XML';
  CAMINHO_JSON_EVENTOS = '..\..\..\..\Recursos\Arquivos-Comparacao\Eventos\JSON';
  CAMINHO_INI_EVENTOS = '..\..\..\..\Recursos\Arquivos-Comparacao\Eventos\INI';

type
  TTipoArquivo = (taXML, taINI, taJSON);

  { TNFeJSONVazioTest }

  TNFeJSONVazioTest = class(TTestCase)
  private
    FACBrNFe: TACBrNFe;
    FOK: Boolean;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure StringVazia;
    procedure JSONEmBranco;
    procedure JSONSomenteElementoNFe;
    procedure JSONElementoNFeInfNFe;
    procedure CaminhoApontandoArquivoInvalido;
    procedure CaminhoApontandoArquivoJSONValido;
    procedure JSONInvalido;
  end;

  { TEventoNFeJSONVazioTest }

  TEventoNFeJSONVazioTest = class(TTestCase)
  private
    FACBrNFe: TACBrNFe;
    FOK: Boolean;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure StringVazia;
    procedure JSONEmBranco;
    procedure JSONSomenteElementoEnvEvento;
    procedure JSONElementoEnvEvento_Evento;
    procedure CaminhoApontandoArquivoInvalido;
    procedure CaminhoApontandoArquivoJSONValido;
    procedure JSONInvalido;
  end;

  { TNFeComparer }

  TNFeComparer = class(TTestCase)
  private
    class procedure Compara_imposto(const AImpostoBase, AImpostoCompara: TImposto);
    class procedure Compara_prod(const AProdBase, AProdCompara: TProd);
    class procedure Compara_ICMS(const AICMSBase, AICMSCompara: TICMS);
    class procedure Compara_PIS(const APISBase, APISCompara: TPIS);
    class procedure Compara_PISST(const APISSTBase, APISSTCompara: TPISST);
    class procedure Compara_COFINS(const ACOFINSBase, ACOFINSCompara: TCOFINS);
    class procedure Compara_COFINSST(const ACOFINSSTBase, ACOFINSSTCompara: TCOFINSST);
    class procedure Compara_IPI(const AIPIBase, AIPICompara: TIPI);
    class procedure Compara_II(const AIIBase, AIICompara: TII);
    class procedure Compara_ISSQN(const AISSQNBase, AISSQNCompara: TISSQN);
    class procedure Compara_IS(const AISBase, AISCompara: TgIS);
    class procedure Compara_IBSCBS(const AIBSCBSBase, AIBSCBSCompara: TIBSCBS);
    class procedure Compara_gIBSCBS(const AIBSCBSBase, AIBSCBSCompara: TgIBSCBS);
    class procedure Compara_gIBSCBSMono(const AIBSCBSMonoBase, AIBSCBSMonoCompara: TgIBSCBSMono);
    class procedure Compara_gTransfCred(const ATransfCredBase, ATransfCredCompara: TgTransfCred);
    class procedure Compara_gCredPresIBSZFM(const ACredPresIBSZFMBase, ACredPresIBSZFMCompara: TCredPresIBSZFM);
  public
    class procedure Compara_Ide(const AIdeBase, AIdeCompara: TIde);
    class procedure Compara_emit(const AEmitBase, AEmitCompara: TEmit);
    class procedure Compara_avulsa(const AAvulsaBase, AAvulsaCompara: TAvulsa);
    class procedure Compara_dest(const ADestBase, ADestCompara: TDest);
    class procedure Compara_retirada(const ARetiradaBase, ARetiradaCompara: TRetirada);
    class procedure Compara_entrega(const AEntregaBase, AEntregaCompara: TEntrega);
    class procedure Compara_autXML(const AAutXMLBase, AAutXMLCompara: TautXMLCollection);
    class procedure Compara_det(const ADetBase, ADetCompara: TDetCollection);
    class procedure Compara_total(const ATotalBase, ATotalCompara: TTotal);
    class procedure Compara_transp(const ATranspBase, ATranspCompara: TTransp);
    class procedure Compara_cobr(const ACobrBase, ACobrCompara: TCobr);
    class procedure Compara_pag(const APagBase, APagCompara: TpagCollection);
    class procedure Compara_infAdic(const AInfAdicBase, AInfAdicCompara: TInfAdic);
  end;

  { TEventoNFeComparer }

  TEventoNFeComparer = class(TTestCase)
  public
    class procedure Compara_Evento(const AEventoBase, AEventoCompara: TInfEventoCollectionItem);
  end;

  { TNFeJSONSimetriaTest }

  TNFeJSONSimetriaTest = class(TTestCase)
  private
    FListaArquivos: TStringList;
    procedure ListaArquivosParaLer(const ATipoArquivo: TTipoArquivo);
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure LeituraEGeracaoJSON_DeveProduzirJSONEquivalente;
    procedure GeracaoELeituraJSON_DeveManterIntegridadeDosDadosNoComponente;
  end;

  { TNFeJSONEquivalenciaTest }

  TNFeJSONEquivalenciaTest = class(TTestCase)
  private
    FACBrNFeBase: TACBrNFe;
    FACBrNFeCompara: TACBrNFe;
    procedure ListaArquivosParaLer(const ATipo: TTipoArquivo;var AListaBase, AListaCompara: TStringList);
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure LeituraXMLEhJSON_DevePreencherAsMesmasPropriedades;
    procedure LeituraINIEhJSON_DevePreencherAsMesmasPropriedades;
  end;

  { TEventoNFeJSONEquivalenciaTest }

  TEventoNFeJSONEquivalenciaTest = class(TTestCase)
  private
    FACBrNFeBase: TACBrNFe;
    FACBrNFeCompara: TACBrNFe;
  public
    procedure SetUp; override;
    procedure TearDown; override;
    procedure ListaArquivosParaLer(const ATipo: TTipoArquivo;var AListaBase, AListaCompara: TStringList);
  published
    procedure LeituraXMLEhJSON_DevePreencherAsMesmasPropriedades;
    procedure LeituraINIEhJSON_DevePreencherAsMesmasPropriedades;
  end;

implementation

{ TNFeJSONVazioTest }

procedure TNFeJSONVazioTest.SetUp;
begin
  inherited SetUp;
  FACBrNFe := TACBrNFe.Create(nil);
end;

procedure TNFeJSONVazioTest.TearDown;
begin
  FACBrNFe.Free;
  inherited TearDown;
end;

procedure TNFeJSONVazioTest.StringVazia;
begin
  try
    FOK := False;
    FACBrNFe.NotasFiscais.Clear;
    FOK := FACBrNFe.NotasFiscais.LoadFromJSON('');
  except
    on E:Exception do
    begin
      Check(FOK = False, 'LoadFromJSON não devolveu false');
      Check(ACBrStr(E.Message) = 'String JSON informada não é válida', 'Exception devolvida difere da esperada: ' + E.Message);
      exit;
    end;
  end;
  Fail('Não levantou exceção ao passar string vazia');
end;

procedure TNFeJSONVazioTest.JSONEmBranco;
var
  s: String;
begin
  try
    FOK := False;
    FACBrNFe.NotasFiscais.Clear;
    FOK := FACBrNFe.NotasFiscais.LoadFromJSON('{}');
  except
    on E:Exception do
    begin
      s := E.MEssage;
      Check(FOK = False, 'LoadFromJSON não devolveu false');
      Check(ACBrStr(E.Message) = 'Objeto JSON incorreto. Chave "NFe" não encontrada', 'Exception devolvida difere da esperada: '+ E.Message);
    end;
  end;
end;

procedure TNFeJSONVazioTest.JSONSomenteElementoNFe;
begin
  try
    FOK := False;
    FACBrNFe.NotasFiscais.Clear;
    FOK := FACBrNFe.NotasFiscais.LoadFromJSON('{"NFe":{}}');
  except
    on E:Exception do
    begin
      Check(FOK = False, 'LoadFromJSON não devolveu false');
      Check(ACBrStr(E.Message) = 'Objeto JSON incorreto. Chave "infNFe" não encontrada', 'Exception devolvida difere da esperada: ' + E.Message);
    end;
  end;
end;

procedure TNFeJSONVazioTest.JSONElementoNFeInfNFe;
begin
  FOK := False;
  FACBrNFe.NotasFiscais.Clear;
  FOK := FACBrNFe.NotasFiscais.LoadFromJSON('{"NFe":{"infNFe":{}}}');
  Check(FOK, 'LoadFromJSON não devolveu true');
end;

procedure TNFeJSONVazioTest.CaminhoApontandoArquivoInvalido;
begin
  try
    FOK := False;
    FACBrNFe.NotasFiscais.Clear;
    FACBrNFe.NotasFiscais.LoadFromJSON(CAMINHO_INVALIDOOUEMBRANCO+'\ArquivoInvalido.txt');
  except
    on E:Exception do
    begin
      Check(ACBrStr(E.Message) = 'String JSON informada não é válida', 'Exception devolvida difere da esperada: ' + E.Message);
      exit;
    end;
  end;
  Fail('Não levantou exceção ao passar arquivo inválido');
end;

procedure TNFeJSONVazioTest.CaminhoApontandoArquivoJSONValido;
begin
  try
    FOK := False;
    FACBrNFe.NotasFiscais.Clear;
    FOK := FACBrNFe.NotasFiscais.LoadFromJSON(CAMINHO_INVALIDOOUEMBRANCO+'\NFe-EmBranco.json');
  except
    on E:Exception do
    begin
      Check(FOK, 'LoadFromJSON não devolveu True');
      Check(FACBrNFe.NotasFiscais.Count = 0, 'Lista de notas não esta vazia');
    end;
  end;
end;

procedure TNFeJSONVazioTest.JSONInvalido;
begin
  try
    FOK := False;
    FACBrNFe.NotasFiscais.Clear;
    FOK := FACBrNFe.NotasFiscais.LoadFromJSON('{":"}');
  except
    on E:Exception do
      Check(FOK = False, 'LoadFromJSON não devolveu false');
  end;
end;

{ TEventoNFeJSONVazioTest }

procedure TEventoNFeJSONVazioTest.SetUp;
begin
  inherited SetUp;
  FACBrNFe := TACBrNFe.Create(nil);
end;

procedure TEventoNFeJSONVazioTest.TearDown;
begin
  FACBrNFe.Free;
  inherited TearDown;
end;

procedure TEventoNFeJSONVazioTest.StringVazia;
begin
  try
    FOK := False;
    FACBrNFe.EventoNFe.Evento.Clear;
    FOK := FACBrNFe.EventoNFe.LerFromJSON('');
  except
    on E:Exception do
    begin
      Check(FOK = False, 'LerFromJSON não devolveu false');
      Check(FACBrNFe.EventoNFe.Evento.Count = 0, 'Lista de eventos não está vazia');
      Check(ACBrStr(E.Message) = 'String JSON informada não é válida', 'Exception devolvida difere da esperada: ' + E.Message);
      exit;
    end;
  end;
  Fail('Não levantou exceção ao passar string vazia');
end;

procedure TEventoNFeJSONVazioTest.JSONEmBranco;
begin
  try
    FOK := False;
    FACBrNFe.EventoNFe.Evento.Clear;
    FOK := FACBrNFe.EventoNFe.LerFromJSON('{}');
  except
    on E:Exception do
    begin
      Check(FOK = False, 'LerFromJSON não devolveu false');
      Check(FACBrNFe.EventoNFe.Evento.Count = 0, 'Lista de eventos não está vazia');
      Check(ACBrStr(E.Message) = 'Objeto JSON incorreto. Chave "envEvento" não encontrada', 'Exception devolvida difere da esperada: ' + E.Message);
    end;
  end;
end;

procedure TEventoNFeJSONVazioTest.JSONSomenteElementoEnvEvento;
begin
  try
    FOK := False;
    FACBrNFe.EventoNFe.Evento.Clear;
    FOK := FACBrNFe.EventoNFe.LerFromJSON('{"envEvento":{}}');
  except
    on E:Exception do
    begin
      Check(FOK = False, 'LerFromJSON não devolveu false');
      Check(FACBrNFe.EventoNFe.Evento.Count = 0, 'Lista de Eventos não está vazia');
      Check(ACBrStr(E.Message) = 'Objeto JSON incorreto. Chave "evento" não encontrada', 'Exception devolvida difere da esperada: ' + E.Message);
    end;
  end;
end;

procedure TEventoNFeJSONVazioTest.JSONElementoEnvEvento_Evento;
begin
  FOK := False;
  FACBrNFe.EventoNFe.Evento.Clear;
  FOK := FACBrNFe.EventoNFe.LerFromJSON('{"envEvento":{"evento":[{}]}}');
  Check(FOK, 'LerFromJSON não devolveu true');
end;

procedure TEventoNFeJSONVazioTest.CaminhoApontandoArquivoInvalido;
begin
  try
    FOK := False;
    FACBrNFe.EventoNFe.Evento.Clear;
    FOK := FACBrNFe.EventoNFe.LerFromJSON(CAMINHO_INVALIDOOUEMBRANCO+'\ArquivoInvalido.txt');
  except
    on E:Exception do
    begin
      Check(FOK = False, 'LerFromJSON não devolveu false');
      Check(FACBrNFe.EventoNFe.Evento.Count = 0, 'Lista de eventos não está vazia');
      Check(ACBrStr(E.Message) = 'String JSON informada não é válida', 'Exception devolvida difere da esperada: ' + E.Message);
      exit;
    end;
  end;
  Fail('Não levantou exceção ao passar arquivo inválido');
end;

procedure TEventoNFeJSONVazioTest.CaminhoApontandoArquivoJSONValido;
begin
  try
    FOK := False;
    FACBrNFe.EventoNFe.Evento.Clear;
    FOK := FACBrNFe.EventoNFe.LerFromJSON(CAMINHO_INVALIDOOUEMBRANCO+'\EventoEmBranco.json');
  except
    on E:Exception do
    begin
      Check(FOK, 'LerFromJSON não devolveu true');
      Check(FACBrNFe.EventoNFe.Evento.Count = 0, 'Lista de eventos esta vazia');
    end;
  end;
end;

procedure TEventoNFeJSONVazioTest.JSONInvalido;
begin
  try
    FOK := False;
    FACBrNFe.EventoNFe.Evento.Clear;
    FOK := FACBrNFe.EventoNFe.LerFromJSON('{":"}');
  except
    on E:Exception do
    begin
      Check(FOK = False, 'LerFromJSON não devolveu false');
      Check(FACBrNFe.EventoNFe.Evento.Count = 0, 'Lista de eventos não esta vazia');
    end;
  end;
end;

{ TNFeJSONSimetriaTest }

procedure TNFeJSONSimetriaTest.ListaArquivosParaLer(const ATipoArquivo: TTipoArquivo);
var
  SR: TSearchRec;
  lSRPath, lResultPath: String;
begin
  case ATipoArquivo of
    taXML:
      begin
        lResultPath := CAMINHO_XML_DFE;
        lSRPath := IncludeTrailingPathDelimiter(CAMINHO_XML_DFE) + '*.XML';
      end;
    taINI:
      begin
        lResultPath := CAMINHO_INI_DFE;
        lSRPath := IncludeTrailingPathDelimiter(CAMINHO_INI_DFE) + '*.INI';
      end;
    taJSON:
      begin
        lResultPath := CAMINHO_JSON_DFE;
        lSRPath := IncludeTrailingPathDelimiter(CAMINHO_JSON_DFE) + '*.JSON';
      end;
  end;

  FListaArquivos.Clear;
  if FindFirst(lSRPath, faAnyFile, SR) = 0 then
  begin
    try
      repeat
        if (SR.Attr and faDirectory) = 0 then
          FListaArquivos.Add(IncludeTrailingPathDelimiter(lResultPath) + SR.Name);
      until FindNext(SR) <> 0;
    finally
      FindClose(SR);
    end;
  end;
end;

procedure TNFeJSONSimetriaTest.SetUp;
begin
  inherited SetUp;
  FListaArquivos := TStringList.Create;
end;

procedure TNFeJSONSimetriaTest.TearDown;
begin
  FListaArquivos.Free;
  inherited TearDown;
end;

procedure TNFeJSONSimetriaTest.LeituraEGeracaoJSON_DeveProduzirJSONEquivalente;
var
  i: Integer;
  lJSONGerado: String;
  lJSONBase: TStringList;
  lJSONOriginal, lJSONComparacao: TACBrJSONObject;
  FACBrNFe: TACBrNFe;
begin
  FACBrNFe := TACBrNFe.Create(nil);
  try
    lJSONBase := TStringList.Create;
    try
      ListaArquivosParaLer(taJSON);
      for i := 0 to FListaArquivos.Count - 1 do
      begin
        lJSONBase.Clear;
        lJSONBase.LoadFromFile( FListaArquivos.Strings[i]);

        FACBrNFe.NotasFiscais.Clear;
        FACBrNFe.NotasFiscais.LoadFromJSON(lJSONBase.Text);
        lJSONGerado := FACBrNFe.NotasFiscais.GerarJSON;

        //Faço um Parse em objetos JSON para garantir normalização.
        lJSONOriginal := TACBrJSONObject.Parse(lJSONBase.Text);
        try
          lJSONComparacao := TACBrJSONObject.Parse(lJSONGerado);
          try
            CheckEquals(lJSONOriginal.ToJSON, lJSONComparacao.ToJSON, 'JSON gerado a partir de ' + FListaArquivos.Strings[i] + ' difere do original');
          finally
            lJSONComparacao.Free;
          end;
        finally
          lJSONOriginal.Free;
        end;
      end;
    finally
      lJSONBase.Free;
    end;
  finally
    FACBrNFe.Free;
  end;
end;

procedure TNFeJSONSimetriaTest.GeracaoELeituraJSON_DeveManterIntegridadeDosDadosNoComponente;
var
  FACBrNFeBase, FACBrNFeCompara: TACBrNFe;
  lNFeBase, lNFeCompara: TNFe;
  i: Integer;
  lJSONStr: String;
begin
  FACBrNFeBase := TACBrNFe.Create(nil);
  try
    FACBrNFeCompara := TACBrNFe.Create(nil);
    try
      ListaArquivosParaLer(taXML);
      for i := 0 to FListaArquivos.Count - 1 do
      begin
        //Carrego um XML para simular preenchimento das propriedades.
        FACBrNFeBase.NotasFiscais.Clear;
        FACBrNFeBase.NotasFiscais.LoadFromFile(FListaArquivos.Strings[i]);
        //Gero um JSON no componente com as propriedades preenchidas
        lJSONStr := FACBrNFeBase.NotasFiscais.GerarJSON;
        //Leio o JSON gerado
        FACBrNFeCompara.NotasFiscais.Clear;
        FACBrNFeCompara.NotasFiscais.LoadFromJSON(lJSONStr);
        lNFeBase := FACBrNFeBase.NotasFiscais[0].NFe;
        lNFeCompara := FACBrNFeCompara.NotasFiscais[0].NFe;

        try
          TNFeComparer.Compara_Ide(lNFeBase.Ide, lNFeCompara.Ide);
          TNFeComparer.Compara_emit(lNFeBase.Emit, lNFeCompara.Emit);
          TNFeComparer.Compara_avulsa(lNFeBase.Avulsa, lNFeCompara.Avulsa);
          TNFeComparer.Compara_dest(lNFeBase.Dest, lNFeCompara.Dest);
          TNFeComparer.Compara_retirada(lNFeBase.Retirada, lNFeCompara.Retirada);
          TNFeComparer.Compara_entrega(lNFeBase.Entrega, lNFeCompara.Entrega);
          TNFeComparer.Compara_autXML(lNFeBase.autXML, lNFeCompara.autXML);
          TNFeComparer.Compara_det(lNFeBase.Det, lNFeCompara.Det);
          TNFeComparer.Compara_total(lNFeBase.Total, lNFeCompara.Total);
          TNFeComparer.Compara_transp(lNFeBase.Transp, lNFeCompara.Transp);
          TNFeComparer.Compara_cobr(lNFeBase.Cobr, lNFeCompara.Cobr);
          TNFeComparer.Compara_pag(lNFeBase.pag, lNFeCompara.pag);
          TNFeComparer.Compara_infAdic(lNFeBase.InfAdic, lNFeCompara.InfAdic);
        except
          on E:Exception do
            Fail('JSON gerado a partir dos dados de ' + FListaArquivos.Strings[i] + ' não alimentou as propriedades corretamente: ' + sLineBreak + E.Message);
        end;
      end;
    finally
      FACBrNFeCompara.Free;
    end;
  finally
    FACBrNFeBase.Free;
  end;
end;

{ TNFeJSONEquivalenciaTest }

procedure TNFeJSONEquivalenciaTest.ListaArquivosParaLer(const ATipo: TTipoArquivo;var AListaBase, AListaCompara: TStringList);
var
  SR: TSearchRec;
  lSRPath, lResultPath: String;
begin
  case ATipo of
    taXML:
      begin
        lResultPath := CAMINHO_XML_DFE;
        lSRPath := IncludeTrailingPathDelimiter(CAMINHO_XML_DFE) + '*.XML';
      end;
    taINI:
      begin
        lResultPath := CAMINHO_INI_DFE;
        lSRPath := IncludeTrailingPathDelimiter(CAMINHO_INI_DFE) + '*.INI';
      end;
  end;

  //Lista base pode ser INI ou XML
  AListaBase.Clear;
  if FindFirst(lSRPath, faAnyFile, SR) = 0 then
  begin
    try
      repeat
        if (SR.Attr and faDirectory) = 0 then
          AListaBase.Add(IncludeTrailingPathDelimiter(lResultPath) + SR.Name);
      until FindNext(SR) <> 0;
    finally
      FindClose(SR);
    end;
  end;

  //Lista de comparação sempre será JSON
  AListaCompara.Clear;
  if FindFirst(IncludeTrailingPathDelimiter(CAMINHO_JSON_DFE) + '*.JSON', faAnyFile, SR) = 0 then
  begin
    try
      repeat
        if (SR.Attr and faDirectory) = 0 then
          AListaCompara.Add(IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(CAMINHO_JSON_DFE)) + SR.Name);
      until FindNext(SR) <> 0;
    finally
      FindClose(SR);
    end;
  end;
end;

procedure TNFeJSONEquivalenciaTest.SetUp;
begin
  inherited SetUp;
  FACBrNFeBase := TACBrNFe.Create(nil);
  FACBrNFeCompara := TACBrNFe.Create(nil);
end;

procedure TNFeJSONEquivalenciaTest.TearDown;
begin
  FACBrNFeBase.Free;
  FACBrNFeCompara.Free;
  inherited TearDown;
end;

procedure TNFeJSONEquivalenciaTest.LeituraXMLEhJSON_DevePreencherAsMesmasPropriedades;
var
  lListaBase, lListaCompara: TStringList;
  i, lIndiceJSON: Integer;
  lNFeBase, lNFeCompara: TNFe;
  lJSONAhProcurar: String;
begin
  lListaBase := TStringList.Create;
  try
    lListaCompara := TStringList.Create;
    try
      ListaArquivosParaLer(taXML, lListaBase, lListaCompara);

      if lListaBase.Count <> lListaCompara.Count then
      begin
        Fail('Falhou em carregar arquivos equivalentes para usar no teste');
        exit;
      end;

      for i := 0 to lListaBase.Count - 1 do
      begin
        //Carrego o XML para base
        FACBrNFeBase.NotasFiscais.Clear;
        FACBrNFeBase.NotasFiscais.LoadFromFile(lListaBase.Strings[i]);
        lNFeBase := FACBrNFeBase.NotasFiscais[0].NFe;

        //Carrego o JSON equivalente
        lJSONAhProcurar := StringReplace(lListaBase.Strings[i], '.XML', '.JSON', [rfReplaceAll]);
        lJSONAhProcurar := StringReplace(lJSONAhProcurar, '.xml', '.json', [rfReplaceAll]);
        lJSONAhProcurar := StringReplace(lJSONAhProcurar, 'XML', 'JSON', [rfReplaceAll]);
        lIndiceJSON := lListaCompara.IndexOf(lJSONAhProcurar);
        FACBrNFeCompara.NotasFiscais.Clear;
        FACBrNFeCompara.NotasFiscais.LoadFromJSON(lListaCompara.Strings[lIndiceJSON]);
        lNFeCompara := FACBrNFeCompara.NotasFiscais[0].NFe;

        try
          TNFeComparer.Compara_Ide(lNFeBase.Ide, lNFeCompara.Ide);
          TNFeComparer.Compara_emit(lNFeBase.Emit, lNFeCompara.Emit);
          TNFeComparer.Compara_avulsa(lNFeBase.Avulsa, lNFeCompara.Avulsa);
          TNFeComparer.Compara_dest(lNFeBase.Dest, lNFeCompara.Dest);
          TNFeComparer.Compara_retirada(lNFeBase.Retirada, lNFeCompara.Retirada);
          TNFeComparer.Compara_entrega(lNFeBase.Entrega, lNFeCompara.Entrega);
          TNFeComparer.Compara_autXML(lNFeBase.autXML, lNFeCompara.autXML);
          TNFeComparer.Compara_det(lNFeBase.Det, lNFeCompara.Det);
          TNFeComparer.Compara_total(lNFeBase.Total, lNFeCompara.Total);
          TNFeComparer.Compara_transp(lNFeBase.Transp, lNFeCompara.Transp);
          TNFeComparer.Compara_cobr(lNFeBase.Cobr, lNFeCompara.Cobr);
          TNFeComparer.Compara_pag(lNFeBase.pag, lNFeCompara.pag);
          TNFeComparer.Compara_infAdic(lNFeBase.InfAdic, lNFeCompara.InfAdic);
        except
          on E:Exception do
            Fail('Arquivo XML:'+lListaBase.Strings[i]+' e Arquivo JSON:'+lListaCompara.Strings[i]+' não preencheram as mesmas propriedades.' + sLineBreak + E.Message);
        end;

      end;
    finally
      lListaCompara.Free;
    end;
  finally
    lListaBase.Free;
  end;
end;

procedure TNFeJSONEquivalenciaTest.LeituraINIEhJSON_DevePreencherAsMesmasPropriedades;
var
  lListaBase, lListaCompara: TStringList;
  i, lIndiceJSON: Integer;
  lNFeBase, lNFeCompara: TNFe;
  lJSONAhProcurar: String;
begin
  lListaBase := TStringList.Create;
  try
    lListaCompara := TStringList.Create;
    try
      ListaArquivosParaLer(taINI, lListaBase, lListaCompara);

      if lListaBase.Count <> lListaCompara.Count then
      begin
        Fail('Falhou em carregar arquivos equivalentes para usar no teste');
        exit;
      end;

      for i := 0 to lListaBase.Count - 1 do
      begin
        //Carrego o XML para base
        FACBrNFeBase.NotasFiscais.Clear;
        FACBrNFeBase.NotasFiscais.LoadFromIni(lListaBase.Strings[i]);
        lNFeBase := FACBrNFeBase.NotasFiscais[0].NFe;

        //Carrego o JSON equivalente
        lJSONAhProcurar := StringReplace(lListaBase.Strings[i], '.INI', '.JSON', [rfReplaceAll]);
        lJSONAhProcurar := StringReplace(lJSONAhProcurar, 'INI', 'JSON', [rfReplaceAll]);
        lIndiceJSON := lListaCompara.IndexOf(lJSONAhProcurar);
        FACBrNFeCompara.NotasFiscais.Clear;
        FACBrNFeCompara.NotasFiscais.LoadFromJSON(lListaCompara.Strings[lIndiceJSON]);
        lNFeCompara := FACBrNFeCompara.NotasFiscais[0].NFe;

        try
          TNFeComparer.Compara_Ide(lNFeBase.Ide, lNFeCompara.Ide);
          TNFeComparer.Compara_emit(lNFeBase.Emit, lNFeCompara.Emit);
          TNFeComparer.Compara_avulsa(lNFeBase.Avulsa, lNFeCompara.Avulsa);
          TNFeComparer.Compara_dest(lNFeBase.Dest, lNFeCompara.Dest);
          TNFeComparer.Compara_retirada(lNFeBase.Retirada, lNFeCompara.Retirada);
          TNFeComparer.Compara_entrega(lNFeBase.Entrega, lNFeCompara.Entrega);
          TNFeComparer.Compara_autXML(lNFeBase.autXML, lNFeCompara.autXML);
          TNFeComparer.Compara_det(lNFeBase.Det, lNFeCompara.Det);
          TNFeComparer.Compara_total(lNFeBase.Total, lNFeCompara.Total);
          TNFeComparer.Compara_transp(lNFeBase.Transp, lNFeCompara.Transp);
          TNFeComparer.Compara_cobr(lNFeBase.Cobr, lNFeCompara.Cobr);
          TNFeComparer.Compara_pag(lNFeBase.pag, lNFeCompara.pag);
          TNFeComparer.Compara_infAdic(lNFeBase.InfAdic, lNFeCompara.InfAdic);
        except
          on E:Exception do
            Fail('Arquivo INI:'+lListaBase.Strings[i]+' e Arquivo JSON:'+lListaCompara.Strings[i]+' não preencheram as mesmas propriedades.' + sLineBreak + E.Message);
        end;

      end;
    finally
      lListaCompara.Free;
    end;
  finally
    lListaBase.Free;
  end;
end;

{ TEventoNFeJSONEquivalenciaTest }

procedure TEventoNFeJSONEquivalenciaTest.SetUp;
begin
  inherited SetUp;
  FACBrNFeBase := TACBrNFe.Create(nil);
  FACBrNFeCompara := TACBrNFe.Create(nil);
end;

procedure TEventoNFeJSONEquivalenciaTest.TearDown;
begin
  FACBrNFeBase.Free;
  FACBrNFeCompara.Free;
  inherited TearDown;
end;

procedure TEventoNFeJSONEquivalenciaTest.ListaArquivosParaLer(const ATipo: TTipoArquivo;var AListaBase, AListaCompara: TStringList);
var
  SR: TSearchRec;
  lSRPath, lResultPath: String;
begin
  case ATipo of
    taXML:
      begin
        lResultPath := CAMINHO_XML_EVENTOS;
        lSRPath := IncludeTrailingPathDelimiter(CAMINHO_XML_EVENTOS) + '*.XML';
      end;
    taINI:
      begin
        lResultPath := CAMINHO_INI_EVENTOS;
        lSRPath := IncludeTrailingPathDelimiter(CAMINHO_INI_EVENTOS) + '*.INI';
      end;
  end;

  //Lista base pode ser INI ou XML
  AListaBase.Clear;
  if FindFirst(lSRPath, faAnyFile, SR) = 0 then
  begin
    try
      repeat
        if (SR.Attr and faDirectory) = 0 then
          AListaBase.Add(IncludeTrailingPathDelimiter(lResultPath) + SR.Name);
      until FindNext(SR) <> 0;
    finally
      FindClose(SR);
    end;
  end;

  //Lista de comparação sempre será JSON
  AListaCompara.Clear;
  if FindFirst(IncludeTrailingPathDelimiter(CAMINHO_JSON_EVENTOS) + '*.JSON', faAnyFile, SR) = 0 then
  begin
    try
      repeat
        if (SR.Attr and faDirectory) = 0 then
          AListaCompara.Add(IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(CAMINHO_JSON_EVENTOS)) + SR.Name);
      until FindNext(SR) <> 0;
    finally
      FindClose(SR);
    end;
  end;
end;

procedure TEventoNFeJSONEquivalenciaTest.LeituraXMLEhJSON_DevePreencherAsMesmasPropriedades;
var
  i, lIndiceJSON: Integer;
  lEventoBase, lEventoCompara: TInfEventoCollectionItem;
  lJSONAhProcurar: String;
  lListaBase, lListaCompara: TStringList;
begin
  lListaBase := TStringList.Create;
  try
    lListaCompara := TStringList.Create;
    try

      ListaArquivosParaLer(taXML, lListaBase, lListaCompara);
      if lListaBase.Count <> lListaCompara.Count then
      begin
        Fail('Falhou em carregar arquivos equivalentes para usar no teste');
        exit;
      end;

      for i := 0 to lListaBase.Count - 1 do
      begin
        //Carrego o XML base
        FACBrNFeBase.EventoNFe.Evento.Clear;
        FACBrNFeBase.EventoNFe.LerXML(lListaBase.Strings[i]);
        lEventoBase := FACBrNFeBase.EventoNFe.Evento[0];

        //Carrego o JSON
        lJSONAhProcurar := StringReplace(lListaBase.Strings[i], 'XML', 'JSON', [rfReplaceAll]);
        lJSONAhProcurar := StringReplace(lJSONAhProcurar, '.XML', '.JSON', [rfReplaceAll]);
        lJSONAhProcurar := StringReplace(lJSONAhProcurar, '.xml', '.json', [rfReplaceAll]);
        lIndiceJSON := lListaCompara.IndexOf(lJSONAhProcurar);
        FACBrNFeCompara.EventoNFe.Evento.Clear;
        FACBrNFeCompara.EventoNFe.LerFromJSON(lListaCompara.Strings[lIndiceJSON]);
        lEventoCompara := FACBrNFeCompara.EVentoNFe.Evento[0];

        try
          TEventoNFeComparer.Compara_Evento(lEventoBase, lEventoCompara);
        except
          on E:Exception do
            Fail('Arquivo XML:'+lListaBase.Strings[i]+' e Arquivo JSON:'+lListaCompara.Strings[i]+' não preencheram as mesmas propriedades.' + sLineBreak + E.Message);
        end;
      end;
    finally
      lListaCompara.Free;
    end;
  finally
    lListaBase.Free;
  end;
end;

procedure TEventoNFeJSONEquivalenciaTest.LeituraINIEhJSON_DevePreencherAsMesmasPropriedades;
var
  i, lIndiceJSON: Integer;
  lEventoBase, lEventoCompara: TInfEventoCollectionItem;
  lJSONAhProcurar: String;
  lListaBase, lListaCompara: TStringList;
begin
  lListaBase := TStringList.Create;
  try
    lListaCompara := TStringList.Create;
    try

      ListaArquivosParaLer(taINI, lListaBase, lListaCompara);
      if lListaBase.Count <> lListaCompara.Count then
      begin
        Fail('Falhou em carregar arquivos equivalentes para usar no teste');
        exit;
      end;

      for i := 0 to lListaBase.Count - 1 do
      begin
        //Carrego o XML base
        FACBrNFeBase.EventoNFe.Evento.Clear;
        FACBrNFeBase.EventoNFe.LerFromIni(lListaBase.Strings[i], False);
        lEventoBase := FACBrNFeBase.EventoNFe.Evento[0];

        //Carrego o JSON
        lJSONAhProcurar := StringReplace(lListaBase.Strings[i], 'INI', 'JSON', [rfReplaceAll]);
        lJSONAhProcurar := StringReplace(lJSONAhProcurar, '.INI', '.JSON', [rfReplaceAll]);
        lJSONAhProcurar := StringReplace(lJSONAhProcurar, '.ini', '.json', [rfReplaceAll]);
        lIndiceJSON := lListaCompara.IndexOf(lJSONAhProcurar);
        FACBrNFeCompara.EventoNFe.Evento.Clear;
        FACBrNFeCompara.EventoNFe.LerFromJSON(lListaCompara.Strings[lIndiceJSON]);
        lEventoCompara := FACBrNFeCompara.EVentoNFe.Evento[0];

        try
          TEventoNFeComparer.Compara_Evento(lEventoBase, lEventoCompara);
        except
          on E:Exception do
            Fail('Arquivo XML:'+lListaBase.Strings[i]+' e Arquivo JSON:'+lListaCompara.Strings[i]+' não preencheram as mesmas propriedades.' + sLineBreak + E.Message);
        end;
      end;
    finally
      lListaCompara.Free;
    end;
  finally
    lListaBase.Free;
  end;
end;

class procedure TNFeComparer.Compara_Ide(const AIdeBase, AIdeCompara: TIde);
var
  i: Integer;
begin
  CheckEquals(AIdeBase.cUF, AIdeCompara.cUF, 'ide.cUF difere do esperado');
  CheckEquals(AIdeBase.cNF, AIdeCompara.cNF, 'ide.cNF difere do esperado');
  CheckEquals(AIdeBase.natOp, AIdeCompara.natOp, 'ide.natOp difere do esperado');
  CheckEquals(AIdeBase.modelo, AIdeCompara.modelo, 'ide.modelo difere do esperado');
  CheckEquals(AIdeBase.serie, AIdeCompara.serie, 'ide.serie difere do esperado');
  CheckEquals(AIdeBase.nNF, AIdeCompara.nNF, 'ide.nNF difere do esperado');
  CheckEquals(AIdeBase.dEmi, AIdeCompara.dEmi, 'ide.dhEmi difere do esperado');
  CheckEquals(AIdeBase.dSaiEnt, AIdeCompara.dSaiEnt, 'ide.dhSaiEnt difere do esperado');
  CheckEquals(tpNFToStr(AIdeBase.tpNF), tpNFToStr(AIdeCompara.tpNF), 'ide.tpNF difere do esperado');
  CheckEquals(DestinoOperacaoToStr(AIdeBase.idDest), DestinoOperacaoToStr(AIdeCompara.idDest), 'ide.idDest difere do esperado');
  CheckEquals(AIdeBase.cMunFG, AIdeCompara.cMunFG, 'ide.cMunFG difere do esperado');
  CheckEquals(TpImpToStr(AIdeBase.tpImp), TpImpToStr(AIdeCompara.tpImp), 'ide.tpImp difere do esperado');
  CheckEquals(TpEmisToStr(AIdeBase.tpEmis), TpEmisToStr(AIdeCompara.tpEmis), 'ide.tpEmis difere do esperado');
  CheckEquals(AIdeBase.cDV, AIdeCompara.cDV, 'ide.cDV difere do esperado');
  CheckEquals(TpAmbToStr(AIdeBase.tpAmb), TpAmbToStr(AIdeCompara.tpAmb), 'ide.tpAmb difere do esperado');
  CheckEquals(FinNFeToStr(AIdeBase.finNFe), FinNFeToStr(AIdeCompara.finNFe), 'ide.finNFe difere do esperado');
  CheckEquals(ConsumidorFinalToStr(AIdeBase.indFinal), ConsumidorFinalToStr(AIdeCompara.indFinal), 'ide.indFinal difere do esperado');
  CheckEquals(PresencaCompradorToStr(AIdeBase.indPres), PresencaCompradorToStr(AIdeCompara.indPres), 'ide.indPres difere do esperado');
  CheckEquals(procEmiToStr(AIdeBase.procEmi), procEmiToStr(AIdeCompara.procEmi), 'ide.procEmi difere do esperado');
  CheckEquals(AIdeBase.verProc, AIdeCompara.verProc, 'ide.verProc difere do esperado');
  CheckEquals(AIdeBase.dhCont, AIdeCompara.dhCont, 'ide.dhCont difere do esperado');
  CheckEquals(AIdeBase.xJust, AIdeCompara.xJust, 'ide.xJust difere do esperado');

  CheckEquals(AIdeBase.gCompraGov.pRedutor, AIdeCompara.gCompraGov.pRedutor, 'ide.gCompraGov.pRedutor difere do esperado');
  CheckEquals(tpEnteGovToStr(AIdeBase.gCompraGov.tpEnteGov), tpEnteGovToStr(AIdeCompara.gCompraGov.tpEnteGov), 'ide.gCompraGov.tpEnteGov difere do esperado');
  CheckEquals(tpOperGovToStr(AIdeBase.gCompraGov.tpOperGov), tpOperGovToStr(AIdeCompara.gCompraGov.tpOperGov), 'ide.gCompraGov.tpOperGov difere do esperado');

  if AIdeBase.gPagAntecipado.Count <> AIdeBase.gPagAntecipado.Count then
  begin
    Fail(Format('gPagAntecipado.Count difere do esperado. Esperado: %d, Obtido: %d', [AIdeBase.gPagAntecipado.Count, AIdeBase.gPagAntecipado.Count]));
    Exit;
  end;
  for i := 0 to AIdeBase.gPagAntecipado.Count - 1 do
    CheckEquals(AIdeBase.gPagAntecipado[i].refNFe, AIdeCompara.gPagAntecipado[i].refNFe, 'ide.gPagAntecipado['+IntToStr(i)+'].refNFe difere do esperado');
end;

class procedure TNFeComparer.Compara_emit(const AEmitBase, AEmitCompara: TEmit);
begin
  CheckEquals(AEmitBase.CNPJCPF, AEmitCompara.CNPJCPF, 'emit.CNPJCPF difere do esperado');
  CheckEquals(AEmitBase.xNome, AEmitCompara.xNome, 'emit.xNome difere do esperado');
  CheckEquals(AEmitBase.xFant, AEmitCompara.xFant, 'emit.xFant difere do esperado');

  // Endereço
  CheckEquals(AEmitBase.EnderEmit.xLgr, AEmitCompara.EnderEmit.xLgr, 'emit.EnderEmit.xLgr difere do esperado');
  CheckEquals(StrToIntDef(AEmitBase.EnderEmit.nro, 0), StrToIntDef(AEmitCompara.EnderEmit.nro, 0), 'emit.EnderEmit.nro difere do esperado');
  CheckEquals(AEmitBase.EnderEmit.xCpl, AEmitCompara.EnderEmit.xCpl, 'emit.EnderEmit.xCpl difere do esperado');
  CheckEquals(AEmitBase.EnderEmit.xBairro, AEmitCompara.EnderEmit.xBairro, 'emit.EnderEmit.xBairro difere do esperado');
  CheckEquals(AEmitBase.EnderEmit.cMun, AEmitCompara.EnderEmit.cMun, 'emit.EnderEmit.cMun difere do esperado');
  CheckEquals(AEmitBase.EnderEmit.xMun, AEmitCompara.EnderEmit.xMun, 'emit.EnderEmit.xMun difere do esperado');
  CheckEquals(AEmitBase.EnderEmit.UF, AEmitCompara.EnderEmit.UF, 'emit.EnderEmit.UF difere do esperado');
  CheckEquals(AEmitBase.EnderEmit.CEP, AEmitCompara.EnderEmit.CEP, 'emit.EnderEmit.CEP difere do esperado');
  CheckEquals(AEmitBase.EnderEmit.cPais, AEmitCompara.EnderEmit.cPais, 'emit.EnderEmit.cPais difere do esperado');
  CheckEquals(AEmitBase.EnderEmit.xPais, AEmitCompara.EnderEmit.xPais, 'emit.EnderEmit.xPais difere do esperado');
  CheckEquals(AEmitBase.EnderEmit.Fone, AEmitCompara.EnderEmit.Fone, 'emit.EnderEmit.Fone difere do esperado');

  CheckEquals(AEmitBase.IE, AEmitCompara.IE, 'emit.IE difere do esperado');
  CheckEquals(AEmitBase.IEST, AEmitCompara.IEST, 'emit.IEST difere do esperado');
  CheckEquals(AEmitBase.IM, AEmitCompara.IM, 'emit.IM difere do esperado');
  CheckEquals(AEmitBase.CNAE, AEmitCompara.CNAE, 'emit.CNAE difere do esperado');
  CheckEquals(CRTToStr(AEmitBase.CRT), CRTToStr(AEmitCompara.CRT), 'emit.CRT difere do esperado');
end;

class procedure TNFeComparer.Compara_avulsa(const AAvulsaBase, AAvulsaCompara: TAvulsa);
begin
  CheckEquals(AAvulsaBase.CNPJ, AAvulsaCompara.CNPJ, 'avulsa.CNPJ difere do esperado');
  CheckEquals(AAvulsaBase.xOrgao, AAvulsaCompara.xOrgao, 'avulsa.xOrgao difere do esperado');
  CheckEquals(AAvulsaBase.matr, AAvulsaCompara.matr, 'avulsa.matr difere do esperado');
  CheckEquals(AAvulsaBase.xAgente, AAvulsaCompara.xAgente, 'avulsa.xAgente difere do esperado');
  CheckEquals(AAvulsaBase.fone, AAvulsaCompara.fone, 'avulsa.fone difere do esperado');
  CheckEquals(AAvulsaBase.UF, AAvulsaCompara.UF, 'avulsa.UF difere do esperado');
  CheckEquals(AAvulsaBase.nDAR, AAvulsaCompara.nDAR, 'avulsa.nDAR difere do esperado');
  CheckEquals(AAvulsaBase.dEmi, AAvulsaCompara.dEmi, 'avulsa.dEmi difere do esperado');
  CheckEquals(AAvulsaBase.vDAR, AAvulsaCompara.vDAR, 'avulsa.vDAR difere do esperado');
  CheckEquals(AAvulsaBase.repEmi, AAvulsaCompara.repEmi, 'avulsa.repEmi difere do esperado');
  CheckEquals(AAvulsaBase.dPag, AAvulsaCompara.dPag, 'avulsa.dPag difere do esperado');
end;

class procedure TNFeComparer.Compara_dest(const ADestBase, ADestCompara: TDest);
begin
  CheckEquals(ADestBase.CNPJCPF, ADestCompara.CNPJCPF, 'dest.CNPJCPF difere do esperado');
  CheckEquals(ADestBase.xNome, ADestCompara.xNome, 'dest.xNome difere do esperado');

  // Endereço
  CheckEquals(ADestBase.EnderDest.xLgr, ADestCompara.EnderDest.xLgr, 'dest.EnderDest.xLgr difere do esperado');
  CheckEquals(StrToIntDef(ADestBase.EnderDest.nro, 0), StrToIntDef(ADestCompara.EnderDest.nro, 0), 'dest.EnderDest.nro difere do esperado');
  CheckEquals(ADestBase.EnderDest.xCpl, ADestCompara.EnderDest.xCpl, 'dest.EnderDest.xCpl difere do esperado');
  CheckEquals(ADestBase.EnderDest.xBairro, ADestCompara.EnderDest.xBairro, 'dest.EnderDest.xBairro difere do esperado');
  CheckEquals(ADestBase.EnderDest.cMun, ADestCompara.EnderDest.cMun, 'dest.EnderDest.cMun difere do esperado');
  CheckEquals(ADestBase.EnderDest.xMun, ADestCompara.EnderDest.xMun, 'dest.EnderDest.xMun difere do esperado');
  CheckEquals(ADestBase.EnderDest.UF, ADestCompara.EnderDest.UF, 'dest.EnderDest.UF difere do esperado');
  CheckEquals(ADestBase.EnderDest.CEP, ADestCompara.EnderDest.CEP, 'dest.EnderDest.CEP difere do esperado');
  CheckEquals(ADestBase.EnderDest.cPais, ADestCompara.EnderDest.cPais, 'dest.EnderDest.cPais difere do esperado');
  CheckEquals(ADestBase.EnderDest.xPais, ADestCompara.EnderDest.xPais, 'dest.EnderDest.xPais difere do esperado');
  CheckEquals(ADestBase.EnderDest.Fone, ADestCompara.EnderDest.Fone, 'dest.EnderDest.Fone difere do esperado');

  CheckEquals(indIEDestToStr(ADestBase.indIEDest), indIEDestToStr(ADestCompara.indIEDest), 'dest.indIEDest difere do esperado');
  CheckEquals(ADestBase.IE, ADestCompara.IE, 'dest.IE difere do esperado');
  CheckEquals(ADestBase.ISUF, ADestCompara.ISUF, 'dest.ISUF difere do esperado');
  CheckEquals(ADestBase.IM, ADestCompara.IM, 'dest.IM difere do esperado');
  CheckEquals(ADestBase.email, ADestCompara.email, 'dest.email difere do esperado');
  CheckEquals(ADestBase.idEstrangeiro, ADestCompara.idEstrangeiro, 'dest.idEstrangeiro difere do esperado');
end;

class procedure TNFeComparer.Compara_retirada(const ARetiradaBase, ARetiradaCompara: TRetirada);
begin
  CheckEquals(ARetiradaBase.CNPJCPF, ARetiradaCompara.CNPJCPF, 'retirada.CNPJCPF difere do esperado');
  CheckEquals(ARetiradaBase.xNome, ARetiradaCompara.xNome, 'retirada.xNome difere do esperado');
  CheckEquals(ARetiradaBase.xLgr, ARetiradaCompara.xLgr, 'retirada.xLgr difere do esperado');
  CheckEquals(StrToIntDef(ARetiradaBase.nro, 0), StrToIntDef(ARetiradaCompara.nro, 0), 'retirada.nro difere do esperado');
  CheckEquals(ARetiradaBase.xCpl, ARetiradaCompara.xCpl, 'retirada.xCpl difere do esperado');
  CheckEquals(ARetiradaBase.xBairro, ARetiradaCompara.xBairro, 'retirada.xBairro difere do esperado');
  CheckEquals(ARetiradaBase.cMun, ARetiradaCompara.cMun, 'retirada.cMun difere do esperado');
  CheckEquals(ARetiradaBase.xMun, ARetiradaCompara.xMun, 'retirada.xMun difere do esperado');
  CheckEquals(ARetiradaBase.UF, ARetiradaCompara.UF, 'retirada.UF difere do esperado');
  CheckEquals(ARetiradaBase.CEP, ARetiradaCompara.CEP, 'retirada.CEP difere do esperado');
  CheckEquals(ARetiradaBase.cPais, ARetiradaCompara.cPais, 'retirada.cPais difere do esperado');
  CheckEquals(ARetiradaBase.xPais, ARetiradaCompara.xPais, 'retirada.xPais difere do esperado');
  CheckEquals(ARetiradaBase.Fone, ARetiradaCompara.Fone, 'retirada.Fone difere do esperado');
  CheckEquals(ARetiradaBase.Email, ARetiradaCompara.Email, 'retirada.Email difere do esperado');
  CheckEquals(ARetiradaBase.IE, ARetiradaCompara.IE, 'retirada.IE difere do esperado');
end;

class procedure TNFeComparer.Compara_entrega(const AEntregaBase, AEntregaCompara: TEntrega);
begin
  CheckEquals(AEntregaBase.CNPJCPF, AEntregaCompara.CNPJCPF, 'entrega.CNPJCPF difere do esperado');
  CheckEquals(AEntregaBase.xNome, AEntregaCompara.xNome, 'entrega.xNome difere do esperado');
  CheckEquals(AEntregaBase.xLgr, AEntregaCompara.xLgr, 'entrega.xLgr difere do esperado');
  CheckEquals(StrToIntDef(AEntregaBase.nro, 0), StrToIntDef(AEntregaCompara.nro, 0), 'entrega.nro difere do esperado');
  CheckEquals(AEntregaBase.xCpl, AEntregaCompara.xCpl, 'entrega.xCpl difere do esperado');
  CheckEquals(AEntregaBase.xBairro, AEntregaCompara.xBairro, 'entrega.xBairro difere do esperado');
  CheckEquals(AEntregaBase.cMun, AEntregaCompara.cMun, 'entrega.cMun difere do esperado');
  CheckEquals(AEntregaBase.xMun, AEntregaCompara.xMun, 'entrega.xMun difere do esperado');
  CheckEquals(AEntregaBase.UF, AEntregaCompara.UF, 'entrega.UF difere do esperado');
  CheckEquals(AEntregaBase.CEP, AEntregaCompara.CEP, 'entrega.CEP difere do esperado');
  CheckEquals(AEntregaBase.cPais, AEntregaCompara.cPais, 'entrega.cPais difere do esperado');
  CheckEquals(AEntregaBase.xPais, AEntregaCompara.xPais, 'entrega.xPais difere do esperado');
  CheckEquals(AEntregaBase.Fone, AEntregaCompara.Fone, 'entrega.Fone difere do esperado');
  CheckEquals(AEntregaBase.Email, AEntregaCompara.Email, 'entrega.Email difere do esperado');
  CheckEquals(AEntregaBase.IE, AEntregaCompara.IE, 'entrega.IE difere do esperado');
end;

class procedure TNFeComparer.Compara_autXML(const AAutXMLBase, AAutXMLCompara: TautXMLCollection);
var
  i: Integer;
begin
  if AAutXMLBase.Count <> AAutXMLCompara.Count then
  begin
    Fail(Format('autXML.Count difere do esperado. Esperado: %d, Obtido: %d', [AAutXMLBase.Count, AAutXMLCompara.Count]));
    Exit;
  end;

  for i := 0 to AAutXMLBase.Count - 1 do
  begin
    CheckEquals(AAutXMLBase[i].CNPJCPF, AAutXMLCompara[i].CNPJCPF, Format('autXML[%d].CNPJCPF difere do esperado', [i]));
  end;
end;

class procedure TNFeComparer.Compara_prod(const AProdBase, AProdCompara: TProd);
begin
  CheckEquals(AProdBase.cProd, AProdCompara.cProd, 'prod.cProd difere do esperado');
  CheckEquals(AProdBase.cEAN, AProdCompara.cEAN, 'prod.cEAN difere do esperado');
  CheckEquals(AProdBase.xProd, AProdCompara.xProd, 'prod.xProd difere do esperado');
  CheckEquals(AProdBase.NCM, AProdCompara.NCM, 'prod.NCM difere do esperado');
//  CheckEquals(AProdBase.NVE, AProdCompara.NVE, 'prod.NVE difere do esperado');
  CheckEquals(AProdBase.CEST, AProdCompara.CEST, 'prod.CEST difere do esperado');
  CheckEquals(IndEscalaToStr(AProdBase.indEscala), IndEscalaToStr(AProdCompara.indEscala), 'prod.indEscala difere do esperado');
  CheckEquals(AProdBase.CNPJFab, AProdCompara.CNPJFab, 'prod.CNPJFab difere do esperado');
  CheckEquals(AProdBase.cBenef, AProdCompara.cBenef, 'prod.cBenef difere do esperado');
  CheckEquals(AProdBase.EXTIPI, AProdCompara.EXTIPI, 'prod.EXTIPI difere do esperado');
  CheckEquals(AProdBase.CFOP, AProdCompara.CFOP, 'prod.CFOP difere do esperado');
  CheckEquals(AProdBase.uCom, AProdCompara.uCom, 'prod.uCom difere do esperado');
  CheckEquals(AProdBase.qCom, AProdCompara.qCom, 'prod.qCom difere do esperado');
  CheckEquals(AProdBase.vUnCom, AProdCompara.vUnCom, 'prod.vUnCom difere do esperado');
  CheckEquals(AProdBase.vProd, AProdCompara.vProd, 'prod.vProd difere do esperado');
  CheckEquals(AProdBase.cEANTrib, AProdCompara.cEANTrib, 'prod.cEANTrib difere do esperado');
  CheckEquals(AProdBase.uTrib, AProdCompara.uTrib, 'prod.uTrib difere do esperado');
  CheckEquals(AProdBase.qTrib, AProdCompara.qTrib, 'prod.qTrib difere do esperado');
  CheckEquals(AProdBase.vUnTrib, AProdCompara.vUnTrib, 'prod.vUnTrib difere do esperado');
  CheckEquals(AProdBase.vFrete, AProdCompara.vFrete, 'prod.vFrete difere do esperado');
  CheckEquals(AProdBase.vSeg, AProdCompara.vSeg, 'prod.vSeg difere do esperado');
  CheckEquals(AProdBase.vDesc, AProdCompara.vDesc, 'prod.vDesc difere do esperado');
  CheckEquals(AProdBase.vOutro, AProdCompara.vOutro, 'prod.vOutro difere do esperado');
  CheckEquals(indTotToStr(AProdBase.indTot), indTotToStr(AProdCompara.indTot), 'prod.indTot difere do esperado');
  CheckEquals(AProdBase.xPed, AProdCompara.xPed, 'prod.xPed difere do esperado');
  CheckEquals(AProdBase.nItemPed, AProdCompara.nItemPed, 'prod.nItemPed difere do esperado');
  CheckEquals(AProdBase.nFCI, AProdCompara.nFCI, 'prod.nFCI difere do esperado');
end;

class procedure TNFeComparer.Compara_det(const ADetBase, ADetCompara: TDetCollection);
var
  i: Integer;
begin
  if ADetBase.Count <> ADetCompara.Count then
  begin
    Fail(Format('det.Count difere do esperado. Esperado: %d, Obtido: %d', [ADetBase.Count, ADetCompara.Count]));
    Exit;
  end;

  for i := 0 to ADetBase.Count - 1 do
  begin
    // Compara o produto
    Compara_prod(ADetBase[i].Prod, ADetCompara[i].Prod);
    // Chamar aqui a comparação para o grupo de Impostos
    Compara_imposto(ADetBase[i].Imposto, ADetCompara[i].Imposto);
    //ImpostoDevol
    CheckEquals(ADetBase[i].pDevol, ADetCompara[i].pDevol, Format('Det[%d].pDevol difere do esperado', [i]));
    CheckEquals(ADetBase[i].vIPIDevol, ADetCompara[i].vIPIDevol, Format('Det[%d].vIPIDevol difere do esperado', [i]));
    //InfAdProd
    CheckEquals(ADetBase[i].infAdProd, ADetCompara[i].infAdProd, Format('Det[%d].infAdProd difere do esperado', [i]));
    //ObsCont
    CheckEquals(ADetBase[i].obsCont.xCampo, ADetCompara[i].obsCont.xCampo, Format('Det[%d].obsCont.xCampo difere do esperado', [i]));
    CheckEquals(ADetBase[i].obsCont.xTexto, ADetCompara[i].obsCont.xTexto, Format('Det[%d].obsCont.xTexto difere do esperado', [i]));
    //ObsFisco
    CheckEquals(ADetBase[i].obsFisco.xCampo, ADetCompara[i].obsFisco.xCampo, Format('Det[%d].obsFisco.xCampo difere do esperado', [i]));
    CheckEquals(ADetBase[i].obsFisco.xTexto, ADetCompara[i].obsFisco.xTexto, Format('Det[%d].obsFisco.xTexto difere do esperado', [i]));
    //RT
    CheckEquals(ADetBase[i].vItem, ADetCompara[i].vItem, Format('Det[%d].vItem difere do esperado', [i]));
    CheckEquals(ADetBase[i].DFeReferenciado.nItem, ADetCompara[i].DFeReferenciado.nItem, Format('Det[%d].DFeReferenciado.nItem difere do esperado', [i]));
    CheckEquals(ADetBase[i].DFeReferenciado.chaveAcesso, ADetCompara[i].DFeReferenciado.chaveAcesso, Format('Det[%d].DFeReferenciado.chaveAcesso difere do esperado', [i]));
  end;
end;

class procedure TNFeComparer.Compara_imposto(const AImpostoBase, AImpostoCompara: TImposto);
begin
  CheckEquals(AImpostoBase.vTotTrib, AImpostoCompara.vTotTrib, 'imposto.vTotTrib difere do esperado');
  Compara_ICMS(AImpostoBase.ICMS, AImpostoCompara.ICMS);
  Compara_PIS(AImpostoBase.PIS, AImpostoCompara.PIS);
  Compara_PISST(AImpostoBase.PISST, AImpostoCompara.PISST);
  Compara_COFINS(AImpostoBase.COFINS, AImpostoCompara.COFINS);
  Compara_COFINSST(AImpostoBase.COFINSST, AImpostoCompara.COFINSST);
  Compara_IPI(AImpostoBase.IPI, AImpostoCompara.IPI);
  Compara_II(AImpostoBase.II, AImpostoCompara.II);
  Compara_ISSQN(AImpostoBase.ISSQN, AImpostoCompara.ISSQN);
  Compara_IS(AImpostoBase.ISel, AImpostoCompara.ISel);
  Compara_IBSCBS(AImpostoBase.IBSCBS, AImpostoCompara.IBSCBS);
end;

class procedure TNFeComparer.Compara_ICMS(const AICMSBase, AICMSCompara: TICMS);
begin
  CheckEquals(OrigToStr(AICMSBase.orig), OrigToStr(AICMSCompara.orig), 'imposto.ICMS.orig difere do esperado');
  CheckEquals(CSTICMSToStr(AICMSBase.CST), CSTICMSToStr(AICMSCompara.CST), 'imposto.ICMS.CST difere do esperado');
  CheckEquals(CSOSNIcmsToStr(AICMSBase.CSOSN), CSOSNIcmsToStr(AICMSCompara.CSOSN), 'imposto.ICMS.CSOSN difere do esperado');

  if AICMSBase.CSOSN = csosnVazio then
  begin
    case AICMSBase.CST of
      cst00:
        begin
          CheckEquals(modBCToStr(AICMSBase.modBC), modBCToStr(AICMSCompara.modBC), 'imposto.ICMS.modBC difere do esperado');
          CheckEquals(AICMSBase.vBC, AICMSCompara.vBC, 'imposto.ICMS.vBC difere do esperado');
          CheckEquals(AICMSBase.pICMS, AICMSCompara.pICMS, 'imposto.ICMS.pICMS difere do esperado');
          CheckEquals(AICMSBase.vICMS, AICMSCompara.vICMS, 'imposto.ICMS.vICMS difere do esperado');
          CheckEquals(AICMSBase.pFCP, AICMSCompara.pFCP, 'imposto.ICMS.pFCP difere do esperado');
          CheckEquals(AICMSBase.vFCP, AICMSCompara.vFCP, 'imposto.ICMS.vFCP difere do esperado');
        end;
      cst15:
        begin
          CheckEquals(AICMSBase.qBCMono, AICMSCompara.qBCMono, 'imposto.ICMS.qBCMono (CST15) difere do esperado');
          CheckEquals(AICMSBase.adRemICMS, AICMSCompara.adRemICMS, 'imposto.ICMS.adRemICMS (CST15) difere do esperado');
          CheckEquals(AICMSBase.vICMSMono, AICMSCompara.vICMSMono, 'imposto.ICMS.vICMSMono (CST15) difere do esperado');
          CheckEquals(AICMSBase.qBCMonoReten, AICMSCompara.qBCMonoReten, 'imposto.ICMS.qBCMonoReten (CST15) difere do esperado');
          CheckEquals(AICMSBase.adRemICMSReten, AICMSCompara.adRemICMSReten, 'imposto.ICMS.adRemICMSReten (CST15) difere do esperado');
          CheckEquals(AICMSBase.vICMSMonoReten, AICMSCompara.vICMSMonoReten, 'imposto.ICMS.vICMSMonoReten (CST15) difere do esperado');
          CheckEquals(AICMSBase.pRedAdRem, AICMSCompara.pRedAdRem, 'imposto.ICMS.pRedAdRem (CST15) difere do esperado');
          CheckEquals(motRedAdRemToStr(AICMSBase.motRedAdRem), motRedAdRemToStr(AICMSCompara.motRedAdRem), 'imposto.ICMS.motRedAdRem (CST15) difere do esperado');
        end;
      cst20:
        begin
          CheckEquals(modBCToStr(AICMSBase.modBC), modBCToStr(AICMSCompara.modBC), 'imposto.ICMS.modBC (CST20) difere do esperado');
          CheckEquals(AICMSBase.pRedBC, AICMSCompara.pRedBC, 'imposto.ICMS.pRedBC (CST20) difere do esperado');
          CheckEquals(AICMSBase.vBC, AICMSCompara.vBC, 'imposto.ICMS.vBC (CST20) difere do esperado');
          CheckEquals(AICMSBase.pICMS, AICMSCompara.pICMS, 'imposto.ICMS.pICMS (CST20) difere do esperado');
          CheckEquals(AICMSBase.vICMS, AICMSCompara.vICMS, 'imposto.ICMS.vICMS (CST20) difere do esperado');
          CheckEquals(AICMSBase.vBCFCP, AICMSCompara.vBCFCP, 'imposto.ICMS.vBCFCP (CST20) difere do esperado');
          CheckEquals(AICMSBase.pFCP, AICMSCompara.pFCP, 'imposto.ICMS.pFCP (CST20) difere do esperado');
          CheckEquals(AICMSBase.vFCP, AICMSCompara.vFCP, 'imposto.ICMS.vFCP (CST20) difere do esperado');
          CheckEquals(AICMSBase.vICMSDeson, AICMSCompara.vICMSDeson, 'imposto.ICMS.vICMSDeson (CST20) difere do esperado');
          CheckEquals(motDesICMSToStr(AICMSBase.motDesICMS), motDesICMSToStr(AICMSCompara.motDesICMS), 'imposto.ICMS.motDesICMS (CST20) difere do esperado');
          CheckEquals(TIndicadorExToStr(AICMSBase.indDeduzDeson), TIndicadorExToStr(AICMSCompara.indDeduzDeson), 'imposto.ICMS.indDeduzDeson (CST20) difere do esperado');
        end;
      cst40:
        begin
          CheckEquals(AICMSBase.vICMSDeson, AICMSCompara.vICMSDeson, 'imposto.ICMS.vICMSDeson (CST40) difere do esperado');
          CheckEquals(motDesICMSToStr(AICMSBase.motDesICMS), motDesICMSToStr(AICMSCompara.motDesICMS), 'imposto.ICMS.motDesICMS (CST40) difere do esperado');
          CheckEquals(TIndicadorExToStr(AICMSBase.indDeduzDeson), TIndicadorExToStr(AICMSCompara.indDeduzDeson), 'imposto.ICMS.indDeduzDeson (CST40) difere do esperado');
        end;
      cst60:
        begin
          CheckEquals(AICMSBase.vBCSTRet, AICMSCompara.vBCSTRet, 'imposto.ICMS.vBCSTRet (CST60) difere do esperado');
          CheckEquals(AICMSBase.pST, AICMSCompara.pST, 'imposto.ICMS.pST (CST60) difere do esperado');
          CheckEquals(AICMSBase.vICMSSubstituto, AICMSCompara.vICMSSubstituto, 'imposto.ICMS.vICMSSubstituto (CST60) difere do esperado');
          CheckEquals(AICMSBase.vICMSSTRet, AICMSCompara.vICMSSTRet, 'imposto.ICMS.vICMSSTRet (CST60) difere do esperado');
          CheckEquals(AICMSBase.vBCFCPSTRet, AICMSCompara.vBCFCPSTRet, 'imposto.ICMS.vBCFCPSTRet (CST60) difere do esperado');
          CheckEquals(AICMSBase.pFCPSTRet, AICMSCompara.pFCPSTRet, 'imposto.ICMS.pFCPSTRet (CST60) difere do esperado');
          CheckEquals(AICMSBase.vFCPSTRet, AICMSCompara.vFCPSTRet, 'imposto.ICMS.vFCPSTRet (CST60) difere do esperado');
          CheckEquals(AICMSBase.pRedBCEfet, AICMSCompara.pRedBCEfet, 'imposto.ICMS.pRedBCEfet (CST60) difere do esperado');
          CheckEquals(AICMSBase.vBCEfet, AICMSCompara.vBCEfet, 'imposto.ICMS.vBCEfet (CST60) difere do esperado');
          CheckEquals(AICMSBase.pICMSEfet, AICMSCompara.pICMSEfet, 'imposto.ICMS.pICMSEfet (CST60) difere do esperado');
          CheckEquals(AICMSBase.vICMSEfet, AICMSCompara.vICMSEfet, 'imposto.ICMS.vICMSEfet (CST60) difere do esperado');
        end;
      //TODO: Implementar demais CSTs
    end;
  end else
  begin
    case AICMSBase.CSOSN of
      csosn101:
        begin
          CheckEquals(AICMSBase.pCredSN, AICMSCompara.pCredSN, 'imposto.ICMS.pCredSN (CSOSN101) difere do esperado');
          CheckEquals(AICMSBase.vCredICMSSN, AICMSCompara.vCredICMSSN, 'imposto.ICMS.vCredICMSSN (CSOSN101) difere do esperado');
        end;
      csosn201:
        begin
          CheckEquals(modBCSTToStr(AICMSBase.modBCST), modBCSTToStr(AICMSCompara.modBCST), 'imposto.ICMS.modBCST (CSOSN201) difere do esperado');
          CheckEquals(AICMSBase.pMVAST, AICMSCompara.pMVAST, 'imposto.ICMS.pMVAST (CSOSN201) difere do esperado');
          CheckEquals(AICMSBase.pRedBCST, AICMSCompara.pRedBCST, 'imposto.ICMS.pRedBCST (CSOSN201) difere do esperado');
          CheckEquals(AICMSBase.vBCST, AICMSCompara.vBCST, 'imposto.ICMS.vBCST (CSOSN201) difere do esperado');
          CheckEquals(AICMSBase.pICMSST, AICMSCompara.pICMSST, 'imposto.ICMS.pICMSST (CSOSN201) difere do esperado');
          CheckEquals(AICMSBase.vICMSST, AICMSCompara.vICMSST, 'imposto.ICMS.vICMSST (CSOSN201) difere do esperado');
          CheckEquals(AICMSBase.vBCFCPST, AICMSCompara.vBCFCPST, 'imposto.ICMS.vBCFCPST (CSOSN201) difere do esperado');
          CheckEquals(AICMSBase.pFCPST, AICMSCompara.pFCPST, 'imposto.ICMS.pFCPST (CSOSN201) difere do esperado');
          CheckEquals(AICMSBase.vFCPST, AICMSCompara.vFCPST, 'imposto.ICMS.vFCPST (CSOSN201) difere do esperado');
          CheckEquals(AICMSBase.pCredSN, AICMSCompara.pCredSN, 'imposto.ICMS.pCredSN (CSOSN201) difere do esperado');
          CheckEquals(AICMSBase.vCredICMSSN, AICMSCompara.vCredICMSSN, 'imposto.ICMS.vCredICMSSN (CSOSN201) difere do esperado');
        end;
      csosn500:
        begin
          CheckEquals(AICMSBase.vBCSTRet, AICMSCompara.vBCSTRet, 'imposto.ICMS.vBCSTRet (CSOSN500) difere do esperado');
          CheckEquals(AICMSBase.pST, AICMSCompara.pST, 'imposto.ICMS.pST (CSOSN500) difere do esperado');
          CheckEquals(AICMSBase.vICMSSubstituto, AICMSCompara.vICMSSubstituto, 'imposto.ICMS.vICMSSubstituto (CSOSN500) difere do esperado');
          CheckEquals(AICMSBase.vICMSSTRet, AICMSCompara.vICMSSTRet, 'imposto.ICMS.vICMSSTRet (CSOSN500) difere do esperado');
          CheckEquals(AICMSBase.vBCFCPSTRet, AICMSCompara.vBCFCPSTRet, 'imposto.ICMS.vBCFCPSTRet (CSOSN500) difere do esperado');
          CheckEquals(AICMSBase.pFCPSTRet, AICMSCompara.pFCPSTRet, 'imposto.ICMS.pFCPSTRet (CSOSN500) difere do esperado');
          CheckEquals(AICMSBase.vFCPSTRet, AICMSCompara.vFCPSTRet, 'imposto.ICMS.vFCPSTRet (CSOSN500) difere do esperado');
          CheckEquals(AICMSBase.pRedBCEfet, AICMSCompara.pRedBCEfet, 'imposto.ICMS.pRedBCEfet (CSOSN500) difere do esperado');
          CheckEquals(AICMSBase.vBCEfet, AICMSCompara.vBCEfet, 'imposto.ICMS.vBCEfet (CSOSN500) difere do esperado');
          CheckEquals(AICMSBase.pICMSEfet, AICMSCompara.pICMSEfet, 'imposto.ICMS.pICMSEfet (CSOSN500) difere do esperado');
          CheckEquals(AICMSBase.vICMSEfet, AICMSCompara.vICMSEfet, 'imposto.ICMS.vICMSEfet (CSOSN500) difere do esperado');
        end;
      csosn900:
        begin
          CheckEquals(modBCToStr(AICMSBase.modBC), modBCToStr(AICMSCompara.modBC), 'imposto.ICMS.modBC (CSOSN900) difere do esperado');
          CheckEquals(AICMSBase.vBC, AICMSCompara.vBC, 'imposto.ICMS.vBC (CSOSN900) difere do esperado');
          CheckEquals(AICMSBase.pRedBC, AICMSCompara.pRedBC, 'imposto.ICMS.pRedBC (CSOSN900) difere do esperado');
          CheckEquals(AICMSBase.pICMS, AICMSCompara.pICMS, 'imposto.ICMS.pICMS (CSOSN900) difere do esperado');
          CheckEquals(AICMSBase.vICMS, AICMSCompara.vICMS, 'imposto.ICMS.vICMS (CSOSN900) difere do esperado');
          CheckEquals(modBCSTToStr(AICMSBase.modBCST), modBCSTToStr(AICMSCompara.modBCST), 'imposto.ICMS.modBC (CSOSN900) difere do esperado');
          CheckEquals(AICMSBase.pMVAST, AICMSCompara.pMVAST, 'imposto.ICMS.pMVAST (CSOSN900) difere do esperado');
          CheckEquals(AICMSBase.pRedBCST, AICMSCompara.pRedBCST, 'imposto.ICMS.pRedBCST (CSOSN900) difere do esperado');
          CheckEquals(AICMSBase.vBCST, AICMSCompara.vBCST, 'imposto.ICMS.vBCST (CSOSN900) difere do esperado');
          CheckEquals(AICMSBase.pICMSST, AICMSCompara.pICMSST, 'imposto.ICMS.pICMSST (CSOSN900) difere do esperado');
          CheckEquals(AICMSBase.vICMSST, AICMSCompara.vICMSST, 'imposto.ICMS.vICMSST (CSOSN900) difere do esperado');
          CheckEquals(AICMSBase.vBCFCPST, AICMSCompara.vBCFCPST, 'imposto.ICMS.vBCFCPST (CSOSN900) difere do esperado');
          CheckEquals(AICMSBase.pFCPST, AICMSCompara.pFCPST, 'imposto.ICMS.pFCPST (CSOSN900) difere do esperado');
          CheckEquals(AICMSBase.vFCPST, AICMSCompara.vFCPST, 'imposto.ICMS.vFCPST (CSOSN900) difere do esperado');
          CheckEquals(AICMSBase.pCredSN, AICMSCompara.pCredSN, 'imposto.ICMS.pCredSN (CSOSN900) difere do esperado');
          CheckEquals(AICMSBase.vCredICMSSN, AICMSCompara.vCredICMSSN, 'imposto.ICMS.vCredICMSSN (CSOSN900) difere do esperado');
        end;
      //TODO: Implementar demais CSOSNs
    end;
  end;
end;

class procedure TNFeComparer.Compara_PIS(const APISBase, APISCompara: TPIS);
begin
  CheckEquals(CSTPISToStr(APISBase.CST), CSTPISToStr(APISCompara.CST), 'imposto.PIS.CST difere do esperado');

  case APISBase.CST of
    pis01, pis02: //PISAliq
      begin
        CheckEquals(APISBase.vBC, APISCompara.vBC, 'imposto.PIS.vBC difere do esperado');
        CheckEquals(APISBase.pPIS, APISCompara.pPIS, 'imposto.PIS.pPIS difere do esperado');
        CheckEquals(APISBase.vPIS, APISCompara.vPIS, 'imposto.PIS.vPIS difere do esperado');
      end;
    pis03: //PISQtde
      begin
        CheckEquals(APISBase.qBCProd, APISCompara.qBCProd, 'imposto.PIS.qBCProd difere do esperado');
        CheckEquals(APISBase.vAliqProd, APISCompara.vAliqProd, 'imposto.PIS.vAliqProd difere do esperado');
        CheckEquals(APISBase.vPIS, APISCompara.vPIS, 'imposto.PIS.vPIS difere do esperado');
      end;
    pis99: //PisOutr
      begin
        CheckEquals(APISBase.vBC, APISCompara.vBC, 'imposto.PIS.vBC (CST99) difere do esperado');
        CheckEquals(APISBase.pPIS, APISCompara.pPIS, 'imposto.PIS.pPIS (CST99) difere do esperado');
        CheckEquals(APISBase.qBCProd, APISCompara.qBCProd, 'imposto.PIS.qBCProd (CST99) difere do esperado');
        CheckEquals(APISBase.vAliqProd, APISCompara.vAliqProd, 'imposto.PIS.vAliqProd (CST99) difere do esperado');
        CheckEquals(APISBase.vPIS, APISCompara.vPIS, 'imposto.PIS.vPIS (CST99) difere do esperado');
      end;
  end;
end;

class procedure TNFeComparer.Compara_PISST(const APISSTBase, APISSTCompara: TPISST);
begin
  CheckEquals(indSomaPISSTToStr(APISSTBase.indSomaPISST), indSomaPISSTToStr(APISSTCompara.indSomaPISST), 'imposto.PISST.indSomaPISST difere do esperado');
  CheckEquals(APISSTBase.pPis, APISSTCompara.pPis, 'imposto.PISST.pPis difere do esperado');
  CheckEquals(APISSTBase.qBCProd, APISSTCompara.qBCProd, 'imposto.PISST.qBCProd difere do esperado');
  CheckEquals(APISSTBase.vAliqProd, APISSTCompara.vAliqProd, 'imposto.PISST.vAliqProd difere do esperado');
  CheckEquals(APISSTBase.vBc, APISSTCompara.vBc, 'imposto.PISST.vBc difere do esperado');
  CheckEquals(APISSTBase.vPIS, APISSTCompara.vPIS, 'imposto.PISST.vPIS difere do esperado');
end;

class procedure TNFeComparer.Compara_COFINS(const ACOFINSBase, ACOFINSCompara: TCOFINS);
begin
  CheckEquals(CSTCOFINSToStr(ACOFINSBase.CST), CSTCOFINSToStr(ACOFINSCompara.CST), 'imposto.COFINS.CST difere do esperado');

  case ACOFINSBase.CST of
    cof01, cof02: //COFINSAliq
      begin
        CheckEquals(ACOFINSBase.vBC, ACOFINSCompara.vBC, 'imposto.COFINS.vBC difere do esperado');
        CheckEquals(ACOFINSBase.pCOFINS, ACOFINSCompara.pCOFINS, 'imposto.COFINS.pCOFINS difere do esperado');
        CheckEquals(ACOFINSBase.vCOFINS, ACOFINSCompara.vCOFINS, 'imposto.COFINS.vCOFINS difere do esperado');
      end;
    cof03: //COFINSQtde
      begin
        CheckEquals(ACOFINSBase.qBCProd, ACOFINSCompara.qBCProd, 'imposto.COFINS.qBCProd difere do esperado');
        CheckEquals(ACOFINSBase.vAliqProd, ACOFINSCompara.vAliqProd, 'imposto.COFINS.vAliqProd difere do esperado');
        CheckEquals(ACOFINSBase.vCOFINS, ACOFINSCompara.vCOFINS, 'imposto.COFINS.vCOFINS difere do esperado');
      end;
    cof99: //COFINSOutr
      begin
        CheckEquals(ACOFINSBase.vBC, ACOFINSCompara.vBC, 'imposto.COFINS.vBC (CST99) difere do esperado');
        CheckEquals(ACOFINSBase.pCOFINS, ACOFINSCompara.pCOFINS, 'imposto.COFINS.pCOFINS (CST99) difere do esperado');
        CheckEquals(ACOFINSBase.qBCProd, ACOFINSCompara.qBCProd, 'imposto.COFINS.qBCProd (CST99) difere do esperado');
        CheckEquals(ACOFINSBase.vAliqProd, ACOFINSCompara.vAliqProd, 'imposto.COFINS.vAliqProd (CST99) difere do esperado');
        CheckEquals(ACOFINSBase.vCOFINS, ACOFINSCompara.vCOFINS, 'imposto.COFINS.vCOFINS (CST99) difere do esperado');
      end;
  end;
end;

class procedure TNFeComparer.Compara_COFINSST(const ACOFINSSTBase, ACOFINSSTCompara: TCOFINSST);
begin
  CheckEquals(ACOFINSSTBase.vBC, ACOFINSSTCompara.vBC, 'imposto.COFINSST.vBC difere do esperado');
  CheckEquals(ACOFINSSTBase.vAliqProd, ACOFINSSTCompara.vAliqProd, 'imposto.COFINSST.vAliqProd difere do esperado');
  CheckEquals(ACOFINSSTBase.qBCProd, ACOFINSSTCompara.qBCProd, 'imposto.COFINSST.qBCProd difere do esperado');
  CheckEquals(indSomaCOFINSSTToStr(ACOFINSSTBase.indSomaCOFINSST), indSomaCOFINSSTToStr(ACOFINSSTCompara.indSomaCOFINSST), 'imposto.COFINSST.indSomaCOFINSST difere do esperado');
  CheckEquals(ACOFINSSTBase.pCOFINS, ACOFINSSTCompara.pCOFINS, 'imposto.COFINSST.pCOFINS difere do esperado');
  CheckEquals(ACOFINSSTBase.vCOFINS, ACOFINSSTCompara.vCOFINS, 'imposto.COFINSST.vCOFINS difere do esperado');
end;

class procedure TNFeComparer.Compara_IPI(const AIPIBase, AIPICompara: TIPI);
begin
  CheckEquals(AIPIBase.CNPJProd, AIPICompara.CNPJProd, 'imposto.IPI.CNPJProd difere do esperado');
  CheckEquals(AIPIBase.cSelo, AIPICompara.cSelo, 'imposto.IPI.cSelo difere do esperado');
  CheckEquals(AIPIBase.qSelo, AIPICompara.qSelo, 'imposto.IPI.qSelo difere do esperado');
  CheckEquals(CSTIPIToStr(AIPIBase.CST), CSTIPIToStr(AIPICompara.CST), 'imposto.IPI.CST difere do esperado');
  CheckEquals(AIPIBase.vBC, AIPICompara.vBC, 'imposto.IPI.vBC difere do esperado');
  CheckEquals(AIPIBase.pIPI, AIPICompara.pIPI, 'imposto.IPI.pIPI difere do esperado');
  CheckEquals(AIPIBase.qUnid, AIPICompara.qUnid, 'imposto.IPI.qUnid difere do esperado');
  CheckEquals(AIPIBase.vUnid, AIPICompara.vUnid, 'imposto.IPI.vUnid difere do esperado');
  CheckEquals(AIPIBase.vIPI, AIPICompara.vIPI, 'imposto.IPI.vIPI difere do esperado');
end;

class procedure TNFeComparer.Compara_II(const AIIBase, AIICompara: TII);
begin
  CheckEquals(AIIBase.vBC, AIICompara.vBC, 'imposto.II.vBC difere do esperado');
  CheckEquals(AIIBase.vDespAdu, AIICompara.vDespAdu, 'imposto.II.vDespAdu difere do esperado');
  CheckEquals(AIIBase.vII, AIICompara.vII, 'imposto.II.vII difere do esperado');
  CheckEquals(AIIBase.vIOF, AIICompara.vIOF, 'imposto.II.vIOF difere do esperado');
end;

class procedure TNFeComparer.Compara_ISSQN(const AISSQNBase, AISSQNCompara: TISSQN);
begin
  CheckEquals(AISSQNBase.vBC, AISSQNCompara.vBC, 'imposto.ISSQN.vBC difere do esperado');
  CheckEquals(AISSQNBase.vAliq, AISSQNCompara.vAliq, 'imposto.ISSQN.vAliq difere do esperado');
  CheckEquals(AISSQNBase.vISSQN, AISSQNCompara.vISSQN, 'imposto.ISSQN.vISSQN difere do esperado');
  CheckEquals(AISSQNBase.cMunFG, AISSQNCompara.cMunFG, 'imposto.ISSQN.cMunFG difere do esperado');
  CheckEquals(AISSQNBase.cListServ, AISSQNCompara.cListServ, 'imposto.ISSQN.cListServ difere do esperado');
  CheckEquals(AISSQNBase.vDeducao, AISSQNCompara.vDeducao, 'imposto.ISSQN.vDeducao difere do esperado');
  CheckEquals(AISSQNBase.vOutro, AISSQNCompara.vOutro, 'imposto.ISSQN.vOutro difere do esperado');
  CheckEquals(AISSQNBase.vDescIncond, AISSQNCompara.vDescIncond, 'imposto.ISSQN.vDescIncond difere do esperado');
  CheckEquals(AISSQNBase.vDescCond, AISSQNCompara.vDescCond, 'imposto.ISSQN.vDescCond difere do esperado');
  CheckEquals(AISSQNBase.vISSRet, AISSQNCompara.vISSRet, 'imposto.ISSQN.vISSRet difere do esperado');
  CheckEquals(indISSToStr(AISSQNBase.indISS), indISSToStr(AISSQNCompara.indISS), 'imposto.ISSQN.indISS difere do esperado');
  CheckEquals(AISSQNBase.cServico, AISSQNCompara.cServico, 'imposto.ISSQN.cServico difere do esperado');
  CheckEquals(AISSQNBase.cMun, AISSQNCompara.cMun, 'imposto.ISSQN.cMun difere do esperado');
  CheckEquals(AISSQNBase.cPais, AISSQNCompara.cPais, 'imposto.ISSQN.cPais difere do esperado');
  CheckEquals(AISSQNBase.nProcesso, AISSQNCompara.nProcesso, 'imposto.ISSQN.nProcesso difere do esperado');
  CheckEquals(indIncentivoToStr(AISSQNBase.indIncentivo), indIncentivoToStr(AISSQNCompara.indIncentivo), 'imposto.ISSQN.indIncentivo difere do esperado');
end;

class procedure TNFeComparer.Compara_IS(const AISBase, AISCompara: TgIS);
begin
  CheckEquals(AISBase.cClassTribIS, AISCompara.cClassTribIS, 'imposto.IS.cClassTribIS difere do esperado');
  CheckEquals(CSTISToStr(AISBase.CSTIS), CSTISToStr(AISCompara.CSTIS), 'imposto.IS.CSTIS difere do esperado');
  CheckEquals(AISBase.pIS, AISCompara.pIS, 'imposto.IS.pIS difere do esperado');
  CheckEquals(AISBase.pISEspec, AISCompara.pISEspec, 'imposto.IS.pISEspec difere do esperado');
  CheckEquals(AISBase.qTrib, AISCompara.qTrib, 'imposto.IS.qTrib difere do esperado');
  CheckEquals(AISBase.uTrib, AISCompara.uTrib, 'imposto.IS.uTrib difere do esperado');
  CheckEquals(AISBase.vBCIS, AISCompara.vBCIS, 'imposto.IS.vBCIS difere do esperado');
  CheckEquals(AISBase.vIS, AISCompara.vIS, 'imposto.IS.vIS difere do esperado');
end;

class procedure TNFeComparer.Compara_IBSCBS(const AIBSCBSBase, AIBSCBSCompara: TIBSCBS);
begin
  CheckEquals(CSTIBSCBSToStr(AIBSCBSBase.CST), CSTIBSCBSToStr(AIBSCBSCompara.CST), 'imposto.IBSCBS.CST difere do esperado');
  CheckEquals(AIBSCBSBase.cClassTrib, AIBSCBSCompara.cClassTrib, 'imposto.IBSCBS.cClassTrib difere do esperado');

  Compara_gIBSCBS(AIBSCBSBase.gIBSCBS, AIBSCBSCompara.gIBSCBS);
  Compara_gIBSCBSMono(AIBSCBSBase.gIBSCBSMono, AIBSCBSCompara.gIBSCBSMono);
  Compara_gTransfCred(AIBSCBSBase.gTransfCred, AIBSCBSCompara.gTransfCred);
  Compara_gCredPresIBSZFM(AIBSCBSBAse.gCredPresIBSZFM, AIBSCBSCompara.gCredPresIBSZFM);
end;

class procedure TNFeComparer.Compara_gIBSCBS(const AIBSCBSBase, AIBSCBSCompara: TgIBSCBS);
  procedure Compara_gDif(const AGDifBase, AGDifCompara: TgDif; const AOrig: String);
  begin
    CheckEquals(AGDifBase.pDif, AGDifCompara.pDif, Format('%s.gDif.pDif difere do esperado', [AOrig]));
    CheckEquals(AGDifBase.vDif, AGDifCompara.vDif, Format('%s.gDif.vDif difere do esperado', [AOrig]));
  end;
  procedure Compara_gRed(const AGRedBase, AGRedCompara: TgRed; const AOrig: String);
  begin
    CheckEquals(AGRedBase.pAliqEfet, AGRedCompara.pAliqEfet, Format('%s.gRed.pAliqEfet difere do esperado', [AOrig]));
    CheckEquals(AGRedBase.pRedAliq,  AGRedCompara.pRedAliq,  Format('%s.gRed.pRedAliq difere do esperado', [AOrig]));
  end;
  procedure Compara_gTribRegular(const AGTribRegularBase, AGTribRegularCompara: TgTribRegular);
  begin
    CheckEquals(CSTIBSCBSToStr(AGTribRegularBase.CSTReg), CSTIBSCBSToStr(AGTribRegularCompara.CSTReg), 'gTribRegular.CSTReg difere do esperado');
    CheckEquals(AGTribRegularBase.cClassTribReg, AGTribRegularCompara.cClassTribReg, 'gTribRegular.cClassTribReg difere do esperado');
    CheckEquals(AGTribRegularBase.pAliqEfetRegCBS, AGTribRegularCompara.pAliqEfetRegCBS, 'gTribRegular.pAliqEfetRegCBS difere do esperado');
    CheckEquals(AGTribRegularBase.pAliqEfetRegIBSMun, AGTribRegularCompara.pAliqEfetRegIBSMun, 'gTribRegular.pAliqEfetRegIBSMun difere do esperado');
    CheckEquals(AGTribRegularBase.pAliqEfetRegIBSUF, AGTribRegularCompara.pAliqEfetRegIBSUF, 'gTribRegular.pAliqEfetRegIBSUF difere do esperado');
    CheckEquals(AGTribRegularBase.vTribRegCBS, AGTribRegularCompara.vTribRegCBS, 'gTRibRegular.vTribRegCBS difere do esperado');
    CheckEquals(AGTribRegularBase.vTribRegIBSMun, AGTribRegularCompara.vTribRegIBSMun, 'gTribRegular.vTribRegIBSMun difere do esperado');
    CheckEquals(AGTribRegularBase.vTribRegIBSUF, AGTribRegularCompara.vTribRegIBSUF, 'gTribRegular.vTribRegIBSUF difere do esperado');
  end;
  procedure Compara_gCredPres(const ACredPresBase, ACredPresCompara: TgIBSCBSCredPres; const AOrig: String);
  begin
    CheckEquals(cCredPresToStr(ACredPresBase.cCredPres), cCredPresToStr(ACredPresCompara.cCredPres), Format('%s.cCredPres difere do esperado', [AOrig]));
    CheckEquals(ACredPresBase.pCredPres, ACredPresCompara.pCredPres, Format('%s.pCredPres difere do esperado', [AOrig]));
    CheckEquals(ACredPresBase.vCredPres, ACredPresCompara.vCredPres, Format('%s.vCredPres difere do esperado', [AOrig]));
    CheckEquals(ACredPresBase.vCredPresCondSus, ACredPresCompara.vCredPresCondSus, Format('%s.vCredPresCondSus difere do esperad', [AOrig]));
  end;
  procedure Compara_gTribCompraGov(const ATribCompraGovBase, ATribCompraGovCompara: TgTribCompraGov);
  begin
    CheckEquals(ATribCompraGovBase.pAliqCBS, ATribCompraGovCompara.pAliqCBS, 'gTribCompraGov.pAliqCBS difere do esperado');
    CheckEquals(ATribCompraGovBase.pAliqIBSMun, ATribCompraGovCompara.pAliqIBSMun, 'gTribCompraGov.pAliqIBSMun difere do esperado');
    CheckEquals(ATribCompraGovBase.pAliqIBSUF, ATribCompraGovCompara.pAliqIBSUF, 'gTribCompraGov.pAliqIBSUF difere do esperado');
    CheckEquals(ATribCompraGovBase.vTribCBS, ATribCompraGovCompara.vTribCBS, 'gTribCompraGov.vTribCBS difere do esperado');
    CheckEquals(ATribCompraGovBase.vTribIBSMun, ATribCompraGovCompara.vTribIBSMun, 'gTribCompraGov.vTribIBSMun difere do esperado');
    CheckEquals(ATribCompraGovBase.vTribIBSUF, ATribCompraGovCompara.vTribIBSUF, 'gTribCompraGov.vTribIBSUF difere do esperado');
  end;

begin
  CheckEquals(AIBSCBSBase.vBC, AIBSCBSCompara.vBC, 'IBSCBS.gIBSCBS.vBC difere do esperado');
  CheckEquals(AIBSCBSBase.vIBS, AIBSCBSCompara.vIBS, 'IBSCBS.gIBSCBS.vIBS difere do esperado');

  //gIBSUF---
  CheckEquals(AIBSCBSBase.gIBSUF.pIBSUF, AIBSCBSCompara.gIBSUF.pIBSUF, 'gIBSCBS.gIBSUF.pIBSUF difere do esperado');
  CheckEquals(AIBSCBSBase.gIBSUF.vIBSUF, AIBSCBSCompara.gIBSUF.vIBSUF, 'gIBSCBS.gIBSUF.vIBSUF difere do esperado');
  //gDevTrib
  CheckEquals(AIBSCBSBase.gIBSUF.gDevTrib.vDevTrib, AIBSCBSCompara.gIBSUF.gDevTrib.vDevTrib, 'gIBSUF.gDevTrib.vDevTrib difere do esperado');
  //gDif
  Compara_gDif(AIBSCBSBase.gIBSUF.gDif, AIBSCBSCompara.gIBSUF.gDif, 'gIBSUF');
  //gRed
  Compara_gRed(AIBSCBSBase.gIBSUF.gRed, AIBSCBSCompara.gIBSUF.gRed, 'gIBSUF');

  //gIBSMun---
  CheckEquals(AIBSCBSBase.gIBSMun.pIBSMun, AIBSCBSCompara.gIBSMun.pIBSMun, 'gIBSCBS.gIBSMun.pIBSMun difere do esperado');
  CheckEquals(AIBSCBSBase.gIBSMun.vIBSMun, AIBSCBSCompara.gIBSMun.vIBSMun, 'gIBSCBS.gIBSMun.vIBSMun difere do esperado');
  //gDevTrib
  CheckEquals(AIBSCBSBase.gIBSMun.gDevTrib.vDevTrib, AIBSCBSCompara.gIBSMun.gDevTrib.vDevTrib, 'gIBSMun.gDevTrib.vDevTrib difere do esperado');
  //gDif
  Compara_gDif(AIBSCBSBase.gIBSMun.gDif, AIBSCBSCompara.gIBSMun.gDif, 'gIBSMun');
  //gRed
  Compara_gRed(AIBSCBSBase.gIBSMun.gRed, AIBSCBSCompara.gIBSMun.gRed, 'gIBSMun');
  //gCBS---
  CheckEquals(AIBSCBSBase.gCBS.pCBS, AIBSCBSCompara.gCBS.pCBS, 'gIBSCBS.gCBS.pCBS difere do esperado');
  CheckEquals(AIBSCBSBase.gCBS.vCBS, AIBSCBSCompara.gCBS.vCBS, 'gIBSCBS.gCBS.vCBS difere do esperado');
  //gDevTrib
  CheckEquals(AIBSCBSBase.gCBS.gDevTrib.vDevTrib, AIBSCBSCompara.gCBS.gDevTrib.vDevTrib, 'gCBS.gDevTrib.vDevTrib difere do esperado');
  //gDif
  Compara_gDif(AIBSCBSBase.gCBS.gDif, AIBSCBSCompara.gCBS.gDif, 'gCBS');
  //gRed
  Compara_gRed(AIBSCBSBase.gCBS.gRed, AIBSCBSCompara.gCBS.gRed, 'gCBS');
  //---
  Compara_gTribRegular(AIBSCBSBase.gTribRegular, AIBSCBSCompara.gTribRegular);
  //---
  Compara_gCredPres(AIBSCBSBase.gIBSCredPres, AIBSCBSCompara.gIBSCredPres, 'gIBSCredPres');
  Compara_gCredPres(AIBSCBSBase.gCBSCredPres, AIBSCBSCompara.gCBSCredPres, 'gCBSCredPres');
  //---
  Compara_gTribCompraGov(AIBSCBSBase.gTribCompraGov, AIBSCBSCompara.gTribCompraGov);
end;

class procedure TNFeComparer.Compara_gIBSCBSMono(const AIBSCBSMonoBase, AIBSCBSMonoCompara: TgIBSCBSMono);
begin

  //gMonoPadrao
  CheckEquals(AIBSCBSMonoBase.gMonoPadrao.qBCMono, AIBSCBSMonoCompara.gMonoPadrao.qBCMono, 'gIBSCBSMono.qBCMono difere do esperado');
  CheckEquals(AIBSCBSMonoBase.gMonoPadrao.adRemIBS, AIBSCBSMonoCompara.gMonoPadrao.adRemIBS, 'gIBSCBSMono.adRemIBS difere do esperado');
  CheckEquals(AIBSCBSMonoBase.gMonoPadrao.adRemCBS, AIBSCBSMonoCompara.gMonoPadrao.adRemCBS, 'gIBSCBSMono.adRemCBS difere do esperado');
  CheckEquals(AIBSCBSMonoBase.gMonoPadrao.vIBSMono, AIBSCBSMonoCompara.gMonoPadrao.vIBSMono, 'gIBSCBSMono.vIBSMono difere do esperado');
  CheckEquals(AIBSCBSMonoBase.gMonoPadrao.vCBSMono, AIBSCBSMonoCompara.gMonoPadrao.vCBSMono, 'gIBSCBSMono.vCBSMono difere do esperado');

  //gMonoReten
  CheckEquals(AIBSCBSMonoBase.gMonoReten.qBCMonoReten, AIBSCBSMonoCompara.gMonoReten.qBCMonoReten, 'gIBSCBSMono.qBCMonoReten difere do esperado');
  CheckEquals(AIBSCBSMonoBase.gMonoReten.adRemIBSReten, AIBSCBSMonoCompara.gMonoReten.adRemIBSReten, 'gIBSCBSMono.adRemIBSReten difere do esperado');
  CheckEquals(AIBSCBSMonoBase.gMonoReten.adRemCBSReten, AIBSCBSMonoCompara.gMonoReten.adRemCBSReten, 'gIBSCBSMono.adRemCBSReten difere do esperado');
  CheckEquals(AIBSCBSMonoBase.gMonoReten.vIBSMonoReten, AIBSCBSMonoCompara.gMonoReten.vIBSMonoReten, 'gIBSCBSMono.vIBSMonoReten difere do esperado');
  CheckEquals(AIBSCBSMonoBase.gMonoReten.vCBSMonoReten, AIBSCBSMonoCompara.gMonoReten.vCBSMonoReten, 'gIBSCBSMono.vCBSMonoReten difere do esperado');

  //gMonoRet
  CheckEquals(AIBSCBSMonoBase.gMonoRet.qBCMonoRet, AIBSCBSMonoCompara.gMonoRet.qBCMonoRet, 'gIBSCBSMono.qBCMonoRet difere do esperado');
  CheckEquals(AIBSCBSMonoBase.gMonoRet.adRemIBSRet, AIBSCBSMonoCompara.gMonoRet.adRemIBSRet, 'gIBSCBSMono.adRemIBSRet difere do esperado');
  CheckEquals(AIBSCBSMonoBase.gMonoRet.adRemCBSRet, AIBSCBSMonoCompara.gMonoRet.adRemCBSRet, 'gIBSCBSMono.adRemCBSRet difere do esperado');
  CheckEquals(AIBSCBSMonoBase.gMonoRet.vIBSMonoRet, AIBSCBSMonoCompara.gMonoRet.vIBSMonoRet, 'gIBSCBSMono.vIBSMonoRet difere do esperado');
  CheckEquals(AIBSCBSMonoBase.gMonoRet.vCBSMonoRet, AIBSCBSMonoCompara.gMonoRet.vCBSMonoRet, 'gIBSCBSMono.vCBSMonoRet difere do esperado');

  //gMonoDif
  CheckEquals(AIBSCBSMonoBase.gMonoDif.pDifIBS, AIBSCBSMonoCompara.gMonoDif.pDifIBS, 'gIBSCBSMono.pDifIBS difere do esperado');
  CheckEquals(AIBSCBSMonoBase.gMonoDif.vIBSMonoDif, AIBSCBSMonoCompara.gMonoDif.vIBSMonoDif, 'gIBSCBSMono.vIBSMonoDif difere do esperado');
  CheckEquals(AIBSCBSMonoBase.gMonoDif.pDifCBS, AIBSCBSMonoCompara.gMonoDif.pDifCBS, 'gIBSCBSMono.pDifCBS difere do esperado');
  CheckEquals(AIBSCBSMonoBase.gMonoDif.vCBSMonoDif, AIBSCBSMonoCompara.gMonoDif.vCBSMonoDif, 'gIBSCBSMono.vCBSMonoDif difere do esperado');

  //...
  CheckEquals(AIBSCBSMonoBase.vTotIBSMonoItem, AIBSCBSMonoCompara.vTotIBSMonoItem, 'gIBSCBSMono.vTotIBSMonoItem difere do esperado');
  CheckEquals(AIBSCBSMonoBase.vTotCBSMonoItem, AIBSCBSMonoCompara.vTotCBSMonoItem, 'gIBSCBSMono.vTotCBSMonoItem difere do esperado');
end;

class procedure TNFeComparer.Compara_gTransfCred(const ATransfCredBase, ATransfCredCompara: TgTransfCred);
begin
  CheckEquals(ATransfCredBase.vIBS, ATransfCredCompara.vIBS, 'gTransfCred.vIBS difere do esperado');
  CheckEquals(ATransfCredBase.vCBS, ATransfCredCompara.vCBS, 'gTransfCred.vCBS difere do esperado');
end;

class procedure TNFeComparer.Compara_gCredPresIBSZFM(const ACredPresIBSZFMBase, ACredPresIBSZFMCompara: TCredPresIBSZFM);
begin
  CheckEquals(TpCredPresIBSZFMToStr(ACredPresIBSZFMBase.tpCredPresIBSZFM), TpCredPresIBSZFMToStr(ACredPresIBSZFMCompara.tpCredPresIBSZFM), 'gCredPresIBSZFM.tpCredPresIBSZFM difere do esperado');
  CheckEquals(ACredPresIBSZFMBase.vCredPresIBSZFM, ACredPresIBSZFMCompara.vCredPresIBSZFM, 'gCredPresIBSZFM.vCredPresIBSZFM difere do esperado');
end;

class procedure TNFeComparer.Compara_total(const ATotalBase, ATotalCompara: TTotal);
begin
  // --- Totais do ICMS ---
  CheckEquals(ATotalBase.ICMSTot.vBC, ATotalCompara.ICMSTot.vBC, 'total.ICMSTot.vBC difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vICMS, ATotalCompara.ICMSTot.vICMS, 'total.ICMSTot.vICMS difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vICMSDeson, ATotalCompara.ICMSTot.vICMSDeson, 'total.ICMSTot.vICMSDeson difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vFCPUFDest, ATotalCompara.ICMSTot.vFCPUFDest, 'total.ICMSTot.vFCPUFDest difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vICMSUFDest, ATotalCompara.ICMSTot.vICMSUFDest, 'total.ICMSTot.vICMSUFDest difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vICMSUFRemet, ATotalCompara.ICMSTot.vICMSUFRemet, 'total.ICMSTot.vICMSUFRemet difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vFCP, ATotalCompara.ICMSTot.vFCP, 'total.ICMSTot.vFCP difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vBCST, ATotalCompara.ICMSTot.vBCST, 'total.ICMSTot.vBCST difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vST, ATotalCompara.ICMSTot.vST, 'total.ICMSTot.vST difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vFCPST, ATotalCompara.ICMSTot.vFCPST, 'total.ICMSTot.vFCPST difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vFCPSTRet, ATotalCompara.ICMSTot.vFCPSTRet, 'total.ICMSTot.vFCPSTRet difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vProd, ATotalCompara.ICMSTot.vProd, 'total.ICMSTot.vProd difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vFrete, ATotalCompara.ICMSTot.vFrete, 'total.ICMSTot.vFrete difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vSeg, ATotalCompara.ICMSTot.vSeg, 'total.ICMSTot.vSeg difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vDesc, ATotalCompara.ICMSTot.vDesc, 'total.ICMSTot.vDesc difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vII, ATotalCompara.ICMSTot.vII, 'total.ICMSTot.vII difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vIPI, ATotalCompara.ICMSTot.vIPI, 'total.ICMSTot.vIPI difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vIPIDevol, ATotalCompara.ICMSTot.vIPIDevol, 'total.ICMSTot.vIPIDevol difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vPIS, ATotalCompara.ICMSTot.vPIS, 'total.ICMSTot.vPIS difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vCOFINS, ATotalCompara.ICMSTot.vCOFINS, 'total.ICMSTot.vCOFINS difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vOutro, ATotalCompara.ICMSTot.vOutro, 'total.ICMSTot.vOutro difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vNF, ATotalCompara.ICMSTot.vNF, 'total.ICMSTot.vNF difere do esperado');
  CheckEquals(ATotalBase.ICMSTot.vTotTrib, ATotalCompara.ICMSTot.vTotTrib, 'total.ICMSTot.vTotTrib difere do esperado');

  // --- Totais do IS ---
  CheckEquals(ATotalBase.ISTot.vIS, ATotalCompara.ISTot.vIS, 'total.ISTot.vIS difere do esperado');

  // --- Totais do IBSCBS ---
  CheckEquals(ATotalBase.IBSCBSTot.vBCIBSCBS, ATotalCompara.IBSCBSTot.vBCIBSCBS, 'total.IBSCBSTot.vBCIBSCBS difere do esperado');
  //--gIBS
  CheckEquals(ATotalBase.IBSCBSTot.gIBS.vIBS, ATotalCompara.IBSCBSTot.gIBS.vIBS, 'IBSCBSTot.gIBS.vIBS difere do esperado');
  CheckEquals(ATotalBase.IBSCBSTot.gIBS.vCredPres, ATotalCompara.IBSCBSTot.gIBS.vCredPres, 'IBSCBSTot.gIBS.vCredPres difere do esperado');
  CheckEquals(ATotalBase.IBSCBSTot.gIBS.vCredPresCondSus, ATotalCompara.IBSCBSTot.gIBS.vCredPresCondSus, 'IBSCBSTot.vCredPresCondSus difere do esperado');
  //---gIBSUF
  CheckEquals(ATotalBase.IBSCBSTot.gIBS.gIBSUFTot.vDif, ATotalCompara.IBSCBSTot.gIBS.gIBSUFTot.vDif, 'gIBS.gIBSUFTot.vDif difere do esperado');
  CheckEquals(ATotalBase.IBSCBSTot.gIBS.gIBSUFTot.vDevTrib, ATotalCompara.IBSCBSTot.gIBS.gIBSUFTot.vDevTrib, 'gIBS.gIBSUFTot.vDevTrib difere do esperado');
  CheckEquals(ATotalBase.IBSCBSTot.gIBS.gIBSUFTot.vIBSUF, ATotalCompara.IBSCBSTot.gIBS.gIBSUFTot.vIBSUF, 'gIBS.gIBSUFTot.vIBSUF difere do esperado');
  //---gIBSMun
  CheckEquals(ATotalBase.IBSCBSTot.gIBS.gIBSMunTot.vDif, ATotalCompara.IBSCBSTot.gIBS.gIBSMunTot.vDif, 'gIBS.gIBSMunTot.vDif difere do esperado');
  CheckEquals(ATotalBase.IBSCBSTot.gIBS.gIBSMunTot.vDevTrib, ATotalCompara.IBSCBSTot.gIBS.gIBSMunTot.vDevTrib, 'gIBS.gIBSMunTot.vDevTrib difere do esperado');
  CheckEquals(ATotalBase.IBSCBSTot.gIBS.gIBSMunTot.vIBSMun, ATotalCompara.IBSCBSTot.gIBS.gIBSMunTot.vIBSMun, 'gIBS.gIBSMunTot.vIBSMun difere do esperado');
  //--gCBS
  CheckEquals(ATotalBase.IBSCBSTot.gCBS.vDif, ATotalCompara.IBSCBSTot.gCBS.vDif, 'IBSCBSTot.gCBS.vDif difere do esperado');
  CheckEquals(ATotalBase.IBSCBSTot.gCBS.vDevTrib, ATotalCompara.IBSCBSTot.gCBS.vDevTrib, 'IBSCBSTot.gCBS.vDevTrib difere do esperado');
  CheckEquals(ATotalBase.IBSCBSTot.gCBS.vCBS, ATotalCompara.IBSCBSTot.gCBS.vCBS, 'IBSCBSTot.gCBS.vCBS difere do esperado');
  CheckEquals(ATotalBase.IBSCBSTot.gCBS.vCredPres, ATotalCompara.IBSCBSTot.gCBS.vCredPres, 'IBSCBSTot.gCBS.vCredPres difere do esperado');
  CheckEquals(ATotalBase.IBSCBSTot.gCBS.vCredPresCondSus, ATotalCompara.IBSCBSTot.gCBS.vCredPresCondSus, 'IBSCBSTot.gCBS.vCredPresCondSus difere do esperado');
  //--gMono
  CheckEquals(ATotalBase.IBSCBSTot.gMono.vCBSMono, ATotalCompara.IBSCBSTot.gMono.vCBSMono, 'IBSCBSTot.gMono.vCBSMono difere do esperado');
  CheckEquals(ATotalBase.IBSCBSTot.gMono.vIBSMono, ATotalCompara.IBSCBSTot.gMono.vIBSMono, 'IBSCBSTot.gMono.vIBSMono difere do esperado');
  CheckEquals(ATotalBase.IBSCBSTot.gMono.vIBSMonoReten, ATotalCompara.IBSCBSTot.gMono.vIBSMonoReten, 'IBSCBSTot.gMono.vIBSMonoReten difere do esperado');
  CheckEquals(ATotalBase.IBSCBSTot.gMono.vCBSMonoReten, ATotalCompara.IBSCBSTot.gMono.vCBSMonoReten, 'IBSCBSTot.gMono.vCBSMonoReten difere do esperado');
  CheckEquals(ATotalBase.IBSCBSTot.gMono.vIBSMonoRet, ATotalCompara.IBSCBSTot.gMono.vIBSMonoRet, 'IBSCBSTot.gMono.vIBSMonoRet difere do esperado');
  CheckEquals(ATotalBase.IBSCBSTot.gMono.vCBSMonoRet, ATotalCompara.IBSCBSTot.gMono.vCBSMonoRet, 'IBSCBSTot.gMono.vCBSMonoRet difere do esperado');

  // --- Totais do ISSQN ---
  CheckEquals(ATotalBase.ISSQNtot.vServ, ATotalCompara.ISSQNtot.vServ, 'total.ISSQNtot.vServ difere do esperado');
  CheckEquals(ATotalBase.ISSQNtot.vBC, ATotalCompara.ISSQNtot.vBC, 'total.ISSQNtot.vBC difere do esperado');
  CheckEquals(ATotalBase.ISSQNtot.vISS, ATotalCompara.ISSQNtot.vISS, 'total.ISSQNtot.vISS difere do esperado');
  CheckEquals(ATotalBase.ISSQNtot.vPIS, ATotalCompara.ISSQNtot.vPIS, 'total.ISSQNtot.vPIS difere do esperado');
  CheckEquals(ATotalBase.ISSQNtot.vCOFINS, ATotalCompara.ISSQNtot.vCOFINS, 'total.ISSQNtot.vCOFINS difere do esperado');
  CheckEquals(ATotalBase.ISSQNtot.dCompet, ATotalCompara.ISSQNtot.dCompet, 'total.ISSQNtot.dCompet difere do esperado');
  CheckEquals(ATotalBase.ISSQNtot.vDeducao, ATotalCompara.ISSQNtot.vDeducao, 'total.ISSQNtot.vDeducao difere do esperado');
  CheckEquals(ATotalBase.ISSQNtot.vOutro, ATotalCompara.ISSQNtot.vOutro, 'total.ISSQNtot.vOutro difere do esperado');
  CheckEquals(ATotalBase.ISSQNtot.vDescIncond, ATotalCompara.ISSQNtot.vDescIncond, 'total.ISSQNtot.vDescIncond difere do esperado');
  CheckEquals(ATotalBase.ISSQNtot.vDescCond, ATotalCompara.ISSQNtot.vDescCond, 'total.ISSQNtot.vDescCond difere do esperado');
  CheckEquals(ATotalBase.ISSQNtot.vISSRet, ATotalCompara.ISSQNtot.vISSRet, 'total.ISSQNtot.vISSRet difere do esperado');
  CheckEquals(RegTribISSQNToStr(ATotalBase.ISSQNtot.cRegTrib), RegTribISSQNToStr(ATotalCompara.ISSQNtot.cRegTrib), 'total.ISSQNtot.cRegTrib difere do esperado');

  // --- Retenções de Tributos ---
  CheckEquals(ATotalBase.retTrib.vRetPIS, ATotalCompara.retTrib.vRetPIS, 'total.retTrib.vRetPIS difere do esperado');
  CheckEquals(ATotalBase.retTrib.vRetCOFINS, ATotalCompara.retTrib.vRetCOFINS, 'total.retTrib.vRetCOFINS difere do esperado');
  CheckEquals(ATotalBase.retTrib.vRetCSLL, ATotalCompara.retTrib.vRetCSLL, 'total.retTrib.vRetCSLL difere do esperado');
  CheckEquals(ATotalBase.retTrib.vBCIRRF, ATotalCompara.retTrib.vBCIRRF, 'total.retTrib.vBCIRRF difere do esperado');
  CheckEquals(ATotalBase.retTrib.vIRRF, ATotalCompara.retTrib.vIRRF, 'total.retTrib.vIRRF difere do esperado');
  CheckEquals(ATotalBase.retTrib.vBCRetPrev, ATotalCompara.retTrib.vBCRetPrev, 'total.retTrib.vBCRetPrev difere do esperado');
  CheckEquals(ATotalBase.retTrib.vRetPrev, ATotalCompara.retTrib.vRetPrev, 'total.retTrib.vRetPrev difere do esperado');

  CheckEquals(ATotalBase.vNFTot, ATotalCompara.vNFTot, 'total.vNFTot difere do esperado');
end;

class procedure TNFeComparer.Compara_transp(const ATranspBase, ATranspCompara: TTransp);
var
  i, j: Integer;
begin
  CheckEquals(modFreteToStr(ATranspBase.modFrete), modFreteToStr(ATranspCompara.modFrete), 'transp.modFrete difere do esperado');
  //-Transporta
  CheckEquals(ATranspBase.Transporta.CNPJCPF, ATranspCompara.Transporta.CNPJCPF, 'transp.Transporta.CNPJCPF difere do esperado');
  CheckEquals(ATranspBase.Transporta.xNome, ATranspCompara.Transporta.xNome, 'transp.Transporta.xNome difere do esperado');
  CheckEquals(ATranspBase.Transporta.IE, ATranspCompara.Transporta.IE, 'transp.Transporta.IE difere do esperado');
  CheckEquals(ATranspBase.Transporta.xEnder, ATranspCompara.Transporta.xEnder, 'transp.Transporta.xEnder difere do esperado');
  CheckEquals(ATranspBase.Transporta.xMun, ATranspCompara.Transporta.xMun, 'transp.Transporta.xMun difere do esperado');
  CheckEquals(ATranspBase.Transporta.UF, ATranspCompara.Transporta.UF, 'transp.Transporta.UF difere do esperado');
  //-retTransp
  CheckEquals(ATranspBase.retTransp.vServ, ATranspCompara.retTransp.vServ, 'transp.retTransp.vServ difere do esperado');
  CheckEquals(ATranspBase.retTransp.vBCRet, ATranspCompara.retTransp.vBCRet, 'transp.retTransp.vBCRet difere do esperado');
  CheckEquals(ATranspBase.retTransp.pICMSRet, ATranspCompara.retTransp.pICMSRet, 'transp.retTransp.pICMSRet difere do esperado');
  CheckEquals(ATranspBase.retTransp.CFOP, ATranspCompara.retTransp.CFOP, 'transp.retTransp.CFOP difere do esperado');
  CheckEquals(ATranspBase.retTransp.cMunFG, ATranspCompara.retTransp.cMunFG, 'transp.retTransp.cMunFG difere do esperado');
  //-veicTransp
  CheckEquals(ATranspBase.veicTransp.placa, ATranspCompara.veicTransp.placa, 'transp.veicTransp.placa difere do esperado');
  CheckEquals(ATranspBase.veicTransp.UF, ATranspCompara.veicTransp.UF, 'transp.veicTransp.UF difere do esperado');
  CheckEquals(ATranspBase.veicTransp.RNTC, ATranspCompara.veicTransp.RNTC, 'transp.veicTransp.RNTC difere do esperado');
  //-reboque
  if ATranspBase.Reboque.Count <> ATranspCompara.Reboque.Count then
  begin
    Fail(Format('Reboque.Count difere do esperado. Esperado: %d, Obtido: %d', [ATranspBase.Reboque.Count, ATranspCompara.Reboque.Count]));
    Exit;
  end;
  for i := 0 to ATranspBase.Reboque.Count - 1 do
  begin
    CheckEquals(ATranspBase.Reboque[i].placa, ATranspCompara.Reboque[i].placa, Format('transp.Reboque[%d].placa difere do esperado', [i]));
    CheckEquals(ATranspBase.Reboque[i].UF, ATranspCompara.Reboque[i].UF, Format('transp.Reboque[%d].UF difere do esperado', [i]));
    CheckEquals(ATranspBase.Reboque[i].RNTC, ATranspCompara.Reboque[i].RNTC, Format('transp.Reboque[%d].RNTC difere do esperado', [i]));
  end;
  //-
  CheckEquals(ATranspBase.vagao, ATranspCompara.vagao, 'transp.vagao difere do esperado');
  CheckEquals(ATranspBase.balsa, ATranspCompara.balsa, 'transp.balsa difere do esperado');
  //-
  if ATranspBase.Vol.Count <> ATranspCompara.Vol.Count then
  begin
    Fail(Format('Vol.Count difere do esperado. Esperado: %d, Obtido: %d', [ATranspBase.Vol.Count, ATranspCompara.Vol.Count]));
    Exit;
  end;
  for i := 0 to ATranspBase.Vol.Count - 1 do
  begin
    CheckEquals(ATranspBase.Vol[i].qVol, ATranspCompara.Vol[i].qVol, Format('transp.Vol[%d].qVol difere do esperado', [i]));
    CheckEquals(ATranspBase.Vol[i].esp, ATranspCompara.Vol[i].esp, Format('transp.Vol[%d].esp difere do esperado', [i]));
    CheckEquals(ATranspBase.Vol[i].marca, ATranspCompara.Vol[i].marca, Format('transp.Vol[%d].marca difere do esperado', [i]));
    CheckEquals(ATranspBase.Vol[i].nVol, ATranspCompara.Vol[i].nVol, Format('transp.Vol[%d].nVol difere do esperado', [i]));
    CheckEquals(ATranspBase.Vol[i].pesoL, ATranspCompara.Vol[i].pesoL, Format('transp.Vol[%d].pesoL difere do esperado', [i]));
    CheckEquals(ATranspBase.Vol[i].pesoB, ATranspCompara.Vol[i].pesoB, Format('transp.Vol[%d].pesoB difere do esperado', [i]));
    if ATranspBase.Vol[i].Lacres.Count <> ATranspCompara.Vol[i].Lacres.Count then
    begin
      Fail(Format('Vol[%d].Lacres.Count difere do esperado. Esperado: %d, Obtido: %d', [ATranspBase.Vol.Count, ATranspBase.Vol[i].Lacres.Count, ATranspCompara.Vol[i].Lacres.Count]));
      break;
    end;
    for j := 0 to ATranspBase.Vol[i].Lacres.Count - 1 do
      CheckEquals(ATranspBase.Vol[i].Lacres[j].nLacre, ATranspCompara.Vol[i].Lacres[j].nLacre, Format('Vol[%d].Lacres[%d].nLacre difere do esperado', [i,j]));
  end;
end;

class procedure TNFeComparer.Compara_cobr(const ACobrBase, ACobrCompara: TCobr);
var
  i: Integer;
begin
  //-fat
  CheckEquals(ACobrBase.fat.nFat,  ACobrCompara.fat.nFat, 'fat.nFat difere do esperado');
  CheckEquals(ACobrBase.fat.vOrig, ACobrCompara.fat.vOrig, 'fat.vOrig difere do esperado');
  CheckEquals(ACobrBase.fat.vDesc, ACobrCompara.fat.vDesc, 'fat.vDesc difere do esperado');
  CheckEquals(ACobrBase.fat.vLiq,  ACobrCompara.fat.vLiq, 'fat.vLiq difere do esperado');
  //-dup
  if ACobrBase.Dup.Count <> ACobrCompara.Dup.Count then
  begin
    Fail(Format('Dup.Count difere do esperado. Esperado: %d, Obtido: %d', [ACobrBase.Dup.Count, ACobrCompara.Dup.Count]));
    exit;
  end;
  for i := 0 to ACobrBase.Dup.Count - 1 do
  begin
    CheckEquals(ACobrBase.Dup[i].nDup,  ACobrCompara.Dup[i].nDup, Format('Dup[%d].nDup difere do esperado', [i]));
    CheckEquals(ACobrBase.Dup[i].dVenc, ACobrCompara.Dup[i].dVenc, Format('Dup[%d].dVenc difere do esperado', [i]));
    CheckEquals(ACobrBase.Dup[i].vDup, ACobrCompara.Dup[i].vDup, Format('Dup[%d].vDup difere do esperado', [i]));
  end;
end;

class procedure TNFeComparer.Compara_pag(const APagBase, APagCompara: TpagCollection);
var
  i: Integer;
begin
  if APagBase.Count <> APagCompara.Count then
  begin
    Fail(Format('detPag.Count difere do esperado. Esperado: %d, Obtido: %d', [APagBase.Count, APagCompara.Count]));
    exit;
  end;
  for i := 0 to APagBase.Count - 1 do
  begin
    CheckEquals(IndpagToStrEX(APagBase[i].indPag), IndpagToStrEX(APagCompara[i].indPag), Format('detPag[%d].indPag difere do esperado', [i]));
    CheckEquals(FormaPagamentoToStr(APagBase[i].tPag), FormaPagamentoToStr(APagCompara[i].tPag), Format('detPag[%d].tPag difere do esperado', [i]));
    CheckEquals(APagBase[i].xPag, APagCompara[i].xPag, Format('detPag[%d].xPag difere do esperado', [i]));
    CheckEquals(APagBase[i].vPag, APagCompara[i].vPag, Format('detPag[%d].vPag difere do esperado', [i]));
    CheckEquals(APagBase[i].dPag, APagCompara[i].dPag, Format('detPag[%d].dPag difere do esperado', [i]));
    CheckEquals(APagBase[i].CNPJPag, APagCompara[i].CNPJPag, Format('detPag[%d].CNPJPag difere do esperado', [i]));
    CheckEquals(APagBase[i].UFPag, APagCompara[i].UFPag, Format('detPag[%d].UFPag difere do esperado', [i]));
    CheckEquals(tpIntegraToStr(APagBase[i].tpIntegra), tpIntegraToStr(APagCompara[i].tpIntegra), Format('detPag[%d].tpIntegra difere do esperado', [i]));
    CheckEquals(APagBase[i].CNPJ, APagCompara[i].CNPJ, Format('detPag[%d].CNPJ difere do esperado', [i]));
    CheckEquals(BandeiraCartaoToStr(APagBase[i].tBand), BandeiraCartaoToStr(APagCompara[i].tBand), Format('detPag[%d].tBand difere do esperado', [i]));
    CheckEquals(APagBase[i].cAut, APagCompara[i].cAut, Format('detPag[%d].cAut difere do esperado', [i]));
    CheckEquals(APagBase[i].CNPJReceb, APagCompara[i].CNPJReceb, Format('detPag[%d].CNPJReceb difere do esperado', [i]));
    CheckEquals(APagBase[i].idTermPag, APagCompara[i].idTermPag, Format('detPag[%d].idTermPag difere do esperado', [i]));
  end;
  CheckEquals(APagBase.vTroco, APagCompara.vTroco, 'pag.vTroco difere do esperado');
end;

class procedure TNFeComparer.Compara_infAdic(const AInfAdicBase, AInfAdicCompara: TInfAdic);
var
  i: Integer;
begin
  CheckEquals(AInfAdicBase.infAdFisco, AInfAdicCompara.infAdFisco, 'InfAdic.InfAdFisco difere do esperado');
  CheckEquals(AInfAdicBase.infCpl, AInfAdicCompara.infCpl, 'InfAdic.InfAdCpl difere do esperado');
  //-ObsCont
  if AInfAdicBase.obsCont.Count <> AInfAdicCompara.obsCont.Count then
  begin
    Fail(Format('InfAdic.obsCont.Count difere do esperado. Esperado: %d, Obtido: %d', [AInfAdicBase.obsCont.Count, AInfAdicCompara.obsCont.Count]));
    exit;
  end;
  for i := 0 to AInfAdicBase.obsCont.Count - 1 do
  begin
    CheckEquals(AInfAdicBase.obsCont[i].xCampo, AInfAdicBase.obsCont[i].xCampo, Format('InfAdic.obsCont[%d].xCampo difere do esperado', [i]));
    CheckEquals(AInfAdicBase.obsCont[i].xTexto, AInfAdicBase.obsCont[i].xTexto, Format('InfAdic.obsCont[%d].xTexto difere do esperado', [i]));
  end;
  //-obsFisco
  if AInfAdicBase.obsFisco.Count <> AInfAdicCompara.obsFisco.Count then
  begin
    Fail(Format('InfAdic.obsFisco.Count difere do esperado. Esperado: %d, Obtido: %d', [AInfAdicBase.obsFisco.Count, AInfAdicCompara.obsFisco.Count]));
    exit;
  end;
  for i := 0 to AInfAdicBase.obsFisco.Count - 1 do
  begin
    CheckEquals(AInfAdicBase.obsFisco[i].xCampo, AInfAdicBase.obsFisco[i].xCampo, Format('InfAdic.obsFisco[%d].xCampo difere do esperado', [i]));
    CheckEquals(AInfAdicBase.obsFisco[i].xTexto, AInfAdicBase.obsFisco[i].xTexto, Format('InfAdic.obsFisco[%d].xTexto difere do esperado', [i]));
  end;
  //-procRef
  if AInfAdicBase.procRef.Count <> AInfAdicCompara.procRef.Count then
  begin
    Fail(Format('InfAdic.procRef.Count difere do esperado. Esperado: %d, Obtido: %d', [AInfAdicBase.procRef.Count, AInfAdicCompara.procRef.Count]));
    exit;
  end;
  for i := 0 to AInfAdicBase.procRef.Count - 1 do
  begin
    CheckEquals(AInfAdicBase.procRef[i].nProc, AInfAdicCompara.procRef[i].nProc, Format('InfAdic.procRef[%d].nProc difere do esperado', [i]));
    CheckEquals(indProcToStr(AInfAdicBase.procRef[i].indProc), indProcToStr(AInfAdicCompara.procRef[i].indProc), Format('InfAdic.procRef[%d].indProc difere do esperado', [i]));
    CheckEquals(tpAtoToStr(AInfAdicBase.procRef[i].tpAto), tpAtoToStr(AInfAdicCompara.procRef[i].tpAto), Format('InfAdic.procRef[%d].tpAto difere do esperado', [i]));
  end;
end;

{ TEventoNFeComparer }

class procedure TEventoNFeComparer.Compara_Evento(const AEventoBase, AEventoCompara: TInfEventoCollectionItem);
var
  i: Integer;
begin
  CheckEquals(AEventoBase.InfEvento.cOrgao, AEventoCompara.InfEvento.cOrgao, 'infEvento.cOrgao difere do esperado');
  CheckEquals(AEventoBase.InfEvento.CNPJ, AEventoCompara.InfEvento.CNPJ, 'infEvento.CNPJ difere do esperado');
  CheckEquals(AEventoBase.InfEvento.chNFe, AEventoCompara.InfEvento.chNFe, 'infEvento.chNFe difere do esperado');
  CheckEquals(FormatDateTime('DD/MM/YYYY hh:nn:ss', AEventoBase.InfEvento.dhEvento), FormatDateTime('DD/MM/YYYY hh:nn:ss', AEventoCompara.InfEvento.dhEvento), 'infEvento.dhEvento difere do esperado');
  CheckEquals(TpEventoToStr(AEventoBase.InfEvento.tpEvento), TpEventoToStr(AEventoCompara.InfEvento.tpEvento), 'infEvento.tpEvento difere do esperado');
  CheckEquals(AEventoBase.InfEvento.nSeqEvento, AEventoCompara.InfEvento.nSeqEvento, 'infEvento.nSeqEvento difere do esperado');
  CheckEquals(AEventoBase.InfEvento.versaoEvento, AEventoCompara.InfEvento.versaoEvento, 'infEvento.versaoEvento difere do esperado');
  CheckEquals(AEventoBase.InfEvento.detEvento.descEvento, AEventoCompara.InfEvento.detEvento.descEvento, 'infEvento.detEvento.descEvento difere do esperado');
  CheckEquals(TpEventoToStr(AEventoBase.InfEvento.tpEvento), TpEventoToStr(AEventoCompara.InfEvento.tpEvento), 'infEvento.tpEvento difere do esperado');
  case AEventoBase.InfEvento.tpEvento of
    teCancelamento:
      begin
        CheckEquals(AEventoBase.InfEvento.detEvento.nProt, AEventoCompara.InfEvento.detEvento.nProt, 'infEvento.detEvento.nProt difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.xJust, AEventoCompara.InfEvento.detEvento.xJust, 'infEvento.detEvento.xJust difere do esperado');
      end;
    teCCe:
      begin
        CheckEquals(AEventoBase.InfEvento.detEvento.xCorrecao, AEventoCompara.InfEvento.detEvento.xCorrecao, 'infEvento.detEvento.xCorrecao difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.xCondUso, AEventoCompara.InfEvento.detEvento.xCondUso, 'infEvento.detEvento.xCondUso difere do esperado');
      end;
    teComprEntregaNFe:
      begin
        CheckEquals(AEventoBase.InfEvento.detEvento.cOrgaoAutor, AEventoCompara.InfEvento.detEvento.cOrgaoAutor, 'infEvento.detEvento.cOrgaoAutor difere do esperado');
        CheckEquals(TipoAutorToStr(AEventoBase.InfEvento.detEvento.tpAutor), TipoAutorToStr(AEventoCompara.InfEvento.detEvento.tpAutor), 'infEvento.detEvento.tpAutor difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.verAplic, AEventoCompara.InfEvento.detEvento.verAplic, 'infEvento.detEvento.verAplic difere do esperado');
        CheckEquals(FormatDateTime('DD/MM/YYYY hh:nn:ss', AEventoBase.InfEvento.detEvento.dhEntrega), FormatDateTime('DD/MM/YYYY hh:nn:ss', AEventoCompara.InfEvento.detEvento.dhEntrega), 'infEvento.detEvento.dhEntrega difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.nDoc, AEventoCompara.InfEvento.detEvento.nDoc, 'infEvento.detEvento.nDoc difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.xNome, AEventoCompara.InfEvento.detEvento.xNome, 'infEvento.detEvento.xNome difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.latGPS, AEventoCompara.InfEvento.detEvento.latGPS, 'infEvento.detEvento.latGPS difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.longGPS, AEventoCompara.InfEvento.detEvento.longGPS, 'infEvento.detEvento.longGPS difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.hashComprovante, AEventoCompara.InfEvento.detEvento.hashComprovante, 'infEvento.detEvento.hashComprovante difere do esperado');
        CheckEquals(FormatDateTime('DD/MM/YYYY hh:nn:ss', AEventoBase.InfEvento.detEvento.dhHashComprovante), FormatDateTime('DD/MM/YYYY hh:nn:ss', AEventoCompara.InfEvento.detEvento.dhHashComprovante), 'infEvento.detEvento.dhHashComprovante difere do esperado');
      end;
    teCancComprEntregaNFe:
      begin
        CheckEquals(AEventoBase.InfEvento.detEvento.cOrgaoAutor, AEventoCompara.InfEvento.detEvento.cOrgaoAutor, 'infEvento.detEvento.cOrgaoAutor difere do esperado');
        CheckEquals(TipoAutorToStr(AEventoBase.InfEvento.detEvento.tpAutor), TipoAutorToStr(AEventoCompara.InfEvento.detEvento.tpAutor), 'infEvento.detEvento.tpAutor difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.verAplic, AEventoCompara.InfEvento.detEvento.verAplic, 'infEvento.detEvento.verAplic difere do esperado');
        if (AEventoBase.InfEvento.detEvento.nProtEvento <> '')then
          CheckEquals(AEventoBase.InfEvento.detEvento.nProtEvento, AEventoCompara.InfEvento.detEvento.nProtEvento, 'infEvento.detEvento.nProtEvento difere do esperado')
        else
          //nProtEvento não é considerado pela LerXML...
          Check(Trim(AEventoCompara.InfEvento.detEvento.nProtEvento) <> '', 'infEvento.detEvento.nProtEvento não foi preenchido');
      end;
    teEPEC:
      begin
        CheckEquals(AEventoBase.InfEvento.detEvento.cOrgaoAutor, AEventoCompara.InfEvento.detEvento.cOrgaoAutor, 'infEvento.detEvento.cOrgaoAutor difere do esperado');
        CheckEquals(TipoAutorToStr(AEventoBase.InfEvento.detEvento.tpAutor), TipoAutorToStr(AEventoCompara.InfEvento.detEvento.tpAutor), 'infEvento.detEvento.tpAutor difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.verAplic, AEventoCompara.InfEvento.detEvento.verAplic, 'infEvento.detEvento.verAplic difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.dhEmi, AEventoCompara.InfEvento.detEvento.dhEmi, 'infEvento.detEvento.dhEmi difere do esperado');
        CheckEquals(tpNFToStr(AEventoBase.InfEvento.detEvento.tpNF), tpNFToStr(AEventoCompara.InfEvento.detEvento.tpNF), 'infEvento.detEvento.tpNF difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.IE, AEventoCompara.InfEvento.detEvento.IE, 'infEvento.detEvento.IE difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.vNF, AEventoCompara.InfEvento.detEvento.vNF, 'infEvento.detEvento.vNF difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.vICMS, AEventoCompara.InfEvento.detEvento.vICMS, 'infEvento.detEvento.vICMS difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.vST, AEventoCompara.InfEvento.detEvento.vST, 'infEvento.detEvento.vST difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.dest.UF, AEventoCompara.InfEvento.detEvento.dest.UF, 'infEvento.detEvento.dest.UF difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.dest.CNPJCPF, AEventoCompara.InfEvento.detEvento.dest.CNPJCPF, 'infEvento.detEvento.dest.CNPJCPF difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.dest.idEstrangeiro, AEventoCompara.InfEvento.detEvento.dest.idEstrangeiro, 'infEvento.detEvento.dest.idEstrangeiro difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.dest.IE, AEventoCompara.InfEvento.detEvento.dest.IE, 'infEvento.detEvento.dest.IE difere do esperado');
      end;
    teManifDestDesconhecimento, teManifDestOperNaoRealizada:
      begin
        CheckEquals(AEventoBase.InfEvento.detEvento.xJust, AEventoCompara.InfEvento.detEvento.xJust, 'infEvento.detEvento.xJust difere do esperado');
      end;
    teCancSubst:
      begin
        CheckEquals(AEventoBase.InfEvento.detEvento.cOrgaoAutor, AEventoCompara.InfEvento.detEvento.cOrgaoAutor, 'infEvento.detEvento.cOrgaoAutor difere do esperado');
        CheckEquals(TipoAutorToStr(AEventoBase.InfEvento.detEvento.tpAutor), TipoAutorToStr(AEventoCompara.InfEvento.detEvento.tpAutor), 'infEvento.detEvento.tpAutor difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.verAplic, AEventoCompara.InfEvento.detEvento.verAplic, 'infEvento.detEvento.verAplic difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.xJust, AEventoCompara.InfEvento.detEvento.xJust, 'infEvento.detEvento.xJust difere do esperado');
        if (AEventoBase.InfEvento.detEvento.chNFeRef <> '')then
          CheckEquals(AEventoBase.InfEvento.detEvento.chNFeRef, AEventoCompara.InfEvento.detEvento.chNFeRef, 'infEvento.detEvento.chNFeRef difere do esperado')
        else
          //chNFeRef não é considerado pela LerXML...
          Check(Trim(AEventoCompara.InfEvento.detEvento.chNFeRef) <> '', 'infEvento.detEvento.chNFeRef não foi preenchido');
      end;
    teInsucessoEntregaNFe:
      begin
        CheckEquals(AEventoBase.InfEvento.detEvento.cOrgaoAutor, AEventoCompara.InfEvento.detEvento.cOrgaoAutor, 'infEvento.detEvento.cOrgaoAutor difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.verAplic, AEventoCompara.InfEvento.detEvento.verAplic, 'infEvento.detEvento.verAplic difere do esperado');
        CheckEquals(FormatDateTime('DD/MM/YYYY hh:nn:ss', AEventoBase.InfEvento.detEvento.dhTentativaEntrega), FormatDateTime('DD/MM/YYYY hh:nn:ss', AEventoCompara.InfEvento.detEvento.dhTentativaEntrega), 'infEvento.detEvento.dhTentativaEntrega difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.nTentativa, AEventoCompara.InfEvento.detEvento.nTentativa, 'infEvento.detEvento.nTentativa difere do esperado');
        CheckEquals(tpMotivoToStr(AEventoBase.InfEvento.detEvento.tpMotivo), tpMotivoToStr(AEventoCompara.InfEvento.detEvento.tpMotivo), 'infEvento.detEvento.tpMotivo difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.xJustMotivo, AEventoCompara.InfEvento.detEvento.xJustMotivo, 'infEvento.detEvento.xJustMotivo difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.hashTentativaEntrega, AEventoCompara.InfEvento.detEvento.hashTentativaEntrega, 'infEvento.detEvento.hashTentativaEntrega difere do esperado');
        CheckEquals(FormatDateTime('DD/MM/YYYY hh:nn:ss', AEventoBase.InfEvento.detEvento.dhHashTentativaEntrega), FormatDateTime('DD/MM/YYYY hh:nn:ss', AEventoCompara.InfEvento.detEvento.dhHashTentativaEntrega), 'infEvento.detEvento.dhHashTentativaEntrega difere do esperado');
      end;
    teCancInsucessoEntregaNFe:
      begin
        CheckEquals(AEventoBase.InfEvento.detEvento.cOrgaoAutor, AEventoCompara.InfEvento.detEvento.cOrgaoAutor, 'infEvento.detEvento.cOrgaoAutor difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.verAplic, AEventoCompara.InfEvento.detEvento.verAplic, 'infEvento.detEvento.verAplic difere do esperado');
        if (AEventoBase.InfEvento.detEvento.nProtEvento <> '')then
          CheckEquals(AEventoBase.InfEvento.detEvento.nProtEvento, AEventoCompara.InfEvento.detEvento.nProtEvento, 'infEvento.detEvento.nProtEvento difere do esperado')
        else
          //nProtEvento não é considerado pela LerXML...
          Check(Trim(AEventoCompara.InfEvento.detEvento.nProtEvento) <> '', 'infEvento.detEvento.nProtEvento não foi preenchido');
      end;
    teConcFinanceira:
      begin
        if (AEventoBase.InfEvento.detEvento.detPag.Count > 0) then
        begin
          if(AEventoBase.InfEvento.detEvento.detPag.Count <> AEventoCompara.InfEvento.detEvento.detPag.Count) then
          begin
            Fail(Format('detEvento.detPag.Count difere do esperado. Esperado: %d, Obtido: %d', [AEventoBase.InfEvento.detEvento.detPag.Count, AEventoCompara.InfEvento.detEvento.detPag.Count]));
            exit;
          end;
        end else
          //detPag não é considerado na pela LerXML, então testo se preencheu a lista.
          Check(AEventoCompara.InfEvento.detEvento.detPag.Count > 0, 'detEvento.detPag.Count está vazio');

        for i := 0 to AEventoBase.InfEvento.detEvento.detPag.Count - 1 do
        begin
          CheckEquals(IndpagToStrEX(AEventoBase.InfEvento.detEvento.detPag[i].indPag), IndpagToStrEX(AEventoCompara.InfEvento.detEvento.detPag[i].indPag), Format('detEvento.detPag[%d].indPag difere do esperado', [i]));
          CheckEquals(FormaPagamentoToStr(AEventoBase.InfEvento.detEvento.detPag[i].tPag), FormaPagamentoToStr(AEventoCompara.InfEvento.detEvento.detPag[i].tPag), Format('detEvento.detPag[%d].tPag difere do esperado', [i]));
          CheckEquals(AEventoBase.InfEvento.detEvento.detPag[i].xPag, AEventoCompara.InfEvento.detEvento.detPag[i].xPag, Format('detEvento.detPag[%d].xPag difere do esperado', [i]));
          CheckEquals(AEventoBase.InfEvento.detEvento.detPag[i].vPag, AEventoCompara.InfEvento.detEvento.detPag[i].vPag, Format('detEvento.detPag[%d].vPag difere do esperado', [i]));
          CheckEquals(AEventoBase.InfEvento.detEvento.detPag[i].dPag, AEventoCompara.InfEvento.detEvento.detPag[i].dPag, Format('detEvento.detPag[%d].dPag difere do esperado', [i]));
          CheckEquals(AEventoBase.InfEvento.detEvento.detPag[i].CNPJPag, AEventoCompara.InfEvento.detEvento.detPag[i].CNPJPag, Format('detEvento.detPag[%d].CNPJPag difere do esperado', [i]));
          CheckEquals(AEventoBase.InfEvento.detEvento.detPag[i].UFPag, AEventoCompara.InfEvento.detEvento.detPag[i].UFPag, Format('detEvento.detPag[%d].UFPag difere do esperado', [i]));
          CheckEquals(AEventoBase.InfEvento.detEvento.detPag[i].CNPJIF, AEventoCompara.InfEvento.detEvento.detPag[i].CNPJIF, Format('detEvento.detPag[%d].CNPJIF difere do esperado', [i]));
          CheckEquals(BandeiraCartaoToStr(AEventoBase.InfEvento.detEvento.detPag[i].tBand), BandeiraCartaoToStr(AEventoCompara.InfEvento.detEvento.detPag[i].tBand), Format('detEvento.detPag[%d].tBand difere do esperado', [i]));
          CheckEquals(AEventoBase.InfEvento.detEvento.detPag[i].CNPJReceb, AEventoCompara.InfEvento.detEvento.detPag[i].CNPJReceb, Format('detEvento.detPag[%d].CNPJReceb difere do esperado', [i]));
          CheckEquals(AEventoBase.InfEvento.detEvento.detPag[i].UFReceb, AEventoCompara.InfEvento.detEvento.detPag[i].UFReceb, Format('detEvento.detPag[%d].UFReceb difere do esperado', [i]));
        end;
      end;
     teCancConcFinanceira:
      begin
        CheckEquals(AEventoBase.InfEvento.detEvento.verAplic, AEventoCompara.InfEvento.detEvento.verAplic, 'infEvento.detEvento.verAplic difere do esperado');
        if (AEventoBase.InfEvento.detEvento.nProtEvento <> '')then
          CheckEquals(AEventoBase.InfEvento.detEvento.nProtEvento, AEventoCompara.InfEvento.detEvento.nProtEvento, 'infEvento.detEvento.nProtEvento difere do esperado')
        else
          //nProtEvento não é considerado pela LerXML...
          Check(Trim(AEventoCompara.InfEvento.detEvento.nProtEvento) <> '', 'infEvento.detEvento.nProtEvento não foi preenchido');
      end;
    tePedProrrog1, tePedProrrog2:
      begin
        CheckEquals(AEventoBase.InfEvento.detEvento.nProt, AEventoCompara.InfEvento.detEvento.nProt, 'infEvento.detEvento.nProt difere do esperado');
        if (AEventoBase.InfEvento.detEvento.itemPedido.Count > 0) then
        begin
          if(AEventoBase.InfEvento.detEvento.itemPedido.Count <> AEventoCompara.InfEvento.detEvento.itemPedido.Count) then
          begin
            Fail(Format('detEvento.itemPedido.Count difere do esperado. Esperado: %d, Obtido: %d', [AEventoBase.InfEvento.detEvento.itemPedido.Count, AEventoCompara.InfEvento.detEvento.itemPedido.Count]));
            exit;
          end;
        end else
          //itemPedido não é considerado na pela LerXML, então testo se preencheu a lista.
          Check(AEventoCompara.InfEvento.detEvento.itemPedido.Count > 0, 'detEvento.itemPedido.Count está vazio');

        for i := 0 to AEventoBase.InfEvento.detEvento.itemPedido.Count - 1 do
        begin
          CheckEquals(AEventoBase.InfEvento.detEvento.itemPedido[i].numItem, AEventoCompara.InfEvento.detEvento.itemPedido[i].numItem, Format('detEvento.itemPedido[%d].numItem difere do esperado', [i]));
          CheckEquals(AEventoBase.InfEvento.detEvento.itemPedido[i].qtdeItem, AEventoCompara.InfEvento.detEvento.itemPedido[i].qtdeItem, Format('detEvento.itemPedido[%d].qtdeItem difere do esperado', [i]));
        end;
      end;
    teCanPedProrrog1, teCanPedProrrog2:
      begin
        if (AEVentoBase.InfEvento.detEvento.idPedidoCancelado <> '') then
          CheckEquals(AEventoBase.InfEvento.detEvento.idPedidoCancelado, AEventoCompara.InfEvento.detEvento.idPedidoCancelado, 'infEvento.detEvento.idPedidoCancelado difere do esperado')
        else
          //idPedidoCancelado não é considerado pela LerXML
          Check(Trim(AEventoCompara.InfEvento.detEvento.idPedidoCancelado) <> '', 'infEvento.detEvento.idPedidoCancelado não foi preenchido');
        CheckEquals(AEventoBase.InfEvento.detEvento.nProt, AEventoCompara.InfEvento.detEvento.nProt, 'infEvento.detEvento.nProt difere do esperado');
      end;
    teAtorInteressadoNFe:
      begin
        CheckEquals(AEventoBase.InfEvento.detEvento.cOrgaoAutor, AEventoCompara.InfEvento.detEvento.cOrgaoAutor, 'infEvento.detEvento.cOrgaoAutor difere do esperado');
        CheckEquals(TipoAutorToStr(AEventoBase.InfEvento.detEvento.tpAutor), TipoAutorToStr(AEventoCompara.InfEvento.detEvento.tpAutor), 'infEvento.detEvento.tpAutor difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.verAplic, AEventoCompara.InfEvento.detEvento.verAplic, 'infEvento.detEvento.verAplic difere do esperado');
        CheckEquals(AutorizacaoToStr(AEventoBase.InfEvento.detEvento.tpAutorizacao), AutorizacaoToStr(AEventoCompara.InfEvento.detEvento.tpAutorizacao), 'infEvento.detEvento.tpAutorizacao difere do esperado');
        CheckEquals(AEventoBase.InfEvento.detEvento.xCondUso, AEventoCompara.InfEvento.detEvento.xCondUso, 'infEvento.detEvento.xCondUso difere do esperado');

        if(AEventoBase.InfEvento.detEvento.autXML.Count <> AEventoCompara.InfEvento.detEvento.autXML.Count) then
        begin
          Fail(Format('detEvento.autXML.Count difere do esperado. Esperado: %d, Obtido: %d', [AEventoBase.InfEvento.detEvento.autXML.Count, AEventoCompara.InfEvento.detEvento.autXML.Count]));
          exit;
        end;

        for i := 0 to AEventoBase.InfEvento.detEvento.autXML.Count - 1 do
          CheckEquals(AEventoBase.InfEvento.detEvento.autXML[i].CNPJCPF, AEventoCompara.InfEvento.detEvento.autXML[i].CNPJCPF, Format('detEvento.autXML[%d].CNPJCPF difere do esperado', [i]));
      end;
  end;
end;

initialization
  _RegisterTest('ACBrNFeJSON.ValoresInválidos', TNFeJSONVazioTest);
  _RegisterTest('ACBrNFeJSON.SimetriaLeituraEscritaJSON', TNFeJSONSimetriaTest);
  _RegisterTest('ACBrNFeJSON.EquivalenciaJSON_XML_INI', TNFeJSONEquivalenciaTest);
  _RegisterTest('ACBrEventoNFeJSON.ValoresInválidos', TEventoNFeJSONVazioTest);
  _RegisterTest('ACBrEventoNFeJSON.EquivalenciaJSON_XML', TEventoNFeJSONEquivalenciaTest);

end.

