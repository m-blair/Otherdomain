class_name PlayerSignals extends Node

# rooms
signal exited_room(next_room: StringName, door: int)
signal entered_room(door_id: int)


# Pickups, Items, and InteractiveObject interactions
signal found_object(object: InteractiveObject3D)
signal left_object(object: InteractiveObject3D)

signal found_entity(entity: Entity) # when player enters range of an Entity
signal left_entity(entity: Entity) 


signal used_item(object)  # used for keys, doors, 
signal gave_item_to_entity(entity: Entity, item: Item) # giving items to Entities

signal pickup_request(item: ItemDrop) # when player is requesting to pick up the in_range ItemDrop


# dialogue
signal dialogue_started(entity: Entity)
signal dialogue_ended(entity: Entity)
