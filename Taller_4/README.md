# Taller de shaders

## Propósito

Estudiar los [patrones de diseño de shaders](http://visualcomputing.github.io/Shaders/#/4).

## Tarea

1. Hacer un _benchmark_ entre la implementación por software y la de shaders de varias máscaras de convolución aplicadas a imágenes y video.
2. Implementar un modelo de iluminación que combine luz ambiental con varias fuentes puntuales de luz especular y difusa. Tener presente _factores de atenuación_ para las fuentes de iluminación puntuales.
3. (grupos de dos o más) Implementar el [bump mapping](https://en.wikipedia.org/wiki/Bump_mapping).

## Informe

### Benchmark

Para el desarrollo de este punto, se tomaron elementos del taller 1 donde se aplicaban algunas máscaras de convolución a imágenes y un video. Así pues, en este taller se se escogieron las máscaras: _Sharpen_, _Edge Detection_ y _Blur_, además de un filtro en escala de grises, por implentación de software (matrices del kernel) y por medio de shaders. 

Al correr la aplicación, se observa una imagen inicial que puede ser cambiada, por medio de cuatro botones, a otras imágenes o a un video. Por otro lado, hay 8 checkbox (4 para la implementación por software y 4 para la implementación por shaders) para elegir la máscara de convolución. Una vez escogida la opción, se verá la máscara aplicada en la imagen o video y los FPS que muestra la diferencia de rendimiento en cada implementación..

### Modelo de iluminación

Se presenta una escena de un carro en una calle con un par de lámparas de calle y un semáforo. Se hace uso de una luz ambiental tenue para simular la noche, point lights para las lámparas y spot lights para el resto de luces ya que son dirigidas y en forma de cono. Para el shader de iluminación se usó el modelo de Blinn-Phong para simulación de luz especular y difusa, y la ley de Lambert y el factor de caída de la luz para agregar atenuación dependiendo de la distancia.

Se utilizó la libreria nub para la interacción con los objetos de la escena y la cámara. Con click izquierdo sobre un objeto se puede cambiar el estado de las luces correspondientes al objeto y arrastrando mientras se sostiene el click derecho se puede mover el objeto sobre el eje Z para observar el cambio en tiempo real de la iluminación. Además si se hace click con el botón central del ratón sobre el carro, este rotará 180° sobre el eje Y para visualizar el efecto de las luces delanteras y traseras del carro en el otro sentido.

### Bump mapping

El modelo que se implementó permite integrar un modelo de iluminación con diferentes fuentes que recrean la escena de un carro en una calle con semáforos y luces en la calle.

Este modelo permite trabajar el *bump mapping* con diferentes texturas a lo largo de la escena. Se centró en mostrar una textura clara en la carrocería del carro, donde se pudiera apreciar el detalle de las puertas, el parabrisas y los diferentes elementos exteriores del carro.

![image](https://user-images.githubusercontent.com/13041087/60772307-059c4780-a0ba-11e9-9fdc-336641c9c8a5.png)

![image](https://user-images.githubusercontent.com/13041087/60772312-26649d00-a0ba-11e9-943b-5d292e86c9f4.png)

![image](https://user-images.githubusercontent.com/13041087/60772322-48f6b600-a0ba-11e9-98b2-367d0c47dd54.png)

## Entrega

Fecha límite ~~Lunes 1/7/19~~ Domingo 7/7/19 a las 24h. Sustentaciones: 10/7/19 y 11/7/19.
