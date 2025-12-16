#!/usr/bin/env bash

USER="hdutheil"
USERFILE="/home/${USER}/.config/systemd/user/hypridle.service"
GUIFILE="/home/${USER}/.config/systemd/user/graphical-session.target.wants/hypridle.service"
if [ -f ${USERFILE} ]; then
  rm ${USERFILE}
fi
if [ -f ${GUIFILE} ]; then
  rm ${GUIFILE}
fi
