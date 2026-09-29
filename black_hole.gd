extends Area3D

var timer = 0.0

func _ready():
    var col = CollisionShape3D.new()
    col.shape = SphereShape3D.new()
    col.shape.radius = 2.0
    add_child(col)
    
    var void_sphere = CSGSphere3D.new()
    void_sphere.radius = 1.5
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color.BLACK
    mat.emission_enabled = true
    mat.emission = Color(0.1, 0, 0.2)
    void_sphere.material = mat
    add_child(void_sphere)

func _process(delta):
    # Violent multidirectional spinning
    rotation.y -= delta * 5.0 
    rotation.x += delta * 3.0
    rotation.z += delta * 2.0
    
    var bodies = get_overlapping_bodies()
    for b in bodies:
        if b.has_node("ItemStacker"):
            var stacker = b.get_node("ItemStacker")
            if not stacker.is_empty():
                timer += delta
                if timer > 0.05: # Sucks items instantly!
                    if stacker.remove_item():
                        ParticleManager.spawn_poof(global_position, Color.PURPLE)
                        GameManager.shake_camera(0.1)
                        if b.name == "Player":
                            b.speed += 0.2 # Permanent tiny speed boost per item!
                            GameManager.spawn_floating_text(b.global_position, "+0.2 SPD", Color.PURPLE)
                    timer = 0.0
