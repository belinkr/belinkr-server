# encoding: utf-8
require 'i18n'
require_relative '../Tinto/Transformer'
require_relative '../Config'

Belinkr::Config::AVAILABLE_LOCALES.each do |locale|
  I18n.load_path << ["#{File.dirname(__FILE__)}/#{locale.upcase}"]
end

I18n.locale = Belinkr::Config::DEFAULT_LOCALE

