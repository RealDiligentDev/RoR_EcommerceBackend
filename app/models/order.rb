class Order < ApplicationRecord
    belongs_to :client, class_name: 'User'
    has_many :order_items, dependent: :destroy

    validates :payment_method, presence: true
    validates :status, presence: true
end
