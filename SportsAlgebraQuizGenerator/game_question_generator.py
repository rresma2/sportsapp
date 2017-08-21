from collections import Counter
from collections import defaultdict
from question import Question, GameQuestion
from basketball_game import BasketBallGameInfo
from basketball_formula import PlayerStatsFormula
from remote_loader import RemoteLoader
import json
import random
import sys

"""
Variants

1. Quarter (1, 2, 3, 4)
2. Player (All players who scored > 1 point in > 1 quarter)
4. Team (home, away)

3. Point Type (Total, Three-Pointer, Field-Goal, Free-Throw)

Total # of questions:

4 * 4 * p where p is the total # of players who satisfy the condition above
"""

class QuestionTemplate:
	total_baskets_question = "How many total baskets were made"
	total_points_question = "How many total points were made"

	total_baskets_format = "{total} total baskets were made"
	total_points_format = "{total} total points were made"
	teams_total_baskets_format = "{total} baskets were made in total by both teams"
	teams_total_points_format = "{total} points were made in total by both teams"

	point_type_format = "{point_type_count} were {point_type}"
	point_type_question_format = "How many {point_type} were there total?"
	player_question_format = "How many {descriptor} did {subject} make?"

	player_score_format = "{player} made {ct} total {descriptor}"




class FirstQuizGenerator():
	def generate_questions(self):
		return [Question(self.question1()),
				Question(self.question2()),
				Question(self.question3()),
				Question(self.question4())]

	def question1(self):
		return {
			'text': "How many team sports do you play?",
			'answers': [
				{ "text": "1" },
				{ "text": "2" },
				{ "text": "3" },
				{ "text": "4" },
				{ "text": "5 or more" }
			],
			"questionType": 1,
			"isRequired": True,
			"questionSubject": 3
		}

	def question2(self):
		return {
			'text': "What's your favorite team sport?",
			'answers': [
				{ "text": "Basketball", "label": "a" },
				{ "text": "Soccer", "label": "b" },
				{ "text": "Baseball", "label": "c" },
				{ "text": "Football", "label": "d" },
				{ "text": "Hockey", "label": "e" }
			],
			"questionType": 1,
			"isRequired": True,
			"questionSubject": 3
		}

	def question3(self):
		return {
			'text': "What's your favorite team?",
			'questionType': 2,
			'isRequired': True,
			"questionSubject": 3
		}

	def question4(self):
		return {
			'text': "Who's your favorite team player?",
			'questionType': 2,
			'isRequired': True,
			"questionSubject": 3
		}

class GameQuestionGenerator():
	def __init__(self, game, game_id):
		"""
		Params: game
		Description: Initializes the quiz generator based on a passed in dictionary.
		game -> 

		"game": {
	        "date": "2016-10-25", 
	        "awayTeam": {
	            "Abbreviation": "NYK", 
	            "City": "New York", 
	            "ID": "83", 
	            "Name": "Knicks"
	        }, 
	        "homeTeam": {
	            "Abbreviation": "CLE", 
	            "City": "Cleveland", 
	            "ID": "86", 
	            "Name": "Cavaliers"
	        }, 
	        "location": "Quicken Loans Arena", 
	        "time": "7:30PM"
	    }, 

		"""
		self.game = game
		self.game_id = game_id
		self.game_title = "{home_team} vs. {away_team}".format(home_team=game["game"]["homeTeam"]["Name"], away_team=game["game"]["awayTeam"]["Name"])
		self.game_location = game["game"]["location"]
		self.game_date = game["game"]["date"]
		self.quarters = self.game["quarterSummary"]["quarter"]
		self.point_types = ["FreeThrow", "FieldGoal", "ThreePointer"]
		self.home_player_dict, self.home_players = self.get_all_home_players()
		self.away_player_dict, self.away_players = self.get_all_away_players()
		self.all_players = self.home_players.union(self.away_players)
		self.home_team = self.get_home_team()
		self.away_team = self.get_away_team()
		self.point_breakdown = self.get_point_breakdown()
		self.total_baskets = self.get_total_baskets()
		
		self.total_home_score = self.get_home_score()
		self.total_away_score = self.get_away_score()
		self.home_scores_by_quarter = self.get_home_scores_by_quarter()
		self.away_scores_by_quarter = self.get_away_scores_by_quarter()
		self.total_points = self.total_home_score + self.total_away_score
		self.question_subject = 1 # 1 means game related question

		self.create_point_distribution()
		
	def get_total_baskets(self):
		ct = 0
		for quarter_totals in self.point_breakdown:
			for entry in quarter_totals:
				ct += 1
		return ct

	def create_point_distribution(self):
		self.team_basket_counter = Counter()
		self.team_counter = Counter()
		self.quarter_counter = Counter()
		self.quarter_baskets_counter = Counter()
		self.player_baskets_counter = Counter()
		self.player_counter = Counter()
		self.point_type_counter = Counter()
		self.point_counter = Counter()
		
		self.total_baskets_sentence = QuestionTemplate.teams_total_baskets_format.format(total=self.total_baskets) # {} baskets were made in total by both teams
		self.total_points_sentence = QuestionTemplate.teams_total_points_format.format(total=self.total_points) # {} points were made in total by both teams

		for i in range(len(self.point_breakdown)):
			for entry in self.point_breakdown[i]:
				team_baskets_key = self.get_user_friendly_team_point_string(team=entry["team"], descriptor="baskets")
				team_points_key = self.get_user_friendly_team_point_string(team=entry["team"], descriptor="points")
				quarter_key = self.get_user_friendly_quarter_string(quarter=i)
				player_key = self.get_user_friendly_player_string(player=entry["player"])
				point_type_key = self.get_user_friendly_point_type(point_type=entry["point_type"])

				self.team_basket_counter[team_baskets_key] += 1
				self.team_counter[team_points_key] += entry["points"]
				self.quarter_baskets_counter[quarter_key] += 1
				self.quarter_counter[quarter_key] += entry["points"]
				self.player_baskets_counter[player_key] += 1
				self.player_counter[player_key] += entry["points"]
				self.point_type_counter[point_type_key] += 1

		for key in self.point_type_counter:
			if key == "FreeThrow":
				self.point_counter[key] = self.point_type_counter[key]
			elif key == "FieldGoal":
				self.point_counter[key] = 2 * self.point_type_counter[key]
			elif key == "ThreePointer":
				self.point_counter[key] = 3 * self.point_type_counter[key]

		self.combined_team_dict = defaultdict(dict)
		for key in self.team_counter:
			self.combined_team_dict[key] = {
				"baskets": self.team_basket_counter[key],
				"points": self.team_counter[key]
			}

		self.combined_quarters_dict = defaultdict(dict)
		for key in self.quarter_counter:
			self.combined_quarters_dict[key] = {
				"baskets": self.quarter_baskets_counter[key],
				"points": self.quarter_counter[key]
			}

		self.combined_player_dict = defaultdict(dict)
		for key in self.player_counter:
			self.combined_player_dict[key] = {
				"baskets": self.player_baskets_counter[key],
				"points": self.player_counter[key]
			}

		self.combined_point_type_dict = defaultdict(dict)
		for key in self.point_counter:
			self.combined_point_type_dict[key] = {
				"baskets": self.point_type_counter[key],
				"points": self.point_counter[key]
			}

		self.team_basket_variants = zip(self.team_basket_counter, self.team_basket_counter.values())
		self.team_variants = zip(self.team_counter, self.team_counter.values())

		self.quarter_basket_variants = zip(self.quarter_baskets_counter, self.quarter_baskets_counter.values())
		self.quarter_variants = zip(self.quarter_counter, self.quarter_counter.values())
		
		self.player_basket_variants = zip(self.player_baskets_counter, self.player_baskets_counter.values())
		self.player_variants = zip(self.player_counter, self.player_counter.values())

		self.point_type_variants = zip(self.point_type_counter, self.point_type_counter.values())
		self.point_variants = zip(self.point_counter, self.point_counter.values())


	def generate_questions(self):
		questions = []
		
		questions += self.point_type_only_variants()
		questions += self.team_only_variants()
		questions += self.quarter_only_variants()
		questions += self.player_only_variants()
						
		return questions
	
	# 106 total baskets were made. 55 were field goals. 22 were three pointers. How many free throws were there total?
	def point_type_only_variants(self):
		questions = []

		for tup in [(self.point_type_variants, self.total_baskets_sentence, QuestionTemplate.point_type_question_format), (self.point_variants, self.total_points_sentence, QuestionTemplate.point_type_question_format)]:
			variants, total_sentence, question_prompt = tup
			for i in range(len(variants)):
				answer_point_type, answer = variants[i]
				information_in_question = [variants[j] for j in range(len(variants)) if j != i]
				
				templates = []
				for info in information_in_question:
					templates.append(QuestionTemplate.point_type_format.format(point_type_count=info[1], point_type=info[0]))

				question_info_sentence = ". ".join(templates)
				questions.append(self.create_game_question(total_sentence=total_sentence, \
															problem_information_sentence=question_info_sentence, \
															question_prompt=question_prompt.format(point_type=answer_point_type), \
															correct_answer=answer))
		return questions

	# 106 total baskets were made. 47 were Away Team Baskets. How many Home Team Baskets were there total?
	def team_only_variants(self):
		questions = []
		
		for tup in [(self.team_basket_variants, self.total_baskets_sentence, "baskets", QuestionTemplate.point_type_question_format), (self.team_variants, self.total_points_sentence, "points", QuestionTemplate.point_type_question_format)]:
			variants, total_sentence, descriptor, question_prompt = tup
			for i in range(len(variants)):
				answer_team, answer = variants[i]
				information_in_question = [variants[j] for j in range(len(variants)) if j != i]

				templates = []
				for info in information_in_question:
					templates.append(QuestionTemplate.point_type_format.format(point_type_count=info[1], point_type=info[0]))
					
				question_info_sentence = ". ".join(templates)
				questions.append(self.create_game_question(total_sentence=total_sentence, \
															problem_information_sentence=question_info_sentence, \
															question_prompt=question_prompt.format(point_type=answer_team), \
															correct_answer=answer))
		return questions

	# 106 total baskets were made. 23 baskets were in quarter 1. 26 baskets were in quarter 2. 32 baskets were in quarter 3. How many baskets in quarter 0 were there total?
	def quarter_only_variants(self):
		questions = []
		for tup in [(self.quarter_basket_variants, self.total_baskets_sentence, "baskets", QuestionTemplate.point_type_question_format), (self.quarter_variants, self.total_points_sentence, "points", QuestionTemplate.point_type_question_format)]:
			variants, total_sentence, descriptor, question_prompt = tup
			for i in range(len(variants)):
				answer_quarter, answer = variants[i]
				information_in_question = [variants[j] for j in range(len(variants)) if j != i]
				templates = []
				for info in information_in_question:
					point_type_count = "{count} {descriptor}".format(count=info[1], descriptor=descriptor)
					templates.append(QuestionTemplate.point_type_format.format(point_type_count=point_type_count, point_type=info[0]))

				question_info_sentence = ". ".join(templates)
				questions.append(self.create_game_question(total_sentence=total_sentence, \
															problem_information_sentence=question_info_sentence, \
															question_prompt=question_prompt.format(point_type="{descriptor} {quarter}".format(descriptor=descriptor, \
																																			  quarter=answer_quarter)),
															correct_answer=answer))
		return questions

	# This variant is between player and the sum of the scores of the other players
	# total_baskets_format = "{total} total baskets were made"
	# player_question_format = "How many {point_type} did {subject} make?"
	# total_player_baskets_format = "{player} made {ct} total baskets"
	def player_only_variants(self):
		questions = []
		for tup in [(self.player_basket_variants, self.total_baskets_sentence, "baskets", QuestionTemplate.player_question_format), (self.player_variants, self.total_points_sentence, "points", QuestionTemplate.player_question_format)]:
			variants, total_sentence, descriptor, question_prompt = tup
			for i in range(len(variants)):
				player, ct = variants[i]
				information_in_question = [variants[j] for j in range(len(variants)) if j != i]
				correct_answer = sum([tup[1] for tup in information_in_question])

				# 100 baskets were made in total by both teams. Kobe Bryant made {} total baskets. How many points did the rest of the players make??
				player_sentence = QuestionTemplate.player_score_format.format(player=player, \
																			  ct=ct, \
																			  descriptor=descriptor)
				questions.append(self.create_game_question(total_sentence=total_sentence, \
														   problem_information_sentence=player_sentence, \
														   question_prompt=question_prompt.format(descriptor=descriptor, \
																								  subject="the rest of the team"), \
														   correct_answer=correct_answer))
		return questions

	def create_game_question(self, total_sentence, problem_information_sentence, question_prompt, correct_answer):
		combined = "{}. {}. {}".format(total_sentence, problem_information_sentence, question_prompt)
		# print combined, "({answer})".format(answer=correct_answer)
		return GameQuestion(text=combined, \
							correct_answer=correct_answer, \
							question_subject=self.question_subject, \
							question_type=3, \
							game_id=self.game_id, \
							game_title=self.game_title, \
							game_location=self.game_location, \
							game_date=self.game_date)
		
	
	# if quarter is None, use all quarters
	# if player is not None, make sure to check if the entry["player"] == player
	# if team is not None, make sure to check if the entry["team"] == team

	def aggregate_player_stats(self):
		player_dict = defaultdict(Counter)
		for quarter_totals in self.point_breakdown:
			for entry in quarter_totals:
				player_dict[self.get_user_friendly_player_string(entry["player"])][entry["point_type"]] += 1

		filtered_player_dict = defaultdict(Counter)
		for player in player_dict:
			keys = player_dict[player].keys()
			if len(keys) > 1:
				filtered_player_dict[player] = player_dict[player]
		player_dict = filtered_player_dict
		
		# sum_dict = defaultdict(dict)
		# for player in player_dict:
		# 	s = 0
		# 	s += player_dict[player]["FieldGoal"]
		# 	s += player_dict[player]["FreeThrow"]
		# 	s += player_dict[player]["ThreePointer"]
		# 	sum_dict[player]["Total"] = s
		# for player in sum_dict:
		# 	player_dict[player]["Total"] = sum_dict[player]["Total"]
		return player_dict
	
	def aggregate_scores(self, player, quarter, team, point_type, sums_total_score):
		indices = [quarter] or [i for i in range(len(self.point_breakdown))]
		ct = 0
		for index in indices:
			quarter_totals = self.point_breakdown[index]
			for entry in quarter_totals:
				if player is not None and entry["player"] != player:
					continue
				if team is not None and entry["team"] != team:
					continue

				if entry["point_type"] == point_type:
					ct += 1 if not sums_total_score else entry["points"]
		return ct

	def quarter_template_string(self, quarter):
		if quarter == 0:
			return "Q1"
		elif quarter == 1:
			return "Q2"
		elif quarter == 2:
			return "Q3"
		elif quarter == 3:
			return "Q4"
		return None

	def point_type_template_string(self, point_type, points):
		if point_type == "FreeThrow":
			return "Free Throws" if points != 1 else "Free Throw"

	def get_all_home_players(self):
		home_players = {}
		for entry in self.game["homeTeam"]["homePlayers"]["playerEntry"]:
			home_players[entry["player"]["LastName"]] = entry
		return home_players, set(home_players.keys())

	def get_all_away_players(self):
		away_players = {}
		for entry in self.game["awayTeam"]["awayPlayers"]["playerEntry"]:
			away_players[entry["player"]["LastName"]] = entry
		return away_players, set(away_players.keys())

	def get_home_team(self):
		return self.game["game"]["homeTeam"]["Abbreviation"]

	def get_away_team(self):
		return self.game["game"]["awayTeam"]["Abbreviation"]

	def get_home_score(self):
		return int(self.game["quarterSummary"]["quarterTotals"]["homeScore"])

	def get_away_score(self):
		return int(self.game["quarterSummary"]["quarterTotals"]["awayScore"])

	def get_home_scores_by_quarter(self):
		return [quarter["homeScore"] for quarter in self.quarters]

	def get_away_scores_by_quarter(self):
		return [quarter["awayScore"] for quarter in self.quarters]

	def get_point_breakdown(self):
		quarter_list = [] # qurters
		player_map = {}
		for i, quarter in enumerate(self.quarters):
			quarter_totals = []
			for play_dict in self.get_play_from_quarter(quarter):
				play = play_dict["playDescription"]
				
				entry = {}
				player = self.get_player_from_play(play)
				entry["quarter"] = i
				entry["player"] = player
				entry["team"] = self.get_team_from_play_dict(play_dict)
				cumulative_player_points = self.get_points_from_play(play)
				# print player, cumulative_player_points

				if player in player_map:
					last_player_points = player_map[player]
					entry["point_type"] = self.get_point_type_from_score(cumulative_player_points - last_player_points)
					entry["points"] = cumulative_player_points - last_player_points
					player_map[player] = cumulative_player_points
				else:
					player_map[player] = cumulative_player_points
					entry["point_type"] = self.get_point_type_from_score(cumulative_player_points)
					entry["points"] = cumulative_player_points
				quarter_totals.append(entry)
			quarter_list.append(quarter_totals)
		return quarter_list
				
	def get_team_from_play_dict(self, play_dict):
		if play_dict["teamAbbreviation"] == self.away_team:
			return "away"
		elif play_dict["teamAbbreviation"] == self.home_team:
			return "home"
		return None

	def get_player_from_play(self, play):
		tokens = play.split(" ")
		for token in tokens:
			if token in self.all_players:
				return token
		return None

	def get_points_from_play(self, play):
		pointString = play[play.find("(")+1:play.find(")")]
		return int(pointString.split(" ")[0])

	def get_point_type_from_score(self, score):
		if score == 1:
			return "FreeThrow"
		elif score == 2:
			return "FieldGoal"
		elif score == 3:
			return "ThreePointer"
		return None

	def get_user_friendly_point_type(self, point_type, is_plural=True):
		if point_type == "FreeThrow":
			return "free throws" if is_plural else "free throw"
		elif point_type == "FieldGoal":
			return "field goals" if is_plural else "field goal"
		elif point_type == "ThreePointer":
			return "three pointers" if is_plural else "three pointer"

	def get_user_friendly_team_point_string(self, team, descriptor):
		if team == "away":
			return "Away Team {descriptor}".format(descriptor=descriptor)
		elif team == "home":
			return "Home Team {descriptor}".format(descriptor=descriptor)

	def get_user_friendly_quarter_string(self, quarter):
		return "in quarter {quarter}".format(quarter=quarter + 1)

	def get_user_friendly_player_string(self, player):
		if player in self.home_player_dict:
			entry = self.home_player_dict[player]
			return "{first} {last}".format(first=entry["player"]["FirstName"], last=entry["player"]["LastName"])
		elif player in self.away_player_dict:
			entry = self.away_player_dict[player]
			return "{first} {last}".format(first=entry["player"]["FirstName"], last=entry["player"]["LastName"])
		return None

	def get_play_from_quarter(self, quarter):
		return quarter["scoring"]["scoringPlay"]

	def validate(self):
		home_total = 0
		away_total = 0
		for quarter_totals in self.point_breakdown:
			for entry in quarter_totals:
				if entry["team"] == "away":
					away_total += entry["points"]
				elif entry["team"] == "home":
					home_total += entry["points"]
				else:
					print "found an unsupported team type"
					return False
		if home_total != self.total_home_score:
			# print home_total, self.total_home_score
			# print "Inconsistent home points"
			return False
		if away_total != self.total_away_score:
			# print "Inconsistent away points"
			# print away_total, self.total_away_score
			return False
		return True

with open('sample_game.json') as data_file:
	game = json.load(data_file)
	generator = GameQuestionGenerator(game=game, game_id="20161025-NYK-CLE")
	questions = generator.generate_questions()
	game = BasketBallGameInfo(generator=generator)	
	player_stats = generator.aggregate_player_stats()

	basketball_formula_questions = []
	for player in player_stats:
		three_pointers = player_stats[player]["ThreePointer"]
		field_goals = player_stats[player]["FieldGoal"]
		free_throws = player_stats[player]["FreeThrow"]

		formula = PlayerStatsFormula(game=game, \
									 three_pointers=three_pointers, \
									 field_goals=field_goals, \
									 free_throws=free_throws, \
									 player=player)

		# print formula.get_variable_definition_string()
		# print formula.get_formula_string()
		# print formula.get_in_terms_sentence(formula.point_types[0])
		basketball_formula_questions += formula.create_questions()
	# first_quiz_generator = FirstQuizGenerator()
	# first_quiz_questions = first_quiz_generator.generate_questions()
	# print generator.point_breakdown
	if generator.validate():
		questions += basketball_formula_questions
		
		for i in range(random.choice([i for i in range(10)])):
			random.shuffle(questions)

		print "Success!" 
		print "Uploading {ct} questions".format(ct=len(questions))
		loader = RemoteLoader()
		for question in questions:
			loader.create_object(class_name="Question", params=question.dictionary())
			
	else:
		print "Failed..."