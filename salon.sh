#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon ~~~~~\n"
MAIN_MENU(){
  SERVICE_RESULT=$($PSQL "SELECT * FROM services ")
  echo "$SERVICE_RESULT" | while read  SERVICE_ID BAR  NAME ;
  do
    echo -e "$SERVICE_ID) $NAME"
  done
  echo "0) exit"2
  echo "Enter service: "
  read SERVICE_ID_SELECTED
  if [[ $SERVICE_ID_SELECTED != 0 ]]
  then
    SERVICE_ID_SELECTED_RESULT=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    if [[ -z $SERVICE_ID_SELECTED_RESULT ]] 
    then
      MAIN_MENU
    else
      echo -e "\nEnter you phone: "
      read CUSTOMER_PHONE
      
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
      if [[ -z $CUSTOMER_NAME ]]
      then
        echo -e "\nEnter your name: "
        read CUSTOMER_NAME
        INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
      fi
      
      echo -e "\nEnter the date: "
      read SERVICE_TIME

      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
      INSERT_APPOINTMENTS_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
      if [[  $INSERT_APPOINTMENTS_RESULT == "INSERT 0 1" ]]
      then
        echo -e "\nI have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
      fi
    fi
  fi
}

MAIN_MENU