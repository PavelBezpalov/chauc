class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  before_action :set_last_started_lot
  before_action :set_bidder
  before_action :set_winning_bid

  def start!(*)
    if @last_started_lot
      if @last_started_lot.photos.any?
        respond_with :photo, photo: File.open(ImageUploader.storages[:store].path(@last_started_lot.photos.first.image.id)),
                     caption: lot_text,
                     parse_mode: "HTML",
                     reply_markup: {
                       inline_keyboard: lot_inline_keyboard
                     }
      else
        respond_with :message, **lot_response
      end
    else
      respond_with :message, text: "Немає активних лотів.",
                   reply_markup: {
                     inline_keyboard: [
                       [{ text: 'Оновити', callback_data: 'reload' }]
                     ],
                   }
    end
  end

  def callback_query(data)
    if data == 'reload'
      respond_with :message, text: "Оновлено о #{Time.current.in_time_zone("Europe/Kiev").to_formatted_s(:short)}"
    elsif data.start_with?('raise') && lot_bidding_active
      bid_amount = data.split(':').last.to_i
      if @winning_bid && @winning_bid.amount >= bid_amount
        respond_with :message, "Ваша ставка не прийнята. Вже хтось запропонував більше."
      else
        if @winning_bid && @winning_bid.bidder != @bidder
          send_message_to_last_winning_bidder
        end
        @winning_bid = Bid.create(bidder: @bidder, lot: @last_started_lot, amount: bid_amount)
        respond_with :message, text: "Ваша ставка прийнята."
      end
    end
    start!
  end

  private

  def set_last_started_lot
    @last_started_lot = Lot.order(:id).where(start_time: ..Time.current).last
  end

  def set_bidder
    @bidder = Bidder.create_or_update(from)
  end

  def set_winning_bid
    @winning_bid =
      if @last_started_lot
        @last_started_lot.bids.order(:amount).last
      else
        nil
      end
  end

  def lot_response
    {
      text: lot_text,
      parse_mode: "HTML",
      reply_markup: {
        inline_keyboard: lot_inline_keyboard,
      }
    }
  end

  def lot_text
    <<-TEXT
<b>#{@last_started_lot.name}</b>
#{@last_started_lot.description}

#{lot_time_text}

#{lot_price_message}
    TEXT
  end

  def lot_time_text
    if lot_bidding_active
      "Ставки приймаються до #{@last_started_lot.end_time.in_time_zone("Europe/Kiev").to_formatted_s(:short)}"
    else
      "Аукціон закінчився."
    end
  end

  def lot_price_message
    if @winning_bid
      message = "Виграшна ставка #{@winning_bid.amount} гривень. Всього #{@last_started_lot.bids.count} ставок."
      if @winning_bid.bidder == @bidder
        if lot_bidding_active
          message += "\n<b>Ваша ставка виграє.</b>"
        else
          message += "\n<b>Ваша ставка перемогла! Продавець скоро зв'яжеться з вами.</b>"
        end
      end
      message
    else
      "Стартова ціна #{@last_started_lot.start_price} гривень. Ставок немає."
    end
  end

  def next_bid_amount
    if @winning_bid
      @winning_bid.amount + 100
    else
      @last_started_lot.start_price
    end
  end

  def lot_inline_keyboard
    menu_items = [
      [{ text: 'Оновити', callback_data: 'reload' }]
    ]
    if @bidder.user? && lot_bidding_active
      menu_items.push(
        [{ text: "Поставити #{next_bid_amount}", callback_data: "raise:#{next_bid_amount}" }]
      )
    end
    if @bidder.owner? && @winning_bid && lot_bidding_finished
      menu_items.push(
        [{ text: "Написати переможцю", url: "tg://user?id=#{@winning_bid.bidder.telegram_id}" }]
      )
    end
    menu_items
  end

  def lot_bidding_active
    @last_started_lot && @last_started_lot.end_time > Time.current
  end

  def lot_bidding_finished
    @last_started_lot && @last_started_lot.end_time < Time.current
  end

  def send_message_to_last_winning_bidder
    last_winning_bidder_id = @winning_bid.bidder.telegram_id
    bot.send_message chat_id: last_winning_bidder_id,
                     text: 'Вашу ставку перебито.'
    if @last_started_lot.photos.any?
      bot.send_photo chat_id: last_winning_bidder_id,
                     photo: File.open(ImageUploader.storages[:store].path(@last_started_lot.photos.first.image.id)),
                     caption: lot_text,
                     parse_mode: "HTML",
                     reply_markup: {
                       inline_keyboard: lot_inline_keyboard
                     }
    else
      bot.send_message chat_id: last_winning_bidder_id, **lot_response
    end
  end
end
