require 'bundler/setup'
Bundler.require :default, ENV.fetch('RACK_ENV', 'development')

require 'yaml'

require_relative 'lib/s3'
require_relative 'lib/coordinates'
require_relative 'lib/location'
require_relative 'lib/food'

class EuropeFood < Sinatra::Base

  SIZE               = 500
  PADDING            = 50
  HORIZONTAL_SPACING = SIZE + PADDING
  DATA_Z             = -2_000

  set :public_folder, '.'

  before do
    step_config
  end

  get '/main.js' do
    coffee :main
  end

  get '*' do
    haml :index
  end

  helpers do

    def step_config
      @transition_duration = 1_500
      @map_scale = 2.5
    end

    def locations
      @locations ||= Location.all.each(&:create_foods)
    end

    def location_step_atts(location, is_end = false)
      id = location.name.gsub(/\W/, '_')
      id = "end_#{id}" if is_end
      {
        'id'            => id,
        'data-x'        => Coordinates.x(location.name),
        'data-y'        => Coordinates.y(location.name),
        'data-location' => dom_id(location),
      }
    end

    def food_step_atts(food, idx)
      loc_data_x = Coordinates.x(food.location.name)
      loc_data_y = Coordinates.y(food.location.name)
      {
        'id'            => dom_id(food),
        'data-x'        => loc_data_x + (idx * HORIZONTAL_SPACING),
        'data-y'        => loc_data_y,
        'data-z'        => DATA_Z,
        'data-location' => dom_id(food.location),
        'class'         => ["location-#{dom_id(food.location)}"],
      }
    end

    def dom_id(obj)
      prefix = ''
      if obj.is_a?(Food)
        prefix.replace("#{dom_id(obj.location)}-")
      end
      prefix + obj.name.gsub(/\W/, '_')
    end

  end

end
