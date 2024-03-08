require 'spec_helper'
require_relative '../lib/media_file'

RSpec.describe MediaFile do

  let(:path_to_image) { 'spec/fixtures/source/image0.jpg' }
  let(:media_file) { MediaFile.new(path_to_image) }

  describe '#initialize' do
    context 'when a valid image is provided' do
      it 'initializes device, hash, and date_time' do
        expect(media_file.device).not_to be_nil
        expect(media_file.hash).not_to be_nil
        expect(media_file.date_time).not_to be_nil
      end
    end

    context 'when an invalid image is provided' do
      it 'raises an error' do
        expect { MediaFile.new('invalid/path') }.to raise_error
      end
    end
  end

  TEST_CASES = {
    'spec/fixtures/source/image0.jpg' => '1980-01-01.00-00-04.Canon-PowerShot.8eb073de266308ab2edef914c653eac1f0d4580509799f2e4b66dcec93bb6a55.jpg',
    'spec/fixtures/source/image1.jpg' => '2023-07-04.20-03-38.SM-G991U1.35d59b8ea6a2d12ec63d5a65838fbf057b10cecd9ea684a8af397c62bea5c284.jpg',
    'spec/fixtures/source/image2.jpg' => '2015-02-09.21-58-01.Canon-PowerShot.f6d3e4338f88853a3330a994dc249eb94a075c73feb1415a120a08ade8c1ca97.jpg',
    'spec/fixtures/source/image3.jpg' => '2017-01-05.17-07-39.iPhone-5c.650248bf5f70a1b5a6e01fe0bc706b03d0531ff63909770ab4ea249153d988e0.jpg',
    'spec/fixtures/source/image4.jpg' => '2019-03-09.17-58-51.Moto-G.d10cb854ba0afacb294465ddc2d7ef8fcbf2a5ad312c11b2133b23863cd737cb.jpg',
    'spec/fixtures/source/image5.jpg' => '2019-03-17.14-51-31.Moto-G.a7b21c31e574950db5e54ab85489dd0d150fdeb82bde6a61e823f8b52236e1ab.jpg',
  }

  TEST_CASES.each do |image_path, expected_filename|
    context "when processing #{image_path}" do
      let(:media_file) { MediaFile.new(image_path) }

      it 'returns a valid file path' do
        expect(media_file.filename).to eq(expected_filename)
      end
    end
  end

end

