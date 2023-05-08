# README

Tarea para postular a Bsale, se necesita crear un programa que realice una simulación de check-in.

# Funcionamiento del proyecto

Se nos entrega los siguientes aviones : 

![image](https://user-images.githubusercontent.com/46609963/229935509-31a74513-a47f-40a0-89d5-29426a98dddc.png)

Para llenar los aviones se hizo lo siguiente:

1) Según el id de vuelo que se obtiene por petición GET, se inicia la creación del avión y se crean sus asientos.
2) Luego de tener generada la matriz que simula ser el avión, se sentarán las personas que ya tienen su pasaje comprado, quedando de la siguiente manera:

![image](https://user-images.githubusercontent.com/46609963/229935977-b923e654-f221-4bfe-83c3-e5b84a2e832f.png)
![image](https://user-images.githubusercontent.com/46609963/229936015-8f23e8e4-185e-428d-ab93-fc45ad8b059c.png)

3) Ahora que los asientos están listos, se agruparán a los pasajeros por orden de compra, ya que se asume que los pasajeros que primero compran serán los primeros en tomar asiento.
4) Para validar que los niños de cada grupo no se sienten solos, con cada adulto del grupo se evaluó que el posible asiento tuviera un espacio disponible para los menores. Como no se especifica lo que es estar "junto", se asume que los puestos que están "arriba", "abajo", "derecha" e "izquierda" son válidos, incluso si hay un pasillo de por medio, y para esto se hace un recorrido de arriba hacia abajo, como si se tratase de un avión real. Para manejar los pasillos, se dejaron en blanco y no disponibles.
5) Al terminar de asignar los asientos, queda de la siguiente manera:

5) Al terminar de asignar los asientos queda de la siguiente manera

AirNova-660

![image](https://user-images.githubusercontent.com/46609963/229936994-31717e86-a5c2-4d0b-adf1-575187d55952.png)

AirMax-720neo

![image](https://user-images.githubusercontent.com/46609963/229937041-2e781a11-903a-4807-b561-842b44aa1eb6.png)

Los asientos que siguen con su "asiento-numero" son los que sobran, ya que en cada avión no se compran todos y están al final de cada clase por el tipo de recorrido que se hizo.

Posibles errores:

![image](https://user-images.githubusercontent.com/46609963/229941635-707dc41c-26ae-4288-b66f-fd275b007778.png)


# Despliegue de la API

Para poder subir la API REST, se utilizó DigitalOcean, como prueba:

![image](https://user-images.githubusercontent.com/46609963/230226777-f71f6c1a-a935-4f59-b95d-0af3a8f767c0.png)

No se utilizó dominio por falta de tiempo, por lo que se deja la IP.

Para poder probarla ingrese al siguiente Url : http://198.199.122.51/flights/id/passengers

# Codigo

Comentarios en general para el código:

- Se manejaron las excepciones en el controlador ApplicationController.
- Para ejecutar el back se usa solamente el controlador FlightsController, que contiene toda la lógica.
- La ruta contiene 2 elementos: el primero se refiere a la ruta que se nos pide "/flights/:id/passengers" y el segundo es para manejar la excepción en caso de que se quiera obtener un recurso que no existe y que nos muestre una excepción.
- Para cumplir con el formato que se nos pide al retornar el JSON, se maneja mediante el método "as_json" en el modelo de Flight.

# Ruby version

 Rails 7.0.4.3
 Ruby "3.1.2"

# Dependencias

- actioncable (7.0.4.3)
- actionmailbox (7.0.4.3)
- actionmailer (7.0.4.3) 
- actionpack (7.0.4.3)   
- actiontext (7.0.4.3)   
- actionview (7.0.4.3)   
- activejob (7.0.4.3)    
- activemodel (7.0.4.3)  
- activerecord (7.0.4.3) 
- activestorage (7.0.4.3)
- activesupport (7.0.4.3)
- bootsnap (1.16.0)
- builder (3.2.4)
- bundler (2.3.25)
- concurrent-ruby (1.2.2)
- crass (1.0.6)
- date (3.3.3)
- debug (1.7.1)
- erubi (1.12.0)
- globalid (1.1.0)
- i18n (1.12.0)
- io-console (0.6.0)
- irb (1.6.3)
- loofah (2.19.1)
- mail (2.8.1)
- marcel (1.0.2)
- method_source (1.0.0)
- mini_mime (1.1.2)
- minitest (5.18.0)
- msgpack (1.6.1)
- mysql2 (0.5.4)
- net-imap (0.3.4)
- net-pop (0.1.2)
- net-protocol (0.2.1)
- net-smtp (0.3.3)
- nio4r (2.5.8)
- nokogiri (1.14.2)
- puma (5.6.5)
- racc (1.6.2)
- rack (2.2.6.4)
- rack-test (2.1.0)
- rails (7.0.4.3)
- rails-dom-testing (2.0.3)
- rails-html-sanitizer (1.5.0)
- railties (7.0.4.3)
- rake (13.0.6)
- reline (0.3.2)
- thor (1.2.1)
- timeout (0.3.2)
- tzinfo (2.0.6)
- tzinfo-data (1.2023.1)
- websocket-driver (0.7.5)
- websocket-extensions (0.1.5)
- zeitwerk (2.6.7)

# Base de datos

Para obtener la información se conectó a la base de datos utilizando el archivo database.yml con las credenciales que se nos entregan. Solo podemos leer en ella, por lo que no existen archivos de migración en el proyecto.

Instalación: Instrucciones detalladas para 

# Endpoints

1) /flights/:id/passengers


# Contacto 

Correo : luis.cabello.a@mail.pucv.cl
