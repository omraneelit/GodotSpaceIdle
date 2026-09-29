extends Node3D

var state = "ARRIVING"
var hover_height = 0.5
var timer = 0.0
var sell_zone: Area3D

func _ready():
    # 1. Build the UFO Visuals procedurally
    var dome = CSGSphere3D.new()
    dome.radius = 1.5
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color.PURPLE
    mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    mat.albedo_color.a = 0.8
    mat.emission_enabled = true
    mat.emission = Color(0.5, 0.0, 0.5)
    dome.material = mat
    add_child(dome)
    
    var base = CSGCylinder3D.new()
    base.radius = 3.0
    base.height = 0.5
    base.position = Vector3(0, -0.5, 0)
    var bmat = StandardMaterial3D.new()
    bmat.albedo_color = Color.DARK_GRAY
    bmat.metallic = 0.9
    base.material = bmat
    add_child(base)
    
    # 2. Attach a high-paying Sell Zone to the UFO
    var sell_script = load("res://sell_zone.gd")
    if sell_script:
        sell_zone = sell_script.new()
        sell_zone.price_per_item = 100 # MASSIVE PAYOUT
        sell_zone.sell_time = 0.1
        
        var col = CollisionShape3D.new()
        var cyl = CylinderShape3D.new()
        cyl.radius = 3.5
        cyl.height = 2.0
        col.shape = cyl
        sell_zone.add_child(col)
        add_child(sell_zone)

    # Start high in the sky
    position.y = 30.0

func _process(delta):
    if state == "ARRIVING":
        position.y = lerp(position.y, hover_height, delta * 3.0)
        
        # Spin the UFO
        rotation.y += delta * 2.0
        
        if position.y < hover_height + 0.1:
            state = "WAITING"
            ParticleManager.spawn_poof(global_position, Color.PURPLE)
            GameManager.spawn_floating_text(global_position + Vector3(0, 4, 0), "ALIEN TRADER ARRIVED!", Color.PURPLE)
            
    elif state == "WAITING":
        rotation.y += delta * 1.0 # spin slower
        timer += delta
        # Stay for 20 seconds, then leave
        if timer > 20.0:
            leave()
            
    elif state == "LEAVING":
        position.y = lerp(position.y, 40.0, delta * 2.0)
        rotation.y += delta * 5.0 # spin very fast
        if position.y > 35.0:
            queue_free()

func leave():
    state = "LEAVING"
    GameManager.spawn_floating_text(global_position + Vector3(0, 4, 0), "ALIENS DEPARTING...", Color.PURPLE)
    if sell_zone:
        sell_zone.queue_free() # Stop accepting items while flying away
