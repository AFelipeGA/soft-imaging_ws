# Taller raster

## Propósito

Comprender algunos aspectos fundamentales del paradigma de rasterización.

## Tareas

Emplee coordenadas baricéntricas para:

1. Rasterizar un triángulo.
2. Sombrear su superficie a partir de los colores de sus vértices.
3. (opcional para grupos menores de dos) Implementar un [algoritmo de anti-aliasing](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-practical-implementation) para sus aristas.

Referencias:

* [The barycentric conspiracy](https://fgiesen.wordpress.com/2013/02/06/the-barycentric-conspirac/)
* [Rasterization stage](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-stage)

Implemente la función ```triangleRaster()``` del sketch adjunto para tal efecto, requiere la librería [nub](https://github.com/nakednous/nub/releases).

## Discusión

Describa los resultados obtenidos. En el caso de anti-aliasing describir las técnicas exploradas, citando las referencias.

### Rasterizar un triángulo

Rasterizar es el proceso per el cual una primitiva es convertida a una imagen de dos dimensiones. Cada punto de la imagen contiene información como el color y la profundidad.

En este punto se realizó el proceso de rasterización para un tríángulo. Se definieron algunas funciones con las siguientes teclas:

- `r`: se crean triángulos aleatoriamente dentro del espacio.
- `+`: se aumenta la resolución.
- `-`: se disminuye la resolución.
- `UP` y `DOWN`: se cambia el nivel de antialising.

### Sombrear su superficie a partir de los colores de sus vértices

Para sombrear la superficie se utilizó el método del paper de Juan Pineda, este dice que si el punto del centro se encuentra en el área del triángulo se selecciona el pixel y se pinta. Para determinar el color con el cual se debe pintar el pixel se utiliza el proceso llamdado `shading` el cual implica aplicar la siguiente combinación lineal:

![alt text](https://i.imgur.com/ZHwRKuF.jpg)

Esta combinación básicamente toma en cuenta los pesos y los colores de los 3 vértices del triángulo.

![alt text](https://i.imgur.com/YhNKZI2.jpg)

### Implementar un algoritmo de anti-aliasing para sus aristas

Se implementó el algoritmo MSAA para definir el anti-alising de la imagen.

![alt text](https://i.imgur.com/GqoEEYq.jpg)

#### Referencias

- https://www.tested.com/tech/pcs/1194-how-to-choose-the-right-anti-aliasing-mode-for-your-gpu/
- https://www.opengl.org/archives/resources/code/samples/advanced/advanced97/notes/node59.html
