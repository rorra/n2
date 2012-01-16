module AuthHelper

  def provider_image_link provider, size = "64"
    valid_sizes = %w{ 32 64 128 256}
    raise Exception.new("Invalid size (#{size}): should be one of #{valid_sizes.inspect}") unless valid_sizes.include?(size)

    html_size = size + "x" + size
    html_alt = provider.to_s.titleize
    provider_name = provider.to_s.downcase.underscore
    file = "authbuttons/#{provider_name}_#{size}.png"
    link_to image_tag(file, :size => html_size, :alt => html_alt), "/auth/#{provider_name}", :class => "auth_provider"
  end

end
