# frozen_string_literal: true
#
# Simple OpenAI client wrapper
# ----------------------------
# - Reads the API key from ENV["OPENAI_API_KEY"].
# - Returns nil if the client is not configured (no API key) or on errors.
# - Example usage:
#     client = OpenaiClient.new
#     summary = client.summarize("Texto a resumir...")
#
# Gem: ruby-openai
# Docs: https://github.com/alexrudall/ruby-openai

class OpenaiClient
  def initialize(access_token: ENV["OPENAI_API_KEY"])
    return unless access_token.present?

    @client = OpenAI::Client.new(access_token: access_token)
  end

  def enabled?
    !!@client
  end

# Summarizes the given Spanish text into a short paragraph.
  def summarize(text)
    return nil unless enabled?

    response = @client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [
          { role: "system", content: "You are a concise assistant. Summarize the user's Spanish text in one short paragraph." },
          { role: "user",   content: text.to_s }
        ],
        temperature: 0.2
      }
    )

    response.dig("choices", 0, "message", "content")
  rescue => e
    Rails.logger.warn("[OpenaiClient] summarize error: #{e.class}: #{e.message}")
    nil
  end
end
