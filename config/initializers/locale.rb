I18n.load_path += Dir[File.join(Rails.root, 'config', 'locales', '**', '*.{rb,yml}')]
I18n.default_locale = :en
I18n.locale = :en
