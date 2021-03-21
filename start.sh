#!/bin/bash

FORCE_UPGRADE=$([[ ! -z $FORCE_UPGRADE ]] && echo $FORCE_UPGRADE || echo 1)

if [ "$(ls -A /starbound_upgrade)" ]; then
	echo "Unpack Gamedata (this could take a while)"
	mv /starbound_upgrade/*.sh /tmp
	unzip -qq /tmp/*.sh -d /tmp
	
	if [ "$(ls -A /starbound)" ]; then
		GAME_OLD = $(sed -n -e 1p /starbound/game/gameinfo)
		GAME_NEW = $(sed -n -e 1p /tmp/data/noarch/game/gameinfo)
		VERSION_OLD = $(sed -n -e 2p /starbound/game/gameinfo)
		VERSION_NEW = $(sed -n -e 2p /tmp/data/noarch/game/gameinfo)
		UPGRADE = 0
	
		if [[ $FORCE_UPGRADE -eq 0 ]]; then
			echo "Force upgrade initiated"
			
			mv /starbound/game/storage /starbound_upgrade
			rm -r /starbound/*
		elif [ "$GAME_OLD" == "$GAME_NEW" ] && [[[ $FORCE_UPGRADE -eq 1 ]] || [ "$VERSION_OLD" != "$VERSION_NEW" ] && [ $(printf '%s\n%s\n' "$VERSION_OLD" "$VERSION_NEW" | sort -VC ; echo $?) ]]; then
			echo "Starbound already exists"
			echo "Backup save game and delete old data"
			
			mv /starbound/game/storage /starbound_upgrade
			rm -r /starbound/*
		else
			echo "Given upgrade file is not the right game or an older version"
			echo "New Game Name: $GAME_NEW"
			echo "Current running release: $VERSION_OLD"
			echo "New game release: $VERSION_NEW"
			
			UPGRADE = 1
		fi
	fi

	if [[ $UPGRADE -eq 0 ]]; then
		echo "Upgrade game"
		mv /tmp/data/noarch/* /starbound
		mv /starbound_upgrade/storage /starbound/game
	fi
	
	echo "Cleanup"
	rm -r /tmp/data
fi

echo "Start game server"
if [ -d /starbound/game/linux64 ]; then
	cd /starbound/game/linux64
else
	if [ -d /starbound/game/linux ]; then
		cd /starbound/game/linux
	else
		echo "I'm sorry, the game/linux folder doesn't exist or isn't in the right place."
	fi
fi

chmod a+x ./starbound_server
./starbound_server