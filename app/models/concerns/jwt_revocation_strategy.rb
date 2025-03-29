module JwtRevocationStrategy
  def self.jwt_revoked?(payload, user)
    false  # No revocation logic for now
  end

  def self.revoke_jwt(payload, user)
    # Implement revocation logic later
  end
end
