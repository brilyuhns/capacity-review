require 'csv'
require 'date'

namespace :import do
  desc "Import data from CSV file"
  task :data, [:csv_file] do
    # Debug database connection
    puts "=== DATABASE DEBUG INFO ==="
    puts "Database config: #{ActiveRecord::Base.connection_db_config}"
    puts "Database adapter: #{ActiveRecord::Base.connection.adapter_name}"
    
    # Show which database file is being used
    if ActiveRecord::Base.connection.adapter_name == 'SQLite'
      db_path = ActiveRecord::Base.connection.instance_variable_get(:@config)[:database]
      puts "SQLite database path: #{db_path}"
      puts "Database file exists: #{File.exist?(db_path)}"
      puts "Database file size: #{File.exist?(db_path) ? File.size(db_path) : 'N/A'} bytes"
    end
    
    # Show existing records
    puts "Existing Capacity records: #{Capacity.count}"
    if Capacity.count > 0
      puts "Existing Capacity records:"
      Capacity.all.each do |cap|
        puts "  ID: #{cap.id}, Period: #{cap.period_start}, Type: #{cap.period_type}"
      end
    end
    puts "=== END DATABASE DEBUG ==="
    puts ""
    
    csv_file = ARGV[1] || 'data/resourcing_stats.csv'
    
    unless File.exist?(csv_file)
      puts "Error: CSV file not found at #{csv_file}"
      exit 1
    end

    puts "Reading CSV file: #{csv_file}"
    csv_data = CSV.read(csv_file)
    
    # Extract week dates from first row
    week_dates = csv_data[0].compact.map { |date| date&.strip }
    week_dates = week_dates.reject { |date| date.nil? || date.empty? }
    puts "Found week dates: #{week_dates.inspect}"
    
    # Process capacity data from rows 1-5
    week_dates.each_with_index do |week, index|
      # Get raw values
      idx = 10 + index
      raw_gross = csv_data[1][idx]
      raw_planned = csv_data[2][idx]
      raw_unplanned = csv_data[4][idx]
      
      # Clean and convert values
      gross_capacity = clean_numeric_value(raw_gross)
      planned_leaves = clean_numeric_value(raw_planned)
      unplanned_leaves = clean_numeric_value(raw_unplanned)
      
      # Convert week string to date
      period_start = parse_week_to_date(week)
      
      # Debug output
      puts "Processing week: #{week}"
      puts "  Parsed date: #{period_start}"
      puts "  Gross capacity: #{gross_capacity}"
      puts "  Planned leaves: #{planned_leaves}"
      puts "  Unplanned leaves: #{unplanned_leaves}"
      
      if period_start
        # Check if record already exists
        existing = Capacity.find_by(period_start: period_start, period_type: 'month')
        if existing
          puts "  WARNING: Record already exists for #{period_start} with period_type 'month'"
          puts "  Existing record ID: #{existing.id}"
        else
          puts "  Creating new capacity record"
        end
        
        Capacity.create!(
          period_start: period_start,
          period_type: 'week',
          gross_capacity: gross_capacity,
          planned_leaves: planned_leaves,
          unplanned_leaves: unplanned_leaves,
          source: 'imported'
        )
      end
    end
    
    # Get headers from row 7
    headers = csv_data[6]
    
    # Process project data starting from row 8
    project_data = csv_data[7..-1]
    project_data.each do |row|
      # Skip empty rows or rows without a project name
      next if row.nil? || row.all?(&:nil?) || row.all? { |cell| cell.to_s.strip.empty? }
      next if row[headers.index('Project Name')].nil? || row[headers.index('Project Name')].strip.empty?
      
      # Create or update project
      project = Project.find_or_initialize_by(name: row[headers.index('Project Name')].strip)
      project.update!(
        category: row[headers.index('Category')]&.strip || 'unknown',
        start_date: row[headers.index('Start Date')]&.strip ? Date.parse(row[headers.index('Start Date')].strip) : nil,
        end_date: row[headers.index('End Date')]&.strip ? Date.parse(row[headers.index('End Date')].strip) : nil
      )
      
      # Process allocations for each week
      week_dates.each_with_index do |week, index|
        # Get allocation value from the correct column (starting from column 11)
        allocation = row[10 + index]&.to_s&.gsub(/[^\d.]/, '')&.to_f || 0
        next if allocation == 0 || allocation > 100  # Skip zero or unreasonably large allocations
        
        # Convert week string to date
        period_start = parse_week_to_date(week)
        next unless period_start
        
        ProjectAllocation.create!(
          project: project,
          period_start: period_start,
          period_type: 'month',
          allocation: allocation,
          source: 'imported'
        )
      end
    end

    puts "Import completed successfully!"
    puts "Total projects: #{Project.count}"
    puts "Total capacities: #{Capacity.count}"
    puts "Total project allocations: #{ProjectAllocation.count}"
  end
end

private

def parse_week_to_date(week_str)
  return nil if week_str.nil? || week_str.strip.empty?
  
  begin
    if week_str.include?('-')
      Date.strptime(week_str.strip, '%d-%b-%Y')
    else
      parts = week_str.strip.split(' ')
      return nil unless parts.length >= 2
      
      day = parts[0].to_i
      month = Date::ABBR_MONTHNAMES.index(parts[1][0..2].capitalize)
      return nil unless month
      
      year = 2025  # Default to 2025
      
      # If month is November or December, it must be 2024
      if month >= 11
        year = 2024
      end
      
      Date.new(year, month, day)
    end
  rescue
    nil
  end
end

def clean_numeric_value(value)
  return 0.0 if value.nil? || value.to_s.strip.empty?
  
  # Remove any non-numeric characters except decimal point
  cleaned = value.to_s.strip.gsub(/[^\d.]/, '')
  
  # Handle empty string after cleaning
  return 0.0 if cleaned.empty?
  
  # Convert to float
  cleaned.to_f
end 