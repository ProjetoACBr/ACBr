object FormPrincipal: TFormPrincipal
  Left = 440
  Top = 133
  Width = 1016
  Height = 664
  Caption = 'ACBrTEFAPI - Demo'
  Color = clBtnFace
  Constraints.MinHeight = 490
  Constraints.MinWidth = 882
  ParentFont = True
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter2: TSplitter
    Left = 697
    Top = 0
    Height = 625
    Align = alRight
  end
  object pPrincipal: TPanel
    Left = 0
    Top = 0
    Width = 697
    Height = 625
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter3: TSplitter
      Left = 0
      Top = 441
      Width = 697
      Height = 2
      Cursor = crVSplit
      Align = alTop
    end
    object pgPrincipal: TPageControl
      Left = 0
      Top = 0
      Width = 697
      Height = 441
      ActivePage = tsConfiguracao
      Align = alTop
      Constraints.MinHeight = 375
      Images = ImageList1
      TabHeight = 33
      TabOrder = 0
      object tsConfiguracao: TTabSheet
        Caption = 'Configura'#231#227'o'
        object pgConfiguracao: TPageControl
          Left = 0
          Top = 0
          Width = 689
          Height = 362
          ActivePage = tsConfigTEF
          Align = alClient
          Images = ImageList1
          TabHeight = 33
          TabOrder = 0
          object tsConfigTEF: TTabSheet
            Caption = 'Configura'#231#227'o TEF'
            ImageIndex = 1
            object pConfiguracao: TPanel
              Left = 0
              Top = 0
              Width = 681
              Height = 319
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              object pConfigImpSwHouseEstab: TPanel
                Left = 305
                Top = 0
                Width = 376
                Height = 319
                Align = alClient
                BevelOuter = bvNone
                TabOrder = 0
                object gbSwHouseAplicacao: TGroupBox
                  Left = 0
                  Top = 0
                  Width = 376
                  Height = 129
                  Align = alTop
                  Caption = 'Software House e Aplica'#231#227'o'
                  TabOrder = 0
                  DesignSize = (
                    376
                    129)
                  object Label14: TLabel
                    Left = 14
                    Top = 13
                    Width = 28
                    Height = 13
                    Caption = 'Nome'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object Label16: TLabel
                    Left = 14
                    Top = 48
                    Width = 78
                    Height = 13
                    Caption = 'Nome Aplica'#231#227'o'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object Label19: TLabel
                    Left = 259
                    Top = 48
                    Width = 33
                    Height = 13
                    Anchors = [akTop, akRight]
                    Caption = 'Vers'#227'o'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object Label15: TLabel
                    Left = 259
                    Top = 13
                    Width = 27
                    Height = 13
                    Anchors = [akTop, akRight]
                    Caption = 'CNPJ'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object Label37: TLabel
                    Left = 14
                    Top = 82
                    Width = 89
                    Height = 13
                    Caption = 'Mensagem PinPad'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object edRazaoSocialSwHouse: TEdit
                    Left = 14
                    Top = 26
                    Width = 228
                    Height = 21
                    Anchors = [akLeft, akTop, akRight]
                    TabOrder = 0
                    Text = 'PROJETO ACBR'
                  end
                  object edNomeAplicacao: TEdit
                    Left = 14
                    Top = 62
                    Width = 228
                    Height = 21
                    Anchors = [akLeft, akTop, akRight]
                    TabOrder = 2
                    Text = 'TEFAPIDemo'
                  end
                  object edVersaoAplicacao: TEdit
                    Left = 259
                    Top = 62
                    Width = 100
                    Height = 21
                    Anchors = [akTop, akRight]
                    TabOrder = 3
                    Text = '1.0'
                  end
                  object edCNPJSwHouse: TEdit
                    Left = 259
                    Top = 26
                    Width = 100
                    Height = 21
                    Anchors = [akTop, akRight]
                    TabOrder = 1
                  end
                  object edMsgPinPad: TEdit
                    Left = 14
                    Top = 96
                    Width = 343
                    Height = 21
                    Anchors = [akLeft, akTop, akRight]
                    TabOrder = 4
                    Text = 'TEF ACBR.  SEJA NOSSO PARCEIRO'
                  end
                end
                object gbEstabelecimentoComercial: TGroupBox
                  Left = 0
                  Top = 129
                  Width = 376
                  Height = 64
                  Align = alTop
                  Caption = 'Estabelecimento Comercial'
                  TabOrder = 1
                  DesignSize = (
                    376
                    64)
                  object Label17: TLabel
                    Left = 14
                    Top = 14
                    Width = 63
                    Height = 13
                    Caption = 'Raz'#227'o Social'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object Label21: TLabel
                    Left = 259
                    Top = 14
                    Width = 27
                    Height = 13
                    Anchors = [akTop, akRight]
                    Caption = 'CNPJ'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object edRazaoSocialEstabelecimento: TEdit
                    Left = 15
                    Top = 27
                    Width = 227
                    Height = 21
                    Anchors = [akLeft, akTop, akRight]
                    TabOrder = 0
                    Text = 'PROJETO ACBR'
                  end
                  object edCNPJEstabelecimento: TEdit
                    Left = 259
                    Top = 27
                    Width = 100
                    Height = 21
                    Anchors = [akTop, akRight]
                    TabOrder = 1
                  end
                end
                object gbDadosTerminal: TGroupBox
                  Left = 0
                  Top = 193
                  Width = 376
                  Height = 126
                  Align = alClient
                  Caption = 'Dados Terminal'
                  TabOrder = 2
                  DesignSize = (
                    376
                    126)
                  object Label8: TLabel
                    Left = 92
                    Top = 49
                    Width = 42
                    Height = 13
                    Caption = 'Cod.Filial'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object Label20: TLabel
                    Left = 260
                    Top = 49
                    Width = 62
                    Height = 13
                    Anchors = [akTop, akRight]
                    Caption = 'Porta PinPad'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object Label23: TLabel
                    Left = 92
                    Top = 13
                    Width = 88
                    Height = 13
                    Caption = 'Endere'#231'o Servidor'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object Label24: TLabel
                    Left = 10
                    Top = 49
                    Width = 63
                    Height = 13
                    Caption = 'Cod.Empresa'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object Label30: TLabel
                    Left = 10
                    Top = 13
                    Width = 62
                    Height = 13
                    Caption = 'Cod.Terminal'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object Label31: TLabel
                    Left = 260
                    Top = 11
                    Width = 44
                    Height = 13
                    Anchors = [akTop, akRight]
                    Caption = 'Ambiente'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object Label32: TLabel
                    Left = 10
                    Top = 86
                    Width = 121
                    Height = 13
                    Caption = 'Par'#226'metros Comunica'#231#227'o'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object edCodFilial: TEdit
                    Left = 92
                    Top = 62
                    Width = 149
                    Height = 21
                    Anchors = [akLeft, akTop, akRight]
                    TabOrder = 4
                  end
                  object edPortaPinPad: TEdit
                    Left = 260
                    Top = 62
                    Width = 99
                    Height = 21
                    Anchors = [akTop, akRight]
                    TabOrder = 5
                  end
                  object edEnderecoServidor: TEdit
                    Left = 92
                    Top = 25
                    Width = 149
                    Height = 21
                    Anchors = [akLeft, akTop, akRight]
                    TabOrder = 1
                  end
                  object edCodEmpresa: TEdit
                    Left = 10
                    Top = 62
                    Width = 71
                    Height = 21
                    TabOrder = 3
                  end
                  object edCodTerminal: TEdit
                    Left = 10
                    Top = 27
                    Width = 55
                    Height = 21
                    Anchors = [akLeft, akTop, akRight]
                    TabOrder = 0
                  end
                  object cbxAmbiente: TComboBox
                    Left = 260
                    Top = 25
                    Width = 99
                    Height = 21
                    Style = csDropDownList
                    Anchors = [akTop, akRight]
                    ItemHeight = 13
                    ItemIndex = 0
                    TabOrder = 2
                    Text = 'Nao Definido'
                    Items.Strings = (
                      'Nao Definido'
                      'Homologa'#231#227'o'
                      'Produ'#231#227'o')
                  end
                  object edParamComunic: TEdit
                    Left = 10
                    Top = 99
                    Width = 231
                    Height = 21
                    Anchors = [akLeft, akTop, akRight]
                    TabOrder = 6
                  end
                  object cbGravarLogTEF: TCheckBox
                    Left = 280
                    Top = 95
                    Width = 60
                    Height = 17
                    Anchors = [akTop, akRight]
                    Caption = 'Log TEF'
                    Checked = True
                    State = cbChecked
                    TabOrder = 7
                  end
                end
              end
              object pConfigTEF: TPanel
                Left = 0
                Top = 0
                Width = 305
                Height = 319
                Align = alLeft
                BevelOuter = bvNone
                TabOrder = 1
                object gbConfigTEF: TGroupBox
                  Left = 0
                  Top = 0
                  Width = 305
                  Height = 216
                  Align = alClient
                  Caption = 'TEF'
                  TabOrder = 0
                  object Label11: TLabel
                    Left = 8
                    Top = 56
                    Width = 40
                    Height = 13
                    Alignment = taRightJustify
                    Caption = 'Arq.Log:'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object SbArqLog: TSpeedButton
                    Left = 128
                    Top = 71
                    Width = 15
                    Height = 20
                    Caption = '...'
                    OnClick = SbArqLogClick
                  end
                  object Label9: TLabel
                    Left = 152
                    Top = 11
                    Width = 41
                    Height = 13
                    Caption = 'QRCode'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object Label1: TLabel
                    Left = 9
                    Top = 15
                    Width = 81
                    Height = 13
                    Caption = 'Gerenciador TEF'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object Label10: TLabel
                    Left = 152
                    Top = 56
                    Width = 88
                    Height = 13
                    Caption = 'Imprimir Via Cliente'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object Label12: TLabel
                    Left = 9
                    Top = 99
                    Width = 100
                    Height = 13
                    Caption = 'Transa'#231#227'o Pendente'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object Label18: TLabel
                    Left = 152
                    Top = 99
                    Width = 127
                    Height = 13
                    Caption = 'Pendencia na Inicializa'#231#227'o'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object cbSuportaDesconto: TCheckBox
                    Left = 174
                    Top = 147
                    Width = 105
                    Height = 19
                    Caption = 'Suporta Desconto'
                    TabOrder = 9
                  end
                  object cbSuportaSaque: TCheckBox
                    Left = 174
                    Top = 171
                    Width = 90
                    Height = 18
                    Caption = 'Suporta Saque'
                    TabOrder = 10
                  end
                  object cbImprimirViaReduzida: TCheckBox
                    Left = 9
                    Top = 169
                    Width = 137
                    Height = 18
                    Caption = 'Imprimir Via Reduzida'
                    TabOrder = 7
                  end
                  object edLog: TEdit
                    Left = 9
                    Top = 71
                    Width = 119
                    Height = 21
                    Cursor = crIBeam
                    TabOrder = 2
                    Text = 'ACBr-YYMMDD.txt'
                  end
                  object cbxQRCode: TComboBox
                    Left = 152
                    Top = 29
                    Width = 127
                    Height = 21
                    Style = csDropDownList
                    ItemHeight = 13
                    ItemIndex = 1
                    TabOrder = 1
                    Text = 'Auto'
                    Items.Strings = (
                      'N'#227'o Suportado'
                      'Auto'
                      'Exibir no PinPad'
                      'Exibir na Tela'
                      'Imprimir')
                  end
                  object cbConfirmarAutomaticamente: TCheckBox
                    Left = 9
                    Top = 190
                    Width = 208
                    Height = 18
                    Caption = 'Confirmar Transa'#231#227'o Automaticamente'
                    TabOrder = 8
                  end
                  object cbxGP: TComboBox
                    Left = 9
                    Top = 29
                    Width = 119
                    Height = 21
                    Style = csDropDownList
                    ItemHeight = 13
                    TabOrder = 0
                    OnChange = cbxGPChange
                  end
                  object cbAutoAtendimento: TCheckBox
                    Left = 9
                    Top = 147
                    Width = 161
                    Height = 19
                    Caption = 'Terminal de Auto atendimento'
                    TabOrder = 6
                  end
                  object cbxImpressaoViaCliente: TComboBox
                    Left = 152
                    Top = 71
                    Width = 127
                    Height = 21
                    Style = csDropDownList
                    ItemHeight = 13
                    ItemIndex = 0
                    TabOrder = 3
                    Text = 'Imprimir'
                    Items.Strings = (
                      'Imprimir'
                      'Perguntar'
                      'N'#227'o Imprimir')
                  end
                  object cbxTransacaoPendente: TComboBox
                    Left = 9
                    Top = 114
                    Width = 119
                    Height = 21
                    Style = csDropDownList
                    ItemHeight = 13
                    ItemIndex = 0
                    TabOrder = 4
                    Text = 'Confirmar'
                    Items.Strings = (
                      'Confirmar'
                      'Estornar'
                      'Perguntar')
                  end
                  object cbxTransacaoPendenteInicializacao: TComboBox
                    Left = 152
                    Top = 114
                    Width = 127
                    Height = 21
                    Style = csDropDownList
                    ItemHeight = 13
                    ItemIndex = 1
                    TabOrder = 5
                    Text = 'Processar Pendentes'
                    Items.Strings = (
                      'N'#227'o Fazer nada'
                      'Processar Pendentes'
                      'Cancelar/Estornar')
                  end
                end
                object gbDadosTEFTXT: TGroupBox
                  Left = 0
                  Top = 216
                  Width = 305
                  Height = 103
                  Align = alBottom
                  Caption = 'TEF TXT'
                  Enabled = False
                  TabOrder = 1
                  object Label38: TLabel
                    Left = 10
                    Top = 13
                    Width = 95
                    Height = 13
                    Caption = 'Diret'#243'rio Requisi'#231#227'o'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object Label39: TLabel
                    Left = 144
                    Top = 13
                    Width = 87
                    Height = 13
                    Caption = 'Diret'#243'rio Resposta'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object sbDirReq: TSpeedButton
                    Left = 113
                    Top = 29
                    Width = 24
                    Height = 23
                    Caption = '...'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -11
                    Font.Name = 'MS Sans Serif'
                    Font.Style = []
                    ParentFont = False
                    OnClick = sbDirReqClick
                  end
                  object sbDirResp: TSpeedButton
                    Left = 271
                    Top = 29
                    Width = 24
                    Height = 23
                    Caption = '...'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -11
                    Font.Name = 'MS Sans Serif'
                    Font.Style = []
                    ParentFont = False
                    OnClick = sbDirRespClick
                  end
                  object Label40: TLabel
                    Left = 9
                    Top = 58
                    Width = 72
                    Height = 13
                    Caption = 'Arq.Requisi'#231#227'o'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object Label41: TLabel
                    Left = 106
                    Top = 58
                    Width = 49
                    Height = 13
                    Caption = 'Arq.Status'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object Label42: TLabel
                    Left = 203
                    Top = 58
                    Width = 64
                    Height = 13
                    Caption = 'Arq.Resposta'
                    Color = clBtnFace
                    ParentColor = False
                  end
                  object edDirReq: TEdit
                    Left = 10
                    Top = 29
                    Width = 103
                    Height = 21
                    TabOrder = 0
                    Text = 'C:\Client\Req'
                  end
                  object edDirResp: TEdit
                    Left = 144
                    Top = 29
                    Width = 129
                    Height = 21
                    TabOrder = 1
                    Text = 'C:\Client\Resp'
                  end
                  object edArqReq: TEdit
                    Left = 9
                    Top = 74
                    Width = 88
                    Height = 21
                    TabOrder = 2
                    Text = 'IntPos.001'
                  end
                  object edArqSts: TEdit
                    Left = 106
                    Top = 74
                    Width = 88
                    Height = 21
                    TabOrder = 3
                    Text = 'IntPos.sts'
                  end
                  object edArqResp: TEdit
                    Left = 203
                    Top = 74
                    Width = 88
                    Height = 21
                    TabOrder = 4
                    Text = 'IntPos.001'
                  end
                end
              end
            end
          end
          object tsConfigImpressora: TTabSheet
            Caption = 'Impressora'
            ImageIndex = 4
            object gbConfigImpressora: TGroupBox
              Left = 0
              Top = 64
              Width = 681
              Height = 98
              Align = alTop
              Caption = 'Impressora'
              Enabled = False
              TabOrder = 0
              DesignSize = (
                681
                98)
              object Label25: TLabel
                Left = 123
                Top = 55
                Width = 58
                Height = 13
                Caption = 'Linhas Pular'
                Color = clBtnFace
                ParentColor = False
              end
              object Label26: TLabel
                Left = 64
                Top = 55
                Width = 41
                Height = 13
                Caption = 'Espa'#231'os'
                Color = clBtnFace
                ParentColor = False
              end
              object Label27: TLabel
                Left = 7
                Top = 55
                Width = 38
                Height = 13
                Caption = 'Colunas'
                Color = clBtnFace
                ParentColor = False
              end
              object Label7: TLabel
                Left = 123
                Top = 16
                Width = 25
                Height = 13
                Caption = 'Porta'
                Color = clBtnFace
                ParentColor = False
              end
              object btSerial: TSpeedButton
                Left = 499
                Top = 27
                Width = 24
                Height = 22
                Anchors = [akTop, akRight]
                OnClick = btSerialClick
              end
              object btProcuraImpressoras: TSpeedButton
                Left = 527
                Top = 27
                Width = 23
                Height = 22
                Anchors = [akTop, akRight]
                OnClick = btProcuraImpressorasClick
              end
              object Label28: TLabel
                Left = 7
                Top = 16
                Width = 35
                Height = 13
                Caption = 'Modelo'
                Color = clBtnFace
                ParentColor = False
              end
              object Label29: TLabel
                Left = 191
                Top = 55
                Width = 70
                Height = 13
                Caption = 'P'#225'g.de C'#243'digo'
                Color = clBtnFace
                ParentColor = False
              end
              object seLinhasPular: TSpinEdit
                Left = 123
                Top = 69
                Width = 48
                Height = 22
                MaxValue = 255
                MinValue = 0
                TabOrder = 4
                Value = 0
              end
              object seEspLinhas: TSpinEdit
                Left = 64
                Top = 69
                Width = 48
                Height = 22
                MaxValue = 255
                MinValue = 0
                TabOrder = 3
                Value = 0
              end
              object seColunas: TSpinEdit
                Left = 7
                Top = 69
                Width = 48
                Height = 22
                MaxValue = 999
                MinValue = 1
                TabOrder = 2
                Value = 48
              end
              object cbxModeloPosPrinter: TComboBox
                Left = 7
                Top = 29
                Width = 105
                Height = 21
                Style = csDropDownList
                ItemHeight = 13
                TabOrder = 0
              end
              object cbxPorta: TComboBox
                Left = 123
                Top = 29
                Width = 371
                Height = 21
                Anchors = [akLeft, akTop, akRight]
                ItemHeight = 13
                TabOrder = 1
              end
              object cbxPagCodigo: TComboBox
                Left = 191
                Top = 69
                Width = 79
                Height = 21
                Hint = 'Pagina de c'#243'digo usada pela Impressora POS'
                Style = csDropDownList
                ItemHeight = 13
                TabOrder = 5
              end
              object btTestarPosPrinter: TBitBtn
                Left = 580
                Top = 36
                Width = 83
                Height = 41
                Anchors = [akTop, akRight]
                Caption = 'Testar'
                TabOrder = 6
                OnClick = btTestarPosPrinterClick
                Layout = blGlyphTop
              end
            end
            object gbSaidaImpressao: TGroupBox
              Left = 0
              Top = 0
              Width = 681
              Height = 64
              Align = alTop
              Caption = 'Sa'#237'da de Impressao'
              TabOrder = 1
              DesignSize = (
                681
                64)
              object Label22: TLabel
                Left = 198
                Top = 16
                Width = 117
                Height = 13
                Caption = 'Arquivo Saida Impress'#227'o'
                Color = clBtnFace
                ParentColor = False
              end
              object rbImpressora: TRadioButton
                Left = 18
                Top = 35
                Width = 85
                Height = 14
                Caption = 'Impressora'
                TabOrder = 0
                OnClick = rbImpressoraChange
              end
              object rbArquivo: TRadioButton
                Left = 117
                Top = 35
                Width = 75
                Height = 14
                Caption = 'Arquivo'
                Checked = True
                TabOrder = 1
                TabStop = True
                OnClick = rbImpressoraChange
              end
              object edArquivoImpressao: TEdit
                Left = 198
                Top = 32
                Width = 413
                Height = 21
                Anchors = [akLeft, akTop, akRight]
                TabOrder = 2
                Text = 'IMPYYMMDD.txt'
              end
            end
          end
        end
        object pBotaoConfig: TPanel
          Left = 0
          Top = 362
          Width = 689
          Height = 36
          Align = alBottom
          TabOrder = 1
          DesignSize = (
            689
            36)
          object btLerParametros: TBitBtn
            Left = 550
            Top = 5
            Width = 119
            Height = 26
            Anchors = [akRight, akBottom]
            Caption = 'Ler Par'#226'metros'
            TabOrder = 1
            OnClick = btLerParametrosClick
          end
          object btSalvarParametros: TBitBtn
            Left = 414
            Top = 5
            Width = 119
            Height = 26
            Anchors = [akRight, akBottom]
            Caption = 'Salvar Par'#226'metros'
            TabOrder = 0
            OnClick = btSalvarParametrosClick
          end
          object btTestarTEF: TBitBtn
            Left = 25
            Top = 5
            Width = 119
            Height = 26
            Anchors = [akLeft, akBottom]
            Caption = 'Testar TEF'
            TabOrder = 2
            OnClick = btTestarTEFClick
          end
        end
      end
      object tsOperacao: TTabSheet
        Caption = 'Opera'#231#227'o'
        ImageIndex = 1
        object Splitter1: TSplitter
          Left = 686
          Top = 0
          Height = 398
          Align = alRight
        end
        object pOperacao: TPanel
          Left = 0
          Top = 0
          Width = 686
          Height = 398
          Align = alClient
          BevelOuter = bvNone
          Constraints.MinWidth = 460
          TabOrder = 0
          object pStatus: TPanel
            Left = 0
            Top = 0
            Width = 686
            Height = 42
            Align = alTop
            BevelInner = bvLowered
            BevelWidth = 2
            Caption = 'CAIXA LIVRE'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            object lNumOperacao: TLabel
              Left = 633
              Top = 4
              Width = 49
              Height = 34
              Align = alRight
              Caption = '000000'
              Color = clBtnFace
              ParentColor = False
              Layout = tlCenter
              Visible = False
            end
            object btOperacao: TBitBtn
              Left = 9
              Top = 9
              Width = 101
              Height = 24
              Cancel = True
              Caption = 'Cancelar Opera'#231#227'o'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -5
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              Visible = False
              OnClick = btOperacaoClick
            end
          end
          object pgOperacoes: TPageControl
            Left = 0
            Top = 42
            Width = 686
            Height = 356
            ActivePage = tsVenda
            Align = alClient
            Images = ImageList1
            TabHeight = 33
            TabOrder = 1
            OnChanging = pgOperacoesChanging
            object tsVenda: TTabSheet
              Caption = 'Venda'
              ImageIndex = 1
              object gbVenda: TGroupBox
                Left = 0
                Top = 0
                Width = 678
                Height = 96
                Align = alTop
                Caption = 'Valores da Opera'#231#227'o'
                TabOrder = 0
                DesignSize = (
                  678
                  96)
                object Label2: TLabel
                  Left = 14
                  Top = 15
                  Width = 54
                  Height = 13
                  Caption = 'Valor Inicial'
                  Color = clBtnFace
                  ParentColor = False
                end
                object Label3: TLabel
                  Left = 94
                  Top = 15
                  Width = 46
                  Height = 13
                  Caption = 'Desconto'
                  Color = clBtnFace
                  ParentColor = False
                end
                object Label4: TLabel
                  Left = 175
                  Top = 15
                  Width = 49
                  Height = 13
                  Caption = 'Acr'#233'scimo'
                  Color = clBtnFace
                  ParentColor = False
                end
                object Label5: TLabel
                  Left = 14
                  Top = 53
                  Width = 65
                  Height = 13
                  Caption = 'Total Oper.'
                  Color = clBtnFace
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -5
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentColor = False
                  ParentFont = False
                end
                object Label6: TLabel
                  Left = 94
                  Top = 53
                  Width = 63
                  Height = 13
                  Caption = 'Total Pago'
                  Color = clBtnFace
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -5
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentColor = False
                  ParentFont = False
                end
                object Label13: TLabel
                  Left = 175
                  Top = 53
                  Width = 34
                  Height = 13
                  Caption = 'Troco'
                  Color = clBtnFace
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -5
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentColor = False
                  ParentFont = False
                end
                object Label34: TLabel
                  Left = 266
                  Top = 15
                  Width = 108
                  Height = 13
                  Caption = 'Tipo de Financiamento'
                  Color = clBtnFace
                  Enabled = False
                  ParentColor = False
                end
                object Label33: TLabel
                  Left = 266
                  Top = 51
                  Width = 41
                  Height = 13
                  Caption = 'Parcelas'
                  Color = clBtnFace
                  Enabled = False
                  ParentColor = False
                end
                object Label35: TLabel
                  Left = 341
                  Top = 51
                  Width = 80
                  Height = 13
                  Caption = 'Data Pr'#233' Datado'
                  Color = clBtnFace
                  Enabled = False
                  ParentColor = False
                end
                object Label36: TLabel
                  Left = 444
                  Top = 15
                  Width = 82
                  Height = 13
                  Caption = 'Dados Adicionais'
                  Color = clBtnFace
                  ParentColor = False
                end
                object edTotalVenda: TEdit
                  Left = 14
                  Top = 66
                  Width = 69
                  Height = 21
                  TabStop = False
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -8
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentFont = False
                  ReadOnly = True
                  TabOrder = 3
                  Text = '0.00'
                end
                object edTotalPago: TEdit
                  Left = 94
                  Top = 66
                  Width = 69
                  Height = 21
                  TabStop = False
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -8
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentFont = False
                  ReadOnly = True
                  TabOrder = 4
                  Text = '0.00'
                end
                object edTroco: TEdit
                  Left = 175
                  Top = 66
                  Width = 69
                  Height = 21
                  TabStop = False
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -8
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentFont = False
                  ReadOnly = True
                  TabOrder = 5
                  Text = '0.00'
                end
                object btEfetuarPagamentos: TBitBtn
                  Left = 443
                  Top = 62
                  Width = 214
                  Height = 24
                  Anchors = [akTop, akRight]
                  Caption = 'Efetuar Pagamento'
                  Default = True
                  Enabled = False
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  TabOrder = 9
                  OnClick = btEfetuarPagamentosClick
                end
                object seValorInicialVenda: TEdit
                  Left = 14
                  Top = 29
                  Width = 69
                  Height = 21
                  TabOrder = 0
                  OnChange = seValorInicialVendaChange
                  OnKeyPress = seValorInicialVendaKeyPress
                end
                object seTotalDesconto: TEdit
                  Left = 94
                  Top = 29
                  Width = 69
                  Height = 21
                  TabOrder = 1
                  OnChange = seTotalDescontoChange
                  OnKeyPress = seValorInicialVendaKeyPress
                end
                object seTotalAcrescimo: TEdit
                  Left = 175
                  Top = 29
                  Width = 69
                  Height = 21
                  TabOrder = 2
                  OnChange = seTotalAcrescimoChange
                  OnKeyPress = seValorInicialVendaKeyPress
                end
                object cbTipoFinanciamento: TComboBox
                  Left = 266
                  Top = 29
                  Width = 159
                  Height = 21
                  Style = csDropDownList
                  ItemHeight = 13
                  ItemIndex = 0
                  TabOrder = 6
                  Text = 'N'#227'o Definido'
                  OnChange = cbTipoFinanciamentoChange
                  Items.Strings = (
                    'N'#227'o Definido'
                    'A VISTA'
                    'Parcelado Emissor'
                    'Parcelado Estabelecimento'
                    'Pr'#233' Datado'
                    'Cr'#233'dito Emissor')
                end
                object seParcelas: TSpinEdit
                  Left = 266
                  Top = 65
                  Width = 61
                  Height = 22
                  Enabled = False
                  MaxValue = 255
                  MinValue = 0
                  TabOrder = 7
                  Value = 0
                end
                object dtPreDatado: TDateTimePicker
                  Left = 341
                  Top = 66
                  Width = 84
                  Height = 23
                  Date = 46006.527646759260000000
                  Time = 46006.527646759260000000
                  Enabled = False
                  TabOrder = 8
                end
                object edParamAdic: TEdit
                  Left = 444
                  Top = 29
                  Width = 214
                  Height = 21
                  Anchors = [akLeft, akTop, akRight]
                  TabOrder = 10
                end
              end
              object gbPagamentos: TGroupBox
                Left = 0
                Top = 96
                Width = 678
                Height = 217
                Align = alClient
                Caption = 'Pagamentos'
                TabOrder = 1
                object sgPagamentos: TStringGrid
                  Left = 2
                  Top = 15
                  Width = 596
                  Height = 200
                  Align = alClient
                  ColCount = 7
                  DefaultColWidth = 30
                  FixedCols = 0
                  RowCount = 1
                  FixedRows = 0
                  TabOrder = 0
                end
                object pBotoesPagamentos: TPanel
                  Left = 598
                  Top = 15
                  Width = 78
                  Height = 200
                  Align = alRight
                  BevelOuter = bvNone
                  TabOrder = 1
                  DesignSize = (
                    78
                    200)
                  object btIncluirPagamentos: TBitBtn
                    Left = 5
                    Top = 9
                    Width = 69
                    Height = 20
                    Anchors = [akTop, akRight]
                    Caption = 'Incluir'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -11
                    Font.Name = 'MS Sans Serif'
                    Font.Style = []
                    ParentFont = False
                    TabOrder = 0
                    OnClick = btIncluirPagamentosClick
                  end
                  object btExcluirPagamento: TBitBtn
                    Left = 5
                    Top = 34
                    Width = 69
                    Height = 20
                    Anchors = [akTop, akRight]
                    Caption = 'Excluir'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -11
                    Font.Name = 'MS Sans Serif'
                    Font.Style = []
                    ParentFont = False
                    TabOrder = 1
                    OnClick = btExcluirPagamentoClick
                  end
                end
              end
            end
            object tsAdm: TTabSheet
              Caption = 'Administrativo'
              ImageIndex = 10
              object gbAdmOutrasFuncoes: TGroupBox
                Left = 0
                Top = 0
                Width = 678
                Height = 56
                Align = alTop
                Caption = 'Outras Fun'#231#245'es'
                TabOrder = 0
                DesignSize = (
                  678
                  56)
                object btAdministrativo: TBitBtn
                  Left = 45
                  Top = 22
                  Width = 144
                  Height = 24
                  Anchors = [akTop, akRight]
                  Caption = 'Menu Administrativo'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  TabOrder = 0
                  OnClick = btAdministrativoClick
                end
                object btCancelarUltima: TBitBtn
                  Left = 218
                  Top = 22
                  Width = 144
                  Height = 24
                  Anchors = [akTop, akRight]
                  Caption = 'Cancelar Ultima'
                  TabOrder = 1
                  OnClick = btCancelarUltimaClick
                end
              end
              object gbAdmPinPad: TGroupBox
                Left = 0
                Top = 56
                Width = 678
                Height = 104
                Align = alTop
                Caption = 'PinPad'
                TabOrder = 1
                DesignSize = (
                  678
                  104)
                object btExibirImagemPinPad: TButton
                  Left = 184
                  Top = 63
                  Width = 116
                  Height = 25
                  Anchors = [akTop, akRight]
                  Caption = 'Enviar Imagem'
                  TabOrder = 3
                  OnClick = btExibirImagemPinPadClick
                end
                object btVerPinPad: TButton
                  Left = 45
                  Top = 21
                  Width = 117
                  Height = 24
                  Anchors = [akTop, akRight]
                  Caption = 'Verificar Presen'#231'a'
                  TabOrder = 0
                  OnClick = btVerPinPadClick
                end
                object btObterCPF: TButton
                  Left = 45
                  Top = 63
                  Width = 117
                  Height = 25
                  Anchors = [akTop, akRight]
                  Caption = 'Solicita CPF'
                  TabOrder = 2
                  OnClick = btObterCPFClick
                end
                object btMsgPinPad: TButton
                  Left = 184
                  Top = 21
                  Width = 116
                  Height = 24
                  Anchors = [akTop, akRight]
                  Caption = 'Enviar Mensagem'
                  TabOrder = 1
                  OnClick = btMsgPinPadClick
                end
                object btMenuPinPad: TButton
                  Left = 325
                  Top = 63
                  Width = 117
                  Height = 25
                  Anchors = [akTop, akRight]
                  Caption = 'Perguntar Menu'
                  TabOrder = 4
                  OnClick = btMenuPinPadClick
                end
              end
            end
          end
        end
      end
    end
    object pLogs: TPanel
      Left = 0
      Top = 443
      Width = 697
      Height = 182
      Align = alClient
      TabOrder = 1
      object sbLimparLog: TSpeedButton
        Left = 424
        Top = 1
        Width = 13
        Height = 66
        OnClick = sbLimparLogClick
      end
      object mLog: TMemo
        Left = 1
        Top = 1
        Width = 695
        Height = 180
        Align = alClient
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
    end
  end
  object pImpressao: TPanel
    Left = 700
    Top = 0
    Width = 300
    Height = 625
    Align = alRight
    BevelOuter = bvNone
    Constraints.MinWidth = 300
    TabOrder = 0
    object lSaidaImpressao: TLabel
      Left = 0
      Top = 122
      Width = 300
      Height = 26
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'Sa'#237'da de Impress'#227'o'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
      OnClick = lSaidaImpressaoClick
    end
    object lURLTEF: TLabel
      Left = 0
      Top = 0
      Width = 300
      Height = 13
      Cursor = crHandPoint
      Align = alTop
      Alignment = taCenter
      Caption = 'projetoacbr.com.br/tef'
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -9
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
      OnClick = lURLTEFClick
    end
    object mImpressao: TMemo
      Left = 0
      Top = 148
      Width = 300
      Height = 343
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -7
      Font.Name = 'Lucida Console'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      WordWrap = False
    end
    object pSimulador: TPanel
      Left = 0
      Top = 577
      Width = 300
      Height = 48
      Align = alBottom
      TabOrder = 1
      DesignSize = (
        300
        48)
      object btMudaPagina: TBitBtn
        Left = 101
        Top = 4
        Width = 96
        Height = 39
        Anchors = [akTop]
        Caption = 'Opera'#231'oes'
        TabOrder = 0
        OnClick = btMudaPaginaClick
        Layout = blGlyphTop
      end
    end
    object pMensagem: TPanel
      Left = 0
      Top = 13
      Width = 300
      Height = 109
      Align = alTop
      Anchors = []
      BevelInner = bvLowered
      BevelWidth = 2
      BorderStyle = bsSingle
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      Visible = False
      object pMensagemOperador: TPanel
        Left = 4
        Top = 4
        Width = 288
        Height = 40
        Align = alTop
        TabOrder = 0
        Visible = False
        object lTituloMsgOperador: TLabel
          Left = 1
          Top = 1
          Width = 286
          Height = 13
          Align = alTop
          Caption = 'Mensagem Operador'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -5
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object lMensagemOperador: TLabel
          Left = 1
          Top = 14
          Width = 286
          Height = 25
          Align = alClient
          Alignment = taCenter
          Caption = 'lMensagemOperador'
          Color = clBtnFace
          ParentColor = False
          Layout = tlCenter
          WordWrap = True
        end
      end
      object pMensagemCliente: TPanel
        Left = 4
        Top = 44
        Width = 288
        Height = 57
        Align = alClient
        TabOrder = 1
        Visible = False
        object lTituloMensagemCliente: TLabel
          Left = 1
          Top = 1
          Width = 286
          Height = 13
          Align = alTop
          Caption = 'Mensagem Cliente'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -5
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object lMensagemCliente: TLabel
          Left = 1
          Top = 14
          Width = 286
          Height = 42
          Align = alClient
          Alignment = taCenter
          Caption = 'lMensagemCliente'
          Color = clBtnFace
          ParentColor = False
          Layout = tlCenter
          WordWrap = True
        end
      end
    end
    object pImpressoraBotes: TPanel
      Left = 0
      Top = 539
      Width = 300
      Height = 38
      Align = alBottom
      TabOrder = 3
      DesignSize = (
        300
        38)
      object btImprimir: TBitBtn
        Left = 157
        Top = 5
        Width = 57
        Height = 27
        Anchors = [akTop, akRight]
        Caption = 'Imprimir'
        TabOrder = 2
        OnClick = btImprimirClick
      end
      object btLimparImpressora: TBitBtn
        Left = 219
        Top = 5
        Width = 56
        Height = 27
        Anchors = [akTop, akRight]
        Caption = 'Limpar'
        TabOrder = 3
        OnClick = btLimparImpressoraClick
      end
      object cbEnviarImpressora: TCheckBox
        Left = 4
        Top = 4
        Width = 111
        Height = 13
        Caption = 'Enviar Impressora'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object cbSimularErroNoDoctoFiscal: TCheckBox
        Left = 4
        Top = 20
        Width = 128
        Height = 15
        Caption = 'Simular Erro Doc.Fiscal'
        TabOrder = 1
      end
    end
    object pQRCode: TPanel
      Left = 0
      Top = 491
      Width = 300
      Height = 48
      Align = alBottom
      TabOrder = 4
      Visible = False
      object imgQRCode: TImage
        Left = 1
        Top = 1
        Width = 298
        Height = 46
        Align = alClient
        Center = True
        Proportional = True
        Stretch = True
      end
    end
  end
  object ImageList1: TImageList
    Left = 880
    Top = 176
    Bitmap = {
      494C01010D000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F3F3
      F30000000000A0A0A00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000003C3C3C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B4B4B400202020000000000040404000000000003C3C3C00000000007070
      7000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A0A0
      A0000000000000000000000000000000000000000000000000006C6C6C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7E7E7000000
      0000E3E3E3000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001C1C
      1C00000000000000000000000000000000000000000000000000585858000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007C7C
      7C000000000000000000000000000000000000000000000000001C1C1C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004848
      4800000000000000000000000000000000000000000000000000444444000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000444444000000
      000000000000000000000000000000000000A0A0A00000000000DFDFDF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004848
      48000000000014141400606060000C0C0C0000000000CFCFCF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000054545400000000000000000000000000FBFBFB0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F3F3F30060606000181818001C1C1C0068686800F7F7F7000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F3F3F30060606000181818001C1C1C0068686800F7F7F7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F3F3F3005C5C5C00181818001C1C1C0064646400F7F7F7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000101010000000000000000000000000000000000000000000000000001818
      1800000000000000000000000000000000000000000000000000000000000000
      0000101010000000000000000000000000000000000000000000000000001818
      18000000000000000000000000000000000000000000B4B4B400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DBDBDB00000000000000000000000000000000000000
      0000101010000000000000000000000000000000000000000000000000001818
      1800000000000000000000000000000000000000000000000000000000003C3C
      3C00000000000000000000000000000000000000000000000000000000000000
      0000545454000000000000000000000000000000000000000000000000003C3C
      3C00000000000000000000000000000000000000000000000000000000000000
      0000545454000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000010101000000000000000000000000000000000003C3C
      3C00000000000000000000000000000000000000000000000000000000000000
      0000545454000000000000000000000000000000000000000000101010000000
      0000000000000000000000000000404040004040400000000000000000000000
      0000000000002424240000000000000000000000000000000000101010000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002424240000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000101010000000
      00000000000050505000000000000000000000000000000000004C4C4C000000
      00000000000024242400000000000000000000000000F3F3F300000000000000
      0000000000000000000000000000808080008080800000000000000000000000
      00000000000000000000000000000000000000000000F3F3F300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F3F3F300000000000000
      00005050500000000000909090000000000000000000ACACAC00000000003030
      3000000000000000000000000000000000000000000060606000000000000000
      0000000000000000000000000000808080008080800000000000000000000000
      0000000000000000000080808000000000000000000060606000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005C5C5C00000000000000
      000000000000909090000000000090909000ACACAC0000000000707070000000
      000000000000000000007C7C7C00000000000000000018181800000000000000
      0000404040008080800080808000BFBFBF00BFBFBF0080808000808080004040
      4000000000000000000038383800000000000000000018181800000000000000
      0000404040008080800080808000808080008080800080808000808080004040
      4000000000000000000038383800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000018181800000000000000
      0000000000000000000090909000000000000000000070707000000000000000
      000000000000000000003838380000000000000000001C1C1C00000000000000
      0000404040008080800080808000BFBFBF00BFBFBF0080808000808080004040
      400000000000000000003C3C3C0000000000000000001C1C1C00000000000000
      0000404040008080800080808000808080008080800080808000808080004040
      400000000000000000003C3C3C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001C1C1C00000000000000
      00000000000000000000ACACAC00000000000000000090909000000000000000
      000000000000000000003C3C3C00000000000000000068686800000000000000
      0000000000000000000000000000808080008080800000000000000000000000
      0000000000000000000088888800000000000000000068686800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000088888800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000064646400000000000000
      000000000000ACACAC0000000000707070009090900000000000909090000000
      00000000000000000000848484000000000000000000F7F7F700000000000000
      0000000000000000000000000000808080008080800000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700000000000000
      00004C4C4C000000000070707000000000000000000090909000000000003030
      3000000000000000000000000000000000000000000000000000181818000000
      0000000000000000000000000000404040004040400000000000000000000000
      0000000000003030300000000000000000000000000000000000181818000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000003030300000000000000000000000000098989800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008C8C8C00000000000000000000000000181818000000
      0000000000003030300000000000000000000000000000000000303030000000
      0000000000003030300000000000000000000000000000000000000000005454
      5400000000000000000000000000000000000000000000000000000000000000
      0000707070000000000000000000000000000000000000000000000000005454
      5400000000000000000000000000000000000000000000000000000000000000
      0000707070000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005454
      5400000000000000000000000000000000000000000000000000000000000000
      0000707070000000000000000000000000000000000000000000000000000000
      0000242424000000000000000000000000000000000000000000000000003030
      3000000000000000000000000000000000000000000000000000000000000000
      0000242424000000000000000000000000000000000000000000000000003030
      3000000000000000000000000000000000000000000000000000000000000000
      0000000000002C2C2C0000000000000000000000000000000000303030000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000242424000000000000000000000000000000000000000000000000003030
      3000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000383838003C3C3C0088888800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000383838003C3C3C0088888800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FBFBFB002C2C2C0000000000000000004C4C4C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007C7C7C00383838003C3C3C0084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F3F3F30060606000181818001C1C1C0068686800F7F7F7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000101010000000000000000000000000000000000000000000000000001818
      1800000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080008080800080808000808080000000
      0000000000000000000000000000000000000000000000000000000000003C3C
      3C00000000000000000000000000000000000000000000000000000000000000
      0000545454000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000080808000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800080808000000000000000000000000000101010000000
      0000000000000000000028282800000000000000000000000000000000000000
      0000000000002424240000000000000000000000000000000000000000000000
      0000707070000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F3F3F300000000000000
      0000000000002828280000000000E7E7E7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000060606000000000000000
      00002828280000000000E7E7E700000000002828280000000000000000000000
      0000000000000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000018181800000000000000
      000000000000E7E7E700000000003C3C3C000000000028282800000000000000
      0000000000000000000038383800000000000000000000000000000000008888
      8800000000000000000000000000000000000000000000000000000000000000
      0000909090000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001010100000000000000000001C1C1C00000000000000
      0000282828000000000000000000000000003C3C3C0000000000E7E7E7000000
      000000000000000000003C3C3C00000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A0A0A000000000000000000068686800000000000000
      000000000000000000000000000000000000000000003C3C3C0000000000E7E7
      E700000000000000000088888800000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000909090001010
      1000000000000000000000000000000000000000000000000000000000000000
      000010101000A0A0A000000000000000000000000000F7F7F700000000000000
      00000000000000000000000000000000000000000000000000003C3C3C000000
      0000282828000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000181818000000
      0000000000000000000000000000000000000000000000000000000000003C3C
      3C0000000000303030000000000000000000000000000000000000000000BFBF
      BF00000000008080800080808000404040004040400080808000808080000000
      0000BFBFBF000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005454
      5400000000000000000000000000000000000000000000000000000000000000
      0000707070000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000BFBFBF00BFBFBF0000000000000000000000
      0000000000000000000000000000000000000000000080808000808080006868
      6800000000000000000000000000686868008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000242424000000000000000000000000000000000000000000000000003030
      3000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000383838003C3C3C0088888800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000000000000000000000000000000000000000000000000000B4B4
      B400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CFCFCF00E7E7E70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D7D7D700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000404
      0400000000000000000000000000F7F7F7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004C4C4C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006C6C6C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000040404000000
      0000000000000000000000000000F7F7F7000000000058585800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A8A8A800000000000000000000000000000000000000
      0000000000000000000000000000444444003838380000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000ACACAC0000000000000000000000
      0000000000002828280000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000282828000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B0B0B000141414000000
      000000000000000000000000000000000000D7D7D70000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000EBEBEB00FBFBFB0000000000040404000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000ACACAC0000000000000000008C8C8C00000000000000
      000000000000000000000000000000000000000000000000000000000000E7E7
      E7000000000000000000000000000000000000000000D7D7D700000000000000
      0000000000000000000000000000000000000000000000000000BFBFBF000000
      000000000000000000000000000000000000000000000000000000000000E7E7
      E700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000242424001C1C1C0000000000000000000000
      00000000000000000000000000000000000000000000DBDBDB00000000000000
      0000000000000000000000000000000000000000000000000000D7D7D7000000
      000000000000000000000000000000000000000000000C0C0C00000000000000
      0000000000000000000000000000000000000000000028282800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FBFBFB000000
      00000000000034343400D7D7D70000000000EFEFEF005C5C5C00000000000000
      000000000000000000000000000000000000EBEBEB0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007878
      7800E7E7E7000000000000000000000000007C7C7C0000000000000000003C3C
      3C00282828000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000CBCBCB00505050002020200040404000B0B0B000000000000000
      000000000000E7E7E70000000000000000006C6C6C00000000003C3C3C000000
      0000000000002828280000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E7E7E7000000000000000000FBFBFB00000000000000
      0000000000001818180000000000000000000404040000000000000000000000
      0000000000000000000000000000000000000000000098989800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008C8C8C00000000000000000000000000000000004040
      4000808080008080800080808000808080008080800080808000000000000000
      0000909090000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000018181800000000000000000000000000F3F3F30000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000686868000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D7D7
      D700000000000000000000000000505050000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BFBFBF00D3D3D30000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FFFF000000000000
      FFF7000000000000FFE3000000000000FFCF000000000000F08F000000000000
      E01F000000000000C73F000000000000CF9F000000000000CF9F000000000000
      CF9F000000000000CF1F000000000000E03F000000000000F07F000000000000
      FFFF000000000000FFFF000000000000FFFFFFFFFFFFFFFFF81FF81FFFFFF81F
      F00FF00F8001F00FE007E0078001E007C003C0038001C0038003800380018423
      8001800180018241800180018001818180018001800181818001800180018241
      8003800380018423C003C0038001C003E007E007F99FE007F00FF00FF81FF00F
      FC3FFC3FF83FFC3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF81FF81FFFFF
      F00FF00FF81FFFFFF00FE007F81FC0FF87E1C003F00FC04787E18203F00FC07F
      87E18501F00FC07F80018881E007C04380098041E007C07F80018021E007C041
      C0038013E007C041F00FC003E007807FF00FE007F66F807FF00FF00FF00FFFFF
      FFFFFC3FF00FFFFFFFFFFFFFFFFFFFFFFFF3FFFFFFFFFFFFFFF1FFFFFFFFFFFF
      FFE0FFFFC003FFFFFFC08001C003FFFFFF039FF9C3C3FFFFFF079FF9C3C39F01
      F20F9FF9C1838F81C00F9FF9C0038FC1803F8001C003C101007F8001C003F001
      007F8001CFC3F839187F9FF9CFC3FFFDB87F8001C007FFFFF07FFFFFC00FFFFF
      E0FFFFFFFFFFFFFFF3FFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object ACBrPosPrinter1: TACBrPosPrinter
    ConfigBarras.MostrarCodigo = False
    ConfigBarras.LarguraLinha = 0
    ConfigBarras.Altura = 0
    ConfigBarras.Margem = 0
    ConfigQRCode.Tipo = 2
    ConfigQRCode.LarguraModulo = 4
    ConfigQRCode.ErrorLevel = 0
    ConfigImagem.ModoLegado = True
    ConfigImagem.AddLF = True
    LinhasEntreCupons = 0
    Left = 813
    Top = 176
  end
  object ACBrAbecsPinPad1: TACBrAbecsPinPad
    OnWriteLog = ACBrAbecsPinPad1WriteLog
    Left = 845
    Top = 176
  end
  object ACBrTEFAPI1: TACBrTEFAPI
    DadosAutomacao.AutoAtendimento = False
    DadosTerminal.Ambiente = ambNaoDefinido
    DadosTerminal.GravarLogTEF = False
    QuandoGravarLog = ACBrTEFAPI1QuandoGravarLog
    QuandoFinalizarOperacao = ACBrTEFAPI1QuandoFinalizarOperacao
    QuandoFinalizarTransacao = ACBrTEFAPI1QuandoFinalizarTransacao
    QuandoDetectarTransacaoPendente = ACBrTEFAPI1QuandoDetectarTransacaoPendente
    QuandoEsperarOperacao = ACBrTEFAPI1QuandoEsperarOperacao
    QuandoExibirMensagem = ACBrTEFAPI1QuandoExibirMensagem
    QuandoPerguntarMenu = ACBrTEFAPI1QuandoPerguntarMenu
    QuandoPerguntarCampo = ACBrTEFAPI1QuandoPerguntarCampo
    QuandoExibirQRCode = ACBrTEFAPI1QuandoExibirQRCode
    Left = 781
    Top = 176
  end
end
