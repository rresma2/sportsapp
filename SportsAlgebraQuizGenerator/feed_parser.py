from ohmysportsfeedspy import MySportsFeeds
import simplejson
import json

'''

Seasons
====================

Example: 

> season='2016-2017-regular'

Format:

> (season start year) + '-' + 
> (season end year) + '-' + 
> either 'regular' or 'playoff', depending on the season's type


Games
====================

Example:

> game_identifier='20161025-SAS-GSW'

Format:

> (game date as YYYYMMDD) + '-' + 
> (away team abbreviation) + '-' + 
> (home team abbreviation) 

'''

class NBAFeedParser():
	def __init__(self):
		self.feed = MySportsFeeds(version='1.0')
		self.feed.authenticate('rresma2', 'sportsapp')
		self.season = '2016-2017-regular'
		self.league = 'nba'
		self.format = 'json'

	# https://api.mysportsfeeds.com/v1.1/pull/nba/{season-name}/cumulative_player_stats.{format}
	def get_cumulative_player_stats(self):
		output = self.feed.msf_get_data(league=self.league,
										season=self.season,
										feed='cumulative_player_stats',
										format=self.format)
		return output

	# https://api.mysportsfeeds.com/v1.1/pull/nba/{season-name}/game_boxscore.{format}?player={player}
	def get_score_info_for_player(self, player):
		output = self.feed.msf_get_data(league=self.league, \
								  season=self.season, \
								  feed='game_boxscore', \
								  format=self.format, \
								  player=player)
		return output

	# https://api.mysportsfeeds.com/v1.1/pull/nba/{season-name}/game_boxscore.{format}?gameid={game-identifier}
	def get_info_for_game(self, game_id):
		output = self.feed.msf_get_data(league=self.league, \
								  season=self.season, \
								  feed='game_boxscore', \
								  format=self.format, \
								  gameid=game_id)
		return output["gameboxscore"]

	# 3 * num_three_pointers + 2 * num_non_three_pointers + 1 * num_free_throws = total points
	# 3 * num_three_pointers + 2 * num_non_three_pointers + 1 * num_free_throws = total points
	def generate_algebra_questions_for_game(self, game_id):
		game_info = get_info_for_game(game_id=game_id)
		pass

	# https://api.mysportsfeeds.com/v1.1/pull/nba/{season-name}/full_game_schedule.{format}
	def get_all_games(self):
		output = self.feed.msf_get_data(league=self.league, \
										season=self.season,
										feed='full_game_schedule',
										format=self.format)
		return output['fullgameschedule']['gameentry']

	def get_game_id_from_game(self, game):
		date = game['date'].replace('-', '')
		away = game['awayTeam']['Abbreviation']
		home = game['homeTeam']['Abbreviation']
		return '{date}-{away}-{home}'.format(date=date, away=away, home=home)
	
	def get_game_ids(self):
		game_ids = [self.get_game_id_from_game(game=game) for game in self.get_all_games()]
		fw = open("game_ids.csv", "w")
		for game_id in game_ids:
			fw.write("{game_id}\n".format(game_id=game_id))
		fw.close()
		return game_ids

	def save_game(self):
		fr = open("game_ids.csv")
		game_ids = [game_id.strip() for game_id in fr]

		fw = open("sample_game.json", "w")
		game = self.get_info_for_game(game_id=game_ids[0])
		fw.write(json.dumps(game, indent=4))
		fw.close()
		

parser = NBAFeedParser()
