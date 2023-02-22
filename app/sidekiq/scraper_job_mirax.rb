# Step 1
# Start scraper, this will get the initial pages of each store

class ScraperJobMirax
  include Sidekiq::Job

  def perform(_arg)
    @stores = Store.new
    all_stores = @stores.getStores

    if all_stores.present?
      all_stores.each do |store|
        if store.blank?
          print("There are no pages, can't start scraper")
        else
          print("\n Start Scraping #{store[:name]}  \n")
          ScraperPageMiraxJob.perform_async(store[:url], store[:id])
        end
      end
    else
      print('No stores found')
    end
  rescue StandardError => e
    Rails.logger.error "Error en scraper_job_mirax Step 1 : #{e.message}\n#{e.backtrace.join("\n")}"
  end
end
