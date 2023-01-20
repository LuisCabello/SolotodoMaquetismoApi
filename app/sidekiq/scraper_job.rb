# Paso 1
# Start scraper, this will get the initial pages of each store

class ScraperJob
  include Sidekiq::Job

  def perform(_arg)
    stores = Store.all

    stores.each do |store|
      if store.blank?
        print("There are no pages, can't start scraper")
      else
        print("\n Star Scraping " + store[:name] + " \n")
        ScraperPageMiraxJob.perform_async(store[:url])
      end
    end
  end
end
