class UsersController < ApplicationController
    rescue_from  ActiveRecord::RecordNotFound, with: :not_found
        def create
            user = User.create(user_params)
            session[:user_id] ||= user.id 
            if user.valid?
              render json: user, status: :created
            else
              render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
            end
           
    
        end
    
        def show
            user = User.find(session[:user_id])
            if user
                render json: user
            else
                render json: {error: "not authorized"}, status: :unauthorized
            end           
                
        end
    
        private
        def user_params
            params.permit(:username, :password, :password_confirmation)
        end
    
        def not_found
         render json: {error: "not authorized"}, status: :unauthorized
    
        end
    end
    