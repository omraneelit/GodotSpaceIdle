extends Node3D

var target: Node3D
var float_offset = Vector3(1.5, 2.0, -1.5)
var timer = 0.0

func _ready():
    # Build a tiny floating pink robot
    var body = CSGSphere3D.new()
    body.radius = 0.3
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color.HOT_PINK
    mat.emission_enabled = true
    mat.emission = Color(0.8, 0.2, 0.5)
    body.material = mat
    add_child(body)
    
    target = get_tree().get_root().find_child("Player", true, false)

func _process(delta):
    timer += delta
    if timer > 5.0: # Passive Income! Generates $30 every 5 seconds
        var amount = int(30 * RebirthManager.money_multiplier)
        GameManager.add_money(amount)
        GameManager.spawn_floating_text(global_position + Vector3(0, 1, 0), "+$" + str(amount) + " (Pet)", Color.HOT_PINK)
        ParticleManager.spawn_poof(global_position, Color.HOT_PINK)
        timer = 0.0
        
    if target:
        var target_pos = target.global_position + float_offset
        # Add a smooth organic bobbing motion
        target_pos.y += sin(Time.get_ticks_msec() * 0.005) * 0.3
        
        # Smoothly follow player
        global_position = global_position.lerp(target_pos, delta * 4.0)
        
        # Always stare at the player
        look_at(target.global_position, Vector3.UP)
