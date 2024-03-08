require_relative 'media_file'

class MediaSorter
  def initialize(source, target, batch_size: 100, dry_run: false)
    @source = source
    @target = target
    @batch_size = batch_size
    @dry_run = dry_run

    raise ArgumentError, "Source directory does not exist" unless Dir.exist?(@source)
    raise ArgumentError, "Target directory does not exist" unless Dir.exist?(@target)
  end

  def run
    begin
      process_files
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
      exit 1
    end
  end

  def process_files
    if @dry_run
      puts "Dry run: no files will be moved."
    else
      puts "Moving files..."
    end

    media_files(@source).take(@batch_size).each do |path|
      media_file = MediaFile.new(path)
      target_dir = File.join(@target, media_file.year, media_file.month)
      puts "#{path} -> #{File.join(target_dir, media_file.filename)}"
      unless @dry_run
        FileUtils.mkdir_p(target_dir)
        FileUtils.mv(path, File.join(target_dir, media_file.filename))
      end
    end
  end

  private
  def media_files(path)
    # Include upper case variants of extensions
    extensions = "jpg,jpeg,png,mp4,mov,heic,aac".split(",").map do |ext|
      [ext, ext.upcase]
    end.flatten.join(",")
    Dir.glob(File.join(path, "**/*.{#{extensions}}"))
  end
end

