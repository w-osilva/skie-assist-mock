# frozen_string_literal: true

module Api
  module Internal
    class GptController < ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        Message.create!(message_params)

        # run the job in a separate thread to avoid blocking the request
        Thread.new do
          sleep 3

          PostMessageJob.new.perform
        end

        render json: {
          status: 'sent',
          success: true
        }, status: :ok
      rescue StandardError => e
        render json: {
          status: 'error',
          success: false,
          message: e.message
        }, status: :unprocessable_content
      end

      private

      def message_params
        {
          metadata: params.require(:metadata).to_json,
          messages: params.require(:messages).to_json
        }
      end
    end
  end
end