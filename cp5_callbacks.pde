Line line = new Line();

void noise_amount(float input) {
 line.to(input, 1000);
}

void noise_frequency(float value) {
 println("noise_frequency:", value);
 noisySphere.setNoiseFrequency(value);
}
