extends Node3D

@export var processing_time: float = 1.0
var processing_count: int = 0
var finished_count: int = 0
var timer: float = 0.0

var visual_gear: CSGCylinder3D

func _ready():
    # 1. Build the Machine Body
    var base = CSGBox3D.new()
    base.size = Vector3(2.5, 2.0, 1.5)
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color(0.2, 0.2, 0.25) # Dark Industrial Gray
    base.material = mat
    add_child(base)
    
    # 2. Build the Spinning Smelter Gear
    visual_gear = CSGCylinder3D.new()
    visual_gear.radius = 0.8
    visual_gear.height = 0.6
    visual_gear.position = Vector3(0, 1.3, 0)
    var gear_mat = StandardMaterial3D.new()
    gear_mat.albedo_color = Color.ORANGE
    gear_mat.emission_enabled = true
    gear_mat.emission = Color(0.8, 0.4, 0.0)
    visual_gear.material = gear_mat
    add_child(visual_gear)
    
    # 3. Add Input Drop-off Zone
    var input_zone = load("res://machine_input.gd").new()
    input_zone.position = Vector3(-1.8, -0.8, 0) # Left side
    add_child(input_zone)
    
    # 4. Add Output Pickup Zone
    var output_zone = load("res://machine_output.gd").new()
    output_zone.position = Vector3(1.8, -0.8, 0) # Right side
    add_child(output_zone)

func _process(delta):
    # Animate and process items
    if processing_count > 0:
        visual_gear.rotation.y += delta * 6.0 # Spin fast when working!
        
        timer += delta
        if timer >= processing_time:
            processing_count -= 1
            finished_count += 1
            timer = 0.0
            
            # Show a green puff of smoke when an item finishes smelting!
            ParticleManager.spawn_poof(global_position + Vector3(0, 2, 0), Color.GREEN)
    else:
        visual_gear.rotation.y += delta * 1.0 # Spin slowly on standby
