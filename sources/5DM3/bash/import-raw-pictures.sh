#!/bin/bash

# ***************************************************************************
# * This file is part of C. Benne tools software.                           * 
# *                                                                         *
# * Copyright © 2022 by Christophe Benne                                    * 
# *                                                                         * 
# * This is free and unencumbered software released into the public domain. *
# *                                                                         *
# * Anyone is free to copy, modify, publish, use, compile, sell, or         *
# * distribute this software, either in source code form or as a compiled   *
# * binary, for any purpose, commercial or non-commercial, and by any       *
# * means.                                                                  *
# *                                                                         *
# * In jurisdictions that recognize copyright laws, the author or authors   *
# * of this software dedicate any and all copyright interest in the         *
# * software to the public domain. We make this dedication for the benefit  *
# * of the public at large and to the detriment of our heirs and            *
# * successors. We intend this dedication to be an overt act of             *
# * relinquishment in perpetuity of all present and future rights to this   *
# * software under copyright law.                                           *
# *                                                                         *
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,         *
# * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF      *
# * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  *
# * IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR       *
# * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   *
# * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR   *
# * OTHER DEALINGS IN THE SOFTWARE.                                         *
# *                                                                         *
# * For more information, please refer to <https://unlicense.org>           *
# *                                                                         *
# ***************************************************************************

#
# \file  import-raw-picture.sh
#
# \brief Un shell bash pour importer des images CR2 depuis un reflex Canon,
#        les images sont automatiquement classées dans une arborescence de
#        répertoire <YEAR>/<MONTH>/<DAY>.
#
# Ceci est une première version très basique du script d'import. Le script
# prend deux arguments : le répertoire où est montée la carte de l'appareil
# photo et le répertoire où les photos doivent être copiées. Toutes les
# photo du répertoire $1/DCIM/100EOS5D sont copiées dans
# $2/<YEAR>/<MONTH>/<DAY> sauf si le fichier existe déjà. <YEAR>, <MONTH>
# et <DAY> sont l'année, le mois et le jour où la photo a été prise, ils
# sont déduits des données EXIF du fichier original.
#

# To be implemented.

#
# \function Import raw images
#
# \param $1 Chemin vers le répertoire où est monté la carte de l'appareil
#           photo.
# \param $2 Chemin vers le répertoire où les images brutes de la carte de
#           l'appareil photo doivent être copiée.
#
function import_CR2()
{
    local org_path=$1/DCIM/100EOS5D
    local dst_path=$2
    local org_file
    local counter=1
    
    for org_file in ${org_path}/*.CR2
    do
	local directory=$(exiftool ${org_file} | awk '/File Modification Date/ { print $5 }' | tr ':' '/')
	local file=$(basename ${org_file})

	[[ -d ${dst_path}/${directory} ]] || mkdir -p ${dst_path}/${directory}
	if [[ ! -f ${dst_path}/${directory}/${file} ]]
	then
	    md5sum ${org_file} > ${dst_path}/${directory}/${file}.md5
	    sed -i "s|${org_file}|${dst_path}/${directory}/${file}|" ${dst_path}/${directory}/${file}.md5
	    
	    cp ${org_file} ${dst_path}/${directory}/${file}
	fi
    done
    
    return 0
}

#
# Deux arguments sont nécessaires au script. A compléter plus tard par un
# usage du script et des vérifications sur les paramètres passés.
# 
[[ $# -eq 2 ]] || exit 1

#
# Import des images brutes.
#
import_CR2 $1 $2

exit 0
