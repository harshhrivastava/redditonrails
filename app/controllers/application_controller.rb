class ApplicationController < ActionController::Base

    protect_from_forgery with: :exception
    
    helper_method :authenticate_user!, :current_user, :refresh, :generate_access_token, :generate_refresh_token

    private

    def refresh

        if cookies[:refresh_token]
        
        if token_expired?(decode_refresh_token(cookies[:access_token]))

            decoded_token = decode_refresh_token(cookies[:refresh_token])

            if decoded_token && !token_expired?(decoded_token)

                @current_user = User.find(decoded_token[0][:user_id])

                access_token = generate_access_token(user)

                cookies[:access_token] = {
                value: access_token,
                expires: 10.minutes.from_now,
                httponly: true
                }

            else

                redirect_to login_path

                return

            end

        end
        
        else

            redirect_to login_path

            return

        end

    end

    def generate_access_token(user)

        payload = { user_id: user.id }
        
        expiration = 10.minutes.from_now.to_i
        
        JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256', { exp: expiration })
    
    end

    def generate_refresh_token(user)
    
        payload = { user_id: user.id }
    
        expiration = 30.days.from_now.to_i
    
        JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256', { exp: expiration })
    
    end

    def decode_refresh_token(token)
    
        begin
        
        JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' }).first
    
        rescue JWT::ExpiredSignature

        flash[:alert] = "Session has expired. Please login again."
        
        rescue JWT::DecodeError
        
        flash[:alert] = "There was some error. You need to log in again."

        end
    
    end

    def token_expired?(token)

        if token[1]['exp']

        Time.at(token[1]['exp']) < Time.now

        end

    end

    def authenticate_user!

        if current_user.nil?
            
            flash[:notice] = "You need to log in."
        
        end

    end

    def current_user
    
        if token_payload

            @current_user ||= User.find(token_payload[0][:user_id].to_i)

        end

    end

    def token_payload

        token_payload ||= begin

            if cookies[:access_token]

                begin

                    JWT.decode(cookies[:access_token], Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')

                rescue JWT::ExpiredSignature

                    flash[:notice] = "You need to log in again."

                rescue JWT::DecodeError

                    flash[:alert] = "Bad request."

                end

            else

                refresh

            end
        
        end

    end

end
