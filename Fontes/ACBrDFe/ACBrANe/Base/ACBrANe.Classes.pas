{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
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

unit ACBrANe.Classes;

interface

uses
  SysUtils, Classes,
  {$IFNDEF VER130}
    Variants,
  {$ENDIF}
  {$IF DEFINED(NEXTGEN)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IFEND}
  ACBrBase,
  ACBrUtil.DateTime,
  ACBrUtil.Strings,
  ACBrANe.Conversao;

type

  TANe = class(TObject)
  private
    /////// ATM
    Fusuario: string;
    Fsenha: string;
    Fcodatm: string;

    /////// ELT
    FNomeArq: string;
    FCNPJ: string;

    /////// ATM e ELT
    FxmlDFe: string;

    Faplicacao: string;
    Fassunto: string;
    Fremetentes: string;
    Fdestinatarios: string;
    Fcorpo: string;
    Fchave: string;
    Fchaveresp: string;

  public
    /////// ATM
    property usuario: string  read Fusuario  write Fusuario;
    property senha: string    read Fsenha    write Fsenha;
    property codatm: string   read Fcodatm   write Fcodatm;

    /////// ELT
    property NomeArq: string  read FNomeArq write FNomeArq;
    property CNPJ: string     read FCNPJ    write FCNPJ;

    /////// ATM e ELT
    // A propriedade abaixo � utilizada pelos servi�os: AverbaNFe, AverbaCTe e DeclaraMDFe
    property xmlDFe: string   read FxmlDFe   write FxmlDFe;

    // As propriedades abaixo s�o utilizadas para o servi�o AddBackMail
    property aplicacao: string     read Faplicacao     write Faplicacao;
    property assunto: string       read Fassunto       write Fassunto;
    property remetentes: string    read Fremetentes    write Fremetentes;
    property destinatarios: string read Fdestinatarios write Fdestinatarios;
    property corpo: string         read Fcorpo         write Fcorpo;
    property chave: string         read Fchave         write Fchave;
    property chaveresp: string     read Fchaveresp     write Fchaveresp;
  end;

implementation

end.
