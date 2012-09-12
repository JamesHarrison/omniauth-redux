require 'omniauth'
require 'bbc_redux'

module OmniAuth
  module Strategies
    class Redux
      class InvalidDetails  < Exception; end       # Bad username or password
      class AccountLocked   < Exception; end       # Auth Service has locked account
      include OmniAuth::Strategy

      args []
      option :title,   "BBC Redux"

      def request_phase
        OmniAuth::Form.build(:title => options.title, :url => callback_path) do
          text_field 'Username', 'username'
          password_field 'Password', 'password'
        end.to_response
      end

      def callback_phase
        begin
          redux_user
        rescue InvalidDetails
          fail!(:invalid_credentials)
        rescue AccountLocked
          fail!(:account_locked)
        end
        return fail!(:invalid_credentials) if !redux_user
        super
      end
      uid { @redux_user.id }
      info do
        {
          'id'         => @redux_user.id,
          'nickname'   => @redux_user.username,
          'last_name'  => @redux_user.last_name,
          'first_name' => @redux_user.first_name,
          'email'      => @redux_user.email
        }
      end
      credentials do
        { 'token' => @redux_user.session.token }
      end


      protected

        def username
          request['username']
        end

        def password
          request['password']
        end

        def redux_user
          unless @redux_user
            return unless username && password
            @auth_service ||= BBC::Redux::Client.new
            begin
              @redux_user = auth_service.login username, password
            rescue BBC::Redux::Exceptions::UserNotFoundException, # Bad username
                   BBC::Redux::Exceptions::UserPasswordException # Bad password
              raise InvalidDetails
            rescue BBC::Redux::Exceptions::ClientHttpException => e
              raise AccountLocked if e.message =~ /^409/
            end
          end
          @redux_user
        end

    end
  end
end
