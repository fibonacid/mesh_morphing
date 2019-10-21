/**
 * START RECORDING
 * ===============
 */
void startRecording() {
 LocalDateTime now = LocalDateTime.now();
 String timestamp = fileDTF.format(now);
 String path = exportDir + _export_filename_ + timestamp + ".mp4";
 // Create file
 File file = new File(path);
 
 // Make sure the file is created
 try {
   if (file.createNewFile()) {
      println("File", path, "successfully created!"); 
   } else {
      
      println("File", path, "already exists."); 
   }
 }
 catch(Exception e) {
   e.printStackTrace();
 }
 
 videoExport.setMovieFileName(path);
 isRecording = true;
 videoExport.startMovie();
 println("\nVideo Export: Recording Started");
 println("===============================");
}

/**
 * RECORDING PROGRESS
 * ==================
 */
String recordingProgress() {
    float seconds = videoExport.getCurrentTime();
    String duration = formatDuration((long)seconds);
    println("[RECORDING]\ttimeo:\t"+duration+" ("+seconds+"s)");
    return duration;
}

/**
 * START RECORDING
 * ===============
 */
void stopRecording() {
  videoExport.endMovie();
  isRecording = false;
  println("\nVideo Export: Recording Ended");
  println("duration:\t"+recordingProgress());
  println("===============================");
}

/**
 * SETUP VIDEO EXPORT
 * ==================
 */
void setupVideoExport() {
  // Set quality of exports
  switch(_export_quality_) {
      case "high":
        videoExport.setQuality(70, 192);
        break;
      case "standard":
        videoExport.setQuality(70, 192);
        break;
  }
  // Export framerate should always match the window one.
  videoExport.setFrameRate(frameRate);
  // If last session had a problem with ffmpeg bin file
  if (ENV_FORGET_FFMPEG) {
    // Make videoExport ask again for it
    videoExport.forgetFfmpegPath();
    println("Ffmpeg binary location forgotten:\t"+videoExport.getFfmpegPath());
  }
  // If user set a path for the ffmpeg binary file
  if (ENV_FFMPEG_PATH != null && 
      !ENV_FFMPEG_PATH.isEmpty()) {
    videoExport.setFfmpegPath(ENV_FFMPEG_PATH);
    println("Ffmpeg binary path:", ENV_FFMPEG_PATH);
  }
}
