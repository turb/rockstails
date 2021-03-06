namespace :db do 
  COMPACT_DATABASE = 'datas/cocktails.yml'
  
  desc "Import cocktails from #{COMPACT_DATABASE} (use DATABASE_URL to set the database)."
  task :import_cocktails do
    require_relative '../model/activerecord/cocktail'
    require_relative '../model/activerecord/ingredient'
    require_relative '../model/activerecord/recipe_step'

    Cocktail.delete_all
    
    YAML::load_file(COMPACT_DATABASE).each do |cocktail|
      created = Cocktail.create! do |db_cocktail|
        db_cocktail.from_yaml(cocktail)
      end
      puts "Created cocktail: #{created.name} with id #{created.id}."
    end
  end

  desc "Import ingredients from #{COMPACT_DATABASE} (use DATABASE_URL to set the database)."
  task :import_ingredients do
    require_relative '../model/activerecord/ingredient'

    Ingredient.delete_all
    
    YAML::load_file(COMPACT_DATABASE).each do |cocktail|
      recipe_steps = cocktail['recipe_steps']
      recipe_steps.each do |step|
        Ingredient.where(name: step['ingredient_name']).first_or_create
      end
    end
    puts "Created #{Ingredient.count} ingredients."
  end
  
  
  desc 'Import bars from datas/bar to database (use DATABASE_URL to set the database).'
  task :import_bars do
    require_relative '../model/activerecord/ingredient'
    require_relative '../model/activerecord/bar'
    
    Bar.delete_all

    Dir['datas/bar/*.yml'].each do |f|
      yml_bar = YAML::load_file(f)
      
      Bar.create! do |bar|
        bar.name = File.basename(f, ".yml").capitalize
        puts "Processing #{bar.name}..."
        yml_bar.each do |i|
          ingredient = Ingredient.find_by(name: i)
          if ingredient.nil?
            puts "  #{i} not found!"
          else
            bar.ingredients << ingredient
          end
        end
        puts "  added #{bar.ingredients.size} ingredients"
      end
    end
  end
  
  def sanitize_name(name)
     name = name.gsub(/ /, '_')
     return name.gsub(/[^0-9A-Za-z_\-]/, '')
  end
  
  desc 'Export all cocktails into one YAML file (use DATABASE_URL to set the database).'
  task :export_cocktails do
    require_relative 'activerecord_yaml_serializer'
    require_relative '../model/activerecord/cocktail'
    require_relative '../model/activerecord/recipe_step'
    require_relative '../model/activerecord/ingredient'

    cocktails = Cocktail.all_as_yaml()
    puts "Write #{cocktails.length} cocktails into '#{COMPACT_DATABASE}'"
    File.open(COMPACT_DATABASE, 'w') do |file|
      file.write(cocktails.to_yaml())
    end
  end
  
  desc 'Export bars content into datas/bar in YAML (use DATABASE_URL to set the database).'
  task :export_bars do
    require_relative '../model/activerecord/bar'
    require_relative '../model/activerecord/ingredient'
    
    Bar.all.find_each do |bar|
      filename = "datas/bar/#{sanitize_name(bar.name.downcase)}.yml"
      puts "Save '#{bar.name}' into '#{filename}'."
      File.open(filename, 'w') do |file|
        file.write(bar.ingredient_names.uniq.sort.to_yaml)
      end
    end
  end

end