# encoding: utf-8
%w{API Cases Resources}.each do |dir|
  Dir.glob("Spec/#{dir}/**/*").each do |file|
    require_relative file if File.file? file
  end
  #Dir.glob("Spec/Resources/**/*").each do |file|
  # require_relative file if File.file? file
  #end
  #require_relative "Spec/Resources/Workspace/EnforcerSpec.rb"
end

