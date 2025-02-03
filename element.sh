#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
 then
   echo "Please provide an element as an argument."
 else
 SEARCH_VALUE=$1
if [[ "$SEARCH_VALUE" =~ ^[0-9]+$ ]]
then
 SQL_QUERY="select e.atomic_number, e.name as element_name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius from elements e join properties p on e.atomic_number = p.atomic_number join types t on p.type_id=t.type_id where  e.atomic_number = $SEARCH_VALUE;"
else
 SQL_QUERY="select e.atomic_number, e.name as element_name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius from elements e join properties p on e.atomic_number = p.atomic_number join types t on p.type_id=t.type_id where e.symbol='$SEARCH_VALUE' or e.name='$SEARCH_VALUE';"
fi
SEARCH_RESULT=$($PSQL "$SQL_QUERY")
if [[ -z $SEARCH_RESULT ]]
 then
   echo "I could not find that element in the database."
 else
   for row in "${SEARCH_RESULT[@]}"; do
        IFS='|' read -ra ADATA <<< "$row"
        atomic_number=${ADATA[0]}
        element_name=${ADATA[1]}
        symbol=${ADATA[2]}
        type=${ADATA[3]}
        atomic_mass=${ADATA[4]}
        melting_point=${ADATA[5]}
        boiling_point=${ADATA[6]}
        echo "The element with atomic number $atomic_number is $element_name ($symbol). It's a $type, with a mass of $atomic_mass amu. $element_name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
    done
 fi

 fi
