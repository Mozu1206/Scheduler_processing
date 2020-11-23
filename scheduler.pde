int page = 1;//最初に表示するページを指定
int s2 = 0;
int _switch = 1;
boolean botan = false;
int Scount; //タイマーの設定時間
int s_reset = 0;
int timer; //
int count = -2;
int t;//タイマーに使う変数
String b_name[] = {
  "HOME", "SCHE", "TIMER"
};//ボタンの名前
String a [] = {
  "SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"
};//曜日
String c [] = { 
  "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
};//月
String data[]; //配列をつくる
int unit_n[][] = new int[7][]; // number of time unit
int unit_k[][] = new int[7][]; // kind of time unit
String A[] = {
  "Sleep", "Class", "Club", "Leisure", "Homework", "Other"
};//項目
PImage img1;//画像のクラスを作成
PImage img2;
PImage img3;
PImage img4;
import ddf.minim.*; //minimライブラリのインポート
Minim minim; //Minim型変数であるminimの宣言
AudioPlayer player; //サウンドデータ格納用の変数

int getDayOfWeek(String s) {//曜日を選ぶ関数
  for (int i = 0; i < 7; i++) {
    if (s.equals(a[i])) {
      return i;
    }
  }

  return -1;
}

void setup() {
  String d[];//配列をつくる
  String n[] = {
    "", "", "", "", "", "", ""
  }; //配列をつくり「,」で区切る
  String k[] = {
    "", "", "", "", "", "", ""
  };//配列をつくり「,」で区切る
  int dow, sum, i, j; //変数を定義

  size(480, 640);
  //  background(200);
  data = loadStrings("week_life.txt");//データ読み取り
  for (i = 0; i < data.length; i++) {
    // sprit one line to 3 strings
    // ex) "SUN,1,28" -> "SUN","1","28"
    d = data[i].split(",");//配列をつくり「,」で区切る
    dow = getDayOfWeek(d[0]); // dow is for day-of-week
    k[dow] += (d[1]+","); // concatenate only kind part
    n[dow] += (d[2]+","); // concatenate only time part
  }

  for (i = 0; i < 7; i++) {
    unit_k[i] = int(k[i].split(","));//配列をつくり「,」で区切る
    unit_n[i] = int(n[i].split(","));//配列をつくり「,」で区切る
  }

  for (i = 0; i < 7; i++) {
    // check the sum of time-unit for each day-of-week 
    sum = 0;
    for (j = 0; j < unit_k[i].length; j++) { 
      sum += unit_n[i][j];
    }

    if (sum != 96) {
      println("Data Error: The sum of quarter-hour-unit for "+a[i]+ " is "+ sum +".");
    }
  }
  strokeWeight(3);

  img1 = loadImage("ra-men.jpg");//画像を読み込む
  img2 = loadImage("kitune.jpg");
  img3 = loadImage("tv.jpg");
  img4 = loadImage("hirune.jpg");

  minim = new Minim(this);//初期化
  player = minim.loadFile("alarm.mp3");//音声を読み込む
}

void divideA(int d) {//線を引く関数
  stroke(0);
  line(5, d, width-6, d);
}

void divideB(int e) {//線を引く関数
  stroke(0);
  line(e, 140, e, height);
}

void liner(int l) { //グラフを区切る線を引くための関数
  strokeWeight(1);//線の太さを変更
  stroke(0);//線色を黒色に変更
  line(50+48*l, 130, 50+48*l, height-100); //線の引く位置を決定
  stroke(0); //線色を黒色に変更
}



void timer(int c, int v) { //時間を表示するための関数
  fill(0); //線色を黒色に変更
  text(c, 50+48*v-8, height-80); //文字を表示する場所の決定
}


void setColor(int idx) { //グラフの色を変える関数
  switch(idx) {
  case 1: //パターン１
    fill(255, 0, 0); // 赤
    break;
  case 2: //パターン2
    fill(0, 255, 0); //緑
    break;
  case 3: //パターン3
    fill(0, 0, 255); //青
    break;
  case 4: //パターン4
    fill(255, 255, 0); //黄
    break;
  case 5: //パターン5
    fill(0, 255, 255); //シアン
    break;
  case 6: //パターン6
    fill(255, 0, 255); //マゼンダ
    break;
  default: //どのパターンでもないとき
    fill(128, 128, 128); //グレー
  }
}


void showGraph(float x, float y, int k[], int n[]) {//グラフを表示させる関数
  int i;//変数を定義
  float w, tx, ty;//変数を定義

  for (i = 0; i < n.length; i++) {
    tx = x; // copy the value of x
    ty = y; // copy the value of y

      setColor(k[i]);   
    // the length of one time-unit on the window is 5
    w = n[i] * 4; 
    // draw the box
    //    rect(tx, ty, w, h);
    rect(tx, ty, w, 20);
    // move the current position to the right end of the box
    x += w;
  }
}


void TIME() {//時間の表示
  textSize(40);

  if (minute()>9) {//場合分け
    if (second()>9) {
      text(hour()+":"+minute()+":"+second(), 30, 90);
    }
  }

  if (minute()>9) {
    if (second()<10) {
      text(hour()+":"+minute()+":0"+second(), 30, 90);
    }
  }

  if (minute()<10) {
    if (second()<10) {
      text(hour()+":0"+minute()+":0"+second(), 30, 90);
    }
  }

  if (minute()<10) {
    if (second()>9) {
      text(hour()+":0"+minute()+":"+second(), 30, 90);
    }
  }
}



// 一ヶ月の日数
final int daysOfMonth[]= {
  31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
};

// ツェラーの公式による曜日の算出
// 日曜=0 ... 土曜=6
int zeller(int y, int m, int d) {
  int h;
  if (m<3) {
    m+=12;
    y--;
  }
  h=(d+(m+1)*26/10+(y%100)+(y%100)/4+y/400-2*y/100)%7;
  h-=1;
  if (h<0) h+=7;
  return h;
}

// うるう年の判別
boolean isLeapYear(int y) {
  if (y%400==0) {
    return true;
  } else if (y%100==0) {
    return false;
  } else if (y%4==0) {
    return true;
  }
  return false;
}

// うるう年を考慮して「今月」の日数を求める
int getDaysOfMonth( int y, int m) {
  int days=daysOfMonth[m-1];
  if (m==2 && isLeapYear(y)) {
    days++;
  }
  return days;
}

// 「今月」のカレンダーを描画する
void drawCalender(int y, int m, int d) {
  int week=zeller(y, m, 1); // 「今月」1日の曜日を求める
  int days=getDaysOfMonth(y, m); // 「今月」の日数を求める
  String k = String.valueOf(m);//文字列を数値として扱う

  if (m==1) {//1月
    k = c[0];
  } else if (m==2) {//2月
    k = c[1];
  } else if (m==3) {//3月
    k = c[2];
  } else if (m==4) {//4月
    k = c[3];
  } else if (m==5) {//5月
    k = c[4];
  } else if (m==6) {//6月
    k = c[5];
  } else if (m==7) {//7月
    k = c[6];
  } else if (m==8) {//8月
    k = c[7];
  } else if (m==9) {//9月
    k = c[8];
  } else if (m==10) {//10月
    k = c[9];
  } else if (m==11) {//11月
    k = c[10];
  } else if (m==12) {//12月
    k = c[11];
  }



  fill(255, 140, 0); // 年/月をオレンジで表示;
  text(k+","+y, 20, 45);
  for (int i=1; i<=days; i++) {
    if (i==d) {// 「今日」なら黄色
      fill(255, 255, 0);
    } else {// 「今日」でないなら黒字
      fill(0, 0, 0);
      if ((i+week-1)%7==0) { // 日曜は赤字
        fill(255, 0, 0);
      } else {
        if ((i+week-1)%7==6) { //土曜日は青
          fill(0, 0, 255);
        }
      }
    }
    String f =(" "+i);
    f=f.substring(f.length()-2);//文字列を右寄せにする
    text(f, (i+week-1)%7*((width-10)/7)+15, ((i+week-1)/7+2)*((height-5)/6-5));
  }
}



void mouseClicked() {
  if (mouseY > 10 && mouseY < 30) {    
    if (350 < mouseX && mouseX < 386) { // the left most button 
      page = 1; // current page will be changed to 1
    } else if (390 < mouseX && mouseX < 426) {
      page = 2;
    } else if (430 < mouseX && mouseX < 466) {
      page = 3;
    }
  }
}

/* show page 1 */
void disp1() {
  strokeWeight(3);//線の太さを変更
  drawCalender(year(), month(), day());//カレンダ－を表示
  for (int o=0; o<7; o++) {
    noStroke();//線をなくする
    fill(127, 255, 0);
    rect(o*68+10, 110, 55, 25);//曜日の背景をつける
  }
  for (int i = 0; i < a.length; i++) {
    fill(0);//黒色に変更
    textSize(20);//文字サイズ変更
    text(a[i], 16+i*68, 130);//曜日を表示
  }
  for (int r=0; r<6; r++) {
    divideA(138+r*100);//線を引く関数を実行
  }
  for (int w=0; w<8; w++) {
    divideB(5+w*67);//線を引く関数を実行
  }
}

/* show page 2 */
void disp2() {
  textSize(20);//文字サイズを変更
  float x, y, x_A, y_A;//変数を定義

  for (int k = 0; k<9; k++) {
    liner(k); //線を引く関数を実行
    timer(3*k, k); //時間を表示する関数を実行
  }    

  for (int i = 0; i < 7; i++) {
    // show text data line by line
    setColor(0);//色を変える関数を実行
    x = 50;//x座標を指定
    y = i * 60+130;//y座標を指定
    fill(0);//黒色に変更
    text(a[i], x, y); //曜日を表示   
    showGraph(x, y, unit_k[i], unit_n[i]);
  } 

  for (int k = 0; k < 4; k++) {

    x_A = k * 100+50;//x座標指定
    y_A = 590;//y座標指定
    fill(0);//黒色に変更
    text(A[k], x_A, y_A);//項目を表示
    setColor(k+1);    //色を変更
    text("■", x_A-15, y_A);//グラフの色をした■を表示
  }

  for (int k = 4; k < 6; k++) {

    x_A = k * 150-460;//x座標指定
    y_A = 610;//y座標指定
    fill(0);//黒色に変更
    text(A[k], x_A, y_A);//項目を表示
    setColor(k+1);    //色を変更
    text("■", x_A-15, y_A);//グラフの色をした■を表示
  }
}

/* show page 3 */
void set_timer(int dx, int w, int dy, int h, int li) { //タイマーを設定する関数

  if (mouseButton == LEFT) { //左クリック
    if ((dx < mouseX && mouseX < dx + w) && (dy < mouseY && mouseY < dy + h)) {
      //マウスが指定した範囲内にある時
      if (mousePressed && _switch > 0) {
        botan = true;
        Scount = li;
      }
    }
  }
}
void timer() { //タイマーを表示する関数
  textSize(50);
  fill(255, 0, 0);
  text("TIMER", 270, 90);
  int m = millis(); //時間の代入

  set_timer(80, 100, 200, 120, 180); //タイマーの関数を呼び出す
  image(img1, 80, 200, 100, 120);

  set_timer(280, 100, 210, 100, 300); //タイマーの関数を呼び出す
  image(img2, 280, 210, 100, 100);

  set_timer(40, 200, 430, 125, 1800); //タイマーの関数を呼び出す
  image(img3, 40, 430, 200, 125);

  set_timer(280, 150, 430, 150, 5400); //タイマーの関数を呼び出す
  image(img4, 280, 430, 150, 150);

  while (botan) {
    timer = millis(); //時間を代入
    botan = false;
    _switch = -1;
  }
  if (_switch<0) {
    int a; //変数
    int b; //時間
    int c; //分
    int d; //秒
    count = Scount -(m - timer) / 1000;
    a = count % 3600;
    b = (count - a) / 3600;
    c = (count - b * 3600) % 60;
    d = (count - b * 3600 - c) / 60;
    fill(150, 0, 150);
    text(nf (b, 2) + ":" + nf(d, 2) + ":" + nf(c, 2), 107, 400);
    //時間：分：秒で表示
  }
  if (count == 0) { //countが0の時
    _switch = 1; //代入
    fill(255, 0, 0); //色指定
    text("TIME UP!", 115, 400); //TIME UP!と表示
  }
  if (mousePressed) { // マウスを押す
    if (mouseButton == LEFT) { //左クリック
      if ((350 < mouseX && mouseX < 450) && (240 < mouseY && mouseY < 300)) {
        s_reset = millis();
        count = -2; //代入
      }
    }
  }
  if (count ==0) {//タイマーが0になったら音楽を再生
    player.play();
  }

  if (mousePressed) {
    if (count == 0 &&mouseButton == RIGHT) {//タイマーが0になっているときに右クリックで音楽を停止
      player.close();
    }
  }
}


void disp3() {
  background(255);
  timer();//タイマーの関数を実行
  
}


void draw() {
  background(200);
  /* show page */
  switch(page) {
  case 1:
    disp1();
    break;
  case 2:
    disp2();
    break;
  case 3:
    disp3();
    break;
  default:
    break;
  }
    /* show buttons */
  strokeWeight(1);
  for (int i = 0; i < 3; i++) {
    textSize(10);
    fill(0, 0, 255);
    rect(350+i*40, 10, 36, 20);//ページ切り替えボタンの背景
    fill(255);
    text(b_name[i], 355+i*40, 25);//ページの名前を書く
  }
  fill(0);
  textSize(40); 
  TIME();
  
}

void stop() {
  player.close();
  minim.stop();
  super.stop();
}
