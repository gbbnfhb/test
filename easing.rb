print 'start'
require './color'

module Raylib


def self.Start
# ウィンドウの初期化
screenWidth = 800
screenHeight = 450
InitWindow(screenWidth, screenHeight, "Easing Functions Graph - Ball Movement")
SetTargetFPS(60)

# グラフのパラメータ
graphWidth = 600
graphHeight = 300
graphX = 100
graphY = 100
graphScaleY = graphHeight.to_f

# イージング関数のリスト
easingFunctions = [
  Raylib::Easing.method(:linear_none),
  Raylib::Easing.method(:sine_in),
  Raylib::Easing.method(:sine_out),
  Raylib::Easing.method(:sine_in_out),
  Raylib::Easing.method(:cubic_in),
  Raylib::Easing.method(:cubic_out),
  Raylib::Easing.method(:cubic_in_out),
  Raylib::Easing.method(:quad_in),
  Raylib::Easing.method(:quad_out),
  Raylib::Easing.method(:quad_in_out),
  Raylib::Easing.method(:expo_in),
  Raylib::Easing.method(:expo_out),
  Raylib::Easing.method(:expo_in_out),
  Raylib::Easing.method(:back_in),
  Raylib::Easing.method(:back_out),
  Raylib::Easing.method(:back_in_out),
  Raylib::Easing.method(:bounce_in),
  Raylib::Easing.method(:bounce_out),
  Raylib::Easing.method(:bounce_in_out),
  Raylib::Easing.method(:elastic_in),
  Raylib::Easing.method(:elastic_out),
  Raylib::Easing.method(:elastic_in_out)
]

# イージング関数の名前のリスト
easingNames = [
  "linear_none",
  "sine_in",
  "sine_out",
  "sine_in_out",
  "cubic_in",
  "cubic_out",
  "cubic_in_out",
  "quad_in",
  "quad_out",
  "quad_in_out",
  "expo_in",
  "expo_out",
  "expo_in_out",
  "back_in",
  "back_out",
  "back_in_out",
  "bounce_in",
  "bounce_out",
  "bounce_in_out",
  "elastic_in",
  "elastic_out",
  "elastic_in_out"
]

# イージング関数の色のリスト
easingColors = [
  RED, ORANGE, YELLOW, GREEN, BLUE, PURPLE, PINK,
  MAROON, GOLD, LIME, DARKGREEN, SKYBLUE, VIOLET,
  DARKPURPLE, BEIGE, BROWN, MAGENTA, DARKBLUE,
  DARKGRAY, LIGHTGRAY, GRAY, BLACK
]

# 現在表示しているイージング関数のインデックス
currentEasingIndex = 0

# 玉のパラメータ
ballRadius = 5
ballColor = BLACK
t = 0.0 # 時間 (0.0 to 1.0)
t_step = 0.01 # 時間の増分

# メインループ
while !WindowShouldClose()
  # タップイベントの処理
  if IsMouseButtonPressed(MOUSE_BUTTON_LEFT)
    currentEasingIndex = (currentEasingIndex + 1) % easingFunctions.length
    t = 0.0 # 新しいイージング関数に切り替わったら、時間をリセット
  end

  # 時間を更新
  t += t_step
  if t > 1.0
    t = 0.0
  end

  # 描画開始
  BeginDrawing()
    ClearBackground(RAYWHITE)

    # グラフの枠を描画
    r = Rectangle.new(graphX, graphY, graphWidth, graphHeight)
    DrawRectangleLines(r, BLACK)

    # 現在のイージング関数のグラフを描画
    easingFunction = easingFunctions[currentEasingIndex]
    color = easingColors[currentEasingIndex % easingColors.length]

    previousX = graphX
    previousY = graphY + graphHeight
    (0..graphWidth).each do |x|
      tx = x.to_f / graphWidth.to_f
      b = 0.0
      c = 1.0
      d = 1.0
      y = easingFunction.call(tx, b, c, d)
      currentX = graphX + x
      currentY = graphY + graphHeight - (y * graphScaleY)
      DrawLine(previousX, previousY, currentX, currentY, color)
      previousX = currentX
      previousY = currentY
    end

    # 玉の座標を計算
    b = 0.0
    c = 1.0
    d = 1.0
    ballY = easingFunction.call(t, b, c, d)
    ballX = graphX + (t * graphWidth)
    ballY = graphY + graphHeight - (ballY * graphScaleY)

    # 玉を描画
    v= Vector2.new(ballX, ballY)
    DrawCircle(v, ballRadius, ballColor)

    # イージング関数の名前を描画
    easingNames.each_with_index do |name, index|
      textColor = (index == currentEasingIndex) ? color : GRAY
      DrawText(name, graphX + graphWidth + 20, graphY + (index * 20)-80, 10, textColor)
    end

    # 軸のラベルを描画
    DrawText("Time (t)", graphX + graphWidth - 50, graphY + graphHeight + 20, 10, BLACK)
    DrawText("Value", graphX - 50, graphY + 10, 10, BLACK)

    DrawText("Tap to change easing function", 10, screenHeight - 30, 20, DARKGRAY)

  EndDrawing()
end

# ウィンドウを閉じる
CloseWindow()
end
end

Raylib.Start

print 'end'
