class GameQuestion():
	def __init__(self, text, correct_answer, question_subject, game_id, game_title, game_location, game_date):
		self.text = text # Kobe Bryant made {total_points} points in {quarter}. If he made {num_two_pointers} {two_points_type} in {quarter}, {num_free_throws} {free_throw_type} in {quarter}, how many {three_pointer_type} did he make in {Q1}?
		self.is_required = True
		self.time_limit = 120.0
		self.question_type = 3 # numericInput
		self.question_subject = question_subject # 1 or 2 (game or playe)
		self.correct_answers = [str(correct_answer)]
		self.game_id = game_id
		self.game_title = game_title
		self.game_location = game_location
		self.game_date = game_date

	def dictionary(self):
		return {
			"text": self.text,
			"isRequired": self.is_required,
			"timeLimit": self.time_limit,
			"questionType": self.question_type,
			"questionSubject": self.question_subject,
			"correctAnswers": self.correct_answers,
			"gameId": self.game_id,
			"gameTitle": self.game_title,
			"gameLocation": self.game_location,
			"gameDate": self.game_date,
		}
class Question():
	def __init__(self, d):
		self.d = d
	
	def dictionary(self):
		return self.d