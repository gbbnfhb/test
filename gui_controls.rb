print 'start'
require './color'
require './raygui'

module Raylib
  include RayGui.include_enums

  def self.TextFormat(format_str, *args)
    result = ""
    arg_index = 0
    format_str.each_char do |char|
      if char == '%'
        format_char = format_str[format_str.index(char) + 1]
        case format_char
        when 'd', 'i'
          if args[arg_index].respond_to?(:to_i)
            result += args[arg_index].to_i.to_s
          else
            result += "0" # to_i がない場合は 0 にする
          end
          arg_index += 1
        when 'f'
          if args[arg_index].respond_to?(:to_f)
            result += args[arg_index].to_f.to_s
          else
            result += "0.0" # to_f がない場合は 0.0 にする
          end
          arg_index += 1
        when 's'
          result += args[arg_index].to_s
          arg_index += 1
        when '%'
          result += '%'
        else
          result += char
        end
        format_str.slice!(format_str.index(char), 2)
      else
        result += char
        format_str.slice!(format_str.index(char), 1)
      end
    end
    result
  end


def self.Start
  screenWidth = 960
  screenHeight = 560
  InitWindow(screenWidth, screenHeight, "Yet Another Ruby-raylib bindings - raygui controls")
  SetExitKey(0)

  dropdownBox000Active = 0
  dropDown000EditMode = false

  dropdownBox001Active = 0
  dropDown001EditMode = false

  spinner001Value = 0
  spinnerEditMode = false

  valueBox002Value = 0
  valueBoxEditMode = false

  #textBoxText = FFI::MemoryPointer.new(:char, 64)
  textBoxText="Text box                                                                                  "
  textBoxEditMode = false

  #textBoxMultiText = FFI::MemoryPointer.new(:char, 1024)
  textBoxMultiText="Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  textBoxMultiEditMode = false

  listViewScrollIndex = 0
  listViewActive = -1

  listViewExScrollIndex = 0
  listViewExActive = 2
  listViewExFocus = -1
  listViewExList = ["This", "is", "a", "list view", "with", "disable", "elements", "amazing!"]

  colorPickerValue = RED

  sliderValue = 50.0
  sliderBarValue = 60
  progressValue = 0.1

  forceSquaredChecked = false

  alphaValue = 0.5

  visualStyleActive = 3
  prevVisualStyleActive = 0

  toggleGroupActive = 0
  toggleSliderActive = 0

  viewScroll = Vector2.new(0,0)

  #----------------------------------------------------------------------------------

  exitWindow = false
  showMessageBox = false

  #textInput = FFI::MemoryPointer.new(:char, 256)
  textInputFileName = "                                                            " #FFI::MemoryPointer.new(:char, 256)
  showTextInputBox = false

  alpha = 1.0

  SetTargetFPS(60)

  #value_buf = FFI::MemoryPointer.new(:int, 1)

  until exitWindow

    exitWindow = WindowShouldClose()

    showMessageBox = !showMessageBox if IsKeyPressed(KEY_ESCAPE)

    showTextInputBox = true if (IsKeyDown(KEY_LEFT_CONTROL) || IsKeyDown(KEY_LEFT_SUPER)) && IsKeyPressed(KEY_S)

=begin
    alpha -= 0.002
    alpha = 0.0 if alpha < 0.0
    alpha = 1.0 if IsKeyPressed(KEY_SPACE)
    GuiSetAlpha(alpha)
=end

    if IsKeyPressed(KEY_LEFT)
      progressValue -= 0.1
    elsif IsKeyPressed(KEY_RIGHT)
      progressValue += 0.1
    end
    progressValue.clamp(0.0, 1.0)

    if visualStyleActive != prevVisualStyleActive
      RayGui.LoadStyleDefault()
      case (visualStyleActive)
      when 0;
      when 1; RayGui.LoadStyle(RAYGUI_STYLE_PATH + 'jungle/style_jungle.rgs')
      when 2; RayGui.LoadStyle(RAYGUI_STYLE_PATH + 'lavanda/style_lavanda.rgs')
      when 3; RayGui.LoadStyle(RAYGUI_STYLE_PATH + 'dark/style_dark.rgs')
      when 4; RayGui.LoadStyle(RAYGUI_STYLE_PATH + 'bluish/style_bluish.rgs')
      when 5; RayGui.LoadStyle(RAYGUI_STYLE_PATH + 'cyber/style_cyber.rgs')
      when 6; RayGui.LoadStyle(RAYGUI_STYLE_PATH + 'terminal/style_terminal.rgs')
      else;
      end
      RayGui.SetStyle(LABEL, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)

      prevVisualStyleActive = visualStyleActive;
    end

    # Draw
    # ----------------------------------------------------------------------------------
    BeginDrawing()
      ClearBackground(GetColor(RayGui.GetStyle(GuiControl::DEFAULT, GuiDefaultProperty::BACKGROUND_COLOR)))

      #GuiLock() if dropDown000EditMode || dropDown001EditMode

      # First GUI column
      forceSquaredChecked, result = RayGui.CheckBox(Rectangle.new(25, 108, 15, 15), "FORCE CHECK!", forceSquaredChecked)

      RayGui.SetStyle(TEXTBOX, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)

      spinner001Value, result = RayGui.Spinner(Rectangle.new(25, 135, 125, 30), "Spinner", spinner001Value, 0, 100, spinnerEditMode)
      spinnerEditMode = !spinnerEditMode if result != 0

      valueBox002Value, result = RayGui.ValueBox(Rectangle.new(25, 175, 125, 30), "ValueBox", valueBox002Value, 0, 100, valueBoxEditMode)
      valueBoxEditMode = !valueBoxEditMode if result != 0

      RayGui.SetStyle(TEXTBOX, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)
      result = RayGui.TextBox(Rectangle.new(25, 215, 125, 30), textBoxText, textBoxText.size, textBoxEditMode)
      textBoxEditMode = !textBoxEditMode if result != 0

      RayGui.SetStyle(BUTTON, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER);

      it = RayGui.IconText(ICON_FILE_SAVE, "Save File")
      showTextInputBox = true if RayGui.Button(Rectangle.new(25, 255, 125, 30), it) != 0

      RayGui.GroupBox(Rectangle.new(25, 310, 125, 150), "STATES")
      RayGui.SetState(STATE_NORMAL)
      RayGui.Button(Rectangle.new(30, 320, 115, 30), "NORMAL")
      RayGui.SetState(STATE_FOCUSED)
      RayGui.Button(Rectangle.new(30, 355, 115, 30), "FOCUSED")
      RayGui.SetState(STATE_PRESSED)
      RayGui.Button(Rectangle.new(30, 390, 115, 30), "#15#PRESSED")
      RayGui.SetState(STATE_DISABLED)
      RayGui.Button(Rectangle.new(30, 425, 115, 30), "DISABLED")
      RayGui.SetState(STATE_NORMAL)

      visualStyleActive, result = RayGui.ComboBox(Rectangle.new(25, 480, 125, 30), "default;Jungle;Lavanda;Dark;Bluish;Cyber;Terminal", visualStyleActive)

      #RayGui.Unlock()
      RayGui.SetStyle(DROPDOWNBOX, TEXT_PADDING, 4)
      RayGui.SetStyle(DROPDOWNBOX, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)
      dropdownBox001Active, result = RayGui.DropdownBox(Rectangle.new(25, 65, 125, 30), "#01#ONE;#02#TWO;#03#THREE;#04#FOUR", dropdownBox001Active, dropDown001EditMode)
      dropDown001EditMode = !dropDown001EditMode if result != 0
      RayGui.SetStyle(DROPDOWNBOX, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)
      RayGui.SetStyle(DROPDOWNBOX, TEXT_PADDING, 0)
      dropdownBox000Active, result = RayGui.DropdownBox(Rectangle.new(25, 25, 125, 30), "ONE;TWO;THREE", dropdownBox000Active, dropDown000EditMode)
      dropDown000EditMode = !dropDown000EditMode if result != 0

      # Second GUI column

      listViewScrollIndex, listViewActive, result = RayGui.ListView(Rectangle.new(165, 25, 140, 124), "Charmander;Bulbasaur;#18#Squirtel;Pikachu;Eevee;Pidgey", listViewScrollIndex, listViewActive)
      listViewExScrollIndex, listViewExActive, listViewExFocus, result = RayGui.ListViewEx(Rectangle.new(165, 162, 140, 184), listViewExList, 8, listViewExScrollIndex, listViewExActive, listViewExFocus)

      toggleGroupActive, result = RayGui.ToggleGroup(Rectangle.new(165, 360, 140, 24), "#1#ONE\n#3#TWO\n#8#THREE\n#23#", toggleGroupActive)
      RayGui.SetStyle(SLIDER, SLIDER_PADDING, 2)
      toggleSliderActive, result = RayGui.ToggleSlider(Rectangle.new(165, 480, 140, 30), "ON;OFF", toggleSliderActive)
      RayGui.SetStyle(SLIDER, SLIDER_PADDING, 0)

      # Third GUI column
      RayGui.Panel(Rectangle.new(320, 25, 225, 140), "Panel Info")
      RayGui.ColorPicker(Rectangle.new(320, 185, 196, 192), "ColorPicker", colorPickerValue)

      sliderValue, result = RayGui.Slider(Rectangle.new(355, 400, 165, 20), "TEST", TextFormat("%2.2f", :float, sliderValue), sliderValue, -50, 100)
      sliderBarValue, result = RayGui.SliderBar(Rectangle.new(320, 430, 200, 20), "SliderBar", TextFormat("%i", :int, sliderBarValue.to_i), sliderBarValue, 0, 100)

      progressValue, result =  RayGui.ProgressBar(Rectangle.new(320, 460, 200, 20), "ProgressBar", TextFormat("%i%%", :int, (progressValue*100).to_i), progressValue, 0.0, 1.0)
      RayGui.Enable()

      view = Rectangle.new(0,0,0,0)
      RayGui.ScrollPanel(Rectangle.new(560, 25, 102, 354), "ScrollPanel", Rectangle.new(560, 25, 300, 1200), viewScroll, view)

      mouseCell = Vector2.new(0,0)
      RayGui.Grid(Rectangle.new(560, 25 + 180 + 195, 100, 120), "Grid", 20, 3, mouseCell)

      alphaValue, result = RayGui.ColorBarAlpha(Rectangle.new(320, 490, 200, 30), "ColorBarAlpha", alphaValue)

      RayGui.SetStyle(DEFAULT, TEXT_ALIGNMENT_VERTICAL, TEXT_ALIGN_TOP)
      RayGui.SetStyle(DEFAULT, TEXT_WRAP_MODE, TEXT_WRAP_WORD)
      result = RayGui.TextBox(Rectangle.new(678, 25, 258, 492), textBoxMultiText, textBoxMultiText.size, textBoxMultiEditMode)
      textBoxMultiEditMode = !textBoxMultiEditMode if result != 0

      RayGui.SetStyle(DEFAULT, TEXT_WRAP_MODE, TEXT_WRAP_NONE)
      RayGui.SetStyle(DEFAULT, TEXT_ALIGNMENT_VERTICAL, TEXT_ALIGN_MIDDLE)

      RayGui.SetStyle(DEFAULT, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)
      RayGui.StatusBar(Rectangle.new(0, GetScreenHeight().to_f - 20, GetScreenWidth().to_f, 20), "This is a status bar")
      RayGui.SetStyle(DEFAULT, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)

      if showMessageBox
        DrawRectangle(0, 0, GetScreenWidth(), GetScreenHeight(), Fade(RAYWHITE, 0.8))
        result = RayGui.MessageBox(Rectangle.new(GetScreenWidth().to_f/2 - 125, GetScreenHeight().to_f/2 - 50, 250, 100), GuiIconText(ICON_EXIT, "Close Window"), "Do you really want to exit?", "Yes;No")

        if (result == 0) || (result == 2)
          showMessageBox = false
        elsif (result == 1)
          exitWindow = true
        end
      end

      if showTextInputBox
        r= Rectangle.new(0, 0, GetScreenWidth(), GetScreenHeight())
        DrawRectangle(r, Fade(RAYWHITE, 0.8))
        result = RayGui.TextInputBox(Rectangle.new(GetScreenWidth().to_f/2 - 120, GetScreenHeight().to_f/2 - 60, 240, 140), GuiIconText(ICON_FILE_SAVE, "Save file as..."), "Introduce output file name:", "Ok;Cancel", textInput, 255, nil)

        if result == 1
          textInputFileName.write_string(textInput.read_string)
        end
        if (result == 0) || (result == 1) || (result == 2)
          showTextInputBox = false
          textInput.clear
        end
      end

      DrawFPS(10, 10)
    EndDrawing()
  end

  CloseWindow()
end

end
Raylib.Start

print 'end'