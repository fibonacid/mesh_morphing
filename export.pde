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
