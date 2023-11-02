# frozen_string_literal: true

# sorcery
module Sorcery
  # Credential module
  module Credential
    extend ActiveSupport::Concern

    included do
      helper_method :sorcery_fetch_user_hash
    end

    # get the user hash from a provider using information from the params and session.
    def sorcery_fetch_user_hash(provider_name)
      sorcery_init_user_hash(provider_name)

      if provider_name == 'google' && params[:credential].present?
        sorcery_get_google_user_hash(params[:credential])
      else
        sorcery_fetch_provider_user_hash
      end
      nil
    end

    # the application should never ask for user hashes from two different providers
    # on the same request.  But if they do, we should be ready: on the second request,
    # clear out the instance variables if the provider is different
    def sorcery_init_user_hash(provider_name)
      provider = sorcery_get_provider provider_name
      return unless @provider.nil? || @provider != provider

      @provider = provider
      @access_token = nil
      @user_hash = nil
    end

    def sorcery_get_google_user_hash(credential)
      @user_hash = {}
      @user_hash[:user_info] =
        Google::Auth::IDTokens.verify_oidc(credential,
                                           aud: Rails.application.config.sorcery.google.key)
      @user_hash[:uid] = @user_hash[:user_info]['sub']
    end

    # delegate to the provider for the access token and the user hash.
    # cache them in instance variables.
    # rubocop: disable Naming/MemoizedInstanceVariableName
    def sorcery_fetch_provider_user_hash
      # sends request to oauth agent to get the token
      @access_token ||= @provider.process_callback(params, session)
      # uses the token to send another request to the oauth agent requesting user info
      @user_hash ||= @provider.get_user_hash(@access_token)
    end
    # rubocop: enable Naming/MemoizedInstanceVariableName
  end
end
