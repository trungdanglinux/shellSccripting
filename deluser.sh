#!/bin/bash

#The script deletes a user.

usage(){
 echo "Usage:./deluser.sh [-dra] USER[USER]"
 echo "Disable a local Linux account."
 echo "-d Deletes accounts instead of disabling them."
 echo "-r Removes the home directory associated with the account(s)."
 echo "-a Creates an archive of the home directory associated with the account(s)."
 exit 1
}
#Check if the command works welll
check_command(){
 if [[ "${1}" -ne 0 ]]
 then 
     echo "The process is not successful. Please check it again!" >&2
     exit 1
 fi
}


#RUn as a root or sudo
if [[ "${UID}" -ne 0 ]] 
then
 echo "Please run with sudo or as a root."
 exit 1
fi

#Parsing the options
while getopts dra OPTION
do 
  case "${OPTION}" in
   d)  
      DELETE=1	
    ;;
   r)
      REMOVE_OPTION="-r"
    ;;
   a)
     MAKE_ARC=1
    ;;
   ?)
     usage
    ;;	
  esac
done  

NUM_OPTIND="${OPTIND}"

shift "$((OPTIND -1 ))"
ARG_NUM="${#}"
if [[ "${ARG_NUM}" -eq 0  ]]
then 
    usage
fi

for ACCOUNT in  "${@}"
do
   CHECKID=$(id -u "${ACCOUNT}" ) 
   if [[ "${?}" -gt 0 ]]
   then
      echo "Choose a valid account" >&2
      exit 1 
   fi

   if  [[ "${CHECKID}" -lt 1000 ]]
   then 
        echo " Only user accounts can be modified or deleted. " >&2
        exit 1
   fi

   if [[ "${MAKE_ARC}" -eq 1 ]]
   then
      if [[ ! -d /home/archives ]]
      then
         echo "Creating archive directory."
         mkdir -p /home/archives
      fi
      if [[ "${?}" -ne 0 ]]
      then
         echo "Archive directory can't created"
      fi
      tar -zcf /home/archives/"${ACCOUNT}" /home/"${ACCOUNT}" &> /dev/null 
      if [[ "${?}" -ne 0 ]]
      then
         echo "Could not create archive directory." >&2
      fi
      echo "The ${ACCOUNT} directory is backed up."  
   fi
      
   if [[ "${DELETE}" -eq 1 ]]
   then
      userdel "${REMOVE_OPTION}" "${ACCOUNT}" &> /dev/null

      if [[ "${?}" -ne 0 ]]
      then 
         echo "${ACCOUNT} can not be deleted."
      fi
   fi

   if [[ "${NUM_OPTIND}" -eq 1 ]]
   then 
      chage -E 0 "${ACCOUNT}"
      check_command "${?}"
      echo "The account ${ACCOUNT} is disabled."
   fi

done


#if it is done successfully 
echo "The process is done successfully!"

exit 0
