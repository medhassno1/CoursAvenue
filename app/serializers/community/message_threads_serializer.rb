class Community::MessageThreadsSerializer < ActiveModel::Serializer

  cached
  def cache_key
    'Community::MessageThreadsSerializer/' + object.cache_key + '/' + object.conversation.try(:cache_key).to_s
  end

  attributes :id, :community_id, :question, :answers

  has_one :question, serializer: Community::MessageSerializer
  has_many :answers, serializer: Community::MessageSerializer

  def question
    @options[:thread_id] = object.id
    (object.conversation ? object.conversation.messages.order('created_at ASC').first : nil)
  end

  def answers
    @options[:thread_id] = object.id
    (object.conversation ? object.conversation.messages.order('created_at ASC')[1..-1] : [])
  end
end
