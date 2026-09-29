extends Node

func _ready():
    # Dynamically inject a WorldEnvironment for massive Polish!
    # This enables next-gen Bloom/Glow for all our emissive materials (Lasers, Pets, Factories)
    var env = Environment.new()
    env.background_mode = Environment.BG_COLOR
    env.background_color = Color(0.02, 0.02, 0.05) # Deep Space Dark Blue
    env.glow_enabled = true
    env.glow_intensity = 1.5
    env.glow_bloom = 0.3
    env.glow_blend_mode = Environment.GLOW_BLEND_MODE_ADDITIVE
    
    var we = WorldEnvironment.new()
    we.environment = env
    we.name = "GlobalWorldEnvironment"
    
    # Add it to the root so it affects every scene globally
    get_tree().get_root().call_deferred("add_child", we)
