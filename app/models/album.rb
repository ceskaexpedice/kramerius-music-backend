class Album < ApplicationRecord
    has_many :tracks, dependent: :destroy
end
