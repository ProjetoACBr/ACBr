{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
{                                                                              }
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

{$I ACBr.inc}

unit pcaANe;

interface

uses
  SysUtils,
{$IFNDEF VER130}
  Variants,
{$ENDIF}
  Classes;

type

  TANe = class(TObject)
  private
    /////// ATM
    Fusuario: String;
    Fsenha: String;
    Fcodatm: String;

    /////// ELT
    FNomeArq: String;
    FCNPJ: String;

    /////// ATM e ELT
    FxmlDFe: String;

    Faplicacao: String;
    Fassunto: String;
    Fremetentes: String;
    Fdestinatarios: String;
    Fcorpo: String;
    Fchave: String;
    Fchaveresp: String;

  public
    /////// ATM
    property usuario: String  read Fusuario  write Fusuario;
    property senha: String    read Fsenha    write Fsenha;
    property codatm: String   read Fcodatm   write Fcodatm;

    /////// ELT
    property NomeArq: String  read FNomeArq write FNomeArq;
    property CNPJ: String     read FCNPJ    write FCNPJ;

    /////// ATM e ELT
    // A propriedade abaixo � utilizada pelos servi�os: AverbaNFe, AverbaCTe e DeclaraMDFe
    property xmlDFe: String   read FxmlDFe   write FxmlDFe;

    // As propriedades abaixo s�o utilizadas para o servi�o AddBackMail
    property aplicacao: String     read Faplicacao     write Faplicacao;
    property assunto: String       read Fassunto       write Fassunto;
    property remetentes: String    read Fremetentes    write Fremetentes;
    property destinatarios: String read Fdestinatarios write Fdestinatarios;
    property corpo: String         read Fcorpo         write Fcorpo;
    property chave: String         read Fchave         write Fchave;
    property chaveresp: String     read Fchaveresp     write Fchaveresp;
  end;

implementation

end.

