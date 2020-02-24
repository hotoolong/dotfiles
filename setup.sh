#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
FILES=`ls -1a | grep -E '^\.' | grep -v -E '^(.|..|.git|.config)$'`
CONFIGS=`ls -1a ${SCRIPT_DIR}/configs/. | grep -v -E '^(.|..|.git)$'`

for file in ${FILES[@]}
do
  ln -svi ${SCRIPT_DIR}/${file} ${HOME}/${file}
done

if [ ! -d "${HOME}/.config" ]; then
  mkdir ${HOME}/.config
fi

for file in ${CONFIGS[@]}
do
  ln -svi ${SCRIPT_DIR}/configs/${file} ${HOME}/.config/${file}
done
