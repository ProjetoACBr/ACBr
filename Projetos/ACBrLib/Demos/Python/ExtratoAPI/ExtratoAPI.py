from class_acbrlib import ACBrLibExtrato
import os

LPATH_APP = os.path.dirname(os.path.abspath(__file__))

extrato = ACBrLibExtrato()
extrato.inicializar()

#Caminho dos logs
LArquivoLogLib  = os.path.join(LPATH_APP, '')
LArquivoLogWS   = os.path.join(LPATH_APP, 'LogsWebService.txt')

#Configurando ACBrLib.ini
extrato.config_gravar_valor("Principal", "TipoResposta", "2")
extrato.config_gravar_valor("Principal", "LogNivel", "1")
extrato.config_gravar_valor("Principal", "LogPath", LArquivoLogLib)

extrato.config_gravar_valor("ExtratoAPI", "Ambiente", "1")
extrato.config_gravar_valor("ExtratoAPI", "ArqLog", LArquivoLogWS)
extrato.config_gravar_valor("ExtratoAPI", "NivelLog", "4")
extrato.config_gravar_valor("ExtratoAPI", "BancoConsulta", "1")

#Variaveis das Credenciais do Banco
LApp_Key="7010211ad241f0f0af1a3e4c3e47a14e"
LClient_Id="eyJpZCI6ImRmZDc2MzM2LWZiN2UtNDZkMS05MjM1LTlmNzQ1YzE4ZmZhZSIsImNvZGlnb1B1YmxpY2Fkb3IiOjAsImNvZGlnb1NvZnR3YXJlIjoxMDcwMDAsInNlcXVlbmNpYWxJbnN0YWxhY2FvIjoxfQ"
LClient_Secret="eyJpZCI6Ijk1MjQ4NWEtN2U5MC00MWExLTkyZWMtOGViMTIxYTI5ODNmNWZjYjUiLCJjb2RpZ29QdWJsaWNhZG9yIjowLCJjb2RpZ29Tb2Z0d2FyZSI6MTA3MDAwLCJzZXF1ZW5jaWFsSW5zdGFsYWNhbyI6MSwic2VxdWVuY2lhbENyZWRlbmNpYWwiOjIsImFtYmllbnRlIjoiaG9tb2xvZ2FjYW8iLCJpYXQiOjE3NjMxMjExNzMwMDh9"
LxMCITeste="178961031"
                
extrato.config_gravar_valor("ExtratoAPIBB", "ClientID",LClient_Id)
extrato.config_gravar_valor("ExtratoAPIBB", "ClientSecret", LClient_Secret)
extrato.config_gravar_valor("ExtratoAPIBB", "DeveloperApplicationKey", LApp_Key)
extrato.config_gravar_valor("ExtratoAPIBB", "xMCITeste", LxMCITeste)

CodigoRetorno, Mensagem = extrato.config_gravar()
print(f"Retorno Configravar valor, Codigo:", CodigoRetorno)
print(f"Retorno Configravar valor, Mensagem:", Mensagem)

print('Versao Lib :',extrato.versao())
ret, resultado = extrato.ConsultarExtrato("1505","1348","19/11/2025","19/11/2025",1,200 )
print(f'Código Retorno = {ret}, Resultado da consulta do Extrato:','\n',resultado)

extrato.finalizar()


