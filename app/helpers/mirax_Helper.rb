module MiraxHelper
  # Set the variable "type_values" according to the category
  def type_variables(category)
    case category

    when 'Maquetas'

      type_values = {

        'aviones' => %w[aviones],

        'tanques' => %w[blindados],

        'soldados' => %w[soldados],

        'gundam Sd' => %w[sd],

        'gundam Hg' => %w[hg],

        'gundam Mg' => %w[mg],

        'gundam Rg' => %w[rg],

        'gundam Otros' => %w[grados],

        'haropla' => %w[haropla],

        'gundam 30mm' => %w[minutes],

        'otros ciencia ficcion' => %w[ficcion],

        'naves espaciales' => %w[espaciales],

        'barcos y submarinos' => %w[barcos]

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

    when 'Pinturas'

      type_values = {

        'acrílicos y enamels sets' => %w[sets],

        'acrílicos y enamels individuales/spray' => %w[individuales], # Individuales

        'citadel base' => %w[base],

        'citadel contrast' => %w[contrast],

        'citadel dry' => %w[dry],

        'citadel shade' => %w[shade],

        'citadel spray Primers' => %w[primers],

        'citadel technical' => %w[technical]

      }

    when 'Dioramas'

      type_values = {

        'edificios y accesorios' => %w[edificios],

        'displays' => %w[display],

        'agua' => %w[agua]

      }

    when 'Herramientas'

      type_values = {

        'libros' => %w[libros],

        'aerógrafos' => %w[aerógrafos],

        'otros' => %w[generales],

        'madera balsa' => %w[balsa]

      }

    end

    type_values
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
    categories_values['Maquetas'] << 'Aviones y helicópteros'
    categories_values['Maquetas'] << 'Autos, camiones y motos'
    categories_values['Maquetas'] << 'Soldados y blindados'
    categories_values['Maquetas'] << 'Ciencia ficción y series'
    categories_values['Maquetas'] << 'Soldados y carabineros metalicos'
    categories_values['Maquetas'] << 'Naves espaciales'
    categories_values['Maquetas'] << 'Barcos y submarinos'
    categories_values['Maquetas'] << 'Calcas y fotograbados'

    categories_values['Miniaturas'] << 'Miniaturas'

    categories_values['Pinturas'] << 'Pinturas, efectos, diluyentes y barnices'

    categories_values['Dioramas'] << 'Accesorios e insumos para dioramas'

    categories_values['Herramientas'] << 'Herramientas, pinceles y otros'
    categories_values['Herramientas'] << 'Libros de modelismo'
    categories_values['Herramientas'] << 'Aerógrafos y sus accesorios'
    categories_values['Herramientas'] << 'Pegamentos'
    categories_values['Herramientas'] << 'Otras herramientas'
    categories_values['Herramientas'] << 'Madera terciada y balsa'

    categories_values
  end

  # Set the Brands with two or more words
  def large_brands_names
    {
      'ACALL TO ARMS' => %w[ACALL],
      'AMMO MIG JIMENEZ' => %w[AMMO],
      'ARMY PAINTER' => %w[ARMY],
      'ATLANTIS MODELS' => %w[ATLANTIS],
      'ATOMIC MASS GAMES' => %w[ATOMIC],
      'BILLING BOATS' => %w[BILLING],
      'FANTASY FLIGHT GAMES' => %w[FANTASY],
      'HARDER & STEENBECK' => %w[HARDER],
      'MODEL GRAPHIX' => %w[MODEL]
    }
  end

  def brands_specials_cases(brand)
    case brand

    when 'WIZKIDS'
      special_case = ['MARVEL']
    when 'OSPREY'
      special_case = %w[B C E ESP ESS F GH GI MAA V W]
    when 'K4'
      special_case = %w[FS MS RAF RAL RLM]
    end

    special_case
  end
end