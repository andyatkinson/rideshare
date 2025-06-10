#!/usr/bin/env ruby

class RailsMigrationGenerator
  def initialize(sql_ddl)
    @sql_ddl = sql_ddl
  end

  def generate
    # TODO add more operation types
    if @sql_ddl =~ /create index/i
      output_file = "#{rails_style_timestamp}_create_index.rb"
      File.write(output_file, rails_generate_migration_code)
      puts "Wrote file: #{output_file}"
      puts `cat #{output_file}`
    end
  end

  private

  def get_rails_version
    input = `bundle exec rails version` # assumes bundler and same Rails version
    if input =~ /(\d+)\.(\d+)/
      major = $1.to_i
      minor = $2.to_i
      "#{major}.#{minor}"
    end
  end

  # Try and deduce the operation type
  def rails_migration_filename
    # TODO add more operation types
    if @sql_ddl =~ /create index/i
      "CreateIndex"
    end
  end

  # Assume it's a concurrently operation for now, disable_ddl_transaction!
  def rails_generate_migration_code
    template = <<~MIG_TEMPLATE.strip
      class #{rails_migration_filename} < ActiveRecord::Migration[#{get_rails_version}]
        disable_ddl_transaction!

        def change
          execute <<-SQL
            #{@sql_ddl}
          SQL
        end
      end
    MIG_TEMPLATE
  end

  def rails_style_timestamp
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end
end

# Check if a file path argument was provided
if ARGV.empty?
  puts "Usage: #{__FILE__} <file_path>"
  exit 1
end

file_path = ARGV[0]

# Check if the file exists and is readable
unless File.exist?(file_path) && File.readable?(file_path)
  puts "Error: File not found or is not readable: #{file_path}"
  exit 1
end

# Read and print the contents of the file
begin
  sql_ddl = File.read(file_path)

  RailsMigrationGenerator.new(
    sql_ddl
  ).generate

rescue => e
  puts "Failed to read the file: #{e.message}"
  exit 1
end
