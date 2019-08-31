/**
 * START RECORDING
 * ===============
 */
void startRecording() {
 LocalDateTime now = LocalDateTime.now();
 String timestamp = fileDTF.format(now);
 String path = exportDir + _export_filename_ + timestamp + ".mp4";
 videoExport.setMovieFileName(path);
   try {
    isRecording = true;
  }
  catch (Error e) {
    e.printStackTrace(); 
  }
 println("\nVideo Export: Recording Started");
 println("===============================");
}

/**
 * START RECORDING
 * ===============
 */
void stopRecording() {
  try {
    videoExport.endMovie();
    isRecording = false;
  }
  catch (Error e) {
    e.printStackTrace(); 
  }
  videoExport.endMovie();
  println("\nVideo Export: Recording Ended");
  println("===============================");
}

/**
 * SETUP VIDEO EXPORT
 * ==================
 */
void setupVideoExport() {
  // If last session had a problem with ffmpeg bin file
  if (ENV_FORGET_FFMPEG) {
    // Make videoExport ask again for it
    videoExport.forgetFfmpegPath();
    println("Ffmpeg binary location forgotten:\t"+videoExport.getFfmpegPath());
  } 
  try {
     videoExport.startMovie(); 
     // If by now no errors were raised:
     if (ENV_FORGET_FFMPEG) {
       ENV.setBoolean("FORGET_FFMPEG", false);
     }
  } catch(NullPointerException e) {
     e.printStackTrace();
  }
}
