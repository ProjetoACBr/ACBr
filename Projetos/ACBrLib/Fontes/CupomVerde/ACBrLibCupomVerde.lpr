{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Antonio Carlos Junior                           }
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

{$I ACBr.inc}

library ACBrLibCupomVerde;

uses
  {$IFDEF MT}
   {$IFDEF UNIX}
    cthreads,
    cmem, // the c memory manager is on some systems much faster for multi-threading
   {$ENDIF}
  {$ENDIF}
  Interfaces, Forms, SysUtils, Classes,
  {$IFDEF MT} ACBrLibCupomVerdeMT {$ELSE} ACBrLibCupomVerdeST {$ENDIF},
  ACBrLibCupomVerdeDataModule, ACBrLibCupomVerdeConfig, ACBrLibCupomVerdeBase,
  ACBrLibConfig, ACBrLibResposta, ACBrLibComum, ACBrLibConsts,
  ACBrLibDataModule, ACBrLibCupomVerdeConsts, ACBrLibCupomVerdeRespostas;

{$R *.res}

{$IFDEF DEBUG}
var
   HeapTraceFile: String;
{$ENDIF}

exports
  //Importadas ACBrLibComum
  CupomVerde_Inicializar,
  CupomVerde_Finalizar,
  CupomVerde_Nome,
  CupomVerde_Versao,
  CupomVerde_OpenSSLInfo,
  CupomVerde_UltimoRetorno,
  CupomVerde_ConfigImportar,
  CupomVerde_ConfigExportar,
  CupomVerde_ConfigLer,
  CupomVerde_ConfigGravar,
  CupomVerde_ConfigLerValor,
  CupomVerde_ConfigGravarValor;

begin
  {$IFDEF DEBUG}
   HeapTraceFile := ExtractFilePath(ParamStr(0))+ 'heaptrclog.trc';
   DeleteFile( HeapTraceFile );
   SetHeapTraceOutput( HeapTraceFile );
  {$ENDIF}

  MainThreadID := GetCurrentThreadId();
  Application.Initialize;
end.

