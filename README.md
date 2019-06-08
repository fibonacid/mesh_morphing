# Mesh Morphing
A sketch I made to learn more about the inner workings of Processing and OpenGL

### Description
This sketch envolves a 3D Scene with a spherical shape as protagonist.
The shape appearence is constantly changing due to a gradual displacement of its vertexes.
This is done by plugging every vertex of the shape into a *perlin noise* function which will use the vertex coordinates to output a number between 0.0 and 1.0. 
These values will be used to push all the vertexes from their original position by some amount, therefore morphing the sphere into a less perfect, less boring shape.

This algorithm could be implemented in 2 ways:
- using the processing way through the PShape class methods
- replacing the current rendering shader with a custom one

In this case i prefered to go for the second approach.
That's because a custom shader allow the program to perform all the vertex displacement calculations on the GPU, resulting in much higher performance. 
In addition to that I have found no way to access the vertexes of a PShape created like this `new PShape(SPHERE, x)`,
so i would be stuck with having to create all my 3D shapes manually which would result in less portable code and in many time spent with formulas i don't really wanna know.

Shaders are a very complex subject and are not the subject of this paper.
Here's just a portion of glsl code to apply vertex displacement:
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
Launch sketch by double clicking any .pde file in the directory.  
Use the graphic user interface to change some parameters of the scene.  
Check out the on screen console for tips and shortcuts 
