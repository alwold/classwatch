STRIPE_CONFIG = YAML.load_file("#{Rails.root}/config/stripe.yml")[Rails.env]
