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

unit ACBrTEFSmartTEFInterface;

interface

uses
  Classes, SysUtils, ACBrTEFSmartTEFSchemas;

type

  { IACBrSmartTEFOrderResponse }

  IACBrSmartTEFOrderResponse = interface
  ['{E083777E-9687-49FA-916E-728ABCBA83B1}']
    procedure LoadJson(aJson: String);
    function payment_identifier: String;
    function payment_status: TACBrSmartTEFStatus;
    function order_type: TACBrSmartTEFOrderType;
    function charge_id: String;
    function ToJson: String;
  end;

  { IACBrSmartTEFPrintResponse }

  IACBrSmartTEFPrintResponse = interface
  ['{E77B5667-E215-4D4E-9B75-19AB6CC0716E}']
    procedure LoadJson(aJson: String);
    function print_identifier: String;
    function print_status: TACBrSmartTEFStatus;
    function order_type: TACBrSmartTEFOrderType;
    function print_id: String;
    function file_: String;
    function ToJson: String;
  end;

  { IACBrSmartTEFPrintDetailsResponse }

  IACBrSmartTEFPrintDetailsResponse = interface
  ['{D9CF0721-55E6-42AB-B2A3-3F81F8263F8F}']
    procedure LoadJson(aJson: String);
    function print_identifier: String;
    function cnpj: String;
    function create_at: TDateTime;
    function update_at: TDateTime;
    function file_: String;
    function order_type: TACBrSmartTEFOrderType;
    function print_status: TACBrSmartTEFStatus;
    function serial_pos: String;
    function user_id: Integer;
    function type_: String;
    function has_details: Boolean;
    function print_id: String;
    function ToJson: String;
  end;

  { IACBrSmartTEFCardDetailsListResponse }

  IACBrSmartTEFCardDetailsListResponse = interface
  ['{6B2BD772-C9B3-4BD5-AE59-931E8A0C206A}']
    procedure LoadJson(aJson: String);
    function ToJson: String;
    function cards: TACBrSmartTEFCardDetailsList;
  end;

  { IACBrSmartTEFTerminalListResponse }

  IACBrSmartTEFTerminalListResponse = interface
  ['{17E26647-70DE-418E-A2BB-CDF03820DA19}']
    procedure LoadJson(aJson: String);
    function ToJson: String;
    function terminais: TACBrSmartTEFTerminalList;
  end;

  { IACBrSmartTEFUserListResponse }

  IACBrSmartTEFUserListResponse = interface
  ['{8799B4E5-9536-4D34-954A-AB340B59CAF1}']
    procedure LoadJson(aJson: String);
    function ToJson: String;
    function users: TACBrSmartTEFUserList;
  end; 

  { IACBrSmartTEFUserCreateResponse }

  IACBrSmartTEFUserCreateResponse = interface
  ['{1A4CCC09-9051-43A0-94FF-F5B77A7B192D}']
    procedure LoadJson(aJson: String);
    function ToJson: String;
    function email: String; 
    function pos_password: String;
  end; 

  { IACBrSmartTEFStoreResponse }

  IACBrSmartTEFStoreResponse = interface
  ['{47704C08-3DE2-4493-BD00-BDC2E5F3FD1F}']
    procedure LoadJson(aJson: String);
    function ToJson: String;
    function store_id: Integer;
    function cnpj: String;
    function cnpj_integrador: String;
    function webhook: TACBrSmartTEFWebhook;
    function active: Boolean;
    function create_at: TDateTime;
    function update_at: TDateTime;
    function token: String;
    function name: String;
    function trademark: String;
    function contact_tel: String;
    function city_id: Integer;
    function state_id: Integer;
    function zip_code: String;
    function disctrict: String;
    function address: String;
    function integrator_id: Integer;
  end;

  { IACBrSmartTEFStoreSettingsListResponse }

  IACBrSmartTEFStoreSettingsListResponse = interface
  ['{F4CA7D8F-4DAA-4579-A693-3309ADD87A43}']
    procedure LoadJson(aJson: String);
    function ToJson: String;
    function storeSettings: TACBrSmartTEFStoreSettingsList;
  end; 

  { IACBrSmartTEFPoolingResponse }

  IACBrSmartTEFPoolingResponse = interface
  ['{91269002-5BF3-424C-9ED0-3B41121528D3}']
    procedure LoadJson(aJson: String);
    function ToJson: String;
    function poolingList: TACBrSmartTEFPoolingList;
  end;

implementation

end. 
