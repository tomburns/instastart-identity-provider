key_id_prefix = 'layer:///keys/'
key_id = ENV['LAYER_KEY_ID']
ENV['LAYER_KEY_ID'] = "#{key_id_prefix}#{key_id}" unless !key_id || key_id.starts_with?(key_id_prefix)

provider_id_prefix = 'layer:///providers/'
provider_id = ENV['LAYER_PROVIDER_ID']
ENV['LAYER_PROVIDER_ID'] = "#{provider_id_prefix}#{provider_id}" unless !provider_id || provider_id.starts_with?(provider_id_prefix)