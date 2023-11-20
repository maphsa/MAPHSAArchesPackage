#!/bin/bash

eval PACKAGEPATH=$PWD

eval ARCHESPATH="~/maphsa_arches"
eval ENVPATH="~/ENV/bin/activate"

# enable ENV

source $ENVPATH

# read -e -p "Enter the path to arches: " ARCHESPATH
# eval ARCHESPATH=$ARCHESPATH
# cd $A

# Rebuild db
python $ARCHESPATH/manage.py setup_db

# Load ontology
python $ARCHESPATH/manage.py load_ontology -s $PACKAGEPATH/ontology

# Load Concepts and collections
for i in $PACKAGEPATH/reference_data/*.xml; do
    [ -f "$i" ] || break
    python $ARCHESPATH/manage.py packages -o import_reference_data -s $i
done

for i in $PACKAGEPATH/reference_data/collections/*.xml; do
    [ -f "$i" ] || break
    python $ARCHESPATH/manage.py packages -o import_reference_data -s $i
done


# Load Resource Models, Branches
python $ARCHESPATH/manage.py packages -o import_graphs -s $PACKAGEPATH/resource_model

# read -p "Publish all resource models and press key to proceed with business data import..."

# Load Business Data

# for i in $PACKAGEPATH/business_data/*.json; do
#     [ -f "$i" ] || break
#     python $ARCHESPATH/manage.py packages -o import_business_data -s $i -ow overwrite
# done


# Reindex Elastic Search
python $ARCHESPATH/manage.py es reindex_database
