class Order < ApplicationRecord
    has_many :order_items, dependent: :destroy
    validates :payment_method, presence: true
end
