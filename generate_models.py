import os
import math
import random

def create_crystal(filepath):
    with open(filepath, "w") as f:
        f.write("# Procedural Crystal Model\n")
        f.write("v 0.0 1.0 0.0\n") # Top tip (v1)
        # Hexagon middle ring (v2 to v7)
        for i in range(6):
            angle = i * (math.pi / 3)
            f.write(f"v {0.5 * math.cos(angle)} 0.0 {0.5 * math.sin(angle)}\n")
        f.write("v 0.0 -1.0 0.0\n") # Bottom tip (v8)
        
        # Faces
        for i in range(6):
            next_i = (i + 1) % 6
            f.write(f"f 1 {i+2} {next_i+2}\n") # Top half
            f.write(f"f 8 {next_i+2} {i+2}\n") # Bottom half

def create_asteroid(filepath):
    # A simple randomized blocky asteroid
    with open(filepath, "w") as f:
        f.write("# Procedural Asteroid Model\n")
        # Generate 8 vertices of a distorted cube
        verts = []
        for x in [-1, 1]:
            for y in [-1, 1]:
                for z in [-1, 1]:
                    # Add random distortion
                    dx = x * random.uniform(0.6, 1.2)
                    dy = y * random.uniform(0.6, 1.2)
                    dz = z * random.uniform(0.6, 1.2)
                    verts.append((dx, dy, dz))
                    f.write(f"v {dx} {dy} {dz}\n")
        
        # Cube faces (1-based index)
        # 1: -1,-1,-1 | 2: -1,-1,1 | 3: -1,1,-1 | 4: -1,1,1
        # 5:  1,-1,-1 | 6:  1,-1,1 | 7:  1,1,-1 | 8:  1,1,1
        faces = [
            (1, 5, 7, 3), # Back
            (2, 4, 8, 6), # Front
            (1, 2, 6, 5), # Bottom
            (3, 7, 8, 4), # Top
            (1, 3, 4, 2), # Left
            (5, 6, 8, 7)  # Right
        ]
        
        for face in faces:
            # OBJ faces can be quads
            f.write(f"f {face[0]} {face[1]} {face[2]} {face[3]}\n")

if __name__ == "__main__":
    base_dir = "models"
    create_crystal(os.path.join(base_dir, "crystal.obj"))
    create_asteroid(os.path.join(base_dir, "asteroid.obj"))
    print("Python generation complete: crystal.obj and asteroid.obj created!")
