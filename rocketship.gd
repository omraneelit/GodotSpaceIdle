extends Area3D

@export var cost: int = 10000 # Massive Endgame Cost!
var timer = 0.0
var launched = false
var rocket_mesh: Node3D

func _ready():
    # Build a giant Rocketship visually
    rocket_mesh = Node3D.new()
    add_child(rocket_mesh)
    
    var body = CSGCylinder3D.new()
    body.radius = 2.0; body.height = 8.0
    body.position = Vector3(0, 4, 0)
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color.WHITE
    body.material = mat
    rocket_mesh.add_child(body)
    
    var nose = CSGCone3D.new()
    nose.radius = 2.0; nose.height = 3.0
    nose.position = Vector3(0, 9.5, 0)
    var nmat = StandardMaterial3D.new()
    nmat.albedo_color = Color.RED
    nose.material = nmat
    rocket_mesh.add_child(nose)
    
    # Add collision for the Launch Pad / Buy Zone
    var col = CollisionShape3D.new()
    var box = BoxShape3D.new()
    box.size = Vector3(8, 2, 8) # Huge pad
    col.shape = box
    add_child(col)
    
    var pad_mesh = CSGBox3D.new()
    pad_mesh.size = Vector3(8, 0.2, 8)
    var pmat = StandardMaterial3D.new()
    pmat.albedo_color = Color.YELLOW
    pad_mesh.material = pmat
    add_child(pad_mesh)

func _process(delta):
    if launched:
        # Cutscene Logic: Fly up and spin
        rocket_mesh.position.y += delta * 25.0 
        rocket_mesh.rotation.y += delta * 2.0
        GameManager.shake_camera(0.3) # RUMBLE!
        return
        
    var bodies = get_overlapping_bodies()
    for b in bodies:
        if b.name == "Player":
            if cost > 0:
                timer += delta
                if timer > 0.01: # Drain incredibly fast
                    var drain_amount = 100 # Drain $100 per tick!
                    if GameManager.spend_money(drain_amount):
                        cost -= drain_amount
                        timer = 0.0
                        GameManager.spawn_floating_text(global_position + Vector3(0, 4, 0), "-$100", Color.RED)
                        if cost <= 0:
                            launch_cutscene(b)

func launch_cutscene(player: Node3D):
    launched = true
    
    # Massive particle explosion
    ParticleManager.spawn_poof(global_position, Color.ORANGE)
    ParticleManager.spawn_poof(global_position + Vector3(2,0,2), Color.YELLOW)
    ParticleManager.spawn_poof(global_position + Vector3(-2,0,-2), Color.RED)
    
    # Hide the player (they've boarded the ship)
    player.visible = false
    player.process_mode = Node.PROCESS_MODE_DISABLED
    
    # Hijack the camera to follow the rocket into space
    var cam = get_tree().get_root().find_child("MainCamera", true, false)
    if cam:
        cam.target = rocket_mesh
        
    # Spawn Victory UI
    var canvas = CanvasLayer.new()
    var win_label = Label.new()
    win_label.text = "YOU WIN!\nESCAPED THE STATION!"
    win_label.add_theme_font_size_override("font_size", 96)
    win_label.add_theme_color_override("font_color", Color.GOLD)
    win_label.add_theme_color_override("font_outline_color", Color.BLACK)
    win_label.add_theme_constant_override("outline_size", 16)
    
    win_label.position = Vector2(100, 200)
    canvas.add_child(win_label)
    get_tree().get_root().add_child(canvas)
    
    # TRIGGER REBIRTH SYSTEM AFTER 6 SECONDS
    var t = get_tree().create_timer(6.0)
    t.timeout.connect(func(): RebirthManager.do_rebirth())
