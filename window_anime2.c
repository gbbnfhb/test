#define RAYGUI_IMPLEMENTATION
#include "raylib.h"
#include "raygui.h"

// ウィンドウの種類を定義
typedef enum {
    WINDOW_TYPE_LISTVIEW,
    WINDOW_TYPE_TEXTBOX
} WindowType;

// ウィンドウのデータを保持する構造体
typedef struct {
    Rectangle bounds;
    const char* title;
    const char* listItems;
    int listScrollIndex;
    int listActive;
    bool windowActive;
    bool windowOpening;
    bool windowClosing;
    float animationSpeed;
    float targetHeight;
    bool windowDragging;
    Vector2 mouseOffset;
    WindowType windowType;
    char textBoxText[256]; // TextBox に表示するテキスト
    bool textBoxEditMode; // TextBox の編集モード
} WindowData;

// ウィンドウのデータを初期化するサブルーチン
void InitWindowData(WindowData* data,Rectangle bounds,const char* title,const char* content,WindowType windowType) {
    data->bounds = bounds;
    data->title = title;
    data->listItems = NULL;
    data->listScrollIndex = 0;
    data->listActive = -1;
    data->windowActive = false;
    data->windowOpening = false;
    data->windowClosing = false;
    data->animationSpeed = 800.0f;
    data->targetHeight = bounds.height;
    data->windowDragging = false;
    data->mouseOffset = (Vector2){ 0, 0 };
    data->windowType = windowType;
    if(windowType == WINDOW_TYPE_LISTVIEW) {
        data->listItems = content;
    }
    else if(windowType == WINDOW_TYPE_TEXTBOX) {
        strcpy(data->textBoxText,content);
        data->textBoxEditMode = false;
    }
}

//スタイルを変えてtextboxを　ただのメッセージボックスと同じにします
void TextboxStyleChg()
{
    // TextBoxのスタイルを変更
    // STATE_FOCUSED のスタイルを STATE_NORMAL と同じにする
    GuiSetStyle(TEXTBOX,BORDER_COLOR_FOCUSED,GuiGetStyle(TEXTBOX,BORDER_COLOR_NORMAL));
    GuiSetStyle(TEXTBOX,TEXT_COLOR_FOCUSED,GuiGetStyle(TEXTBOX,TEXT_COLOR_NORMAL));
    GuiSetStyle(TEXTBOX,BASE_COLOR_FOCUSED,GuiGetStyle(TEXTBOX,BASE_COLOR_NORMAL));

    // STATE_PRESSED のスタイルを STATE_NORMAL と同じにする
    GuiSetStyle(TEXTBOX,BORDER_COLOR_PRESSED,GuiGetStyle(TEXTBOX,BORDER_COLOR_NORMAL));
    GuiSetStyle(TEXTBOX,TEXT_COLOR_PRESSED,GuiGetStyle(TEXTBOX,TEXT_COLOR_NORMAL));
    GuiSetStyle(TEXTBOX,BASE_COLOR_PRESSED,GuiGetStyle(TEXTBOX,BASE_COLOR_NORMAL));
}

// ウィンドウの開閉アニメーション、移動処理を行うサブルーチン
void UpdateWindow(WindowData* data) {
    // ウィンドウを開くアニメーション
    if(data->windowOpening) {
        if(data->bounds.height < data->targetHeight) {
            data->bounds.y -= data->animationSpeed * GetFrameTime() / 2;
            data->bounds.height += data->animationSpeed * GetFrameTime();
            if(data->bounds.height > data->targetHeight) {
                data->bounds.height = data->targetHeight;
                data->bounds.y -= data->bounds.height - data->targetHeight;
            }
        }
        if(data->bounds.height >= data->targetHeight) {
            data->windowOpening = false;
        }
    }

    // ウィンドウを閉じるアニメーション
    if(data->windowClosing) {
        if(data->bounds.height > 0) {
            data->bounds.y += data->animationSpeed * GetFrameTime() / 2;
            data->bounds.height -= data->animationSpeed * GetFrameTime();
            if(data->bounds.height < 0) {
                data->bounds.height = 0;
                data->bounds.y += data->bounds.height;
            }
        }
        if(data->bounds.height <= 0) {
            data->windowActive = false;
            data->windowClosing = false;
            data->listActive = -1;
        }
    }

    // ウィンドウの移動処理
    if(data->windowActive) {
        // タイトルバーの領域を定義
        Rectangle titleBar = { data->bounds.x, data->bounds.y, data->bounds.width, 20 };

        if(CheckCollisionPointRec(GetMousePosition(),titleBar)) {
            if(IsMouseButtonPressed(MOUSE_BUTTON_LEFT)) {
                data->windowDragging = true;
                data->mouseOffset.x = GetMouseX() - data->bounds.x;
                data->mouseOffset.y = GetMouseY() - data->bounds.y;
            }
        }

        if(IsMouseButtonReleased(MOUSE_BUTTON_LEFT)) {
            data->windowDragging = false;
        }

        if(data->windowDragging) {
            data->bounds.x = GetMouseX() - data->mouseOffset.x;
            data->bounds.y = GetMouseY() - data->mouseOffset.y;
        }
    }
}



// ウィンドウを描画するサブルーチン
int DrawWindow(WindowData* data) {
    int result = -1;
    if(data->windowActive) {
        GuiWindowBox(data->bounds,data->title);
        if(data->windowType == WINDOW_TYPE_LISTVIEW) {
            Rectangle listViewBounds = { data->bounds.x + 10, data->bounds.y + 30, data->bounds.width - 20, data->bounds.height - 40 };
            result = GuiListView(listViewBounds,data->listItems,&data->listScrollIndex,&data->listActive);
        }
        else if(data->windowType == WINDOW_TYPE_TEXTBOX) {
            Rectangle textBoxBounds = { data->bounds.x + 10, data->bounds.y + 30, data->bounds.width - 20, data->bounds.height - 40 };
            GuiTextBox(textBoxBounds,data->textBoxText,256,data->textBoxEditMode);
/*
            if(CheckCollisionRecs(textBoxBounds,(Rectangle){ GetMouseX(),GetMouseY(),1,1 }))
            {
                if(IsMouseButtonPressed(MOUSE_BUTTON_LEFT))
                {
                    data->textBoxEditMode = !data->textBoxEditMode;
                }
            }
*/  
      }
    }
    return result;
}

int main(void)
{
    // ウィンドウの初期化
    const int screenWidth = 800;
    const int screenHeight = 450;
    InitWindow(screenWidth,screenHeight,"raygui - Window Animation");
    SetTargetFPS(60);

    // フォントのロード
    Font font = LoadFontEx("fonts/mplus-1p-regular.ttf",16,0,0); // すべてのグリフをロードするように変更

    // スタイルセットのロード
    GuiLoadStyleDefault(); // デフォルトのスタイルセットをロード
    TextboxStyleChg();

    // フォントの設定
    GuiSetFont(font); // GuiSetFont() を使用してフォントを設定

    // スクロールバーを非表示にする
    GuiSetStyle(LISTVIEW,SCROLLBAR_WIDTH,0);
    GuiSetStyle(LISTVIEW,SCROLLBAR_SIDE,0);

    // ウィンドウの初期化
    WindowData windowData;
    Rectangle windowBounds = { screenWidth / 2 - 100, screenHeight / 2, 200, 150 };
    const char* listItems = u8"ニューゲーム;コンティニュー;終了";
    InitWindowData(&windowData,windowBounds,"Animated Window",listItems,WINDOW_TYPE_LISTVIEW);

    WindowData windowData2;
    Rectangle windowBounds2 = { screenWidth / 2 - 100, screenHeight / 2, 200, 150 };
    const char* textBoxText = u8"これはテキストボックスです。\n複数行のテキストを表示できます。";
    InitWindowData(&windowData2,windowBounds2,"TextBox Window",textBoxText,WINDOW_TYPE_TEXTBOX);

// メインループ
while(!WindowShouldClose())
{
    // ウィンドウの開閉処理
    if(GuiButton((Rectangle){ 10,10,100,30 },"Toggle ListView"))
    {
        if(!windowData.windowActive)
        {
            windowData.windowActive = true;
            windowData.windowOpening = true;
            windowData.windowClosing = false;
        }
        else
        {
            windowData.windowClosing = true;
            windowData.windowOpening = false;
        }
    }
    if(GuiButton((Rectangle){ 10,50,100,30 },"Toggle TextBox"))
    {
        if(!windowData2.windowActive)
        {
            windowData2.windowActive = true;
            windowData2.windowOpening = true;
            windowData2.windowClosing = false;
        }
        else
        {
            windowData2.windowClosing = true;
            windowData2.windowOpening = false;
        }
    }

    // ウィンドウの更新
    UpdateWindow(&windowData);
    UpdateWindow(&windowData2);

    // 描画
    BeginDrawing();
    ClearBackground(RAYWHITE);

    // ウィンドウの描画
    int result = DrawWindow(&windowData);
    if(result != -1)
    {
        if(windowData.listActive == 0)
        {
            TraceLog(LOG_INFO,u8"ニューゲームが選択されました");
        }
        else if(windowData.listActive == 1)
        {
            TraceLog(LOG_INFO,u8"コンティニューが選択されました");
        }
        else if(windowData.listActive == 2)
        {
            TraceLog(LOG_INFO,u8"終了が選択されました");
        }
    }
    DrawWindow(&windowData2);

    EndDrawing();
}

// ウィンドウを閉じる
CloseWindow();
// フォントをアンロード
UnloadFont(font);
return 0;
}