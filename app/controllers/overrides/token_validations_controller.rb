module Overrides
    class TokenValidationsController < DeviseTokenAuth::TokenValidationsController
      def validate_token
        if @resource
          render json: {
            data: {
                id: @resource.id,
                uid: @resource.uid,
                email: @resource.email,
                image: @resource.image,
                name: @resource.name,
                roles: @resource.roles
            }
          }
        else
          render json: {
            success: false,
            errors: ["Invalid login credentials"]
          }, status: 401
        end
      end
    end
  end