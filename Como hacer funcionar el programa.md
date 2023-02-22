Comando para ejecutar solotodo Maquetas : 

1) rails s = Levantamos el servidor

2) Para iniciar el sidekiq tenemos que correr radis en Ubuntu (Recordar que podemos instalar una aplicacion aparte) , se crear otro terminal y ejecutamos : 

redis-server = Levantamos la base de datos Redis

-Recordar que si iniciamos el sidekiq, empiezan a correr las tareas que estan en memoria ? 

bundle exec sidekiq = Corremos el Sidekiq

3)Para poder ejecutar un script individual de sidekiq tenemos que abrir el terminal y ejecutamos el archivo.

  rails console = Ejecutamos la consola de rails

-Ejecutamos el comando de la siguiente manera 

ScraperJob.perform_sync("") = Nombre del archivo con mayuscula y sin espacios, luego el metodo perform_sync("") en caso de que lo quieras de forma asincrona(te muestra los print de esta manera)

ScraperJob.perform_async("") = asi lo ejecutamos de forma asincrona, los resultados o los print te los muestra en la consola donde estas corriendo el sidekiq

Segundo ejemplo : ScraperProductJob.perform_sync("https://www.mirax.cl/detalles.php?codigo=251969"), asi le pasamos el url de una pagina para que haga el scraping


-Los cambios cuando esta la consola abierta no se muestran, hay que sacar y entrar de nuevo


**Para ver la base de datos, abrimos PostgreSql

Las claves son admin y admin

Ultimas pruebas de hoy
ScraperCategoryMiraxJob.perform_sync("https://www.mirax.cl/index.php?menu=300")
ScraperProductJob.perform_sync("https://www.mirax.cl/detalles.php?codigo=251969", "tanque", "Maquetas", 1)