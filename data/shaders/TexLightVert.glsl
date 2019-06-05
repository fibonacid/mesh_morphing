/*
  Part of the Processing project - http://processing.org

  Copyright (c) 2012-15 The Processing Foundation
  Copyright (c) 2004-12 Ben Fry and Casey Reas
  Copyright (c) 2001-04 Massachusetts Institute of Technology

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation, version 2.1.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General
  Public License along with this library; if not, write to the
  Free Software Foundation, Inc., 59 Temple Place, Suite 330,
  Boston, MA  02111-1307  USA
*/

uniform mat4 modelviewMatrix;
uniform mat4 transformMatrix;
uniform mat3 normalMatrix;
uniform mat4 texMatrix;

uniform int lightCount;
uniform vec4 lightPosition[8];
uniform vec3 lightNormal[8];
uniform vec3 lightAmbient[8];
uniform vec3 lightDiffuse[8];
uniform vec3 lightSpecular[8];
uniform vec3 lightFalloff[8];
uniform vec2 lightSpot[8];

uniform float u_time;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;

attribute vec4 ambient;
attribute vec4 specular;
attribute vec4 emissive;
attribute float shininess;

varying vec4 vertColor;
varying vec4 backVertColor;
varying vec4 vertTexCoord;

const float zero_float = 0.0;
const float one_float = 1.0;
const vec3 zero_vec3 = vec3(0);

float falloffFactor(vec3 lightPos, vec3 vertPos, vec3 coeff) {
  vec3 lpv = lightPos - vertPos;
  vec3 dist = vec3(one_float);
  dist.z = dot(lpv, lpv);
  dist.y = sqrt(dist.z);
  return one_float / dot(dist, coeff);
}

float spotFactor(vec3 lightPos, vec3 vertPos, vec3 lightNorm, float minCos, float spotExp) {
  vec3 lpv = normalize(lightPos - vertPos);
  vec3 nln = -one_float * lightNorm;
  float spotCos = dot(nln, lpv);
  return spotCos <= minCos ? zero_float : pow(spotCos, spotExp);
}

float lambertFactor(vec3 lightDir, vec3 vecNormal) {
  return max(zero_float, dot(lightDir, vecNormal));
}

float blinnPhongFactor(vec3 lightDir, vec3 vertPos, vec3 vecNormal, float shine) {
  vec3 np = normalize(vertPos);
  vec3 ldp = normalize(lightDir - np);
  return pow(max(zero_float, dot(ldp, vecNormal)), shine);
}

//	Classic Perlin 3D Noise
//	by Stefan Gustavson
//
vec4 permute(vec4 x){return mod(((x*34.0)+1.0)*x, 289.0);}
vec4 taylorInvSqrt(vec4 r){return 1.79284291400159 - 0.85373472095314 * r;}
vec3 fade(vec3 t) {return t*t*t*(t*(t*6.0-15.0)+10.0);}

float cnoise(vec3 P){
  vec3 Pi0 = floor(P); // Integer part for indexing
  vec3 Pi1 = Pi0 + vec3(1.0); // Integer part + 1
  Pi0 = mod(Pi0, 289.0);
  Pi1 = mod(Pi1, 289.0);
  vec3 Pf0 = fract(P); // Fractional part for interpolation
  vec3 Pf1 = Pf0 - vec3(1.0); // Fractional part - 1.0
  vec4 ix = vec4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
  vec4 iy = vec4(Pi0.yy, Pi1.yy);
  vec4 iz0 = Pi0.zzzz;
  vec4 iz1 = Pi1.zzzz;

  vec4 ixy = permute(permute(ix) + iy);
  vec4 ixy0 = permute(ixy + iz0);
  vec4 ixy1 = permute(ixy + iz1);

  vec4 gx0 = ixy0 / 7.0;
  vec4 gy0 = fract(floor(gx0) / 7.0) - 0.5;
  gx0 = fract(gx0);
  vec4 gz0 = vec4(0.5) - abs(gx0) - abs(gy0);
  vec4 sz0 = step(gz0, vec4(0.0));
  gx0 -= sz0 * (step(0.0, gx0) - 0.5);
  gy0 -= sz0 * (step(0.0, gy0) - 0.5);

  vec4 gx1 = ixy1 / 7.0;
  vec4 gy1 = fract(floor(gx1) / 7.0) - 0.5;
  gx1 = fract(gx1);
  vec4 gz1 = vec4(0.5) - abs(gx1) - abs(gy1);
  vec4 sz1 = step(gz1, vec4(0.0));
  gx1 -= sz1 * (step(0.0, gx1) - 0.5);
  gy1 -= sz1 * (step(0.0, gy1) - 0.5);

  vec3 g000 = vec3(gx0.x,gy0.x,gz0.x);
  vec3 g100 = vec3(gx0.y,gy0.y,gz0.y);
  vec3 g010 = vec3(gx0.z,gy0.z,gz0.z);
  vec3 g110 = vec3(gx0.w,gy0.w,gz0.w);
  vec3 g001 = vec3(gx1.x,gy1.x,gz1.x);
  vec3 g101 = vec3(gx1.y,gy1.y,gz1.y);
  vec3 g011 = vec3(gx1.z,gy1.z,gz1.z);
  vec3 g111 = vec3(gx1.w,gy1.w,gz1.w);

  vec4 norm0 = taylorInvSqrt(vec4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
  g000 *= norm0.x;
  g010 *= norm0.y;
  g100 *= norm0.z;
  g110 *= norm0.w;
  vec4 norm1 = taylorInvSqrt(vec4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
  g001 *= norm1.x;
  g011 *= norm1.y;
  g101 *= norm1.z;
  g111 *= norm1.w;

  float n000 = dot(g000, Pf0);
  float n100 = dot(g100, vec3(Pf1.x, Pf0.yz));
  float n010 = dot(g010, vec3(Pf0.x, Pf1.y, Pf0.z));
  float n110 = dot(g110, vec3(Pf1.xy, Pf0.z));
  float n001 = dot(g001, vec3(Pf0.xy, Pf1.z));
  float n101 = dot(g101, vec3(Pf1.x, Pf0.y, Pf1.z));
  float n011 = dot(g011, vec3(Pf0.x, Pf1.yz));
  float n111 = dot(g111, Pf1);

  vec3 fade_xyz = fade(Pf0);
  vec4 n_z = mix(vec4(n000, n100, n010, n110), vec4(n001, n101, n011, n111), fade_xyz.z);
  vec2 n_yz = mix(n_z.xy, n_z.zw, fade_xyz.y);
  float n_xyz = mix(n_yz.x, n_yz.y, fade_xyz.x);
  return 2.2 * n_xyz;
}

#define OCTAVES 4
float fmb(in vec3 st) {
  // Initial values
  float value = 0.0;
  float amplitude = 1.0;
  //float frequency = 2.0;
  //
  // Loop of octaves
  for (int i = 0; i < OCTAVES; i++) {
    st *= i+1;
    value += amplitude * cnoise(st);
    amplitude *= .3;
  }
  return value;
}

void main() {

  float displacement = 100. * (0.5 + 0.5 * fmb(position.xyz * 0.01 + u_time * 0.001));

  // Vertex in clip coordinates
  gl_Position = transformMatrix * position + displacement;

  // Vertex in eye coordinates
  vec3 ecVertex = vec3(modelviewMatrix * position);

  // Normal vector in eye coordinates
  vec3 ecNormal = normalize(normalMatrix * normal);
  vec3 ecNormalInv = ecNormal * -one_float;

  // Light calculations
  vec3 totalAmbient = vec3(0, 0, 0);

  vec3 totalFrontDiffuse = vec3(0, 0, 0);
  vec3 totalFrontSpecular = vec3(0, 0, 0);

  vec3 totalBackDiffuse = vec3(0, 0, 0);
  vec3 totalBackSpecular = vec3(0, 0, 0);

  for (int i = 0; i < 8; i++) {
    if (lightCount == i) break;

    vec3 lightPos = lightPosition[i].xyz;
    bool isDir = lightPosition[i].w < one_float;
    float spotCos = lightSpot[i].x;
    float spotExp = lightSpot[i].y;

    vec3 lightDir;
    float falloff;
    float spotf;

    if (isDir) {
      falloff = one_float;
      lightDir = -one_float * lightNormal[i];
    } else {
      falloff = falloffFactor(lightPos, ecVertex, lightFalloff[i]);
      lightDir = normalize(lightPos - ecVertex);
    }

    spotf = spotExp > zero_float ? spotFactor(lightPos, ecVertex, lightNormal[i],
                                              spotCos, spotExp)
                                 : one_float;

    if (any(greaterThan(lightAmbient[i], zero_vec3))) {
      totalAmbient       += lightAmbient[i] * falloff;
    }

    if (any(greaterThan(lightDiffuse[i], zero_vec3))) {
      totalFrontDiffuse  += lightDiffuse[i] * falloff * spotf *
                            lambertFactor(lightDir, ecNormal);
      totalBackDiffuse   += lightDiffuse[i] * falloff * spotf *
                            lambertFactor(lightDir, ecNormalInv);
    }

    if (any(greaterThan(lightSpecular[i], zero_vec3))) {
      totalFrontSpecular += lightSpecular[i] * falloff * spotf *
                            blinnPhongFactor(lightDir, ecVertex, ecNormal, shininess);
      totalBackSpecular  += lightSpecular[i] * falloff * spotf *
                            blinnPhongFactor(lightDir, ecVertex, ecNormalInv, shininess);
    }
  }

  // Calculating final color as result of all lights (plus emissive term).
  // Transparency is determined exclusively by the diffuse component.
  vertColor =     vec4(totalAmbient, 0) * ambient +
                  vec4(totalFrontDiffuse, 1) * color +
                  vec4(totalFrontSpecular, 0) * specular +
                  vec4(emissive.rgb, 0);

  backVertColor = vec4(totalAmbient, 0) * ambient +
                  vec4(totalBackDiffuse, 1) * color +
                  vec4(totalBackSpecular, 0) * specular +
                  vec4(emissive.rgb, 0);

  // Calculating texture coordinates, with r and q set both to one
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
}
