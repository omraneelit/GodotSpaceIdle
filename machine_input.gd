extends Area3D

var timer: float = 0.0
@export var processing_speed: float = 0.15 # Time between sucking items

func _ready():
    # Setup Physical Collision
    var col = CollisionShape3D.new()
    var box = BoxShape3D.new()
    box.size = Vector3(1.5, 1.0, 1.5)
    col.shape = box
    add_child(col)
    
    # Setup Red "Drop" Pad Visuals
    var mesh = CSGBox3D.new()
    mesh.size = Vector3(1.5, 0.2, 1.5)
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color.RED
    mesh.material = mat
    add_child(mesh)

func _process(delta):
    var parent_machine = get_parent()
    var bodies = get_overlapping_bodies()
    
    for body in bodies:
        if body.has_node("ItemStacker"):
            var stacker = body.get_node("ItemStacker")
            
            if not stacker.is_empty():
                timer += delta
                if timer > processing_speed:
                    if stacker.remove_item():
                        # Item successfully removed from backpack, send to machine!
                        parent_machine.processing_count += 1
                        GameManager.spawn_floating_text(global_position + Vector3(0, 1, 0), "INSERTED", Color.RED)
                    timer = 0.0
