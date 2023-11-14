PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
#listening for input or lack thereof
if [[ -z $1 ]]
then
	echo "Please provide an element as an argument."
	exit
fi

#Elements list

#if entry is a number
if [[ $1 =~ ^[0-9]+$ ]]
then 
	RETURN_ELEMENT=$($PSQL "SELECT e.atomic_number,e.name,e.symbol,t.type,p.atomic_mass,p.melting_point_celsius,p.boiling_point_celsius FROM elements e FULL JOIN  properties p USING(atomic_number) FULL JOIN types t  USING(type_id) WHERE e.atomic_number=$1;")
else
#if entry is name or symbol
	RETURN_ELEMENT=$($PSQL "SELECT e.atomic_number,e.name,e.symbol,t.type,p.atomic_mass,p.melting_point_celsius,p.boiling_point_celsius FROM elements e FULL JOIN properties p USING(atomic_number) FULL JOIN types t USING(type_id) WHERE name = '$1' OR symbol = '$1';")
fi

#if not in table
if [[ -z $RETURN_ELEMENT ]]
then
	echo "I could not find that element in the database."
	exit
fi

#print value
echo $RETURN_ELEMENT | while IFS=" |" read atomic_number name symbol type atomic_mass melting_point boiling_point 
do
	echo  "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
done
