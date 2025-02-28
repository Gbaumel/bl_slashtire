# Sistema de Corte de Pneus para FiveM

Este é um script Lua para FiveM que permite aos jogadores cortar pneus de veículos usando uma arma específica (como uma faca). O script utiliza o framework `QBCore` e a biblioteca `ox_target` para interações.

## Recursos

- **Corte de pneus**: Os jogadores podem cortar pneus de veículos.
- **Armas permitidas**: Configuração de quais armas podem ser usadas para cortar pneus.
- **Notificações**: Mensagens personalizadas para informar o jogador sobre o sucesso ou falha da ação.
- **Sincronização**: O estado dos pneus é sincronizado entre todos os jogadores.

## Pré-requisitos

- [QBCore Framework](https://github.com/qbcore-framework)
- [ox_target](https://github.com/overextended/ox_target)
- [ox_lib](https://github.com/overextended/ox_lib) (opcional, para notificações personalizadas)

## Instalação

1. **Baixe o projeto**:
   - Clone este repositório ou faça o download do arquivo `.zip`.
   - Extraia o arquivo na pasta `resources` do seu servidor FiveM.

2. **Renomeie a pasta**:
   - Renomeie a pasta para `bl_tireslash` (ou o nome que preferir).

3. **Adicione ao `server.cfg`**:
   - Adicione a seguinte linha ao seu arquivo `server.cfg`:
     ```plaintext
     ensure bl_tireslash
     ```

4. **Configure o script**:
   - Edite o arquivo `config.lua` para ajustar as armas permitidas, mensagens e outras configurações.

5. **Reinicie o servidor**:
   - Reinicie o servidor para carregar o script.

## Configuração

O arquivo `config.lua` contém todas as configurações necessárias. Aqui estão as principais opções:

- **Armas permitidas**:
  ```lua
  Config.allowedWeapons = {
      `weapon_knife`,       -- Faca
      `weapon_knuckle`      -- Soco inglês
  }
