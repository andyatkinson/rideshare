if defined?(RailsERD)
  RailsERD.load_tasks if Rails.env.development?
end
