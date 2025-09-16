{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }    
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{ - Elias César Vieira                                                         }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

(*

  Documentação SmartTEF
  https://poscontrolecombr-my.sharepoint.com/:f:/g/personal/emerson_poscontrole_com_br/EiUWGpBTwyhImcFhFgrJTJMBu36C-KZm1knClhR6p5nA9g?e=7PzZVD

*)

{$I ACBr.inc}

unit ACBrTEFSmartTEFSchemas;

interface

uses
  Classes, SysUtils,
  ACBrBase,
  ACBrJSON,
  ACBrSocket,
  ACBrAPIBase;

const
  cSmartTEFURL = 'https://api.smarttef.mobi';
  cSmartTEFEndpointGet = 'get';
  cSmartTEFEndpointUser = 'user';
  cSmartTEFEndpointBlock = 'block';
  cSmartTEFEndpointPrint = 'print';
  cSmartTEFEndpointStore = 'store';
  cSmartTEFEndpointToken = 'token';
  cSmartTEFEndpointOrder = 'order';
  cSmartTEFEndpointUsers = 'users';
  cSmartTEFEndpointConfig = 'config';
  cSmartTEFEndpointStatus = 'status';
  cSmartTEFEndpointCreate = 'create';
  cSmartTEFEndpointCancel = 'cancelar';
  cSmartTEFEndpointUnblock = 'unblock';
  cSmartTEFEndpointPooling = 'pooling';
  cSmartTEFEndpointManager = 'manager';
  cSmartTEFEndpointNickname = 'nickname';
  cSmartTEFEndpointCommands = 'commands';
  cSmartTEFEndpointEstornar = 'estornar';  
  cSmartTEFEndpointTerminals = 'terminals';
  cSmartTEFEndpointIntegrador = 'integrator';
  cSmartTEFHeaderGWKey = 'Ocp-Apim-Subscription-Key:';

resourcestring
  sErrorInvalidObject = 'Objeto %s inválido ou não preenchido';
  sErrorInvalidParameter = 'Parâmetro(s) %s inválido(s) ou não preenchido(s)';

type

  { Mapeamento das requisições e respostas da API SmartTEF }

  TACBrSmartTEFStatus = (
    stsNone,
    stsPDT,       // Pendente
    stsSOL_EST,   // Solicitou Estorno
    stsCAN_ERP,   // Cancelado pelo ERP
    stsPROC_PAG,  // Processando Pagamento
    stsPROC_EST,  // Processando Estorno
    stsCNC,       // Concluído
    stsREJ_PAG,   // Rejeitado Pagamento
    stsREJ_EST,   // Rejeitado Estorno
    stsEST,       // Estorno
    stsIMP,       // Impresso
    stsREJ,       // Rejeitado
    stsPROC       // Processando
  );

  TACBrSmartTEFPaymentType = (
    stpNone,
    stpCredit,
    stpDebit,
    stpPix,
    stpVoucher,
    stpOthers
  );

  TACBrSmartTEFFeeType = (
    sftNone,
    sftStore,
    sftClient
  );

  TACBrSmartTEFOrderType = (
    sotNone,
    sotCrdUnico,
    sotNrm
  );

  TACBrSmartTEFUserType = (
    stoNone,
    stoADM,
    stoOPER,
    stoGER
  );

  { TACBrSmartTEFOrderExtras }

  TACBrSmartTEFOrderExtras = class(TACBrAPISchema)
  private
    fCPF: String;
    fCNPJ: String;
    fNome: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJson(aJson: TACBrJSONObject); override;
    procedure DoReadFromJson(aJson: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrSmartTEFOrderExtras);

    property CPF: String read fCPF write fCPF;
    property CNPJ: String read fCNPJ write fCNPJ;
    property Nome: String read fNome write fNome;
  end;

  { TACBrSmartTEFOrderCreateRequest }

  TACBrSmartTEFOrderCreateRequest = class(TACBrAPISchema)
  private
    fvalue: Double;
    fpayment_type: TACBrSmartTEFPaymentType;
    finstallments: Integer;
    fcharge_id: String;
    forder_type: TACBrSmartTEFOrderType;
    fextras: TACBrSmartTEFOrderExtras;
    fserial_pos: String;
    fuser_id: Integer;
    ffee_type: TACBrSmartTEFFeeType;
    fhas_details: Boolean;
    function GetExtras: TACBrSmartTEFOrderExtras;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJson(aJson: TACBrJSONObject); override;
    procedure DoReadFromJson(aJson: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrSmartTEFOrderCreateRequest);

    property value: Double read fvalue write fvalue;
    property payment_type: TACBrSmartTEFPaymentType read fpayment_type write fpayment_type;
    property installments: Integer read finstallments write finstallments;
    property charge_id: String read fcharge_id write fcharge_id;
    property order_type: TACBrSmartTEFOrderType read forder_type write forder_type;
    property extras: TACBrSmartTEFOrderExtras read GetExtras;
    property serial_pos: String read fserial_pos write fserial_pos;
    property user_id: Integer read fuser_id write fuser_id;
    property fee_type: TACBrSmartTEFFeeType read ffee_type write ffee_type;
    property has_details: Boolean read fhas_details write fhas_details;
  end;

  { TACBrSmartTEFOrderResponseSchema }

  TACBrSmartTEFOrderResponseSchema = class(TACBrAPISchema)
  private
    fpayment_identifier: String;
    fpayment_status: TACBrSmartTEFStatus;
    forder_type: TACBrSmartTEFOrderType;
    fcharge_id: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJson(aJson: TACBrJSONObject); override;
    procedure DoReadFromJson(aJson: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrSmartTEFOrderResponseSchema);

    property payment_identifier: String read fpayment_identifier write fpayment_identifier;
    property payment_status: TACBrSmartTEFStatus read fpayment_status write fpayment_status;
    property order_type: TACBrSmartTEFOrderType read forder_type write forder_type;
    property charge_id: String read fcharge_id write fcharge_id;
  end;

  { TACBrSmartTEFReason }

  TACBrSmartTEFReason = class(TACBrAPISchema)
  private
    fmsg: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJson(aJson: TACBrJSONObject); override;
    procedure DoReadFromJson(aJson: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrSmartTEFReason);

    property msg: String read fmsg write fmsg;
  end;

  { TACBrSmartTEFCoupon }

  TACBrSmartTEFCoupon = class(TACBrAPISchema)
  private
    fclient: String;
    fstore: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJson(aJson: TACBrJSONObject); override;
    procedure DoReadFromJson(aJson: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrSmartTEFCoupon);

    property client: String read fclient write fclient;
    property store: String read fstore write fstore;
  end;

  { TACBrSmartTEFCardClass }

  TACBrSmartTEFCardClass = class(TACBrAPISchema)
  private
    fpayment_identifier: String;
    fcnpj: String;
    fcreate_at: TDateTime;
    fpayment_value: Double;
    fupdate_at: TDateTime;
    fvalue: Double;
    fpayment_date: TDateTime;
    fautorization_code: String;
    forder_type: TACBrSmartTEFOrderType;
    fpayment_type: TACBrSmartTEFPaymentType;
    fpayment_status: TACBrSmartTEFStatus;
    fcard_brand: String;
    finstallments: Integer;
    fnsu_host: String;
    fnsu_sitef: String;
    facquirer: String;
    fserial_pos: String;
    fuser_id: Integer;
    fextras: TACBrSmartTEFOrderExtras;
    fhas_details: Boolean;
    ftype: String;
    fcharge_id: String;
    freason: TACBrSmartTEFReason;
    frefund_autorization_code: String;
    frefund_serial_pos: String;
    frefund_user_id: Integer;
    fcoupon: TACBrSmartTEFCoupon;
    frefund_coupon: String;
    ffee_type: TACBrSmartTEFFeeType;
    fprint_identifier: String;
    fprint_status: TACBrSmartTEFStatus;
    ffile: String;
    fprint_id: String;

    function GetExtras: TACBrSmartTEFOrderExtras;
    function GetReason: TACBrSmartTEFReason;
    function Getcoupon: TACBrSmartTEFCoupon;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJson(aJson: TACBrJSONObject); override;
    procedure DoReadFromJson(aJson: TACBrJSONObject); override;

    property payment_identifier: String read fpayment_identifier write fpayment_identifier;
    property cnpj: String read fcnpj write fcnpj;
    property create_at: TDateTime read fcreate_at write fcreate_at;
    property update_at: TDateTime read fupdate_at write fupdate_at;
    property value: Double read fvalue write fvalue;
    property payment_value: Double read fpayment_value write fpayment_value;
    property payment_date: TDateTime read fpayment_date write fpayment_date;
    property autorization_code: String read fautorization_code write fautorization_code;
    property order_type: TACBrSmartTEFOrderType read forder_type write forder_type;
    property payment_type: TACBrSmartTEFPaymentType read fpayment_type write fpayment_type;
    property payment_status: TACBrSmartTEFStatus read fpayment_status write fpayment_status;
    property card_brand: String read fcard_brand write fcard_brand;
    property installments: Integer read finstallments write finstallments;
    property nsu_host: String read fnsu_host write fnsu_host;
    property nsu_sitef: String read fnsu_sitef write fnsu_sitef;
    property acquirer: String read facquirer write facquirer;
    property serial_pos: String read fserial_pos write fserial_pos;
    property user_id: Integer read fuser_id write fuser_id;
    property extras: TACBrSmartTEFOrderExtras read GetExtras;
    property has_details: Boolean read fhas_details write fhas_details;
    property type_: String read ftype write ftype;
    property charge_id: String read fcharge_id write fcharge_id;
    property reason: TACBrSmartTEFReason read GetReason;
    property refund_autorization_code: String read frefund_autorization_code write frefund_autorization_code;
    property refund_serial_pos: String read frefund_serial_pos write frefund_serial_pos;
    property refund_user_id: Integer read frefund_user_id write frefund_user_id;
    property coupon: TACBrSmartTEFCoupon read Getcoupon;
    property refund_coupon: String read frefund_coupon write frefund_coupon;
    property fee_type: TACBrSmartTEFFeeType read ffee_type write ffee_type;
    property print_identifier: String read fprint_identifier write fprint_identifier;
    property print_status: TACBrSmartTEFStatus read fprint_status write fprint_status;
    property file_: String read ffile write ffile;
    property print_id: String read fprint_id write fprint_id;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrSmartTEFCardClass);
  end;

  { TACBrSmartTEFCardDetails }

  TACBrSmartTEFCardDetails = class(TACBrSmartTEFCardClass)
  public
    property payment_identifier;
    property cnpj;
    property create_at;
    property update_at;
    property value;
    property payment_value;
    property payment_date;
    property autorization_code;
    property order_type;
    property payment_type;
    property payment_status;
    property card_brand;
    property installments;
    property nsu_host;
    property nsu_sitef;
    property acquirer;
    property serial_pos;
    property user_id;
    property extras;
    property has_details;
    property type_;
    property charge_id;
    property reason;
    property refund_autorization_code;
    property refund_serial_pos;
    property refund_user_id;
    property coupon;
    property refund_coupon;
    property fee_type;
  end;

  {TACBrSmartTEFCardDetailsList}

  TACBrSmartTEFCardDetailsList = class(TACBrAPISchemaArray)
  private
    function GetItem(Index: Integer): TACBrSmartTEFCardDetails;
    procedure SetItem(Index: Integer; AValue: TACBrSmartTEFCardDetails);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aItem: TACBrSmartTEFCardDetails): Integer;
    procedure Insert(Index: Integer; aItem: TACBrSmartTEFCardDetails);
    function New: TACBrSmartTEFCardDetails;
    property Items[Index: Integer]: TACBrSmartTEFCardDetails read GetItem write SetItem; default;
  end;

  { TACBrSmartTEFCardResponse }

  TACBrSmartTEFCardResponse = class(TACBrSmartTEFCardClass)
  public
    property payment_identifier;
    property order_type;
    property payment_status;
  end;

  { TACBrSmartTEFPrintFile }

  TACBrSmartTEFPrintFile = class(TACBrAPISchema)
  private
    fname: String;
    fdata: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJson(aJson: TACBrJSONObject); override;
    procedure DoReadFromJson(aJson: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrSmartTEFPrintFile);

    property name: String read fname write fname;
    property data: String read fdata write fdata;
  end;

  { TACBrSmartTEFPrintCreateRequest }

  TACBrSmartTEFPrintCreateRequest = class(TACBrAPISchema)
  private
    forder_type: TACBrSmartTEFOrderType;
    fprint_id: String;
    ffile: TACBrSmartTEFPrintFile;
    fserial_pos: String;
    fuser_id: Integer;
    function GetFile: TACBrSmartTEFPrintFile;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJson(aJson: TACBrJSONObject); override;
    procedure DoReadFromJson(aJson: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrSmartTEFPrintCreateRequest);

    property order_type: TACBrSmartTEFOrderType read forder_type write forder_type;
    property print_id: String read fprint_id write fprint_id;
    property serial_pos: String read fserial_pos write fserial_pos;
    property user_id: Integer read fuser_id write fuser_id;
    property file_: TACBrSmartTEFPrintFile read GetFile;
  end;

  { TACBrSmartTEFPrintResponseSchemas }
  TACBrSmartTEFPrintResponseSchemas = class(TACBrSmartTEFCardClass)
  public
    property print_identifier;
    property print_status;
    property order_type;
    property file_;
    property print_id;
  end;

  { TACBrSmartTEFPrintDetails }
  TACBrSmartTEFPrintDetails = class(TACBrSmartTEFCardClass)
  public
    property print_identifier;
    property print_status;
    property order_type;
    property file_;
    property print_id;
    property cnpj;
    property create_at;
    property update_at;
    property serial_pos;
    property user_id;
    property type_;
    property has_details;
  end; 

  { TACBrSmartTEFPrintCancelResponse }
  TACBrSmartTEFPrintCancelResponse = class(TACBrSmartTEFCardClass)
  public
    property print_identifier;
    property print_status;
    property order_type;
  end;

  { TACBrSmartTEFLocation }

  TACBrSmartTEFLocation = class(TACBrAPISchema)
  private
    flat: String;
    flong: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJson(aJson: TACBrJSONObject); override;
    procedure DoReadFromJson(aJson: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrSmartTEFLocation);

    property lat: String read flat write flat;
    property long: String read flong write flong;
  end;

  { TACBrSmartTEFTerminalDetails }

  TACBrSmartTEFTerminalDetails = class(TACBrAPISchema)
  private
    fterminal_id: Integer;
    fcnpj: String;
    fcontrole_versao: String;
    factive: Boolean;
    fserial_pos: String;
    fconn_type: Integer;
    fbatt_level: Integer;
    fcharging: Boolean;
    fstore_id: Integer;
    fcreate_at: TDateTime;
    fupdate_at: TDateTime;
    fnickname: String;
    flocation: TACBrSmartTEFLocation;
    function GetLocation: TACBrSmartTEFLocation;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJson(aJson: TACBrJSONObject); override;
    procedure DoReadFromJson(aJson: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrSmartTEFTerminalDetails);

    property terminal_id: Integer read fterminal_id write fterminal_id;
    property cnpj: String read fcnpj write fcnpj;
    property controle_versao: String read fcontrole_versao write fcontrole_versao;
    property active: Boolean read factive write factive;
    property serial_pos: String read fserial_pos write fserial_pos;
    property conn_type: Integer read fconn_type write fconn_type;
    property batt_level: Integer read fbatt_level write fbatt_level;
    property charging: Boolean read fcharging write fcharging;
    property store_id: Integer read fstore_id write fstore_id;
    property create_at: TDateTime read fcreate_at write fcreate_at;
    property update_at: TDateTime read fupdate_at write fupdate_at;
    property nickname: String read fnickname write fnickname;
    property location: TACBrSmartTEFLocation read GetLocation;
  end;

  { TACBrSmartTEFTerminalList }

  TACBrSmartTEFTerminalList = class(TACBrAPISchemaArray)
  private
    function GetItem(Index: Integer): TACBrSmartTEFTerminalDetails;
    procedure SetItem(Index: Integer; AValue: TACBrSmartTEFTerminalDetails);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aItem: TACBrSmartTEFTerminalDetails): Integer;
    procedure Insert(Index: Integer; aItem: TACBrSmartTEFTerminalDetails);
    function New: TACBrSmartTEFTerminalDetails;
    property Items[Index: Integer]: TACBrSmartTEFTerminalDetails read GetItem write SetItem; default;
  end;

  { TACBrSmartTEFUserClass }

  TACBrSmartTEFUserClass = class(TACBrAPISchema)
  private
    fuser_id: Integer;
    femail: String;
    factive: Boolean;
    fuser_type: TACBrSmartTEFUserType;
    fcreate_at: TDateTime;
    fupdate_at: TDateTime;
    fname: String;
    fpos_password: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJson(aJson: TACBrJSONObject); override;
    procedure DoReadFromJson(aJson: TACBrJSONObject); override; 

    property user_id: Integer read fuser_id write fuser_id;
    property email: String read femail write femail;
    property active: Boolean read factive write factive;
    property user_type: TACBrSmartTEFUserType read fuser_type write fuser_type;
    property create_at: TDateTime read fcreate_at write fcreate_at;
    property update_at: TDateTime read fupdate_at write fupdate_at;
    property name: String read fname write fname;
    property pos_password: String read fpos_password write fpos_password;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrSmartTEFUserClass);
  end;

  { TACBrSmartTEFUserRequest }

  TACBrSmartTEFUserRequest = class(TACBrSmartTEFUserClass)
  public
    property name;
    property email;
    property user_type;
  end;

  { TACBrSmartTEFUserCreateResponseSchemas }

  TACBrSmartTEFUserCreateResponseSchemas = class(TACBrSmartTEFUserClass)
  public
    property email;
    property pos_password;
  end;

  { TACBrSmartTEFUser }

  TACBrSmartTEFUser = class(TACBrSmartTEFUserClass)
  public
    property user_id;
    property email;
    property active;
    property user_type;
    property create_at;
    property update_at;
    property name;
    property pos_password;
  end;

  { TACBrSmartTEFUserList }

  TACBrSmartTEFUserList = class(TACBrAPISchemaArray)
  private
    function GetItem(Index: Integer): TACBrSmartTEFUser;
    procedure SetItem(Index: Integer; AValue: TACBrSmartTEFUser);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aItem: TACBrSmartTEFUser): Integer;
    procedure Insert(Index: Integer; aItem: TACBrSmartTEFUser);
    function New: TACBrSmartTEFUser;
    property Items[Index: Integer]: TACBrSmartTEFUser read GetItem write SetItem; default;
  end;

  { TACBrSmartTEFStoreActiveRequest }

  TACBrSmartTEFStoreActiveRequest = class(TACBrAPISchema)
  private
    fcnpj: String;
    fcnpj_integrador: String;
    femail: String;
    fname: String;
    fpassword: String;
    fstore_name: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJson(aJson: TACBrJSONObject); override;
    procedure DoReadFromJson(aJson: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrSmartTEFStoreActiveRequest);

    property cnpj: String read fcnpj write fcnpj;
    property cnpj_integrador: String read fcnpj_integrador write fcnpj_integrador;
    property email: String read femail write femail;
    property password: String read fpassword write fpassword;
    property name: String read fname write fname;
    property store_name: String read fstore_name write fstore_name;
  end;

  { TACBrSmartTEFWebhook }

  TACBrSmartTEFWebhook = class(TACBrAPISchema)
  private
    furl: String;
    fauthorization_token: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJson(aJson: TACBrJSONObject); override;
    procedure DoReadFromJson(aJson: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrSmartTEFWebhook);

    property url: String read furl write furl;
    property authorization_token: String read fauthorization_token write fauthorization_token;
  end;

  { TACBrSmartTEFStore }

  TACBrSmartTEFStore = class(TACBrAPISchema)
  private
    fstore_id: Integer;
    fcnpj: String;
    fcnpj_integrador: String;
    fwebhook: TACBrSmartTEFWebhook;
    factive: Boolean;
    fcreate_at: TDateTime;
    fupdate_at: TDateTime;
    ftoken: String;
    fname: String;
    ftrademark: String;
    fcontact_tel: String;
    fcity_id: Integer;
    fstate_id: Integer;
    fzip_code: String;
    fdisctrict: String;
    faddress: String;
    fintegrator_id: Integer;
    function GetWebhook: TACBrSmartTEFWebhook;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJson(aJson: TACBrJSONObject); override;
    procedure DoReadFromJson(aJson: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrSmartTEFStore);

    property store_id: Integer read fstore_id write fstore_id;
    property cnpj: String read fcnpj write fcnpj;
    property cnpj_integrador: String read fcnpj_integrador write fcnpj_integrador;
    property webhook: TACBrSmartTEFWebhook read GetWebhook;
    property active: Boolean read factive write factive;
    property create_at: TDateTime read fcreate_at write fcreate_at;
    property update_at: TDateTime read fupdate_at write fupdate_at;
    property token: String read ftoken write ftoken;
    property name: String read fname write fname;
    property trademark: String read ftrademark write ftrademark;
    property contact_tel: String read fcontact_tel write fcontact_tel;
    property city_id: Integer read fcity_id write fcity_id;
    property state_id: Integer read fstate_id write fstate_id;
    property zip_code: String read fzip_code write fzip_code;
    property disctrict: String read fdisctrict write fdisctrict;
    property address: String read faddress write faddress;
    property integrator_id: Integer read fintegrator_id write fintegrator_id;
  end;

  { TACBrSmartTEFStoreSettings }

  TACBrSmartTEFStoreSettings = class(TACBrAPISchema)
  private
    fconfig_id: Integer;
    fname: String;
    fvalue: String;
    factive: Boolean;
    fdescription: String;
    fstore_id: Integer;
    fintegrator_id: Integer;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJson(aJson: TACBrJSONObject); override;
    procedure DoReadFromJson(aJson: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrSmartTEFStoreSettings);

    property config_id: Integer read fconfig_id write fconfig_id;
    property name: String read fname write fname;
    property value: String read fvalue write fvalue;
    property active: Boolean read factive write factive;
    property description: String read fdescription write fdescription;
    property store_id: Integer read fstore_id write fstore_id;
    property integrator_id: Integer read fintegrator_id write fintegrator_id;
  end;

  { TACBrSmartTEFStoreSettingsList }

  TACBrSmartTEFStoreSettingsList = class(TACBrAPISchemaArray)
  private
    function GetItem(Index: Integer): TACBrSmartTEFStoreSettings;
    procedure SetItem(Index: Integer; AValue: TACBrSmartTEFStoreSettings);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aItem: TACBrSmartTEFStoreSettings): Integer;
    procedure Insert(Index: Integer; aItem: TACBrSmartTEFStoreSettings);
    function New: TACBrSmartTEFStoreSettings;
    property Items[Index: Integer]: TACBrSmartTEFStoreSettings read GetItem write SetItem; default;
  end;

  TACBrSmartTEFPoolingSchemas = class(TACBrSmartTEFCardClass)
  public
    property payment_identifier;
    property cnpj;
    property create_at;
    property update_at;
    property value;
    property payment_value;
    property payment_date;
    property autorization_code;
    property order_type;
    property payment_type;
    property payment_status;
    property card_brand;
    property installments;
    property nsu_host;
    property nsu_sitef;
    property acquirer;
    property serial_pos;
    property user_id;
    property extras;
    property has_details;
    property type_;
    property charge_id;
    property reason;
    property refund_autorization_code;
    property refund_serial_pos;
    property refund_user_id;
    property coupon;
    property refund_coupon;
    property fee_type;
    property print_identifier;
    property print_status;
    property file_;
    property print_id;
  end;

  { TACBrSmartTEFPoolingList }

  TACBrSmartTEFPoolingList = class(TACBrAPISchemaArray)
  private
    function GetItem(Index: Integer): TACBrSmartTEFPoolingSchemas;
    procedure SetItem(Index: Integer; AValue: TACBrSmartTEFPoolingSchemas);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aItem: TACBrSmartTEFPoolingSchemas): Integer;
    procedure Insert(Index: Integer; aItem: TACBrSmartTEFPoolingSchemas);
    function New: TACBrSmartTEFPoolingSchemas;
    property Items[Index: Integer]: TACBrSmartTEFPoolingSchemas read GetItem write SetItem; default;
  end;

  { TACBrSmartTEFErrorData }

  TACBrSmartTEFErrorData = class(TACBrAPISchema)
  private
    ftimestamp: TDateTime;
    fpath: String;
    fmessage: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJson(aJson: TACBrJSONObject); override;
    procedure DoReadFromJson(aJson: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrSmartTEFErrorData);

    property message: String read fmessage;
    property timestamp: TDateTime read ftimestamp;
    property path: String read fpath;
  end;

  { TACBrSmartTEFError }

  TACBrSmartTEFError = class(TACBrAPISchema)
  private
    fstatus: Integer;
    fdata: TACBrSmartTEFErrorData;
    function GetData: TACBrSmartTEFErrorData;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJson(aJson: TACBrJSONObject); override;
    procedure DoReadFromJson(aJson: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrSmartTEFError);

    property status: Integer read fstatus write fstatus;
    property data: TACBrSmartTEFErrorData read GetData;
  end;

function SmartTEFStatusToString(aStatus: TACBrSmartTEFStatus): String;
function StringToSmartTEFStatus(const aString: String): TACBrSmartTEFStatus;
function SmartTEFPaymentTypeToString(aTipo: TACBrSmartTEFPaymentType): String;
function StringToSmartTEFPaymentType(const aString: String): TACBrSmartTEFPaymentType;
function SmartTEFFeeTypeToString(aTipo: TACBrSmartTEFFeeType): String;
function StringToSmartTEFFeeType(const aString: String): TACBrSmartTEFFeeType;
function SmartTEFOrderTypeToString(aTipo: TACBrSmartTEFOrderType): String;
function StringToSmartTEFOrderType(const aString: String): TACBrSmartTEFOrderType;
function SmartTEFUserTypeToString(aTipo: TACBrSmartTEFUserType): String;
function StringToSmartTEFUserType(const aString: String): TACBrSmartTEFUserType;

implementation

uses
  synautil, StrUtils,
  ACBrUtil.DateTime,
  ACBrUtil.Strings,
  ACBrUtil.Base;

function SmartTEFStatusToString(aStatus: TACBrSmartTEFStatus): String;
begin
  case aStatus of
    stsPDT: Result := 'PDT';
    stsSOL_EST: Result := 'SOL_EST';
    stsCAN_ERP: Result := 'CAN_ERP';
    stsPROC_PAG: Result := 'PROC_PAG';
    stsPROC_EST: Result := 'PROC_EST';
    stsCNC: Result := 'CNC';
    stsREJ_PAG: Result := 'REJ_PAG';
    stsREJ_EST: Result := 'REJ_EST';
    stsEST: Result := 'EST';
    stsIMP: Result := 'IMP';
    stsREJ: Result := 'REJ';
    stsPROC: Result := 'PROC';
  else
    Result := EmptyStr;
  end;
end;

function StringToSmartTEFStatus(const aString: String): TACBrSmartTEFStatus;
var
  s: String;
begin
  Result := stsNone;
  s := UpperCase(Trim(aString));

  if (s = 'PDT') then
    Result := stsPDT
  else if (s = 'SOL_EST') then
    Result := stsSOL_EST
  else if (s = 'CAN_ERP') then
    Result := stsCAN_ERP
  else if (s = 'PROC_PAG') then
    Result := stsPROC_PAG
  else if (s = 'PROC_EST') then
    Result := stsPROC_EST
  else if (s = 'CNC') then
    Result := stsCNC
  else if (s = 'REJ_PAG') then
    Result := stsREJ_PAG
  else if (s = 'REJ_EST') then
    Result := stsREJ_EST
  else if (s = 'EST') then
    Result := stsEST
  else if (s = 'IMP') then
    Result := stsIMP
  else if (s = 'REJ') then
    Result := stsREJ
  else if (s = 'PROC') then
    Result := stsPROC;
end;

function SmartTEFPaymentTypeToString(aTipo: TACBrSmartTEFPaymentType): String;
begin
  case aTipo of
    stpCredit: Result := 'CREDIT';
    stpDebit: Result := 'DEBIT';
    stpPix: Result := 'PIX';
    stpVoucher: Result := 'VOUCHER';
    stpOthers: Result := 'OTHERS';
  else
    Result := EmptyStr;
  end;
end;

function StringToSmartTEFPaymentType(const aString: String): TACBrSmartTEFPaymentType;
var
  s: String;
begin
  Result := stpNone;
  s := UpperCase(Trim(aString));

  if (s = 'CREDIT') then
    Result := stpCredit
  else if (s = 'DEBIT') then
    Result := stpDebit
  else if (s = 'PIX') then
    Result := stpPix
  else if (s = 'VOUCHER') then
    Result := stpVoucher
  else if (s = 'OTHERS') then
    Result := stpOthers;
end;

function SmartTEFFeeTypeToString(aTipo: TACBrSmartTEFFeeType): String;
begin
  case aTipo of
    sftStore: Result := 'F_STORE';
    sftClient: Result := 'F_CLIENT';
  else
    Result := EmptyStr;
  end;
end;

function StringToSmartTEFFeeType(const aString: String): TACBrSmartTEFFeeType;
var
  s: String;
begin
  Result := sftNone;
  s := UpperCase(Trim(aString));

  if (s = 'F_STORE') then
    Result := sftStore
  else if (s = 'F_CLIENT') then
    Result := sftClient;
end;

function SmartTEFOrderTypeToString(aTipo: TACBrSmartTEFOrderType): String;
begin
  case aTipo of
    sotCrdUnico: Result := 'CRD_UNICO';
    sotNrm: Result := 'NRM';
  else
    Result := EmptyStr;
  end;
end;

function StringToSmartTEFOrderType(const aString: String): TACBrSmartTEFOrderType;
var
  s: String;
begin
  Result := sotNone;
  s := UpperCase(Trim(aString));

  if (s = 'CRD_UNICO') then
    Result := sotCrdUnico
  else if (s = 'NRM') then
    Result := sotNrm;
end;

function SmartTEFUserTypeToString(aTipo: TACBrSmartTEFUserType): String;
begin
  case aTipo of
    stoADM: Result := 'ADM';
    stoOPER: Result := 'OPER';
    stoGER: Result := 'GER';
  else
    Result := EmptyStr;
  end;
end;

function StringToSmartTEFUserType(const aString: String): TACBrSmartTEFUserType;
var
  s: String;
begin
  Result := stoNone;
  s := UpperCase(Trim(aString));

  if (s = 'ADM') then
    Result := stoADM
  else if (s = 'OPER') then
    Result := stoOPER
  else if (s = 'GER') then
    Result := stoGER;
end;

{ TACBrSmartTEFLocation }

procedure TACBrSmartTEFLocation.Assign(Source: TACBrSmartTEFLocation);
begin
  if not Assigned(Source) then
    Exit;

  flat := Source.lat;
  flong := Source.long;
end;

procedure TACBrSmartTEFLocation.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrSmartTEFLocation) then
    Assign(TACBrSmartTEFLocation(aSource));
end;

procedure TACBrSmartTEFLocation.Clear;
begin
  flat := EmptyStr;
  flong := EmptyStr;
end;

procedure TACBrSmartTEFLocation.DoReadFromJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .Value('lat', flat)
    .Value('long', flong);
end;

procedure TACBrSmartTEFLocation.DoWriteToJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .AddPair('lat', flat, False)
    .AddPair('long', flong, False);
end;

function TACBrSmartTEFLocation.IsEmpty: Boolean;
begin
  Result := EstaVazio(flat) and EstaVazio(flong);
end;

{ TACBrSmartTEFTerminalDetails }

procedure TACBrSmartTEFTerminalDetails.Assign(Source: TACBrSmartTEFTerminalDetails);
begin
  if not Assigned(Source) then
    Exit;

  fterminal_id := Source.terminal_id;
  fcnpj := Source.cnpj;
  fcontrole_versao := Source.controle_versao;
  factive := Source.active;
  fserial_pos := Source.serial_pos;
  fconn_type := Source.conn_type;
  fbatt_level := Source.batt_level;
  fcharging := Source.charging;
  fstore_id := Source.store_id;
  fcreate_at := Source.create_at;
  fupdate_at := Source.update_at;
  fnickname := Source.nickname;
  location.Assign(Source.location);
end;

procedure TACBrSmartTEFTerminalDetails.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrSmartTEFTerminalDetails) then
    Assign(TACBrSmartTEFTerminalDetails(aSource));
end;

procedure TACBrSmartTEFTerminalDetails.Clear;
begin
  fterminal_id := 0;
  fcnpj := EmptyStr;
  fcontrole_versao := EmptyStr;
  factive := False;
  fserial_pos := EmptyStr;
  fconn_type := 0;
  fbatt_level := 0;
  fcharging := False;
  fstore_id := 0;
  fcreate_at := 0;
  fupdate_at := 0;
  fnickname := EmptyStr;
  if Assigned(flocation) then
    flocation.Clear;
end;

destructor TACBrSmartTEFTerminalDetails.Destroy;
begin
  if Assigned(flocation) then
    flocation.Free;
  inherited;
end;

procedure TACBrSmartTEFTerminalDetails.DoReadFromJson(aJson: TACBrJSONObject);
var
  sCreateAt, sUpdateAt: String;
begin
  if not Assigned(aJson) then
    Exit;

  {$IfDef FPC}
    sCreateAt := EmptyStr;
    sUpdateAt := EmptyStr;
  {$EndIf}

  aJson
    .Value('terminal_id', fterminal_id)
    .Value('cnpj', fcnpj)
    .Value('controle_versao', fcontrole_versao)
    .Value('active', factive)
    .Value('serial_pos', fserial_pos)
    .Value('conn_type', fconn_type)
    .Value('batt_level', fbatt_level)
    .Value('charging', fcharging)
    .Value('store_id', fstore_id)
    .Value('create_at', sCreateAt)
    .Value('update_at', sUpdateAt)
    .Value('nickname', fnickname);

  if NaoEstaVazio(sCreateAt) then
    fcreate_at := Iso8601ToDateTime(sCreateAt);
  if NaoEstaVazio(sUpdateAt) then
    fupdate_at := Iso8601ToDateTime(sUpdateAt);

  location.ReadFromJson(aJson);
end;

procedure TACBrSmartTEFTerminalDetails.DoWriteToJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .AddPair('terminal_id', fterminal_id)
    .AddPair('cnpj', fcnpj, False)
    .AddPair('controle_versao', fcontrole_versao, False)
    .AddPair('active', factive)
    .AddPair('serial_pos', fserial_pos, False)
    .AddPair('conn_type', fconn_type, False)
    .AddPair('batt_level', fbatt_level, False)
    .AddPair('charging', fcharging)
    .AddPair('store_id', fstore_id, False)
    .AddPair('nickname', fnickname, False);

  if (fcreate_at > 0) then
    aJson.AddPair('create_at', DateTimeToIso8601(fcreate_at));
  if (fupdate_at > 0) then
    aJson.AddPair('update_at', DateTimeToIso8601(fupdate_at));

  if Assigned(flocation) then
    flocation.WriteToJson(aJson);
end;

function TACBrSmartTEFTerminalDetails.GetLocation: TACBrSmartTEFLocation;
begin
  if not Assigned(flocation) then
    flocation := TACBrSmartTEFLocation.Create('location');
  Result := flocation;
end;

function TACBrSmartTEFTerminalDetails.IsEmpty: Boolean;
begin
  Result :=
    EstaZerado(fterminal_id) and
    EstaVazio(fcnpj) and
    EstaVazio(fcontrole_versao) and
    not factive and
    EstaVazio(fserial_pos) and
    EstaZerado(fconn_type) and
    EstaZerado(fbatt_level) and
    not fcharging and
    EstaZerado(fstore_id) and
    EstaZerado(fcreate_at) and
    EstaZerado(fupdate_at) and
    EstaVazio(fnickname) and
    ((not Assigned(flocation)) or flocation.IsEmpty);
end;

{ TACBrSmartTEFWebhook }

procedure TACBrSmartTEFWebhook.Assign(Source: TACBrSmartTEFWebhook);
begin
  if not Assigned(Source) then
    Exit;

  furl := Source.url;
  fauthorization_token := Source.authorization_token;
end;

procedure TACBrSmartTEFWebhook.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrSmartTEFWebhook) then
    Assign(TACBrSmartTEFWebhook(aSource));
end;

procedure TACBrSmartTEFWebhook.Clear;
begin
  furl := EmptyStr;
  fauthorization_token := EmptyStr;
end;

procedure TACBrSmartTEFWebhook.DoReadFromJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .Value('url', furl)
    .Value('authorization_token', fauthorization_token);
end;

procedure TACBrSmartTEFWebhook.DoWriteToJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .AddPair('url', furl, False)
    .AddPair('authorization_token', fauthorization_token, False);
end;

function TACBrSmartTEFWebhook.IsEmpty: Boolean;
begin
  Result := EstaVazio(furl) and EstaVazio(fauthorization_token);
end;

{ TACBrSmartTEFTerminalList }

function TACBrSmartTEFTerminalList.GetItem(Index: Integer): TACBrSmartTEFTerminalDetails;
begin
  Result := TACBrSmartTEFTerminalDetails(inherited Items[Index]);
end;

procedure TACBrSmartTEFTerminalList.SetItem(Index: Integer; AValue: TACBrSmartTEFTerminalDetails);
begin
  inherited Items[Index] := AValue;
end;

function TACBrSmartTEFTerminalList.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrSmartTEFTerminalList.Add(aItem: TACBrSmartTEFTerminalDetails): Integer;
begin
  Result := inherited Add(aItem);
end;

procedure TACBrSmartTEFTerminalList.Insert(Index: Integer; aItem: TACBrSmartTEFTerminalDetails);
begin
  inherited Insert(Index, aItem);
end;

function TACBrSmartTEFTerminalList.New: TACBrSmartTEFTerminalDetails;
begin
  Result := TACBrSmartTEFTerminalDetails.Create;
  Self.Add(Result);
end;

{ TACBrSmartTEFUserClass }

procedure TACBrSmartTEFUserClass.Assign(Source: TACBrSmartTEFUserClass);
begin
  if not Assigned(Source) then
    Exit;

  fuser_id := Source.user_id;
  femail := Source.email;
  factive := Source.active;
  fuser_type := Source.user_type;
  fcreate_at := Source.create_at;
  fupdate_at := Source.update_at;
  fname := Source.name;
  fpos_password := Source.pos_password;
end;

{ TACBrSmartTEFStore }

procedure TACBrSmartTEFStore.Assign(Source: TACBrSmartTEFStore);
begin
  if not Assigned(Source) then
    Exit;

  fstore_id := Source.store_id;
  fcnpj := Source.cnpj;
  fcnpj_integrador := Source.cnpj_integrador;
  webhook.Assign(Source.webhook);
  factive := Source.active;
  fcreate_at := Source.create_at;
  fupdate_at := Source.update_at;
  ftoken := Source.token;
  fname := Source.name;
  ftrademark := Source.trademark;
  fcontact_tel := Source.contact_tel;
  fcity_id := Source.city_id;
  fstate_id := Source.state_id;
  fzip_code := Source.zip_code;
  fdisctrict := Source.disctrict;
  faddress := Source.address;
  fintegrator_id := Source.integrator_id;
end;

{ TACBrSmartTEFStoreSettings }

procedure TACBrSmartTEFStoreSettings.Assign(Source: TACBrSmartTEFStoreSettings);
begin
  if not Assigned(Source) then
    Exit;

  fconfig_id := Source.config_id;
  fname := Source.name;
  fvalue := Source.value;
  factive := Source.active;
  fdescription := Source.description;
  fstore_id := Source.store_id;
  fintegrator_id := Source.integrator_id;
end;

procedure TACBrSmartTEFStoreSettings.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrSmartTEFStoreSettings) then
    Assign(TACBrSmartTEFStoreSettings(aSource));
end;

procedure TACBrSmartTEFStoreSettings.Clear;
begin
  fconfig_id := 0;
  fname := EmptyStr;
  fvalue := EmptyStr;
  factive := False;
  fdescription := EmptyStr;
  fstore_id := 0;
  fintegrator_id := 0;
end;

procedure TACBrSmartTEFStoreSettings.DoReadFromJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .Value('config_id', fconfig_id)
    .Value('name', fname)
    .Value('value', fvalue)
    .Value('active', factive)
    .Value('description', fdescription)
    .Value('store_id', fstore_id)
    .Value('integrator_id', fintegrator_id);
end;

procedure TACBrSmartTEFStoreSettings.DoWriteToJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .AddPair('config_id', fconfig_id, False)
    .AddPair('name', fname, False)
    .AddPair('value', fvalue, False)
    .AddPair('active', factive)
    .AddPair('description', fdescription, False)
    .AddPair('store_id', fstore_id, False)
    .AddPair('integrator_id', fintegrator_id, False);
end;

function TACBrSmartTEFStoreSettings.IsEmpty: Boolean;
begin
  Result :=
    EstaZerado(fconfig_id) and
    EstaVazio(fname) and
    EstaVazio(fvalue) and
    not factive and
    EstaVazio(fdescription) and
    EstaZerado(fstore_id) and
    EstaZerado(fintegrator_id);
end;

{ TACBrSmartTEFStoreSettingsList }

function TACBrSmartTEFStoreSettingsList.GetItem(Index: Integer): TACBrSmartTEFStoreSettings;
begin
  Result := TACBrSmartTEFStoreSettings(inherited Items[Index]);
end;

{ TACBrSmartTEFPoolingList }

function TACBrSmartTEFPoolingList.GetItem(Index: Integer): TACBrSmartTEFPoolingSchemas;
begin
  Result := TACBrSmartTEFPoolingSchemas(inherited Items[Index]);
end;

procedure TACBrSmartTEFPoolingList.SetItem(Index: Integer; AValue: TACBrSmartTEFPoolingSchemas);
begin
  inherited Items[Index] := AValue;
end;

function TACBrSmartTEFPoolingList.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrSmartTEFPoolingList.Add(aItem: TACBrSmartTEFPoolingSchemas): Integer;
begin
  Result := inherited Add(aItem);
end;

procedure TACBrSmartTEFPoolingList.Insert(Index: Integer; aItem: TACBrSmartTEFPoolingSchemas);
begin
  inherited Insert(Index, aItem);
end;

function TACBrSmartTEFPoolingList.New: TACBrSmartTEFPoolingSchemas;
begin
  Result := TACBrSmartTEFPoolingSchemas.Create;
  Self.Add(Result);
end;

procedure TACBrSmartTEFStoreSettingsList.SetItem(Index: Integer; AValue: TACBrSmartTEFStoreSettings);
begin
  inherited Items[Index] := AValue;
end;

function TACBrSmartTEFStoreSettingsList.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrSmartTEFStoreSettingsList.Add(aItem: TACBrSmartTEFStoreSettings): Integer;
begin
  Result := inherited Add(aItem);
end;

procedure TACBrSmartTEFStoreSettingsList.Insert(Index: Integer; aItem: TACBrSmartTEFStoreSettings);
begin
  inherited Insert(Index, aItem);
end;

function TACBrSmartTEFStoreSettingsList.New: TACBrSmartTEFStoreSettings;
begin
  Result := TACBrSmartTEFStoreSettings.Create;
  Self.Add(Result);
end;

procedure TACBrSmartTEFStore.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrSmartTEFStore) then
    Assign(TACBrSmartTEFStore(aSource));
end;

procedure TACBrSmartTEFStore.Clear;
begin
  fstore_id := 0;
  fcnpj := EmptyStr;
  fcnpj_integrador := EmptyStr;
  factive := False;
  fcreate_at := 0;
  fupdate_at := 0;
  ftoken := EmptyStr;
  fname := EmptyStr;
  ftrademark := EmptyStr;
  fcontact_tel := EmptyStr;
  fcity_id := 0;
  fstate_id := 0;
  fzip_code := EmptyStr;
  fdisctrict := EmptyStr;
  faddress := EmptyStr;
  fintegrator_id := 0;
  if Assigned(fwebhook) then
    fwebhook.Clear;
end;

destructor TACBrSmartTEFStore.Destroy;
begin
  if Assigned(fwebhook) then
    fwebhook.Free;
  inherited;
end;

procedure TACBrSmartTEFStore.DoReadFromJson(aJson: TACBrJSONObject);
var
  sCreateAt, sUpdateAt: String;
begin
  if not Assigned(aJson) then
    Exit;

  {$IfDef FPC}
    sCreateAt := EmptyStr;
    sUpdateAt := EmptyStr;
  {$EndIf}

  aJson
    .Value('store_id', fstore_id)
    .Value('cnpj', fcnpj)
    .Value('cnpj_integrador', fcnpj_integrador)
    .Value('active', factive)
    .Value('create_at', sCreateAt)
    .Value('update_at', sUpdateAt)
    .Value('token', ftoken)
    .Value('name', fname)
    .Value('trademark', ftrademark)
    .Value('contact_tel', fcontact_tel)
    .Value('city_id', fcity_id)
    .Value('state_id', fstate_id)
    .Value('zip_code', fzip_code)
    .Value('disctrict', fdisctrict)
    .Value('address', faddress)
    .Value('integrator_id', fintegrator_id);

  if NaoEstaVazio(sCreateAt) then
    fcreate_at := Iso8601ToDateTime(sCreateAt);
  if NaoEstaVazio(sUpdateAt) then
    fupdate_at := Iso8601ToDateTime(sUpdateAt);

  webhook.ReadFromJson(aJson);
end;

procedure TACBrSmartTEFStore.DoWriteToJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .AddPair('store_id', fstore_id, False)
    .AddPair('cnpj', fcnpj, False)
    .AddPair('cnpj_integrador', fcnpj_integrador, False)
    .AddPair('active', factive)
    .AddPair('token', ftoken, False)
    .AddPair('name', fname, False)
    .AddPair('trademark', ftrademark, False)
    .AddPair('contact_tel', fcontact_tel, False)
    .AddPair('city_id', fcity_id, False)
    .AddPair('state_id', fstate_id, False)
    .AddPair('zip_code', fzip_code, False)
    .AddPair('disctrict', fdisctrict, False)
    .AddPair('address', faddress, False)
    .AddPair('integrator_id', fintegrator_id, False);

  if (fcreate_at > 0) then
    aJson.AddPair('create_at', DateTimeToIso8601(fcreate_at));
  if (fupdate_at > 0) then
    aJson.AddPair('update_at', DateTimeToIso8601(fupdate_at));

  if Assigned(fwebhook) then
    fwebhook.WriteToJson(aJson);
end;

function TACBrSmartTEFStore.GetWebhook: TACBrSmartTEFWebhook;
begin
  if not Assigned(fwebhook) then
    fwebhook := TACBrSmartTEFWebhook.Create('webhook');
  Result := fwebhook;
end;

function TACBrSmartTEFStore.IsEmpty: Boolean;
begin
  Result :=
    EstaZerado(fstore_id) and
    EstaVazio(fcnpj) and
    EstaVazio(fcnpj_integrador) and
    not factive and
    EstaZerado(fcreate_at) and
    EstaZerado(fupdate_at) and
    EstaVazio(ftoken) and
    EstaVazio(fname) and
    EstaVazio(ftrademark) and
    EstaVazio(fcontact_tel) and
    EstaZerado(fcity_id) and
    EstaZerado(fstate_id) and
    EstaVazio(fzip_code) and
    EstaVazio(fdisctrict) and
    EstaVazio(faddress) and
    EstaZerado(fintegrator_id) and
    ((not Assigned(fwebhook)) or fwebhook.IsEmpty);
end;

{ TACBrSmartTEFUserClass }

procedure TACBrSmartTEFUserClass.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrSmartTEFUserClass) then
    Assign(TACBrSmartTEFUserClass(aSource));
end;

procedure TACBrSmartTEFUserClass.Clear;
begin
  fuser_id := 0;
  femail := EmptyStr;
  factive := False;
  fuser_type := stoNone;
  fcreate_at := 0;
  fupdate_at := 0;
  fname := EmptyStr;
  fpos_password := EmptyStr;
end;

procedure TACBrSmartTEFUserClass.DoReadFromJson(aJson: TACBrJSONObject);
var
  sCreateAt, sUpdateAt, sUserType: String;
begin
  if not Assigned(aJson) then
    Exit;

  {$IfDef FPC}
    sCreateAt := EmptyStr;
    sUpdateAt := EmptyStr;
    sUserType := EmptyStr;
  {$EndIf}

  aJson
    .Value('user_id', fuser_id)
    .Value('email', femail)
    .Value('active', factive)
    .Value('user_type', sUserType)
    .Value('create_at', sCreateAt)
    .Value('update_at', sUpdateAt)
    .Value('name', fname)
    .Value('pos_password', fpos_password);

  if NaoEstaVazio(sCreateAt) then
    fcreate_at := Iso8601ToDateTime(sCreateAt);
  if NaoEstaVazio(sUpdateAt) then
    fupdate_at := Iso8601ToDateTime(sUpdateAt);
  if NaoEstaVazio(sUserType) then
    fuser_type := StringToSmartTEFUserType(sUserType);
end;

procedure TACBrSmartTEFUserClass.DoWriteToJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .AddPair('user_id', fuser_id, False)
    .AddPair('email', femail, False)
    .AddPair('user_type', SmartTEFUserTypeToString(fuser_type), False)
    .AddPair('name', fname, False)
    .AddPair('pos_password', fpos_password, False);

  if factive then
    aJson.AddPair('active', factive);
  if (fcreate_at > 0) then
    aJson.AddPair('create_at', DateTimeToIso8601(fcreate_at));
  if (fupdate_at > 0) then
    aJson.AddPair('update_at', DateTimeToIso8601(fupdate_at));
end;

function TACBrSmartTEFUserClass.IsEmpty: Boolean;
begin
  Result :=
    EstaZerado(fuser_id) and
    EstaVazio(femail) and
    not factive and
    (fuser_type = stoNone) and
    EstaZerado(fcreate_at) and
    EstaZerado(fupdate_at) and
    EstaVazio(fname) and
    EstaVazio(fpos_password);
end;

{ TACBrSmartTEFUserList }

function TACBrSmartTEFUserList.GetItem(Index: Integer): TACBrSmartTEFUser;
begin
  Result := TACBrSmartTEFUser(inherited Items[Index]);
end;

procedure TACBrSmartTEFUserList.SetItem(Index: Integer; AValue: TACBrSmartTEFUser);
begin
  inherited Items[Index] := AValue;
end;

function TACBrSmartTEFUserList.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrSmartTEFUserList.Add(aItem: TACBrSmartTEFUser): Integer;
begin
  Result := inherited Add(aItem);
end;

procedure TACBrSmartTEFUserList.Insert(Index: Integer; aItem: TACBrSmartTEFUser);
begin
  inherited Insert(Index, aItem);
end;

function TACBrSmartTEFUserList.New: TACBrSmartTEFUser;
begin
  Result := TACBrSmartTEFUser.Create;
  Self.Add(Result);
end;

{ TACBrSmartTEFOrderExtras }

procedure TACBrSmartTEFOrderExtras.Assign(Source: TACBrSmartTEFOrderExtras);
begin
  if not Assigned(Source) then
    Exit;

  fCPF := Source.CPF;
  fCNPJ := Source.CNPJ;
  fNome := Source.Nome;
end;

procedure TACBrSmartTEFOrderExtras.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrSmartTEFOrderExtras) then
    Assign(TACBrSmartTEFOrderExtras(aSource));
end;

procedure TACBrSmartTEFOrderExtras.Clear;
begin
  fCPF := EmptyStr;
  fCNPJ := EmptyStr;
  fNome := EmptyStr;
end;

procedure TACBrSmartTEFOrderExtras.DoReadFromJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .Value('CPF', fCPF)
    .Value('CNPJ', fCNPJ)
    .Value('Nome', fNome);
end;

procedure TACBrSmartTEFOrderExtras.DoWriteToJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .AddPair('CPF', fCPF, False)
    .AddPair('CNPJ', fCNPJ, False)
    .AddPair('Nome', fNome, False);
end;

function TACBrSmartTEFOrderExtras.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fCPF) and
    EstaVazio(fCNPJ) and
    EstaVazio(fNome);
end;

{ TACBrSmartTEFOrderCreateRequest }

procedure TACBrSmartTEFOrderCreateRequest.Assign(Source: TACBrSmartTEFOrderCreateRequest);
begin
  if not Assigned(Source) then
    Exit;

  fvalue := Source.value;
  fpayment_type := Source.payment_type;
  finstallments := Source.installments;
  fcharge_id := Source.charge_id;
  forder_type := Source.order_type;
  extras.Assign(Source.extras);
  fserial_pos := Source.serial_pos;
  fuser_id := Source.user_id;
  ffee_type := Source.fee_type;
  fhas_details := Source.has_details;
end;

procedure TACBrSmartTEFOrderCreateRequest.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrSmartTEFOrderCreateRequest) then
    Assign(TACBrSmartTEFOrderCreateRequest(aSource));
end;

procedure TACBrSmartTEFOrderCreateRequest.Clear;
begin
  fvalue := 0;
  fpayment_type := stpNone;
  finstallments := 0;
  fcharge_id := EmptyStr;
  forder_type := sotNone;
  if Assigned(fextras) then
    fextras.Clear;
  fserial_pos := EmptyStr;
  fuser_id := 0;
  ffee_type := sftNone;
  fhas_details := False;
end;

destructor TACBrSmartTEFOrderCreateRequest.Destroy;
begin
  if Assigned(fextras) then
    fextras.Free;
  inherited;
end;

procedure TACBrSmartTEFOrderCreateRequest.DoReadFromJson(aJson: TACBrJSONObject);
var
  sPaymentType, sOrderType, sFeeType: String;
begin
  if not Assigned(aJson) then
    Exit;

  {$IfDef FPC}
    sPaymentType := EmptyStr;
    sOrderType := EmptyStr;
    sFeeType := EmptyStr;
  {$EndIf}

  aJson
    .Value('value', fvalue)
    .Value('payment_type', sPaymentType)
    .Value('installments', finstallments)
    .Value('charge_id', fcharge_id)
    .Value('order_type', sOrderType)
    .Value('serial_pos', fserial_pos)
    .Value('user_id', fuser_id)
    .Value('fee_type', sFeeType)
    .Value('has_details', fhas_details);

  extras.ReadFromJson(aJson);

  if NaoEstaVazio(sPaymentType) then
    fpayment_type := StringToSmartTEFPaymentType(sPaymentType);
  if NaoEstaVazio(sOrderType) then
    forder_type := StringToSmartTEFOrderType(sOrderType);
  if NaoEstaVazio(sFeeType) then
    ffee_type := StringToSmartTEFFeeType(sFeeType);
end;

procedure TACBrSmartTEFOrderCreateRequest.DoWriteToJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .AddPair('value', fvalue)
    .AddPair('payment_type', SmartTEFPaymentTypeToString(fpayment_type), False)
    .AddPair('installments', finstallments, False)
    .AddPair('charge_id', fcharge_id, False)
    .AddPair('order_type', SmartTEFOrderTypeToString(forder_type), False)
    .AddPair('serial_pos', fserial_pos, False)
    .AddPair('user_id', fuser_id, False)
    .AddPair('fee_type', SmartTEFFeeTypeToString(ffee_type), False)
    .AddPair('has_details', fhas_details);

  if Assigned(fextras) then
    fextras.WriteToJson(aJson);
end;

function TACBrSmartTEFOrderCreateRequest.GetExtras: TACBrSmartTEFOrderExtras;
begin
  if not Assigned(fextras) then
    fextras := TACBrSmartTEFOrderExtras.Create('extras');
  Result := fextras;
end;

function TACBrSmartTEFOrderCreateRequest.IsEmpty: Boolean;
begin
  Result :=
    EstaZerado(fvalue) and
    (fpayment_type = stpNone) and
    EstaZerado(finstallments) and
    EstaVazio(fcharge_id) and
    (forder_type = sotNone) and
    (not Assigned(fextras) or fextras.IsEmpty) and
    EstaVazio(fserial_pos) and
    EstaZerado(fuser_id) and
    (ffee_type = sftNone) and
    not fhas_details;
end;

{ TACBrSmartTEFOrderResponseSchema }

procedure TACBrSmartTEFOrderResponseSchema.Assign(Source: TACBrSmartTEFOrderResponseSchema);
begin
  if not Assigned(Source) then
    Exit;

  fpayment_identifier := Source.payment_identifier;
  fpayment_status := Source.payment_status;
  forder_type := Source.order_type;
  fcharge_id := Source.charge_id;
end;

procedure TACBrSmartTEFOrderResponseSchema.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrSmartTEFOrderResponseSchema) then
    Assign(TACBrSmartTEFOrderResponseSchema(aSource));
end;

procedure TACBrSmartTEFOrderResponseSchema.Clear;
begin
  fpayment_identifier := EmptyStr;
  fpayment_status := stsNone;
  forder_type := sotNone;
  fcharge_id := EmptyStr;
end;

procedure TACBrSmartTEFOrderResponseSchema.DoReadFromJson(aJson: TACBrJSONObject);
var
  sPaymentStatus, sOrderType: String;
begin
  if not Assigned(aJson) then
    Exit;

  {$IfDef FPC}
    sPaymentStatus := EmptyStr;
    sOrderType := EmptyStr;
  {$EndIf}

  aJson
    .Value('payment_identifier', fpayment_identifier)
    .Value('payment_status', sPaymentStatus)
    .Value('order_type', sOrderType)
    .Value('charge_id', fcharge_id);

  if NaoEstaVazio(sPaymentStatus) then
    fpayment_status := StringToSmartTEFStatus(sPaymentStatus);

  if NaoEstaVazio(sOrderType) then
    forder_type := StringToSmartTEFOrderType(sOrderType);
end;

procedure TACBrSmartTEFOrderResponseSchema.DoWriteToJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .AddPair('payment_identifier', fpayment_identifier)
    .AddPair('payment_status', SmartTEFStatusToString(fpayment_status))
    .AddPair('order_type', SmartTEFOrderTypeToString(forder_type))
    .AddPair('charge_id', fcharge_id);
end;

function TACBrSmartTEFOrderResponseSchema.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fpayment_identifier) and
    (fpayment_status = stsNone) and
    (forder_type = sotNone) and
    EstaVazio(fcharge_id);
end;

{ TACBrSmartTEFReason }

procedure TACBrSmartTEFReason.Assign(Source: TACBrSmartTEFReason);
begin
  if not Assigned(Source) then
    Exit;

  fmsg := Source.msg;
end;

procedure TACBrSmartTEFReason.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrSmartTEFReason) then
    Assign(TACBrSmartTEFReason(aSource));
end;

procedure TACBrSmartTEFReason.Clear;
begin
  fmsg := EmptyStr;
end;

procedure TACBrSmartTEFReason.DoReadFromJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson.Value('msg', fmsg);
end;

procedure TACBrSmartTEFReason.DoWriteToJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson.AddPair('msg', fmsg);
end;

function TACBrSmartTEFReason.IsEmpty: Boolean;
begin
  Result := EstaVazio(fmsg);
end;

{ TACBrSmartTEFCoupon }

procedure TACBrSmartTEFCoupon.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrSmartTEFCoupon) then
    Assign(TACBrSmartTEFCoupon(aSource));
end;

procedure TACBrSmartTEFCoupon.DoWriteToJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .AddPair('client', fclient)
    .AddPair('store', fstore);
end;

procedure TACBrSmartTEFCoupon.DoReadFromJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .Value('client', fclient)
    .Value('store', fstore);
end;

procedure TACBrSmartTEFCoupon.Clear;
begin
  fclient := EmptyStr;
  fstore := EmptyStr;
end;

function TACBrSmartTEFCoupon.IsEmpty: Boolean;
begin
  Result := EstaVazio(fclient) and EstaVazio(fstore);
end;

procedure TACBrSmartTEFCoupon.Assign(Source: TACBrSmartTEFCoupon);
begin
  fclient := Source.client;
  fstore := Source.store;
end;

{ TACBrSmartTEFCardClass }

procedure TACBrSmartTEFCardClass.Assign(Source: TACBrSmartTEFCardClass);
begin
  if not Assigned(Source) then
    Exit;

  fpayment_identifier := Source.payment_identifier;
  fcnpj := Source.cnpj;
  fcreate_at := Source.create_at;
  fupdate_at := Source.update_at;
  fvalue := Source.value;
  fpayment_value := Source.payment_value;
  fpayment_date := Source.payment_date;
  fautorization_code := Source.autorization_code;
  forder_type := Source.order_type;
  fpayment_type := Source.payment_type;
  fpayment_status := Source.payment_status;
  fcard_brand := Source.card_brand;
  finstallments := Source.installments;
  fnsu_host := Source.nsu_host;
  fnsu_sitef := Source.nsu_sitef;
  facquirer := Source.acquirer;
  fserial_pos := Source.serial_pos;
  fuser_id := Source.user_id;
  extras.Assign(Source.extras);
  fhas_details := Source.has_details;
  ftype := Source.type_;
  fcharge_id := Source.charge_id;
  reason.Assign(Source.reason);
  frefund_autorization_code := Source.refund_autorization_code;
  frefund_serial_pos := Source.refund_serial_pos;
  frefund_user_id := Source.refund_user_id;
  coupon.Assign(Source.coupon);
  frefund_coupon := Source.refund_coupon;
  ffee_type := Source.fee_type;
  fprint_identifier := Source.print_identifier;
  fprint_status := Source.print_status;
  ffile := Source.file_;
  fprint_id := Source.print_id;
end;

procedure TACBrSmartTEFCardClass.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrSmartTEFCardClass) then
    Assign(TACBrSmartTEFCardClass(aSource));
end;

procedure TACBrSmartTEFCardClass.Clear;
begin
  fpayment_identifier := EmptyStr;
  fcnpj := EmptyStr;
  fcreate_at := 0;
  fupdate_at := 0;
  fvalue := 0;
  fpayment_value := 0;
  fpayment_date := 0;
  fautorization_code := EmptyStr;
  forder_type := sotNone;
  fpayment_type := stpNone;
  fpayment_status := stsNone;
  fcard_brand := EmptyStr;
  finstallments := 0;
  fnsu_host := EmptyStr;
  fnsu_sitef := EmptyStr;
  facquirer := EmptyStr;
  fserial_pos := EmptyStr;
  fuser_id := 0;
  if Assigned(fextras) then
    fextras.Clear;
  fhas_details := False;
  ftype := EmptyStr;
  fcharge_id := EmptyStr;
  if Assigned(freason) then
    freason.Clear;
  frefund_autorization_code := EmptyStr;
  frefund_serial_pos := EmptyStr;
  frefund_user_id := 0;
  if Assigned(fcoupon) then
    fcoupon.Clear;
  frefund_coupon := EmptyStr;
  ffee_type := sftNone;
  fprint_identifier := EmptyStr;
  fprint_status := stsNone;
  ffile := EmptyStr;
  fprint_id := EmptyStr;
end;

destructor TACBrSmartTEFCardClass.Destroy;
begin
  if Assigned(fextras) then
    fextras.Free;
  if Assigned(freason) then
    freason.Free;
  if Assigned(fcoupon) then
    fcoupon.Free;
  inherited;
end;

procedure TACBrSmartTEFCardClass.DoReadFromJson(aJson: TACBrJSONObject);
var
  sCreateAt, sUpdateAt, sPaymentDate, sOrderType, sPaymentType, sPaymentStatus,
    sFeeType, sStatus: String;
begin
  if not Assigned(aJson) then
    Exit;

  {$IfDef FPC}
    sCreateAt := EmptyStr;
    sUpdateAt := EmptyStr;
    sPaymentDate := EmptyStr;
    sOrderType := EmptyStr;
    sPaymentType := EmptyStr;
    sPaymentStatus := EmptyStr;
    sFeeType := EmptyStr;
  {$EndIf}

  aJson
    .Value('payment_identifier', fpayment_identifier)
    .Value('cnpj', fcnpj)
    .Value('create_at', sCreateAt)
    .Value('update_at', sUpdateAt)
    .Value('value', fvalue)
    .Value('payment_value', fpayment_value)
    .Value('payment_date', sPaymentDate)
    .Value('autorization_code', fautorization_code)
    .Value('order_type', sOrderType)
    .Value('payment_type', sPaymentType)
    .Value('payment_status', sPaymentStatus)
    .Value('card_brand', fcard_brand)
    .Value('installments', finstallments)
    .Value('nsu_host', fnsu_host)
    .Value('nsu_sitef', fnsu_sitef)
    .Value('acquirer', facquirer)
    .Value('serial_pos', fserial_pos)
    .Value('user_id', fuser_id)
    .Value('has_details', fhas_details)
    .Value('type', ftype)
    .Value('charge_id', fcharge_id)
    .Value('refund_autorization_code', frefund_autorization_code)
    .Value('refund_serial_pos', frefund_serial_pos)
    .Value('refund_user_id', frefund_user_id)
    .Value('refund_coupon', frefund_coupon)
    .Value('fee_type', sFeeType)
    .Value('print_identifier', fprint_identifier)
    .Value('print_status', sStatus)
    .Value('file', ffile)
    .Value('print_id', fprint_id);

  if NaoEstaVazio(sCreateAt) then
    fcreate_at := Iso8601ToDateTime(sCreateAt);
  if NaoEstaVazio(sUpdateAt) then
    fupdate_at := Iso8601ToDateTime(sUpdateAt);
  if NaoEstaVazio(sPaymentDate) then
    fpayment_date := Iso8601ToDateTime(sPaymentDate);
  if NaoEstaVazio(sOrderType) then
    forder_type := StringToSmartTEFOrderType(sOrderType);
  if NaoEstaVazio(sPaymentType) then
    fpayment_type := StringToSmartTEFPaymentType(sPaymentType);
  if NaoEstaVazio(sPaymentStatus) then
    fpayment_status := StringToSmartTEFStatus(sPaymentStatus);
  if NaoEstaVazio(sFeeType) then
    ffee_type := StringToSmartTEFFeeType(sFeeType);
  if NaoEstaVazio(sStatus) then
    fprint_status := StringToSmartTEFStatus(sStatus);

  extras.ReadFromJson(aJson);
  reason.ReadFromJson(aJson);
  coupon.ReadFromJSon(aJson);
end;

procedure TACBrSmartTEFCardClass.DoWriteToJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .AddPair('payment_identifier', fpayment_identifier, False)
    .AddPair('print_identifier', fprint_identifier, False)
    .AddPair('print_status', SmartTEFStatusToString(fprint_status), False)
    .AddPair('cnpj', fcnpj, False)
    .AddPair('value', fvalue, False)
    .AddPair('payment_value', fpayment_value, False)
    .AddPair('autorization_code', fautorization_code, False)
    .AddPair('order_type', SmartTEFOrderTypeToString(forder_type), False)
    .AddPair('payment_type', SmartTEFPaymentTypeToString(fpayment_type), False)
    .AddPair('payment_status', SmartTEFStatusToString(fpayment_status), False)
    .AddPair('card_brand', fcard_brand, False)
    .AddPair('installments', finstallments, False)
    .AddPair('nsu_host', fnsu_host, False)
    .AddPair('nsu_sitef', fnsu_sitef, False)
    .AddPair('acquirer', facquirer, False)
    .AddPair('serial_pos', fserial_pos, False)
    .AddPair('user_id', fuser_id, False)
    .AddPair('has_details', fhas_details)
    .AddPair('type', ftype, False)
    .AddPair('charge_id', fcharge_id, False)
    .AddPair('refund_autorization_code', frefund_autorization_code, False)
    .AddPair('refund_serial_pos', frefund_serial_pos, False)
    .AddPair('refund_user_id', frefund_user_id, False)
    .AddPair('refund_coupon', frefund_coupon, False)
    .AddPair('fee_type', SmartTEFFeeTypeToString(ffee_type), False)
    .AddPair('file', ffile, False)
    .AddPair('print_id', fprint_id, False);

  if NaoEstaZerado(fcreate_at) then
    aJson.AddPair('create_at', DateTimeToIso8601(fcreate_at));

  if NaoEstaZerado(fupdate_at) then
    aJson.AddPair('update_at', DateTimeToIso8601(fupdate_at));

  if NaoEstaZerado(fpayment_date) then
    aJson.AddPair('payment_date', DateTimeToIso8601(fpayment_date));

  if Assigned(fextras) then
    fextras.WriteToJson(aJson);

  if Assigned(freason) then
    freason.WriteToJson(aJson);

  if Assigned(fcoupon) then
    fcoupon.WriteToJson(aJson);
end;

function TACBrSmartTEFCardClass.GetExtras: TACBrSmartTEFOrderExtras;
begin
  if not Assigned(fextras) then
    fextras := TACBrSmartTEFOrderExtras.Create('extras');
  Result := fextras;
end;

function TACBrSmartTEFCardClass.GetReason: TACBrSmartTEFReason;
begin
  if not Assigned(freason) then
    freason := TACBrSmartTEFReason.Create('reason');
  Result := freason;
end;

function TACBrSmartTEFCardClass.Getcoupon: TACBrSmartTEFCoupon;
begin
  if not Assigned(fcoupon) then
    fcoupon := TACBrSmartTEFCoupon.Create('coupon');
  Result := fcoupon;
end;

function TACBrSmartTEFCardClass.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fpayment_identifier) and
    EstaVazio(fcnpj) and
    EstaZerado(fcreate_at) and
    EstaZerado(fupdate_at) and
    EstaZerado(fvalue) and
    EstaZerado(fpayment_value) and
    EstaZerado(fpayment_date) and
    EstaVazio(fautorization_code) and
    (forder_type = sotNone) and
    (fpayment_type = stpNone) and
    (fpayment_status = stsNone) and
    EstaVazio(fcard_brand) and
    EstaZerado(finstallments) and
    EstaVazio(fnsu_host) and
    EstaVazio(fnsu_sitef) and
    EstaVazio(facquirer) and
    EstaVazio(fserial_pos) and
    EstaZerado(fuser_id) and
    (not Assigned(fextras) or fextras.IsEmpty) and
    not fhas_details and
    EstaVazio(ftype) and
    EstaVazio(fcharge_id) and
    (not Assigned(freason) or freason.IsEmpty) and
    EstaVazio(frefund_autorization_code) and
    EstaVazio(frefund_serial_pos) and
    EstaZerado(frefund_user_id) and
    (not Assigned(fcoupon) or fcoupon.IsEmpty) and
    EstaVazio(frefund_coupon) and
    (ffee_type = sftNone);
end;

{ TACBrSmartTEFCardDetailsList }

function TACBrSmartTEFCardDetailsList.GetItem(Index: Integer): TACBrSmartTEFCardDetails;
begin
  Result := TACBrSmartTEFCardDetails(inherited Items[Index]);
end;

procedure TACBrSmartTEFCardDetailsList.SetItem(Index: Integer; AValue: TACBrSmartTEFCardDetails);
begin
  inherited Items[Index] := aValue;
end;

function TACBrSmartTEFCardDetailsList.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrSmartTEFCardDetailsList.Add(aItem: TACBrSmartTEFCardDetails): Integer;
begin
  Result := inherited Add(aItem);
end;

procedure TACBrSmartTEFCardDetailsList.Insert(Index: Integer; aItem: TACBrSmartTEFCardDetails);
begin
  inherited Insert(Index, aItem);
end;

function TACBrSmartTEFCardDetailsList.New: TACBrSmartTEFCardDetails;
begin
  Result := TACBrSmartTEFCardDetails.Create;
  Self.Add(Result);
end;

{ TACBrSmartTEFPrintFile }

procedure TACBrSmartTEFPrintFile.Assign(Source: TACBrSmartTEFPrintFile);
begin
  if not Assigned(Source) then
    Exit;

  fname := Source.name;
  fdata := Source.data;
end;

procedure TACBrSmartTEFPrintFile.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrSmartTEFPrintFile) then
    Assign(TACBrSmartTEFPrintFile(aSource));
end;

procedure TACBrSmartTEFPrintFile.Clear;
begin
  fname := EmptyStr;
  fdata := EmptyStr;
end;

procedure TACBrSmartTEFPrintFile.DoReadFromJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .Value('name', fname)
    .Value('data', fdata);
end;

procedure TACBrSmartTEFPrintFile.DoWriteToJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .AddPair('name', fname)
    .AddPair('data', fdata);
end;

function TACBrSmartTEFPrintFile.IsEmpty: Boolean;
begin
  Result := EstaVazio(fname) and EstaVazio(fdata);
end;

{ TACBrSmartTEFPrintCreateRequest }

procedure TACBrSmartTEFPrintCreateRequest.Assign(Source: TACBrSmartTEFPrintCreateRequest);
begin
  if not Assigned(Source) then
    Exit;

  forder_type := Source.order_type;
  fprint_id := Source.print_id;
  file_.Assign(Source.file_);
end;

procedure TACBrSmartTEFPrintCreateRequest.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrSmartTEFPrintCreateRequest) then
    Assign(TACBrSmartTEFPrintCreateRequest(aSource));
end;

procedure TACBrSmartTEFPrintCreateRequest.Clear;
begin
  forder_type := sotNone;
  fprint_id := EmptyStr;
  fserial_pos := EmptyStr;
  fuser_id := 0;
  if Assigned(ffile) then
    ffile.Clear;
end;

destructor TACBrSmartTEFPrintCreateRequest.Destroy;
begin
  if Assigned(ffile) then
    ffile.Free;
  inherited;
end;

procedure TACBrSmartTEFPrintCreateRequest.DoReadFromJson(aJson: TACBrJSONObject);
var
  sOrderType: String;
begin
  if not Assigned(aJson) then
    Exit;

  {$IfDef FPC}
    sOrderType := EmptyStr;
  {$EndIf}

  aJson
    .Value('order_type', sOrderType)
    .Value('serial_pos', fserial_pos)
    .Value('user_id', fuser_id)
    .Value('print_id', fprint_id);

  if NaoEstaVazio(sOrderType) then
    forder_type := StringToSmartTEFOrderType(sOrderType);

  file_.ReadFromJson(aJson);
end;

procedure TACBrSmartTEFPrintCreateRequest.DoWriteToJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .AddPair('order_type', SmartTEFOrderTypeToString(forder_type))
    .AddPair('serial_pos', fserial_pos, False)
    .AddPair('user_id', fuser_id, False)
    .AddPair('print_id', fprint_id, False);

  if Assigned(ffile) then
    ffile.WriteToJson(aJson);
end;

function TACBrSmartTEFPrintCreateRequest.GetFile: TACBrSmartTEFPrintFile;
begin
  if not Assigned(ffile) then
    ffile := TACBrSmartTEFPrintFile.Create('file');
  Result := ffile;
end;

function TACBrSmartTEFPrintCreateRequest.IsEmpty: Boolean;
begin
  Result :=
    (forder_type = sotNone) and
    EstaVazio(fserial_pos) and
    EstaZerado(fuser_id) and
    EstaVazio(fprint_id) and
    ((not Assigned(ffile)) or ffile.IsEmpty);
end;

{ TACBrSmartTEFStoreActiveRequest }

procedure TACBrSmartTEFStoreActiveRequest.Assign(
  Source: TACBrSmartTEFStoreActiveRequest);
begin
  if not Assigned(Source) then
    Exit;

  fcnpj := Source.cnpj;
  fcnpj_integrador := Source.cnpj_integrador;
  femail := Source.email;
  fpassword := Source.password;
  fname := Source.name;
  fstore_name := Source.store_name;
end;

procedure TACBrSmartTEFStoreActiveRequest.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrSmartTEFStoreActiveRequest) then
    Assign(TACBrSmartTEFStoreActiveRequest(aSource));
end;

procedure TACBrSmartTEFStoreActiveRequest.Clear;
begin
  fcnpj := EmptyStr;
  fcnpj_integrador := EmptyStr;
  femail := EmptyStr;
  fpassword := EmptyStr;
  fname := EmptyStr;
  fstore_name := EmptyStr;
end;

procedure TACBrSmartTEFStoreActiveRequest.DoReadFromJson(
  aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .Value('cnpj', fcnpj)
    .Value('cnpj_integrador', fcnpj_integrador)
    .Value('email', femail)
    .Value('password', fpassword)
    .Value('name', fname)
    .Value('store_name', fstore_name);
end;

procedure TACBrSmartTEFStoreActiveRequest.DoWriteToJson(
  aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .AddPair('cnpj', fcnpj)
    .AddPair('cnpj_integrador', fcnpj_integrador)
    .AddPair('email', femail)
    .AddPair('password', fpassword)
    .AddPair('name', fname)
    .AddPair('store_name', fstore_name);
end;

function TACBrSmartTEFStoreActiveRequest.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fcnpj) and
    EstaVazio(fcnpj_integrador) and
    EstaVazio(femail) and
    EstaVazio(fpassword) and
    EstaVazio(fname) and
    EstaVazio(fstore_name);
end;

{ TACBrSmartTEFErrorData }

procedure TACBrSmartTEFErrorData.Assign(Source: TACBrSmartTEFErrorData);
begin
  if not Assigned(Source) then
    Exit;

  fmessage := Source.message;
  ftimestamp := Source.timestamp;
  fpath := Source.path;
end;

procedure TACBrSmartTEFErrorData.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrSmartTEFErrorData) then
    Assign(TACBrSmartTEFErrorData(aSource));
end;

procedure TACBrSmartTEFErrorData.Clear;
begin
  fmessage := EmptyStr;
  ftimestamp := 0;
  fpath := EmptyStr;
end;

procedure TACBrSmartTEFErrorData.DoReadFromJson(aJson: TACBrJSONObject);
var
  sTimestamp: String;
begin
  if not Assigned(aJson) then
    Exit;

  {$IfDef FPC}
    sTimestamp := EmptyStr;
  {$EndIf}

  aJson
    .Value('message', fmessage)
    .Value('timestamp', sTimestamp)
    .Value('path', fpath);

  if NaoEstaVazio(sTimestamp) then
    ftimestamp := Iso8601ToDateTime(sTimestamp);
end;

procedure TACBrSmartTEFErrorData.DoWriteToJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson
    .AddPair('message', fmessage)
    .AddPair('path', fpath);
  if NaoEstaZerado(ftimestamp) then
    aJson.AddPair('timestamp', DateTimeToIso8601(ftimestamp));
end;

function TACBrSmartTEFErrorData.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fmessage) and
    EstaZerado(ftimestamp) and
    EstaVazio(fpath);
end;

{ TACBrSmartTEFError }

procedure TACBrSmartTEFError.Assign(Source: TACBrSmartTEFError);
begin
  if not Assigned(Source) then
    Exit;

  fstatus := Source.status;
  data.Assign(Source.data);
end;

procedure TACBrSmartTEFError.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrSmartTEFError) then
    Assign(TACBrSmartTEFError(aSource));
end;

procedure TACBrSmartTEFError.Clear;
begin
  fstatus := 0;
  if Assigned(fdata) then
    fdata.Clear;
end;

destructor TACBrSmartTEFError.Destroy;
begin
  if Assigned(fdata) then
    fdata.Free;
  inherited;
end;

procedure TACBrSmartTEFError.DoReadFromJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson.Value('status', fstatus);

  data.ReadFromJson(aJson);
end;

procedure TACBrSmartTEFError.DoWriteToJson(aJson: TACBrJSONObject);
begin
  if not Assigned(aJson) then
    Exit;

  aJson.AddPair('status', fstatus);

  if Assigned(fdata) then
    fdata.WriteToJson(aJson);
end;

function TACBrSmartTEFError.GetData: TACBrSmartTEFErrorData;
begin
  if not Assigned(fdata) then
    fdata := TACBrSmartTEFErrorData.Create('data');
  Result := fdata;
end;

function TACBrSmartTEFError.IsEmpty: Boolean;
begin
  Result := EstaZerado(fstatus) and (not Assigned(fdata) or fdata.IsEmpty);
end;

end. 
