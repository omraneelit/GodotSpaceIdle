extends Area3D

var timer: float = 0.0
@export var dispense_speed: float = 0.15 # Time between giving items

func _ready():
    # Setup Physical Collision
    var col = CollisionShape3D.new()
    var box = BoxShape3D.new()
    box.size = Vector3(1.5, 1.0, 1.5)
    col.shape = box
    add_child(col)
    
    # Setup Green "Pickup" Pad Visuals
    var mesh = CSGBox3D.new()
    mesh.size = Vector3(1.5, 0.2, 1.5)
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color.GREEN
    mesh.material = mat
    add_child(mesh)

func _process(delta):
    var parent_machine = get_parent()
    
    # Only try to give items if the machine actually finished processing some
    if parent_machine.finished_count > 0:
        var bodies = get_overlapping_bodies()
        for body in bodies:
            if body.has_node("ItemStacker"):
                var stacker = body.get_node("ItemStacker")
                
                if not stacker.is_full():
                    timer += delta
                    if timer > dispense_speed:
                        if stacker.add_item():
                            # Successfully placed finished item onto backpack!
                            parent_machine.finished_count -= 1
                            GameManager.spawn_floating_text(global_position + Vector3(0, 1, 0), "COLLECTED", Color.GREEN)
                        timer = 0.0
