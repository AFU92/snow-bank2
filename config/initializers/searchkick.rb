# frozen_string_literal: true

# Searchkick client bootstrap
# - Reads SEARCH_URL from ENV (eg. http://localhost:9200 or http://search:9200 in Docker)
# - Safe no-op if SEARCH_URL is not present
#
# Useful envs:
#   SEARCH_URL=http://localhost:9200
#   RAILS_LOG_TO_STDOUT=true
#
# Gem deps:
#   gem "searchkick"
#   gem "elasticsearch"

if ENV["SEARCH_URL"].present?
  require "elasticsearch"

  Searchkick.client = Elasticsearch::Client.new(
    url: ENV["SEARCH_URL"],
    transport_options: { request: { timeout: 10 } }, # 10s timeout
    retry_on_failure: 2
  )

  Rails.logger.info("[searchkick] Client configured for #{ENV['SEARCH_URL']}")
else
  Rails.logger.warn("[searchkick] SEARCH_URL not set; Searchkick disabled")
end
