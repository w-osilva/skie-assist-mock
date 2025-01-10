# frozen_string_literal: true

namespace :skie_assist do
  desc 'Post a message to a topic'
  task answer_last_message: :environment do
    PostMessageJob.new.perform
  end
end
