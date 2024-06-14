class_name SquareTexture
extends AtlasTexture

const SS = Enum.SquareState

func _init():
	resource_local_to_scene = true

func update_texture_region(sq_state: SS):
	# All of the texture mapping math happens here.
	var atlas_size: Vector2 = atlas.get_size()
	
	region = Rect2(
		int(sq_state * region.size.x) % int(atlas_size.x), 
		floor((sq_state * region.size.x) / atlas_size.x) * region.size.x, 
		region.size.x, region.size.y)
