class_name Med extends Item

enum EffectType {Hype, Chill, Trippy, None}
## Hype - speed up
## Chill - speed down + blur
## Trippy - Visuals
@export var effect: EffectType

@export var duration: float

@export var intensity: int



## Price of the item as a product
@export_range(0.0, 99999.99, 0.01, "suffix:$") var price: float
