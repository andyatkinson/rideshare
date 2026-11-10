if defined?(RailsERD)
  RailsERD.load_tasks if Rails.env.development? && ENV['SKIP_ERD'] != '1'
end
