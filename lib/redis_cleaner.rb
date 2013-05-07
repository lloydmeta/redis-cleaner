#encoding: utf-8

require 'rubygems'
require 'bundler/setup'

class RedisCleaner

  attr_accessor :redis, :temp_file_path

  def initialize(redis, temp_file_path)
    self.redis = redis
    self.temp_file_path = temp_file_path
  end

  # returns number of keys deleted if
  # everything was succesfully deleted otherwise
  # return false
  def remove_from_redis(keys_group = [])
    if redis.del(keys_group) == keys_group.size
      keys_group.size
    else
      false
    end
  end

  # def delete_in_groups
  # end
  # deleted_keys_count = 0
  # total_keys_count = 0

  # takes params inside a hash
  #   :batch_size defaults to 20
  #   :verbose defaults to true
  def delete_keys_in_temp_file(params = {})
    batch_size = params.fetch(:batch_size, 20)
    verbose = params.fetch(:verbose, true)

    total_keys_count = 0
    deleted_keys_count = 0

    File.foreach(temp_file_path).each_slice(batch_size) do |keys_group|
      total_keys_count = total_keys_count + keys_group.size
      if removed_keys_count = remove_from_redis(strip_keys_group(keys_group))
        puts "Successfully deleted key group of size #{keys_group.size}" if verbose
        deleted_keys_count = deleted_keys_count + removed_keys_count
      else
        puts "Failed to delete: #{keys_group.inspect}" if verbose
      end
    end

    {total_keys_count: total_keys_count, deleted_keys_count: deleted_keys_count}
  end

  def dump_matching_keys_to_temp_file(pattern)
    resque_keys = redis.keys(pattern)
    File.open(temp_file_path, "w+") do |file|
      resque_keys.each do |key|
        file.puts key
      end
    end
  end

  def dump_and_delete(pattern, params = {})
    verbose = params.fetch(:verbose, true)
    delete_temp_file = params.fetch(:delete_temp_file, true)

    puts "Dumping ..."
    dump_matching_keys_to_temp_file(pattern)
    puts "Dumping finished !"
    puts "Deleting dumped keys ..."
    cleanup_job_stats = delete_keys_in_temp_file(params)

    File.delete(temp_file_path) if delete_temp_file
    puts "Deleted #{cleanup_job_stats[:deleted_keys_count]} keys out of #{cleanup_job_stats[:total_keys_count]}"
  end

  private

    def strip_keys_group(keys_group = [])
      keys_group.map{|element| element.strip}
    end

end