#!/usr/bin/env ruby

files = {
  "resque_schedule.yml.sample" => "resque_schedule.yml",
  "resque.yml.sample"          => "resque.yml",
  "database.ci.yml"            => "database.yml",
  "application_settings.yml.sample" => "application_settings.yml",
  "providers.yml.sample" => "providers.yml"
}

files.each do |orig, dest|
  command = "cp config/#{orig} config/#{dest}"
  puts command
  `#{ command }`
end
