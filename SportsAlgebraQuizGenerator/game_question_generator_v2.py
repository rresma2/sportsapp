from collections import Counter
from collections import defaultdict
from question import Question, GameQuestion
from remote_loader import RemoteLoader
import json
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
		self.create_point_distribution()

		self.total_home_score = self.get_home_score()
		self.total_away_score = self.get_away_score()
		self.home_scores_by_quarter = self.get_home_scores_by_quarter()
		self.away_scores_by_quarter = self.get_away_scores_by_quarter()
		self.total_points = self.total_home_score + self.total_away_score
		self.question_subject = 1 # 1 means game related question
		
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

		for i in range(len(self.point_breakdown)):
			for entry in self.point_breakdown[i]:
				self.team_basket_counter[entry["team"]] += 1
				self.team_counter[entry["team"]] += entry["points"]
				self.quarter_baskets_counter[i] += 1
				self.quarter_counter[i] += entry["points"]
				self.player_baskets_counter[entry["player"]] += 1
				self.player_counter[entry["player"]] += entry["points"]
				self.point_type_counter[entry["point_type"]] += 1
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


	def generate_questions(self):
		questions = []
						
		return questions
	
	def question_for(self, player, quarter, team, point_type):
		
		if not player and not quarter and not team and not point_type: # use total points
			return None # irrelevant since there are no variants
		if not player and not quarter and not team: # only use point type
			return self.point_type_only_variants()
		if not player and not quarter and not point_type: # only use team
			return self.team_only_variants()
		if not player and not team and not point_type: # only use quarter
			return self.quarter_only_variants()
			"""

			{} <- 0, 1, 2, 3

			TODO: 0 1 2 3 _
			TODO: 0 1 2 _ T
			TODO: 0 1 _ 3 T
			TODO: 0 _ 2 3 T
			TODO: _ 1 2 3 T

			5 total questions
			******* Potentially 10, for points vs. ct

			"""

		if not quarter and not team and not point_type: # only use player
			"""

			{} <- players

			TODO: Player RestOfTeam _
			TODO: Player _ T
			TODO: _ RestOfTeam T

			3 total questions
			******* Potentially 6, for points vs. ct

			"""

		if not player and not quarter: # only use team and point type
			
			"""

			{} <- ThreePointer, FieldGoal, FreeThrow

			TODO: {}_home + {}_away = _
			TODO: {}_home + _ = {}_both
			TODO: _ + {}_away = {}_both

			9 total questions
			******* Potentially 18, for points vs. ct

			"""
			

		if not quarter and not team: # only use player and point type
			
			"""

			{} <- ThreePointer, FieldGoal, FreeThrow
			{} <- Player

			TODO: Example: P1 made 2 three pointers, _ field goals, 1 free throw and 10 points

			p * 3 - total questions
			******* Potentially 2 * (p*3), for points vs. ct

			"""

		if not team and not point_type: # only use player and quarter
			
			"""

			{} <- 0, 1, 2, 3
			{} <- Player

			TODO: Example: P1 made 1 total in Q1, 2 total in Q2, 3 total in Q3, How many _ Total?
			TODO: Example: P1 made 1 total in Q1, 2 total in Q2, _ in Q3, How many 10 Total?
			TODO: Example: P1 made 1 total in Q1, _ total in Q2, 3 in Q3, How many 10 Total?
			TODO: Example: P1 made _ total in Q1, 2 total in Q2, 3 in Q3, How many 10 Total?

			p * 4 - total questions
			******* Potentially 2 * (p*4), for points vs. ct

			"""

		if not player and not team: # only use quarter and point type

			"""

			{} <- 0, 1, 2, 3
			{} <- ThreePointer, FieldGoal, FreeThrow
			{} <- Points, Ct

			TODO: Example: 1 ThreePointer in {}, 2 FieldGoal in {}, 3 FreeThrow in {}, How many _ total in {}?
			TODO: Example: _ ThreePointer in {}, 2 FieldGoal in {}, 3 FreeThrow in {}, How many 9 total in {}?
			TODO: Example: 1 ThreePointer in {}, _ FieldGoal in {}, 3 FreeThrow in {}, How many 9 total in {}?
			TODO: Example: 1 ThreePointer in {}, 2 FieldGoal in {}, _ FreeThrow in {}, How many 9 total in {}?

			12 - total questions
			******* Potentially 24, for points vs. ct

			"""

		if not quarter and not point_type: # only use player and team
			return None # irrelevant question since every player is on exactly one team
			
		if not player and not point_type: # only use team and quarter
			"""

			{} <- 0, 1, 2, 3

			TODO: home_q1 + home_q2 + home_q3 + home_q4 = _
			TODO: home_q1 + home_q2 + home_q3 + _ = total
			TODO: home_q1 + home_q2 + _ + home_q4 = total
			TODO: home_q1 + _ + home_q3 + home_q4 = total
			TODO: _ + home_q2 + home_q3 + home_q4 = total

			TODO: away_q1 + away_q2 + away_q3 + away_q4 = _
			TODO: away_q1 + away_q2 + away_q3 + _ = total
			TODO: away_q1 + away_q2 + _ + away_q4 = total
			TODO: away_q1 + _ + away_q3 + away_q4 = total
			TODO: _ + away_q2 + away_q3 + away_q4 = total

			10 total questions
			******* Potentially 20, for points vs. ct

			"""
			

		if not player: # use quarter, team, point_type
			"""

			{} <- 0, 1, 2, 3
			{} <- ThreePointer, FieldGoal, FreeThrow
			{} <- Players()

			TODO: Example: in {quarter}, {player} made 3 ThreePointers, 2 FieldGoals, and 1 FreeThrow, how many Total?
			TODO: Example: In Q1, {player} made 3 ThreePointers, in Q2, {player} made 2 ThreePointers, in Q3... How many total
			TODO: Example: 51 points of three pointers were made among 3 players. If {player1} made 2 three pointers, and {player2} made 4 three pointers, how many points total did {player3} make?

			10 total questions
			******* Potentially 20, for points vs. ct

			"""


		if not quarter: # use player, team, point_type
			return None # irrelevant since player and team aren't mutually exlusive
		if not team: # use player, quarter, point_type
			pass
		if not point_type: # use player, quarter, team
			return None # irrelevant since player and team aren't mutually exlusive

		return # use all of them



	# if quarter is None, use all quarters
	# if player is not None, make sure to check if the entry["player"] == player
	# if team is not None, make sure to check if the entry["team"] == team
	
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

	# first_quiz_generator = FirstQuizGenerator()
	# first_quiz_questions = first_quiz_generator.generate_questions()
	# print generator.point_breakdown
	if generator.validate():
		print "Success!" 
		print "Uploading {ct} questions".format(ct=len(questions))
		loader = RemoteLoader()
		
		# for question in first_quiz_questions:
		# 	loader.create_object(class_name="Question", params=question.dictionary())

		for question in questions:
			loader.create_object(class_name="Question", params=question.dictionary())
			
	else:
		print "Failed..."