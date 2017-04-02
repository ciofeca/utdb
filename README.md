## Description

Given an UrbanTerror client and some time slaying enemies in deathmatch-like modes, aggregate players statistics (kills, hitting, cumulative damage, being killed, accidental stepping on own grenades, and so on) in a local PostgreSQL database.

Depending on people playing on a server, there could be up to 3000-4000 *upsert* events per hour. The *ut* table will grow up proportional to the actual number of players seen during the game - don't expect it to go far more than a few hundreds.

Table fields:
* screen name chosen by the player (ascii)
* account name, if present; an account may have more than a screen name associated, cannot contain special characters
* location, as reported by the server guessed by the IP address; 'None' means the player is a bot (not human)
* firstseen, timestamp of record creation
* lastseen, most recent timestamped event about this player
* kills: player total kills (others + me)
* deaths: player total deaths (inflicted by others and me)
* killed: times I actually killed this player
* killedme: times I was actually killed by this player
* hit: times I actually hit this player without killing
* hitme: times I was actually hit without being killed
* damage: cumulative damage percentages reported by hit events
* damageme: cumulative damage inflicted by this player to me
* spree: number of times the server flattered this player reporting his/her ongoing "killing spree"
* lemming: number of times the player died because of high jumping/falling or drowning
* kicked: times the player was kicked by the server for some reason (idle, bot disabling...)
* smitten: punishment explicitly inflicted by server administrator

Name, account and location are string type; except the two timestamps, the other fields are integers.

## Installation

Assuming "Ubuntu Linux" as operating system. Ruby is required for the data collector script.

    sudo apt install ruby postgresql libpq-dev
    sudo gem install pg

## Trusting local users

In the "IPv4 local connections" section of *pg_hba.conf* switch from default *md5* to *trust:*

    host  all  all  127.0.0.1/32  trust

If you don't do this, you'll need to manually authenticate to PostgreSQL (adding a few parameters to *PGconn.new*).

## Initializing database

Assuming "acciuga" as Ubuntu login user:

    sudo -u postgres psql
        create user acciuga;
        create database acciuga;

## Launcher script

The original version just does an *upsert* for every console-reported event, allowing real-time statistics.
