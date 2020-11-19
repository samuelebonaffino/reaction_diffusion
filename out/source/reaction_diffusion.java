import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 

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
final static int B = 128;

PGraphics canvas;
PShader initGrid, grayscott, render;
PImage img;
Audio audio;
boolean init   = true;
boolean stop   = false;
float f        = 0.0545f;
float k        = 0.062f;
float dt       = 1.0f;
float dA       = 1.1f;
float dB       = 0.5f;
int iterarions = 10;

// Processing functions
public void settings()
{
    // size(972, 1296, P2D);
    fullScreen(P2D);
}
public void setup()
{
    initShaders();
    setupAudio();
}
public void draw()
{
    options();
    updateShaders();
    updateCanvas();
}

// My functions
public void setupAudio()
{
    audio = new Audio(B, "bias.wav");
    audio.cue(240);
    audio.play();
}
public void initShaders()
{
    initGrid = loadShader("init_grid.glsl");
    grayscott = loadShader("grayscott.glsl");
    render = loadShader("render.glsl");
    canvas = createGraphics(width*2, height*2, P2D);
    canvas.beginDraw();
    canvas.background(0);
    canvas.stroke(200);
    canvas.strokeWeight(1);
    canvas.endDraw();

    render.set("ca", new PVector(1.0f, 1.0f, 1.0f));
    render.set("cb", new PVector(0.0f, 0.0f, 0.0f));
    // render.set("cb", new PVector(1.0, 1.0, 1.0));
    // render.set("ca", new PVector(0.0, 0.0, 0.0));
}
public void updateParamFromAudio()
{
    int   i = floor(random(B));
    float a = audio.getAmplitude();
    float s = audio.getFrequency(i);
    f  = map(a, 0, 1, 0.01f, 0.030f);
    k  = map(a, 0, 1, 0.045f, 0.046f);
    // dt = map(a, 0, 1, 0, 1.0);
    // dA = map(a, 0, 1, 0, 0.8);
    // dB = map(a, 0, 1, 0, 0.7);
    dA = map(a, 0, 1, 0.1f, 0.68f);
    dB = map(a, 0, 1, 0.1f, 0.74f);
    // dA = map(a, 0, 1, 0.1, 0.24);
    // dB = map(a, 0, 1, 0.1, 0.16);
}
public void updateShaders()
{
    updateParamFromAudio();
    grayscott.set("f", f);
    grayscott.set("k", k);
    grayscott.set("dt", dt);
    grayscott.set("dA", dA);
    grayscott.set("dB", dB);

    render.set("alpha", audio.getAmplitude(0.15f));
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
public void options() 
{
    if(keyPressed)
    {
        if(key == 'm' || key == 'M')
            iterarions++;
        if((iterarions > 0) && (key == 'l' || key == 'L'))
            iterarions--;
        if(key == 's' || key == 'S')
            saveFrame("frames\\rda-####.png");
    }    
}


class Audio
{
    // Attributes
    int band;
    String name;
    SoundFile input;
    float[] spectrum;
    FFT fft;
    Amplitude amp;

    // Constructor
    Audio(int band, String name)
    {
        this.band = band;
        this.name = name;

        spectrum = new float[band];

        input = new SoundFile(reaction_diffusion.this, name);
        fft = new FFT(reaction_diffusion.this, band);
        amp = new Amplitude(reaction_diffusion.this);

        fft.input(input);
        amp.input(input);
    }

    // Methods
    public void cue(float time)
    {
        input.cue(time);
    }
    public void play()
    {
        input.play();
    }
    public int getSpectrumID(int index)
    {
        return index % band;
    }
    public float getFrequency(int id)
    {
        if(id >= band)
            id = getSpectrumID(id);
        return spectrum[id];
    }
    public float getFrequency(int id, float mult)
    {
        if(id >= band)
            id = getSpectrumID(id);
        return spectrum[id] * mult;
    }
    public float getAmplitude()
    {
        return amp.analyze();
    }
    public float getAmplitude(float mult)
    {
        return amp.analyze() * mult;
    }
    public void updateSpectrum()
    {
        fft.analyze(spectrum);
    }
    public boolean isPlaying()
    {
        return input.isPlaying();
    }
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
