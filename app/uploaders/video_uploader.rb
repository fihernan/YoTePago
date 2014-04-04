class VideoUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "upload/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(avi mp4 mpg)
  end
end
