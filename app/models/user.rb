class User < ApplicationRecord
    has_secure_password

    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }
    validates :role, presence: true, inclusion: { in: %w(client admin), message: "%{value} is not a valid role" }

    before_validation :set_default_role, on: :create

    private

    def set_default_role
        self.role ||= 'client'
    end
end
