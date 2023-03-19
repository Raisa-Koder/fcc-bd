#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
  exit
fi

# argument pass is an atomic number
if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT type_id,atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$1")

# argument pass is symbol
else
  ELEMENT=$($PSQL "SELECT type_id,atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name='$1' OR symbol='$1'")
fi

if [[ -z $ELEMENT ]]
then
  echo I could not find that element in the database.
  exit
fi

echo "$ELEMENT" | while read TYPE_ID BAR ATOM_NO BAR SYMBOL BAR NAME BAR TYPE BAR ATOM_MASS BAR M_P_C BAR B_P_C
do
  echo "The element with atomic number $ATOM_NO is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOM_MASS amu. $NAME has a melting point of $M_P_C celsius and a boiling point of $B_P_C celsius."
done
