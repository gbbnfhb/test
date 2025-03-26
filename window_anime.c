
#define RAYGUI_IMPLEMENTATION
#include "raylib.h"
#include "raygui.h"
#include "styles/dark/style_dark.h"              // raygui style: dark

int main(void)
{
    // ウィンドウの初期化
    const int screenWidth = 800;
    const int screenHeight = 450;
    InitWindow(screenWidth,screenHeight,"raygui - Window Animation");
    SetTargetFPS(60);


    // フォントのロード
    Font font = LoadFontEx("mplus-1p-regular.ttf",32,0,250); // フォントファイルへのパスを指定

    // スタイルセットのロード
    //GuiLoadStyleDefault(); // デフォルトのスタイルセットをロード
    GuiLoadStyleDark();

    // フォントの設定
    GuiSetFont(font); // GuiSetFont() を使用してフォントを設定

    // スクロールバーを非表示にする
    GuiSetStyle(LISTVIEW,SCROLLBAR_WIDTH,0);
    GuiSetStyle(LISTVIEW,SCROLLBAR_SIDE,0);

    // ウィンドウの初期状態
    Rectangle windowBounds = { screenWidth / 2 - 100, screenHeight / 2, 200, 0 }; // 初期サイズは縦方向のみ 0
    bool windowActive = false;
    bool windowOpening = false;
    bool windowClosing = false;
    float animationSpeed = 800.0f; // アニメーションの速度を調整
    float targetHeight = 150.0f;
    bool windowDragging = false;
    Vector2 mouseOffset = { 0, 0 };

    // リストボックスの初期化
    const char* listItems = "NEWGAME;CONTINUE;EXIT";
    int listScrollIndex = 0;
    int listActive = -1;

    // メインループ
    while(!WindowShouldClose())
    {
        // ウィンドウの開閉処理
        if(GuiButton((Rectangle){ 10,10,100,30 },"Toggle Window"))
        {
            if(!windowActive)
            {
                windowActive = true;
                windowOpening = true;
                windowClosing = false;
            }
            else
            {
                windowClosing = true;
                windowOpening = false;
            }
        }

        // ウィンドウを開くアニメーション
        if(windowOpening)
        {
            if(windowBounds.height < targetHeight)
            {
                windowBounds.y -= animationSpeed * GetFrameTime() / 2;
                windowBounds.height += animationSpeed * GetFrameTime();
                if(windowBounds.height > targetHeight)
                {
                    windowBounds.height = targetHeight;
                    windowBounds.y = screenHeight / 2 - targetHeight / 2;
                }
            }
            if(windowBounds.height >= targetHeight)
            {
                windowOpening = false;
            }
        }

        // ウィンドウを閉じるアニメーション
        if(windowClosing)
        {
            if(windowBounds.height > 0)
            {
                windowBounds.y += animationSpeed * GetFrameTime() / 2;
                windowBounds.height -= animationSpeed * GetFrameTime();
                if(windowBounds.height < 0)
                {
                    windowBounds.height = 0;
                    windowBounds.y = screenHeight / 2;
                }
            }
            if(windowBounds.height <= 0)
            {
                windowActive = false;
                windowClosing = false;
                listActive = -1;
            }
        }

        // ウィンドウの移動処理
        if(windowActive)
        {
            // タイトルバーの領域を定義
            Rectangle titleBar = { windowBounds.x, windowBounds.y, windowBounds.width, 20 };

            if(CheckCollisionPointRec(GetMousePosition(),titleBar))
            {
                if(IsMouseButtonPressed(MOUSE_BUTTON_LEFT))
                {
                    windowDragging = true;
                    mouseOffset.x = GetMouseX() - windowBounds.x;
                    mouseOffset.y = GetMouseY() - windowBounds.y;
                }
            }

            if(IsMouseButtonReleased(MOUSE_BUTTON_LEFT))
            {
                windowDragging = false;
            }

            if(windowDragging)
            {
                windowBounds.x = GetMouseX() - mouseOffset.x;
                windowBounds.y = GetMouseY() - mouseOffset.y;
            }
        }

        // 描画
        BeginDrawing();
        ClearBackground(RAYWHITE);

        // ウィンドウがアクティブな場合のみ描画
        if(windowActive)
        {
            //GuiWindowBox(windowBounds,"Animated Window");
            Rectangle listViewBounds = { windowBounds.x + 10, windowBounds.y + 30, windowBounds.width - 20, windowBounds.height - 40 };
            int result = GuiListView(listViewBounds,listItems,&listScrollIndex,&listActive);
            if(result != -1)
            {
                if(listActive == 0)
                {
                    TraceLog(LOG_INFO,"newgame");
                }
                else if(listActive == 1)
                {
                    TraceLog(LOG_INFO,"continue");
                }
                else if(listActive == 2)
                {
                    TraceLog(LOG_INFO,"exit");
                }
            }
        }

        EndDrawing();
    }

    // ウィンドウを閉じる
    CloseWindow();
    // フォントをアンロード
    UnloadFont(font);
    return 0;
}