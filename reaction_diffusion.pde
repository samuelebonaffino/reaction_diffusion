// REACTION DIFFUSION - GRAY-SCOTT MODEL

// Variables
PGraphics canvas;
PShader grayscott, render;
PImage img;
boolean stop   = false;
float f        = 0.0545;
float k        = 0.062;
float dt       = 1.0;
float dA       = 1.0;
float dB       = 0.5;
int iterarions = 1;

// Processing functions
void settings()
{
    size(800, 800, P2D);
}
void setup()
{
    initShaders();
}
void draw()
{
    updateGSShader();
    updateCanvas();
}

// My functions
void initShaders()
{
    grayscott = loadShader("grayscott.glsl");
    render = loadShader("render.glsl");
    canvas = createGraphics(width, height, P2D);
    canvas.beginDraw();
    canvas.background(255, 0, 0);
    canvas.stroke(200);
    canvas.strokeWeight(15);
    canvas.endDraw();

    // render.set("ca", new PVector(0.0, 0.0, 0.0));
    // render.set("cb", new PVector(1.0, 1.0, 1.0));
    render.set("ca", new PVector(1.0, 1.0, 1.0));
    render.set("cb", new PVector(0.0, 0.0, 0.0));
}
void updateGSShader()
{
    grayscott.set("f", f);
    grayscott.set("k", k);
    grayscott.set("dt", dt);
    grayscott.set("dA", dA);
    grayscott.set("dB", dB);
}
void updateCanvas()
{
    canvas.beginDraw();
    if(!stop)
        for(int i = 0; i < iterarions; i++)
            canvas.filter(grayscott);
    if(mousePressed)
        canvas.line(pmouseX, pmouseY, mouseX, mouseY);
    canvas.endDraw();
    image(canvas, 0, 0, width, height);
    filter(render);
}