# encoding: utf-8

group :unit do
  guard :minitest, test_folders: ["Spec"], 
  test_file_patterns: ["*Spec.rb"] do
    'resources'
    'services'
    'contexts'
    'requests'
  end
end

group :resources do
  guard :minitest, test_folders: ["Spec/Resources"], 
  test_file_patterns: ["*MemberSpec.rb", "*CollectionSpec.rb", "*EnforcerSpec.rb", "*ScopeSpec.rb"] do
    watch(%r|^Resources/(.*)/(.*)\.rb|) { |matches| 
      "Spec/Resources/#{matches[1]}/#{matches[2]}Spec.rb" 
    }
    watch(%r|^Resources/(.*)/(.*)/(.*)\.rb|) { |matches| 
      "Spec/Resources/#{matches[1]}/#{matches[2]}/#{matches[3]}Spec.rb" 
    }
    watch(%r|^Spec/Resources/(.*)/(.*)Spec\.rb|)
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
      "Spec/Cases/#{matches[1]}/#{matches[2]}Spec.rb" 
    }
    watch(%r|^Spec/Cases/(.*)/(.*)Spec\.rb|)
  end
end

group :requests do
  guard :minitest, test_folders: ["Spec/Cases"], 
  test_file_patterns: ["*RequestSpec.rb"] do
    watch(%r|^Cases/(.*)/(.*)\.rb|) { |matches| 
      "Spec/Cases/#{matches[1]}/#{matches[2]}Spec.rb" 
    }
    watch(%r|^Spec/Cases/(.*)/(.*)Spec\.rb|)
  end
end

group :api do
  guard :minitest, test_folders: ["Spec/API"], 
  test_file_patterns: ["*Spec.rb"] do
    watch(%r|^API/(.*)\.rb|) { |matches| 
      "Spec/API/#{matches[1]}Spec.rb" 
    }
    watch(%r|^Spec/API/(.*)Spec\.rb|)
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
