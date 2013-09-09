module S3

  BUCKET = 'UK_Germany_food'

  module_function

  def bucket
    return @bucket if @bucket
    connect
    @bucket = AWS::S3::Bucket.find BUCKET
  end

  def connect
    return true if @connected
    AWS::S3::Base.establish_connection!(
      :access_key_id     => ENV['AMAZON_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AMAZON_SECRET_ACCESS_KEY']
    )
    @connected = true
  end

  def path_prefix
    "https://s3.amazonaws.com/#{BUCKET}"
  end

end
