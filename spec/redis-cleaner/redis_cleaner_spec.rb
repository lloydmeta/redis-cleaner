require 'spec_helper'
require 'tempfile'

describe RedisCleaner do

  let(:fake_keys){%w[key1 key2 key3 key4 key5 a_key1 a_key2]}
  let(:redis_mock){
    r = double("Redis mock", :keys => fake_keys)
    r.stub(:del) do |arg|
      arg.size
    end
    r
  }
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

    it "should receive key_group as an argument" do
      redis_cleaner.should_receive(:remove_from_redis).with(fake_keys)
      redis_cleaner.remove_from_redis(fake_keys)
    end

    it "should return the number of keys deleted if everything was deleted successfully" do
      redis_cleaner.remove_from_redis(fake_keys).should eq(fake_keys.size)
    end

    it "should return false if the number of keys deleted does not equal the number of keys passed in" do
      redis_mock.stub(:del) do |arg|
        arg.size - 1
      end
      redis_cleaner.remove_from_redis(fake_keys).should be_false
    end

  end

  describe "#dump_matching_keys_to_temp_file" do

    it "should receive a pattern as an argument" do
      pattern = "asdf1234"
      redis_cleaner.should_receive(:dump_matching_keys_to_temp_file).with(pattern)
      redis_cleaner.dump_matching_keys_to_temp_file(pattern)
    end

    it "should call #keys on the redis object" do
      pattern = "asdf1234"
      redis_mock.should_receive(:keys).with(pattern)
      redis_cleaner.dump_matching_keys_to_temp_file(pattern)
    end

    it "should dump the keys into the temp file" do
      pattern = "asdf1234"
      redis_cleaner.dump_matching_keys_to_temp_file(pattern)
      temp_file_array = File.readlines(temp_file_path)
      temp_file_array.zip(fake_keys).each do |(t, f)|
        t.strip.should eq f
      end
    end

  end

  describe "#delete_keys_in_temp_file" do

    before(:each) do
      redis_cleaner.dump_matching_keys_to_temp_file("bleh")
    end

    it "should call #remove_from_redis" do
      redis_cleaner.should_receive(:remove_from_redis)
      redis_cleaner.delete_keys_in_temp_file(verbose: false)
    end

  end

end