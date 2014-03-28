class WiiPlot{
  int[] xDraw;
  int[] yDraw;
  int[] zDraw;
  int[] magXYZ;
  int maxXYZ = 0;
  int graphWidth, centerline;
  int displayCount = 0;
  int displayMax =3;
  float displayValue=0;

  WiiPlot (int enterWidth, int enterCenterline){
    // Drawing Wii values
    graphWidth =enterWidth;
    centerline =enterCenterline;
    xDraw = new int[graphWidth];
    yDraw = new int[graphWidth];
    zDraw = new int[graphWidth];
    magXYZ = new int[graphWidth];    
  }

  void update(int x, int y, int z, boolean displayX, boolean displayY, boolean displayZ, boolean displayM){
    //add new data to array
    xDraw[graphWidth-1] = x;
    yDraw[graphWidth-1] = y;
    zDraw[graphWidth-1] = z;
    magXYZ[graphWidth-1] = int(mag(x,y,z));


    //move graph to the left
    if (updateGraph){
    for(int i=1; i<graphWidth; i++) { 
      xDraw[i-1] = xDraw[i]; 
      yDraw[i-1] = yDraw[i];
      zDraw[i-1] = zDraw[i];
      magXYZ[i-1] = magXYZ[i];
    } }
    
      if (displayM){
      //draw magnitude line in legend
      stroke (0, 0, 255);
      beginShape();
      vertex (screenwidth-100, screenheight-100);
      vertex (screenwidth-90, screenheight-100);
      endShape();
      textFont(font, 12);
      text ("magnitude", screenwidth - 80, screenheight-95);
    }else stroke(0);
      //draw magnitude graph
      beginShape();
      for(int i=1; i<graphWidth; i++) {
        vertex(i, centerline-magXYZ[i]/10);
        maxXYZ = max(magXYZ[i], maxXYZ);
      }
      endShape();
      beginShape();
      for(int i=0; i<graphWidth; i++) {
        vertex(i, centerline+magXYZ[i]/10);
      }
      endShape();

    if (displayX){
      stroke (255, 255, 0);
      // draw x line in legend
      beginShape();
      vertex (screenwidth-100, screenheight-90);
      vertex (screenwidth-90, screenheight-90);
      endShape();
      textFont(font, 12);
      text ("x", screenwidth - 80, screenheight-85);
      
      // draw x graph
      beginShape();
      for(int i=0; i<graphWidth; i++) { 
        vertex(i, centerline-xDraw[i]/10);
      } 
      endShape();
    }
    if (displayY){
      stroke (255, 0, 255);

      beginShape();
      vertex (screenwidth-100, screenheight-80);
      vertex (screenwidth-90, screenheight-80);
      endShape();
      textFont(font, 12);
      text ("y", screenwidth - 80, screenheight-75);
      
      //draw y graph
      
      beginShape();
      for(int i=0; i<graphWidth; i++) { 
        vertex(i, centerline-yDraw[i]/10);
      }
      endShape();
    }
    if (displayZ){
      stroke (0, 255, 255);
      
      // draw z line in legend
      beginShape();
      vertex (screenwidth-100, screenheight-70);
      vertex (screenwidth-90, screenheight-70);
      endShape();
      textFont(font, 12);
      text ("z", screenwidth - 80, screenheight-65);

      //draw z graph
      beginShape();
      for(int i=0; i<graphWidth; i++) { 
        vertex(i, centerline-zDraw[i]/10);
      }
      endShape();
    }
  
    // magnitude # readout
    fill (0,0,255);
    textAlign(RIGHT);
    textFont(font, 24);
    text("magnitude ", graphWidth-70, centerline-100);
    textAlign(LEFT);
    if (displayCount ==0){
      displayValue = float(magXYZ[graphWidth-1])/10;
    }
    text(nf(displayValue, 2,1), graphWidth-70, centerline-100);
    //text(nf(float(magXYZ[graphWidth-1])/10, 2,1), graphWidth-70, centerline-100);

    // maximum # readoutx
    fill (150);
    textAlign(LEFT);
    text("max "+float(maxXYZ)/10, 25, centerline-10-maxXYZ/10);
    noFill();

    //maximum line
    stroke(150);  
    patternLine(0, centerline-maxXYZ/10, graphWidth, centerline-maxXYZ/10, 0x5555, 1 );
    //  beginShape();
    //  vertex(0, 255-maxXYZ);
    //  vertex(width, 255-maxXYZ);
    //  endShape();

    // zero line
    stroke(200);  
    patternLine(0, centerline, graphWidth, centerline, 0x5555, 4 );

    maxXYZ = 0;
    displayCount = (displayCount +1)%displayMax;
  }

}



