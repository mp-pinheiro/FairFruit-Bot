import asyncio
import json
import logging
import random
import time

from twitchkeywords import Keyword

from communicator import Communicator


def load_json(filename):
    """Reads json file into dictionary"""
    with open(filename, 'r') as f:
        data = json.load(f)

    return data


def write_json(filename):
    # default configs for N64 and typical delay
    data = {
        "controls": {
            "up": "A Up",
            "down": "A Down",
            "left": "A Left",
            "right": "A Right",
            "a": "A",
            "b": "B",
            "z": "Z"
        },
        "options": {
            "delay": 0.1,
            "max": 1000
        }
    }

    with open(filename, 'w') as f:
        f.write(json.dumps(data))

    return data


class Bot(Keyword):
    filename = 'config.json'
    try:
        cfg = load_json(filename)
    except FileNotFoundError:
        cfg = write_json(filename)

    communicator = None

    def __init__(self, gamemode):
        super().__init__()
        self._gamemode = gamemode
        Bot.communicator = []
        Bot.communicator.append(Communicator())
        if gamemode == "double":
            Bot.communicator.append(Communicator(doubleSetup=True))
        self._set_command_handler()

    def _get_comm_index_by_name(self, name):
        letter = name[0].lower()
        return 1 if letter >= "m" else 0

    def _set_command_handler(self):
        async def handler_function(message):
            """Handles keystroke commands from twitch chat."""
            # Skip prefix character
            content = message.content[1:]
            author = message.author.name
            args = content.split()

            controls = Bot.cfg['controls']
            options = Bot.cfg['options']
            delay = float(options['delay'])

            index = 0
            if self._gamemode == "double":
                index = self._get_comm_index_by_name(author)
            communicator = Bot.communicator[index]

            word = args[0]
            if word in controls:
                key = author + ":" + controls[word] + ";"
                communicator.send_data(key)

                # Wait delay amount of seconds
                await asyncio.sleep(delay)

        self.prefix_keywords = {"!": handler_function}

    async def event_ready(self):
        logging.info('Twitch bot is ready. Reading commands from chat...')

    def run_test(self):
        names = [
            "James", "John", "Robert", "Michael", "William", "David",
            "Richard", "Joseph", "Thomas", "Charles", "Christopher", "Daniel",
            "Matthew", "Anthony", "Donald", "Mark", "Paul", "Steven", "Andrew",
            "Kenneth", "Joshua", "Kevin", "Brian", "George", "Edward",
            "Ronald", "Timothy", "Jason", "Jeffrey", "Ryan", "Jacob", "Gary",
            "Nicholas", "Eric", "Jonathan", "Stephen", "Larry", "Justin",
            "Scott", "Brandon", "Benjamin", "Samuel", "Frank", "Gregory",
            "Raymond", "Alexander", "Patrick", "Jack", "Dennis", "Jerry",
            "Tyler", "Aaron", "Jose", "Henry", "Adam", "Douglas", "Nathan",
            "Peter", "Zachary", "Kyle", "Walter", "Harold", "Jeremy", "Ethan",
            "Carl", "Keith", "Roger", "Gerald", "Christian", "Terry", "Sean",
            "Arthur", "Austin", "Noah", "Lawrence", "Jesse", "Joe", "Bryan",
            "Billy", "Jordan", "Albert", "Dylan", "Bruce", "Willie", "Gabriel",
            "Alan", "Juan", "Logan", "Wayne", "Ralph", "Roy", "Eugene",
            "Randy", "Vincent", "Russell", "Louis", "Philip", "Bobby",
            "Johnny", "Bradley"
        ]

        options = Bot.cfg['options']
        delay = float(options['delay'])
        controls = {
            "{name}:A Up;": 80,
            "{name}:A Down;": 20,
            "{name}:A Left;": 40,
            "{name}:A Right;": 40,
            "{name}:A;": 20,
            "{name}:B;": 5,
            "{name}:Z;": 2
        }
        inputList = []
        for key, value in controls.items():
            inputList += value * [key]

        while True:
            name = random.choice(names)
            key = random.choice(inputList).format(name=name)
            command = key.format(name=name)

            if self._gamemode == "double":
                index = self._get_comm_index_by_name(name)
            else:
                index = 0
            communicator = Bot.communicator[index]

            communicator.send_data(key)
            logging.info(f"(test)-{command}")

            # Wait delay amount of seconds
            time.sleep(delay * random.uniform(0.01, 0.1))
