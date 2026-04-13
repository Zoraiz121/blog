class ClientsController < ApplicationController
  # This action receives query string parameters from an HTTP GET request
  # at the URL "/clients?status=activated"
  def index
    if params[:status] == "activated"
      @clients = Client.activated
    else
      @clients = Client.inactivated
    end
  end

  # This action receives parameters from a POST request to "/clients" URL with  form data in the request body.
  def create
    @client = Client.new(params[:client])
    if @client.save
      redirect_to @client
    else
      render "new"
    end
  end
end
