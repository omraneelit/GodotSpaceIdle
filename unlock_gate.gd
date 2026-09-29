extends Area3D

@export var cost: int = 100
var timer: float = 0.0

func _process(delta):
    var bodies = get_overlapping_bodies()
    for body in bodies:
        if body.name == "Player": # Only player can buy gates
            if cost > 0:
                timer += delta
                if timer > 0.05: # Drain speed
                    if GameManager.spend_money(5):
                        cost -= 5
                        timer = 0.0
                        GameManager.spawn_floating_text(global_position + Vector3(randomf_range(-1,1), 2, randomf_range(-1,1)), "-$5", Color.RED)
                        
                        if cost <= 0:
                            unlock()

func unlock():
    print("Gate Unlocked!")
    PhaseManager.unlock_next_phase()
    # Destroy the gate so we can walk through
    queue_free()
