/* {******************************************************************************}
// { Projeto: Componentes ACBr                                                    }
// {  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
// { mentos de Automação Comercial utilizados no Brasil                           }
// {                                                                              }
// { Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
// {                                                                              }
// { Colaboradores nesse arquivo: Renato Rubinho                                  }
// {                                                                              }
// {  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
// { Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
// {                                                                              }
// {  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
// { sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
// { Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
// { qualquer versão posterior.                                                   }
// {                                                                              }
// {  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
// { NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
// { ADEQUAÇÃO A UMA FINALIDADE ESPECÝFICA. Consulte a Licença Pública Geral Menor}
// { do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
// {                                                                              }
// {  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
// { com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
// { no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
// { Você também pode obter uma copia da licença em:                              }
// { http://www.opensource.org/licenses/lgpl-license.php                          }
// {                                                                              }
// { Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
// {       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
// {******************************************************************************}
*/

int NCM_Inicializar(const uintptr_t* libHandle, const char* eArqConfig, const char* eChaveCrypt);
int NCM_Finalizar (const uintptr_t libHandle);
int NCM_Nome(const uintptr_t libHandle, const char* sNome, long* esTamanho);
int NCM_Versao(const uintptr_t libHandle, const char* sVersao, long* esTamanho);
int NCM_OpenSSLInfo(const uintptr_t libHandle, const char* sOpenSSLInfo, long* esTamanho);
int NCM_UltimoRetorno(const uintptr_t libHandle, const char* sMensagem, long* esTamanho);
int NCM_ConfigImportar(const uintptr_t libHandle, const char* eArqConfig);
int NCM_ConfigExportar(const uintptr_t libHandle, const char* sMensagem, long* esTamanho);
int NCM_ConfigLer(const uintptr_t libHandle, const char* eArqConfig);
int NCM_ConfigGravar(const uintptr_t libHandle, const char* eArqConfig);
int NCM_ConfigLerValor(const uintptr_t libHandle, const char* eSessao, const char* eChave, const char* sValor, long* esTamanho);
int NCM_ConfigGravarValor(const uintptr_t libHandle, const char* eSessao, const char* eChave, const char* eValor);
int NCM_DescricaoNCM(const uintptr_t libHandle, const char* cNCM, const char* sResposta, long* esTamanho); 
int NCM_Validar(const uintptr_t libHandle, const char* cNCM, const char* sResposta, long* esTamanho); 
int NCM_BaixarLista(const uintptr_t libHandle, const char* cNomeArquivo, const char* sResposta, long* esTamanho); 
int NCM_ObterNCMs(const uintptr_t libHandle, const char* sResposta, long* esTamanho); 
int NCM_BuscarPorCodigo(const uintptr_t libHandle, const char* cNCM, const char* sResposta, long* esTamanho); 
int NCM_BuscarPorDescricao(const uintptr_t libHandle, const char* cDesc, long nTipo, const char* sResposta, long* esTamanho); 
