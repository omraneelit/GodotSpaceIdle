extends CharacterBody3D

var speed = 2.5 # Slow and menacing
var target: Node3D
var state = "SEEKING"
var health = 500 # MASSIVE HP!

func _ready():
    # Build Giant Boss Visual
    var mesh = CSGBox3D.new()
    mesh.size = Vector3(1.8, 3.6, 1.8) # 3x the size of a pirate
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color.DARK_RED
    mat.emission_enabled = true
    mat.emission = Color(0.2, 0, 0)
    mesh.material = mat
    add_child(mesh)
    
    var anim = load("res://squash_stretch.gd").new()
    add_child(anim)
    anim.target_node_path = ".."
    
    target = get_tree().get_root().find_child("Player", true, false)

func take_damage(dmg: int):
    health -= dmg
    GameManager.spawn_floating_text(global_position + Vector3(0, 4, 0), "BOSS -" + str(dmg), Color.ORANGE)
    ParticleManager.spawn_poof(global_position, Color.DARK_RED)
    
    if health <= 0:
        GameManager.add_money(500) # Insane payout!
        GameManager.spawn_floating_text(global_position + Vector3(0, 5, 0), "BOSS DEFEATED! +$500", Color.GOLD)
        queue_free()

func _process(delta):
    if state == "SEEKING" and target:
        var move_target = target.global_position
        var flat_target = Vector3(move_target.x, global_position.y, move_target.z)
        var dir = global_position.direction_to(flat_target)
        
        velocity = dir * speed
        move_and_slide()
        
        if dir.length() > 0.1:
            rotation.y = lerp_angle(rotation.y, atan2(dir.x, dir.z), 5.0 * delta)
            
        # If it reaches the player
        if global_position.distance_to(target.global_position) < 2.5:
            if target.has_method("take_damage"):
                target.take_damage(40) # Deal 40 damage per hit
                GameManager.shake_camera(0.6) # HUGE SHAKE
                # Knockback the player
                target.global_position += dir * 2.0
