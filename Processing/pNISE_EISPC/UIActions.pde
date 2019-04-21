void keyPressed() {
  println(keyCode);

  if (key == ENTER) {                // run dijkstra twice in order to attain gateway costs
    
    start = System.currentTimeMillis();
    
//    dBarValue = (1+eps)*spCost;
    ArrayList<BiPoint> ll = doNiseThings();
    
    elapsed = System.currentTimeMillis() - start;
    
    exportSupportedBiObjectivePoints(ll);
    sup = ll.size();
    //printList(ss);
    
    if (count > 0)
      println("NISE Completed, Dijkstra ran " + count + " times");
    else
      println("There's an error somewhere");    
    
    printRuntime(elapsed);
  }

  else if (key == TAB) {
    /*    if (looping) {
     noLoop();
     looping = false;
     }
     else {
     loop();
     looping = true;
     }*/
  }

  else if (keyPressed && keyCode == 18) {
    println("OPTION BABY!!");
//    for (int i = 0; i < cells.length; i++) {
//      if(cells[i].blackNode == false) { 
//          cells[i].bkpColor = cells[i].nodeColor;
//          cells[i].nodeColor = cClear;
//      }
//    }
    for (int i = 0; i < arcs.length; i++) {
      arcs[i].bkpColor = arcs[i].arcColor;
      arcs[i].arcColor = cClear;
    }
  }

  else if (key == '1') {  // the number 1 causes only for forward path to show
    disp2 = 1;
  }

  else if (key == '2') {  // the number 2 causes only for forward path to show
    disp2 = 2;
  }

  else if (key == 'a') {  // the letter A causes the nodes to toggle on and off
    nodesView = !nodesView;
  }

  else if (key == 'e') {  // the letter E exports all gateway node path lengths and area differences to a file
    start = System.currentTimeMillis();
    
    // reverse dijkstra
    //runDijkstra(endingNode, startingNode, 1, cLabels);
    
    elapsed = System.currentTimeMillis() - start;

    printRuntime(elapsed);
  }

  else if (key == 'i') {  // the letter i initializes the NSP Algorithm
    double a = 1;
    start = System.currentTimeMillis();
    BiPoint bP = new BiPoint(a, runDijkstra(startingNode, endingNode, a));
    elapsed = System.currentTimeMillis() - start;
    println(bP.getZ1() + "\t" + bP.getZ2());
    printRuntime(elapsed);
  }

  else if (key == 'r') {  // the letter R causes the top layer of tree to toggle
    if (disp2 == 1) {
      disp2 = 2;
    }
    else {
      disp2 = 1;
    }
  }

  else if (key == 't') {  // the letter T calculates dijsktra and order of reverse path
  }

  else if (key == 'y') {  // the char y calculates strahler stream order for the forward path
//    
//    start = System.currentTimeMillis();
//    pathCount = iterateNSP(startingNode, endingNode, dBarValue);
//    elapsed = System.currentTimeMillis() - start;
//    printRuntime(elapsed);
//    println("number of paths found was " + pathCount);
//    println("passes = " + passes);
//    displayNSP();
  }

  else {
    //iterateNSP();
  }

  redraw();
}

void keyReleased() {
  if (keyCode == 18) {
//    for (int i = 0; i < cells.length; i++) {
//      if (cells[i].blackNode == false) {
//        cells[i].nodeColor = cells[i].bkpColor;
//      }
//    }
    for (int i = 0; i < arcs.length; i++) {
      arcs[i].arcColor = arcs[i].bkpColor;
      //arcs[i].arcColor2 = arcs[i].bkpColor2;
    }
  }
  redraw();
}

void mouseClicked() {
  //exit(); 
}
// display the path length with the clicked gateway point
//void mouseClicked() {

  //  clicked = true;
  //
  //  if (mouseY >= 33 && mouseX >= 33 && mouseY < 753 && mouseX < 753 && allCalc) {
  //
  //    // convert previously clicked node to prior color
  //    if (cells[mouseRow][mouseCol].bkpColor != cClear) {
  //      cells[mouseRow][mouseCol].nodeColor = cells[mouseRow][mouseCol].bkpColor;
  //    }
  //    
  //    // convert previously shown path to original color
  //    if (gNodeStore != -1) {
  //      gNode = gNodeStore;
  //      
  //      while (gNode != startNode) {
  //         arcs[cells[i2r(gNode)][i2c(gNode)].prevArc1].arcColor = arcs[cells[i2r(gNode)][i2c(gNode)].prevArc1].bkpColor;
  //         arcs[cells[i2r(gNode)][i2c(gNode)].prevArc1].bkpColor = cClear;
  //         gNode = cells[i2r(gNode)][i2c(gNode)].previousNode1;
  //      }
  //      gNode = gNodeStore;
  //          
  //      while (gNode != endNode) {
  //        arcs[cells[i2r(gNode)][i2c(gNode)].prevArc2].arcColor2 = arcs[cells[i2r(gNode)][i2c(gNode)].prevArc2].bkpColor2;
  //        arcs[cells[i2r(gNode)][i2c(gNode)].prevArc2].bkpColor2 = cClear;
  //        gNode = cells[i2r(gNode)][i2c(gNode)].previousNode2;
  //      }
  //    }
  //
  //    // Determine which cell was just clicked    
  //    mouseRow = (mouseY - 33) / cellSize;
  //    mouseCol = (mouseX - 33) / cellSize;
  //    gNode = rc2i(mouseRow,mouseCol);
  //    gNodeStore = gNode;
  //
  //    if (cells[mouseRow][mouseCol].nodeColor != cBlack) {
  //      
  //      area = gatewayAreaDiff(gNode);
  //
  //      println("gateway cost = " + str(cells[mouseRow][mouseCol].gwCost));
  //      println("gateway path area difference = " + area);
  //      println("forward chain length = " + str(cells[mouseRow][mouseCol].chainLength1));
  //      println("reverse chain length = " + str(cells[mouseRow][mouseCol].chainLength2));
  //     
  //      // change node to green
  //      cells[mouseRow][mouseCol].bkpColor = cells[mouseRow][mouseCol].nodeColor;
  //      cells[mouseRow][mouseCol].nodeColor = cGreen;
  //      
  //      // change gateway path to green
  //      while (gNode != startNode) {
  //        arcs[cells[i2r(gNode)][i2c(gNode)].prevArc1].bkpColor = arcs[cells[i2r(gNode)][i2c(gNode)].prevArc1].arcColor;
  //        arcs[cells[i2r(gNode)][i2c(gNode)].prevArc1].arcColor = cGreen;
  //        gNode = cells[i2r(gNode)][i2c(gNode)].previousNode1;
  //      }
  //      
  //      gNode = gNodeStore;
  //        
  //      while (gNode != endNode) {
  //        arcs[cells[i2r(gNode)][i2c(gNode)].prevArc2].bkpColor2 = arcs[cells[i2r(gNode)][i2c(gNode)].prevArc2].arcColor2;
  //        arcs[cells[i2r(gNode)][i2c(gNode)].prevArc2].arcColor2 = cGreen;
  //        gNode = cells[i2r(gNode)][i2c(gNode)].previousNode2;
  //      }
  //    }
  //    
  //    else {
  //      text("Gateway cost = invalid",541,800);
  //      gNode = -1;
  //    }
  //  }
//  refresh();
//}


// display the row and column where the mouse is located
//void mouseMoved() {
  /*  
   fill(180);
   //noStroke();
   rect(534,760,216,48);
   
   // show text displaying row and column of cell that mouse is over
   
   if (mouseY >= 33 && mouseX >= 33 && mouseY < 753 && mouseX < 753) {
   
   mouseRow = (mouseY - 33) / cellSize;
   mouseCol = (mouseX - 33) / cellSize;
   
   fill(0);
   textFont(font,20);
   textAlign(LEFT);
   text("Row = " + str(mouseRow),541,780);
   text("Column = " + str(mouseCol),641,780);
   //println((mouseX - 33) / cellSize + " " + (mouseY - 33) / cellSize);
   }
   */
//}

void printRuntime(long elapsed) {

  days = (int) elapsed/86400000;
  int rem = (int) (elapsed%86400000);
  hours = rem / 3600000;
  rem = rem % 3600000;
  minutes = rem / 60000;
  rem = rem % 60000;
  seconds = rem / 1000.0;
  
  t_sec = elapsed / 1000.0;
  
  text("Time (d:h:m:s) = " + days + ":" + hours + ":" + minutes + ":" + seconds,282,820);
  println("runtime took " + days + " days, " + hours + " hours, " + minutes + " minutes, and " +
           seconds + " seconds (" + elapsed + " total ms)");
}
