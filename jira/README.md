# jira_deploy


Role Name
=========

установка jira в docker

Requirements
------------

python 3 installed
credentials login/password or ssh keys


Role Variables
--------------


Dependencies
------------
docker
module community.docker.docker_network 
install on manager host via cmd:
'''


ansible-galaxy collection install community.docker


'''

inventory - файл со списком хостов для ansible. если не указывать, то будет использован стандартный /etc/ansible/hosts
пример:

'''
cat /etc/ansible/hosts

[docker]
docker-1.company.off

'''

Example 
----------------

Пример запуска:

$ansible-playbook --extra-vars "variable_host=jira.company.off" --extra-vars "variable_user=infrauser"  install_docker.yml -b -K

где:
variable_host - переопределение адреса сервера куда производится установка
variable_user - переопределение имени пользователя от которого производится установка


можно переопределить переменные с аргументом --extra-vars:
variable_atl_proxy_name
variable_atl_proxy_port 
variable_atl_tomcat_scheme
variable_atl_tomcat_secure




