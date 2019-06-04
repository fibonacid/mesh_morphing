/**
 *
 */
void controllerChange(int channel, int number, int value) {
   //println("MIDI CC"+number+": "+value);
   
   switch(number) {
      case 1:
        noise_amount(float(value)/127f);
        break;
      case 2:
        noise_frequency(float(value)/127f);
        break;
      case 3:
        break;
      case 4:
        break;
      case 5:
        break;
      case 6:
        break;
      case 7:
        break;
      case 8:
        break;
      case 9:
        break;
      case 10:
        break;
      case 11:
        break;
      case 12:
        break;
      case 13:
        break;
      case 14:
        break;
      case 15:
        break;
      case 16:
        break;
   }
}
