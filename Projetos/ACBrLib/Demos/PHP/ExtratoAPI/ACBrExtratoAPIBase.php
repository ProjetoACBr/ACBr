<!--
// {******************************************************************************}
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
// { ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
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
-->

<!DOCTYPE html>

<head>
    <meta charset="UTF-8">
    <meta name="ACBrExtratoAPI" content="width=device-width, initial-scale=1.0">
    <title>
        <?php
        $title = 'ACBrExtratoAPI';
        if (isset($_GET['modo']))
            $titleModo = $_GET['modo'];
        else
            $titleModo = 'MT';

        if ($titleModo == 'MT') {
            $title .= ' - MultiThread';
        } else {
            $title .= ' - SingleThread';
        }

        echo $title;
        ?>
    </title>
    <style>
        body {
            display: flex;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            height: 100vh;
        }

        .container {
            display: flex;
            margin: 20px;
        }

        .cfgPanelEsquerda,
        .cfgPanelDireita {
            width: 50%;
            padding: 10px;
            box-sizing: border-box;
        }

        .cfgPanelEsquerda {
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .cfgPanelEsquerda .tabsPanel {
            flex-grow: 1;
            overflow-y: auto;
        }

        .cfgPanelEsquerda .buttons {
            text-align: center;
            margin-top: 10px;
            margin-bottom: 10px;
        }

        .cfgPanelEsquerda .buttons button {
            padding: 10px 20px;
            margin: 0 5px;
        }

        .cfgPanelDireita {
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .cfgPanelDireita .tabsPanel {
            flex: 1;
            border: 1px solid #ccc;
            border-radius: 4px;
            height: 50%;
        }

        .tabAbas {
            display: flex;
        }

        .tabAbas button {
            flex: 1;
            padding: 10px;
            border: 1px solid #ccc;
            background: #f1f1f1;
            cursor: pointer;
        }

        .tabAbas button.selecionado {
            background: #ddd;
        }

        .panelAba {
            border-top: none;
            padding: 10px;
            display: none;
            height: calc(100% - 40px);
            overflow-y: auto;
        }

        .panelAba.selecionado {
            display: block;
        }

        .form-group {
            margin-bottom: 10px;
        }

        .form-group label {
            display: block;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 5px;
            box-sizing: border-box;
        }

        .response-memo {
            height: 50%;
            margin-top: 10px;
            width: 100%;
            box-sizing: border-box;
        }

        .button-container {
            display: none;
        }

        .button-container.selecionado {
            display: block;
        }

        .panelEsquerda-container {
            display: none;
        }

        .panelEsquerda-container.selecionado {
            display: block;
        }

        .panelConfiguracoes-container {
            display: none;
        }

        .panelConfiguracoes-container.selecionado {
            display: block;
        }

        .grid1Col {
            display: grid;
            grid-template-columns: repeat(1, 1fr);
            gap: 10px;
            row-gap: 1px;
        }

        .grid2Col {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
            row-gap: 1px;
        }

        .grid3Col {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            row-gap: 1px;
        }

        .grid4Col {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
            row-gap: 1px;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>

    <div class="cfgPanelEsquerda">
        <div class="tabsPanel">
            <div class="grid4Col">
                <div class="tabAbas">
                    <button class="selecionado" onclick="ativaAba(event, 'configuracoes', 'panelEsquerda')">Configurações</button>
                    <button onclick="ativaAba(event, 'bancos', 'panelEsquerda')">Bancos</button>
                </div>
            </div>
            <div id="configuracoes" class="panelAba selecionado panelEsquerda-container">
                <div class="tabsPanel">
                    <div class="tabAbas">
                        <button class="selecionado" onclick="ativaAba(event, 'geral', 'panelConfiguracoes')">Geral</button>
                    </div>
                    <div id="geral" class="panelAba selecionado panelConfiguracoes-container">
                        <div class="grid2Col">
                            <label>Ambiente</label>
                            <div>
                                <input type="radio" id="producao" name="ambiente" value="0" checked>
                                <label for="producao">Produção</label>
                                <input type="radio" id="homologacao" name="ambiente" value="1">
                                <label for="homologacao">Homologação</label>
                            </div>
                        </div>
                        <br>
                        <div class="grid3Col">
                            <div class="form-group">
                                <label for="BancoConsulta">Banco Consulta</label>
                                <select id="BancoConsulta">
                                    <option value="0" selected>bccNenhum</option>
                                    <option value="1">bccBancoDoBrasil</option>
                                    <option value="2">bccInter</option>
                                    <option value="3">bccSicoob</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Proxy</label>
                            <div>
                                <label for="proxyServidor">Servidor</label>
                                <input type="text" id="proxyServidor">
                            </div>
                            <div>
                                <label for="proxyPorta">Porta</label>
                                <input type="number" id="proxyPorta" value="5000">
                            </div>
                            <div>
                                <label for="proxyUsuario">Usuário</label>
                                <input type="text" id="proxyUsuario">
                            </div>
                            <div>
                                <label for="proxySenha">Senha</label>
                                <input type="password" id="proxySenha">
                            </div>
                        </div>
                        <div class="grid2Col">
                            <div class="form-group">
                                <label for="LogNivel">Log Nível LIB</label>
                                <select id="LogNivel">
                                    <option value="0">logNenhum</option>
                                    <option value="1">logSimples</option>
                                    <option value="2" selected>logNormal</option>
                                    <option value="3">logCompleto</option>
                                    <option value="4">logParanoico</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="LogPath">Path Log LIB</label>
                                <input type="text" id="LogPath">
                            </div>
                        </div>
                        <div class="grid2Col">
                            <div class="form-group">
                                <label for="NivelLog">Log Nível API</label>
                                <select id="NivelLog">
                                    <option value="0">Nenhum</option>
                                    <option value="1">Baixo</option>
                                    <option value="2" selected>Normal</option>
                                    <option value="3">Alto</option>
                                    <option value="4">Muito Alto</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="ArqLog">Arquivo de Log API</label>
                                <input type="text" id="ArqLog">
                            </div>
                        </div>
                        <div class="grid3Col">
                            <input type="button" id="OpenSSLInfo" value="OpenSSLInfo">
                        </div>
                    </div>
                </div>
            </div>
            <div id="bancos" class="panelAba panelEsquerda-container">
                <div class="tabsPanel">
                    <div class="tabAbas">
                        <button class="selecionado" onclick="ativaAba(event, 'BB', 'panelBancos')">BB</button>
                        <button onclick="ativaAba(event, 'INTER', 'panelBancos')">Inter</button>
                        <button onclick="ativaAba(event, 'SICOOB', 'panelBancos')">Sicoob</button>
                    </div>
                    <div id="BB" class="panelAba selecionado panelBancos-container">
                        <div class="grid2Col">
                            <div class="form-group">
                                <label for="DeveloperApplicationKeyBB">Developer Application Key</label>
                                <input type="text" id="DeveloperApplicationKeyBB">
                            </div>
                            <div class="form-group">
                                <label for="xMCITesteBB">x-br-com-bb-ipa-miteste (Homologação)</label>
                                <input type="text" id="xMCITesteBB">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="ClientIDBB">Client ID</label>
                            <input type="text" id="ClientIDBB">
                        </div>
                        <div class="form-group">
                            <label for="ClientSecretBB">Client Secret</label>
                            <input type="text" id="ClientSecretBB">
                        </div>
                        <div class="form-group">
                            <label for="ArquivoChavePrivadaBB">Arquivo Chave Privada</label>
                            <input type="text" id="ArquivoChavePrivadaBB">
                        </div>
                        <div class="form-group">
                            <label for="ArquivoCertificadoBB">Arquivo Certificado PEM</label>
                            <input type="text" id="ArquivoCertificadoBB">
                        </div>
                    </div>
                    <div id="INTER" class="panelAba panelBancos-container">
                        <div class="form-group">
                            <label for="ClientIDInter">Client ID</label>
                            <input type="text" id="ClientIDInter">
                        </div>
                        <div class="form-group">
                            <label for="ClientSecretInter">Client Secret</label>
                            <input type="text" id="ClientSecretInter">
                        </div>
                        <div class="form-group">
                            <label for="ArquivoChavePrivadaInter">Arquivo Chave Privada</label>
                            <input type="text" id="ArquivoChavePrivadaInter">
                        </div>
                        <div class="form-group">
                            <label for="ArquivoCertificadoInter">Arquivo Certificado PEM</label>
                            <input type="text" id="ArquivoCertificadoInter">
                        </div>
                    </div>
                    <div id="SICOOB" class="panelAba panelBancos-container">
                        <div class="form-group">
                            <label for="ClientIDSicoob">Client ID</label>
                            <input type="text" id="ClientIDSicoob">
                        </div>
                        <div class="form-group">
                            <label for="ArquivoChavePrivadaSicoob">Arquivo Chave Privada</label>
                            <input type="text" id="ArquivoChavePrivadaSicoob">
                        </div>
                        <div class="form-group">
                            <label for="ArquivoCertificadoSicoob">Arquivo Certificado PEM</label>
                            <input type="text" id="ArquivoCertificadoSicoob">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="buttons">
            <input type="button" id="carregarConfiguracoes" value="Carregar Configurações">
            <input type="button" id="salvarConfiguracoes" value="Salvar Configurações">
        </div>
    </div>
    <div class="cfgPanelDireita">
        <div class="tabsPanel">
            <div class="grid3Col">
                <div class="tabAbas">
                    <button class="selecionado" onclick="ativaAba(event, 'consultas', 'panelDireita')">Consultas</button>
                </div>
            </div>
            <div id="consultas" class="panelAba selecionado button-container">
                <div class="grid3Col">
                    <input type="button" id="ConsultarExtrato" value="Consultar ExtratoAPI">
                </div>
            </div>
        </div>
        <div class="grid1Col">
            <label for="result">Respostas</label>
            <textarea id="result" rows="25" readonly></textarea>
        </div>
    </div>

    <?php
    $modo = isset($_GET['modo']) ? $_GET['modo'] : null;
    ?>

    <script>
        function ativaAba(event, abaId, panel) {
            const listaAbas = document.querySelectorAll(`#${panel} .panelAba`);
            listaAbas.forEach(abaItem => {
                abaItem.classList.remove('selecionado');
            });

            document.getElementById(abaId).classList.add('selecionado');

            const outrasAbas = event.target.parentElement.children;
            for (let item of outrasAbas) {
                item.classList.remove('selecionado');
            }

            event.target.classList.add('selecionado');

            // Controle panel Direita
            if (panel === 'panelDireita') {
                const abaSelecionada = document.querySelector(`#${abaId}.button-container`);
                const outrasAbas = document.querySelectorAll('.button-container');
                outrasAbas.forEach(container => container.classList.remove('selecionado'));

                if (abaSelecionada) {
                    abaSelecionada.classList.add('selecionado');
                }
            }

            // Controle panel Esquerda
            if (panel === 'panelEsquerda') {
                const abaSelecionada = document.querySelector(`#${abaId}.panelEsquerda-container`);
                const outrasAbas = document.querySelectorAll('.panelEsquerda-container');
                outrasAbas.forEach(container => container.classList.remove('selecionado'));

                if (abaSelecionada) {
                    abaSelecionada.classList.add('selecionado');
                }
            }

            // Controle panel Configurações
            if (panel === 'panelConfiguracoes') {
                const abaSelecionada = document.querySelector(`#${abaId}.panelConfiguracoes-container`);
                const outrasAbas = document.querySelectorAll('.panelConfiguracoes-container');
                outrasAbas.forEach(container => container.classList.remove('selecionado'));

                if (abaSelecionada) {
                    abaSelecionada.classList.add('selecionado');
                }
            }

            // Controle panel Bancos
            if (panel === 'panelBancos') {
                const abaSelecionada = document.querySelector(`#${abaId}.panelBancos-container`);
                const outrasAbas = document.querySelectorAll('.panelBancos-container');
                outrasAbas.forEach(container => container.classList.remove('selecionado'));

                if (abaSelecionada) {
                    abaSelecionada.classList.add('selecionado');
                }
            }
        }

        // Inicializa biblioteca
        chamaAjaxEnviar({
            metodo: "carregarConfiguracoes"
        });

        // Chamada do botão para carregar configurações
        $('#carregarConfiguracoes').on('click', function() {
            chamaAjaxEnviar({
                metodo: "carregarConfiguracoes"
            });
        });

        // Chamada do botão para salvar configurações
        $('#salvarConfiguracoes').on('click', function() {
            const infoData = {
                LogPath: $('#LogPath').val(),
                LogNivel: $('#LogNivel').val(),

                metodo: "salvarConfiguracoes",
                BancoConsulta: $('#BancoConsulta').val(),
                ambiente: parseInt($('input[name="ambiente"]:checked').val(), 10),
                ArqLog: $('#ArqLog').val(),
                NivelLog: $('#NivelLog').val(),

                proxyServidor: $('#proxyServidor').val(),
                proxyPorta: $('#proxyPorta').val(),
                proxyUsuario: $('#proxyUsuario').val(),
                proxySenha: $('#proxySenha').val(),

                DeveloperApplicationKeyBB: $('#DeveloperApplicationKeyBB').val(),
                xMCITesteBB: $('#xMCITesteBB').val(),
                ClientIDBB: $('#ClientIDBB').val(),
                ClientSecretBB: $('#ClientSecretBB').val(),
                ArquivoChavePrivadaBB: $('#ArquivoChavePrivadaBB').val(),
                ArquivoCertificadoBB: $('#ArquivoCertificadoBB').val(),

                ClientIDInter: $('#ClientIDInter').val(),
                ClientSecretInter: $('#ClientSecretInter').val(),
                ArquivoChavePrivadaInter: $('#ArquivoChavePrivadaInter').val(),
                ArquivoCertificadoInter: $('#ArquivoCertificadoInter').val(),

                ClientIDSicoob: $('#ClientIDSicoob').val(),
                ArquivoChavePrivadaSicoob: $('#ArquivoChavePrivadaSicoob').val(),
                ArquivoCertificadoSicoob: $('#ArquivoCertificadoSicoob').val()
            };

            chamaAjaxEnviar(infoData);
        });

        $('#OpenSSLInfo').on('click', function() {
            chamaAjaxEnviar({
                metodo: "OpenSSLInfo"
            });
        });

        $('#ConsultarExtrato').on('click', function() {
            inputBox("Digite a Agência:", function(AAgencia) {
                inputBox("Digite a Conta:", function(AConta) {
                    inputBox("Informe a Data Inicial (dd/mm/aaaa):", function(ADataInicio) {
                        inputBox("Informe a Data Final (dd/mm/aaaa):", function(ADataFim) {
                            inputBox("Digite o Número da Página:", function(APagina) {
                                inputBox("Digite o Número de Registros por Página:", function(ARegistrosPorPag) {
                                    chamaAjaxEnviar({
                                        metodo: "ConsultarExtrato",
                                        AAgencia: AAgencia,
                                        AConta: AConta,
                                        ADataInicio: ADataInicio,
                                        ADataFim: ADataFim,
                                        APagina: APagina,
                                        ARegistrosPorPag: ARegistrosPorPag
                                    });
                                });
                            });
                        });
                    });
                });
            });
        });

        function chamaAjaxEnviar(infoData) {
            // Fazer a chamada passando o modo ST ou MT. 
            // Ex: http://localhost/ExtratoAPI/ACBrExtratoAPIBase.php?modo=MT
            // Ex: http://localhost/ExtratoAPI/ACBrExtratoAPIBase.php?modo=ST
            var modo = "<?php echo $modo; ?>";
            if (modo == "")
                modo = "MT";

            $.ajax({
                url: modo + '/ACBrExtratoAPIServicos' + modo + '.php',
                type: 'POST',
                data: infoData,
                success: function(response) {
                    if ((infoData.metodo === "carregarConfiguracoes") ||
                        (infoData.metodo === "Inicializar")) {
                        processaRetornoConfiguracoes(response);
                    } else {
                        processaResponseGeral(response);
                    }
                },
                error: function(error) {
                    processaResponseGeral(error);
                }
            });
        }

        function inputBox(mensagem, callback, obrigatorio = true) {
            var ACodigoUF = prompt(mensagem);
            if ((obrigatorio) && (ACodigoUF === null || ACodigoUF === "")) {
                alert("Nenhuma informação foi inserida.");
                return;
            }
            callback(ACodigoUF);
        }

        function selecionarArquivo(extensao, retorno) {
            var arquivoSelecionado = document.createElement("input");
            arquivoSelecionado.type = "file";
            arquivoSelecionado.accept = extensao;

            arquivoSelecionado.onchange = function(event) {
                var file = event.target.files[0];

                if (!file) {
                    return;
                }

                var reader = new FileReader();
                reader.onload = function(e) {
                    retorno(e.target.result);
                };
                reader.readAsText(file);
            };

            arquivoSelecionado.click();
        }

        function processaResponseGeral(retorno) {
            if (retorno.mensagem)
                $('#result').val(retorno.mensagem)
            else
                $('#result').val('Erro: ' + JSON.stringify(retorno, null, 4));
        }

        function processaRetornoConfiguracoes(response) {
            if (response.dados) {
                $('#result').val(JSON.stringify(response, null, 4));

                $('#LogPath').val(response.dados.LogPath);
                $('#LogNivel').val(response.dados.LogNivel);

                $('#BancoConsulta').val(response.dados.BancoConsulta);
                $('input[name="ambiente"][value="' + response.dados.ambiente + '"]').prop('checked', true);
                $('#ArqLog').val(response.dados.ArqLog);
                $('#NivelLog').val(response.dados.NivelLog);

                $('#proxyServidor').val(response.dados.proxyServidor);
                $('#proxyPorta').val(response.dados.proxyPorta);
                $('#proxyUsuario').val(response.dados.proxyUsuario);
                $('#proxySenha').val(response.dados.proxySenha);

                $('#DeveloperApplicationKeyBB').val(response.dados.DeveloperApplicationKeyBB);
                $('#xMCITesteBB').val(response.dados.xMCITesteBB);
                $('#ClientIDBB').val(response.dados.ClientIDBB);
                $('#ClientSecretBB').val(response.dados.ClientSecretBB);
                $('#ArquivoChavePrivadaBB').val(response.dados.ArquivoChavePrivadaBB);
                $('#ArquivoCertificadoBB').val(response.dados.ArquivoCertificadoBB);

                $('#ClientIDInter').val(response.dados.ClientIDInter);
                $('#ClientSecretInter').val(response.dados.ClientSecretInter);
                $('#ArquivoChavePrivadaInter').val(response.dados.ArquivoChavePrivadaInter);
                $('#ArquivoCertificadoInter').val(response.dados.ArquivoCertificadoInter);

                $('#ClientIDSicoob').val(response.dados.ClientIDSicoob);
                $('#ArquivoChavePrivadaSicoob').val(response.dados.ArquivoChavePrivadaSicoob);
                $('#ArquivoCertificadoSicoob').val(response.dados.ArquivoCertificadoSicoob);

            } else {
                processaResponseGeral(response);
            }
        }
    </script>
</body>

</html>