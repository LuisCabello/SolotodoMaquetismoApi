module RamscaleHelper

  # Set the Brands with two or more words
  def normalize_brands_names
    {
      'AMMO MIG JIMENEZ' => %w[AMMO],
      'FINEMOLDS'=> %w[FINEMODELS]
    }
  end

   # normalize categories
  def self.category_values
    categories_values = {
      'Maquetas' => [],
      'Miniaturas' => [],
      'Pinturas' => [],
      'Dioramas' => [],
      'Herramientas' => []
    }

    categories_values['Maquetas'] << 'Maquetas'

    categories_values['Miniaturas'] << 'Miniaturas'

    categories_values['Pinturas'] << 'Pinturas'

    categories_values['Dioramas'] << 'Efectos y Dioramas'

    categories_values['Herramientas'] << 'Herramientas y Auxiliares'
    categories_values['Herramientas'] << 'Libros y Revistas'

    categories_values
  end

  def type_variables(category)
    case category

    # TODO: La marca Green Stuff World tiene pinturas acrilicas en set dentro del tipo revisar
    # TODO: Color metalizado es en base a alcohol, ver si es acrilica o de otro tipo, y la tinta tambien
    # TODO: Tal vez dejar las en base a alcohol como pinturas en alcohol
    when 'Pinturas'

      type_values = {

        'acrílicos y enamels sets' => %w[sets],

        'acrílicos y enamels individuales/spray' => %w[individuales acrilicos esmaltes pinturas colores dry gama tintas],

        'pintura al alcohol' => %w[metalizados],

        'barnices y primer' => %w[barnices imprimantes titans],

        'lacas' => %w[lacas alclad],

        'efectos y filtros' => %w[lavados escurridos efectos filtros],

        'oleos' => %w[oleos]

      }

    # TODO: HAY CASOS DONDE HAY EFECTOS QUE VAN CON EL DIORAMA
    when 'Dioramas'

      type_values = {

        'edificios y accesorios' => %w[edificios],

        'displays' => %w[display],

        'agua' => %w[agua aguas],

        'pigmentos' => %w[pigmentos],

        'pastos, hojas y piedras' => %w[arbustos bases pasto pastos hojas piedras],

        'arboles' => %w[plantas],

        'barros y texturas' => %w[barros]

      }

  # TODO: TAL VEZ sacar merchandising
  # TODO: LOS PINCELES ESTAN MEZCLADOS ENTRE TIPOS
    when 'Herramientas'

      type_values = {

        'libros' => %w[libros tanques aviones figuras misceláneo],

        'Libros de modelismo' => %w[tanques aviones figuras misceláneo],

        'aerógrafos' => %w[aerógrafos],

        'madera balsa' => %w[balsa],

        'lijas y masking tape' => %w[lijas cintas],

        'Herramientas para modelismo' => %w[herramientas paletas],

        'otros' => %w[estaciones auxiliares generales]

      }

    when 'Maquetas'

      type_values = {

        'aviones' => %w[aviones],

        'tanques' => %w[tanques],

        'soldados' => %w[soldados],

        'otros ciencia ficcion' => %w[sci-fi],

        'barcos y submarinos' => %w[buques]

      }

    when 'Miniaturas'

      type_values = {

        'warhammer 40k apocalypse' => %w[apocalypse],

        'warhammer age of sigmar' => %w[sigmar],

        'warhammer 40k killteam' => %w[killteam],

        'warhammer adeptus titanicus' => %w[adeptus],

        'warhammer warcry' => %w[warcry],

        'warhammer blood bowl' => %w[bowl],

        'warhammer necromunda' => %w[necromunda],

        'warhammer aeronautica imperialis' => %w[imperialis]

      }

    end

    type_values
  end

end

  # Tenemos las marcas en Ramscale :
# Tanques---

# AMMO -> "AMMO MIG JIMENEZ"
# RFM -> RFM
# Tiger Model -> TIGER MODEL
# Thunder Models -> THUNDER MODELS
# Tamiya -> "TAMIYA"
# Kinetic -> KINETIC
# Bordermodel -> BORDERMODEL
# Amusing Hobby -> AMUSING HOBBY
# Hobby 2000 -> HOBBY 2000
# Takom -> TAKOM
# Das Werk -> DAS WERK
# Finemodels -> "FINEMOLDS"
# Modelcollect -> MODELCOLLECT
# T-model -> T-MODEL
# GWH -> GWH
# Arma Hobby -> ARMA HOBBY
# Clear Prop -> CLEAR PROP
# Dora Wings -> DORA WINGS
# Dream Model -> DREAM MODEL
# Kotobukiya -> "KOTOBUKIYA"
# AOSHIMA -> AOSHIMA
# Rado Miniatures -> RADO MINIATURES
# T-rex Studio -> T-REX STUDIO
# Master Model -> MASTER MODEL
# Quinta Studio -> QUINTA STUDIO
# ----

# Otros

# AMMO By Mig Jimenez -> "AMMO MIG JIMENEZ"
# Mission Models -> MISSION MODELS
# Green Stuff World -> GREEN STUFF WORLD
# Tamiya -> "TAMIYA"
# Mini-Nature -> MINI-NATURE
# Man Wah -> MAN WAH
# Red Grass -> RED GRASS

# TENER EN CUENTA QUE DEBEMOS PONER LOS TIPOS EN MAYUSCULAS O EN MINISCULAS