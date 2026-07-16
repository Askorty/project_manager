# typed: strict

class ApplicationController
  sig { returns(T.nilable(User)) }
  def current_user; end

  sig { void }
  def authenticate_user!; end
end

class User
  sig { params(modules: T.untyped).void }
  def self.devise(*modules); end
end
