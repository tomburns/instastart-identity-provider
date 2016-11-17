module UsersHelper
  def app_has_admin?
    User.where(is_admin: true).count > 0
  end
end