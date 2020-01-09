# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)

# Prevent database truncation if the environment is production
if Rails.env.production?
  abort('The Rails environment is running in production mode!')
end
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

require 'devise'

## ajaxのテスト用
# require 'capybara/rails'
# require 'capybara/rspec'
# Capybara.javascript_driver = :webkit

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

# include Warden::Test::Helpers

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.

  ## ajaxのテストの際はfalse
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")



  ## ajaxのテストの補助
  # # suite: RSpecコマンドでテストを実行する単位
  # # all:  各テストファイル(xxx_spec.rb)単位
  # # each: 各テストケース(it)単位
  # config.before(:suite) do
  #   DatabaseCleaner.clean_with :truncation  # テスト開始時にDBをクリーンにする
  # end

  # # js以外のテスト時は通常のtransactionでデータを削除する
  # config.before(:each) do
  #   DatabaseCleaner.strategy = :transaction
  # end

  # # jsのテスト時はtruncationで削除する
  # config.before(:each, js: true) do
  #   DatabaseCleaner.strategy = :truncation
  # end

  # config.before(:each) do
  #   DatabaseCleaner.start
  # end

  # config.after(:each) do
  #   DatabaseCleaner.clean
  # end

  # config.after(:all) do
  #   DatabaseCleaner.clean_with :truncation # all時にDBをクリーンにする
  # end

  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers, type: :request

  ## ajaxのテスト用
  # config.include SystemSpecHelper, type: :system
  # config.include WaitForAjax, type: :system
  # config.include WaitForCss, type: :system

  ## system spec用のブラウザ設定
  # config.before(:each) do |example|
  #   if example.metadata[:type] == :system
  #     driven_by :selenium, using: :headless_chrome, options: { args: ["headless", "disable-gpu", "no-sandbox", "disable-dev-shm-usage"] }
  #   end
  # end
end
