class BlacklistedToken < ApplicationRecord
    validates :token, presence: true
end
