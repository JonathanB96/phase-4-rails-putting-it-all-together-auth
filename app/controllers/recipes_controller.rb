class RecipesController < ApplicationController
    rescue_from  ActiveRecord::RecordNotFound, with: :not_found

    def index 
      
        user = User.find(session[:user_id])
        recipes = Recipe.all

        if user 
            render json: recipes, include: :user
        else
            render json: {errors: ["unauthorized"]}, status: :unauthorized
        end
    end

    def create
        user = User.find(session[:user_id])
        if user 
            recipe = user.recipes.create(recipe_params)
            if recipe.valid?
                render json: recipe, include: :user, status: :created
            else
                render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
            end    
            
        else
            render json: {errors: ["Not authorized"]}, status: :unauthorized
        end

       
    end

    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end

    def not_found
        render json: {errors: ["not authorized"]}, status: :unauthorized
   
    end
end
