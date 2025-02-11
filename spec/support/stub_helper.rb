module StubHelper
  def stub_rdv_solidarites_create_user(rdv_solidarites_user_id)
    stub_request(:post, "#{ENV['RDV_SOLIDARITES_URL']}/api/v1/users")
      .to_return(status: 200, body: { "user" => { "id" => rdv_solidarites_user_id } }.to_json)
  end

  def stub_rdv_solidarites_assign_organisations(rdv_solidarites_user_id)
    stub_request(
      :post, "#{ENV['RDV_SOLIDARITES_URL']}/api/rdvinsertion/user_profiles/create_many"
    ).to_return(
      status: 200,
      body: {
        user: { id: rdv_solidarites_user_id }
      }.to_json
    )
  end

  def stub_rdv_solidarites_assign_referents(rdv_solidarites_user_id)
    stub_request(
      :post, "#{ENV['RDV_SOLIDARITES_URL']}/api/rdvinsertion/referent_assignations/create_many"
    ).to_return(
      status: 200,
      body: {
        user: { id: rdv_solidarites_user_id }
      }.to_json
    )
  end

  def stub_rdv_solidarites_update_user(rdv_solidarites_user_id)
    stub_request(
      :patch, "#{ENV['RDV_SOLIDARITES_URL']}/api/v1/users/#{rdv_solidarites_user_id}"
    ).to_return(
      status: 200,
      body: {
        user: { id: rdv_solidarites_user_id }
      }.to_json
    )
  end

  def stub_rdv_solidarites_invitation_requests(rdv_solidarites_user_id, rdv_solidarites_token = "123456")
    stub_request(:post, "#{ENV['RDV_SOLIDARITES_URL']}/api/v1/users/#{rdv_solidarites_user_id}/rdv_invitation_token")
      .with(
        headers: { "Content-Type" => "application/json" }.merge(rdv_solidarites_auth_headers_with_shared_secret(agent))
      )
      .to_return(body: { "invitation_token" => rdv_solidarites_token }.to_json)
  end

  def stub_geo_api_request(address)
    stub_request(:get, RetrieveGeolocalisation::API_ADRESSE_URL).with(
      headers: { "Content-Type" => "application/json" },
      query: { "q" => address }
    ).to_return(body: { "features" => [] }.to_json)
  end

  def stub_brevo
    stub_request(:post, "https://api.sendinblue.com/v3/transactionalSMS/sms")
      .to_return(status: 200)
  end

  def stub_user_creation(rdv_solidarites_user_id)
    stub_rdv_solidarites_create_user(rdv_solidarites_user_id)
    stub_rdv_solidarites_assign_organisations(rdv_solidarites_user_id)
    stub_rdv_solidarites_assign_referents(rdv_solidarites_user_id)
    stub_rdv_solidarites_update_user(rdv_solidarites_user_id)
    stub_brevo
    stub_rdv_solidarites_invitation_requests(rdv_solidarites_user_id)
    stub_geo_api_request("127 RUE DE GRENELLE 75007 PARIS")
  end

  def stub_sync_with_rdv_solidarites_user(rdv_solidarites_user_id)
    stub_rdv_solidarites_assign_organisations(rdv_solidarites_user_id)
    stub_rdv_solidarites_assign_referents(rdv_solidarites_user_id)
    stub_rdv_solidarites_update_user(rdv_solidarites_user_id)
  end

  def rdv_solidarites_auth_headers_with_shared_secret(agent)
    agent.send(:rdv_solidarites_auth_headers_with_shared_secret)
  end
end
