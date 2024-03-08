require 'pry'
require 'exif'
require 'mini_exiftool'
require 'digest'

class MediaFile
  attr_accessor :device, :hash, :date_time, :extension, :year, :month, :day, :time

  def initialize(path)
    begin
      data = Exif::Data.new(File.new(path))
      @device = device_name(data.ifds[:ifd0][:model])
      @date_time = DateTime.strptime(data.date_time, '%Y:%m:%d %H:%M:%S')
    rescue
      begin
        data = MiniExiftool.new(path)
        @device = device_name(data.model)
        @date_time = nil
      rescue => e
        puts "#{path}: #{e}"
        throw e
      end
    end
    @hash = Digest::SHA2.file(path).hexdigest
    @extension = File.extname(path) or 'unk'

    # Special logic for personal photo library
    @year = if date_time.nil?
              '1980'
            else
              date_time.strftime('%Y')
            end
    @month = if date_time.nil?
              '1980-01'
            else
              date_time.strftime('%Y-%m')
            end
    @day = if date_time.nil?
            '1980-01-01'
          else
            date_time.strftime('%Y-%m-%d')
          end
    @time = if date_time.nil?
             '00-00-00'
           else
             date_time.strftime('%H-%M-%S')
           end
  end

  # Filename based on file attributes
  def filename
    File.join("#{@day}.#{@time}.#{@device}.#{@hash}#{@extension}")
  end

  private
  def device_name(device)
    (device or 'Unknown-Device').split(' ')[..1].join('-')
  end
end

