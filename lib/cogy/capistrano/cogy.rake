namespace :cogy do
  desc "Invoke the Cog Trigger that will install the Cogy-generated bundle"
  task :notify_cog do
    require "net/http"
    require "timeout"
    require "json"

    trigger_url = fetch(:cogy_release_trigger_url)
    cogy_endpoint = Cogy.cogy_endpoint

    begin
      raise ":cogy_release_trigger_url must be set" if trigger_url.nil?
      raise "Cogy.cogy_endpoint must be set" if cogy_endpoint.nil?

      Timeout.timeout(fetch(:cogy_trigger_timeout) || 7) do
        url = URI(trigger_url)
        res = Net::HTTP.post_form(url, url: cogy_endpoint)

        if !res.is_a?(Net::HTTPSuccess)
          error = JSON.parse(res.body)["errors"]["error_message"]
          if error !~ /version has already been taken/
            puts "Error response (#{res.code}) from Cog trigger: #{error}"
          end
        end
      end
    rescue => e
      puts "Error invoking Cog trigger: #{e.class} #{e.message}"
    end
  end
end
