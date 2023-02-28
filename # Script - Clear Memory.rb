# Script - Clear Memory
#==============================================================================
# +++ MOG - Clear Memory (v1.0) (Memory Leak Solution) +++
#==============================================================================
# By Moghunter
# https://atelierrgss.wordpress.com/
#==============================================================================
# O script limpa a memória utilizada pelo RpgMaker, basicamente dá um reset 
# no jogo sem que o jogador perca os dados dos jogo.
# Este script é voltado para quem estiver tendo problema com sobrecarregamento
# na memória Ram.
#==============================================================================
# UTILIZAÇÃO
#==============================================================================
# Basta usar o código abaixo através do comando chamar script.
#
# $game_system.clear_memory
#
#==============================================================================
# NOTA 
#==============================================================================
# Haverá uma pequena pausa no momento que a memória é limpa, portanto  é 
# aconselhavel limpar a memória durante uma cena ou quando for teleportar
# entre um mapa e outro.
#==============================================================================


#===============================================================================
# ■ SceneManager
#===============================================================================
class << SceneManager

    #--------------------------------------------------------------------------
    # ● First Scene Class
    #--------------------------------------------------------------------------  
    def first_scene_class
        $clear_memory ? Scene_Recover_Data : $BTEST ? Scene_Battle : Scene_Title
    end  
    
  end
  
  #===============================================================================
  # ■ DataManager
  #===============================================================================
  class << DataManager
    
    #--------------------------------------------------------------------------
    # ● Save Game Temp
    #--------------------------------------------------------------------------
    def save_game_temp
        File.open("Quick_Save", "wb") do |file|
          $game_system.on_before_save
          Marshal.dump(make_save_header, file)
          Marshal.dump(make_save_contents, file)
        end
        return true
    end
    
    #--------------------------------------------------------------------------
    # ● Load Game Temp
    #--------------------------------------------------------------------------
    def load_game_temp
        File.open("Quick_Save", "rb") do |file|
          Marshal.load(file)
          extract_save_contents(Marshal.load(file))
          reload_map_if_updated
        end
        File.delete("Quick_Save") rescue nil
        return true
    end
    
  end  
  
  #===============================================================================
  # ■ Game System
  #===============================================================================
  class Game_System
    
    #--------------------------------------------------------------------------
    # ● Clear_Memory
    #--------------------------------------------------------------------------        
    def clear_memory
        DataManager.save_game_temp
        reset = Win32API.new 'user32', 'keybd_event', %w(l l l l), ''
        reset.call(0x7B,0,0,0)
        sleep(0.1)
        $clear_memory = [RPG::BGM.last,RPG::BGS.last]
        reset.call(0x7B,0,2,0)
    end    
    
  end  
  
  #===============================================================================
  # ■ Scene Recover Data
  #===============================================================================
  class Scene_Recover_Data
    
    #--------------------------------------------------------------------------
    # ● Main
    #--------------------------------------------------------------------------    
    def main
        SceneManager.clear
        DataManager.load_game_temp
        SceneManager.goto(Scene_Map)
        $clear_memory[0].replay rescue nil
        $clear_memory[1].replay rescue nil
        $clear_memory = nil
    end    
  end
  
  $mog_rgss3_clear_memory = true

