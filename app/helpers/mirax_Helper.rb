module MiraxHelper

  # Set the variable "type_values" according to the category
  def global_variables(category)
    case category

    when 'Maquetas'

      type_values = {

        'Aviones' => %w[aviones],

        'Tanques' => %w[blindados],

        'Soldados' => %w[soldados],

        'Gundam Sd' => %w[sd],

        'Gundam Hg' => %w[hg],

        'Gundam Mg' => %w[mg],

        'Gundam Rg' => %w[rg],

        'Gundam Otros' => %w[grados],

        'Haropla' => %w[Haropla],

        'Gundam 30mm' => %w[minutes],

        'Otros Ciencia Ficcion' => %w[ficcion],

        'Naves Espaciales' => %w[espaciales],

        'Barcos y Submarinos' => %w[Barcos]

      }

    when 'Miniaturas'

      type_values = {

        'Warhammer 40k Apocalypse' => %w[apocalypse],

        'Warhammer Age of Sigmar' => %w[sigmar],

        'Warhammer 40k Killteam' => %w[killteam],

        'Warhammer Adeptus Titanicus' => %w[Adeptus],

        'Warhammer Warcry' => %w[warcry],

        'Warhammer Blood Bowl' => %w[Bowl],

        'Warhammer Necromunda' => %w[necromunda],

        'Warhammer Aeronautica Imperialis' => %w[imperialis]

      }

    when 'Pinturas'

      type_values = {

        'Acrílicos y Enamels Sets' => %w[Sets],

        'Acrílicos y Enamels Individuales/Spray' => %w[Individuales y spray],

        'Citadel Base' => %w[base],

        'Citadel Contrast' => %w[contrast],

        'Citadel Dry' => %w[dry],

        'Citadel Shade' => %w[shade],

        'Citadel Spray Primers' => %w[primers],

        'Citadel Technical' => %w[technical]

      }

    when 'Dioramas'

      type_values = {

        'Edificios y Accesorios' => %w[Edificios],

        'Displays' => %w[Display],

        'Agua' => %w[Agua]

      }

    when 'Herramientas'

      type_values = {

        'Libros' => %w[Libros],

        'Aerógrafos' => %w[Aerógrafos],

        'Otros' => %w[generales],

        'Madera Balsa' => %w[balsa]

      }

    end

    return type_values
  end
end
