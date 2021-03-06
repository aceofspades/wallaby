module Wallaby
  EMPTY_STRING = ''.freeze
  EMPTY_HASH = {}.freeze
  EMPTY_ARRAY = [].freeze
  SPACE = ' '.freeze
  SLASH = '/'.freeze
  COLONS = '::'.freeze
  COMMA = ','.freeze
  DOT = '.'.freeze
  CSV = 'csv'.freeze
  PERS = [10, 20, 50, 100].freeze
  DEFAULT_PAGE_SIZE = 20
  DEFAULT_MAX = 20
  ERRORS = %i(
    bad_request
    forbidden
    internal_server_error
    not_found
    unauthorized
    unprocessable_entity
  ).freeze
  WILDCARD = 'QUERY'.freeze
  FORM_ACTIONS = %w(new create edit update).freeze
  SAVE_ACTIONS = %w(create update).freeze
end

require 'wallaby/engine'
