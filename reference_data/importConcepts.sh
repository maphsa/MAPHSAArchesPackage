#!/bin/bash

eval CONCEPTPATH=$PWD
eval ARCHESPATH="~/maphsa_arches"


# Enable ENV
source ~/ENV/bin/activate

# Import concepts
shopt -s nullglob
for i in *.xml; do
    python $ARCHESPATH/manage.py packages -o import_reference_data -s $i -ow overwrite -st keep
done

# import collections
python $ARCHESPATH/manage.py packages -o import_reference_data -s collections/collections.xml -ow overwrite -st keep

# Reindex db
python $ARCHESPATH/manage.py es reindex_database
