extends Area3D

@export var sell_time: float = 0.2
@export var price_per_item: int = 15
var timer: float = 0.0

func _process(delta):
    var bodies = get_overlapping_bodies()
    for body in bodies:
        if body.has_node("ItemStacker"):
            var stacker = body.get_node("ItemStacker")
            if not stacker.is_empty():
                timer += delta
                if timer >= sell_time:
                    if stacker.remove_item():
                        var final_price = int(price_per_item * RebirthManager.money_multiplier)
                        # Call the global GameManager Autoload
                        GameManager.add_money(final_price)
                        GameManager.spawn_floating_text(body.global_position + Vector3(0, 2, 0), "+$" + str(final_price), Color.GREEN)
                        timer = 0.0
