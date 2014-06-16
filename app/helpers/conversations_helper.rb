# encoding: utf-8
module ConversationsHelper

  def conversation_label(conversation, options={})
    label = Mailboxer::Label.find(conversation.mailboxer_label_id)
    content_tag :span, class: "lbl--chip lbl lbl--#{label.color} #{options[:class]}" do
    end
  end

  def conversation_label_name(conversation)
    label = Mailboxer::Label.find(conversation.mailboxer_label_id)
    I18n.t(label.name).pluralize(2)
  end

  # Tells wether or not the admin has responded to the message
  #
  # @return Boolean
  def conversation_waiting_for_reply? conversation
    if conversation.mailboxer_label_id == Mailboxer::Label::INFORMATION.id
      senders = conversation.messages.map(&:sender).compact.uniq
      if senders.length == 1 and !conversation.treated_by_phone
        return true
      end
    end
    return false
  end

end
