class_name AnylandJson2ResourceBuilder
extends Node

func build_resource(thing_json: Dictionary) -> AnylandThingResource: ## Build a resource from json
	var thing: AnylandThingResource = AnylandThingResource.new();
	
	thing.name = thing_json.get("n", "thing")
	thing.description = thing_json.get("d", "");
	
	for a in thing_json.get("a", 0):
		thing.attributes.append(int(a));
	
	for p in thing_json.get("p"):
		var part: AnylandThingPartResource = AnylandThingPartResource.new();
		
		
		# set basic part info
		part.base_shape_type = p.get("b", 1);
		
		part.material_type = p.get("t", -1);
		
		part.name = p.get("n", "part");
		
		# get part attributes
		if p.get("a") != null:
			for pa in p.get("a"):
				part.attributes.append(int(pa));
		
		if p.get("c") != null:
			for tweak in p.get("c"):
				part.changed_verts.append(tweak);
		
		# get part states
		if p.get("s") != null:
			for ps in p.get("s"):
				var new_state: ThingStateResource = ThingStateResource.new();
				
				# set pos
				var pos: Array = ps.get("p");
				new_state.position = Vector3(pos[0], pos[1], -pos[2]);
				
				var rot: Array = ps.get("r");
				new_state.rotation = Vector3(-deg_to_rad(rot[0]),-deg_to_rad(rot[1]), deg_to_rad(rot[2]));
				
				# set scale
				var scale: Array = ps.get("s");
				new_state.scale = Vector3(scale[0],scale[1],scale[2]);
				
				var color: Array = ps.get("c");
				new_state.color = Color(color[0], color[1], color[2]);
				
				
				part.states.append(new_state);
			
			thing.parts.append(part); # add to part list
	
	
	return thing;
