class SessionsController < ApplicationController
    rescue_from  ActiveRecord::RecordNotFound, with: :not_found
    def create
        user = User.find_by(username: params[:username])
        if user&.authenticate(params[:password]) 
            session[:user_id]||= user.id
            render json: user
        else
            render json: {errors: ["not authorized"]}, status: :unauthorized
        end
    end
    def destroy
        user = User.find(session[:user_id])
        if user
            session.delete :user_id
            head :no_content
        else
            render json: {errors: ["not authorized"]}, status: :unauthorized
        end
    end

    private

    def not_found
        render json: {errors: ["not authorized"]}, status: :unauthorized
   
    end

end
