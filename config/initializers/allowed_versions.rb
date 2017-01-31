ALLOWED_VERSIONS = YAML.load_file("#{Rails.root}/config/versions.yml")[Rails.env]['allowed_versions']
