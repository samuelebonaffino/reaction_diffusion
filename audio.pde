import processing.sound.*;

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
    void cue(float time)
    {
        input.cue(time);
    }
    void play()
    {
        input.play();
    }
    int getSpectrumID(int index)
    {
        return index % band;
    }
    float getFrequency(int id)
    {
        if(id >= band)
            id = getSpectrumID(id);
        return spectrum[id];
    }
    float getFrequency(int id, float mult)
    {
        if(id >= band)
            id = getSpectrumID(id);
        return spectrum[id] * mult;
    }
    float getAmplitude()
    {
        return amp.analyze();
    }
    float getAmplitude(float mult)
    {
        return amp.analyze() * mult;
    }
    void updateSpectrum()
    {
        fft.analyze(spectrum);
    }
    boolean isPlaying()
    {
        return input.isPlaying();
    }
}