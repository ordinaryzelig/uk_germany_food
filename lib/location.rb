class Location

  S3_DIR  = 'locations'

  attr_reader :name
  attr_reader :foods

  class << self

    def all
      Coordinates.all.keys.map do |name|
        Location.new(name)
      end
    end

  end

  def initialize(name)
    @name = name
  end

  def create_foods
    @foods = bucket_objects.map do |s3_obj|
      path = "#{S3.path_prefix}/#{s3_obj.key}"
      Food.new(path, self)
    end.shuffle
  end

  def bucket_objects
    S3.bucket.objects.select do |s3_obj|
      key_prefix = "#{S3_DIR}/#{name}/"
      s3_obj.key =~ Regexp.new("#{key_prefix}.+")
    end
  end

end
