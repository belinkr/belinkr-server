# encoding: utf-8
%w{API Cases Resources}.each do |dir|
  Dir.glob("Spec/#{dir}/**/*").each do |file|
    require_relative file if File.file? file
  end
end

