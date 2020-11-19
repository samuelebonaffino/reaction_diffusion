import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class reaction_diffusion extends PApplet {

// REACTION DIFFUSION - GRAY-SCOTT MODEL

// Variables
PGraphics canvas;
PShader initGrid, grayscott, render;
PImage img;
boolean init   = true;
boolean stop   = false;
float f        = 0.0545f;
float k        = 0.062f;
float dt       = 1.0f;
float dA       = 1.15f;
float dB       = 0.5f;
int iterarions = 10;

// Processing functions
public void settings()
{
    // size(800, 800, P2D);
    fullScreen(P2D);
}
public void setup()
{
    initShaders();
}
public void draw()
{
    updateGSShader();
    updateCanvas();
}

// My functions
public void initShaders()
{
    initGrid = loadShader("init_grid.glsl");
    grayscott = loadShader("grayscott.glsl");
    render = loadShader("render.glsl");
    canvas = createGraphics(width, height, P2D);
    canvas.beginDraw();
    canvas.background(255, 50, 0);
    canvas.stroke(200);
    canvas.strokeWeight(15);
    canvas.endDraw();

    // render.set("ca", new PVector(0.0, 0.0, 0.0));
    // render.set("cb", new PVector(1.0, 1.0, 1.0));
    render.set("ca", new PVector(1.0f, 1.0f, 1.0f));
    render.set("cb", new PVector(0.0f, 0.0f, 0.0f));
}
public void updateGSShader()
{
    grayscott.set("f", f);
    grayscott.set("k", k);
    grayscott.set("dt", dt);
    grayscott.set("dA", dA);
    grayscott.set("dB", dB);
}
public void updateCanvas()
{
    canvas.beginDraw();
    if(init)
    {
        canvas.filter(initGrid);
        init = !init;
    }
    if(!stop)
        for(int i = 0; i < iterarions; i++)
            canvas.filter(grayscott);
    if(mousePressed)
        canvas.line(pmouseX, pmouseY, mouseX, mouseY);
    canvas.endDraw();
    image(canvas, 0, 0, width, height);
    filter(render);
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "reaction_diffusion" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
