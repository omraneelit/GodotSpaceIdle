extends Area3D

func _ready():
    # Build Hoverbike Visuals
    var body = CSGBox3D.new()
    body.size = Vector3(0.6, 0.4, 2.0)
    body.material = StandardMaterial3D.new()
    body.material.albedo_color = Color.DODGER_BLUE
    add_child(body)
    
    var thruster = CSGCylinder3D.new()
    thruster.radius = 0.4
    thruster.height = 0.5
    thruster.position = Vector3(0, 0, 1.0)
    thruster.rotation_degrees.x = 90
    thruster.material = StandardMaterial3D.new()
    thruster.material.albedo_color = Color.DARK_GRAY
    add_child(thruster)
    
    var col = CollisionShape3D.new()
    col.shape = SphereShape3D.new()
    col.shape.radius = 2.0
    add_child(col)

func _process(delta):
    # Hover effect
    position.y += sin(Time.get_ticks_msec() * 0.005) * 0.005
    
    var bodies = get_overlapping_bodies()
    for b in bodies:
        if b.name == "Player":
            b.mount_bike()
            queue_free()
