# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "upload/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg bmp)
  end
end
