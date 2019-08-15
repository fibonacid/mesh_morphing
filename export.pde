void startRecording() {
 LocalDateTime now = LocalDateTime.now();
 String timestamp = fileDTF.format(now);
 String path = exportDir + _export_filename_ + timestamp + ".mp4";
 videoExport.setMovieFileName(path);
 videoExport.startMovie();
}

void stopRecording() {
  videoExport.endMovie();
}
