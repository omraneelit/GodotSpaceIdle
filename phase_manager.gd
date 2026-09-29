extends Node

signal phase_changed(new_phase)

var current_phase: int = 0

func _ready():
    # We delay loading slightly to ensure SaveManager is ready
    call_deferred("initialize_data")

func initialize_data():
    var data = SaveManager.load_game()
    GameManager.money = data["money"]
    current_phase = data["phase"]
    phase_changed.emit(current_phase)
    print("Loaded Game. Phase: ", current_phase + 1)

func unlock_next_phase():
    if current_phase < 3: # 4 phases max (0, 1, 2, 3)
        current_phase += 1
        SaveManager.save_game(GameManager.money, current_phase)
        phase_changed.emit(current_phase)
        
        # Notify the Main scene to update the visible worlds
        var main = get_tree().get_root().get_node_or_null("Main")
        if main and main.has_method("update_world_visibility"):
            main.update_world_visibility()
