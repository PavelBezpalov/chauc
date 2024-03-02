class Bid < ApplicationRecord
  belongs_to :bidder
  belongs_to :lot

  after_save :sniping_check

  private

  def sniping_check
    return if created_at + 5.minutes < lot.end_time

    lot.update(end_time: lot.end_time + 10.minutes)
  end
end
