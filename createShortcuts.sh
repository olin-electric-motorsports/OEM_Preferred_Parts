#!/bin/bash

#Check if .bashrc contains call command
echo "Adding  command file to .bashrc..."
FORMULADIR="$(dirname "$(pwd)")"

#If .bashrc does not have line append call to end
ALIASCOMMAND=$FORMULADIR"/aliases.sh"
if [[ $(grep -c $ALIASCOMMAND ~/.bashrc) -eq 0 ]]
then echo "source "$ALIASCOMMAND >> ~/.bashrc;
fi

#Create Alias file if it doesn't exist
echo "Creating  alias file"
cd $FORMULADIR
commandComment="#!/bin/sh";
if ! [[ $( find -name "aliases.sh") ]]
then $( touch aliases.sh && echo -e $commandComment  >> ./aliases.sh )
fi

#Get existing aliases
source ~/.bashrc
$(alias >> ./alias.txt)

echo "Adding new shortcuts"
#Create Shortcuts in alias file
for repo in $(ls)
 do
 if [[ $repo =~ ^MK ]] && [[ $( grep -c $repo ./alias.txt)  -eq 0 ]] && [[ $( grep -c $repo ./aliases.sh) -eq 0 ]];
 then
 short=${repo:$(expr index "$repo" K):$(expr index "$repo" -) - $(expr index "$repo" K)-1}${repo:$(expr index "$repo" -)};
 shorter="alias ""${short,,}";
 cut="='cd "$FORMULADIR"/"$repo"/'";
 echo $shorter$cut >> ./aliases.sh;
 fi;

 #Add OEM_Preferred_Parts shortcuts
 if [[ $repo =~ ^OEM ]]
 then echo "alias OEM_Parts='cd "$FORMULADIR"/OEM_Preferred_Parts/'" >> ./aliases.sh;
 fi
done

#Add rules shortcut
RULES=$FORMULADIR"/OEM_Preferred_Parts/rules.pdf"
if [[ $( grep -c $RULES ./alias.txt)  -eq 0 ]] && [[ $( grep -c $RULES ./aliases.sh) -eq 0 ]];
then echo "alias rules='evince "$RULES"'" >> ./aliases.sh;
fi;

#Remove temp file
rm alias.txt
