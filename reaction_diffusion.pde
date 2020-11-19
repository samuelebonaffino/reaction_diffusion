// REACTION DIFFUSION - GRAY-SCOTT MODEL

// Variables
final static int B = 128;

PGraphics canvas;
PShader initGrid, grayscott, render;
PImage img;
Audio audio;
boolean init   = true;
boolean stop   = false;
float f        = 0.0545;
float k        = 0.062;
float dt       = 1.0;
float dA       = 1.1;
float dB       = 0.5;
int iterarions = 10;

// Processing functions
void settings()
{
    // size(972, 1296, P2D);
    fullScreen(P2D);
}
void setup()
{
    initShaders();
    setupAudio();
}
void draw()
{
    options();
    updateShaders();
    updateCanvas();
}

// My functions
void setupAudio()
{
    audio = new Audio(B, "bias.wav");
    audio.cue(240);
    audio.play();
}
void initShaders()
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

    render.set("ca", new PVector(1.0, 1.0, 1.0));
    render.set("cb", new PVector(0.0, 0.0, 0.0));
    // render.set("cb", new PVector(1.0, 1.0, 1.0));
    // render.set("ca", new PVector(0.0, 0.0, 0.0));
}
void updateParamFromAudio()
{
    int   i = floor(random(B));
    float a = audio.getAmplitude();
    float s = audio.getFrequency(i);
    f  = map(a, 0, 1, 0.01, 0.030);
    k  = map(a, 0, 1, 0.045, 0.046);
    // dt = map(a, 0, 1, 0, 1.0);
    // dA = map(a, 0, 1, 0, 0.8);
    // dB = map(a, 0, 1, 0, 0.7);
    dA = map(a, 0, 1, 0.1, 0.68);
    dB = map(a, 0, 1, 0.1, 0.74);
    // dA = map(a, 0, 1, 0.1, 0.24);
    // dB = map(a, 0, 1, 0.1, 0.16);
}
void updateShaders()
{
    updateParamFromAudio();
    grayscott.set("f", f);
    grayscott.set("k", k);
    grayscott.set("dt", dt);
    grayscott.set("dA", dA);
    grayscott.set("dB", dB);

    render.set("alpha", audio.getAmplitude(0.15));
}
void updateCanvas()
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
void options() 
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