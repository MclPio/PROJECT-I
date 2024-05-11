class CalendarsController < ApplicationController
  before_action :authenticate_user!

  def home
  end

  def redirect
    client = Signet::OAuth2::Client.new(client_options)
    redirect_to(client.authorization_uri.to_s, allow_other_host: true)
  end

  def callback
    client = Signet::OAuth2::Client.new(client_options)
    client.code = params[:code]

    response = client.fetch_access_token!
    print("test output ------->#{client}")
    session[:authorization] = response

    redirect_to root_path
  end

  # def calendars
  #   client = Signet::OAuth2::Client.new(client_options)
  #   client.update!(session[:authorization])

  #   service = Google::Apis::CalendarV3::CalendarService.new
  #   service.authorization = client

  #   @calendar_list = service.list_calendar_lists

  #   #Example implementation of refreshing access token
  # rescue Google::Apis::AuthorizationError
  #   response = client.refresh!

  #   session[:authorization] = session[:authorization].merge(response)

  #   retry
  # end

  private

  def client_options
    {
      client_id: Figaro.env.google_client_id,
      client_secret: Figaro.env.google_client_secret,
      authorization_uri: "https://accounts.google.com/o/oauth2/auth",
      token_credential_uri: "https://oauth2.googleapis.com/token",
      scope: 'https://www.googleapis.com/auth/calendar.app.created',
      redirect_uri: callback_url
    }
  end
end
