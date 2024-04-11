
# FrogmiTest

Prueba de Frogmi: se consume una url sobre sismos. Se crea una aplicación con ruby, vue.js y sqlite. 

## Ruby ##

Versión: 3.2.3

Gems utilizadas: 

- json
- sinatra 
- net/http
- rack/cors
- sequel




Para ejecutar el código: 

    1) Instalar Compilador de Ruby
    2) ejecutar los comando: cd server y ruby main.rb
    






## API

#### Obtener todos los sismos

```http
  GET /api/features
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `page` | `int` | **Opcional**. Ubicación dentro de la paginación de sismos segun la cantidad de sismos por página |
| `per_page` | `int` | **Opcional**. Cantidad de sismos por página|
| `mag_type` | `Array<String>` | **Opcional**. Tipo de maginitudes |

#### Comentar el sismo según id 

```http
  POST /api/features/:feature_id/comments
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Required**. Id del sismo a comentar |




## Vuejs

Pasos a seguir: 

  1.-  Ejecutar el siguiente comando:

  `cd client/app`
  
  2.- Ejecutar else siguiente comando: 

  `npm install`

  3.- Finalmente ejecutar

  `npm run dev ` 

