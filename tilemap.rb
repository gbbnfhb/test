print 'start'
require './color'

module Raylib

# マップチップレイヤーのクラス
class MapChipLayer
  attr_accessor :tile_ids
  attr_reader :tile_map_shader
  attr_reader :tile_count

  # コンストラクタ
  def initialize(texture, width, height)
    @texture= texture
    @width= width
    @height= height
    @tile_ids= Array.new(width * height, 0) # 初期値は0で埋める
    @tile_map_shader= nil # Shaderオブジェクトを想定
    @texture_location= 0
    @texture_size_loc= 0
    @map_chip_size_loc= 0
    @tile_count_loc= 0
    @tile_size_loc= 0
    @texture_size= Vector2.new(0,0)
    @map_chip_size= Vector2.new(0,0)
    @tile_count= Vector2.new(0,0)
    @tile_size_vec= Vector2.new(0,0)
  end

  # タイルIDを取得
  def gid(x, y)
    return 0 if x < 0 || x >= @width || y < 0 || y >= @height
    @tile_ids[y * @width + x]
  end

  # タイルインデックスを取得
  def tile_index(x, y, anime_frame)
    id = gid(x, y)
    return 0 if id == 0
    # アニメーションの処理（例：フレーム数で切り替える）
    ((id - 1 + anime_frame) % (@texture.width / 32)) + 1 # 32はタイルサイズ
  end

  # タイルIDを設定
  def set_tile_id(x, y, id)
    @tile_ids[y * @width + x] = id if x >= 0 && x < @width && y >= 0 && y < @height
  end

  # テクスチャを返す
#  def get_texture
#    @texture
#  end
  def draw_texture_pro(source_rec, dest_rec)
        # 原点
        origin = Vector2.new(0,0)

        Raylib.DrawTexturePro(@texture, source_rec, dest_rec, origin, 0.0, Raylib::WHITE)
  end

  #DrawTextureRec(target.texture, Rectangle.new(0, 0, layer.texture_size.x, -layer.texture_size.y), Vector2.new(0, 0), WHITE)
  def  draw_texture_rec(target)
    r = Rectangle.new(0, 0, @texture_size.x, -@texture_size.y)
    v = Vector2.new(0, 0)

    Raylib.DrawTextureRec(target.texture, r, v, Raylib::WHITE)
  end

  # Shaderを設定
  def set_shader(shader)
    @tile_map_shader = shader
  end

  #locationを設定
  def set_location(texture_location,texture_size_loc,map_chip_size_loc,tile_count_loc,tile_size_loc)
    @texture_location = texture_location
    @texture_size_loc = texture_size_loc
    @map_chip_size_loc = map_chip_size_loc
    @tile_count_loc = tile_count_loc
    @tile_size_loc = tile_size_loc
  end

  #Vector2を設定
  def set_vector2(texture_size,map_chip_size,tile_count,tile_size_vec)
    @texture_size = texture_size
    @map_chip_size = map_chip_size
    @tile_count = tile_count
    @tile_size_vec = tile_size_vec
  end

  def set_shader_value
    Raylib.SetShaderValueTexture(@tile_map_shader, @texture_location, @texture)
    Raylib.SetShaderValue(@tile_map_shader, @texture_size_loc, @texture_size, Raylib::SHADER_UNIFORM_VEC2)
    Raylib.SetShaderValue(@tile_map_shader, @map_chip_size_loc, @map_chip_size, Raylib::SHADER_UNIFORM_VEC2)
    Raylib.SetShaderValue(@tile_map_shader, @tile_count_loc, @tile_count, Raylib::SHADER_UNIFORM_VEC2)
    Raylib.SetShaderValue(@tile_map_shader, @tile_size_loc, @tile_size_vec, Raylib::SHADER_UNIFORM_VEC2)
  end

end




def self.Start

# ウィンドウの初期化
screen_width = 800
screen_height = 450
InitWindow(screen_width, screen_height, "Tilemap with Raylib")

# マップチップのサイズ
tile_size = 32
# マップのサイズ
map_width = 20
map_height = 20

#timer
anime_frame = 0
timer = 0.0
anime_interval = 0.5

# レイヤーの作成
layers = []


# テクスチャのロード
tile_texture1 = LoadTexture("chip0.png")
tile_texture2 = LoadTexture("chip1.png")

# レイヤーの追加
layers.push(MapChipLayer.new(tile_texture1, map_width, map_height))
layers.push(MapChipLayer.new(tile_texture2, map_width, map_height))

    _ids1= [
             0,  6,  6,  6,  3,  3,  3,  3,  3,  1,  1,  3,  3,  3,  3,  3,  3,  3,  3,  3,
             6,  6,  6,  3,  3,  3,  3,  3,  1,  1,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,
             6,  6,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  4,  4,  4,  4,  4,
             3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  4,  2,  2,  2,  2,  2,
             3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  4,  3,  1,  2,  2,  2,  2,  2,
             3,  3,  3,  3,  3,  3,  3,  4,  4,  4,  4,  4,  4,  3,  3,  2,  2,  2,  2,  2,
             3,  3,  3,  3,  4,  4,  4,  4,  1,  1,  1,  1,  1,  1,  3,  1,  2,  2,  1,  2,
             3,  3,  3,  4,  4,  1,  1,  1,  1,  1,  1,  1,  1,  1,  3,  1,  1,  2,  2,  2,
             3,  3,  3,  4,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  3,  3,  3,  1,  1,  1,
             4,  4,  4,  4,  1,  1,  2,  1,  1,  1,  1,  1,  1,  1,  1,  1,  3,  3,  3,  1,
             1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  5,  5,  5,  5,  5,  5,  1,  1,  3,  3,
             1,  1,  1,  1,  1,  1,  1,  1,  1,  5,  5,  4,  4,  4,  4,  5,  5,  1,  1,  3,
             1,  2,  1,  1,  1,  1,  1,  1,  5,  5,  4,  4,  4,  4,  4,  4,  5,  5,  1,  1,
             1,  1,  1,  1,  1,  1,  1,  1,  5,  4,  4,  4,  4,  4,  4,  4,  4,  5,  1,  1,
             1,  1,  1,  1,  2,  1,  1,  1,  5,  4,  4,  4,  4,  4,  4,  4,  4,  5,  1,  1,
             3,  3,  3,  3,  3,  3,  1,  1,  5,  5,  4,  4,  4,  4,  4,  4,  5,  5,  1,  1,
             3,  2,  2,  2,  2,  3,  1,  1,  1,  5,  5,  4,  4,  4,  4,  5,  5,  1,  1,  1,
             2,  2,  2,  2,  2,  3,  3,  3,  3,  1,  5,  5,  5,  5,  5,  5,  1,  1,  1,  1,
             2,  2,  2,  2,  2,  2,  2,  2,  3,  3,  1,  1,  1,  1,  1,  1,  1,  2,  1,  1,
             2,  2,  2,  2,  2,  2,  2,  2,  2,  3,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1]

    _ids2= [
             4,  4,  4,  4,  0,  0,  0,  0,  0,  2,  2,  0,  0,  0,  0,  0,  0,  0,  0,  0,
             4,  4,  4,  0,  0,  0,  0,  0,  2,  2,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
             4,  4,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
             0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
             0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
             0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,
             0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  1,  1,  1,  7,  1,
             0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  0,  2,  2,  1,  1,  1,
             0,  0,  0,  0,  0,  0,  0,  0,  1,  2,  2,  2,  2,  2,  0,  0,  0,  2,  2,  1,
             0,  0,  0,  0,  0,  0,  0,  1,  2,  2,  3,  3,  3,  3,  3,  3,  0,  0,  0,  2,
             0,  0,  0,  0,  0,  0,  1,  2,  2,  3,  0,  0,  0,  0,  0,  0,  3,  3,  0,  0,
             1,  1,  1,  1,  1,  1,  2,  2,  3,  0,  0,  0,  0,  0,  0,  0,  0,  3,  3,  0,
             2,  2,  2,  2,  2,  2,  2,  3,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  3,  4,
             2,  2,  2,  2,  2,  2,  2,  3,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  3,  4,
             2,  2,  2,  2,  2,  2,  2,  3,  0,  0,  0,  0,  5,  6,  0,  0,  0,  0,  3,  4,
             0,  0,  0,  0,  0,  0,  2,  3,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  4,  4,
             0,  2,  2,  2,  2,  0,  2,  2,  3,  0,  0,  0,  0,  0,  0,  0,  0,  4,  4,  4,
             2,  2,  3,  3,  2,  0,  0,  0,  0,  3,  0,  0,  0,  0,  0,  0,  4,  4,  4,  4,
             2,  3,  3,  3,  3,  2,  2,  2,  0,  0,  3,  3,  3,  3,  3,  3,  4,  4,  4,  4,
             3,  3,  4,  4,  3,  3,  3,  2,  2,  0,  3,  3,  3,  3,  3,  4,  4,  4,  4,  4]

    layers[0].tile_ids= _ids1
    layers[1].tile_ids= _ids2

# シェーダーのロード
layers[0].set_shader( LoadShader("tilemap0.vs", "tilemap0.fs"))
layers[1].set_shader( LoadShader("tilemap0.vs", "tilemap0.fs"))

# シェーダーのロケーション
layers[0].set_location(
	GetShaderLocation(layers[0].tile_map_shader, "mainTexture"),
	GetShaderLocation(layers[0].tile_map_shader, "textureSize0"),
	GetShaderLocation(layers[0].tile_map_shader, "mapChipSize"),
	GetShaderLocation(layers[0].tile_map_shader, "tileCount"),
	GetShaderLocation(layers[0].tile_map_shader, "tileSize"))

layers[1].set_location(
	GetShaderLocation(layers[1].tile_map_shader, "mainTexture"),
	GetShaderLocation(layers[1].tile_map_shader, "textureSize0"),
	GetShaderLocation(layers[1].tile_map_shader, "mapChipSize"),
	GetShaderLocation(layers[1].tile_map_shader, "tileCount"),
	GetShaderLocation(layers[1].tile_map_shader, "tileSize"))

# シェーダーに渡すパラメータ
layers[0].set_vector2(
	Vector2.new(map_width * tile_size, map_height * tile_size),
	Vector2.new(tile_texture1.width, tile_texture1.height),
	Vector2.new(tile_texture1.width / tile_size, tile_texture1.height / tile_size),
	Vector2.new(tile_size, tile_size))

layers[1].set_vector2(
	Vector2.new(map_width * tile_size, map_height * tile_size),
	Vector2.new(tile_texture1.width, tile_texture1.height),
	Vector2.new(tile_texture1.width / tile_size, tile_texture1.height / tile_size),
	Vector2.new(tile_size, tile_size))


# レンダーテクスチャの作成
target = LoadRenderTexture(screen_width, screen_height)

SetTargetFPS(60)


while !WindowShouldClose()
  # タイマーの更新
  timer += GetFrameTime()
  if timer >= anime_interval
    anime_frame += 1
    timer = 0.0
  end

  # 描画開始
  BeginDrawing()
  ClearBackground(RAYWHITE)

  # レイヤーごとに描画
  vec_index = 0
  m_tile_index = 0
  layers.each do |layer|
    # レンダーテクスチャへの描画開始
    # BeginTextureMode(target)
    # ClearBackground(BLANK)

    # マップチップの描画
    (0...map_height).each do |y|
      (0...map_width).each do |x|
        m_tile_index = if vec_index != 0
                       layer.tile_index(x, y, anime_frame)
                     else
                       layer.tile_index(x, y, 0)
                     end
        next if m_tile_index == 0 # 0は描画しない

        # タイルの位置を計算
        tile_x = (m_tile_index - 1) % layer.tile_count.x.to_i
        tile_y = (m_tile_index - 1) / layer.tile_count.x.to_i

        # タイルの矩形
        source_rec = Rectangle.new(tile_x * tile_size, tile_y * tile_size, tile_size, tile_size)
        # 描画先の矩形
        dest_rec = Rectangle.new(x * tile_size, y * tile_size, tile_size, tile_size)

        # タイルの描画
        #DrawTexturePro(layer.texture, source_rec, dest_rec, origin, 0.0, WHITE)
        layer.draw_texture_pro( source_rec, dest_rec)
      end
    end
    # レンダーテクスチャへの描画終了
    # EndTextureMode()

    # シェーダーの適用開始
    BeginShaderMode(layer.tile_map_shader)

    # シェーダーパラメータの設定
    layer.set_shader_value

    # レンダーテクスチャの描画
    #DrawTextureRec(target.texture, Rectangle.new(0, 0, layer.texture_size.x, -layer.texture_size.y), Vector2.new(0, 0), WHITE)
    layer.draw_texture_rec(target)

    # シェーダーの適用終了
    EndShaderMode()
    vec_index += 1
  end # layers.each do |layer|

  DrawFPS(10, 10)
  # 描画終了
  EndDrawing()
end #!WindowShouldClose()

# リソースの解放
UnloadTexture(tile_texture1)
UnloadTexture(tile_texture2)
UnloadShader(layers[0].tile_map_shader)
UnloadShader(layers[1].tile_map_shader)
UnloadRenderTexture(target)

CloseWindow()
end #Start

end #Raylib



Raylib.Start

print 'end'

