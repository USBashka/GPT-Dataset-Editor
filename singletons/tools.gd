extends Node


func find(data: Array) -> int:
	return 0

func replace(data: Array, from: String, to: String) -> int:
	var count: int = 0
	for example in data:
		for message in example.messages:
			message.content = message.content.replace(from, to)
			count += 1
	return count
