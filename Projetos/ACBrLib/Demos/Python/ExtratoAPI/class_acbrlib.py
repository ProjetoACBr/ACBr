import os
import ctypes
from ctypes import CDLL, POINTER, byref, c_char_p, c_int, create_string_buffer, c_ulong, c_void_p, c_bool, c_double
from datetime import datetime



class ACBrLibExtrato:
    def __init__(self):
        self.PATH_APP = os.path.dirname(os.path.abspath(__file__))
        self.PATH_DLLS = os.path.join(self.PATH_APP, 'ACBrLib', 'x64')

        if os.name == 'nt':
            #user lib MT
            self.PATH_DLL = os.path.join(self.PATH_DLLS, 'ACBrExtratoAPI64.dll')
            self.acbr = CDLL(self.PATH_DLL)
        else:
            self.PATH_DLL = os.path.join(self.PATH_DLLS, 'ACBrExtratoAPI64.so')
            self.acbr = ctypes.cdll.LoadLibrary(self.PATH_DLL)

        self.handle = c_void_p(None)
        self._definir_assinaturas()

    def _definir_assinaturas(self):
        self.acbr.ExtratoAPI_Inicializar.argtypes = [POINTER(c_void_p), c_char_p, c_char_p]
        self.acbr.ExtratoAPI_Inicializar.restype = c_int

        self.acbr.ExtratoAPI_ConfigGravarValor.argtypes = [c_void_p, c_char_p, c_char_p, c_char_p, c_char_p, POINTER(c_int)]
        self.acbr.ExtratoAPI_ConfigGravarValor.restype = c_int

        self.acbr.ExtratoAPI_ConfigGravar.argtypes = [c_void_p, c_char_p]
        self.acbr.ExtratoAPI_ConfigGravar.restype = c_int

        self.acbr.ExtratoAPI_Finalizar.argtypes = [c_void_p]
        self.acbr.ExtratoAPI_Finalizar.restype = c_int
        
        self.acbr.ExtratoAPI_Versao.argtypes = [c_void_p, c_char_p, POINTER(c_int)]
        self.acbr.ExtratoAPI_Versao.restype = c_int
        
        self.acbr.ExtratoAPI_UltimoRetorno.argtypes = [c_void_p, c_char_p, POINTER(c_int)]
        self.acbr.ExtratoAPI_UltimoRetorno.restype = c_int     
        
        #                               ExtratoAPI_ConsultarExtrato(AAgencia, AConta  , ADataInicio, ADataFim, APagina, ARegistrosPorPag, sResposta, esTamanho); 
        self.acbr.ExtratoAPI_ConsultarExtrato.argtypes = [c_void_p, c_char_p, c_char_p, c_double   , c_double, c_int  , c_int           , c_char_p, POINTER(c_int)]
        self.acbr.ExtratoAPI_ConsultarExtrato.restype = c_int     
        
        self.acbr.ExtratoAPI_ConfigLerValor.argtypes = [c_void_p, c_char_p, c_char_p, c_char_p, POINTER(c_int)]
        self.acbr.ExtratoAPI_ConfigLerValor.restype = c_int     
        

    def _date_to_tdatetime(self, date_str: str) -> float:
            dt = datetime.strptime(date_str, "%d/%m/%Y")
            epoch = datetime(1899, 12, 30)
            return float((dt - epoch).days)          
         
    def inicializar(self, path_ini: str = None):       
        if not path_ini:
            path_ini = os.path.join(self.PATH_APP, 'ACBrLib.INI')
        #elif not os.path.isfile(path_ini):
        #    raise FileNotFoundError(f"Arquivo INI não encontrado: {path_ini}")
        ret = self.acbr.ExtratoAPI_Inicializar(byref(self.handle), path_ini.encode("utf-8"), b"")
        
        #ret = self.acbr.ExtratoAPI_Inicializar(byref(self.handle), MEMORYACBRLIB.encode("utf8"),)
        if ret != 0:
            print(f"Erro ao inicializar a ACBrLib: {ret}")
        else:    
            print(f"ACBrLib NFe Inicializada com sucesso com INI: {path_ini}")

        # Armazenar caminho atual do INI para usar em config_gravar
        self._path_ini_ativo = path_ini
        
    def ultimo_retorno(self, tamanho_buffer: int = 1024) -> str:
        tamanho = c_int(tamanho_buffer)
        resposta = create_string_buffer(tamanho.value)
        ret = self.acbr.ExtratoAPI_UltimoRetorno(self.handle, resposta, byref(tamanho))
        if ret != 0:
            return ret, "Erro ao executar ultimo retorno"
        else:
            return resposta.value.decode("utf-8")        

    def config_gravar_valor(self, sessao: str, chave: str, valor: str):
        tamanho = c_int(256)
        resposta = create_string_buffer(tamanho.value)        
        ret = self.acbr.ExtratoAPI_ConfigGravarValor(
            self.handle,
            sessao.encode("utf-8"),
            chave.encode("utf-8"),
            valor.encode("utf-8"),
            resposta, 
            byref(tamanho)
        )
        if ret != 0:
            return ret, "Erro ao ConfigGravarValor"
        else:    
            #return ret, (f"Configuração gravada: [{sessao}] {chave} = {valor}")
            return ret, self.ultimo_retorno(tamanho.value)

    def config_gravar(self):
        ini_final = getattr(self, '_path_ini_ativo', None)
        ret = self.acbr.ExtratoAPI_ConfigGravar(self.handle, ini_final.encode("utf-8"))
        if ret != 0:
            return ret, "Erro executando ConfigGravar"
        else:    
            return ret, "ConfigGravar OK"
      
    def finalizar(self):
        if self.handle:
            ret = self.acbr.ExtratoAPI_Finalizar(self.handle)
            if ret != 0:
                return ret,"Erro ao finalizar a ACBrLib"
            print("ACBrLib finalizada com sucesso.")
            self.handle = c_void_p(None)
        else:
            return ret, "ACBrLib já estava finalizada ou não foi inicializada."
            
    def versao(self) -> str:
        tamanho = c_int(256)
        resposta = create_string_buffer(tamanho.value)
        ret = self.acbr.ExtratoAPI_Versao(self.handle, resposta, byref(tamanho))
        if ret != 0:
            return ret, "Erro executando API_Versao"
        else:    
            return ret, self.ultimo_retorno(tamanho.value)

    
    def config_ler(self, sessao: str, chave: str,):  
        tamanho = c_int(256)
        resposta = create_string_buffer(tamanho.value)
        ret = self.acbr.ExtratoAPI_ConfigLerValor(self.handle, sessao.encode("utf-8"), chave.encode("utf-8"), resposta, byref(tamanho))
        if ret != 0:
            return ret, "Erro executando ConfigLerValor"
        else:    
            return ret, self.ultimo_retorno(tamanho.value)
    
    def ConsultarExtrato(self, AAgencia:str, AConta:str, ADataInicio:str, ADataFim:str, APagina:int = 1, ARegistrosPorPag:int = 1):
        tamanho = c_int(256)
        resposta = create_string_buffer(tamanho.value)
        
        dt_inicio = self._date_to_tdatetime(ADataInicio)
        dt_fim = self._date_to_tdatetime(ADataFim)
        
        ret = self.acbr.ExtratoAPI_ConsultarExtrato(self.handle,
                                                    AAgencia.encode("utf-8"),
                                                    AConta.encode("utf-8"),
                                                    dt_inicio,  # ← String diretamente
                                                    dt_fim,     # ← String diretamente
                                                    APagina,
                                                    ARegistrosPorPag,                                                    
                                                    resposta, byref(tamanho))
        if ret != 0:
            return ret, "Erro ao consultar extrato"
        else:    
            return ret, self.ultimo_retorno(tamanho.value)#   
        
    
