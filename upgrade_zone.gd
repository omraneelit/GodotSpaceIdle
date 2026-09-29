extends Area3D

@export var upgrade_type: String = "SPEED" # Options: "SPEED", "CAPACITY"
@export var cost: int = 250
var timer: float = 0.0

func _process(delta):
    var bodies = get_overlapping_bodies()
    for body in bodies:
        if body.name == "Player":
            if cost > 0:
                timer += delta
                if timer > 0.05:
                    if GameManager.spend_money(10):
                        cost -= 10
                        timer = 0.0
                        GameManager.spawn_floating_text(global_position + Vector3(randomf_range(-1,1), 2, randomf_range(-1,1)), "-$10", Color.RED)
                        
                        if cost <= 0:
                            apply_upgrade(body)

func apply_upgrade(player: Node3D):
    ParticleManager.spawn_poof(global_position, Color.GOLD)
    GameManager.spawn_floating_text(global_position + Vector3(0, 3, 0), "UPGRADED " + upgrade_type + "!", Color.GOLD)
    
    if upgrade_type == "SPEED":
        player.speed += 3.0 # Player runs much faster
    elif upgrade_type == "CAPACITY":
        var stacker = player.get_node_or_null("ItemStacker")
        if stacker:
            stacker.max_capacity += 5 # Carry 5 more items!
            
    # Remove the pad since we bought it
    queue_free()
