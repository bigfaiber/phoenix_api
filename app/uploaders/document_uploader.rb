class DocumentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    if model.class.name == "WarrantyFile"
      "uploads/#{model.class.to_s.underscore}/documents/#{mounted_as}/#{model.id}"
    else
      "uploads/#{model.class.to_s.underscore}/#{model.imageable_type}/documents/#{mounted_as}/#{model.id}"
    end
  end

  def extension_whitelist
    %w(jpg jpeg gif png pdf)
  end

  def filename
     "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end
