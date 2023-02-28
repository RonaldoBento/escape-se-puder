# escape-se-puder
 Game_Point_and_Click

# Point-Click
 
## Memórias - Escape Se Puder

 <br><img src="logo-bento-projeto.png" alt="logo bento-projeto no formato png"><br>

 ## Ficha Técnica

<ul>
    <li><strong>Criador:</strong> Ronaldo Rodrigues Bento</li>
    <li><strong>Gênero:</strong> Escape; Mistério, Point and Click e Puzzle</li>
    <li><strong>Engine:</strong> RPG Maker VX Ace</li>
    <li><strong>Design e Characters & Scenario: </strong>Okami Amaterasu & Ronaldo R. Bento</li>
    <li><strong>Roteiro original:</strong> Bento </li>
    <li><strong>Idioma:</strong> Português Brasileiro</li>
    <li><strong>Faixa Etária:</strong> Maiores de 13 anos</li>
    <li><storng>Precisa de RTP?</strong> Não</li>
    <li><strong>Roteiro, Game Design, Level Design:</strong> Ronaldo R. Bento</li>
    <li><strong>Lançamento do projeto:</strong> 10/01/2023</li>
    <li><strong>Tamanho:</strong> 35MB</li>
    <li><strong>DGD - Documento de Game_Design:</strong>Anexo</li>
    <li><strong>Duração do jogo:</strong> depende do jogador</li>
</ul>

***

<br><img src="layout-3.png" alt="logo do jogo no formato png"><br>

# História:

 **Mysterious Room Escape** Memórias – Escape Se Puder: é um jogo que remete aos gráficos de 8-bits (MonoChrome) de curta duração desenvolvido para o evento denominado TocaJam 2023 Slasher Movies, seu principal objetivo é escapar da sala na qual se encontra interagindo com o ambiente e resolvendo vários enigmas e quebra-cabeças. E pelo bem de sua sanidade metal, você também quer saber o MOTIVO de estar lá. O jogo possui dois finais distintos dependendo das pistas obtidas durante suas investigações com os ambientes do jogo.

# Screenshoot do Game

<br><img src="tela.png" alt="tela do jogo no formato png"><br>

<br><img src="tela1.png" alt="tela do jogo no formato png"><br>

<br><img src="tela2.png" alt="tela do jogo no formato png"><br>

<br><p>O RPG Maker permite que os usuários criem seus próprios jogos de RPG e com algumas mudanças no sistema pode criar até outros tipos de jogos. Utiliza a linguagem de Programacão:
RGSS (Ruby Game Scripting System) uses the object-oriented scripting language Ruby to develop 2D games for the Windows® platform.</p>



## Exemplos de Scripts:

```Ruby
#         Lune Ultimate Anti-Lag
# Autor: Raizen
# Compativel com: RMVXAce
# Comunidade: www.centrorpg.com
# O script permite um pulo de frames na atualização de gráficos, 
# muito útil para jogos que tem uma programação pesada, e 
# atualização de gráficos, funcionando com um anti-lag.
# Detalhe: anti-lags são compátiveis com esse script.
#========================================================

#Para atualizar um programa constantemente, coloque um comentário
#no primeiro comando daquele evento escrito :update:

module Anti_conf
#==============================================================================
# ** Configurações
#------------------------------------------------------------------------------
#  Configure o que for necessário para um maior desempenho.
#==============================================================================
# Escolha como o Frame_Skip irá agir.
# <=====Qualidade============================Desempenho=====>
# 1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20
# Padrão = 10
Fr = 10

# Configure a taxa de FPS (padrão = 60)
Fps = 60
# Configure a taxa minina de FPS (padrão = 25)
Mini = 25

# Quantidade de frames que o analizador de FPS irá levar, 
# Quanto menor o número mais rápido o script funcionará, porém
# será menos preciso.
Time = 300

end
=begin




Funções desse Anti-Lag

* Bug comum de posição de evento corrigido
* Frame Skip inteligente
* atualiza apenas o que é necessário
* ajuda inclusive outros scripts visuais a reduzir o lag
* Ele muda o seu comportamento de acordo com as necessidades de cada jogador
* Aumenta a prioridade do RPG Maker diante de outros programas
=end

#=================================================================#
#====================  Alias methods =============================#
# command_203          => Game_Interpreter
# start                => Scene_Map
# update               => Scene_Map
# perform_transfer     => Scene_Map
#=================================================================#
#====================  Rewrite methods ===========================#
# update_events        => Game_Map
# update_one_event     => Spriteset_Map
#=================================================================#
#========================  New methods ===========================#
# need_to_update?      => Game_Event
# near_the_screen?     => Sprite_Character
# call_position_event  => Scene_Map
# skip_calculate       => Scene_Map
# update_one_event     => Spriteset_Map
#=================================================================#
#=================================================================#

#==============================================================================
#============================  Início do Script!  =============================
#==============================================================================
#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de mapa.
#==============================================================================

class Scene_Map < Scene_Base
alias lune_skip_start start
alias lune_skip_update update
alias lune_perform perform_transfer
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    Graphics.frame_rate = Anti_conf::Fps
    @update_skip = false
    @count_up = 0
    lune_skip_start
  end
  #--------------------------------------------------------------------------
  # * Execução da transferência
  #--------------------------------------------------------------------------
  def perform_transfer
    $get_new_ids = Array.new
    Graphics.frame_rate = Anti_conf::Fps
    lune_perform
    @count_up = 0
    @update_skip = false
  end
  #--------------------------------------------------------------------------
  # * Atualização da tela
  #--------------------------------------------------------------------------
  def update
    @update_skip ? lune_skip_update : skip_calculate
  end
  #--------------------------------------------------------------------------
  # * Atualização de um personagem especifico
  #--------------------------------------------------------------------------
  def call_position_event(id)
    @spriteset.update_one_event(id)
  end
  #--------------------------------------------------------------------------
  # * Calcula o tempo necessário para rodar o update do Scene_Map
  #--------------------------------------------------------------------------  
  def skip_calculate
    @count_up += 1
    return unless @count_up >= Anti_conf::Time
    auto_skip = Time.now
    lune_skip_update
    old_skip = Time.now
    get_skip = old_skip - auto_skip
    Graphics.frame_rate -= (get_skip * Graphics.frame_rate * 2 * Anti_conf::Fr - 1).to_i
    Graphics.frame_rate = [Graphics.frame_rate, Anti_conf::Mini].max
    @update_skip = true
  end
end


#==============================================================================
# ** Scene_Base
#------------------------------------------------------------------------------
#  Esta é a superclasse de todas as cenas do jogo.
#==============================================================================
class Scene_Base
alias skipper_main main
  #--------------------------------------------------------------------------
  # * Processamento principal
  #--------------------------------------------------------------------------
  def main
    @fr_cont = 0
    skipper_main
  end
  #--------------------------------------------------------------------------
  # * Execução da transição
  #--------------------------------------------------------------------------
  def perform_transition
    Graphics.transition(transition_speed * Graphics.frame_rate / 60)
  end
  #--------------------------------------------------------------------------
  # * Atualização da tela (básico)
  #--------------------------------------------------------------------------
  def update_basic
    if @fr_cont >= 60
      Graphics.update       
      @fr_cont -= 60
    end
    @fr_cont += Graphics.frame_rate
    update_all_windows
    Input.update
  end
end

#==============================================================================
# ** Aumento da prioridade do rpg maker
#------------------------------------------------------------------------------
Lune_high = Win32API.new("kernel32", "SetPriorityClass", "pi", "i")
Lune_high.call(-1, 0x90)
#==============================================================================

#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  Esta classe gerencia os eventos. Ela controla funções incluindo a mudança
# de páginas de event por condições determinadas, e processos paralelos.
# Esta classe é usada internamente pela classe Game_Map. 
#==============================================================================

class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # * necessário atualizar?
  #--------------------------------------------------------------------------
  def need_to_update?
    ax = $game_map.adjust_x(@real_x) - 8
    ay = $game_map.adjust_y(@real_y) - 6
    ax.between?(-9, 9) && ay.between?(-7, 7) || @list[0].parameters.include?(':update:')
  end
end

#==============================================================================
# ** Sprite_Character
#------------------------------------------------------------------------------
#  Este sprite é usado para mostrar personagens. Ele observa uma instância
# da classe Game_Character e automaticamente muda as condições do sprite.
#==============================================================================

class Sprite_Character < Sprite_Base
  #--------------------------------------------------------------------------
  # * Evento próximo a tela?
  #--------------------------------------------------------------------------
  def near_the_screen?
    ax = $game_map.adjust_x(@character.x) - 8
    ay = $game_map.adjust_y(@character.y) - 6
    ax.between?(-11, 11) && ay.between?(-8, 8)
  end
end
#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  Esta classe gerencia os eventos. Ela controla funções incluindo a mudança
# de páginas de event por condições determinadas, e processos paralelos.
# Esta classe é usada internamente pela classe Game_Map. 
#==============================================================================

class Game_Event < Game_Character
alias lune_ant_initialize initialize
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     event : RPG::Event
  #--------------------------------------------------------------------------
  def initialize(*args, &block)
    lune_ant_initialize(*args, &block)
    $get_new_ids.push(@event.id)
  end
end

#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  Um interpretador para executar os comandos de evento. Esta classe é usada
# internamente pelas classes Game_Map, Game_Troop e Game_Event.
#==============================================================================

class Game_Interpreter
alias lune_lag_command_203 command_203
  #--------------------------------------------------------------------------
  # Definir posição do evento
  #--------------------------------------------------------------------------
  def command_203
    lune_lag_command_203
    SceneManager.scene.call_position_event($get_new_ids.index(@event_id))
  end
end
#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  Esta classe gerencia o mapa. Inclui funções de rolagem e definição de 
# passagens. A instância desta classe é referenciada por $game_map.
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # * Atualização dos comandos dos eventos
  #--------------------------------------------------------------------------
  def update_events
    @events.each_value {|event| event.update if event.need_to_update?}
    @common_events.each {|event| event.update}
  end
end


$get_new_ids = Array.new
#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
#  Esta classe reune os sprites da tela de mapa e tilesets. Esta classe é
# usada internamente pela classe Scene_Map. 
#==============================================================================
class Spriteset_Map
  #--------------------------------------------------------------------------
  # * Atualização dos personagens
  #--------------------------------------------------------------------------
  def update_characters
    refresh_characters if @map_id != $game_map.map_id
    @character_sprites.each {|sprite| sprite.update if sprite.near_the_screen? }
  end
  #--------------------------------------------------------------------------
  # * Atualização de algum personagem remoto
  #--------------------------------------------------------------------------
  def update_one_event(id)
    @character_sprites[id].update
  end
end

```

## IMPORTANTE:

 [![NPM](https://img.shields.io/npm/l/react)](https://github.com/RonaldoBento/escape-se-puder/blob/main/LICENSE) 

Você tem todo o direito de usar esse material para seu próprio aprendizado. Espero que seja útil o conteúdo disponibilizado. Para rodar o jogo no seu computador (Windows) ou em outro dispositivo é preciso ter instalado o Programa RPG Maker VX Ace. Para jogar Game.exe apenas para Windows.




