class SendTransactionalSms < BaseService
  SENDER_NAME = "RdvRSA".freeze

  def initialize(phone_number:, content:)
    @phone_number = phone_number
    @content = content
  end

  def call
    send_transactional_sms
  end

  private

  def send_transactional_sms
    api_instance = SibApiV3Sdk::TransactionalSMSApi.new
    api_instance.send_transac_sms(transactional_sms)
  end

  def transactional_sms
    SibApiV3Sdk::SendTransacSms.new(
      sender: SENDER_NAME,
      recipient: @phone_number,
      content: @content,
      type: "transactional"
    )
  end
end
