from question import GameQuestion

class ThreePointer():
	def __init__(self, variable_name, value):
		self.name = "3 pointers"
		self.variable_name = variable_name
		self.multiplier = 3
		self.value = value

	# X = 3 pointers
	def definition_string(self):
		return "{variable_name} = {name}".format(variable_name=self.variable_name, name=self.name)

	def total_points_formula(self):
		return "3{variable_name}".format(variable_name=self.variable_name)

class FieldGoal():
	def __init__(self, variable_name, value):
		self.name = "Field Goals"
		self.variable_name = variable_name
		self.multiplier = 2
		self.value = value
	# X = Field Goals
	def definition_string(self):
		return "{variable_name} = {name}".format(variable_name=self.variable_name, name=self.name)
	def total_points_formula(self):
		return "2{variable_name}".format(variable_name=self.variable_name)

class FreeThrow():
	def __init__(self, variable_name, value):
		self.name = "Free Throws"
		self.variable_name = variable_name
		self.multiplier = 1
		self.value = value
	# X = Free Throws
	def definition_string(self):
		return "{variable_name} = {name}".format(variable_name=self.variable_name, name=self.name)
	def total_points_formula(self):
		return self.variable_name

class BasketballFormula():
	def __init__(self, game, three_pointers, field_goals, free_throws):
		self.game = game
		self.three_pointers = three_pointers
		self.field_goals = field_goals
		self.free_throws = free_throws

		self.point_types = [ThreePointer(variable_name="x", value=self.three_pointers),
							FieldGoal(variable_name="y", value=self.field_goals),
							FreeThrow(variable_name="z", value=self.free_throws)]
		self.valid_point_types = [point_type for point_type in self.point_types if point_type.value > 0]

		self.total = self.three_pointers * 3 + self.field_goals * 2 + self.free_throws

		if len([v for v in [three_pointers, field_goals, free_throws] if v > 0]) <= 1:
			print "Warning, there are < 2 non-empty point types. Creating a formula may produce unexpected results: ", self.three_pointers, self.field_goals, self.free_throws

	def get_formula_string(self):
		formulas = [point_type.total_points_formula() for point_type in self.point_types if point_type.value > 0]
		if len(formulas) < 2:
			return None
		return " + ".join(formulas)

	def get_variable_definition_string(self):
		definitions = [point_type.definition_string() for point_type in self.point_types if point_type.value > 0]
		if len(definitions) < 2:
			return None
		return ". ".join(definitions) + "."
	

"X=2 pointers; Y=3 pointers."
"Bryant scored a total of 45 points."
"(1) If 3X-2Y = 45, how many 3 pointers did he shoot? (2) Express 2 pointers in terms of 3 pointers. (2) How many more 3 pointers must he shoot to score a total of 60 points? Possible with the generator?"

class PlayerStatsFormula(BasketballFormula):
	def __init__(self, game, three_pointers, field_goals, free_throws, player):
		BasketballFormula.__init__(self, game, three_pointers, field_goals, free_throws)
		self.player = player

	def create_questions(self):
		questions = []
		answers = []

		variable_definition_string = self.get_variable_definition_string()
		player_string = "{player} scored a total of {total} points.".format(player=self.player, total=self.total)
		for point_type in self.point_types:
			question_string = "If {formula} = {total}, how many {name} did he shoot? {in_terms_sentence}".format(formula=self.get_formula_string(), \
																				  								total=self.total, \
																				  								name=point_type.name, \
																				  								in_terms_sentence=self.get_in_terms_sentence(point_type))
			answer = self.solve_for_variable(point_type.variable_name)
			if answer is not None:
				combined = "{} {} {}".format(variable_definition_string, player_string, question_string)
				question = GameQuestion(text=combined, \
										correct_answer=answer, \
										question_subject=self.game.question_subject, \
										question_type=2, \
										game_id=self.game.game_id, \
										game_title=self.game.game_title, \
										game_location=self.game.game_location, \
										game_date=self.game.game_date)
				questions.append(question)
		return questions
	
	def get_in_terms_sentence(self, current_point_type):
		all_variable_names = [point_type.variable_name for point_type in self.valid_point_types]
		remaining_variable_names = [variable_name for variable_name in all_variable_names if variable_name != current_point_type.variable_name]

		if len(remaining_variable_names) == 1:
			remaining_variable_names_string = remaining_variable_names[0]
		else:
			remaining_variable_names_string = " and ".join(remaining_variable_names)

		return "Express {answer_variable_name} in terms of {remaining_variable_names_string}.".format(answer_variable_name=current_point_type.variable_name, \
																	  								remaining_variable_names_string=remaining_variable_names_string)
	def solve_for_variable(self, variable_name):
		if variable_name not in [point_type.variable_name for point_type in self.valid_point_types]:
			print "Couldn't find original variable name. Returning None"
			return None
		
		other_point_types = [point_type for point_type in self.valid_point_types if point_type.variable_name != variable_name]
		formula_list = ["-{formula}".format(formula=point_type.total_points_formula()) for point_type in other_point_types]
		rest = "".join(formula_list)

		target_point_type = [point_type for point_type in self.valid_point_types if point_type.variable_name == variable_name][0]
		if target_point_type.multiplier > 1:
			return "({total}{rest})/{multiplier}".format(total=self.total, \
														 rest=rest, \
														 multiplier=target_point_type.multiplier)
		else:
			return "{total}{rest}".format(total=self.total, \
										  rest=rest)