require 'rspec'
require 'fileutils'
require_relative '../lib/media_sorter'

RSpec.describe MediaSorter do
  let(:fixtures_dir) { 'spec/fixtures/source' }
  let(:test_source_dir) { 'spec/test_env/source' }
  let(:test_target_dir) { 'spec/test_env/target' }

  before(:all) do
  end

  after(:all) do
    # Overall cleanup (if needed)
  end

  before(:each) do
    # Setup for each test: Clear and recreate test directories
    FileUtils.rm_rf(test_source_dir)
    FileUtils.rm_rf(test_target_dir)
    FileUtils.mkdir_p(test_source_dir)
    FileUtils.mkdir_p(test_target_dir)

    # Copy files from fixtures to the test source directory
    FileUtils.cp_r(Dir.glob("#{fixtures_dir}/*"), test_source_dir)

    # Stub out MediaFile.new to raise an error
    #allow(MediaFile).to receive(:new).and_raise(StandardError.new("Test error"))
    #allow(Kernel).to receive(:exit)
  end

  after(:each) do
    # Teardown for each test: Clear test directories
    FileUtils.rm_rf(test_source_dir)
    FileUtils.rm_rf(test_target_dir)
  end

  # TODO
  context 'when source and target directories are the same' do
    it 'raises an error' do
      # binding.pry
    end
  end

  context 'when dry_run is true' do
    it 'does not move any files' do
      sorter = MediaSorter.new(test_source_dir, test_target_dir, dry_run: true)
      sorter.run
      expect(Dir.glob("#{test_source_dir}/*")).not_to be_empty
      expect(Dir.glob("#{test_target_dir}/*")).to be_empty
    end
  end

  context 'when dry_run is false' do
    it 'moves files from source to target' do
      sorter = MediaSorter.new(test_source_dir, test_target_dir, dry_run: false)
      sorter.run
      expect(Dir.glob("#{test_source_dir}/*")).to be_empty
      expect(Dir.glob("#{test_target_dir}/*")).not_to be_empty
    end
  end

  context 'when batch_size is 2 and dry_run is false' do
    it 'moves files in batches of 2' do
      sorter = MediaSorter.new(test_source_dir, test_target_dir, dry_run: false, batch_size: 2)
      sorter.run
      expect(Dir.glob("#{test_source_dir}/*").size).to eq(4)
      expect(Dir.glob("#{test_target_dir}/*").size).to eq(2)
    end
  end

  # TODO: Figure out how to test this
  #context 'when MediaFile raises an exception' do
  #  it 'terminates with an error message' do
  #    sorter = MediaSorter.new(test_source_dir, test_target_dir)
  #    expect { sorter.run }.to output(/An error occurred: Test error/).to_stdout
  #    expect(Kernel).to have_received(:exit).with(1)
  #  end
  #end
end

