# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'minitest', test_folders: ["Spec"], test_file_patterns: ["*Spec.rb"], 
notify: false do
  watch(%r|^Spec/(.*)/(.*)Spec\.rb|)
end
