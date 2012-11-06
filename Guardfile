#guard :minitest, test_folders: ["Spec"], test_file_patterns: ["*Spec.rb"] do
#  watch(%r|^Spec/(.*)/(.*)Spec\.rb|)
#end

group :data_objects do
  guard :minitest, test_folders: ["Spec"], 
  test_file_patterns: ["*MemberSpec.rb", "*CollectionSpec.rb"] do
    watch(%r|^App/(.*)/(.*)\.rb|) { |matches| 
      "Spec/#{matches[1]}/#{matches[2]}Spec.rb" 
    }
    watch(%r|^App/(.*)/(.*)/(.*)\.rb|) { |matches| 
      "Spec/#{matches[1]}/#{matches[2]}/#{matches[3]}Spec.rb" 
    }
    watch(%r|^Spec/(.*)/(.*)Spec\.rb|)
  end
end

group :contexts do
  guard :minitest, test_folders: ["Spec/Contexts"], 
  test_file_patterns: ["*Spec.rb"] do
    watch(%r|^App/Contexts/(.*)\.rb|) { |matches| 
      "Spec/Contexts/#{matches.last}Spec.rb" 
    }
    watch(%r|^(.*)Spec.rb|)
  end
end

group :unit do
  guard :minitest, test_folders: ["Spec"], 
  test_file_patterns: ["*Spec.rb"] do
    'data_objects'
    'contexts'
  end
end

notification :tmux, 
  display_message: true,

  # in seconds
  timeout: 5, 

  # the first %s will show the title, the second the message
  # Alternately you can also configure *success_message_format*,
  # *pending_message_format*, *failed_message_format*
  default_message_format: '%s >> %s',

  # since we are single line we need a separator
  line_separator: ' > ', 

  # to customize which tmux element will change color
  color_location: 'status-left-bg'
