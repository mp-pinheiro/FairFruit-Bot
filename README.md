# FairFruit-Bot

A Twitch Plays bot that sends Twitch Chat inputs into the BizHawk Emulator.

# License

This is a modified version of [tprei's Twitch Keyboard project](https://github.com/tprei/Twitch-Keyboard), and is thus licensed under the same MIT License.

# Big Disclaimer

This is a for fun project made with passion. However, it cannot be called plug and play. Using it will required a little tweaking, and at least minor understanding of Windows and the Windows Command Prompt. Feel free to open issues and ask questions, I will do my best to answer them.

# Installation

FairFruit-Bot is currently only supported on Windows. Before installing and configuring, to use FairFruit-Bot you need a Windows:

1. Download the latest release from the [releases page](https://github.com/mp-pinheiro/fairfruit-bot/releases). Extract the contents of the zip file to an easy to access folder;
1. Download the [BizHawk Emulator](https://github.com/TASVideos/BizHawk/releases). **Important: the bot was last tested with version 2.5.2, which means it'll be most likely to work in that same version**;
1. Rip your favorite game into a rom. You can check the list of BizzHawk supported systems [here](https://bizhawk.en.uptodown.com/windows#:~:text=Currently%2C%20BizHawk%20supports%20the%20following,%2C%20Neo%20Geo%20Pocket%2C%20WonderSwan%2C). Note that the bot was only tested with N64 and GameBoy, and might work / need tweaking for other systems.

## Authenticating

In order to pull messages from Twitch Chat, you'll need to create your own Twitch Bot. Follow these steps:

1. Go to https://twitchapps.com/tmi/ and get your **OAuth Password**. This is linked to your logged in account, so if you're planing on using bot-like features (such as sending messages in chat), you'd probably wanna do this within a bot account.

1. Go to the Twitch Developer Portal and register an **Application** to get your **Client ID** like so:

    ![registration](https://i.imgur.com/Wjdl0aD.png)

1. Create a `.env` file in the project's directory which looks like this:

    ```bash
    # don't mess with these unless you know what you're doing
    HOST=127.0.0.1
    PORT=9999
    
    # fill in with your own Twitch credentials and channel
    TWITCH_OAUTH_PASS=<OAUTH KEY GENERATED IN LAST STEP>
    TWITCH_CLIENT_ID=<CLIENT ID GENERATED IN LAST STEP>
    TWITCH_CHANNEL=<NAME OF THE TWITCH CHANNEL>
    
    # fill in with the path where you installed the BizHawk emulator
    BIZZHAWK_PATH="D:/Emulators/BizHawk-2.3/EmuHawk.exe"
    ```

And replace each value with your credentials. 

**IMPORTANT**: This is all sensitive information, do not share your OAuth Password, Client ID and/or `.env` file.

## Configuring the bot

To configure your commands, simply edit the config.json file, which looks like this:

```json
{
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
```

> ⚠️ Important: these are basic configs that will work on N64. To work with different systems, you will need to map commands accordingly. You can check command tables on [BizHawk's Website](http://tasvideos.org/Bizhawk/LuaFunctions/JoypadTableKeyNames.html).

Users will then send command through chat using the `!` prefix, which will then trigger the mapped commands. For example, with the basic configs above, if an user sends `!up` message, an `A Up` command will be triggered on BizHawk, which will then press the Analog stick up.

Under options, you can determine the delay between keystrokes and the maximum amount of times a keystroke can be pressed.

## Configuring BizzHawk

Before running the bot, you'll need to configure BizzHawk to receive the inputs from chat and run them in the system and game of your choise.

Navigate to the folder where you extracted the bot files downloaded in the previous steps. Look for a folder called `Lua`. Inside of it, you'll find a file named `config.lua`. Open it using a text editor of prefference. Most of the configs will work as is, you only need to focus on the commands part, which looks like this:

```lua
-- key maps (map accordingly to `config.json`)
config.keys = {
    ["Up"] = {
        inputTime = config.analogTime,
        threshold = config.analogThreshold
    },
    ["Down"] = {
        inputTime = config.analogTime,
        threshold = config.analogThreshold
    },
    ["Left"] = {
        inputTime = config.analogTime,
        threshold = config.analogThreshold
    },
    ["Right"] = {
        inputTime = config.analogTime,
        threshold = config.analogThreshold
    },
    ["A"] = {
        inputTime = config.keyTime,
        threshold = config.keyThreshold
    },
    ["B"] = {
        inputTime = config.keyTime,
        threshold = config.keyThreshold
    },
    ["Z"] = {
        inputTime = config.keyTime,
        threshold = config.keyThreshold
    }
}
```

Make sure the letters inside `[]` match the letters in the `config.json` files previously. Directional and analog keys have different configs compared to buttons, just copy and paste using the template as an example. If you're doing an N64 game, you don't need to change anything.

## Running the bot

To run the bot, open a Command Prompt window and navigate to the foler where you extracted, then run it:

```batch
fairfruitbot.exe --gamemode single
```

> ⚠️ Important: this will run the bot in "single" mode, which will open a single BizHawk window which Twitch Chat will play on. You can check other game modes and options by using the `help` command.

If everything was configured correctly, a BizHawk window should pop up and you should see something along these lines in your command prompt window:

```
INFO:root:Running fairfruit-bot in production mode. Gamemode is single.
INFO:root:Launching BizHawk Emulator using connection settings:                 127.0.0.1:9999.
INFO:root:Successfully connected to Bizzhawk. Listening for commands...
INFO:root:Twitch bot is ready. Reading commands from chat...
```

Finally, it's time to run the game and start the Twitch Plays experience. Navigate to `File -> Open ROM` and select your ROM of choice.

When the game starts running, navigate to `Tools -> Lua Console`. A window like this one will open:

![Lua Console](https://i.imgur.com/9GZ4PLf.png)

Inside the newly open window, click on `Script -> Open Script` then navigate to the folder where you extracted the bot files, and find the `Lua` folder. Inside of it, select the `N64.lua` file and hit `Open`.

The N64 script should appear under the list with a green play icon indicating it to be running. You should also see an IP address printed to the Output console.

![N64 Script](https://i.imgur.com/N9lNS42.png)

Finally, to start receiving messages, type in the command `start()` on the text box below the Output box on the right side and hit `Enter`. A message saying `Listening for inputs...` will pop up.

And that's it! Sending a command in Twitch Chat will now trigger a command in game. If you used the default N64 config, you can type in `!a` in Twitch Chat, an A key press will happen in game.

To stop listening to commands, use the command `stop()`. There's also a `count(x)` which will count down and choose a random chatter that recently sent commands, you can use that for giveaways. Just replace the `x` with the number of seconds you want to count down from. To clear the chatter name from the screen, do `clear()`.

## Troubleshooting

The bot is far from perfect, and you might run into some problems using it. Here's a list of common mistakes:

### BizHawk not opening when running the script

Check if the path to the emulator exe file is correct inside of your `.env` file.

### Messages not going through

1. Did you remember to run the `start()` command? Try running it
1. Was there an error on your command prompt? This is very likely an `.env` file problem. Check the error, it might have information on what went wrong, you might be missing some important variables like the `CLIENT_ID`.
1. Is the `N64.lua` script running? Check your Lua Console for the green play icon mentioned above. Sometimes the script can crash, which will lead to a red stop icon appearing. If that happens, you'll need to refresh the script.

### How does the "double" gamemode work

This one is a little more confusing to run. In theory, if you pass the option to the bot, two BizHawk windows should pop up. You then open and load the `N64.lua` script on both windows and run the `start()` command on both consoles. If nothing goes wrong, the first window should receive commands from chatters with names starting with `A to M`, while the second window should receive commands from `N to Z + number and symbols` chatters. I might do a more in-depth tutorial for the mode.

### The controller image is too big/small/out of place

The image was made to be used with the N64 system, and thus configured for that resolution. You'll probably need to mess with the configs in `Lua/config.lua` and mess with positions and sizes if you're using a different system.

## Development

Clone this repository

```sh
git clone --recurse-submodules https://github.com/mp-pinheiro/FairFruit-Bot.git
```

Install all dependencies (it's heavily recommended that you do this inside a virtual enviroment).

```sh
pip install -r requirements.txt
```
