extends CharacterBody3D

var speed = 4.5
var target: Node3D
var state = "SEEKING"
var escape_pos: Vector3
var health = 100

func take_damage(dmg: int):
    health -= dmg
    GameManager.spawn_floating_text(global_position, "-" + str(dmg), Color.ORANGE)
    if health <= 0:
        GameManager.add_money(25)
        GameManager.spawn_floating_text(global_position + Vector3(0, 2, 0), "BOUNTY +$25", Color.GREEN)
        queue_free()

func _ready():
    # Build red visual for the Space Pirate
    var mesh = CSGBox3D.new()
    mesh.size = Vector3(0.6, 1.2, 0.6)
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color.RED
    mesh.material = mat
    add_child(mesh)
    
    # Add bounce animation
    var anim = load("res://squash_stretch.gd").new()
    add_child(anim)
    anim.target_node_path = ".." # Point to self
    
    # Find the player to rob!
    target = get_tree().get_root().find_child("Player", true, false)

func _process(delta):
    var move_target = Vector3.ZERO
    
    if state == "SEEKING" and target:
        move_target = target.global_position
        # If we catch the player
        if global_position.distance_to(move_target) < 1.5:
            if target.has_method("take_damage"):
                target.take_damage(20) # Hurt the player!
                
            if GameManager.spend_money(50):
                GameManager.spawn_floating_text(global_position + Vector3(0,3,0), "STOLEN -$50!", Color.RED)
                ParticleManager.spawn_poof(global_position, Color.RED)
            else:
                GameManager.spend_money(GameManager.money) # Take whatever they have left
                GameManager.spawn_floating_text(global_position + Vector3(0,3,0), "ROBBED!", Color.RED)
                
            state = "FLEEING"
            # Pick a random point far outside the map to escape to
            escape_pos = global_position + Vector3(randf_range(-30, 30), 0, randf_range(40, 60))
    
    elif state == "FLEEING":
        move_target = escape_pos
        if global_position.distance_to(escape_pos) < 2.0:
            queue_free() # Pirate got away!

    # Movement Logic
    if move_target != Vector3.ZERO:
        var flat_target = Vector3(move_target.x, global_position.y, move_target.z)
        var dir = global_position.direction_to(flat_target)
        velocity = dir * speed
        move_and_slide()
        
        # Look where we are going
        if dir.length() > 0.1:
            rotation.y = lerp_angle(rotation.y, atan2(dir.x, dir.z), 10.0 * delta)
