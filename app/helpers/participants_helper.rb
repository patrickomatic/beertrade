module ParticipantsHelper
  def shipping_info_url(shipping_info)
    case TrackingNumber.new(shipping_info).carrier
    when :ups
      "https://wwwapps.ups.com/WebTracking/track?track=yes&trackNums=#{shipping_info}"
    when :fedex
      "https://www.fedex.com/apps/fedextrack/index.html?tracknumbers=#{shipping_info}&cntry_code=us"
    when :usps
      "https://tools.usps.com/go/TrackConfirmAction?qtc_tLabels1=#{shipping_info}"
    when :dhl
      "http://www.dhl.com/content/g0/en/express/tracking.shtml?brand=DHL&AWB=#{shipping_info}"
    when :ontrac
      "https://www.ontrac.com/trackingres.asp?tracking_number=#{shipping_info}"
    else
      logger.error "Unknown carrier for tracking number: #{shipping_info}"
    end
  end


  def class_for_feedback_text(feedback_type)
    {"positive"  => "text-success",
     "neutral"   => "text-warning",
     "negative"  => "text-danger", }[feedback_type]
  end

  def glyphicon_for_feedback(feedback_type)
    {"positive"  => "glyphicon-ok",
     "neutral"   => "glyphicon-minus",
     "negative"  => "glyphicon-remove", }[feedback_type]
  end


  def trade_status_message(trade)
    return nil if trade.completed?

    waiting_for = if trade.accepted?
                    trade.participants.pending.map(&:other_participant).map(&:user)
                  else
                    trade.participants.not_yet_accepted.map(&:user)
                  end

    waiting_for = waiting_for.map {|u| link_to u.username, u}.join(' and ')

    ((trade.accepted? ? "waiting for feedback from "
                      : "trade not yet accepted by ") << waiting_for).html_safe
  end
end
