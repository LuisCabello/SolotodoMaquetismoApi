# Step 1
# Start scraper, this will get the initial pages of Mirax Store
class ScraperJobMirax
  include Sidekiq::Job

  def perform(_arg)
    store = Store.get_store_by_name('Mirax Hobbies')

    if store.present?
      if store.blank?
        print("There are no pages, can't start scraper")
      else
        print("\n Start Scraping #{store[:name]}  \n")
        ScraperPageMiraxJob.perform_async(store[:url], store[:id])
      end
    else
      print('No stores found')
    end
  rescue StandardError => e
    Rails.logger.error "Error en scraper_job_mirax Step 1 : #{e.message}\n#{e.backtrace.join("\n")}"
  end
end

# Revisar los errores, pueden ser diferentes en modo Produccion "rescue StandardError" Revisar Modo Debug 