/*
    Word Wolf ver 1.0
    Editor:     Lalaso
    Comment:    It's a remaked version.
                とりあえず作ってみた。
                少数派の人の決定アルゴリズムを見直し、よりランダム性が上がったはず
    Notice:     If you can't read some comments, the reason is "Editor and Console font".
                So, If you want to read comment, change "Editor and Console font" from preference. 
*/

final int MEMBER                = 5;        // 参加人数
final int MINOR                 = 1;        // 少数派の人数
final boolean PERFECT_RANDOM    = true;     // trueで完全ランダム、falseは隣接するお題で出題
final String FILE_NAME          = "01.txt"; // お題のテキストファイル名

String lines[];
int majorIndex, minorIndex;
int lineLength;
int tmp;
boolean minorFlags[] = new boolean[MEMBER];

PFont font;

int playerCount = 1;
int seen = 0;
String minorMemberStr = "";

void setup() {
    // 初期化項目チェック
    if(MEMBER <= MINOR){
        println("'MINOR' is too many.");
        exit();
        return;
    }

    // テキストファイル読み込み
    lines = loadStrings(FILE_NAME);
    lineLength = lines.length;
    // 多数派・少数派の決定
    if (PERFECT_RANDOM) {
        majorIndex = int(random(0, lineLength));
        minorIndex = int(random(0, lineLength));
        if(majorIndex == minorIndex){
            if(majorIndex != 0){
                minorIndex = majorIndex - 1;
            }
            else{
                minorIndex = majorIndex + 1;
            }
        }
    }
    else{
        majorIndex = int(random(0, lineLength));
        tmp = int(random(0,2));
        if(tmp == 0){
            minorIndex = majorIndex - 1;
        }
        else{
            minorIndex = majorIndex + 1;
        }
        if(minorIndex < 0){
            minorIndex = majorIndex + 1;
        }
        else if(minorIndex >= lineLength){
            minorIndex = majorIndex - 1;
        }
    }
    // println("多数派: "+lines[majorIndex]);
    // println("少数派: "+lines[minorIndex]);

    // 少数派の人を決定
    for(int i = 0; i < MEMBER; i++){
        minorFlags[i] = false;
    }
    for(int i = 0; i < MINOR; i++){
        tmp = int(random(0, MEMBER));
        setFlag(tmp);
    }
    for(int i = 0; i < MEMBER; i++){
        int j = i;
        if(minorFlags[i]){
            minorMemberStr += " " + (j + 1) + " ";
        }
    }
    // println("少数派の人：" + minorMemberStr);

    // ウィンドウ初期化
    size(800, 600);

    // フォント初期化
    font = createFont("Ume-Hy-Gothic-O5-48", 48);
}

void draw() {
    // 背景や文字色等の設定
    background(0,0,0);
    textAlign(CENTER, CENTER);
    fill(255, 255, 255);
    textFont(font);

    // Enterの押した回数 = seenによって画面を遷移させる
    if (seen == MEMBER*2 + 5){
        text("多数派："+lines[majorIndex], 400, 200);
        text("少数派："+lines[minorIndex], 400, 300);
        text("エンターキーで次へ", 400, 400);
    }
    else if(seen > MEMBER*2 + 5){
        text("少数派", 400, 200);
        text(minorMemberStr, 400, 300);
        text("Escキーで終了", 400, 400);
    }
    else if(seen >= MEMBER * 2){
        text("トーク開始！", 400, 250);
        text("(エンター×5でトーク終了)", 400, 350);
    }
    else if(seen % 2 == 0){
        text("プレイヤー" + playerCount + "は", 400, 250);
        text("エンターキーを押してください", 400, 350);
    }
    else {
        if(minorFlags[playerCount - 1] == true){
            text("プレイヤー" + playerCount + ": " + lines[minorIndex], 400, 300);
        }
        else{
            text("プレイヤー" + playerCount + ": " + lines[majorIndex], 400, 300);
        }
    }

}

// 少数派フラグを立てる
void setFlag(int num){
    if(num >= MEMBER) setFlag(0);
    else if(minorFlags[num] == true) setFlag(num + 1);
    else minorFlags[num] = true;
}

// キーボード関連
void keyReleased() {
    // エンターキーでシーン遷移
    if(key == ENTER){
        seen += 1;
        // ２回に１回プレイヤーが変わる
        if(seen % 2 == 0){
            playerCount += 1;
        }
    }
}