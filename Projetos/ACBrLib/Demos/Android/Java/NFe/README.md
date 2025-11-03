# 🧪 Programa Exemplo ACBrLibNFe Android (Java)

Este projeto demonstra a integração de um aplicativo Android nativo com a biblioteca **ACBrLibNFe**. Desenvolvida a partir do componente **ACBrNFe** do **Projeto ACBr**, esta biblioteca possibilita a emissão de **Nota Fiscal Eletrônica (NFe)** e **Nota Fiscal Eletrônica do Consumidor (NFCe)**, além de gerenciar todos os eventos relacionados a esses Documentos Fiscais Eletrônicos (DF-e). O programa exemplo serve como um guia prático para desenvolvedores que desejam implementar a funcionalidade de emissão fiscal em suas aplicações Android nativas utilizando Java.

## 🎯 Visão Geral do Projeto Exemplo

Este **Programa Exemplo** foi desenvolvido exclusivamente para fins de **demonstração e estudo**. Ele serve como uma base de referência para desenvolvedores entenderem a integração com a ACBrLibNFe no ambiente Android nativo.

⚠️ **Importante:** O código presente neste projeto **NÃO DEVE** ser utilizado diretamente em aplicações reais ou ambientes de produção sem uma revisão completa, refatoração e implementação de práticas de segurança e tratamento de erros adequadas ao seu caso de uso específico.

No demo, você encontrará:

- A **estrutura essencial** de um projeto Android para integração com ACBrLibNFe usando Java.
- Implementação com **Material Design 3** e navegação moderna com Navigation Component.
- Uma interface organizada com **ViewPager2** e **BottomNavigationView** para facilitar o acesso às funcionalidades.
- **Configurações completas da biblioteca**, incluindo certificados digitais, WebServices e parâmetros gerais.
- Sistema **simplificado de permissões** compatível com Android 13+ usando Storage Access Framework (SAF).
- Exemplos práticos de todos os **comandos NFe**: envio, consultas, eventos, inutilização e distribuição DFe.

## 🚀 Instalação e Execução

Para colocar o programa exemplo em funcionamento, siga os passos abaixo:

1. **Obtenha os Arquivos Necessários da ACBrLibNFe:**

    - Acesse a seção de downloads do fórum oficial do Projeto ACBr:\
      [https://www.projetoacbr.com.br/forum/files/](https://www.projetoacbr.com.br/forum/files/)
    - Selecione **ACBrLibNFe** e, na seção de downloads, escolha a opção para **Android**.
    - Após o download, descompacte o arquivo.
    - Dentro da pasta descompactada, você encontrará as subpastas ``Android`` (contendo o ``.aar``) e ``dep`` (com a pasta ``Schemas``).

2. **Configuração da ACBrLibNFe no Projeto Android:**

    - **Arquivo ``.aar``:** Pegue o arquivo ``ACBrLibNFe-release.aar`` (localizado em ``Android`` na pasta que você descompactou) e copie-o para a pasta ``app/libs`` do demo. Se a pasta ``libs`` não existir dentro de ``app``, crie-a.
    - **Pasta ``Schemas``:**
        - Copie a pasta ``Schemas`` (encontrada dentro da pasta ``dep`` que você descompactou) diretamente para ``app/src/main/assets/`` do projeto.
        - Alternativamente, você pode compactar a pasta ``Schemas`` em um arquivo ZIP com o nome ``schemas.zip`` e colocá-lo em ``app/src/main/res/assets``.

3. **Configuração do Certificado Digital:**

    - Após o aplicativo demo ser iniciado e estar rodando, navegue até a seção de **Configurações** e, em seguida, para a aba de **Certificados**.
    - Nesta tela, você pode usar o botão de seleção para importar um arquivo de **certificado ``.pfx`` válido** usando o seletor de arquivos do Android (SAF).
    - Este certificado é essencial para que a ACBrLibNFe consiga operar todas as suas funcionalidades de emissão fiscal.

4. **Compilação e Execução:**

    - Abra o projeto no **Android Studio**.
    - Sincronize o projeto com os arquivos Gradle.
    - Execute o aplicativo em um dispositivo Android ou emulador.

Após concluir estas configurações (arquivo ``.aar``, pasta ``Schemas``, e importação do certificado ``.pfx``), você estará pronto para explorar e utilizar todas as funcionalidades do programa exemplo!

## 📂 Estrutura do Projeto

A organização do código foi pensada para clareza e manutenção, seguindo as melhores práticas do desenvolvimento Android:

### ``app/src/main/java/com/acbr/nfe/acbrlibnfe/demo/``

Este é o diretório principal do código-fonte Java:

- **``MainActivity.java``**: Activity principal que gerencia a navegação entre fragments usando Navigation Component e BottomNavigationView. Implementa Material Design 3 e inicializa a ACBrLibNFe.

- **``comandos/``**: Contém todos os fragments relacionados aos comandos NFe:
  - ``ComandosNFeFragment.java``: Fragment principal com ViewPager2 para navegação entre as abas de comandos
  - ``ComandosEnvioNFeFragment.java``: Comandos de envio de NFe
  - ``ComandosConsultaNFeFragment.java``: Consultas de NFe e status do serviço
  - ``ComandosEventoNFeFragment.java``: Eventos de NFe (cancelamento, CCe, etc.)
  - ``ComandosInutilizacaoNFeFragment.java``: Inutilização de numeração
  - ``ComandosDistribuicaoNFeFragment.java``: Distribuição DFe

- **``configuracoes/``**: Fragments das configurações da biblioteca:
  - ``ConfiguracoesNFeFragment.java``: Fragment principal com ViewPager2 para navegação entre configurações
  - ``ConfiguracoesCertificadosFragment.java``: Configuração de certificados digitais com SAF
  - ``ConfiguracoesGeralFragment.java``: Configurações gerais da NFe
  - ``ConfiguracoesWebServicesFragment.java``: Configurações de WebServices
  - E outros fragments de configuração...

- **``utils/``**: Classes utilitárias:
  - ``NfeApplication.java``: Application class com padrão Singleton para ACBrLibNFe
  - ``ACBrLibHelper.java``: Classe helper para operações com a biblioteca
  - ``ViewPagerAdapter.java``: Adapter tradicional para ViewPager2

### ``app/src/main/res/``

Recursos da aplicação organizados por tipo:

- **``layout/``**: Layouts XML com Material Design 3:
  - ``activity_main.xml``: Layout principal com Navigation Component
  - ``fragment_comandos_*.xml``: Layouts dos fragments de comandos com TextInputLayout
  - ``fragment_configuracoes_*.xml``: Layouts das configurações
  
- **``menu/``**: Menus de navegação:
  - ``main_menu.xml``: Menu do BottomNavigationView
  
- **``navigation/``**: Grafos de navegação:
  - ``nav_graph.xml``: Definição das rotas entre fragments
  
- **``values/``**: Recursos de valores (cores, strings, estilos, etc.)

### Características Técnicas

- **Material Design 3**: Interface moderna com componentes atualizados
- **Navigation Component**: Navegação padrão do Android com type-safe arguments
- **ViewPager2**: Navegação por abas otimizada
- **Storage Access Framework (SAF)**: Seleção de arquivos compatível com Android 13+
- **Arquitetura Simples**: Organização clara com Activities e Fragments
- **JavaDoc Completo**: Documentação detalhada em todas as classes

Todo o código deste projeto exemplo está **bem documentado** por meio de JavaDoc e comentários detalhados, facilitando a compreensão. Caso surjam dúvidas, sinta-se à vontade para criar um tópico no [fórum oficial do Projeto ACBr](https://www.projetoacbr.com.br/forum/) ou entrar em contato através do [Discord](https://www.projetoacbr.com.br/discord).

## ✨ Funcionalidades Implementadas

- ✅ **Interface Material Design 3** completa e responsiva
- ✅ **Navegação moderna** com Navigation Component e BottomNavigationView  
- ✅ **Todos os comandos NFe**: Envio, Consultas, Eventos, Inutilização, Distribuição DFe
- ✅ **Configurações completas**: Certificados, WebServices, Geral, Arquivos, Email, etc.
- ✅ **Seleção de arquivos moderna** com Storage Access Framework (Android 13+)
- ✅ **ViewPager2 otimizado** para navegação entre abas
- ✅ **Permissões simplificadas** compatíveis com versões recentes do Android
- ✅ **JavaDoc completo** em todas as classes e métodos
- ✅ **Arquitetura limpa** seguindo padrões Android modernos

## 🗺️ Futuro (Roadmap)
- [ ] **Implementação de testes unitários** e de interface
- [ ] **Modo escuro** completo para toda a aplicação
- [ ] **Validação de campos** com feedback visual aprimorado
- [ ] **Cache inteligente** para configurações e certificados
- [ ] **Logs detalhados** com interface de visualização

## 📝 Resumo e Considerações Finais

Este projeto é um programa exemplo crucial para entender a integração Android nativo com a **ACBrLibNFe**. Lembre-se:

- **Não é para Produção:** O código é uma base de estudo e não deve ser usado em produção sem revisão completa.
- **Configuração Essencial:** Certifique-se de configurar corretamente o arquivo ``.aar``, a pasta ``Schemas`` e, principalmente, **importar um certificado** ``.pfx`` no app para ativar as funcionalidades da lib.
- **Integração Nativa:** A integração com a ACBrLibNFe é feita diretamente através das classes Java/JNI da biblioteca.
- **Material Design:** O projeto segue as diretrizes mais recentes do Material Design 3 para Android.
- **Compatibilidade:** Funciona com Android 7.0+ (API level 24) e otimizado para Android 13+.
- **Documentação:** O projeto está completamente documentado com JavaDoc para facilitar a compreensão.
---
**Suporte:** Se tiver qualquer dúvida, sinta-se à vontade para abrir um tópico no [fórum oficial do Projeto ACBr](https://www.projetoacbr.com.br/forum/) ou entrar em contato através do [Discord](https://www.projetoacbr.com.br/discord).
