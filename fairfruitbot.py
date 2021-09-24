import argparse
import asyncio
import logging
import os
import subprocess
import sys

from dotenv import load_dotenv

from bot import Bot


def setup_logger():
    logging.getLogger('twitchio.websocket').disabled = 1
    logging.basicConfig(stream=sys.stdout, level=logging.INFO)


# check for required environment variables
def check_env_file():
    load_dotenv()

    env_vars = [
        "HOST",
        "PORT",
        "TWITCH_OAUTH_PASS",
        "TWITCH_CLIENT_ID",
        "TWITCH_CHANNEL",
    ]
    for var in env_vars:
        if var not in os.environ:
            logging.info(
                f"Missing required environment variable '{var}'. Please add it to the '.env' file."  # noqa
            )
            sys.exit(1)


# prod mode
def run_production(bot):
    try:
        bot.run()
    except asyncio.TimeoutError:
        # TODO: maybe actually handle these? they're twitch.io weird errors
        pass


# test mode
def run_test(bot):
    bot.run_test()


# configs
modes = {"production": run_production, "test": run_test}
if __name__ == "__main__":
    # initial setup
    setup_logger()

    # parser settings
    parser = argparse.ArgumentParser(
        description='Fairfruit-bot: stream commands from Twitch Chat.')
    parser.add_argument(
        '--mode',
        default='production',
        help='run the bot in <prodution> or <test> mode. Production streams \
            commands from chat, Test mode streams random commands for \
            testing purposes')
    parser.add_argument(
        '--gamemode',
        default='single',
        help='run the bot in <single> or <double> game mode. Single will \
            stream commands to one single emulator, whilst Double is a \
            "versus" mode. It will split commands by chatter name and \
            stream to two emulators. The port for the second emulator \
            will be the one specified in the PORT environment variable \
            plus 1000.')

    args = parser.parse_args()
    params = vars(args)

    # check required parameters
    check_env_file()

    # get mode
    mode = params["mode"]
    runner = modes[mode]
    gamemode = params["gamemode"]
    logging.info(
        f"Running fairfruit-bot in {mode} mode. Gamemode is {gamemode}.")

    # prepare bot
    bot = Bot(gamemode)

    # launch bizhawk
    ip = os.getenv("HOST")
    ports = [os.getenv("PORT")]
    bizhawk_path = os.getenv("BIZZHAWK_PATH")
    DETACHED_PROCESS = 0x00000008
    if bizhawk_path:
        if gamemode == "double":
            ports.append(int(os.getenv("PORT")) + 1000)

        for port in ports:
            cmd = [bizhawk_path, f"--socket_ip={ip}", f"--socket_port={port}"]
            subprocess.Popen(cmd,
                             shell=False,
                             stdin=None,
                             stdout=None,
                             stderr=None,
                             close_fds=True,
                             creationflags=DETACHED_PROCESS)
    else:
        logging.info(
            "Bizhawk path not found in .env config file. Open it manually.")

    # run
    runner(bot)
