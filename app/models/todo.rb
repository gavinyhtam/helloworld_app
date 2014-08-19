class Todo < ActiveRecord::Base
	validates :todo_item, presence: true
	#Todo.create(todo_item: "Pay your bills")
	#Todo.create(todo_item: "Eat food")
end
