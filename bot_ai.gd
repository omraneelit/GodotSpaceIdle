extends Node3D

@export var speed: float = 5.0
var source_zone: Node3D
var dest_zone: Node3D

var state = "TO_SOURCE"
var stacker: Node

func _ready():
    stacker = get_node_or_null("ItemStacker")

func _process(delta):
    if not source_zone or not dest_zone or not stacker:
        return
        
    var target_pos = Vector3.ZERO
    
    if state == "TO_SOURCE":
        target_pos = source_zone.global_position
        if global_position.distance_to(target_pos) < 1.0:
            if stacker.is_full():
                state = "TO_DEST"
    elif state == "TO_DEST":
        target_pos = dest_zone.global_position
        if global_position.distance_to(target_pos) < 1.0:
            if stacker.is_empty():
                state = "TO_SOURCE"
                
    # Move towards the target position
    if target_pos != Vector3.ZERO:
        # Flatten Y so they don't fly
        var flat_target = Vector3(target_pos.x, global_position.y, target_pos.z)
        var dir = global_position.direction_to(flat_target)
        
        global_position = global_position.move_toward(flat_target, speed * delta)
        
        # Look in the direction of movement smoothly
        if dir.length() > 0.1:
            var target_rotation = atan2(dir.x, dir.z)
            rotation.y = lerp_angle(rotation.y, target_rotation, 15.0 * delta)
