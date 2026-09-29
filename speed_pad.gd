extends Area3D

@export var boost_speed: float = 20.0

func _ready():
    var col = CollisionShape3D.new()
    var box = BoxShape3D.new()
    box.size = Vector3(3, 0.5, 6)
    col.shape = box
    add_child(col)
    
    var mesh = CSGBox3D.new()
    mesh.size = Vector3(3, 0.2, 6)
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color.CYAN
    mat.emission_enabled = true
    mat.emission = Color.CYAN
    mesh.material = mat
    add_child(mesh)

func _process(delta):
    var bodies = get_overlapping_bodies()
    for body in bodies:
        if body is CharacterBody3D: # Affects Player, Pirates, Bots, Bosses!
            # Push them forward along the local Z axis
            var push_dir = transform.basis.z.normalized()
            # We bypass move_and_slide for a forced push, or we can just alter global_position safely
            body.global_position += push_dir * boost_speed * delta
            
            # Spawn some cool speed lines
            if randf() > 0.8:
                ParticleManager.spawn_poof(body.global_position, Color.CYAN)
