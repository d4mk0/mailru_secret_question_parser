class Parser
  MAX_ATTEMPTS = 3
  
  def initialize
    @http = Net::HTTP.new('e.mail.ru')
    @path = '/api/v1/user/password/restore'
    @request_params = {
      ajax_call: 1,
      'x-email' => '',
      htmlencoded: false,
      api: 1,
      token: ''
    }
  end
  
  def start
    @list = User.unsuccessfulls
    attempts = 0
    @list.each_with_index do |user, i|
      p @response = ActiveSupport::JSON.decode(@http.post(@path, @request_params.merge(email: user.mail).to_param).body)
      update_hash = {
        is_phone_assigned: @response['body']['phone'].blank?,
        response_status: @response['status']
      }
      p attempts
      if @response['body'].present? && @response['body']['retry_after'].present? && attempts < MAX_ATTEMPTS
        attempts += 1
        sleep @response['body']['retry_after'].to_i+1
        redo 
      end
      if @response['status'].to_i != 200 && attempts < MAX_ATTEMPTS
        attempts += 1
        sleep 6
        redo 
      end
      update_hash.merge! question: @response['body']['secret'] if update_hash[:is_phone_assigned]
      user.update_attributes update_hash
      attempts = 0
    end
  end
end