extends Control

func _ready():
    # Setup Background
    var bg = ColorRect.new()
    bg.color = Color(0.05, 0.05, 0.1)
    bg.set_anchors_preset(Control.PRESET_FULL_RECT)
    add_child(bg)

    # Game Title
    var title = Label.new()
    title.text = "SPACE IDLE"
    title.add_theme_font_size_override("font_size", 96)
    title.add_theme_color_override("font_color", Color.CYAN)
    title.add_theme_color_override("font_outline_color", Color.WHITE)
    title.add_theme_constant_override("outline_size", 4)
    title.position = Vector2(300, 100)
    add_child(title)
    
    # Start Button
    var btn = Button.new()
    btn.text = "START EXPEDITION"
    btn.add_theme_font_size_override("font_size", 48)
    btn.position = Vector2(350, 350)
    btn.size = Vector2(400, 100)
    btn.pressed.connect(start_game)
    add_child(btn)
    
    # 3D Background Element
    var cam = Camera3D.new()
    cam.position = Vector3(0, 0, 5)
    add_child(cam)
    
    var mesh = CSGBox3D.new()
    mesh.name = "SpinBox"
    mesh.material = StandardMaterial3D.new()
    mesh.material.albedo_color = Color.PURPLE
    mesh.material.emission_enabled = true
    mesh.material.emission = Color(0.5, 0, 0.5)
    add_child(mesh)

func _process(delta):
    var m = get_node_or_null("SpinBox")
    if m:
        m.rotation.y += delta * 1.5
        m.rotation.x += delta * 0.5

func start_game():
    get_tree().change_scene_to_file("res://universe.tscn")
