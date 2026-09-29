extends CharacterBody3D

@export var speed: float = 8.0
@export var turn_speed: float = 15.0
@export var jump_force: float = 12.0
@export var max_health: int = 100

var health: int = 100
var gravity: float = 25.0
var is_riding = false
var bike_mesh: Node3D

func mount_bike():
    if is_riding: return
    is_riding = true
    speed += 15.0 # Insane speed boost!
    jump_force += 10.0
    GameManager.shake_camera(0.6)
    ParticleManager.spawn_poof(global_position, Color.DODGER_BLUE)
    GameManager.spawn_floating_text(global_position + Vector3(0, 3, 0), "HOVERBIKE MOUNTED!", Color.DODGER_BLUE)
    
    # Visually attach the bike to the player
    bike_mesh = CSGBox3D.new()
    bike_mesh.size = Vector3(0.8, 0.5, 2.2)
    bike_mesh.position = Vector3(0, -0.3, 0)
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color.DODGER_BLUE
    bike_mesh.material = mat
    add_child(bike_mesh)

func _physics_process(delta):
    # Gravity
    if not is_on_floor():
        velocity.y -= gravity * delta
        
    # JETPACK (Spacebar / ui_accept)
    if Input.is_action_pressed("ui_accept"):
        velocity.y = jump_force
        # Spawn jetpack flames at feet
        ParticleManager.spawn_poof(global_position + Vector3(randomf_range(-0.2,0.2), -0.5, randomf_range(-0.2,0.2)), Color.CYAN)

    var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    
    if direction:
        velocity.x = direction.x * speed
        velocity.z = direction.z * speed
        var target_rotation = atan2(velocity.x, velocity.z)
        rotation.y = lerp_angle(rotation.y, target_rotation, turn_speed * delta)
    else:
        velocity.x = move_toward(velocity.x, 0, speed)
        velocity.z = move_toward(velocity.z, 0, speed)

    move_and_slide()

func take_damage(amount: int):
    health -= amount
    GameManager.spawn_floating_text(global_position + Vector3(0, 3, 0), "-" + str(amount) + " HP", Color.RED)
    GameManager.update_health_ui(health)
    
    if health <= 0:
        die()

func die():
    ParticleManager.spawn_poof(global_position, Color.RED)
    global_position = Vector3(0, 5, 5) # Respawn at Phase 1 base
    health = max_health
    GameManager.update_health_ui(health)
    GameManager.spawn_floating_text(global_position + Vector3(0, 4, 0), "RESPAWNED!", Color.GOLD)
