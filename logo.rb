# Title Multilogo

if true
    #==============================================================================
    # +++ MOG - Title Multilogo - [Stand-Alone Series] (V1.1) +++
    #==============================================================================
    # By Moghunter 
    # https://atelierrgss.wordpress.com/
    #==============================================================================
    # Adiciona logos antes da tela de título
    #==============================================================================
    # Para adicionar os logos nomeie os arquivos da seguinte forma.
    #
    # Logo_0.png
    # Logo_1.png
    # Logo_2.png
    # Logo_3.png
    # Logo_4.png
    # Logo_5.png ... Logo_999.png
    #
    # Grave as imagens na pasta /Graphics/Title1/
    #==============================================================================
    module MOG_MLOGOS
      #--------------------------------------------------------------------------
      # Definição do nome do arquivo.
      #--------------------------------------------------------------------------
      FILE_NAME = "Logo_"
      #--------------------------------------------------------------------------
      #Ativar ME (coloque " PLAY_ME = nil " para desativar o efeito )
      #--------------------------------------------------------------------------
      PLAY_ME = "Shock"  
      #--------------------------------------------------------------------------
      #Duração do logo.
      #--------------------------------------------------------------------------
      LOGO_DURATION = 80
      #--------------------------------------------------------------------------
      #Ativar o Botão para pular o logo.
      #--------------------------------------------------------------------------
      SKIP_BUTTON = true
    end
    
    $imported = {} if $imported.nil?
    $imported[:mog_title_multilogo] = true
    
    #==============================================================================
    # ■ Scene Tittle
    #==============================================================================
    class Scene_Title < Scene_Base
      
     #--------------------------------------------------------------------------
     # ● Main
     #--------------------------------------------------------------------------             
       alias mog_t_logo_main main
       def main
           execute_tlogo if $logo_enabled == nil
           mog_t_logo_main
       end
    
     #--------------------------------------------------------------------------
     # ● Execute Tlogo
     #--------------------------------------------------------------------------             
       def execute_tlogo
           $logo_enabled = true if $logo_enabled == nil
           Graphics.transition(transition_speed); mlogo = M_logo.new
           loop do
           Input.update ; mlogo.update ; Graphics.update ; break if mlogo.phase == 1
           end
       end
       
    end
     
    #==============================================================================
    # ■ M_Logo
    #==============================================================================
    class M_logo
      include MOG_MLOGOS
      attr_accessor :phase
      
     #--------------------------------------------------------------------------
     # ● Initialize
     #--------------------------------------------------------------------------             
      def initialize
          @phase = 0 ; @logos = []
          for i in 0...999 ; @logos.push(Cache.title1(MOG_MLOGOS::FILE_NAME + i.to_s)) rescue nil      
          break if @logos[i] == nil ; end
          @logo_sprite = Sprite.new ; time = [LOGO_DURATION, 5].max
          @logo_data = [0,0,61 + time] ; refresh_logo
          Audio.me_play("Audio/ME/" + PLAY_ME, 100, 100) if PLAY_ME != nil
      end
      
     #--------------------------------------------------------------------------
     # ● Refresh Logo
     #--------------------------------------------------------------------------             
      def refresh_logo
          if @logos[@logo_data[1]] == nil ; @phase = 1 ; return ; end
          @logo_sprite.bitmap = @logos[@logo_data[1]]
          @logo_sprite.opacity = 0 ; @logo_data[0] = 0 ; @logo_data[1] += 1
      end
      
     #--------------------------------------------------------------------------
     # ● Dispose
     #--------------------------------------------------------------------------             
      def dispose
          Graphics.freeze
          @logos.each {|sprite| sprite.dispose } 
          @logo_sprite.bitmap.dispose ; @logo_sprite.dispose
      end
      
     #--------------------------------------------------------------------------
     # ● Update
     #--------------------------------------------------------------------------             
      def update
          update_skip_logo ; @logo_data[0] += 1
          case @logo_data[0]
          when 0..60 ; @logo_sprite.opacity += 5
          when 61..@logo_data[2] ; @logo_sprite.opacity = 255
          when @logo_data[2]..(@logo_data[2] + 120) ; @logo_sprite.opacity -= 5
          end      
          refresh_logo if @logo_sprite.opacity == 0
      end
      
     #--------------------------------------------------------------------------
     # ● Update Skip Logo
     #--------------------------------------------------------------------------             
      def update_skip_logo
          return if !SKIP_BUTTON
          return if @logo_data[1] > @logos.size
          if Input.press?(:C) or Input.press?(:B) 
          @logo_data[0] = @logo_data[2] + 10 ; @logo_data[1] = @logos.size + 1
          end
      end
      
    end
    
    #==============================================================================
    # ■ Scene Base
    #==============================================================================
    class Scene_Base
        
     #--------------------------------------------------------------------------
     # ● Terminate
     #--------------------------------------------------------------------------             
     alias mog_t_mlogos_main terminate
     def terminate        
         mog_t_mlogos_main 
         $logo_enabled = nil unless SceneManager.scene_is?(Scene_Title) or SceneManager.scene_is?(Scene_Load)
     end
    
    end
    
    #===============================================================================
    # ■ SceneManager
    #===============================================================================
    class << SceneManager
    
      #--------------------------------------------------------------------------
      # ● First Scene Class
      #--------------------------------------------------------------------------  
      alias mog_t_mlogos_first_scene_class first_scene_class
      def first_scene_class
          $logo_enabled = nil
          mog_t_mlogos_first_scene_class
      end  
      
    end
    
    end