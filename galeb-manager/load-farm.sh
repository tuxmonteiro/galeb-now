#!/bin/bash

PROTOCOL="http"
SERVER="localhost:MANAGER_PORT"
HEADER="Content-Type: application/json;charset=UTF-8"
TEAM_NAME='xxxxx'
ADMIN_TEAM_NAME='AdminTeam'
PROVIDER_NAME='galeb'
ENV_NAME='desenv'
RULETYPE_NAME='UrlPath'
FARM_NAME='farm1'
BALANCEPOLICYTYPE_NAME='RoundRobin'
BALANCEPOLICY_NAME='RoundRobin'
DOMAIN="${FARM_NAME}.localhost"
API="http://API_ADDR_AND_PORT"
ADMIN_LOGIN=galeb

TOKEN=""

showPreRequisite() {
cat <<eof

PRE-REQUISITES:

  * jq - lightweight and flexible command-line JSON processor
  * curl - command line tool for transferring data with URL syntax

eof
exit
}

usage() {
cat <<eof

usage: $0 [admin]

eof
exit
}

hasJq() {
  echo {} | jq . > /dev/null 2>&1
  return $?
}

hasCurl() {
  curl --help > /dev/null 2>&1
  return $?
}

if ! (hasJq && hasCurl); then
  showPreRequisite
fi

if [ "x$1" == "x-h" -o "x$1" == "x--help" ]; then
  usage
fi

loginAccount() {
  local MESSAGE=$1
  local LOGIN=$2
  local PASSWORD=$3

  if [ "x$PASSWORD" == "x" ]; then
    echo -n "$MESSAGE password: "
    read -s PASSWORD
    echo
  else
    PASSWORD='password'
  fi

  export TOKEN="$(curl -k -v ${PROTOCOL}://${LOGIN}:${PASSWORD}@${SERVER}/token | jq -r .token)"
  echo
}

logoutAccount() {
  local TOKEN=$1

  curl -k -XPOST -H"x-auth-token: $TOKEN" ${PROTOCOL}://${SERVER}/logout
  echo
}

getId() {
  local TOKEN=$1
  local TYPE=$2
  local NAME=$3

  # TYPE: pool, target, rule, virtualhost, farm, environment, ruletype,
  #       project, account, team, etc.
  curl -k -s -XGET -H"x-auth-token: $TOKEN" \
    ${PROTOCOL}'://'${SERVER}'/'${TYPE}'/search/findByName?name='${NAME}'&page=0&size=999999' | \
  jq ._embedded.${TYPE}[0].id
}

createTeam() {
  local TOKEN=$1
  local NAME=$2

  curl -k -v -XPOST -H"x-auth-token: $TOKEN" -H ${HEADER} \
    -d '{ "name":"'${NAME}'" }' ${PROTOCOL}://${SERVER}/team
  echo
}

createAccount() {
  local TOKEN=$1
  local ROLES=$2
  local TEAM_NAME=$3
  local LOGIN=$4
  local RANDOM_EMAIL="fake.$(date +%s%N)@fake.com"
  local TEAM_ID="$(getId ${TOKEN} team ${TEAM_NAME})"

  curl -k -v -XPOST -H ${HEADER} \
       -d '{
              "name": "'${LOGIN}'",
              "password": "password",
              "email": "'${RANDOM_EMAIL}'" ,
              "roles": [ '${ROLES}' ],
              "teams": [ "'${PROTOCOL}'://'${SERVER}'/team/'${TEAM_ID}'" ]
          }' \
       -H"x-auth-token: $TOKEN" ${PROTOCOL}://${SERVER}/account
  echo
}

createProvider() {
  local TOKEN=$1
  local NAME=$2
  local DRIVER_NAME='GalebV3'

  curl -k -v -XPOST -H ${HEADER} \
       -d '{
              "name": "'${NAME}'",
              "driver": "'${DRIVER_NAME}'"
          }' \
       -H"x-auth-token: $TOKEN" ${PROTOCOL}://${SERVER}/provider
  echo
}

createEnvironment() {
  local TOKEN=$1
  local NAME=$2

  curl -k -v -XPOST -H ${HEADER} \
       -d '{ "name":"'${NAME}'" }' \
       -H"x-auth-token: $TOKEN" ${PROTOCOL}://${SERVER}/environment
  echo
}

createTargetType () {
  local TOKEN=$1
  local NAME=$2

  curl -k -v -XPOST -H ${HEADER} \
       -d '{ "name":"'${NAME}'" }' \
       -H"x-auth-token: $TOKEN" ${PROTOCOL}://${SERVER}/targettype
  echo
}

createRuleType() {
  local TOKEN=$1
  local NAME=$2

  curl -k -v -XPOST -H ${HEADER} \
       -d '{ "name": "'${NAME}'" }' \
       -H"x-auth-token: $TOKEN" ${PROTOCOL}://${SERVER}/ruletype
  echo
}

createFarm () {
  local TOKEN=$1
  local NAME=$2
  local ENV_ID="$(getId ${TOKEN} environment ${ENV_NAME})"
  local PROVIDER_ID="$(getId ${TOKEN} provider ${PROVIDER_NAME})"

  curl -k -v -XPOST -H ${HEADER} \
       -d '{
              "name": "'${NAME}'",
              "domain": "'${DOMAIN}'",
              "api": "'${API}'",
              "autoReload": true,
              "environment": "'${PROTOCOL}'://'${SERVER}'/environment/'${ENV_ID}'",
              "provider": "'${PROTOCOL}'://'${SERVER}'/provider/'${PROVIDER_ID}'"
          }' \
       -H"x-auth-token: $TOKEN" ${PROTOCOL}://${SERVER}/farm
  echo
}

createBalancePolicyType() {
  local TOKEN=$1
  local NAME=$2

  curl -k -v -XPOST -H ${HEADER} \
       -d '{ "name": "'${NAME}'" }' \
       -H"x-auth-token: $TOKEN" ${PROTOCOL}://${SERVER}/balancepolicytype
  echo
}

createBalancePolicy() {
  local TOKEN=$1
  local NAME=$2
  local BALANCEPOLICYTYPE_ID="$(getId ${TOKEN} balancepolicytype ${BALANCEPOLICYTYPE_NAME})"

  curl -k -v -XPOST -H ${HEADER} \
       -d '{
              "name": "'${NAME}'",
              "balancePolicyType": "'${PROTOCOL}'://'${SERVER}'/balancepolicytype/'${BALANCEPOLICYTYPE_ID}'"
          }' \
       -H"x-auth-token: $TOKEN" ${PROTOCOL}://${SERVER}/balancepolicy
  echo
}

# LOGIN WITH INTERNAL ADMIN ACCOUNT
loginAccount '(internal admin)' admin password

# CREATE A TEAM
createTeam ${TOKEN} ${ADMIN_TEAM_NAME}

# CREATE A ACCOUNT WITH ADMIN ROLE
createAccount ${TOKEN} '"ROLE_USER","ROLE_ADMIN"' ${ADMIN_TEAM_NAME} ${ADMIN_LOGIN}

# LOGOUT INTERNAL ADMIN
logoutAccount ${TOKEN}

# LOGIN WITH A NEW ADMIN ACCOUNT
loginAccount '(new admin)' ${ADMIN_LOGIN} password

# CREATE A PROVIDER
createProvider ${TOKEN} ${PROVIDER_NAME}

# CREATE A ENVIRONMENT
createEnvironment ${TOKEN} ${ENV_NAME}

# CREATE A RULE TYPE
createRuleType ${TOKEN} ${RULETYPE_NAME}

# CREATE A FARM (Environment and Provider are required)
createFarm ${TOKEN} ${FARM_NAME}

# CREATE BALANCE POLICY TYPE
createBalancePolicyType ${TOKEN} ${BALANCEPOLICYTYPE_NAME}

# CREATE BALANCE POLICY
createBalancePolicy ${TOKEN} ${BALANCEPOLICY_NAME}

# LOGOUT NEW ADMIN ACCOUNT
logoutAccount ${TOKEN}

