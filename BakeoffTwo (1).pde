import java.util.Arrays;
import java.util.Collections;
import java.util.Random;

String[] phrases; //contains all of the phrases
int totalTrialNum = 2; //the total number of phrases to be tested!
int currTrialNum = 0; // the current trial number (indexes into trials array above)
float startTime = 0; // time starts when the first letter is entered
float finishTime = 0; // records the time of when the final trial ends
float lastTime = 0; //the timestamp of when the last trial was completed
float lettersEnteredTotal = 0; //a running total of the number of letters the user has entered (need this for final WPM computation)
float lettersExpectedTotal = 0; //a running total of the number of letters expected (correct phrases)
float errorsTotal = 0; //a running total of the number of errors (when hitting next)
String currentPhrase = ""; //the current target phrase
String currentTyped = ""; //what the user has typed so far
final int DPIofYourDeviceScreen = 142; //you will need to look up the DPI or PPI of your device to make sure you get the right scale!!
//http://en.wikipedia.org/wiki/List_of_displays_by_pixel_density
final float sizeOfInputArea = DPIofYourDeviceScreen*1; //aka, 1.0 inches square!
PImage watch;

//Variables for my silly implementation. You can delete this:
char currentLetter = 'a';

PrintWriter output;
Table table;
String andrew_id = "xwu3"; // current tester's andrew ID

//You can modify anything in here. This is just a basic implementation.
void setup()
{
  watch = loadImage("watchhand3smaller.png");
  phrases = loadStrings("phrases2.txt"); //load the phrase set into memory
  Collections.shuffle(Arrays.asList(phrases), new Random()); //randomize the order of the phrases with no seed
  //Collections.shuffle(Arrays.asList(phrases), new Random(100)); //randomize the order of the phrases with seed 100; same order every time, useful for testing
 
  orientation(LANDSCAPE); //can also be PORTRAIT - sets orientation on android device
  size(800, 800); //Sets the size of the app. You should modify this to your device's native size. Many phones today are 1080 wide by 1920 tall.
  textFont(createFont("Arial", 24)); //set the font to arial 24. Creating fonts is expensive, so make difference sizes once in setup, not draw
  noStroke(); //my code doesn't use any strokes
  
  output = createWriter("performance.csv");
  table = new Table();
  table.addColumn("user_ID", Table.STRING);
  table.addColumn("cycle_number", Table.INT);
  table.addColumn("Total time taken", Table.FLOAT);
  table.addColumn("Total letters entered", Table.FLOAT);
  table.addColumn("Total letters expected", Table.FLOAT);
  table.addColumn("Total errors entered", Table.FLOAT);
  table.addColumn("Raw WPM", Table.FLOAT);
  table.addColumn("Freebie errors", Table.FLOAT);
  table.addColumn("Penalty", Table.FLOAT);
  table.addColumn("WPM w/ penalty", Table.FLOAT);
}

//You can modify anything in here. This is just a basic implementation.
void draw()
{
  background(255); //clear background
  drawWatch(); //draw watch background
  fill(100);
  rect(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2, sizeOfInputArea, sizeOfInputArea); //input area should be 1" by 1"

  if (finishTime!=0)
  {
    fill(128);
    textAlign(CENTER);
    text("Finished", 280, 150);
    return;
  }

  if (startTime==0 & !mousePressed)
  {
    fill(128);
    textAlign(CENTER);
    text("Click to start time!", 280, 150); //display this messsage until the user clicks!
  }

  if (startTime==0 & mousePressed)
  {
    nextTrial(); //start the trials!
  }

  if (startTime!=0)
  {
    //feel free to change the size and position of the target/entered phrases and next button 
    textAlign(LEFT); //align the text left
    fill(128);
    text("Phrase " + (currTrialNum+1) + " of " + totalTrialNum, 70, 50); //draw the trial count
    fill(128);
    text("Target:   " + currentPhrase, 70, 100); //draw the target string
    text("Entered:  " + currentTyped +"|", 70, 140); //draw what the user has entered thus far 

    //draw very basic next button
    fill(255, 0, 0);
    rect(600, 600, 200, 200); //draw next button
    fill(255);
    text("NEXT > ", 650, 650); //draw next label

    float start_x = width/2-sizeOfInputArea/2;
    float start_y = height/2;
    float x_diff = sizeOfInputArea/3;
    float y_diff = sizeOfInputArea/6;
    int angle = 90;
    float diameter = sizeOfInputArea/2;

    //my draw code
    fill(255); 
    rect(start_x, start_y, sizeOfInputArea/3-0.5, sizeOfInputArea/6-0.5); //draw left red button
    textAlign(CENTER);
    fill(0);
    textSize(10);
    text("SPACE", start_x + sizeOfInputArea/6 - 5.0, start_y + y_diff - 10.0);
    
   
    fill(255);
    rect(start_x + 2.0 * x_diff, start_y, sizeOfInputArea/3-0.5, sizeOfInputArea/6-0.5);
    fill(0);
    text("DEL", start_x + 2 * x_diff + sizeOfInputArea/6 - 5.0, start_y + y_diff - 10.0);
    
    textSize(20);
    fill(255);
    rect(start_x + x_diff, start_y, sizeOfInputArea/3-0.5, sizeOfInputArea/6-0.5);
    fill(0);
    text("abcd", start_x + x_diff + sizeOfInputArea/6 - 5.0, start_y + y_diff - 10.0);
    
    
    fill(255);
    rect(start_x, start_y + y_diff, sizeOfInputArea/3-0.5, sizeOfInputArea/6-0.5);
    fill(0);
    text("efgh", start_x + sizeOfInputArea/6 - 5.0, start_y + 2 * y_diff - 10.0);
    
    fill(255);
    rect(start_x + x_diff, start_y + y_diff, sizeOfInputArea/3-0.5, sizeOfInputArea/6-0.5);
    fill(0);
    text("ijkl", start_x + x_diff + sizeOfInputArea/6 - 5.0, start_y + 2 * y_diff - 10.0);
    
    fill(255);
    rect(start_x + 2.0 * x_diff, start_y + y_diff, sizeOfInputArea/3-0.5, sizeOfInputArea/6-0.5);
    fill(0);
    text(" mnop", start_x + 2 * x_diff + sizeOfInputArea/6 - 5.0, start_y + 2 * y_diff - 10.0);
    
    fill(255);
    rect(start_x, start_y + 2 * y_diff, sizeOfInputArea/3-0.5, sizeOfInputArea/6-0.5);
    fill(0);
    text("qrst", start_x + sizeOfInputArea/6 - 5.0, start_y + 3 * y_diff - 10.0);
    
    fill(255);
    rect(start_x + x_diff, start_y + 2 * y_diff, sizeOfInputArea/3-0.5, sizeOfInputArea/6-0.5);
    fill(0);
    text("  uvwx", start_x + x_diff + sizeOfInputArea/6 - 5.0, start_y + 3 * y_diff - 10.0);
    
    fill(255);
    rect(start_x + 2.0 * x_diff, start_y + 2 * y_diff, sizeOfInputArea/3-0.5, sizeOfInputArea/6-0.5);
    fill(0);
    text("yz", start_x + 2 * x_diff + sizeOfInputArea/6 - 5.0, start_y + 3 * y_diff - 10.0);
    
    //for (float w_x = start_x; w_x < sizeOfInputArea; w_x = w_x + sizeOfInputArea/6) {
    //  for (float h_y = start_y; h_y < sizeOfInputArea/2; h_y = h_y + sizeOfInputArea/6) {
    //    fill(255);
    //    rect(w_x, h_y, sizeOfInputArea/3-0.5, sizeOfInputArea/6-0.5);
    //  }
    //}
    
    //fill(0, 255, 0); //green button
    //rect(width/2-sizeOfInputArea/2+sizeOfInputArea/2, height/2-sizeOfInputArea/2+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2); //draw right green button
    //textAlign(CENTER);
    
    //start_x + x_diff, start_y, sizeOfInputArea/3-0.5, sizeOfInputArea/6-0.5
    
   
    
    if ((mouseX >= start_x + x_diff) && (mouseX <= start_x + 2 * x_diff) && (mouseY >= start_y) && (mouseY <= start_y + y_diff)) { //"a"
    
      float cur_cir_x = start_x + x_diff + sizeOfInputArea/6;
      float cur_cir_y = start_y + sizeOfInputArea/12;
      
      float left_x_bound = start_x + x_diff;
      float middle_x_bound = left_x_bound + x_diff / 2;
      float right_x_bound = left_x_bound + x_diff;
      
      float upper_y_bound = start_y; // smaller value
      float middle_y_bound = upper_y_bound + y_diff / 2;
      float lower_y_bound = upper_y_bound + y_diff;
    
      fill(188);
      //ellipse(start_x + x_diff + sizeOfInputArea/6, start_y + sizeOfInputArea/12, sizeOfInputArea/3, sizeOfInputArea/4);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 0, radians(angle));
      fill(209);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, radians(angle) , 2 * radians(angle));
      fill(230);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 2 * radians(angle), 3 * radians(angle));
      fill(255);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 3 * radians(angle), 4 * radians(angle));
      
      char first = 'a';
      char second = 'b';
      char third = 'c';
      char fourth = 'd';
      
      textSize(20);
      
      fill(0);
      float first_x_pos = cur_cir_x - diameter/4;
      float first_y_pos = cur_cir_y - diameter/8;
      float second_x_pos = cur_cir_x + diameter/5;
      float second_y_pos = cur_cir_y - diameter/8;
      float third_x_pos = cur_cir_x + diameter/5;
      float third_y_pos = cur_cir_y + diameter/4;
      float fourth_x_pos = cur_cir_x - diameter/5;
      float fourth_y_pos = cur_cir_y + diameter/4;
      
      text(first, first_x_pos, first_y_pos);
      text(second, second_x_pos, second_y_pos);
      text(third, third_x_pos, third_y_pos);
      text(fourth, fourth_x_pos, fourth_y_pos);
      
      if ((mouseX >= left_x_bound) && (mouseX <= middle_x_bound) && (mouseY >= upper_y_bound) && (mouseY <= middle_y_bound)) {
        fill(200);
        text("" + first, width/2, height/2-sizeOfInputArea/4);
        currentLetter = first;
      } else if ((mouseX >= middle_x_bound) && (mouseX <= right_x_bound) && (mouseY >= upper_y_bound) && (mouseY <= middle_y_bound)) {
        fill(200);
        text("" + second, width/2, height/2-sizeOfInputArea/4);
        currentLetter = second;
      } else if ((mouseX >= middle_x_bound) && (mouseX <= right_x_bound) && (mouseY >= middle_y_bound) && (mouseY <= lower_y_bound)) {
        fill(200);
        text("" + third, width/2, height/2-sizeOfInputArea/4);
        currentLetter = third;
      } else if ((mouseX >= left_x_bound) && (mouseX <= middle_x_bound) && (mouseY >= middle_y_bound) && (mouseY <= lower_y_bound)) {
        fill(200);
        text("" + fourth, width/2, height/2-sizeOfInputArea/4);
        currentLetter = fourth;
      }
      
    } 
    else if ((mouseX >= start_x) && (mouseX <= start_x + x_diff) && (mouseY >= start_y + y_diff) && (mouseY <= start_y + 2 * y_diff)) { //'e'
      float left_x_bound = start_x;
      float middle_x_bound = left_x_bound + x_diff / 2;
      float right_x_bound = left_x_bound + x_diff;
      
      float upper_y_bound = start_y + y_diff; // smaller value
      float middle_y_bound = upper_y_bound + y_diff / 2;
      float lower_y_bound = upper_y_bound + y_diff;
      
      float cur_cir_x = left_x_bound + sizeOfInputArea/6;
      float cur_cir_y = upper_y_bound + sizeOfInputArea/12;
    
      fill(188);
      //ellipse(start_x + x_diff + sizeOfInputArea/6, start_y + sizeOfInputArea/12, sizeOfInputArea/3, sizeOfInputArea/4);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 0, radians(angle));
      fill(209);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, radians(angle) , 2 * radians(angle));
      fill(230);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 2 * radians(angle), 3 * radians(angle));
      fill(255);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 3 * radians(angle), 4 * radians(angle));
      
      char first = 'e';
      char second = 'f';
      char third = 'g';
      char fourth = 'h';
      
      textSize(20);
      
      fill(0);
      float first_x_pos = cur_cir_x - diameter/4;
      float first_y_pos = cur_cir_y - diameter/8;
      float second_x_pos = cur_cir_x + diameter/5;
      float second_y_pos = cur_cir_y - diameter/8;
      float third_x_pos = cur_cir_x + diameter/5;
      float third_y_pos = cur_cir_y + diameter/4;
      float fourth_x_pos = cur_cir_x - diameter/5;
      float fourth_y_pos = cur_cir_y + diameter/4;
      
      text(first, first_x_pos, first_y_pos);
      text(second, second_x_pos, second_y_pos);
      text(third, third_x_pos, third_y_pos);
      text(fourth, fourth_x_pos, fourth_y_pos);
      
      if ((mouseX >= left_x_bound) && (mouseX <= middle_x_bound) && (mouseY >= upper_y_bound) && (mouseY <= middle_y_bound)) {
        fill(200);
        text("" + first, width/2, height/2-sizeOfInputArea/4);
        currentLetter = first;
      } else if ((mouseX >= middle_x_bound) && (mouseX <= right_x_bound) && (mouseY >= upper_y_bound) && (mouseY <= middle_y_bound)) {
        fill(200);
        text("" + second, width/2, height/2-sizeOfInputArea/4);
        currentLetter = second;
      } else if ((mouseX >= middle_x_bound) && (mouseX <= right_x_bound) && (mouseY >= middle_y_bound) && (mouseY <= lower_y_bound)) {
        fill(200);
        text("" + third, width/2, height/2-sizeOfInputArea/4);
        currentLetter = third;
      } else if ((mouseX >= left_x_bound) && (mouseX <= middle_x_bound) && (mouseY >= middle_y_bound) && (mouseY <= lower_y_bound)) {
        fill(200);
        text("" + fourth, width/2, height/2-sizeOfInputArea/4);
        currentLetter = fourth;
      }
    } 
    else if ((mouseX >= start_x + x_diff) && (mouseX <= start_x + 2 * x_diff) && (mouseY >= start_y + y_diff) && (mouseY <= start_y + 2 * y_diff)) { //'i'
      float left_x_bound = start_x + x_diff;
      float middle_x_bound = left_x_bound + x_diff / 2;
      float right_x_bound = left_x_bound + x_diff;
      
      float upper_y_bound = start_y + y_diff; // smaller value
      float middle_y_bound = upper_y_bound + y_diff / 2;
      float lower_y_bound = upper_y_bound + y_diff;
      
      float cur_cir_x = left_x_bound + sizeOfInputArea/6;
      float cur_cir_y = upper_y_bound + sizeOfInputArea/12;
    
      fill(188);
      //ellipse(start_x + x_diff + sizeOfInputArea/6, start_y + sizeOfInputArea/12, sizeOfInputArea/3, sizeOfInputArea/4);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 0, radians(angle));
      fill(209);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, radians(angle) , 2 * radians(angle));
      fill(230);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 2 * radians(angle), 3 * radians(angle));
      fill(255);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 3 * radians(angle), 4 * radians(angle));
      
      char first = 'i';
      char second = 'j';
      char third = 'k';
      char fourth = 'l';
      
      textSize(20);
      
      fill(0);
      float first_x_pos = cur_cir_x - diameter/4;
      float first_y_pos = cur_cir_y - diameter/8;
      float second_x_pos = cur_cir_x + diameter/5;
      float second_y_pos = cur_cir_y - diameter/8;
      float third_x_pos = cur_cir_x + diameter/5;
      float third_y_pos = cur_cir_y + diameter/4;
      float fourth_x_pos = cur_cir_x - diameter/5;
      float fourth_y_pos = cur_cir_y + diameter/4;
      
      text(first, first_x_pos, first_y_pos);
      text(second, second_x_pos, second_y_pos);
      text(third, third_x_pos, third_y_pos);
      text(fourth, fourth_x_pos, fourth_y_pos);
      
      if ((mouseX >= left_x_bound) && (mouseX <= middle_x_bound) && (mouseY >= upper_y_bound) && (mouseY <= middle_y_bound)) {
        fill(200);
        text("" + first, width/2, height/2-sizeOfInputArea/4);
        currentLetter = first;
      } else if ((mouseX >= middle_x_bound) && (mouseX <= right_x_bound) && (mouseY >= upper_y_bound) && (mouseY <= middle_y_bound)) {
        fill(200);
        text("" + second, width/2, height/2-sizeOfInputArea/4);
        currentLetter = second;
      } else if ((mouseX >= middle_x_bound) && (mouseX <= right_x_bound) && (mouseY >= middle_y_bound) && (mouseY <= lower_y_bound)) {
        fill(200);
        text("" + third, width/2, height/2-sizeOfInputArea/4);
        currentLetter = third;
      } else if ((mouseX >= left_x_bound) && (mouseX <= middle_x_bound) && (mouseY >= middle_y_bound) && (mouseY <= lower_y_bound)) {
        fill(200);
        text("" + fourth, width/2, height/2-sizeOfInputArea/4);
        currentLetter = fourth;
      }
    } 
    else if ((mouseX >= start_x + 2 * x_diff) && (mouseX <= start_x + 3 * x_diff) && (mouseY >= start_y + y_diff) && (mouseY <= start_y + 2 * y_diff)) { //'m'
      float left_x_bound = start_x + 2 * x_diff;
      float middle_x_bound = left_x_bound + x_diff / 2;
      float right_x_bound = left_x_bound + x_diff;
      
      float upper_y_bound = start_y + y_diff; // smaller value
      float middle_y_bound = upper_y_bound + y_diff / 2;
      float lower_y_bound = upper_y_bound + y_diff;
      
      float cur_cir_x = left_x_bound + sizeOfInputArea/6;
      float cur_cir_y = upper_y_bound + sizeOfInputArea/12;
    
      fill(188);
      //ellipse(start_x + x_diff + sizeOfInputArea/6, start_y + sizeOfInputArea/12, sizeOfInputArea/3, sizeOfInputArea/4);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 0, radians(angle));
      fill(209);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, radians(angle) , 2 * radians(angle));
      fill(230);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 2 * radians(angle), 3 * radians(angle));
      fill(255);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 3 * radians(angle), 4 * radians(angle));
      
      char first = 'm';
      char second = 'n';
      char third = 'o';
      char fourth = 'p';
      
      textSize(20);
      
      fill(0);
      float first_x_pos = cur_cir_x - diameter/4;
      float first_y_pos = cur_cir_y - diameter/8;
      float second_x_pos = cur_cir_x + diameter/5;
      float second_y_pos = cur_cir_y - diameter/8;
      float third_x_pos = cur_cir_x + diameter/5;
      float third_y_pos = cur_cir_y + diameter/4;
      float fourth_x_pos = cur_cir_x - diameter/5;
      float fourth_y_pos = cur_cir_y + diameter/4;
      
      text(first, first_x_pos, first_y_pos);
      text(second, second_x_pos, second_y_pos);
      text(third, third_x_pos, third_y_pos);
      text(fourth, fourth_x_pos, fourth_y_pos);
      
      if ((mouseX >= left_x_bound) && (mouseX <= middle_x_bound) && (mouseY >= upper_y_bound) && (mouseY <= middle_y_bound)) {
        fill(200);
        text("" + first, width/2, height/2-sizeOfInputArea/4);
        currentLetter = first;
      } else if ((mouseX >= middle_x_bound) && (mouseX <= right_x_bound) && (mouseY >= upper_y_bound) && (mouseY <= middle_y_bound)) {
        fill(200);
        text("" + second, width/2, height/2-sizeOfInputArea/4);
        currentLetter = second;
      } else if ((mouseX >= middle_x_bound) && (mouseX <= right_x_bound) && (mouseY >= middle_y_bound) && (mouseY <= lower_y_bound)) {
        fill(200);
        text("" + third, width/2, height/2-sizeOfInputArea/4);
        currentLetter = third;
      } else if ((mouseX >= left_x_bound) && (mouseX <= middle_x_bound) && (mouseY >= middle_y_bound) && (mouseY <= lower_y_bound)) {
        fill(200);
        text("" + fourth, width/2, height/2-sizeOfInputArea/4);
        currentLetter = fourth;
      }
    } 
    else if ((mouseX >= start_x) && (mouseX <= start_x + x_diff) && (mouseY >= start_y + 2 * y_diff) && (mouseY <= start_y + 3 * y_diff)) { //'q'
      float left_x_bound = start_x;
      float middle_x_bound = left_x_bound + x_diff / 2;
      float right_x_bound = left_x_bound + x_diff;
      
      float upper_y_bound = start_y + 2 * y_diff; // smaller value
      float middle_y_bound = upper_y_bound + y_diff / 2;
      float lower_y_bound = upper_y_bound + y_diff;
      
      float cur_cir_x = left_x_bound + sizeOfInputArea/6;
      float cur_cir_y = upper_y_bound + sizeOfInputArea/12;
    
      fill(188);
      //ellipse(start_x + x_diff + sizeOfInputArea/6, start_y + sizeOfInputArea/12, sizeOfInputArea/3, sizeOfInputArea/4);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 0, radians(angle));
      fill(209);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, radians(angle) , 2 * radians(angle));
      fill(230);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 2 * radians(angle), 3 * radians(angle));
      fill(255);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 3 * radians(angle), 4 * radians(angle));
      
      char first = 'q';
      char second = 'r';
      char third = 's';
      char fourth = 't';
      
      textSize(20);
      
      fill(0);
      float first_x_pos = cur_cir_x - diameter/4;
      float first_y_pos = cur_cir_y - diameter/8;
      float second_x_pos = cur_cir_x + diameter/5;
      float second_y_pos = cur_cir_y - diameter/8;
      float third_x_pos = cur_cir_x + diameter/5;
      float third_y_pos = cur_cir_y + diameter/4;
      float fourth_x_pos = cur_cir_x - diameter/5;
      float fourth_y_pos = cur_cir_y + diameter/4;
      
      text(first, first_x_pos, first_y_pos);
      text(second, second_x_pos, second_y_pos);
      text(third, third_x_pos, third_y_pos);
      text(fourth, fourth_x_pos, fourth_y_pos);
      
      if ((mouseX >= left_x_bound) && (mouseX <= middle_x_bound) && (mouseY >= upper_y_bound) && (mouseY <= middle_y_bound)) {
        fill(200);
        text("" + first, width/2, height/2-sizeOfInputArea/4);
        currentLetter = first;
      } else if ((mouseX >= middle_x_bound) && (mouseX <= right_x_bound) && (mouseY >= upper_y_bound) && (mouseY <= middle_y_bound)) {
        fill(200);
        text("" + second, width/2, height/2-sizeOfInputArea/4);
        currentLetter = second;
      } else if ((mouseX >= middle_x_bound) && (mouseX <= right_x_bound) && (mouseY >= middle_y_bound) && (mouseY <= lower_y_bound)) {
        fill(200);
        text("" + third, width/2, height/2-sizeOfInputArea/4);
        currentLetter = third;
      } else if ((mouseX >= left_x_bound) && (mouseX <= middle_x_bound) && (mouseY >= middle_y_bound) && (mouseY <= lower_y_bound)) {
        fill(200);
        text("" + fourth, width/2, height/2-sizeOfInputArea/4);
        currentLetter = fourth;
      }
    } 
    else if ((mouseX >= start_x + x_diff) && (mouseX <= start_x + 2 * x_diff) && (mouseY >= start_y + 2 * y_diff) && (mouseY <= start_y + 3 * y_diff)) { //'u'
      float left_x_bound = start_x + x_diff;
      float middle_x_bound = left_x_bound + x_diff / 2;
      float right_x_bound = left_x_bound + x_diff;
      
      float upper_y_bound = start_y + 2 * y_diff; // smaller value
      float middle_y_bound = upper_y_bound + y_diff / 2;
      float lower_y_bound = upper_y_bound + y_diff;
      
      float cur_cir_x = left_x_bound + sizeOfInputArea/6;
      float cur_cir_y = upper_y_bound + sizeOfInputArea/12;
    
      fill(188);
      //ellipse(start_x + x_diff + sizeOfInputArea/6, start_y + sizeOfInputArea/12, sizeOfInputArea/3, sizeOfInputArea/4);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 0, radians(angle));
      fill(209);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, radians(angle) , 2 * radians(angle));
      fill(230);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 2 * radians(angle), 3 * radians(angle));
      fill(255);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 3 * radians(angle), 4 * radians(angle));
      
      char first = 'u';
      char second = 'v';
      char third = 'w';
      char fourth = 'x';
      
      textSize(20);
      
      fill(0);
      float first_x_pos = cur_cir_x - diameter/4;
      float first_y_pos = cur_cir_y - diameter/8;
      float second_x_pos = cur_cir_x + diameter/5;
      float second_y_pos = cur_cir_y - diameter/8;
      float third_x_pos = cur_cir_x + diameter/5;
      float third_y_pos = cur_cir_y + diameter/4;
      float fourth_x_pos = cur_cir_x - diameter/5;
      float fourth_y_pos = cur_cir_y + diameter/4;
      
      text(first, first_x_pos, first_y_pos);
      text(second, second_x_pos, second_y_pos);
      text(third, third_x_pos, third_y_pos);
      text(fourth, fourth_x_pos, fourth_y_pos);
      
      if ((mouseX >= left_x_bound) && (mouseX <= middle_x_bound) && (mouseY >= upper_y_bound) && (mouseY <= middle_y_bound)) {
        fill(200);
        text("" + first, width/2, height/2-sizeOfInputArea/4);
        currentLetter = first;
      } else if ((mouseX >= middle_x_bound) && (mouseX <= right_x_bound) && (mouseY >= upper_y_bound) && (mouseY <= middle_y_bound)) {
        fill(200);
        text("" + second, width/2, height/2-sizeOfInputArea/4);
        currentLetter = second;
      } else if ((mouseX >= middle_x_bound) && (mouseX <= right_x_bound) && (mouseY >= middle_y_bound) && (mouseY <= lower_y_bound)) {
        fill(200);
        text("" + third, width/2, height/2-sizeOfInputArea/4);
        currentLetter = third;
      } else if ((mouseX >= left_x_bound) && (mouseX <= middle_x_bound) && (mouseY >= middle_y_bound) && (mouseY <= lower_y_bound)) {
        fill(200);
        text("" + fourth, width/2, height/2-sizeOfInputArea/4);
        currentLetter = fourth;
      }
    } 
    else if ((mouseX >= start_x + 2 * x_diff) && (mouseX <= start_x + 3 * x_diff) && (mouseY >= start_y + 2 * y_diff) && (mouseY <= start_y + 3 * y_diff)) { //'y'
      float left_x_bound = start_x + 2 * x_diff;
      float middle_x_bound = left_x_bound + x_diff / 2;
      float right_x_bound = left_x_bound + x_diff;
      
      float upper_y_bound = start_y + 2 * y_diff; // smaller value
      float middle_y_bound = upper_y_bound + y_diff / 2;
      float lower_y_bound = upper_y_bound + y_diff;
      
      float cur_cir_x = left_x_bound + sizeOfInputArea/6;
      float cur_cir_y = upper_y_bound + sizeOfInputArea/12;
    
      fill(188);
      //ellipse(start_x + x_diff + sizeOfInputArea/6, start_y + sizeOfInputArea/12, sizeOfInputArea/3, sizeOfInputArea/4);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 0, radians(angle));
      fill(209);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, radians(angle) , 2 * radians(angle));
      fill(230);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 2 * radians(angle), 3 * radians(angle));
      fill(255);
      arc(cur_cir_x, cur_cir_y, diameter, diameter - 10, 3 * radians(angle), 4 * radians(angle));
      
      char first = 'y';
      char second = 'z';
      //char third = 'w';
      //char fourth = 'x';
      
      textSize(20);
      
      fill(0);
      float first_x_pos = cur_cir_x - diameter/4;
      float first_y_pos = cur_cir_y - diameter/8;
      float second_x_pos = cur_cir_x + diameter/5;
      float second_y_pos = cur_cir_y - diameter/8;
      //float third_x_pos = cur_cir_x + diameter/5;
      //float third_y_pos = cur_cir_y + diameter/4;
      //float fourth_x_pos = cur_cir_x - diameter/5;
      //float fourth_y_pos = cur_cir_y + diameter/4;
      
      text(first, first_x_pos, first_y_pos);
      text(second, second_x_pos, second_y_pos);
      //text(third, third_x_pos, third_y_pos);
      //text(fourth, fourth_x_pos, fourth_y_pos);
      
      if ((mouseX >= left_x_bound) && (mouseX <= middle_x_bound) && (mouseY >= upper_y_bound) && (mouseY <= middle_y_bound)) {
        fill(200);
        text("" + first, width/2, height/2-sizeOfInputArea/4);
        currentLetter = first;
      } else if ((mouseX >= middle_x_bound) && (mouseX <= right_x_bound) && (mouseY >= upper_y_bound) && (mouseY <= middle_y_bound)) {
        fill(200);
        text("" + second, width/2, height/2-sizeOfInputArea/4);
        currentLetter = second;
      } 
      //else if ((mouseX >= middle_x_bound) && (mouseX <= right_x_bound) && (mouseY >= middle_y_bound) && (mouseY <= lower_y_bound)) {
      //  fill(200);
      //  text("" + third, width/2, height/2-sizeOfInputArea/4);
      //  currentLetter = third;
      //} else if ((mouseX >= left_x_bound) && (mouseX <= middle_x_bound) && (mouseY >= middle_y_bound) && (mouseY <= lower_y_bound)) {
      //  fill(200);
      //  text("" + fourth, width/2, height/2-sizeOfInputArea/4);
      //  currentLetter = fourth;
      //}
    }
    
     //draw current letter
  }
}

//my terrible implementation you can entirely replace
boolean didMouseClick(float x, float y, float w, float h) //simple function to do hit testing
{
  return (mouseX > x && mouseX<x+w && mouseY>y && mouseY<y+h); //check to see if it is in button bounds
}

//my terrible implementation you can entirely replace
void mousePressed()
{
  float start_x = width/2-sizeOfInputArea/2;
  float start_y = height/2-sizeOfInputArea/2+sizeOfInputArea/2;
  float x_diff = sizeOfInputArea/3;
  float y_diff = sizeOfInputArea/6;
  //if (didMouseClick(start_x + x_diff, start_y, sizeOfInputArea/3-0.5, sizeOfInputArea/6-0.5)) //clicks on the "a" rectangle
  //{
  //  //currentLetter --;
  //  //if (currentLetter<'_') //wrap around to z
  //  //  currentLetter = 'z';
  //    fill(167);
  //    circle(start_x + sizeOfInputArea/6, start_y + sizeOfInputArea/6, sizeOfInputArea/6);
   
  //}

  //if (didMouseClick(width/2-sizeOfInputArea/2+sizeOfInputArea/2, height/2-sizeOfInputArea/2+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2)) //check if click in right button
  //{
  //  currentLetter ++;
  //  if (currentLetter>'z') //wrap back to space (aka underscore)
  //    currentLetter = '_';
  //}
  
 
  
  if (didMouseClick(width/2-sizeOfInputArea/2, height/2, sizeOfInputArea, sizeOfInputArea/2)) //check if click occured in letter area
  {
     if (didMouseClick(start_x + 2.0 * x_diff, start_y, sizeOfInputArea/3-0.5, sizeOfInputArea/6-0.5) && currentTyped.length()>=1)
    {
      String tmp=currentTyped.substring(0, currentTyped.length()-1);
      currentTyped = ""; //delete
      currentTyped =tmp;
    }
    
    
    else if (didMouseClick(start_x, start_y, sizeOfInputArea/3-0.5, sizeOfInputArea/6-0.5))
    {
      currentTyped+=" "; //space
    } else {
      currentTyped+=currentLetter;
    }
  //  if (currentLetter=='_') //if underscore, consider that a space bar
  //    currentTyped+=" ";
  //  else if (currentLetter=='`' & currentTyped.length()>0) //if `, treat that as a delete command
  //    currentTyped = currentTyped.substring(0, currentTyped.length()-1);
  //  else if (currentLetter!='`') //if not any of the above cases, add the current letter to the typed string
  //    currentTyped+=currentLetter;
  }
  

  //You are allowed to have a next button outside the 1" area
  if (didMouseClick(600, 600, 200, 200)) //check if click is in next button
  {
    nextTrial(); //if so, advance to next trial
  }
}


void nextTrial()
{
  if (currTrialNum >= totalTrialNum) //check to see if experiment is done
    return; //if so, just return

  if (startTime!=0 && finishTime==0) //in the middle of trials
  {
    System.out.println("==================");
    System.out.println("Phrase " + (currTrialNum+1) + " of " + totalTrialNum); //output
    System.out.println("Target phrase: " + currentPhrase); //output
    System.out.println("Phrase length: " + currentPhrase.length()); //output
    System.out.println("User typed: " + currentTyped); //output
    System.out.println("User typed length: " + currentTyped.length()); //output
    System.out.println("Number of errors: " + computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim())); //trim whitespace and compute errors
    System.out.println("Time taken on this trial: " + (millis()-lastTime)); //output
    System.out.println("Time taken since beginning: " + (millis()-startTime)); //output
    System.out.println("==================");
    lettersExpectedTotal+=currentPhrase.trim().length();
    lettersEnteredTotal+=currentTyped.trim().length();
    errorsTotal+=computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim());
  }

  //probably shouldn't need to modify any of this output / penalty code.
  if (currTrialNum == totalTrialNum-1) //check to see if experiment just finished
  {
    finishTime = millis();
    System.out.println("==================");
    System.out.println("Trials complete!"); //output
    System.out.println("Total time taken: " + (finishTime - startTime)); //output
    System.out.println("Total letters entered: " + lettersEnteredTotal); //output
    System.out.println("Total letters expected: " + lettersExpectedTotal); //output
    System.out.println("Total errors entered: " + errorsTotal); //output

    float wpm = (lettersEnteredTotal/5.0f)/((finishTime - startTime)/60000f); //FYI - 60K is number of milliseconds in minute
    float freebieErrors = lettersExpectedTotal*.05; //no penalty if errors are under 5% of chars
    float penalty = max(errorsTotal-freebieErrors, 0) * .5f;
    
    System.out.println("Raw WPM: " + wpm); //output
    System.out.println("Freebie errors: " + freebieErrors); //output
    System.out.println("Penalty: " + penalty);
    System.out.println("WPM w/ penalty: " + (wpm-penalty)); //yes, minus, becuase higher WPM is better
    System.out.println("==================");

    currTrialNum++; //increment by one so this mesage only appears once when all trials are done
    
    TableRow row = table.addRow();
    row.setString("user_ID",andrew_id);
    row.setInt("cycle_number",currTrialNum);
    row.setFloat("Total time taken", (finishTime - startTime));
    row.setFloat("Total letters entered", lettersEnteredTotal);
    row.setFloat("Total letters expected", lettersExpectedTotal);
    row.setFloat("Total errors entered", errorsTotal);
    row.setFloat("Raw WPM", wpm);
    row.setFloat("Freebie errors", freebieErrors);
    row.setFloat("Penalty", penalty);
    row.setFloat("WPM w/ penalty", (wpm-penalty));
        
    saveTable(table, "performance.csv");
    
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
        
    return;
  }

  if (startTime==0) //first trial starting now
  {
    System.out.println("Trials beginning! Starting timer..."); //output we're done
    startTime = millis(); //start the timer!
  } 
  else
    currTrialNum++; //increment trial number

  lastTime = millis(); //record the time of when this trial ended
  currentTyped = ""; //clear what is currently typed preparing for next trial
  currentPhrase = phrases[currTrialNum]; // load the next phrase!
  //currentPhrase = "abc"; // uncomment this to override the test phrase (useful for debugging)

}


void drawWatch()
{
  float watchscale = DPIofYourDeviceScreen/138.0;
  pushMatrix();
  translate(width/2, height/2);
  scale(watchscale);
  imageMode(CENTER);
  image(watch, 0, 0);
  popMatrix();
}





//=========SHOULD NOT NEED TO TOUCH THIS METHOD AT ALL!==============
int computeLevenshteinDistance(String phrase1, String phrase2) //this computers error between two strings
{
  int[][] distance = new int[phrase1.length() + 1][phrase2.length() + 1];

  for (int i = 0; i <= phrase1.length(); i++)
    distance[i][0] = i;
  for (int j = 1; j <= phrase2.length(); j++)
    distance[0][j] = j;

  for (int i = 1; i <= phrase1.length(); i++)
    for (int j = 1; j <= phrase2.length(); j++)
      distance[i][j] = min(min(distance[i - 1][j] + 1, distance[i][j - 1] + 1), distance[i - 1][j - 1] + ((phrase1.charAt(i - 1) == phrase2.charAt(j - 1)) ? 0 : 1));

  return distance[phrase1.length()][phrase2.length()];
}
