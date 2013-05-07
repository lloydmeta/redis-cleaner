require 'spec_helper'
require 'tempfile'

describe RedisCleaner do

  let(:fake_keys){%w[key1 key2 key3 key4 key5 a_key1 a_key2]}
  let(:redis_mock){double("Redis mock", :keys => fake_keys)}
  let(:temp_file){Tempfile.new('test_file')}
  let(:temp_file_path){temp_file.path}
  let(:redis_cleaner){RedisCleaner.new(redis_mock, temp_file_path)}

  after(:all) do
    temp_file.unlink
  end

  describe "initialisation" do

    it "should not error out" do
      expect{
        redis_cleaner = RedisCleaner.new(redis_mock, temp_file_path)
        }.to_not raise_error
    end

  end

  describe "#remove_from_redis" do

    it "should return the number of keys deleted if everything was deleted successfully" do
      redis_mock.stub(:del).and_return(fake_keys.size)
      redis_cleaner.remove_from_redis(fake_keys).should eq(fake_keys.size)
    end

    it "should return false if the number of keys deleted does not equal the number of keys passed in" do
      redis_mock.stub(:del).and_return(fake_keys.size - 1)
      redis_cleaner.remove_from_redis(fake_keys).should be_false
    end

  end

end