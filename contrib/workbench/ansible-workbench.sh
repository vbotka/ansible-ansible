#!/bin/sh

# All rights reserved (c) 2019-2020, Vladimir Botka <vbotka@gmail.com>
# Simplified BSD License, https://opensource.org/licenses/BSD-2-Clause

# version="0.2.4-CURRENT"
version="0.2.3"

usage="ansible-workbench ver ${version}
Usage:
      ansible-workbench [-h|--help] [-V|--version]
                        [-v1|--actionable] [-v2|--minimal] [-v3|--minimal]
                        [-d|--debug] [-n|--dry-run] command
                        -- Install and configure Ansible workbench
Where:
      -h --help ....... Show this help and exit
      -V --version .... Print version and exit
      -v1 --actionable  Use Ansible actionable callback plugin
      -v2 --minimal ... Use Ansible minimal callback plugin
      -v3 --yaml ...... Use Ansible yaml callback plugin
      -d --debug ...... Display debug and set playbook_debug=true
      -n --dry-run .... Set dryrun=true and playbook_dryrun=--check
      command ......... ansible, config, dirs,
                        repos, roles, projects, links, runner,
                        all, none, test, update, diff
Commands:
      ansible ......... Clone vbotka.ansible and copy contrib/workbench
                        to ansible-workbench if not exist
      config .......... Copy sample configuration files if not exist
      dirs ............ Create directories if not exist
      repos ........... Clone repositories if exist update
      roles ........... Clone roles if exist update
      projects ........ Clone projects if exist update
      links ........... Create links
      runner .......... Create ansible-runner projects
      all ............. Create all
      none ............ Create none. For testing
      test ............ Test all
      update .......... Update ansible-workbench from contrib/workbench
      diff ............ Diff ansible-workbench to contrib/workbench

Examples:
      Dry-run all commands. Display debug output
      shell> ./ansible-workbench.sh -d -n all
      Run all commands. Use Ansible yaml callback plugin
      shell> ./ansible-workbench.sh -v3 all
      Run all tests. Use Ansible actionable callback plugin
      shell> ./ansible-workbench.sh -v1 test"

expected_args=1
if [ "$#" -lt "${expected_args}" ]; then
    echo "${usage}"
    exit 0
fi

# Configuration
my_config_file=""
if [ -e ${HOME}/.ansible-workbench.cfg ]; then
    my_config_file="${HOME}/.ansible-workbench.cfg"
    . ${HOME}/.ansible-workbench.cfg
fi
if [ -e ${PWD}/.ansible-workbench.cfg ]; then
    my_config_file="${PWD}/.ansible-workbench.cfg"
    . ${PWD}/.ansible-workbench.cfg
fi

# Functions
. ${workbench_dir}/ansible-workbench-lib.sh

# Main
dryrun="false"
playbook_debug="false"
playbook_dryrun=""
for i in "$@"; do
    case $i in
        -h|--help)
            printf "${usage}\n"
            exit 0
            ;;
        -V|--version)
            printf "${version}\n"
            exit 0
            ;;
        -v1|--actionable)
            export ANSIBLE_STDOUT_CALLBACK=actionable
            ;;
        -v2|--minimal)
            export ANSIBLE_STDOUT_CALLBACK=minimal
            ;;
        -v3|--yaml)
            export ANSIBLE_STDOUT_CALLBACK=yaml
            ;;
        -n|--dry-run)
            playbook_dryrun="--check"
	    dryrun="true"
            ;;
        -d|--debug)
            playbook_debug="true"
	    print_debug
            ;;
	ansible)
	    ansible_role
	    exit 0
	    ;;
	update)
	    ansible_update_workbench
	    exit 0
	    ;;
	config)
	    config_files
	    exit 0
	    ;;
	diff)
	    devel_diff
	    exit 0
	    ;;
	dirs)
	    create_dirs
	    exit 0
	    ;;
        repos)
            repos_clone_update_link
            exit 0
            ;;
        roles)
            roles_clone_update_link
            exit 0
            ;;
        projects)
            projects_clone_update_link
            exit 0
            ;;
        links)
            create_links
            exit 0
            ;;
        runner)
            runner_create_private
            exit 0
            ;;
        test)
            install_test
            exit 0
            ;;
        none)
            exit 0
            ;;
        all)  # .............................COMMANDS
	    create_dirs                    # dirs
	    ansible_role                   # ansible
	    config_files                   # config
            repos_clone_update_link        # repos
            roles_clone_update_link        # roles
            projects_clone_update_link     # projects
            create_links                   # links
	    runner_create_private          # runner
            exit 0
            ;;
        *)
            printf "[ERR] Unknown command ${i}\n"
            printf "${usage}\n"
            exit 1
            ;;
    esac
done

exit 0

# Devel. Diff and update source code
# ==================================
#
# 1) Print diff
#    #!/bin/sh
#    while read l; do
#      echo $l
#      diff $l $HOME/.ansible/roles/vbotka.ansible/contrib/workbench/$l
#    done < FILES
#
# 2) Copy FILES to roles/vbotka.ansible/contrib/workbench
#    #!/bin/sh
#    while read l; do
#      cp $l $HOME/.ansible/roles/vbotka.ansible/contrib/workbench/$l
#    done < FILES    

# EOF
