extends CanvasLayer

var is_paused = false
var label: Label
var bg: ColorRect

func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS # This script runs even when the game is paused
    layer = 100 # Render on top of everything
    
    # Dimming background
    bg = ColorRect.new()
    bg.color = Color(0, 0, 0, 0.5)
    bg.set_anchors_preset(Control.PRESET_FULL_RECT)
    bg.visible = false
    add_child(bg)
    
    # Pause Text
    label = Label.new()
    label.text = "- PAUSED -"
    label.add_theme_font_size_override("font_size", 96)
    label.add_theme_color_override("font_color", Color.WHITE)
    label.add_theme_color_override("font_outline_color", Color.BLACK)
    label.add_theme_constant_override("outline_size", 16)
    label.position = Vector2(350, 250)
    label.visible = false
    add_child(label)

func _process(_delta):
    if Input.is_action_just_pressed("ui_cancel"): # Escape Key
        is_paused = !is_paused
        get_tree().paused = is_paused
        label.visible = is_paused
        bg.visible = is_paused
