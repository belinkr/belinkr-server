# encoding: utf-8

module Belinkr
  module Config
    HOSTNAME                  = 'www.belinkr.com'
    
    AVAILABLE_LOCALES         = ['EN', 'ZH', 'ES']
    DEFAULT_LOCALE            = :en
    DEFAULT_TIMEZONE          = 'Etc/UTC'
    INITIAL_SCRAPBOOKS        = ['favorites', 'drafts']

    SESSION_SECRET            = 'ruobilin'
    LOCALE_COOKIE             = 'belinkr.locale'
    AUTH_TOKEN_COOKIE         = 'belinkr.auth_token'
    REMEMBER_COOKIE           = 'belinkr.remember'
    COOKIE_EXPIRATION_IN_SECS = 604800

    XMPP_BOSH_URL             = 'http://www.belinkr.com:5280/http-bind'
    XMPP_HOST                 = 'www.belinkr.com'
    XMPP_QUEUE_KEY            = 'xmpp'
    STORAGE_ROOT              = File.join(File.dirname(__FILE__), 'public')

    # See http://activitystrea.ms/head/activity-schema.html#verbs
    ACTIVITY_ACTIONS = %w{
      add cancel checkin delete favorite follow give ignore invite 
      join leave like make-friend play post receive remove remove-friend
      request-friend rsvp-maybe rsvp-no rsvp-yes save share
      stop-following tag unfavorite unlike unsave update
    }

    ACTIVITY_ACTIONS_EXTENSIONS = %w{
      accept reject allow deny promote demote
    }

    #
    # Polymorphic mapper
    #

    RESOURCE_MAP = { 
      'string'                      => 'String',
      'openstruct'                  => 'OpenStruct',
      'array'                       => 'Array',
      'user'                        => 'Belinkr::User::Member', 
      'profile'                     => 'Belinkr::Profile::Member', 
      'status'                      => 'Belinkr::Status::Member',
      'status::reply'               => 'Belinkr::Reply::Member',
      'invitation'                  => 'Belinkr::Invitation::Member',
      'workspace'                   => 'Belinkr::Workspace::Member',
      'workspace::invitation'       => 'Belinkr::Workspace::Invitation::Member',
      'workspace::autoinvitation'   => 'Belinkr::Workspace::Autoinvitation::Member',
      'scrapbook'                   => 'Belinkr::Scrapbook::Member',
      'request'                     => 'Belinkr::Request::Member'
    }

    #
    # Mailer Worker
    #

    SMTP = {
      #address:          "smtp.sendgrid.net",
      address:          "smtp.gmail.com",
      port:             587,
      domain:           "belinkr.com",
      user_name:        ENV["MAIL_USER"],
      password:         ENV["MAIL_PASS"],
      authentication:   "plain",
      enable_start_tls: true
    }

    INVITATION_TEMPLATE_EN = 
      "#{File.dirname(__FILE__)}/Workers/Mailer/Templates/invitation.en.html"
    INVITATION_TEMPLATE_ES = 
      "#{File.dirname(__FILE__)}/Workers/Mailer/Templates/invitation.es.html"
    RESET_TEMPLATE_EN = 
      "#{File.dirname(__FILE__)}/Workers/Mailer/Templates/reset.en.html"
    RESET_TEMPLATE_ES = 
      "#{File.dirname(__FILE__)}/Workers/Mailer/Templates/reset.es.html"

    MAILER_TEMPLATES = {
      invitation: {
        en: File.open(INVITATION_TEMPLATE_EN, "r") { |f| f.read },
        es: File.open(INVITATION_TEMPLATE_ES, "r") { |f| f.read }
      },
      reset: {
        en: File.open(RESET_TEMPLATE_EN, "r") { |f| f.read },
        es: File.open(RESET_TEMPLATE_ES, "r") { |f| f.read }
      }
    }
  end # Config
end # Belinkr
