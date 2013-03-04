# encoding: utf-8
%w{Searcher Tracker Locator}.each do |service|
  Dir.glob("Spec/Services/#{service}/**/*").each do |file|
    require_relative file if File.file? file
  end
  #Dir.glob("Spec/Resources/**/*").each do |file|
  # require_relative file if File.file? file
  #end
  #require_relative "Spec/Resources/Workspace/EnforcerSpec.rb"
end
