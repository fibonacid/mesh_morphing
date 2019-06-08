# Mesh Morphing
A sketch I made to learn more about the inner workings of Processing and OpenGL

## Description
This sketch involves a 3D Scene with a spherical shape as protagonist.
The shape appearance is constantly changing due to a gradual displacement of its vertexes.
This is done by plugging every vertex of the shape into a *perlin noise* function which will use the vertex coordinates to output a number between 0.0 and 1.0.
These values will be used to push all the vertexes from their original position by some amount, therefore morphing the sphere into a less perfect, less boring shape.

This algorithm could be implemented in 2 ways:
- Using the processing way through the PShape class methods
- Modifying the rendering behavior through a **Vertex Shader**.

In this case i preferred to go for the second approach.
That's because a custom shader allow the program to perform all the vertex displacement calculations on the GPU, resulting in much higher performance.
In addition to that I have found no way to access the vertexes of a PShape created like this `new PShape(SPHERE, x)`,
so i would be stuck with having to create all my 3D shapes manually which could be time expensive and could result in less scalable code.

Explaining openGL is well beyond the scope of this paper, so i'll leave some useful links for whomever would like to look into the topic with more depth.
To give a glimpse of what a vertex shaders does we could say that they are small programs that have to put together vertexes to construct some geometry.
These geometries will then be the source of other calculations that will end up being the image you see on the screen.

```
 attribute vec4 position;

 uniform mat4 transformMatrix;
 uniform float u_noise_amount;
 uniform float u_time;

 float noise(vec3 st) {...}

 void main() {
  float displacement = u_noise_amount * (noise(position.xyz + u_time) - 0.5);
  gl_Position = transformMatrix * position + vec4(displacement);
 }
```

Anyhow, here above is a simplified version of my vertex shader code; The language is called **GLSL**, which stands for OpenGL Shading Language.
When you create a PShape and you place it on the canvas through `shape()`, this shader will be applied to all vertexes of the shape.
So Processing will send the coordinates of a specific vertex through the `position` attribute. At the same time it will send some other parameters that are the same throughout all vertexes: these are `transformMatrix`, `u_noise_amount` and `u_time`.
The main function is where calculations are done and the final position of the vertex is produced, this one is held in the `gl_Position` variable.



## Requirements
- Processing 3.x
- Processing Sound
- PeasyCam
- ControlP5

## Installation
Open a terminal and cd into the path you want this sketch to be located.
```
 cd your-path-of-choice
 git clone https://github.com/lorenzorivosecchi/mesh_morphing.git
```
Make sure you have installed all the libraries listed above, if you don't just add them using the Contribution Manager.

## Usage
Launch sketch by double clicking any `.pde" file in the directory.  
Use the graphic user interface to change some parameters of the scene.  
Check out the on screen console for tips and shortcuts
