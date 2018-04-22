CarrierWave.configure do |config|
  config.storage = :upyun
  config.upyun_username = Rails.application.credentials.dig(:development, :upyun_username)
  config.upyun_password = Rails.application.credentials.dig(:development, :upyun_password)
  config.upyun_bucket = Rails.application.credentials.dig(:development, :upyun_bucket)
  config.upyun_bucket_host = Rails.application.credentials.dig(:development, :upyun_bucket_host)
end
