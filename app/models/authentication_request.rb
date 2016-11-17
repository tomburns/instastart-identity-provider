class AuthenticationRequest
  def initialize(email, password)
    @email = email
    @password = password
  end

  def user
    @user ||= User.find_by_email(@email)
  end

  def valid?
    user && user.authenticate(@password)
  end
end