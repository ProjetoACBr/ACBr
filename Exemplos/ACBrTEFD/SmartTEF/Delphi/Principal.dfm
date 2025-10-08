object frPrincipal: TfrPrincipal
  Left = 491
  Top = 199
  Width = 983
  Height = 603
  Caption = 'SmartTEF Teste'
  Color = clBtnFace
  TransparentColorValue = clDefault
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lURLTEF: TLabel
    Left = 0
    Top = 544
    Width = 967
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'https://projetoacbr.com.br/tef'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = False
    OnClick = lURLTEFClick
  end
  object pcPrincipal: TPageControl
    Left = 0
    Top = 0
    Width = 967
    Height = 544
    ActivePage = tsEndpoints
    Align = alClient
    Images = ImageList1
    TabHeight = 30
    TabOrder = 0
    TabWidth = 300
    object tsEndpoints: TTabSheet
      Caption = 'Endpoints'
      ImageIndex = 14
      object Splitter1: TSplitter
        Left = 591
        Top = 0
        Width = 5
        Height = 504
        Align = alRight
      end
      object pnEndpointsLog: TPanel
        Left = 596
        Top = 0
        Width = 363
        Height = 504
        Align = alRight
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object lbEndpointsLog: TLabel
          Left = 0
          Top = 0
          Width = 363
          Height = 13
          Align = alTop
          Caption = 'Log das Opera'#231#245'es'
        end
        object mmEndpointsLog: TMemo
          Left = 0
          Top = 13
          Width = 363
          Height = 460
          Align = alClient
          BorderStyle = bsNone
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
        end
        object pnEndpointsLogRodape: TPanel
          Left = 0
          Top = 473
          Width = 363
          Height = 31
          Align = alBottom
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 1
          DesignSize = (
            363
            31)
          object btEndpointsLogLimpar: TBitBtn
            Left = 261
            Top = 4
            Width = 83
            Height = 26
            Anchors = [akTop]
            Caption = 'Limpar'
            TabOrder = 0
            OnClick = btEndpointsLogLimparClick
          end
        end
      end
      object pcEndpoints: TPageControl
        Left = 0
        Top = 0
        Width = 591
        Height = 504
        ActivePage = tsERP
        Align = alClient
        Images = ImageList1
        TabHeight = 30
        TabOrder = 1
        TabWidth = 150
        object tsIntegrador: TTabSheet
          Caption = 'Integrador'
          ImageIndex = 30
          object pcIntegrador: TPageControl
            Left = 0
            Top = 0
            Width = 583
            Height = 464
            ActivePage = tsIntegradorCriarLoja
            Align = alClient
            TabHeight = 30
            TabOrder = 0
            TabWidth = 146
            object tsIntegradorCriarLoja: TTabSheet
              Caption = 'Criar Loja'
              object pnIntegradorCriarLoja: TPanel
                Left = 0
                Top = 0
                Width = 575
                Height = 419
                Align = alClient
                BevelOuter = bvNone
                ParentBackground = False
                TabOrder = 0
                DesignSize = (
                  575
                  424)
                object lbIntegradorCriarLojaCNPJIntegrador: TLabel
                  Left = 20
                  Top = 20
                  Width = 78
                  Height = 13
                  Caption = 'CNPJ Integrador'
                end
                object lbIntegradorCriarLojaCNPJ: TLabel
                  Left = 295
                  Top = 20
                  Width = 27
                  Height = 13
                  Caption = 'CNPJ'
                end
                object lbIntegradorCriarLojaEmail: TLabel
                  Left = 20
                  Top = 72
                  Width = 28
                  Height = 13
                  Caption = 'E-mail'
                end
                object lbIntegradorCriarLojaSenha: TLabel
                  Left = 295
                  Top = 72
                  Width = 31
                  Height = 13
                  Caption = 'Senha'
                end
                object lbIntegradorCriarLojaNome: TLabel
                  Left = 20
                  Top = 128
                  Width = 28
                  Height = 13
                  Caption = 'Nome'
                end
                object lbIntegradorCriarLojaNomeLoja: TLabel
                  Left = 20
                  Top = 184
                  Width = 51
                  Height = 13
                  Caption = 'Nome Loja'
                end
                object btIntegradorCriarLojaSenha: TSpeedButton
                  Left = 532
                  Top = 87
                  Width = 23
                  Height = 23
                  AllowAllUp = True
                  Anchors = [akTop, akRight]
                  GroupIndex = 1
                  Flat = True
                  OnClick = btIntegradorCriarLojaSenhaClick
                end
                object edIntegradorCriarLojaCNPJIntegrador: TEdit
                  Left = 20
                  Top = 35
                  Width = 260
                  Height = 23
                  TabOrder = 0
                end
                object edIntegradorCriarLojaCNPJ: TEdit
                  Left = 295
                  Top = 35
                  Width = 260
                  Height = 23
                  TabOrder = 1
                end
                object edIntegradorCriarLojaEmail: TEdit
                  Left = 20
                  Top = 87
                  Width = 260
                  Height = 23
                  TabOrder = 2
                end
                object edIntegradorCriarLojaSenha: TEdit
                  Left = 295
                  Top = 87
                  Width = 237
                  Height = 23
                  PasswordChar = '*'
                  TabOrder = 3
                end
                object edIntegradorCriarLojaNome: TEdit
                  Left = 20
                  Top = 143
                  Width = 535
                  Height = 23
                  TabOrder = 4
                end
                object edIntegradorCriarLojaNomeLoja: TEdit
                  Left = 20
                  Top = 199
                  Width = 535
                  Height = 23
                  TabOrder = 5
                end
                object btIntegradorCriarLoja: TBitBtn
                  Left = 435
                  Top = 248
                  Width = 120
                  Height = 30
                  Caption = 'Criar'
                  TabOrder = 6
                end
              end
            end
          end
        end
        object tsERP: TTabSheet
          Caption = 'ERPs'
          ImageIndex = 23
          object pcERP: TPageControl
            Left = 0
            Top = 0
            Width = 583
            Height = 464
            ActivePage = tsOrdemPagamento
            Align = alClient
            TabHeight = 30
            TabOrder = 0
            TabWidth = 143
            object tsOrdemPagamento: TTabSheet
              Caption = 'Ordens de Pagamento'
              object pcOrdemPagamento: TPageControl
                Left = 0
                Top = 0
                Width = 575
                Height = 424
                ActivePage = tsOrdemPagamentoCriar
                Align = alClient
                TabHeight = 30
                TabOrder = 0
                TabWidth = 139
                object tsOrdemPagamentoCriar: TTabSheet
                  Caption = 'Criar'
                  object pnOrdemPagamentoCriar: TPanel
                    Left = 0
                    Top = 0
                    Width = 567
                    Height = 384
                    Align = alClient
                    BevelOuter = bvNone
                    ParentBackground = False
                    TabOrder = 0
                    DesignSize = (
                      567
                      384)
                    object lbOrdemPagamentoCriarParcelas: TLabel
                      Left = 291
                      Top = 20
                      Width = 41
                      Height = 13
                      Hint = 'Obrigat'#243'rio apenas quando o payment_type for'#13#10#8220'CREDIT'#8221'.'
                      Caption = 'Parcelas'
                      Enabled = False
                    end
                    object lbOrdemPagamentoCriarSerialPOS: TLabel
                      Left = 427
                      Top = 70
                      Width = 51
                      Height = 13
                      Hint = 
                        'O Serial do POS que ir'#225' receber o card.'#13#10'Sendo obrigat'#243'rio apena' +
                        's quando o order_type for'#13#10#8220'CRD_UNICO'#8221'.'#13#10#13#10'ATEN'#199#195'O n'#227'o pode ser ' +
                        'enviado junto com o user_id'#13
                      Caption = 'Serial POS'
                    end
                    object lbOrdemPagamentoCriarIdUsuario: TLabel
                      Left = 291
                      Top = 70
                      Width = 50
                      Height = 13
                      Hint = 
                        'O ID do usu'#225'rio logado que ir'#225' receber o card.'#13#10'Sendo obrigat'#243'ri' +
                        'o apenas quando o order_type for'#13#10#8220'CRD_UNICO'#8221'.'#13#10#13#10'ATEN'#199#195'O n'#227'o po' +
                        'de ser enviado junto com o'#13#10'Serial_pos'#13
                      Caption = 'ID Usuario'
                    end
                    object lbOrdemPagamentoCriarValor: TLabel
                      Left = 427
                      Top = 20
                      Width = 24
                      Height = 13
                      Hint = #201' o valor do pagamento, com separador de dezena.'
                      Caption = 'Valor'
                      Color = clBtnFace
                      ParentColor = False
                    end
                    object lbOrdemPagamentoCriarTipoPagamento: TLabel
                      Left = 156
                      Top = 20
                      Width = 78
                      Height = 13
                      Caption = 'Tipo Pagamento'
                      Color = clBtnFace
                      ParentColor = False
                    end
                    object lbOrdemPagamentoCriarChargeId: TLabel
                      Left = 20
                      Top = 20
                      Width = 46
                      Height = 13
                      Hint = 'Campo de identifica'#231#227'o em string'
                      Caption = 'Charge Id'
                    end
                    object lbOrdemPagamentoCriarTipoJuros: TLabel
                      Left = 156
                      Top = 70
                      Width = 49
                      Height = 13
                      Hint = 
                        'Tipo de juros em pagamento de Cr'#233'dito, podendo ser:'#13#10'- F_STORE -' +
                        ' '#233' o padr'#227'o e a loja paga os juros do'#13#10'parcelamento;'#13#10'- F_CLIENT' +
                        ' - e o cliente que paga.'
                      Caption = 'Tipo Juros'
                      Color = clBtnFace
                      ParentColor = False
                    end
                    object lbOrdemPagamentoCriarTipoOrdem: TLabel
                      Left = 20
                      Top = 70
                      Width = 55
                      Height = 13
                      Caption = 'Tipo Ordem'
                      Color = clBtnFace
                      ParentColor = False
                    end
                    object edOrdemPagamentoCriarSerialPOS: TEdit
                      Left = 427
                      Top = 85
                      Width = 120
                      Height = 21
                      Hint = 
                        'O Serial do POS que ir'#225' receber o card.'#13#10'Sendo obrigat'#243'rio apena' +
                        's quando o order_type for'#13#10#8220'CRD_UNICO'#8221'.'#13#10#13#10'ATEN'#199#195'O n'#227'o pode ser ' +
                        'enviado junto com o user_id'#13
                      TabOrder = 7
                    end
                    object edOrdemPagamentoCriarIdUsuario: TEdit
                      Left = 291
                      Top = 85
                      Width = 120
                      Height = 21
                      Hint = 
                        'O ID do usu'#225'rio logado que ir'#225' receber o card.'#13#10'Sendo obrigat'#243'ri' +
                        'o apenas quando o order_type for'#13#10#8220'CRD_UNICO'#8221'.'#13#10#13#10'ATEN'#199#195'O n'#227'o po' +
                        'de ser enviado junto com o'#13#10'Serial_pos'#13
                      TabOrder = 6
                    end
                    object btOrdemPagamentoCriar: TBitBtn
                      Left = 427
                      Top = 230
                      Width = 120
                      Height = 30
                      Caption = 'Criar'
                      TabOrder = 10
                      OnClick = btOrdemPagamentoCriarClick
                    end
                    object edOrdemPagamentoCriarValor: TEdit
                      Left = 427
                      Top = 35
                      Width = 120
                      Height = 21
                      Hint = #201' o valor do pagamento, com separador de dezena.'
                      TabOrder = 3
                      Text = '1,00'
                    end
                    object cbOrdemPagamentoCriarTipoPagamento: TComboBox
                      Left = 156
                      Top = 35
                      Width = 120
                      Height = 21
                      Style = csDropDownList
                      ItemHeight = 13
                      TabOrder = 1
                      OnSelect = cbOrdemPagamentoCriarTipoPagamentoSelect
                    end
                    object edOrdemPagamentoCriarChargeId: TEdit
                      Left = 20
                      Top = 35
                      Width = 123
                      Height = 21
                      Hint = 'Campo de identifica'#231#227'o em string'
                      TabOrder = 0
                    end
                    object edOrdemPagamentoCriarParcelas: TSpinEdit
                      Left = 291
                      Top = 35
                      Width = 120
                      Height = 22
                      Hint = 'Obrigat'#243'rio apenas quando o payment_type for'#13#10#8220'CREDIT'#8221'.'
                      Anchors = [akTop, akRight]
                      Enabled = False
                      MaxValue = 9999
                      MinValue = 0
                      TabOrder = 2
                      Value = 0
                    end
                    object cbOrdemPagamentoCriarTipoJuros: TComboBox
                      Left = 156
                      Top = 85
                      Width = 120
                      Height = 21
                      Hint = 
                        'Tipo de juros em pagamento de Cr'#233'dito, podendo ser:'#13#10'- F_STORE -' +
                        ' '#233' o padr'#227'o e a loja paga os juros do'#13#10'parcelamento;'#13#10'- F_CLIENT' +
                        ' - e o cliente que paga.'
                      Style = csDropDownList
                      ItemHeight = 13
                      TabOrder = 5
                    end
                    object cbOrdemPagamentoCriarTipoOrdem: TComboBox
                      Left = 20
                      Top = 85
                      Width = 123
                      Height = 21
                      Style = csDropDownList
                      ItemHeight = 13
                      TabOrder = 4
                    end
                    object gbOrdemPagamentoCriarDetalhes: TGroupBox
                      Left = 20
                      Top = 130
                      Width = 527
                      Height = 89
                      Enabled = False
                      ParentBackground = False
                      TabOrder = 9
                      object pnOrdemPagamentoCriarDetalhes: TPanel
                        Left = 2
                        Top = 15
                        Width = 523
                        Height = 72
                        Align = alClient
                        BevelOuter = bvNone
                        ParentBackground = False
                        TabOrder = 0
                        object lbOrdemPagamentoCriarCPF: TLabel
                          Left = 20
                          Top = 10
                          Width = 20
                          Height = 13
                          Caption = 'CPF'
                        end
                        object lbOrdemPagamentoCriarCNPJ: TLabel
                          Left = 186
                          Top = 10
                          Width = 27
                          Height = 13
                          Caption = 'CNPJ'
                        end
                        object lbOrdemPagamentoCriarNome: TLabel
                          Left = 352
                          Top = 10
                          Width = 28
                          Height = 13
                          Caption = 'Nome'
                        end
                        object edOrdemPagamentoCriarCPF: TEdit
                          Left = 20
                          Top = 25
                          Width = 151
                          Height = 21
                          TabOrder = 0
                        end
                        object edOrdemPagamentoCriarCNPJ: TEdit
                          Left = 186
                          Top = 25
                          Width = 151
                          Height = 21
                          TabOrder = 1
                        end
                        object edOrdemPagamentoCriarNome: TEdit
                          Left = 352
                          Top = 25
                          Width = 151
                          Height = 21
                          TabOrder = 2
                        end
                      end
                    end
                    object cbOrdemPagamentoCriarDetalhes: TCheckBox
                      Left = 25
                      Top = 128
                      Width = 95
                      Height = 19
                      Hint = 'Caso a op'#231#227'o seja false, n'#227'o ser'#225' exibido tela'
                      Caption = 'Exibir Detalhes'
                      TabOrder = 8
                      OnClick = cbOrdemPagamentoCriarDetalhesChange
                    end
                  end
                end
                object tsOrdemPagamentoConsultar: TTabSheet
                  Caption = 'Consultar'
                  object pnOrdemPagamentoConsultar: TPanel
                    Left = 0
                    Top = 0
                    Width = 567
                    Height = 381
                    Align = alClient
                    BevelOuter = bvNone
                    ParentBackground = False
                    TabOrder = 0
                    object lbOrdemPagamentoConsultarChargeId: TLabel
                      Left = 291
                      Top = 20
                      Width = 46
                      Height = 13
                      Hint = 'Campo de identifica'#231#227'o em string'
                      Caption = 'Charge Id'
                    end
                    object lbOrdemPagamentoConsultarPaymentIdentifier: TLabel
                      Left = 20
                      Top = 20
                      Width = 84
                      Height = 13
                      Hint = 'Campo de identifica'#231#227'o em string'
                      Caption = 'Payment Identifier'
                    end
                    object edOrdemPagamentoConsultarChargeId: TEdit
                      Left = 291
                      Top = 35
                      Width = 256
                      Height = 23
                      Hint = 'Campo de identifica'#231#227'o em string'
                      TabOrder = 1
                    end
                    object edOrdemPagamentoConsultarPaymentIdentifier: TEdit
                      Left = 20
                      Top = 35
                      Width = 256
                      Height = 23
                      Hint = 'Campo de identifica'#231#227'o em string'
                      TabOrder = 0
                    end
                    object btOrdemPagamentoConsultar: TBitBtn
                      Left = 427
                      Top = 80
                      Width = 120
                      Height = 30
                      Caption = 'Consultar'
                      TabOrder = 2
                      OnClick = btOrdemPagamentoConsultarClick
                    end
                  end
                end
                object tsOrdemPagamentoCancelar: TTabSheet
                  Caption = 'Cancelar'
                  object pnOrdemPagamentoCancelar: TPanel
                    Left = 0
                    Top = 0
                    Width = 567
                    Height = 381
                    Align = alClient
                    BevelOuter = bvNone
                    ParentBackground = False
                    TabOrder = 0
                    object lbOrdemPagamentoCancelarPaymentIdentifier: TLabel
                      Left = 20
                      Top = 20
                      Width = 84
                      Height = 13
                      Hint = 'Campo de identifica'#231#227'o em string'
                      Caption = 'Payment Identifier'
                    end
                    object edOrdemPagamentoCancelarPaymentIdentifier: TEdit
                      Left = 20
                      Top = 35
                      Width = 527
                      Height = 23
                      Hint = 'Campo de identifica'#231#227'o em string'
                      TabOrder = 0
                    end
                    object btOrdemPagamentoCancelar: TBitBtn
                      Left = 427
                      Top = 80
                      Width = 120
                      Height = 30
                      Caption = 'Cancelar'
                      TabOrder = 1
                      OnClick = btOrdemPagamentoCancelarClick
                    end
                  end
                end
                object tsOrdemPagamentoEstornar: TTabSheet
                  Caption = 'Estornar'
                  object pnOrdemPagamentoEstornar: TPanel
                    Left = 0
                    Top = 0
                    Width = 567
                    Height = 381
                    Align = alClient
                    BevelOuter = bvNone
                    ParentBackground = False
                    TabOrder = 0
                    object lbOrdemPagamentoEstornarPaymentIdentifier: TLabel
                      Left = 20
                      Top = 20
                      Width = 84
                      Height = 13
                      Hint = 'Campo de identifica'#231#227'o em string'
                      Caption = 'Payment Identifier'
                    end
                    object edOrdemPagamentoEstornarPaymentIdentifier: TEdit
                      Left = 20
                      Top = 35
                      Width = 527
                      Height = 23
                      Hint = 'Campo de identifica'#231#227'o em string'
                      TabOrder = 0
                    end
                    object btOrdemPagamentoEstornar: TBitBtn
                      Left = 427
                      Top = 80
                      Width = 120
                      Height = 30
                      Caption = 'Estornar'
                      TabOrder = 1
                      OnClick = btOrdemPagamentoEstornarClick
                    end
                  end
                end
              end
            end
            object tsOrdemImpressao: TTabSheet
              Caption = 'Ordens de Impress'#227'o'
              object pcOrdemImpressao: TPageControl
                Left = 0
                Top = 0
                Width = 575
                Height = 424
                ActivePage = tsOrdemImpressaoCriar
                Align = alClient
                TabHeight = 30
                TabOrder = 0
                TabWidth = 139
                object tsOrdemImpressaoCriar: TTabSheet
                  Caption = 'Criar'
                  object pnOrdemImpressaoCriar: TPanel
                    Left = 0
                    Top = 0
                    Width = 567
                    Height = 381
                    Align = alClient
                    BevelOuter = bvNone
                    ParentBackground = False
                    TabOrder = 0
                    DesignSize = (
                      567
                      384)
                    object lbOrdemImpressaoCriarSerialPOS: TLabel
                      Left = 427
                      Top = 20
                      Width = 51
                      Height = 13
                      Hint = 
                        'O Serial do POS que ir'#225' receber o card.'#13#10'Sendo obrigat'#243'rio apena' +
                        's quando o order_type for'#13#10#8220'CRD_UNICO'#8221'.'#13#10#13#10'ATEN'#199#195'O n'#227'o pode ser ' +
                        'enviado junto com o user_id'#13
                      Caption = 'Serial POS'
                    end
                    object lbOrdemImpressaoCriarIdUsuario: TLabel
                      Left = 291
                      Top = 20
                      Width = 50
                      Height = 13
                      Hint = 
                        'O ID do usu'#225'rio logado que ir'#225' receber o card.'#13#10'Sendo obrigat'#243'ri' +
                        'o apenas quando o order_type for'#13#10#8220'CRD_UNICO'#8221'.'#13#10#13#10'ATEN'#199#195'O n'#227'o po' +
                        'de ser enviado junto com o'#13#10'Serial_pos'#13
                      Caption = 'ID Usuario'
                    end
                    object lbOrdemImpressaoCriarTipoOrdem: TLabel
                      Left = 20
                      Top = 20
                      Width = 55
                      Height = 13
                      Caption = 'Tipo Ordem'
                      Color = clBtnFace
                      ParentColor = False
                    end
                    object lbOrdemImpressaoCriarArquivo: TLabel
                      Left = 20
                      Top = 70
                      Width = 36
                      Height = 13
                      Caption = 'Arquivo'
                      Color = clBtnFace
                      ParentColor = False
                    end
                    object btOrdemImpressaoCriarArquivo: TSpeedButton
                      Left = 523
                      Top = 85
                      Width = 24
                      Height = 23
                      Anchors = [akTop, akRight]
                      Flat = True
                      Font.Charset = DEFAULT_CHARSET
                      Font.Color = clWindowText
                      Font.Height = -11
                      Font.Name = 'MS Sans Serif'
                      Font.Style = []
                      ParentFont = False
                      ParentShowHint = False
                      ShowHint = True
                      OnClick = btOrdemImpressaoCriarArquivoClick
                    end
                    object lbOrdemImpressaoCriarPrintId: TLabel
                      Left = 156
                      Top = 20
                      Width = 33
                      Height = 13
                      Caption = 'Print Id'
                    end
                    object edOrdemImpressaoCriarSerialPOS: TEdit
                      Left = 427
                      Top = 35
                      Width = 120
                      Height = 23
                      Hint = 
                        'O Serial do POS que ir'#225' receber o card.'#13#10'Sendo obrigat'#243'rio apena' +
                        's quando o order_type for'#13#10#8220'CRD_UNICO'#8221'.'#13#10#13#10'ATEN'#199#195'O n'#227'o pode ser ' +
                        'enviado junto com o user_id'#13
                      TabOrder = 3
                    end
                    object edOrdemImpressaoCriarIdUsuario: TEdit
                      Left = 291
                      Top = 35
                      Width = 120
                      Height = 23
                      Hint = 
                        'O ID do usu'#225'rio logado que ir'#225' receber o card.'#13#10'Sendo obrigat'#243'ri' +
                        'o apenas quando o order_type for'#13#10#8220'CRD_UNICO'#8221'.'#13#10#13#10'ATEN'#199#195'O n'#227'o po' +
                        'de ser enviado junto com o'#13#10'Serial_pos'#13
                      TabOrder = 2
                    end
                    object btOrdemImpressaoCriar: TBitBtn
                      Left = 427
                      Top = 128
                      Width = 120
                      Height = 30
                      Caption = 'Criar'
                      TabOrder = 5
                      OnClick = btOrdemImpressaoCriarClick
                    end
                    object cbOrdemImpressaoCriarTipoOrdem: TComboBox
                      Left = 20
                      Top = 35
                      Width = 123
                      Height = 23
                      Style = csDropDownList
                      ItemHeight = 0
                      TabOrder = 0
                    end
                    object edOrdemImpressaoCriarArquivo: TEdit
                      Left = 20
                      Top = 85
                      Width = 504
                      Height = 23
                      Hint = 
                        'O ID do usu'#225'rio logado que ir'#225' receber o card.'#13#10'Sendo obrigat'#243'ri' +
                        'o apenas quando o order_type for'#13#10#8220'CRD_UNICO'#8221'.'#13#10#13#10'ATEN'#199#195'O n'#227'o po' +
                        'de ser enviado junto com o'#13#10'Serial_pos'#13
                      TabOrder = 4
                    end
                    object edOrdemImpressaoCriarPrintId: TEdit
                      Left = 156
                      Top = 35
                      Width = 120
                      Height = 23
                      TabOrder = 1
                    end
                  end
                end
                object tsOrdemImpressaoConsultar: TTabSheet
                  Caption = 'Consultar'
                  object pnOrdemImpressaoConsultar: TPanel
                    Left = 0
                    Top = 0
                    Width = 567
                    Height = 381
                    Align = alClient
                    BevelOuter = bvNone
                    ParentBackground = False
                    TabOrder = 0
                    object lbOrdemImpressaoConsultarPrintIdentifier: TLabel
                      Left = 20
                      Top = 20
                      Width = 64
                      Height = 13
                      Hint = 'Campo de identifica'#231#227'o em string'
                      Caption = 'Print Identifier'
                    end
                    object edOrdemImpressaoConsultarPrintIdentifier: TEdit
                      Left = 20
                      Top = 35
                      Width = 527
                      Height = 23
                      Hint = 'Campo de identifica'#231#227'o em string'
                      TabOrder = 0
                    end
                    object btOrdemImpressaoConsultar: TBitBtn
                      Left = 427
                      Top = 80
                      Width = 120
                      Height = 30
                      Caption = 'Consultar'
                      TabOrder = 1
                      OnClick = btOrdemImpressaoConsultarClick
                    end
                  end
                end
                object tsOrdemImpressaoCancelar: TTabSheet
                  Caption = 'Cancelar'
                  object pnOrdemImpressaoCancelar: TPanel
                    Left = 0
                    Top = 0
                    Width = 567
                    Height = 381
                    Align = alClient
                    BevelOuter = bvNone
                    ParentBackground = False
                    TabOrder = 0
                    object lbOrdemImpressaoCancelarPrintIdentifier: TLabel
                      Left = 20
                      Top = 20
                      Width = 64
                      Height = 13
                      Hint = 'Campo de identifica'#231#227'o em string'
                      Caption = 'Print Identifier'
                    end
                    object edOrdemImpressaoCancelarPrintIdentifier: TEdit
                      Left = 20
                      Top = 35
                      Width = 527
                      Height = 23
                      Hint = 'Campo de identifica'#231#227'o em string'
                      TabOrder = 0
                    end
                    object btOrdemImpressaoCancelar: TBitBtn
                      Left = 427
                      Top = 80
                      Width = 120
                      Height = 30
                      Caption = 'Cancelar'
                      Default = True
                      TabOrder = 1
                      OnClick = btOrdemImpressaoCancelarClick
                    end
                  end
                end
              end
            end
            object tsTerminais: TTabSheet
              Caption = 'Terminais'
              object pnTerminais: TPanel
                Left = 0
                Top = 0
                Width = 575
                Height = 419
                Align = alClient
                BevelOuter = bvNone
                ParentBackground = False
                TabOrder = 0
                object gbTerminaisListar: TGroupBox
                  Left = 20
                  Top = 20
                  Width = 535
                  Height = 75
                  Caption = 'Listar Terminais'
                  ParentBackground = False
                  TabOrder = 0
                  object pnTerminaisListar: TPanel
                    Left = 0
                    Top = 0
                    Width = 531
                    Height = 55
                    Align = alClient
                    BevelOuter = bvNone
                    TabOrder = 0
                    object btTerminaisListar: TBitBtn
                      Left = 20
                      Top = 10
                      Width = 120
                      Height = 30
                      Caption = 'Listar'
                      TabOrder = 0
                      OnClick = btTerminaisListarClick
                    end
                  end
                end
                object gbTerminaisNickname: TGroupBox
                  Left = 20
                  Top = 112
                  Width = 535
                  Height = 120
                  Caption = 'Alterar Nickname'
                  ParentBackground = False
                  TabOrder = 1
                  object pnTerminaisNickname: TPanel
                    Left = 0
                    Top = 0
                    Width = 531
                    Height = 100
                    Align = alClient
                    BevelOuter = bvNone
                    TabOrder = 0
                    object lbTerminaisNicknameSerialPos: TLabel
                      Left = 20
                      Top = 10
                      Width = 44
                      Height = 13
                      Caption = 'SerialPos'
                    end
                    object lbTerminaisNickname: TLabel
                      Left = 277
                      Top = 10
                      Width = 48
                      Height = 13
                      Caption = 'Nickname'
                    end
                    object btTerminaisNickname: TBitBtn
                      Left = 391
                      Top = 56
                      Width = 120
                      Height = 30
                      Caption = 'Alterar'
                      TabOrder = 2
                      OnClick = btTerminaisNicknameClick
                    end
                    object edTerminaisNicknameSerialPos: TEdit
                      Left = 20
                      Top = 25
                      Width = 238
                      Height = 23
                      TabOrder = 0
                    end
                    object edTerminaisNickname: TEdit
                      Left = 277
                      Top = 25
                      Width = 234
                      Height = 23
                      TabOrder = 1
                    end
                  end
                end
                object gbTerminaisBloqueio: TGroupBox
                  Left = 20
                  Top = 248
                  Width = 535
                  Height = 120
                  Caption = 'Bloquear/Desbloquear'
                  ParentBackground = False
                  TabOrder = 2
                  object pnTerminaisBloqueio: TPanel
                    Left = 0
                    Top = 0
                    Width = 531
                    Height = 100
                    Align = alClient
                    BevelOuter = bvNone
                    TabOrder = 0
                    object lbTerminaisBloqueioSerialPos: TLabel
                      Left = 20
                      Top = 10
                      Width = 44
                      Height = 13
                      Caption = 'SerialPos'
                    end
                    object btTerminaisDesbloquear: TBitBtn
                      Left = 391
                      Top = 56
                      Width = 120
                      Height = 30
                      Caption = 'Desbloquear'
                      TabOrder = 2
                      OnClick = btTerminaisDesbloquearClick
                    end
                    object edTerminaisBloqueioSerialPos: TEdit
                      Left = 20
                      Top = 25
                      Width = 491
                      Height = 23
                      TabOrder = 0
                    end
                    object btTerminaisBloquear: TBitBtn
                      Left = 264
                      Top = 56
                      Width = 120
                      Height = 30
                      Caption = 'Bloquear'
                      TabOrder = 1
                      OnClick = btTerminaisBloquearClick
                    end
                  end
                end
              end
            end
            object tsUsuarios: TTabSheet
              Caption = 'Usuarios'
              object pnUsuarios: TPanel
                Left = 0
                Top = 0
                Width = 575
                Height = 419
                Align = alClient
                BevelOuter = bvNone
                ParentBackground = False
                TabOrder = 0
                object gbUsuariosListar: TGroupBox
                  Left = 20
                  Top = 20
                  Width = 535
                  Height = 75
                  Caption = 'Listar Usuarios'
                  ParentBackground = False
                  TabOrder = 0
                  object pnUsuariosListar: TPanel
                    Left = 0
                    Top = 0
                    Width = 531
                    Height = 55
                    Align = alClient
                    BevelOuter = bvNone
                    TabOrder = 0
                    object btUsuariosListar: TBitBtn
                      Left = 20
                      Top = 10
                      Width = 120
                      Height = 30
                      Caption = 'Listar'
                      TabOrder = 0
                      OnClick = btUsuariosListarClick
                    end
                  end
                end
                object gbUsuariosCriar: TGroupBox
                  Left = 20
                  Top = 112
                  Width = 535
                  Height = 120
                  Caption = 'Criar Usuario'
                  ParentBackground = False
                  TabOrder = 1
                  object pnUsuariosCriar: TPanel
                    Left = 0
                    Top = 0
                    Width = 531
                    Height = 100
                    Align = alClient
                    BevelOuter = bvNone
                    TabOrder = 0
                    object lbUsuariosCriarEmail: TLabel
                      Left = 20
                      Top = 10
                      Width = 25
                      Height = 13
                      Caption = 'Email'
                    end
                    object lbUsuariosCriarNome: TLabel
                      Left = 256
                      Top = 10
                      Width = 28
                      Height = 13
                      Caption = 'Nome'
                    end
                    object lbUsuariosCriarTipo: TLabel
                      Left = 391
                      Top = 10
                      Width = 21
                      Height = 13
                      Caption = 'Tipo'
                      Color = clBtnFace
                      ParentColor = False
                    end
                    object btUsuariosCriar: TBitBtn
                      Left = 391
                      Top = 56
                      Width = 120
                      Height = 30
                      Caption = 'Criar'
                      TabOrder = 3
                      OnClick = btUsuariosCriarClick
                    end
                    object edUsuariosCriarEmail: TEdit
                      Left = 20
                      Top = 25
                      Width = 221
                      Height = 23
                      TabOrder = 0
                    end
                    object edUsuariosCriarNome: TEdit
                      Left = 256
                      Top = 25
                      Width = 120
                      Height = 23
                      TabOrder = 1
                    end
                    object cbUsuariosCriarTipo: TComboBox
                      Left = 391
                      Top = 25
                      Width = 120
                      Height = 23
                      Style = csDropDownList
                      ItemHeight = 0
                      TabOrder = 2
                    end
                  end
                end
              end
            end
            object tsLoja: TTabSheet
              Caption = 'Loja'
              object pnLoja: TPanel
                Left = 0
                Top = 0
                Width = 575
                Height = 419
                Align = alClient
                BevelOuter = bvNone
                ParentBackground = False
                TabOrder = 0
                object gbLojaConsultar: TGroupBox
                  Left = 20
                  Top = 20
                  Width = 535
                  Height = 75
                  Caption = 'Consultar Loja'
                  ParentBackground = False
                  TabOrder = 0
                  object pnLojaConsultar: TPanel
                    Left = 0
                    Top = 0
                    Width = 531
                    Height = 55
                    Align = alClient
                    BevelOuter = bvNone
                    TabOrder = 0
                    object btLojaConsultar: TBitBtn
                      Left = 20
                      Top = 10
                      Width = 120
                      Height = 30
                      Caption = 'Consultar'
                      TabOrder = 0
                      OnClick = btLojaConsultarClick
                    end
                  end
                end
                object gbLojaConfigConsultar: TGroupBox
                  Left = 20
                  Top = 112
                  Width = 535
                  Height = 75
                  Caption = 'Consultar Configuracoes'
                  ParentBackground = False
                  TabOrder = 1
                  object pnLojaConfigConsultar: TPanel
                    Left = 0
                    Top = 0
                    Width = 531
                    Height = 55
                    Align = alClient
                    BevelOuter = bvNone
                    TabOrder = 0
                    object btLojaConfigConsultar: TBitBtn
                      Left = 20
                      Top = 10
                      Width = 120
                      Height = 30
                      Caption = 'Consultar'
                      TabOrder = 0
                      OnClick = btLojaConfigConsultarClick
                    end
                  end
                end
              end
            end
            object tsPooling: TTabSheet
              Caption = 'Pooling'
              object pnPooling: TPanel
                Left = 0
                Top = 0
                Width = 575
                Height = 419
                Align = alClient
                BevelOuter = bvNone
                TabOrder = 0
                object gbPooling: TGroupBox
                  Left = 20
                  Top = 20
                  Width = 535
                  Height = 92
                  Caption = 'Consultar Registros'
                  ParentBackground = False
                  TabOrder = 0
                  object pnPoolingConsultar: TPanel
                    Left = 0
                    Top = 0
                    Width = 531
                    Height = 72
                    Align = alClient
                    BevelOuter = bvNone
                    TabOrder = 0
                    object lbPoolingConsultarData: TLabel
                      Left = 20
                      Top = 10
                      Width = 79
                      Height = 13
                      Caption = 'Registros do dia:'
                      Color = clBtnFace
                      ParentColor = False
                    end
                    object btPoolingConsultar: TBitBtn
                      Left = 169
                      Top = 21
                      Width = 120
                      Height = 30
                      Caption = 'Consultar'
                      TabOrder = 1
                      OnClick = btPoolingConsultarClick
                    end
                    object edPoolingConsultarData: TDateTimePicker
                      Left = 20
                      Top = 25
                      Width = 137
                      Height = 23
                      Date = 45901.565578831020000000
                      Time = 45901.565578831020000000
                      MaxDate = 2958465.000000000000000000
                      MinDate = -53780.000000000000000000
                      TabOrder = 0
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    object tsConfig: TTabSheet
      Caption = 'Configura'#231#227'o'
      ImageIndex = 2
      object pnConfig: TPanel
        Left = 0
        Top = 0
        Width = 959
        Height = 504
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object pnConfigPainel: TPanel
          Left = 236
          Top = 31
          Width = 500
          Height = 409
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 0
          object gbConfigSmartTEF: TGroupBox
            Left = 0
            Top = 0
            Width = 500
            Height = 178
            Align = alTop
            Caption = 'Smart TEF'
            ParentBackground = False
            TabOrder = 0
            object pnConfigSmartTEF: TPanel
              Left = 0
              Top = 0
              Width = 496
              Height = 158
              Align = alClient
              BevelOuter = bvNone
              ParentBackground = False
              TabOrder = 0
              object lbConfigSmartTEFTokenIntegrador: TLabel
                Left = 20
                Top = 5
                Width = 104
                Height = 13
                Caption = 'GW-Token-Integrador'
                Color = clBtnFace
                ParentColor = False
              end
              object lbConfigSmartTEFTokenLoja: TLabel
                Left = 20
                Top = 55
                Width = 76
                Height = 13
                Caption = 'GW-Token-Loja'
                Color = clBtnFace
                ParentColor = False
              end
              object lbConfigSmartTEFCNPJIntegrador: TLabel
                Left = 356
                Top = 5
                Width = 78
                Height = 13
                Caption = 'CNPJ Integrador'
                Color = clBtnFace
                ParentColor = False
              end
              object lbConfigSmartTEFCNPJLoja: TLabel
                Left = 356
                Top = 55
                Width = 50
                Height = 13
                Caption = 'CNPJ Loja'
                Color = clBtnFace
                ParentColor = False
              end
              object lbConfigSmartTEFJWTToken: TLabel
                Left = 20
                Top = 105
                Width = 108
                Height = 13
                Caption = 'JWT-Token-Integrador'
                Color = clBtnFace
                ParentColor = False
              end
              object edConfigSmartTEFTokenIntegrador: TEdit
                Left = 20
                Top = 20
                Width = 316
                Height = 23
                TabOrder = 0
              end
              object edConfigSmartTEFTokenLoja: TEdit
                Left = 20
                Top = 70
                Width = 316
                Height = 23
                TabOrder = 2
              end
              object edConfigSmartTEFCNPJIntegrador: TEdit
                Left = 356
                Top = 20
                Width = 120
                Height = 23
                TabOrder = 1
              end
              object edConfigSmartTEFCNPJLoja: TEdit
                Left = 356
                Top = 70
                Width = 120
                Height = 23
                TabOrder = 3
              end
              object edConfigSmartTEFJWTToken: TEdit
                Left = 20
                Top = 120
                Width = 456
                Height = 23
                TabOrder = 4
              end
            end
          end
          object gbConfigProxy: TGroupBox
            Left = 0
            Top = 178
            Width = 500
            Height = 130
            Align = alTop
            Caption = 'Proxy'
            ParentBackground = False
            TabOrder = 1
            object pnConfigProxy: TPanel
              Left = 0
              Top = 0
              Width = 496
              Height = 110
              Align = alClient
              BevelOuter = bvNone
              ParentBackground = False
              TabOrder = 0
              DesignSize = (
                496
                113)
              object lbConfigProxyHost: TLabel
                Left = 20
                Top = 5
                Width = 22
                Height = 13
                Caption = 'Host'
                Color = clBtnFace
                ParentColor = False
              end
              object lbConfigProxyPorta: TLabel
                Left = 356
                Top = 5
                Width = 25
                Height = 13
                Caption = 'Porta'
                Color = clBtnFace
                ParentColor = False
              end
              object lbConfigProxyUsuario: TLabel
                Left = 20
                Top = 55
                Width = 36
                Height = 13
                Caption = 'Usu'#225'rio'
                Color = clBtnFace
                ParentColor = False
              end
              object lbConfigProxySenha: TLabel
                Left = 356
                Top = 55
                Width = 31
                Height = 13
                Caption = 'Senha'
                Color = clBtnFace
                ParentColor = False
              end
              object btConfigProxySenha: TSpeedButton
                Left = 453
                Top = 70
                Width = 23
                Height = 23
                AllowAllUp = True
                Anchors = [akTop, akRight]
                GroupIndex = 1
                Flat = True
                OnClick = btConfigProxySenhaClick
              end
              object edConfigProxyHost: TEdit
                Left = 20
                Top = 20
                Width = 316
                Height = 23
                TabOrder = 0
              end
              object edConfigProxyUsuario: TEdit
                Left = 20
                Top = 70
                Width = 316
                Height = 23
                TabOrder = 1
              end
              object edConfigProxySenha: TEdit
                Left = 356
                Top = 70
                Width = 96
                Height = 23
                PasswordChar = '*'
                TabOrder = 2
              end
              object edConfigProxyPorta: TSpinEdit
                Left = 356
                Top = 21
                Width = 120
                Height = 23
                MaxValue = 999999
                MinValue = 0
                TabOrder = 3
                Value = 0
              end
            end
          end
          object gbConfigLog: TGroupBox
            Left = 0
            Top = 308
            Width = 500
            Height = 101
            Align = alClient
            Caption = 'Log'
            ParentBackground = False
            TabOrder = 2
            object pnConfigLog: TPanel
              Left = 2
              Top = 15
              Width = 496
              Height = 84
              Align = alClient
              BevelOuter = bvNone
              ParentBackground = False
              TabOrder = 0
              DesignSize = (
                496
                84)
              object lbConfigLogArquivo: TLabel
                Left = 16
                Top = 5
                Width = 36
                Height = 13
                Caption = 'Arquivo'
                Color = clBtnFace
                ParentColor = False
              end
              object lbConfigLogNivel: TLabel
                Left = 352
                Top = 5
                Width = 26
                Height = 13
                Caption = 'N'#237'vel'
                Color = clBtnFace
                ParentColor = False
              end
              object btConfigLogArquivo: TSpeedButton
                Left = 312
                Top = 20
                Width = 24
                Height = 23
                Hint = 'Abrir Arquivo de Log'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                ParentShowHint = False
                ShowHint = True
              end
              object edConfigLogArquivo: TEdit
                Left = 16
                Top = 20
                Width = 297
                Height = 23
                Anchors = [akLeft, akTop, akRight]
                TabOrder = 0
              end
              object cbConfigLogNivel: TComboBox
                Left = 352
                Top = 20
                Width = 124
                Height = 21
                Style = csDropDownList
                ItemHeight = 13
                ItemIndex = 4
                TabOrder = 1
                Text = '4 - Muito Alto'
                Items.Strings = (
                  '0 - Nenhum'
                  '1 - Baixo'
                  '2 - Normal'
                  '3 - Alto'
                  '4 - Muito Alto')
              end
            end
          end
        end
        object pnConfigRodape: TPanel
          Left = 0
          Top = 467
          Width = 959
          Height = 37
          Align = alBottom
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 1
          object btConfigSalvar: TBitBtn
            Left = 648
            Top = 4
            Width = 136
            Height = 28
            Caption = 'Salvar Par'#226'metros'
            TabOrder = 0
            OnClick = btConfigSalvarClick
          end
          object btConfigLerParametros: TBitBtn
            Left = 800
            Top = 4
            Width = 136
            Height = 28
            Caption = 'Ler Par'#226'metros'
            TabOrder = 1
            OnClick = btConfigLerParametrosClick
          end
        end
      end
    end
  end
  object ImageList1: TImageList
    Left = 904
    Top = 8
    Bitmap = {
      494C010122002700040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000040000000A0000000010020000000000000A0
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D4D4D400717171002C2C2C000C0C0C000C0C0C002C2C2C0072727200D5D5
      D500000000000000000000000000000000000000000000000000000000000000
      0000D9D9D9007F7F7F004C4C4C0019191900191919004C4C4C007F7F7F00D9D9
      D900000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F9F9F9006D6D
      6D001717170081818100CDCDCD00F3F3F300F2F2F200CDCDCD00818181001717
      17006F6F6F00FAFAFA0000000000000000000000000000000000FEFEFE008F8F
      8F0009090900252525005D5D5D008F8F8F008F8F8F005D5D5D00252525000909
      09008F8F8F00FEFEFE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F9F9F900434343005252
      5200F0F0F000000000000000000000000000000000000000000000000000F0F0
      F0005151510044444400FAFAFA000000000000000000FEFEFE004A4A4A000707
      07008B8B8B00FDFDFD0000000000C6C6C600C6C6C60000000000FDFDFD008B8B
      8B00070707004A4A4A00FEFEFE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006C6C6C0052525200FDFD
      FD00000000000000000000000000000000000000000000000000000000000000
      0000FDFDFD00505050006F6F6F0000000000000000008F8F8F0007070700CDCD
      CD00000000000000000000000000575757005757570000000000000000000000
      0000CDCDCD00070707008F8F8F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D4D4D40018181800F1F1F1000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F0F0F00017171700D5D5D500D9D9D900090909008B8B8B000000
      00000000000000000000ABABAB000D0D0D000F0F0F00C1C1C100000000000000
      0000000000008B8B8B0009090900D9D9D9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007070700082828200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000727272007F7F7F0025252500FDFDFD000000
      000000000000E9E9E900030303005A5A5A00656565000A0A0A00EAEAEA000000
      000000000000FDFDFD0025252500808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002A2A2A00CFCFCF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000CDCDCD002C2C2C004C4C4C005D5D5D00000000000000
      000000000000ACACAC0000000000F6F6F600E1E1E10000000000DBDBDB000000
      000000000000000000005D5D5D004C4C4C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000D0D0D00F2F2F200000000000000
      00008E8E8E007777770077777700777777007777770077777700777777008E8E
      8E000000000000000000F1F1F1000E0E0E00191919008F8F8F00000000000000
      00000000000000000000FEFEFE009E9E9E002A2A2A0035353500F5F5F5000000
      000000000000000000008F8F8F00191919000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000C0C0C00F3F3F300000000000000
      0000969696008888880088888800888888008888880088888800888888009797
      97000000000000000000F2F2F2000D0D0D00191919008F8F8F00000000000000
      000000000000FEFEFE0065656500070707005D5D5D00EEEEEE00000000000000
      000000000000000000008F8F8F00191919000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002A2A2A00D0D0D000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000CECECE002C2C2C004C4C4C005D5D5D00000000000000
      000000000000DADADA0000000000C6C6C6000000000057575700C6C6C6000000
      000000000000000000005D5D5D004C4C4C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006F6F6F0083838300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000081818100717171007F7F7F0025252500FDFDFD000000
      000000000000E1E1E10000000000A0A0A0009797970000000000D2D2D2000000
      000000000000FDFDFD0025252500808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D3D3D30019191900F2F2F2000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F0F0F00018181800D4D4D400D9D9D900090909008B8B8B000000
      000000000000000000009898980003030300000000006A6A6A00000000000000
      0000000000008B8B8B0009090900D9D9D9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006A6A6A0054545400FEFE
      FE00000000000000000000000000000000000000000000000000000000000000
      0000FDFDFD00525252006D6D6D0000000000000000008F8F8F0007070700CDCD
      CD00000000000000000000000000545454004F4F4F0000000000000000000000
      0000CDCDCD00070707008F8F8F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F9F9F900424242005454
      5400F2F2F200000000000000000000000000000000000000000000000000F1F1
      F1005252520043434300F9F9F9000000000000000000FEFEFE004A4A4A000707
      07008B8B8B00FDFDFD0000000000C6C6C600C6C6C60000000000FDFDFD008B8B
      8B00070707004A4A4A00FEFEFE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F9F9F9006A6A
      6A001818180083838300CFCFCF00F4F4F400F4F4F400CECECE00838383001818
      18006C6C6C00F9F9F90000000000000000000000000000000000FEFEFE008F8F
      8F0009090900252525005D5D5D008F8F8F008F8F8F005D5D5D00252525000909
      09008F8F8F00FEFEFE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D3D3D3006F6F6F002B2B2B000B0B0B000B0B0B002B2B2B006F6F6F00D3D3
      D300000000000000000000000000000000000000000000000000000000000000
      0000D9D9D9007F7F7F004C4C4C0019191900191919004C4C4C007F7F7F00D9D9
      D900000000000000000000000000000000000000000000000000000000000000
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
      0000D4D4D400717171002C2C2C000C0C0C000C0C0C002C2C2C0072727200D5D5
      D500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F8F8F800F1F1
      F100F1F1F100F1F1F100F1F1F100F1F1F100F1F1F100F1F1F100F1F1F100F1F1
      F100F1F1F100F8F8F80000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F9F9F9006D6D
      6D001717170081818100CDCDCD00F3F3F300F2F2F200CDCDCD00818181001717
      17006F6F6F00FAFAFA0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000ADADAD00060606000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000002020200ADADAD0000000000000000000000000000000000E2E2
      E200FEFEFE0000000000000000000000000000000000F0F0F000ACACAC00AAAA
      AA00AAAAAA00E3E3E300000000000000000000000000F9F9F900434343005252
      5200F0F0F000000000000000000000000000000000000000000000000000F0F0
      F0005151510044444400FAFAFA00000000000000000000000000DADADA008181
      81005C5C5C006C6C6C00B9B9B900FBFBFB000000000000000000C7C7C7005555
      550055555500555555008E8E8E0000000000000000005858580038383800AAAA
      AA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAA
      AA00AAAAAA003838380058585800000000000000000000000000E6E6E6001212
      12008B8B8B00FEFEFE00000000000000000000000000FEFEFE00828282000000
      000000000000AAAAAA000000000000000000000000006C6C6C0052525200FDFD
      FD00000000000000000000000000000000000000000000000000000000000000
      0000FDFDFD00505050006F6F6F0000000000000000009A9A9A000D0D0D001F1F
      1F004E4E4E00383838000404040054545400F7F7F70000000000AAAAAA000606
      06004F4F4F001C1C1C005555550000000000000000005555550055555500C7C7
      C700AAAAAA00AAAAAA00C7C7C700000000000000000000000000000000000000
      0000000000005555550055555500000000000000000000000000000000008B8B
      8B00060606008A8A8A0000000000000000000000000000000000909090000101
      010000000000AAAAAA000000000000000000D4D4D40018181800F1F1F1000000
      0000000000000000000000000000929292009292920000000000000000000000
      000000000000F0F0F00017171700D5D5D500BCBCBC00060606007D7D7D00FCFC
      FC00F4F4F400FBFBFB00C0C0C0001414140068686800F1F1F100A1A1A1001313
      1300EDEDED005555550050505000F1F1F1000000000055555500555555005E5E
      5E000E0E0E000E0E0E005E5E5E000000000000000000FDFDFD00000000000000
      0000000000005555550055555500000000000000000000000000000000000000
      00008F8F8F00030303008A8A8A00FEFEFE00FEFEFE008D8D8D00040404008D8D
      8D0082828200ACACAC0000000000000000007070700082828200000000000000
      00000000000000000000000000007F7F7F007F7F7F0000000000000000000000
      000000000000000000008080800072727200464646004A4A4A00FCFCFC006E6E
      6E001515150039393900E2E2E2009D9D9D00020202000E0E0E00090909001313
      1300EDEDED0055555500040404000E0E0E00000000005555550055555500F6F6
      F600F1F1F100F1F1F100F6F6F60000000000FAFAFA006B6B6B00989898000000
      0000000000005555550055555500000000000000000000000000000000000000
      00000000000090909000070707008A8A8A00FBFBFB00626262008A8A8A000000
      0000FEFEFE00F0F0F00000000000000000002A2A2A00CFCFCF00000000000000
      00000000000000000000000000007F7F7F007F7F7F0000000000000000000000
      00000000000000000000CDCDCD002C2C2C000D0D0D009A9A9A00C6C6C6000505
      050087878700212121006F6F6F00F6F6F600AAAAAA00AAAAAA00AAAAAA00B1B1
      B100F9F9F900C7C7C70071717100000000000000000055555500555555008E8E
      8E0055555500555555008E8E8E00000000006868680003030300040404009B9B
      9B00000000005555550055555500000000000000000000000000000000000000
      000000000000000000008A8A8A00050505008E8E8E00FBFBFB00FEFEFE000000
      0000000000000000000000000000000000000D0D0D00F2F2F200000000000000
      00008E8E8E0077777700777777003B3B3B003B3B3B0077777700777777008E8E
      8E000000000000000000F1F1F1000E0E0E000D0D0D009A9A9A00C6C6C6000505
      050087878700212121006F6F6F00F6F6F600AAAAAA00AAAAAA00AAAAAA00AAAA
      AA00AAAAAA00AAAAAA0071717100000000000000000055555500555555008E8E
      8E0055555500555555008E8E8E00000000009D9D9D00B1B1B100818181000606
      0600989898005454540055555500000000000000000000000000000000000000
      00000000000000000000FBFBFB008E8E8E00050505008A8A8A00FEFEFE000000
      0000000000000000000000000000000000000C0C0C00F3F3F300000000000000
      0000969696008888880088888800444444004444440088888800888888009797
      97000000000000000000F2F2F2000D0D0D00464646004A4A4A00FCFCFC006E6E
      6E001515150039393900E2E2E2009D9D9D00020202000E0E0E000E0E0E000E0E
      0E000E0E0E000E0E0E000E0E0E000E0E0E00000000005555550055555500F6F6
      F600F1F1F100F1F1F100F6F6F600000000000000000000000000000000007F7F
      7F00858585005454540055555500000000000000000000000000000000000000
      0000000000009090900062626200FBFBFB008A8A8A0006060600898989000000
      0000FEFEFE00F0F0F00000000000000000002A2A2A00D0D0D000000000000000
      00000000000000000000000000007F7F7F007F7F7F0000000000000000000000
      00000000000000000000CECECE002C2C2C00BFBFBF000606060079797900F8F8
      F80000000000FEFEFE00BCBCBC000F0F0F006E6E6E0000000000000000000000
      0000000000000000000000000000000000000000000055555500555555005555
      5500000000000000000055555500000000000000000000000000000000000000
      000000000000555555005555550000000000000000000000000000000000FEFE
      FE008A8A8A00020202008F8F8F0000000000000000008F8F8F00030303008888
      88007C7C7C00ABABAB0000000000000000006F6F6F0083838300000000000000
      00000000000000000000000000007F7F7F007F7F7F0000000000000000000000
      000000000000000000008181810071717100000000009A9A9A000D0D0D001F1F
      1F004E4E4E00383838000404040055555500F7F7F70000000000000000000000
      000000000000000000000000000000000000000000005555550055555500C7C7
      C700AAAAAA00AAAAAA00C7C7C700000000000000000000000000000000000000
      0000000000005555550055555500000000000000000000000000000000008B8B
      8B000606060089898900000000000000000000000000000000008D8D8D000000
      000000000000AAAAAA000000000000000000D3D3D30019191900F2F2F2000000
      0000000000000000000000000000929292009292920000000000000000000000
      000000000000F0F0F00018181800D4D4D4000000000000000000DADADA008181
      81005C5C5C006C6C6C00B9B9B900FBFBFB000000000000000000000000000000
      000000000000000000000000000000000000000000005858580038383800AAAA
      AA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAA
      AA00AAAAAA003838380058585800000000000000000000000000E6E6E6001212
      12008B8B8B00FEFEFE00000000000000000000000000FEFEFE00828282000000
      000000000000AAAAAA000000000000000000000000006A6A6A0054545400FEFE
      FE00000000000000000000000000000000000000000000000000000000000000
      0000FDFDFD00525252006D6D6D00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000AFAFAF00151515000E0E
      0E000E0E0E000E0E0E000E0E0E000E0E0E000E0E0E000E0E0E000E0E0E000E0E
      0E000E0E0E0012121200AFAFAF0000000000000000000000000000000000E6E6
      E6000000000000000000000000000000000000000000EEEEEE00ABABAB00AAAA
      AA00AAAAAA00E3E3E300000000000000000000000000F9F9F900424242005454
      5400F2F2F200000000000000000000000000000000000000000000000000F1F1
      F1005252520043434300F9F9F900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F8F8F800F1F1
      F100F1F1F100F1F1F100F1F1F100F1F1F100F1F1F100F1F1F100F1F1F100F1F1
      F100F1F1F100F8F8F80000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F9F9F9006A6A
      6A001818180083838300CFCFCF00F4F4F400F4F4F400CECECE00838383001818
      18006C6C6C00F9F9F90000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D3D3D3006F6F6F002B2B2B000B0B0B000B0B0B002B2B2B006F6F6F00D3D3
      D300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F6F6F600CDCDCD00D0D0D000F7F7F700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FCFCFC00E6E6
      E600E3E3E300E3E3E300E3E3E300E3E3E300E3E3E300E3E3E300E3E3E300E3E3
      E300E4E4E400FAFAFA0000000000000000000000000000000000F2F2F2008585
      8500555555005555550055555500555555005555550055555500555555005555
      55007E7E7E00F8F8F80000000000000000000000000000000000000000000000
      0000FEFEFE00BFBFBF0040404000030303000909090046464600C6C6C600FEFE
      FE00000000000000000000000000000000000000000000000000000000000000
      0000FAFAFA00C6C6C600808080005B5B5B005D5D5D0084848400C9C9C900FCFC
      FC000000000000000000000000000000000000000000F9F9F9006A6A6A001F1F
      1F001C1C1C001C1C1C001C1C1C001C1C1C001C1C1C001C1C1C001C1C1C001C1C
      1C001D1D1D0074747400FEFEFE00000000000000000000000000B3B3B3000202
      0200000000000000000000000000000000000000000000000000000000000000
      000008080800C3C3C30000000000000000000000000000000000000000000000
      00009F9F9F00101010000000000000000000BBBBBB004444440015151500AAAA
      AA0000000000000000000000000000000000000000000000000000000000E6E6
      E600535353000C0C0C002D2D2D004F4F4F004E4E4E002A2A2A000D0D0D005B5B
      5B00ECECEC0000000000000000000000000000000000E4E4E4001D1D1D000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000021212100E7E7E700000000000000000000000000AAAAAA000000
      0000393939009797970013131300727272007272720013131300979797003939
      390003030300B5B5B5000000000000000000000000000000000000000000BFBF
      BF000808080000000000000000000000000000000000F2F2F200696969000D0D
      0D00CACACA000000000000000000000000000000000000000000E6E6E6003030
      300023232300B5B5B500F2F2F200FEFEFE00FDFDFD00F1F1F100AEAEAE001D1D
      1D003A3A3A00EDEDED00000000000000000000000000E3E3E3001C1C1C000000
      00000000000055555500AAAAAA00AAAAAA0055555500E3E3E3001C1C1C000000
      0000000000001C1C1C00E3E3E300000000000000000000000000AAAAAA000000
      0000393939009797970013131300AAAAAA00AAAAAA0013131300979797003939
      390003030300B5B5B50000000000000000000000000000000000EFEFEF002929
      2900000000000000000000000000000000000000000000000000FAFAFA004949
      490031313100F4F4F400000000000000000000000000FAFAFA00535353002323
      2300E9E9E9000000000000000000C7C7C700C7C7C7000000000000000000E2E2
      E2001C1C1C005F5F5F00FCFCFC000000000000000000E4E4E4001C1C1C000000
      0000555555001C1C1C0038383800383838001C1C1C004B4B4B00090909000000
      0000000000001D1D1D00E4E4E400000000000000000000000000AAAAAA000000
      0000090909001919190003030300979797009797970003030300191919000909
      090003030300B5B5B500000000000000000000000000000000009C9C9C000202
      020000000000000000000000000000000000000000000000000000000000D6D6
      D60009090900A8A8A800000000000000000000000000C6C6C6000C0C0C00B5B5
      B500000000000000000000000000686868006868680000000000000000000000
      0000A9A9A9000E0E0E00CFCFCF000000000000000000F6F6F6003F3F3F000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000044444400F6F6F600000000000000000000000000AAAAAA000000
      00004C4C4C00CACACA0019191900131313001313130019191900CACACA004C4C
      4C0003030300B5B5B500000000000000000000000000FEFEFE004B4B4B000000
      0000000000000000000000000000000000000000000000000000000000000000
      00004747470058585800000000000000000000000000808080002D2D2D00F2F2
      F200000000000000000000000000EDEDED00EDEDED0000000000000000000000
      0000EEEEEE00222222008F8F8F00000000000000000000000000E6E6E600B1B1
      B100AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA0097979700131313007272
      7200B5B5B500EFEFEF0000000000000000000000000000000000AAAAAA000000
      000055555500E3E3E3001C1C1C0072727200727272001C1C1C00E3E3E3005555
      550003030300B5B5B500000000000000000000000000EEEEEE00272727000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000898989002E2E2E00F4F4F40000000000000000005C5C5C004F4F4F00FEFE
      FE000000000000000000000000008E8E8E008E8E8E0000000000000000000000
      0000FAFAFA004545450069696900000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E3E3E3001C1C1C00AAAA
      AA00000000000000000000000000000000000000000000000000AAAAAA000000
      0000393939009797970013131300727272007272720013131300979797003939
      390003030300B5B5B500000000000000000000000000E3E3E3001C1C1C00AAAA
      AA00000000000000000000000000000000000000000000000000000000000000
      00000000000020202000E8E8E80000000000000000005D5D5D004E4E4E00FDFD
      FD00000000000000000000000000555555005555550000000000000000000000
      0000FAFAFA00444444006B6B6B00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E6E6E60035353500B4B4
      B400000000000000000000000000000000000000000000000000AAAAAA000000
      0000000000000000000000000000000000000000000000000000000000000000
      000003030300B5B5B500000000000000000000000000E3E3E3001C1C1C00AAAA
      AA00000000000000000000000000000000000000000000000000000000000000
      0000000000001C1C1C00E3E3E3000000000000000000848484002A2A2A00F1F1
      F100000000000000000000000000555555005555550000000000000000000000
      0000EDEDED002020200092929200000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00F9F9F900E6E6E600F6F6
      F600FAFAFA000000000000000000000000000000000000000000BABABA000505
      0500000000000000000000000000000000000000000000000000000000000000
      000003030300B5B5B500000000000000000000000000E3E3E3001C1C1C00AAAA
      AA00000000000000000000000000000000000000000000000000000000000000
      0000000000001C1C1C00E3E3E3000000000000000000C9C9C9000D0D0D00AEAE
      AE00000000000000000000000000555555005555550000000000000000000000
      0000A2A2A20010101000D3D3D300000000000000000000000000000000000000
      000000000000000000000000000000000000BBBBBB0052525200969696007171
      7100777777000000000000000000000000000000000000000000FBFBFB008686
      8600000000000000000000000000000000000000000000000000000000000000
      000003030300B5B5B500000000000000000000000000E3E3E3001C1C1C009D9D
      9D00000000000000000000000000000000000000000000000000000000000000
      0000000000001C1C1C00E3E3E3000000000000000000FCFCFC005B5B5B001D1D
      1D00E2E2E2000000000000000000C7C7C700C7C7C7000000000000000000DADA
      DA001717170067676700FDFDFD00000000000000000000000000000000000000
      00000000000000000000000000009B9B9B0086868600B5B5B5008D8D8D00A4A4
      A400A9A9A90070707000FBFBFB00000000000000000000000000000000000000
      0000868686000505050000000000000000000000000000000000000000000000
      000003030300B5B5B500000000000000000000000000ECECEC003D3D3D000606
      06004F4F4F00BCBCBC00F5F5F500000000000000000000000000000000000000
      0000050505003F3F3F00ECECEC00000000000000000000000000EBEBEB003838
      38001C1C1C00A9A9A900EEEEEE00FAFAFA00FAFAFA00EDEDED00A2A2A2001717
      170043434300F1F1F10000000000000000000000000000000000000000000000
      0000000000000000000000000000F8F8F800919191004C4C4C00555555004D4D
      4D0075757500E4E4E40000000000000000000000000000000000000000000000
      0000FBFBFB008585850007070700000000000000000000000000000000000000
      000007070700C0C0C00000000000000000000000000000000000F5F5F500ACAC
      AC00424242000D0D0D003A3A3A009F9F9F0000000000000000000A0A0A004646
      4600B1B1B100F7F7F7000000000000000000000000000000000000000000ECEC
      EC005F5F5F000E0E0E0022222200454545004444440020202000101010006767
      6700F1F1F1000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F9F9F900EBEBEB00F4F4
      F400000000000000000000000000000000000000000000000000000000000000
      000000000000FAFAFA0092929200555555005555550055555500555555005555
      550099999900F8F8F80000000000000000000000000000000000000000000000
      0000F8F8F800C2C2C2005E5E5E000E0E0E001010100062626200C5C5C500FAFA
      FA00000000000000000000000000000000000000000000000000000000000000
      0000FCFCFC00CFCFCF008E8E8E00696969006B6B6B0092929200D3D3D300FDFD
      FD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FCFCFC00DCDCDC00DFDFDF00FDFDFD00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C7C7C700AAAAAA00AAAAAA00AAAAAA00AAAAAA00C7C7C7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000686868001C1C1C001C1C1C001C1C1C001C1C1C00686868000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F8F8F800E7E7E700E7E7E700F9F9F900000000000000
      0000000000000000000000000000000000000000000000000000FCFCFC00E6E6
      E600E3E3E300E3E3E300E3E3E300E3E3E300E3E3E300E3E3E300E3E3E300E3E3
      E300E4E4E400FAFAFA00000000000000000000000000F5F5F500B9B9B900AAAA
      AA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAA
      AA00AAAAAA00B5B5B500F5F5F500000000000000000000000000000000000000
      000000000000EDEDED00E3E3E300E3E3E300E3E3E300E3E3E300EDEDED000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000ECECEC00878787003737370020202000202020003A3A3A008E8E8E00EFEF
      EF000000000000000000000000000000000000000000F9F9F9006A6A6A001F1F
      1F001C1C1C001C1C1C001C1C1C001C1C1C001C1C1C001C1C1C001C1C1C001C1C
      1C001D1D1D0074747400FEFEFE0000000000000000007A7A7A00040404000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000303030091919100000000000000000000000000000000000000
      0000AFAFAF005A5A5A005555550055555500555555005555550057575700B1B1
      B10000000000000000000000000000000000000000000000000000000000DEDE
      DE002E2E2E00121212006C6C6C00A2A2A200A1A1A100676767000F0F0F003535
      3500E4E4E40000000000000000000000000000000000E4E4E4001D1D1D007272
      7200AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAA
      AA007272720021212100E7E7E700000000000000000055555500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000055555500000000000000000000000000000000000000
      0000070707000000000000000000000000000000000000000000000000001A1A
      1A00000000000000000000000000000000000000000000000000ECECEC002E2E
      2E003A3A3A00E2E2E20000000000000000000000000000000000DCDCDC003232
      320037373700F1F1F100000000000000000000000000E3E3E3001C1C1C00AAAA
      AA00000000000000000000000000000000000000000000000000000000000000
      0000AAAAAA001C1C1C00E3E3E300000000000000000055555500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000055555500000000000000000000000000000000000000
      000000000000131313001C1C1C001C1C1C001C1C1C001C1C1C00131313000000
      0000000000000000000000000000000000000000000000000000878787001212
      1200E2E2E200000000000000000000000000000000000000000000000000DADA
      DA000D0D0D0094949400000000000000000000000000E3E3E3001C1C1C00AAAA
      AA00000000000000000000000000000000000000000000000000000000000000
      0000AAAAAA001C1C1C00E3E3E300000000000000000055555500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000055555500000000000000000000000000000000000000
      00000000000097979700E3E3E300E3E3E300E3E3E300E3E3E300979797000000
      00000000000000000000000000000000000000000000F8F8F800373737006C6C
      6C00000000000000000000000000000000000000000000000000000000000000
      00005E5E5E0042424200FCFCFC000000000000000000E3E3E3001C1C1C00AAAA
      AA00000000000000000000000000000000000000000000000000000000000000
      0000AAAAAA001C1C1C00E3E3E300000000000000000055555500000000000000
      0000000000000000000004040400646464005B5B5B0002020200000000000000
      0000000000000000000055555500000000000000000000000000000000000000
      000000000000AAAAAA0000000000000000000000000000000000AAAAAA000000
      00000000000000000000000000000000000000000000E7E7E70020202000A2A2
      A2000000000000000000000000008E8E8E008E8E8E0000000000000000000000
      00009595950026262600EDEDED000000000000000000E3E3E3001C1C1C003D3D
      3D00A2A2A2009B9B9B005E5E5E00A0A0A000999999005E5E5E009F9F9F009C9C
      9C003C3C3C001C1C1C00E3E3E300000000000000000055555500000000000000
      00000202020035353500C0C0C000DBDBDB00DFDFDF00B8B8B8002E2E2E000101
      0100000000000000000055555500000000000000000000000000000000000000
      000000000000AAAAAA0000000000000000000000000000000000AAAAAA000000
      00000000000000000000000000000000000000000000E5E5E5001E1E1E00A4A4
      A400000000000000000000000000555555005555550000000000000000000000
      00009292920025252500ECECEC00000000000000000094949400080808003E3E
      3E0003030300090909003A3A3A0006060600080808003A3A3A00060606000505
      05003E3E3E0008080800A7A7A700000000000000000055555500000000001313
      130087878700E3E3E3008D8D8D00151515001A1A1A0096969600E2E2E2007E7E
      7E00101010000000000055555500000000000000000000000000000000000000
      000000000000AAAAAA0000000000000000000000000000000000AAAAAA000000
      00000000000000000000000000000000000000000000F8F8F800373737006A6A
      6A00000000000000000000000000555555005555550000000000000000000000
      00005757570041414100FCFCFC0000000000000000005959590046464600FBFB
      FB003C3C3C004A4A4A00FEFEFE00424242004A4A4A00FCFCFC003C3C3C004A4A
      4A00F7F7F7003C3C3C006E6E6E000000000000000000555555002B2B2B00D0D0
      D000C0C0C0003C3C3C000202020000000000000000000303030044444400C8C8
      C800C9C9C9002929290055555500000000000000000000000000000000000000
      000000000000AAAAAA0000000000000000000000000000000000AAAAAA000000
      00000000000000000000000000000000000000000000000000008B8B8B001111
      1100DBDBDB00000000000000000055555500555555000000000000000000CFCF
      CF000B0B0B00989898000000000000000000000000007C7C7C0033333300F4F4
      F4006565650043434300000000005555550055555500FCFCFC00373737007373
      7300F0F0F000282828008B8B8B00000000000000000055555500464646007171
      71000A0A0A000000000000000000000000000000000000000000000000000D0D
      0D007B7B7B004848480055555500000000000000000000000000000000000000
      000000000000AAAAAA0000000000000000000000000000000000AAAAAA000000
      0000000000000000000000000000000000000000000000000000EFEFEF003333
      330041414100FCFCFC0000000000555555005555550000000000F8F8F8003737
      37003D3D3D00F4F4F400000000000000000000000000B6B6B6000B0B0B00E3E3
      E300848484002E2E2E00F5F5F5005555550055555500EEEEEE00272727009292
      9200D8D8D80007070700C2C2C20000000000000000008C8C8C00050505000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000080808008D8D8D00000000000000000000000000000000000000
      00000000000071717100AAAAAA00AAAAAA00AAAAAA00AAAAAA00717171000000
      000000000000000000000000000000000000000000000000000000000000E3E3
      E300CFCFCF00000000000000000055555500555555000000000000000000CFCF
      CF00E9E9E90000000000000000000000000000000000DFDFDF00191919007D7D
      7D006A6A6A00161616009B9B9B00393939003939390095959500111111007373
      73006F6F6F0020202000E6E6E6000000000000000000F5F5F500BABABA00AAAA
      AA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAA
      AA00AAAAAA00C3C3C300FAFAFA00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      0100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000686868006868680000000000000000000000
      00000000000000000000000000000000000000000000FDFDFD007D7D7D002626
      2600232323002323230023232300232323002323230023232300232323002323
      23002626260087878700FEFEFE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000363636000000000000000000000000000000000000000000000000003B3B
      3B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000EDEDED00EDEDED0000000000000000000000
      0000000000000000000000000000000000000000000000000000FEFEFE00ECEC
      EC00EAEAEA00EAEAEA00EAEAEA00EAEAEA00EAEAEA00EAEAEA00EAEAEA00EAEA
      EA00EDEDED00FEFEFE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E6E6E600BABABA00B9B9B900B9B9B900B9B9B900B9B9B900C0C0C000EFEF
      EF00000000000000000000000000000000000000000000000000000000000000
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
      0000FAFAFA00C6C6C600808080005C5C5C005D5D5D0084848400C9C9C900FCFC
      FC00000000000000000000000000000000000000000000000000000000000000
      0000FAFAFA00C6C6C600808080005C5C5C005D5D5D0083838300C9C9C900FBFB
      FB00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E7E7
      E7005353530009090900000000000000000000000000000000000B0B0B005B5B
      5B00EBEBEB00000000000000000000000000000000000000000000000000E6E6
      E6005353530009090900000000000000000000000000000000000B0B0B005A5A
      5A00EBEBEB000000000000000000000000000000000000000000E4E4E400AEAE
      AE00AAAAAA00AAAAAA00AAAAAA00B2B2B200F8F8F80000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7E7E7003131
      3100000000000000000000000000000000000000000000000000000000000000
      000039393900EDEDED0000000000000000000000000000000000E6E6E6003030
      3000000000000000000000000000000000000000000000000000000000000000
      000039393900ECECEC00000000000000000000000000F0F0F000373737000101
      0100000000000000000000000000020202009292920000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FAFAFA00535353000000
      0000000000000000000022222200060606000000000000000000000000000000
      0000000000005F5F5F00FCFCFC000000000000000000FAFAFA00535353000000
      0000010101002525250003030300000000000000000004040400242424000101
      0100000000005F5F5F00FCFCFC000000000000000000E3E3E3001C1C1C000000
      00000000000000000000000000000000000055555500E3E3E3001C1C1C000000
      0000555555000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600090909000000
      00000000000048484800E7E7E700878787000303030000000000000000000000
      0000000000000D0D0D00CFCFCF000000000000000000C6C6C600090909000000
      000025252500E3E3E3007171710003030300040404007C7C7C00DFDFDF001D1D
      1D00000000000D0D0D00CFCFCF000000000000000000E3E3E3001C1C1C000000
      00000000000000000000000000000000000055555500F6F6F600B4B4B400AAAA
      AA00C7C7C7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      000046464600E8E8E800C1C1C100F3F3F3008383830004040400000000000000
      000000000000000000008F8F8F00000000000000000080808000000000000000
      00000303030071717100EFEFEF00717171007D7D7D00EFEFEF00666666000202
      020000000000000000008E8E8E000000000000000000E3E3E3001C1C1C000000
      00000000000000000000000000000000000055555500F6F6F600B4B4B400AAAA
      AA00AAAAAA00B4B4B400F6F6F600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005C5C5C00000000003D3D
      3D00EEEEEE009D9D9D000D0D0D0061616100F8F8F80083838300030303000000
      000000000000000000006969690000000000000000005C5C5C00000000000000
      0000000000000303030071717100F4F4F400F4F4F40065656500020202000000
      00000000000000000000696969000000000000000000E3E3E3001C1C1C000000
      00000000000000000000000000000000000055555500E3E3E3001C1C1C000000
      0000000000001C1C1C00E3E3E300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005D5D5D00000000003434
      34009090900005050500000000000000000061616100F3F3F300878787000606
      060000000000000000006B6B6B0000000000000000005D5D5D00000000000000
      000000000000040404007D7D7D00F4F4F400F4F4F40071717100030303000000
      000000000000000000006B6B6B000000000000000000E3E3E3001C1C1C000000
      0000000000000000000000000000000000005555550000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000202020064646400F1F1F1008787
      8700030303000000000092929200000000000000000083838300000000000000
      0000040404007C7C7C00EFEFEF006565650071717100EFEFEF00717171000303
      03000000000000000000919191000000000000000000E3E3E3001C1C1C000000
      00000000000000000000000000000000000055555500EDEDED00686868005555
      550055555500555555008E8E8E00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C9C9C9000B0B0B000000
      000000000000000000000000000000000000000000000202020064646400F3F3
      F3005D5D5D000F0F0F00D3D3D3000000000000000000C9C9C9000B0B0B000000
      000024242400DFDFDF0066666600020202000303030071717100DBDBDB001C1C
      1C00000000000F0F0F00D3D3D3000000000000000000EDEDED00686868005555
      5500555555005555550055555500555555008E8E8E00EDEDED00686868005555
      550055555500555555008E8E8E00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FCFCFC005B5B5B000000
      0000000000000000000000000000000000000000000000000000020202004D4D
      4D001010100067676700FDFDFD000000000000000000FBFBFB005A5A5A000000
      0000010101001D1D1D00020202000000000000000000030303001C1C1C000101
      01000000000066666600FDFDFD0000000000000000008E8E8E00555555005555
      55005555550055555500555555005555550055555500C7C7C700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EBEBEB003939
      3900000000000000000000000000000000000000000000000000000000000000
      000042424200F1F1F10000000000000000000000000000000000EBEBEB003838
      3800000000000000000000000000000000000000000000000000000000000000
      000041414100F0F0F0000000000000000000000000008E8E8E00555555003131
      31000000000000000000050505004949490055555500C7C7C700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EDED
      ED005F5F5F000D0D0D00000000000000000000000000000000000F0F0F006767
      6700F1F1F100000000000000000000000000000000000000000000000000ECEC
      EC005F5F5F000D0D0D00000000000000000000000000000000000F0F0F006666
      6600F0F0F000000000000000000000000000000000000000000000000000EFEF
      EF00AAAAAA00AAAAAA00BABABA00FBFBFB000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FCFCFC00CFCFCF008F8F8F006A6A6A006B6B6B0092929200D3D3D300FDFD
      FD00000000000000000000000000000000000000000000000000000000000000
      0000FCFCFC00CFCFCF008E8E8E006A6A6A006B6B6B0091919100D3D3D300FDFD
      FD00000000000000000000000000000000000000000000000000000000000000
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
      0000E9E9E900A8A8A800A4A4A400A4A4A400A4A4A400A4A4A400A4A4A400A4A4
      A400A7A7A700C8C8C80000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F4F4
      F4002B2B2B001717170023232300232323002323230023232300232323002323
      23001717170000000000E7E7E700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E3E3
      E3001C1C1C00AAAAAA0000000000000000000000000000000000000000000000
      0000A7A7A70003030300DCDCDC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F5F5F500B9B9B900AAAA
      AA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAA
      AA00AAAAAA00B5B5B500F4F4F400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E3E3
      E3001C1C1C00AAAAAA0000000000000000000000000000000000000000000000
      0000A7A7A70003030300DCDCDC00000000000000000000000000000000000000
      000000000000B4B4B400EFEFEF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000078787800040404000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000303030091919100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C8C8C800C2C2C200E3E3
      E3001C1C1C00AAAAAA0000000000000000000000000000000000000000000000
      0000A7A7A70003030300DCDCDC00000000000000000000000000000000000000
      0000000000005555550020202000ADADAD00FBFBFB0000000000000000000000
      0000000000000000000000000000000000000000000055555500555555000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000555555005555550000000000000000008E8E8E00555555005555
      5500555555005555550070707000EFEFEF000000000000000000000000000000
      0000FAFAFA008B8B8B00B4B4B400FCFCFC00000000006363630050505000E3E3
      E3001C1C1C00AAAAAA0000000000000000000000000000000000000000000000
      0000A7A7A70003030300DCDCDC00000000000000000000000000000000000000
      0000000000005555550000000000020202005E5E5E00DBDBDB00000000000000
      0000000000000000000000000000000000000000000055555500555555000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005555550055555500000000000000000055555500000000000000
      0000000000001B1B1B00C0C0C000000000000000000000000000000000000000
      0000BDBDBD000808080059595900FBFBFB00000000006363630050505000E3E3
      E3001C1C1C00AAAAAA0000000000000000000000000000000000000000000000
      0000A7A7A70003030300DCDCDC00000000000000000000000000000000000000
      000000000000555555000000000000000000000000001E1E1E0097979700F8F8
      F800000000000000000000000000000000000000000055555500555555000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005555550055555500000000000000000055555500000000000000
      000009090900B7B7B7000000000000000000000000000000000000000000D6D6
      D6001F1F1F0012121200CECECE0000000000000000006363630050505000E3E3
      E3001C1C1C00AAAAAA0000000000000000000000000000000000000000000000
      0000A7A7A70003030300DCDCDC00000000000000000000000000000000000000
      0000000000005555550000000000000000000000000000000000040404004343
      4300D9D9D9000000000000000000000000000000000055555500555555000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005555550055555500000000000000000055555500000000000C0C
      0C00010101002C2C2C009F9F9F00DEDEDE00E6E6E600CECECE00797979000D0D
      0D000F0F0F00AAAAAA000000000000000000000000006363630050505000E3E3
      E3001C1C1C00AAAAAA0000000000000000000000000000000000000000000000
      0000A7A7A70003030300DCDCDC00000000000000000000000000000000000000
      0000000000005555550000000000000000000000000000000000050505004F4F
      4F00E3E3E3000000000000000000000000000000000055555500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005555550000000000000000005555550020202000C3C3
      C3007F7F7F001818180000000000020202000909090000000000040404003535
      3500BFBFBF00000000000000000000000000000000006363630050505000E3E3
      E3001C1C1C00AAAAAA0000000000000000000000000000000000000000000000
      0000A7A7A70003030300DCDCDC00000000000000000000000000000000000000
      0000000000005555550000000000000000000000000025252500A4A4A400FBFB
      FB00000000000000000000000000000000000000000055555500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000055555500000000000000000076767600C8C8C8000000
      0000FEFEFE00DEDEDE009D9D9D006C6C6C00646464007E7E7E00B8B8B800F2F2
      F20000000000000000000000000000000000000000006363630050505000E3E3
      E3001C1C1C00AAAAAA0000000000000000000000000000000000000000000000
      0000A7A7A70003030300DCDCDC00000000000000000000000000000000000000
      0000000000005555550000000000040404006A6A6A00E2E2E200000000000000
      00000000000000000000000000000000000000000000555555001C1C1C005555
      5500555555005555550055555500555555005555550055555500555555005555
      5500555555001C1C1C00555555000000000000000000F3F3F300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006363630050505000EFEF
      EF002A2A2A00121212001B1B1B001B1B1B001B1B1B001B1B1B001B1B1B001B1B
      1B001111110002020200E4E4E400000000000000000000000000000000000000
      000000000000555555002A2A2A00B9B9B900FCFCFC0000000000000000000000
      0000000000000000000000000000000000000000000055555500555555000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005555550055555500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000063636300505050000000
      0000BBBBBB005D5D5D0059595900595959005959590059595900595959005959
      59005C5C5C0088888800FCFCFC00000000000000000000000000000000000000
      000000000000BEBEBE00F4F4F400000000000000000000000000000000000000
      000000000000000000000000000000000000000000008B8B8B00050505000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000080808008B8B8B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006464640045454500DCDC
      DC00DCDCDC00DCDCDC00DCDCDC00DCDCDC00DCDCDC00DCDCDC00DCDCDC000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F5F5F500BABABA00AAAA
      AA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAA
      AA00AAAAAA00C3C3C300FAFAFA00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A7A7A7000B0B0B000505
      0500050505000505050005050500050505000505050005050500050505000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FCFCFC00B1B1B100A4A4
      A400A4A4A400A4A4A400A4A4A400A4A4A400A4A4A400A4A4A400A4A4A4000000
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
      0000000000000000000000000000000000000000000000000000FCFCFC00E6E6
      E600E3E3E300E3E3E300E3E3E300E3E3E300E3E3E300E3E3E300E3E3E300E3E3
      E300E4E4E400FAFAFA0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FE009A9A9A00EBEBEB00000000000000000000000000FAFAFA00BCBCBC00AAAA
      AA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAA
      AA00AAAAAA00BFBFBF00FBFBFB000000000000000000F9F9F9006A6A6A001F1F
      1F001C1C1C001C1C1C001C1C1C001C1C1C001C1C1C001C1C1C001C1C1C001C1C
      1C001D1D1D0074747400FEFEFE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FEFEFE007C7C
      7C0009090900ABABAB00000000000000000000000000CECECE00090909000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000C0C0C00D1D1D1000000000000000000E4E4E4001D1D1D000000
      0000000000000000000021212100939393008E8E8E001B1B1B00000000000000
      00000000000021212100E7E7E700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F9F9F900777777000808
      08009494940000000000000000000000000000000000C7C7C700000000003F3F
      3F008E8E8E008E8E8E008E8E8E008E8E8E008E8E8E008E8E8E008E8E8E008E8E
      8E003F3F3F0000000000C7C7C7000000000000000000E3E3E3001C1C1C000000
      00000000000009090900C4C4C4000000000000000000BABABA00050505000000
      0000000000001C1C1C00E3E3E300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FAFA
      FA00B4B4B40069696900575757007E7E7E00D9D9D900898989000C0C0C008E8E
      8E000000000000000000000000000000000000000000C7C7C700000000007171
      7100000000000000000000000000000000000000000000000000000000000000
      00007171710000000000C7C7C7000000000000000000E3E3E3001C1C1C000000
      00000000000016161600DDDDDD000000000000000000D6D6D6000F0F0F000000
      0000000000001C1C1C00E3E3E30000000000FCFCFC00AEAEAE0090909000FCFC
      FC0000000000000000000000000000000000EBEBEB006B6B6B00555555005555
      550055555500555555008E8E8E00000000000000000000000000F7F7F7006767
      67000B0B0B003F3F3F004E4E4E0022222200161616003030300099999900FCFC
      FC000000000000000000000000000000000000000000C7C7C700000000007171
      7100000000000000000000000000000000000000000000000000000000000000
      00007171710000000000C7C7C7000000000000000000E3E3E3001C1C1C000000
      000000000000020202008A8A8A00FCFCFC00FBFBFB007F7F7F00010101000000
      0000000000001C1C1C00E3E3E30000000000FAFAFA004E4E4E000D0D0D00C7C7
      C7000000000000000000000000000000000000000000B7B7B700151515000000
      0000000000000000000055555500000000000000000000000000929292000606
      0600B3B3B300F8F8F800FDFDFD00ECECEC005E5E5E001A1A1A00DDDDDD000000
      00000000000000000000000000000000000000000000C7C7C700000000007171
      7100000000000000000000000000000000000000000000000000000000000000
      00007171710000000000C7C7C7000000000000000000E3E3E3001C1C1C000000
      0000000000000000000006060600333333003030300005050500000000000000
      0000000000001C1C1C00E3E3E3000000000000000000C5C5C5000E0E0E002626
      2600DEDEDE000000000000000000000000000000000000000000ACACAC000707
      07000000000000000000555555000000000000000000F5F5F500303030006A6A
      6A0000000000000000000000000000000000EDEDED0021212100888888000000
      00000000000000000000000000000000000000000000C7C7C700000000007171
      7100000000000000000000000000000000000000000000000000000000000000
      00007171710000000000C7C7C7000000000000000000E3E3E3001C1C1C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001C1C1C00E3E3E300000000000000000000000000A0A0A0000D0D
      0D001111110080808000D1D1D100E6E6E600DEDEDE009B9B9B00262626000202
      02000B0B0B0000000000555555000000000000000000E5E5E5001D1D1D00A2A2
      A20000000000000000000000000000000000FBFBFB0047474700656565000000
      00000000000000000000000000000000000000000000C7C7C700000000005858
      5800C7C7C700C7C7C700C7C7C700C7C7C700C7C7C700C7C7C700C7C7C700C7C7
      C7005858580000000000C7C7C7000000000000000000E3E3E3001C1C1C001313
      13001C1C1C001C1C1C001C1C1C001C1C1C001C1C1C0019191900030303000000
      0000000000001C1C1C00E3E3E30000000000000000000000000000000000B7B7
      B7002F2F2F0003030300010101000909090004040400000000001B1B1B008787
      8700BDBDBD001B1B1B00555555000000000000000000EEEEEE00272727008989
      890000000000000000000000000000000000F2F2F2002B2B2B007A7A7A000000
      00000000000000000000000000000000000000000000C7C7C700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000005050500CCCCCC000000000000000000E3E3E3001C1C1C009797
      9700E3E3E300E3E3E300E3E3E300E3E3E300E3E3E300CACACA00191919000000
      0000000000001C1C1C00E3E3E300000000000000000000000000000000000000
      0000EFEFEF00B5B5B5007B7B7B00646464006D6D6D00A1A1A100E1E1E1000000
      000000000000C0C0C000707070000000000000000000000000006B6B6B001D1D
      1D00E6E6E600000000000000000000000000989898000C0C0C00C4C4C4000000
      00000000000000000000000000000000000000000000C7C7C700000000000000
      0000000000000000000000000000000000002929290071717100717171007171
      71007171710097979700F7F7F7000000000000000000E3E3E3001C1C1C00AAAA
      AA000000000000000000000000000000000000000000E3E3E3001C1C1C000000
      00000000000049494900F4F4F400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000EFEFEF00000000000000000000000000E8E8E8003434
      34001515150076767600979797005E5E5E00080808007C7C7C00FDFDFD000000
      00000000000000000000000000000000000000000000D0D0D0000C0C0C000000
      000000000000000000000000000030303000E9E9E90000000000000000000000
      00000000000000000000000000000000000000000000E6E6E6001F1F1F007272
      7200AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA0097979700131313000000
      000047474700EFEFEF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E9E9
      E900727272002E2E2E00252525003C3C3C00A5A5A500FBFBFB00000000000000
      00000000000000000000000000000000000000000000FBFBFB00C2C2C200AAAA
      AA00AAAAAA00AAAAAA00AAAAAA00E6E6E6000000000000000000000000000000
      00000000000000000000000000000000000000000000FDFDFD00727272001F1F
      1F001C1C1C001C1C1C001C1C1C001C1C1C001C1C1C001C1C1C001C1C1C004949
      4900EFEFEF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F4F4F400ECECEC00FAFAFA000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FBFBFB00E6E6
      E600E3E3E300E3E3E300E3E3E300E3E3E300E3E3E300E3E3E300E3E3E300F4F4
      F400000000000000000000000000000000000000000000000000000000000000
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
      0000FDFDFD00CECECE0075757500494949004141410075757500C0C0C000F5F5
      F50000000000000000000000000000000000E7E7E700C7C7C700C7C7C700C7C7
      C700C7C7C700C7C7C700C7C7C700C7C7C700C7C7C700C7C7C700C7C7C700C7C7
      C700C7C7C700C7C7C700C7C7C700EAEAEA000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DFDFDF00B1B1
      B100AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAA
      AA00ABABAB00C2C2C200F8F8F80000000000000000000000000000000000DDDD
      DD002C2C2C000303030029292900666666007272720029292900050505000F0F
      0F00DDDDDD00000000000000000000000000CDCDCD000D0D0D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000012121200D6D6D6000000000000000000000000000000
      00000000000000000000FCFCFC00EDEDED00EEEEEE00FCFCFC00000000000000
      000000000000000000000000000000000000FBFBFB0089898900151515000202
      0200000000000000000000000000000000000000000000000000000000000000
      0000000000000707070046464600ECECEC000000000000000000EDEDED003333
      330013131300A1A1A100FBFBFB000000000000000000FBFBFB00BFBFBF002C2C
      2C0033333300DDDDDD000000000000000000FDFDFD0071717100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007D7D7D00FEFEFE000000000000000000000000000000
      0000C9C9C900646464002525250016161600161616002828280069696900CFCF
      CF00000000000000000000000000000000009D9D9D0001010100000000000000
      0000000000000000000005050500868686008686860005050500000000000000
      0000000000000000000000000000646464000000000000000000575757002C2C
      2C00E2E2E2000000000000000000CDCDCD00BDBDBD000000000000000000FAFA
      FA002C2C2C000F0F0F00F5F5F5000000000000000000E6E6E600232323000000
      0000000000000000000000000000656565006565650000000000000000000000
      0000000000002C2C2C00EBEBEB00000000000000000000000000EEEEEE006868
      68000000000000000000171717004B4B4B004949490015151500000000000202
      020071717100F2F2F20000000000000000002B2B2B0000000000000000000000
      0000000000000707070085858500FBFBFB00FBFBFB0085858500070707000000
      00000000000000000000000000001818180000000000F6F6F60004040400C0C0
      C000000000000000000000000000727272004343430000000000000000000000
      0000C0C0C00005050500C0C0C0000000000000000000000000009A9A9A000404
      0400000000000000000000000000000000000000000000000000000000000000
      000005050500A6A6A600000000000000000000000000EEEEEE004A4A4A000000
      0000000000004D4D4D00E2E2E200EDEDED00EFEFEF00DDDDDD00444444000000
      00000101010054545400F2F2F200000000000202020000000000000000000000
      00000505050085858500FAFAFA000000000000000000FAFAFA00858585000505
      05000000000000000000000000001919190000000000AAAAAA0014141400FAFA
      FA00000000000000000000000000727272004343430000000000000000000000
      0000FAFAFA002828280075757500000000000000000000000000F6F6F6003C3C
      3C00000000000000000000000000585858005858580000000000000000000000
      000046464600F9F9F9000000000000000000FCFCFC0072727200010101000000
      000017171700E2E2E200A5A5A5002A2A2A002C2C2C00B0B0B000D9D9D9001212
      120000000000020202007E7E7E00FDFDFD001717170000000000000000000000
      000010101000515151008E8E8E0000000000000000008E8E8E00515151001010
      10000000000000000000000000006C6C6C000000000074747400444444000000
      0000000000000000000000000000727272004343430000000000000000000000
      000000000000717171004141410000000000000000000000000000000000C5C5
      C500010101000000000000000000717171007171710000000000000000000303
      0300D1D1D100000000000000000000000000D4D4D4000B0B0B00000000000000
      00004B4B4B00EDEDED002A2A2A00000000000000000031313100F3F3F3003E3E
      3E00000000000000000010101000DCDCDC007777770000000000000000000000
      0000000000000000000055555500000000000000000055555500000000000000
      0000000000000C0C0C0054545400F0F0F000000000007B7B7B003D3D3D000000
      0000000000000000000000000000B1B1B1009797970000000000000000000000
      0000000000006868680048484800000000000000000000000000000000000000
      0000636363000000000000000000717171007171710000000000000000007070
      700000000000000000000000000000000000D8D8D8000D0D0D00000000000000
      000049494900EFEFEF002C2C2C00000000000000000034343400F4F4F4003B3B
      3B00000000000000000013131300E0E0E000EEEEEE004D4D4D00030303000000
      000000000000000000004B4B4B00E3E3E300E3E3E3004B4B4B00000000000000
      00002C2C2C00CECECE00FBFBFB000000000000000000AAAAAA0014141400FAFA
      FA00000000000000000000000000F6F6F600F3F3F30000000000000000000000
      0000FAFAFA002828280075757500000000000000000000000000000000000000
      0000DEDEDE0018181800000000002525250025252500000000001F1F1F00E4E4
      E40000000000000000000000000000000000FDFDFD007B7B7B00010101000000
      000015151500DDDDDD00B0B0B0003131310034343400B9B9B900D4D4D4001010
      1000000000000303030087878700FEFEFE0000000000F3F3F300AAAAAA004C4C
      4C000000000000000000090909001C1C1C001C1C1C0009090900000000000000
      00009090900000000000000000000000000000000000FCFCFC0012121200A1A1
      A100FEFEFE000000000000000000727272004343430000000000000000000000
      0000A1A1A10003030300CECECE00000000000000000000000000000000000000
      0000FEFEFE008A8A8A0001010100000000000000000002020200969696000000
      00000000000000000000000000000000000000000000F1F1F100545454000101
      01000000000044444400D9D9D900F3F3F300F4F4F400D4D4D4003C3C3C000000
      0000010101005E5E5E00F4F4F40000000000000000000000000000000000F2F2
      F200323232000000000000000000000000000000000000000000000000003F3F
      3F00F7F7F7000000000000000000000000000000000000000000777777001313
      1300BFBFBF00FEFEFE0000000000F0F0F000EBEBEB000000000000000000E1E1
      E100131313002C2C2C00FDFDFD00000000000000000000000000000000000000
      000000000000EEEEEE003131310000000000000000003A3A3A00F2F2F2000000
      0000000000000000000000000000000000000000000000000000F2F2F2007676
      76000303030000000000121212003D3D3D003B3B3B0010101000000000000505
      05007F7F7F00F5F5F50000000000000000000000000000000000000000000000
      0000ECECEC0060606000121212000404040005050500141414006A6A6A00F1F1
      F100000000000000000000000000000000000000000000000000EDEDED003333
      330013131300A1A1A100FBFBFB000000000000000000FBFBFB00BFBFBF002C2C
      2C0033333300DDDDDD0000000000000000000000000000000000000000000000
      00000000000000000000B3B3B300070707000A0A0A00BEBEBE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D5D5D5007272720030303000191919001A1A1A003333330077777700DADA
      DA00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DEDEDE00B8B8B800BABABA00E1E1E100000000000000
      000000000000000000000000000000000000000000000000000000000000EDED
      ED007777770011111100151515003C3C3C004444440015151500040404005757
      5700EDEDED000000000000000000000000000000000000000000000000000000
      00000000000000000000FCFCFC00525252005E5E5E00FEFEFE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F8F8F800F8F8F80000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FCFCFC00AAAAAA007C7C7C0073737300AAAAAA00F6F6F6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D9D9D900E1E1E10000000000000000000000
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
      0000DDDDDD00D4D4D40000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D7D7D7006565650052525200D8D8D800000000000000
      0000000000000000000000000000000000000000000000000000E1E1E100DCDC
      DC00DCDCDC00DCDCDC00FDFDFD0000000000F6F6F600DEDEDE00FDFDFD00E9E9
      E900DCDCDC00DCDCDC00FBFBFB00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CECE
      CE001A1A1A0015151500B7B7B7000000000000000000EAEAEA00DCDCDC00DCDC
      DC00DCDCDC00DCDCDC00DCDCDC00DCDCDC00DCDCDC00DCDCDC00DCDCDC00DCDC
      DC00DCDCDC00DCDCDC00FBFBFB00000000000000000000000000000000000000
      000000000000D5D5D50007070700000000000000000008080800B8B8B8000000
      0000000000000000000000000000000000000000000000000000232323000707
      07000707070001010100EFEFEF00FEFEFE00BBBBBB0013131300EFEFEF005A5A
      5A000101010003030300DDDDDD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CBCBCB002121
      2100000000000000000016161600DCDCDC000000000065656500030303000303
      0300030303000303030003030300030303000303030003030300030303000303
      03000303030003030300DDDDDD00000000000000000000000000000000000000
      0000EAEAEA002C2C2C000000000000000000000000000000000008080800CBCB
      CB0000000000000000000000000000000000000000000000000023232300A4A4
      A4009898980022222200EFEFEF00A3A3A3006D6D6D00ABABAB00DFDFDF005050
      50003A3A3A00A5A5A500F3F3F300000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CECECE00212121000000
      0000000000000000000030303000EBEBEB0000000000C9C9C900A7A7A700A7A7
      A700A7A7A700A7A7A700A7A7A700A7A7A700A7A7A700A7A7A700A7A7A700A7A7
      A700A7A7A700A7A7A700F3F3F30000000000000000000000000000000000EAEA
      EA00A1A1A1005858580004040400000000000000000000000000272727008B8B
      8B00E9E9E9000000000000000000000000000000000000000000232323009C9C
      9C009191910020202000EFEFEF007272720043434300EFEFEF00101010000000
      000059595900FCFCFC0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CBCBCB001A1A1A00000000000000
      00000000000036363600E3E3E30000000000000000000000000000000000A8A8
      A800DADADA0000000000F7F7F700ADADAD00E1E1E1000000000000000000B3B3
      B300DFDFDF000000000000000000000000000000000000000000D5D5D5000808
      0800000000006060600087878700070707000000000065656500C5C5C5000606
      060006060600B0B0B00000000000000000000000000000000000313131001010
      10001010100010101000F0F0F000727272004343430000000000000000000000
      0000A7A7A70003030300DCDCDC00000000000000000000000000000000000000
      0000000000000000000000000000CECECE001A1A1A0000000000000000000000
      000036363600E0E0E00000000000000000000000000000000000000000000808
      08009696960000000000E8E8E80017171700A8A8A80000000000000000002525
      2500A3A3A30000000000000000000000000000000000F7F7F700303030000000
      000000000000000000008484840083838300444444009B9B9B00131313000000
      00000000000006060600D5D5D500000000000000000000000000F1F1F100B3B3
      B3009C9C9C00EFEFEF00A8A8A8007C7C7C006F6F6F00A3A3A300A3A3A300DFDF
      DF00A7A7A70003030300DCDCDC0000000000000000000000000000000000D8D8
      D800A6A6A600A9A9A900B2B2B200212121000000000000000000000000003030
      3000E3E3E3000000000000000000000000000000000000000000000000000808
      08009696960000000000E8E8E80017171700A8A8A80000000000000000002525
      2500A3A3A3000000000000000000000000000000000085858500000000000000
      0000000000000000000000000000595959009A9A9A0007070700000000000000
      000000000000000000004F4F4F00000000000000000000000000DFDFDF006464
      640039393900DADADA000E0E0E0079797900AAAAAA0026262600262626009A9A
      9A009B9B9B0028282800E1E1E1000000000000000000F6F6F600717171001111
      110000000000010101000606060000000000000000000000000030303000E0E0
      E000000000000000000000000000000000000000000000000000000000000808
      08009696960000000000E8E8E80017171700A8A8A80000000000000000002525
      2500A3A3A3000000000000000000000000000000000099999900000000000000
      000000000000000000000808080088888800CFCFCF0014141400000000000000
      000000000000000000006464640000000000000000000000000029292900A9A9
      A900E5E5E5000707070007070700070707004949490000000000000000005E5E
      5E005D5D5D00FCFCFC000000000000000000FCFCFC006F6F6F00000000000000
      0000000000000000000000000000000000000000000036363600E3E3E3000000
      0000000000000000000000000000000000000000000000000000000000000F0F
      0F009999990000000000E9E9E9001D1D1D00ABABAB0000000000000000002B2B
      2B00A6A6A60000000000000000000000000000000000F6F6F6002E2E2E000000
      0000000000000000000084848400838383004444440099999900121212000000
      00000000000007070700D6D6D600000000000000000000000000A2A2A200CFCF
      CF00E5E5E500939393009C9C9C0093939300ABABAB00F8F8F800F0F0F000B3B3
      B300B3B3B300EEEEEE00FDFDFD0000000000DADADA000B0B0B00000000000505
      05000303030000000000000000000000000009090900C4C4C400000000000000
      000000000000000000000000000000000000000000000000000000000000A6A6
      A600D9D9D90000000000F7F7F700ACACAC00E0E0E0000000000000000000B1B1
      B100DEDEDE000000000000000000000000000000000000000000E8E8E8003D3D
      3D002D2D2D008B8B8B005D5D5D0002020200000000003F3F3F00BEBEBE003E3E
      3E003D3D3D00D4D4D40000000000000000000000000000000000232323001F1F
      1F00202020000404040093939300070707000000000093939300101010001B1B
      1B001F1F1F0001010100DCDCDC0000000000A9A9A90000000000060606008D8D
      8D008383830004040400000000000000000002020200B2B2B200000000000000
      00000000000000000000000000000000000000000000CBCBCB00AAAAAA00AAAA
      AA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAAAA00AAAA
      AA00AAAAAA00AAAAAA00F4F4F400000000000000000000000000000000000000
      0000B2B2B2002525250000000000000000000000000000000000000000008080
      800000000000000000000000000000000000000000000000000023232300A0A0
      A0008E8E8E00252525009393930007070700C2C2C200E5E5E500101010008E8E
      8E00A0A0A00008080800DCDCDC0000000000A8A8A800050505008E8E8E00FCFC
      FC00FAFAFA0083838300030303000000000003030300B6B6B600000000000000
      0000000000000000000000000000000000000000000070707000010101000000
      0000070707001B1B1B001C1C1C001C1C1C001C1C1C001C1C1C00181818000101
      01000000000006060600DFDFDF00000000000000000000000000000000000000
      0000ECECEC002F2F2F000000000000000000000000000000000007070700C8C8
      C80000000000000000000000000000000000000000000000000023232300B5B5
      B500AAAAAA0025252500B3B3B3005D5D5D009B9B9B00CFCFCF0010101000A1A1
      A100B5B5B50008080800DCDCDC0000000000E2E2E2009E9E9E00FEFEFE000000
      0000F9F9F9007878780002020200000000001A1A1A00E8E8E800000000000000
      00000000000000000000000000000000000000000000E1E1E1006B6B6B000606
      06001515150087878700E0E0E000E3E3E300E3E3E300B6B6B600545454000404
      04003A3A3A009D9D9D00F9F9F900000000000000000000000000000000000000
      000000000000EAEAEA003131310000000000000000002E2E2E00D1D1D1000000
      0000000000000000000000000000000000000000000000000000424242002323
      23002323230023232300F1F1F1000000000044444400A2A2A200313131002323
      23002323230023232300E1E1E10000000000000000000000000000000000FCFC
      FC00787878000202020000000000030303009494940000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D8D8
      D8006D6D6D001010100034343400A0A0A00069696900070707002E2E2E00A7A7
      A700FEFEFE000000000000000000000000000000000000000000000000000000
      00000000000000000000F7F7F7009B9B9B0084848400F6F6F600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009191
      910002020200000000002222220094949400FCFCFC0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F1F1F1005A5A5A00141414002A2A2A00C4C4C400FEFEFE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EEEE
      EE00CCCCCC00D1D1D100EEEEEE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F9F9F900C2C2C200E7E7E70000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000A00000000100010000000000000500000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000F00FF00F00000000C003C00300000000
      87E18241000000008FF18E71000000001FF81C38000000003FFC181800000000
      3FFC381C00000000300C3C1C00000000300C383C000000003FFC389C00000000
      3FFC1818000000001FF81C38000000008FF18E710000000087E1824100000000
      C003C00300000000F00FF00F00000000FFFFFFFFFFFFF00FFFFFC003FFFFC003
      FFFF8001E78387E1C0C18001C3838FF1804181F9E3C31E78000081B9F0033E7C
      00008119F8133E7C00008109FC1F300C00008101FC1F300C000081E1F8133E7C
      087F81F9E1833E7C807F81F9E3C31E78C0FF8001C3838FF1FFFF8001EF8387E1
      FFFFC003FFFFC003FFFFFFFFFFFFF00FFFFFFFFFFC3FFFFFC003C003F00FF00F
      8001C003F00FE0078001C003E087C0038801C003C0C386618001C003C0E38E71
      8001C00380F38E71C003C00380F18E71FF8FC0038F018E71FF8FC0038F018E71
      FF07C0038F018E71FF07C0038F018661FE01F0038101C003FE03F003C003E007
      FF8FF803F00FF00FFFFFFFFFFC3FFFFFFFFFF81FFFFFFFFFFFFFF81FFC3FC003
      8001F81FF00F80018001F00FE00780018001F00FC3C38FF18001F00FC7E38FF1
      8001F00F8FF18FF18001F3CF8E7180018001F3CF8E7180018001F3CF8E718001
      8001F3CFC66382018001F3CFC24380018001F00FE66780018001F00FFE7F8001
      FFFFF00FFE7FC003FFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFF00FF00FFFFFFFFF
      E007E007C07FFFFFC003C003807FFFFF800180018007F00F800180018007F00F
      800180018001F00F800180018001F00F80018001807FF00F800180018001F00F
      800180018001F00F80018001803FF00FC003C003803FFFFFE007E007E0FFFFFF
      F00FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF003FFFFFFFFFFFFE001FFFFFFFF
      FFFFE3F1FFFF8001FFFFE3F1F9FF8001FFFF83F1F87F9FF980F083F1F83F9FF9
      81F083F1F80F9FF983E183F1F8079FF9800383F1F8078001800783F1F80F8001
      900F83F1F83F8001BFFF8001F87F9FF9FFFF9001F9FF8001FFFF801FFFFF8001
      FFFF801FFFFFFFFFFFFF801FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC003FFFF
      FFE380018001FFFFFFC380018001FFFFFF8780018181FFFFE00F8FF181810F01
      C00F8FF180010F81C01F8FF1800187C18F1F8FF18001C0018F1F80018001E001
      8F1F80018001F019C71F80018F81FFFDC01F807F8003FFFFE03F80FF8007FFFF
      F8FFFFFFC00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00F0000FFFF
      C001E0070000FC3F0000C1830000F00F0000C6618001C00300008E71C0038001
      01808E71C003000001809E79E007000001809E79F00F000000018E71F00F0000
      80078671F01F8001E007C261F81FC003F00FC183FC3FF00FFC3FE007FC3FFE7F
      FFFFF81FFE7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3FFFFFC3FC101FFE18001
      F81FC001FFC08001F00FC001FF808001E007C003FF01E467C003C071FE03E467
      8001C001E007E4678001C001800FE4678001C063001FE4678001C001003FE467
      C003C001003F8001F00FC001003F8001F00FC001103F8001F81FC101E07FE007
      FC3FFFFFE07FF81FFFFFFFFFE1FFFC7F00000000000000000000000000000000
      000000000000}
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 816
    Top = 8
  end
  object ACBrSmartTEF: TACBrSmartTEF
    ProxyPort = '8080'
    ContentsEncodingCompress = []
    NivelLog = 0
    Left = 816
    Top = 80
  end
end
