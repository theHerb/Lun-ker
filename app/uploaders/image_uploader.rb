# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWaveDirect::Uploader
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  #storage :file
  storage :fog
  
  include CarrierWave::MimeTypes
  process :set_content_type

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  version :thumb do
    process :resize_to_fill => [100, 100]
  end

  version :photo_fill do
    process :resize_to_fill => [200, 200]
  end

  version :photo_limit do
    process :resize_to_limit => [200, 200]
  end

  version :large do
    process :resize_to_limit => [720, 540]
  end

  def extension_white_list
     %w(jpg jpeg gif png)
  end

  def filename
    "#{@original_filename}".underscore
  end

end
