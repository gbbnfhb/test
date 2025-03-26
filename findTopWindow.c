// ウィンドウの構造体
struct Window {
    int id;
    Rectangle bounds;
    // ... その他のウィンドウのプロパティ ...
};

// ウィンドウのリスト
List<Window> windows;

// アクティブウィンドウのID
int activeWindowId = -1;

// マウスがクリックされたときの処理
onMouseClick(Vector2 mousePosition) {
    // 最前面のウィンドウを検索
    Window topWindow = findTopWindow(windows, mousePosition);

    // アクティブウィンドウを設定
    activeWindowId = topWindow.id;
}

// マウスボタンが離された時の処理
onMouseRelease(){
    activeWindowId = -1;
}

// ウィンドウのドラッグ処理
onWindowDrag(Window window) {
    // アクティブウィンドウかどうかを確認
    if (window.id == activeWindowId) {
        // ドラッグ処理を実行
        window.bounds.x += mouseDeltaX;
        window.bounds.y += mouseDeltaY;
    }
}

// 最前面のウィンドウを検索する関数
Window findTopWindow(List<Window> windows, Vector2 mousePosition) {
    // リストを逆順に走査（最前面から検索）
    for (Window window : windows.reverse()) {
        // マウス位置がウィンドウの範囲内にあるか確認
        if (CheckCollisionPointRec(mousePosition, window.bounds)) {
            return window; // 最前面のウィンドウを返す
        }
    }
    // 見つからなかった場合は、nullを返すか、エラー処理を行う
    return null;
}