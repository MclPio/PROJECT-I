class CalendarsController < ApplicationController
  before_action :authenticate_user!

  def home
  end

  def redirect
    client = Signet::OAuth2::Client.new(client_options)
    redirect_to(client.authorization_uri, allow_other_host: true)
  end

  def callback
    client = Signet::OAuth2::Client.new(client_options)
    client.code = params[:code]

    response = client.fetch_access_token!
    # response contains (access_token, expires_in, refresh_token, token_type, granted scopes)
    session[:authorization] = response
    store_refresh_token(response["refresh_token"])
    redirect_to root_path
  end

  def show
    refresh_token = current_user.refresh_token

    client = Signet::OAuth2::Client.new(
      token_credential_uri: "https://oauth2.googleapis.com/token",
      client_id: Figaro.env.google_client_id,
      client_secret: Figaro.env.google_client_secret,
      refresh_token: refresh_token
    )

    client.refresh!

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @calendar_list = service.get_calendar('need to store result.id to access created calendar')
    puts "----------------------------------------------_>>>>>>>#{@calendar_list}"

    #Example implementation of refreshing access token
  # rescue Google::Apis::AuthorizationError
  #   response = client.refresh!

  #   session[:authorization] = session[:authorization].merge(response)

  #   retry
  end

  def insert
    refresh_token = current_user.refresh_token

    client = Signet::OAuth2::Client.new(
      token_credential_uri: "https://oauth2.googleapis.com/token",
      client_id: Figaro.env.google_client_id,
      client_secret: Figaro.env.google_client_secret,
      refresh_token: refresh_token
    )

    client.refresh!

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    calendar = Google::Apis::CalendarV3::Calendar.new(
      summary: 'calendarSummary',
      time_zone: 'Canada/Eastern'
    )

    result = service.insert_calendar(calendar)
    puts "New calendar ID: #{result.id}"

    redirect_to root_path
  end

  private

  def client_options
    {
      authorization_uri: "https://accounts.google.com/o/oauth2/auth",
      token_credential_uri: "https://oauth2.googleapis.com/token",
      client_id: Figaro.env.google_client_id,
      client_secret: Figaro.env.google_client_secret,
      scope: 'https://www.googleapis.com/auth/calendar.app.created',
      redirect_uri: callback_url
    }
  end

  def store_refresh_token(refresh_token)
    current_user.update(refresh_token: refresh_token)
    puts "_----------> REFRESh TOKEN STORED"
  end
end
