extends Area3D

func _ready():
    var mesh = CSGDiamond3D.new() # Actually Godot lacks CSGDiamond, using Sphere scaled
    var sphere = CSGSphere3D.new()
    sphere.radius = 0.4
    sphere.scale = Vector3(1.0, 2.0, 1.0) # Elongated crystal shape
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color.YELLOW
    mat.emission_enabled = true
    mat.emission = Color.YELLOW
    sphere.material = mat
    add_child(sphere)
    
    var col = CollisionShape3D.new()
    var box = BoxShape3D.new()
    col.shape = box
    add_child(col)

func _process(delta):
    # Spin and float
    rotation.y += delta * 4.0
    position.y += sin(Time.get_ticks_msec() * 0.005) * 0.01
    
    var bodies = get_overlapping_bodies()
    for b in bodies:
        if b.name == "Player":
            # FRENZY MODE!
            b.speed += 12.0
            GameManager.spawn_floating_text(global_position + Vector3(0,3,0), "FRENZY SPEED!", Color.YELLOW)
            ParticleManager.spawn_poof(global_position, Color.YELLOW)
            
            # Use a timer to reset speed
            var t = get_tree().create_timer(10.0)
            t.timeout.connect(func(): 
                b.speed -= 12.0
                GameManager.spawn_floating_text(b.global_position + Vector3(0,3,0), "Frenzy Over", Color.GRAY)
            )
            
            queue_free()
