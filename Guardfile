# encoding: utf-8

group :data do
  guard :minitest, test_folders: ["Spec/Data"], 
  test_file_patterns: ["*MemberSpec.rb", "*CollectionSpec.rb"] do
    watch(%r|^Data/(.*)/(.*)\.rb|) { |matches| 
      "Spec/#{matches[1]}/#{matches[2]}Spec.rb" 
    }
    watch(%r|^Data/(.*)/(.*)/(.*)\.rb|) { |matches| 
      "Spec/#{matches[1]}/#{matches[2]}/#{matches[3]}Spec.rb" 
    }
    watch(%r|^Spec/Data/(.*)/(.*)Spec\.rb|)
  end
end

group :services do
  guard :minitest, test_folders: ["Spec/Services"], 
  test_file_patterns: ["*Spec.rb"] do
    watch(%r|^Services/(.*)\.rb|) { |matches| 
      "Spec/Services/#{matches[1]}Spec.rb" 
    }
    watch(%r|^Services/(.*)/(.*)\.rb|) { |matches| 
      "Spec/Services/#{matches[1]}/#{matches[2]}Spec.rb" 
    }
    watch(%r|^Spec/Services/(.*)Spec\.rb|)
    watch(%r|^Spec/Services/(.*)/(.*)Spec\.rb|)
  end
end

group :contexts do
  guard :minitest, test_folders: ["Spec/Cases"], 
  test_file_patterns: ["*ContextSpec.rb"] do
    watch(%r|^Cases/(.*)/(.*)\.rb|) { |matches| 
      "Spec/#{matches[1]}/#{matches[2]}Spec.rb" 
    }
    watch(%r|^Spec/Cases/(.*)/(.*)Spec\.rb|)
  end
end

group :unit do
  guard :minitest, test_folders: ["Spec"], 
  test_file_patterns: ["*Spec.rb"] do
    'data'
    'contexts'
    'services'
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
