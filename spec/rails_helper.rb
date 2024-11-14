# frozen_string_literal: true

# Este arquivo é copiado para spec/ quando você executa 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'shoulda/matchers'
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'simplecov'

# Carrega todos os arquivos de suporte
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |file| require file }

SimpleCov.start

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Inclui helpers personalizados para controller specs
  config.include Request::JsonHelpers, type: :controller
  config.include Request::HeadersHelpers, type: :controller

  # Inclui os helpers do Devise apenas para controller specs
  config.include Devise::Test::ControllerHelpers, type: :controller

  # Inclui os helpers de integração do Devise para request specs
  config.include Devise::Test::IntegrationHelpers, type: :request

  # Configuração antes de cada controller spec
  config.before(:each, type: :controller) do
    include_default_accept_headers
  end

  # Configuração antes de cada request spec
  config.before(:each, type: :request) do
    host! 'api.lvh.me:8080'
  end

  # Caminho para fixtures
  config.fixture_path = Rails.root.join('spec/fixtures')

  # Usa fixtures transacionais
  config.use_transactional_fixtures = true

  # Infere o tipo de spec a partir da localização do arquivo
  config.infer_spec_type_from_file_location!

  # Filtra backtraces do Rails
  config.filter_rails_from_backtrace!

  # Outras configurações específicas podem ser adicionadas aqui
end

# Configuração do Shoulda Matchers
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
