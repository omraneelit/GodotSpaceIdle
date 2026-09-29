extends Area3D

var fire_rate = 1.0
var timer = 0.0
var head: CSGBox3D

func _ready():
    # Setup Range Area
    var col = CollisionShape3D.new()
    var sph = SphereShape3D.new()
    sph.radius = 12.0 # Huge range!
    col.shape = sph
    add_child(col)
    
    # Setup Turret Visuals
    var base = CSGCylinder3D.new()
    base.radius = 0.5; base.height = 1.0
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color.DARK_SLATE_GRAY
    base.material = mat
    add_child(base)
    
    head = CSGBox3D.new() # The Gun Barrel
    head.size = Vector3(0.3, 0.3, 1.2)
    head.position = Vector3(0, 0.7, 0)
    var hmat = StandardMaterial3D.new()
    hmat.albedo_color = Color.BLACK
    head.material = hmat
    add_child(head)

func _process(delta):
    timer += delta
    var bodies = get_overlapping_bodies()
    var target = null
    
    # Scan for Pirates in range
    for b in bodies:
        if "state" in b and (b.get("state") == "SEEKING" or b.get("state") == "FLEEING"):
            target = b
            break # Lock onto the first pirate found
            
    if target:
        # Aim the gun head at the Pirate
        head.look_at(target.global_position, Vector3.UP)
        
        if timer >= fire_rate:
            shoot(target)
            timer = 0.0

func shoot(target: Node3D):
    # Flash yellow at the gun barrel
    var muzzle_pos = head.global_position - head.transform.basis.z * 0.6
    ParticleManager.spawn_poof(muzzle_pos, Color.YELLOW)
    
    # Explode the pirate in red
    ParticleManager.spawn_poof(target.global_position, Color.RED)
    GameManager.spawn_floating_text(target.global_position, "PEW!", Color.ORANGE)
    
    if target.has_method("take_damage"):
        target.take_damage(50)
    else:
        target.queue_free()
