import java.util.*;
import java.text.*;
int infoH=100, disp=0, sh, sw, maxN, expN, FB=0, exLevel=5, goodLevel=20, resp;
int hh, hw, gap, numT=12, trl=0, fS=50, numB=4, fixd=500, tlmt=5000,ll;
int[] bX= new int[4];
int[] numL= {
  5, 5, 8, 5
};
int[] maxes = {
  100, 1000
}
, boxF= {
  0, 0, 0, 0
};
int[][] numbers = {
  {
    2,4,6,18,42,71
  }
  , {
    4,6,18,71,230,780
  }
};
int[] wt = new int[numT], lineX = new int[numT], bgnX = new int[numT], endX = new int[numT];
float[] ratioX=new float[numT];
PImage img, mik, bye, exel, good, ng;
Boolean delFlg=false, clrFlg=false, lineFlg=false, startFlg=true, fbFlg=false, tlFlg=false, endFlg=false, andr=true, exitFlg=false;
PFont fnt;
String fname;
PrintWriter output;
long timer;
String fld;

void setup() {
  //println(andr);
  if (!andr) {

    fnt=createFont("HiraMaruPro-W4", fS);
    textFont(fnt);

    size(1280, 640); 
    sw=1280;
  } else {
    orientation(LANDSCAPE);
    sw=displayWidth;
  }

  sh=640;
  //println(sh);
  gap=sw/10;
  //sh=displayHeight;
  ll=sw-gap*2;
  hw=sw/2;
  hh=(sh-infoH)/2;
  for (int i=0; i<numB; i++)
    bX[i]=sw/numB*(i+1);

  smooth();

  img=loadImage("start.png");
  mik=loadImage("P2.png");
  bye=loadImage("P3.png");
  exel=loadImage("exel.png");
  good=loadImage("good.png");
  ng=loadImage("ng.png");
  textSize(fS);
  textAlign(CENTER, CENTER);

  strokeWeight(5);
  background(255);
  //println(numbers.length);
  wt=randPerm(numT);
  rectMode(CENTER);
  frameRate(60);
  Date date1 = new Date();
  SimpleDateFormat sdf1 = new SimpleDateFormat("yyyyMMddhhmm");
  if (andr)
    fld="///sdcard/DCIM/processing/result/"+sdf1.format(date1)+"/";
  else
    fld="./result/"+sdf1.format(date1)+"/";
  fname=fld+"result.csv";
  //fname=sdf1.format(date1)+".csv";
  output=createWriter(fname);
  output.println("trl,MaxN,CrtAns,Response,1st X,Last X,Crs X");
  imageMode(CENTER);
}


void draw() {
  if (exitFlg) {
    image(bye, hw, hh+infoH/2);
    if (millis()-timer>1000)
      exit();
  } else if (startFlg) {
    image(img, hw, hh+infoH/2);
    noStroke();
    if (fbFlg) {
      fill(255, 0, 0);
      rect(hw-145, hh+60, 30, 30);
    }
    if (tlFlg) {
      fill(255, 0, 0);
      rect(hw-145, hh+140, 30, 30);
    }
  } else if (endFlg) {
    background(255);
    if (fbFlg) {
      if (FB==0)
        image(mik, hw, hh+infoH/2);
      else if (FB==1)
        image(exel, hw, hh+infoH/2);
      else if (FB==2)
        image(good, hw, hh+infoH/2);
      else if (FB==3)
        image(ng, hw, hh+infoH/2);
      else {
        exitFlg=true;
        timer=millis();
      }
    }
    if (millis()-timer>1000) {
      exitFlg=true;
      timer=millis();
    }
  } else {
    if (disp==0) {
      background(255);
      if (fbFlg) {
        if (FB==0)
          image(mik, hw, hh+infoH/2);
        else if (FB==1)
          image(exel, hw, hh+infoH/2);
        else if (FB==2)
          image(good, hw, hh+infoH/2);
        else if (FB==3)
          image(ng, hw, hh+infoH/2);
      } else
        image(mik, hw, hh+infoH/2);
      if (millis()-timer>fixd) {
        disp++;
        timer=millis();
        background(255);
      }
    } else if (disp==1) {
      if (clrFlg) {
        background(255);
        clrFlg=false;
      }
      maxN=maxes[floor(wt[trl]/numbers[0].length)];
      expN=numbers[floor(wt[trl]/numbers[0].length)][wt[trl]%numbers[0].length];
      stroke(0);
      fill(0);
      text("0", gap, hh+50);
      text(str(maxN), hw*2-gap, hh+50);
      fill(255, 0, 0);
      text(str(expN)+"の位置に線を引いて下さい", hw, 100);
      line(gap, hh, hw*2-gap, hh);
      noStroke();
      fill(200);
      rect(hw, sh-infoH/2, sw, infoH);
      if (delFlg) {

        fill(0);
        rect(bX[0], sh-infoH/2, fS*numL[0]+20, fS+20);
        rect(bX[2], sh-infoH/2, fS*numL[2]+20, fS+20);
        fill(255);
        text("ぜんぶ消す", bX[0], sh-infoH/2);
        text("記録して次に進む", bX[2], sh-infoH/2);
      } else {
        fill(0);
      }
      if (tlFlg && millis()-timer>tlmt) {
        clrFlg=true;
        output.println(str(trl+1)+','+str(maxN)+','+str(expN)+','+str(resp)+','+str(bgnX[trl])+','+str(endX[trl])+','+str(lineX[trl]));
        if (trl==numT-1) {
          output.flush();
          output.close();
          timer=millis();
          endFlg=true;
        }
        trl++;
        timer=millis();
        disp=0;
        FB=0;
      }
    }
  }
}

void mouseDragged() {
  if (disp==1) {
    delFlg=true;
    stroke(255, 0, 0);
    line(pmouseX, pmouseY, mouseX, mouseY);
    //println(mouseX);
    if ((mouseY-hh)*(pmouseY-hh)<0 || mouseY==hh) {
      lineX[trl]=mouseX;
      //println(mouseX);
    }
  }
}
int[] randPerm(int tN) {
  int[] ro = new int[tN];
  float[] rn = new float[tN];
  for (int i=0; i<tN; i++) {
    ro[i]=i;
    rn[i]= random(1);
  }
  for (int i=0; i<tN-1; i++) {
    for (int j=tN-1; j>i; j--) {
      if (rn[j]<rn[j-1]) {
        float temp=rn[j];
        int temp2=ro[j];
        rn[j]=rn[j-1];
        ro[j]=ro[j-1];
        rn[j-1]=temp;
        ro[j-1]=temp2;
      }
    }
  }
  return ro;
}

void mouseReleased() {
  if (disp==1) {
    if (pmouseY<sh-infoH) {
      lineFlg=true;
      endX[trl]=pmouseX;
      if (lineX[trl]!=0) {
        ratioX[trl]=(float)(lineX[trl]-gap)/(sw-gap*2)*maxN;
      } else
        ratioX[trl]=(float)((bgnX[trl]+endX[trl])/2-gap)/(sw-gap*2)*maxN;
      resp=round(ratioX[trl]);
    } else
      lineFlg=false;
  }
}


void mouseMoved() {
  if ((mouseX>(bX[0]-numL[0]*fS/2) && mouseX<(bX[0]+fS*numL[0]/2)) && (mouseY>sh-infoH/2-fS/2 && mouseY<sh-infoH/2+fS/2))
    boxF[0]=1;
  else
    boxF[0]=0;
  if ((mouseX>(bX[2]-numL[2]*fS/2) && mouseX<(bX[2]+fS*numL[2]/2)) && (mouseY>sh-infoH/2-fS/2 && mouseY<sh-infoH/2+fS/2))
    boxF[2]=1;
  else
    boxF[2]=0;
}

void mousePressed() {
  if (startFlg) {
    if (mouseX>(hw-210) && mouseX < hw+450) {
      if (mouseY>hh-120 && mouseY<hh-20) {
        startFlg=false;
        timer=millis();
        background(255);
      } else if (mouseY<hh+80)
        fbFlg=!fbFlg;
      else if (mouseY<hh+180)
        tlFlg=!tlFlg;
    }
  } else {

    if ((mouseX>(bX[0]-numL[0]*fS/2) && mouseX<(bX[0]+fS*numL[0]/2)) && (mouseY>sh-infoH/2-fS/2 && mouseY<sh-infoH/2+fS/2)) {
      delFlg=false;
      clrFlg=true;
    }
    if ((mouseX>(bX[2]-numL[2]*fS/2) && mouseX<(bX[2]+fS*numL[2]/2)) && (mouseY>sh-infoH/2-fS/2 && mouseY<sh-infoH/2+fS/2)) {
      clrFlg=true;
      output.println(str(trl+1)+','+str(maxN)+','+str(expN)+','+str(resp)+','+str(bgnX[trl])+','+str(endX[trl])+','+str(lineX[trl]));
      save(fld+"trl"+str(trl+1)+"disp.png");
      //if ((ratioX[trl]-expN)/maxN*1000 100-exLevel && ratioX[trl]/expN*100<100+exLevel)
     
      if (abs(ratioX[trl]-expN)<exLevel*maxN/100)
        FB=1;
      else if (abs(ratioX[trl]-expN)<goodLevel*maxN/100)
        FB=2;
      else
        FB=3;
       println(str(FB)+';'+abs(ratioX[trl]-expN));
      if (trl==numT-1) {
        output.flush();
        output.close();
        timer=millis();
        endFlg=true;
      } else {
        //println(ratioX[trl]/expN*100);
        trl++;
        timer=millis();
        disp=0;
      }
    }
    if (disp==1 && mouseY<sh-infoH)
      bgnX[trl]=mouseX;
  }
}


