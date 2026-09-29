extends Area3D

@export var spawn_time: float = 0.5
var timer: float = 0.0

func _process(delta):
    var bodies = get_overlapping_bodies()
    for body in bodies:
        # Check if the object entering has the ItemStacker node
        if body.has_node("ItemStacker"):
            var stacker = body.get_node("ItemStacker")
            if not stacker.is_full():
                timer += delta
                if timer >= spawn_time:
                    if stacker.add_item():
                        timer = 0.0
