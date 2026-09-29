extends Node3D
class_name ItemStacker

@export var max_capacity: int = 5
@export var item_height: float = 0.5
@export var wobble_speed: float = 15.0

var stack: Array = []

func add_item() -> bool:
    if stack.size() >= max_capacity:
        return false
        
    # Create a simple visual box to represent the item for the prototype
    var mesh = CSGBox3D.new()
    mesh.size = Vector3(0.4, 0.4, 0.4)
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color.ORANGE_RED # Sci-fi Ore color
    mesh.material = mat
    
    add_child(mesh)
    
    # Start it slightly higher so it lerps down (drop-in effect)
    mesh.position = Vector3(0, (stack.size() + 1) * item_height, 0)
    stack.append(mesh)
    return true

func remove_item() -> bool:
    if stack.size() == 0:
        return false
        
    var item = stack.pop_back()
    item.queue_free()
    return true

func is_full() -> bool:
    return stack.size() >= max_capacity
    
func is_empty() -> bool:
    return stack.size() == 0

func _process(delta):
    # Wobble / rubber-band effect
    for i in range(stack.size()):
        var item = stack[i]
        var target_pos = Vector3(0, i * item_height, 0)
        item.position = item.position.lerp(target_pos, delta * wobble_speed)
        item.rotation = item.rotation.lerp(Vector3.ZERO, delta * wobble_speed)
