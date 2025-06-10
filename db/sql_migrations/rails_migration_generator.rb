#!/usr/bin/env ruby

class RailsMigrationGenerator
  def initialize(sql_ddl)
    @sql_ddl = sql_ddl
    @index_name = nil # set below
    @migration_file_suffix = nil
    @migration_name = nil
    parse_sql_ddl
  end

  def generate
    # TODO add more operation types
    if @sql_ddl =~ /create index/i
      output_file = "#{migrations_dir}/#{rails_style_timestamp}_#{@migration_file_suffix}.rb"
      File.write(output_file, rails_generate_migration_code)
      puts "Wrote file: #{output_file}"
      puts `cat #{output_file}`
    end
  end

  private

  def migrations_dir
    output = `bundle exec rails runner "puts Rails.root.to_s"`
    base_dir = output.lines.last.chomp
    subdirs = ["db", "migrate"]
    File.join(base_dir, *subdirs)
  end

  def get_rails_version
    input = `bundle exec rails version` # assumes bundler and same Rails version
    if input =~ /(\d+)\.(\d+)/
      major = $1.to_i
      minor = $2.to_i
      "#{major}.#{minor}"
    end
  end

  # Try and deduce the operation type
  # TODO add more operation types, only supporting CREATE INDEX for now
  def parse_sql_ddl
    # Case-insensitive regex with optional keywords
    if @sql_ddl =~ /\A
      create\s+index          # "create index" keywords
      (?:\s+concurrently)?    # optional "concurrently"
      (?:\s+if\s+not\s+exists)?  # optional "if not exists"
      \s+(\S+)                # capture index name (non-whitespace)
      \s+on\s+                # "on" keyword
    /xi
      @index_name = $1
      migration_name_from_index = @index_name.split("_").map(&:capitalize).join
      @migration_file_suffix = "create_index_#{@index_name}"
      @migration_name = "CreateIndex#{migration_name_from_index}"
    end
  end

  # Assume it's a concurrently operation for now, disable_ddl_transaction!
  # Assumes strong_migrations is being used so we need: safety_assured {}
  def rails_generate_migration_code
    template = <<~MIG_TEMPLATE.strip
      class #{@migration_name} < ActiveRecord::Migration[#{get_rails_version}]
        disable_ddl_transaction!

        def change
          safety_assured do
            execute <<-SQL
              #{@sql_ddl}
            SQL
          end
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
