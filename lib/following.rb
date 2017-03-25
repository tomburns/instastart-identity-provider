require "#{Rails.root}/lib/server_api"

class Following
  def self.create(originator, target)
    if !originator.kind_of?(String)
      raise ArgumentError, 'originator must be a string or an object with an `id` getter' unless (originator = originator.id)
    end
    # `target` can be multiple identities to follow. Normalize into array if not.
    target = [target] unless target.kind_of?(Array)
    # Extract string IDs from `target` if necessary
    target = target.map { |t| t.kind_of?(String) ? t : t.id }
    ServerAPI.new.follow_users(originator, target)
  end
end

class Autofollow
  COUNT_LIMIT = 10

  def self.should_autofollow?
    User.count <= COUNT_LIMIT
  end

  def self.establish_for_user(user)
    user_id = user.kind_of?(String) ? user : user.id
    other_user_ids = User.all.pluck(:id).reject { |id| id == user_id }
    Following.create(user_id, other_user_ids)
  end
end