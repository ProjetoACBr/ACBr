<!--
// {******************************************************************************}
// { Projeto: Componentes ACBr                                                    }
// {  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
// { mentos de Automa��o Comercial utilizados no Brasil                           }
// {                                                                              }
// { Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
// {                                                                              }
// { Colaboradores nesse arquivo: Renato Rubinho                                  }
// {                                                                              }
// {  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
// { Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
// {                                                                              }
// {  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
// { sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
// { Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
// { qualquer vers�o posterior.                                                   }
// {                                                                              }
// {  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
// { NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
// { ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
// { do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
// {                                                                              }
// {  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
// { com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
// { no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
// { Voc� tamb�m pode obter uma copia da licen�a em:                              }
// { http://www.opensource.org/licenses/lgpl-license.php                          }
// {                                                                              }
// { Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
// {       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
// {******************************************************************************}
-->

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>ACBrConsultaCNPJ</title>
    <style>
        .tituloColunas {
            display: flex;
            align-items: center;
        }
        .tituloColunas img {
            width: 5%;
            height: auto;
            margin-right: 20px;
        }
        .retornoCampos {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
            row-gap: 1px;
        }
        .retornoCamposColuna {
            display: flex;
            flex-direction: column;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <div class="tituloColunas">
        <img src="https://svn.code.sf.net/p/acbr/code/trunk2/Exemplos/ACBrTEFD/Android/ACBr_96_96.png" alt="ACBr Logo">
        <h1>ACBrConsultaCNPJ - SingleThread</h1>
    </div>
    <form id="formConsulta">
        <label for="cnpj"><?php echo mb_convert_encoding("Digite o CNPJ:", "UTF-8", "ISO-8859-1"); ?></label>
        <input type="text" id="cnpj" name="cnpj">
        <br><br>
        <label for="prov"><?php echo mb_convert_encoding("Selecione o Provedor:", "UTF-8", "ISO-8859-1"); ?></label>
        <select id="prov" name="prov">
            <option value="0">cwsNenhum</option>
            <option value="1">cwsBrasilAPI</option>
            <option value="2">cwsReceitaWS</option>
            <option value="3">cwsCNPJWS</option>
        </select>
        <label for="usuario"><?php echo mb_convert_encoding("Usu�rio:", "UTF-8", "ISO-8859-1"); ?></label>
        <input type="text" id="usuario" name="usuario">
        <label for="senha"><?php echo mb_convert_encoding("Senha:", "UTF-8", "ISO-8859-1"); ?></label>
        <input type="password" id="senha" name="senha">
        <br><br>
        <input type="button" id="consultaCNPJ" value="Consultar">
        <input type="button" id="salvarConfiguracoes" value="<?php echo mb_convert_encoding('Salvar Configura��es', 'UTF-8', 'ISO-8859-1'); ?>">
        <input type="button" id="carregarConfiguracoes" value="<?php echo mb_convert_encoding('Carregar Configura��es', 'UTF-8', 'ISO-8859-1'); ?>">
    </form>

    <h2>Detalhes da Empresa</h2>
    <div class="retornoCampos">
      <div class="retornoCamposColuna">
        <label for="abertura">Abertura</label>
        <input type="text" id="abertura" name="abertura"><br>
      </div>
      <div class="retornoCamposColuna">
        <label for="bairro">Bairro</label>
        <input type="text" id="bairro" name="bairro"><br>
      </div>
      <div class="retornoCamposColuna">
        <label for="cep">CEP</label>
        <input type="text" id="cep" name="cep"><br>
      </div>
      <div class="retornoCamposColuna">
        <label for="cnae1">CNAE1</label>
        <input type="text" id="cnae1" name="cnae1"><br>
      </div>
      <div class="retornoCamposColuna">
        <label for="cnae2">CNAE2</label>
        <input type="text" id="cnae2" name="cnae2"><br>
      </div>
      <div class="retornoCamposColuna">
        <label for="cidade">Cidade</label>
        <input type="text" id="cidade" name="cidade"><br>
      </div>
      <div class="retornoCamposColuna">
        <label for="complemento">Complemento</label>
        <input type="text" id="complemento" name="complemento"><br>
      </div>
      <div class="retornoCamposColuna">
        <label for="empresaTipo">Empresa Tipo</label>
        <input type="text" id="empresaTipo" name="empresaTipo"><br>
      </div>
      <div class="retornoCamposColuna">
        <label for="endereco"><?php echo mb_convert_encoding("Endere�o", "UTF-8", "ISO-8859-1"); ?></label>
        <input type="text" id="endereco" name="endereco"><br>
      </div>
      <div class="retornoCamposColuna">
        <label for="fantasia">Fantasia</label>
        <input type="text" id="fantasia" name="fantasia"><br>
      </div>
      <div class="retornoCamposColuna">
        <label for="inscricaoEstadual"><?php echo mb_convert_encoding("Inscri��o Estadual", "UTF-8", "ISO-8859-1"); ?></label>
        <input type="text" id="inscricaoEstadual" name="inscricaoEstadual"><br>
      </div>
      <div class="retornoCamposColuna">
        <label for="naturezaJuridica"><?php echo mb_convert_encoding("Natureza Jur�dica", "UTF-8", "ISO-8859-1"); ?></label>
        <input type="text" id="naturezaJuridica" name="naturezaJuridica"><br>
      </div>
      <div class="retornoCamposColuna">
        <label for="numero"><?php echo mb_convert_encoding("N�mero", "UTF-8", "ISO-8859-1"); ?></label>
        <input type="text" id="numero" name="numero"><br>
      </div>
      <div class="retornoCamposColuna">
        <label for="razaoSocial"><?php echo mb_convert_encoding("Raz�o Social", "UTF-8", "ISO-8859-1"); ?></label>
        <input type="text" id="razaoSocial" name="razaoSocial"><br>
      </div>
      <div class="retornoCamposColuna">
        <label for="situacao"><?php echo mb_convert_encoding("Situa��o", "UTF-8", "ISO-8859-1"); ?></label>
        <input type="text" id="situacao" name="situacao"><br>
      </div>
      <div class="retornoCamposColuna">
        <label for="uf">UF</label>
        <input type="text" id="uf" name="uf"><br>
      </div>
    </div>

    <label for="result"><?php echo mb_convert_encoding("Retorno:", "UTF-8", "ISO-8859-1"); ?></label>
    <br>
    <textarea id="result" rows="10" cols="100" readonly></textarea>
    <br><br>

    <script>
        $(document).ready(function(){
            $('#consultaCNPJ').on('click', function() {
                $.ajax({
                    url: 'ST/consultaCnpj.php',
                    type: 'POST',
                    data: {
                        cnpj: $('#cnpj').val(),
                        prov: $('#prov').val()
                    },
                    success: function(response) {
                        if(response.dados) {
                            $('#result').val(JSON.stringify(response, null, 4));
                            $('#abertura').val(response.dados.abertura);
                            $('#bairro').val(response.dados.bairro);
                            $('#cep').val(response.dados.cep);
                            $('#cnae1').val(response.dados.CNAE1 || '');
                            $('#cnae2').val(response.dados.CNAE2 || '');
                            $('#cidade').val(response.dados.Cidade || '');
                            $('#complemento').val(response.dados.Complemento || '');
                            $('#empresaTipo').val(response.dados.EmpresaTipo || '');
                            $('#endereco').val(response.dados.Endereco || '');
                            $('#fantasia').val(response.dados.Fantasia || '');
                            $('#inscricaoEstadual').val(response.dados.InscricaoEstadual || '');
                            $('#naturezaJuridica').val(response.dados.NaturezaJuridica || '');
                            $('#numero').val(response.dados.Numero || '');
                            $('#razaoSocial').val(response.dados.RazaoSocial || '');
                            $('#situacao').val(response.dados.Situacao || '');
                            $('#uf').val(response.dados.UF || '');
                        } else {
                            if(response.mensagem)
                                $('#result').val(response.mensagem)
                            else
                                $('#result').val('Erro: ' + JSON.stringify(response, null, 4));
                        }
                    },
                    error: function(error) {
                        if(error.mensagem)
                            $('#result').val(error.mensagem)
                        else
                            $('#result').val('Erro: ' + JSON.stringify(error, null, 4));
                    }
                });
            });

            $.ajax({
                url: 'ST/carregarConfiguracoes.php',
                type: 'POST',
                success: function(response) {
                    if (response.dados) {
                        $('#result').val(JSON.stringify(response, null, 4));
                        $('#usuario').val(response.dados.usuario);
                        $('#senha').val(response.dados.senha);
                        $('#prov').val(response.dados.provedor);
                    } else {
                        if (response.mensagem)
                            $('#result').val(response.mensagem)
                        else
                            $('#result').val('Erro: ' + JSON.stringify(response, null, 4));
                    }
                },
                error: function(error) {
                    if (error.mensagem)
                        $('#result').val(error.mensagem)
                    else
                        $('#result').val('Erro: ' + JSON.stringify(error, null, 4));
                }
            });

            $('#carregarConfiguracoes').on('click', function() {
                $.ajax({
                    url: 'ST/carregarConfiguracoes.php',
                    type: 'POST',
                    success: function(response) {
                        if(response.dados) {
                            $('#result').val(JSON.stringify(response, null, 4));
                            $('#usuario').val(response.dados.usuario);
                            $('#senha').val(response.dados.senha);
                            $('#prov').val(response.dados.provedor);
                        } else {
                            if(response.mensagem)
                                $('#result').val(response.mensagem)
                            else
                                $('#result').val('Erro: ' + JSON.stringify(response, null, 4));
                        }
                    },
                    error: function(error) {
                        if(error.mensagem)
                            $('#result').val(error.mensagem)
                        else
                            $('#result').val('Erro: ' + JSON.stringify(error, null, 4));
                    }
                });
            });

            $('#salvarConfiguracoes').on('click', function() {
                $.ajax({
                    url: 'ST/salvarConfiguracoes.php',
                    type: 'POST',
                    data: {
                        prov: $('#prov').val(),
                        usuario: $('#usuario').val(),
                        senha: $('#senha').val()
                    },
                    success: function(response) {
                        if(response.mensagem)
                            $('#result').val(response.mensagem)
                        else
                            $('#result').val('Erro: ' + JSON.stringify(response, null, 4));
                    },
                    error: function(error) {
                        if(error.mensagem)
                            $('#result').val(error.mensagem)
                        else
                            $('#result').val('Erro: ' + JSON.stringify(error, null, 4));
                    }
                });
            });
        });
    </script>
</body>
</html>
