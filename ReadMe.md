# Poli Legacy

## Descripción

**Poli Legacy** es un videojuego 2D desarrollado en **Godot Engine 4.6** con **GDScript**, ambientado en el **Instituto Politécnico Modelo (IPM)**, inspirado en nuestra experiencia dentro del colegio. El nombre del proyecto está inspirado en el juego *Hogwarts Legacy*, adaptando la idea a un entorno escolar propio.

La propuesta consiste en recorrer distintas aulas y pasillos del instituto, enfrentando en cada nivel a un profesor convertido en jefe (boss), cada uno temático de una materia distinta.

## Historia

El juego cuenta con un tutorial inicial y una progresión de niveles temáticos por materia, cada uno ambientado y diseñado según la asignatura correspondiente:

- **Tutorial**: introducción a los controles y mecánicas básicas del juego, guiada por el NPC **Charly**. No tiene boss.
- **Nivel 1 – Geografía**: enfrentamiento contra la Profesora de Geografía.
- **Nivel 2 – Electricidad**: enfrentamiento contra el Profesor Nievas.
- **Nivel 3 – Matemática**: nivel final, enfrentamiento contra el Profesor de Matemática.

Cada nivel recrea el aula temática correspondiente, con decoración, pizarrones y objetos propios de la materia.

## Jugabilidad

Durante la partida, el jugador deberá:

- Explorar distintas zonas del instituto (pasillos y aulas).
- Interactuar con NPCs, como Charly durante el tutorial.
- Enfrentarse a profesores convertidos en jefes, cada uno con ataques propios de su materia.
- Usar una habilidad especial (ultimate) tipo escudo eléctrico para protegerse de los ataques.
- Conseguir un coleccionable único al derrotar a cada jefe.

## Coleccionables

Cada jefe derrotado entrega un coleccionable temático relacionado con su materia:

- **Geografía**: globo terráqueo.
- **Electricidad**: llave térmica.
- **Matemática**: calculadora/ábaco antiguo.

## Interfaz

- **Menú de inicio**: `MenuInicio_main.tscn`.
- **Menú de pausa**: diseñado con estética de hoja de carpeta/cuaderno escolar.
- **Pantalla de victoria**: pantalla de cierre al completar el juego, con panel de resultados estilo hoja de examen.

## Estructura del Proyecto
- poly-legacy/
- └── Assets/           # Sprites, escenarios, íconos y UI del juego
- project.godot          # Configuración principal del proyecto en Godot
- MenuInicio_main.tscn   # Escena del menú de inicio
- icon.svg               # Ícono del proyecto

## Tecnologías Utilizadas

- Godot Engine 4.6
- GDScript

## Integrantes

- Benjamin Serrano
- Franco Marotta
- Luciano Rojas
