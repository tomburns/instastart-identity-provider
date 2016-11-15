module ApplicationHelper
  def key_id?
    !layer_key_id.blank?
  end

  def provider_id?
    !layer_provider_id.blank?
  end

  def private_key?
    !layer_private_key.blank?
  end
end
