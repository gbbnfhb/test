#include "raylib.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// 文字列スプライトの構造体
typedef struct {
    Texture2D texture;
    Vector2 position;
    float rotation;
    float scale;
    Color color;
    const char* text; // 表示する文字列
} TextSprite;

int main() {
    // ウィンドウの初期化
    const int screenWidth = 800;
    const int screenHeight = 450;
    InitWindow(screenWidth,screenHeight,"raylib - TTF String as Sprite (C)");

    // TTF フォントの読み込み
    Font font = LoadFont("PixelMplus12-Bold.ttf");

    // 文字列スプライトの配列（最大10個）
    TextSprite textSprites[10];
    int textSpriteCount = 0;

    // 文字列スプライトの作成
    const char* texts[] = {
        "Hello, raylib!",
        "This is a test.",
        "Another string.",
        "And one more!"
    };
    int numTexts = sizeof(texts) / sizeof(texts[0]);
    Vector2 startPosition = { 100, 100 };
    float fontSize = 32.0f;
    float lineSpacing = 40.0f;

    for(int i = 0; i < numTexts; i++) {
        // 文字列のサイズを計算
        Vector2 textSize = MeasureTextEx(font,texts[i],fontSize,0);

        // 文字列を描画するための Image を作成
        Image image = GenImageColor((int)textSize.x,(int)textSize.y,BLANK);

        // Image に文字列を描画
        ImageDrawTextEx(&image,font,texts[i],(Vector2){ 0,0 },fontSize,0,RED);

        // Image を Texture2D に変換
        Texture2D texture = LoadTextureFromImage(image);
        UnloadImage(image); // Image は不要になったので解放

        // 文字列スプライトを作成
        TextSprite textSprite;
        textSprite.texture = texture;
        textSprite.position = (Vector2){ startPosition.x, startPosition.y + i * lineSpacing };
        textSprite.rotation = 0.0f;
        textSprite.scale = 1.0f;
        textSprite.color = WHITE;
        textSprite.text = texts[i];
        textSprites[textSpriteCount++] = textSprite;
    }

    SetTargetFPS(60);

    // メインループ
    while(!WindowShouldClose()) {
        // 文字列スプライトの更新（例：回転）
        for(int i = 0; i < textSpriteCount; i++) {
            textSprites[i].rotation += 1.0f;
        }

        // 描画
        BeginDrawing();
        ClearBackground(RAYWHITE);

        // 文字列スプライトの描画
        for(int i = 0; i < textSpriteCount; i++) {
            DrawTexturePro(
                textSprites[i].texture,
                (Rectangle){
                0,0,(float)textSprites[i].texture.width,(float)textSprites[i].texture.height
            },
                (Rectangle){
                textSprites[i].position.x,textSprites[i].position.y,textSprites[i].texture.width* textSprites[i].scale,textSprites[i].texture.height* textSprites[i].scale
            },
                (Vector2){
                0,0
            }, // 原点を左上に設定
                textSprites[i].rotation,
                textSprites[i].color
            );
        }

        EndDrawing();
    }

    // リソースの解放
    UnloadFont(font);
    for(int i = 0; i < textSpriteCount; i++) {
        UnloadTexture(textSprites[i].texture);
    }
    CloseWindow();

    return 0;
}