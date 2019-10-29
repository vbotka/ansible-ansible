#!/bin/sh

# All rights reserved (c) 2019, Vladimir Botka <vbotka@gmail.com>
# Simplified BSD License, https://opensource.org/licenses/BSD-2-Clause

version="0.1.5-CURRENT"

usage="ansible-workbench ver $version
Usage:
      ansible-workbench [-h|--help] [-V|--version]
                        [-d|--debug] [-n|--dry-run] command
                        -- Install and configure Ansible workbench
Where:
      -h --help .......... show this help and exit
      -V --version ....... print version and exit
      -d --debug ......... run the playbooks with debug=true
      -n --dry-run ....... run the playbooks with --check
      command ............ repos, roles, projects, links, runner, all, none"

expected_args=1
if [ "$#" -lt "$expected_args" ]; then
    echo "$usage"
    exit 0
fi

git_user=admin
owner=admin
owner_group=admin
mode="u=+rwX,g=+rX-w,o=-rwx"
base_dir=/home/${owner}/.ansible
repos_dir=${base_dir}
roles_dir=${base_dir}/roles
projects_dir=${base_dir}/projects
runner_dir=${base_dir}/runner
misc_dir=${base_dir}/ansible-misc

# Configuration file
if [ -e $HOME/.ansible-workbench.conf ]; then
    . $HOME/.ansible-workbench.conf
fi

# Clone or update repo (not used) ----------------------------------------------
repo_clone_update() {
    if [ -e "${dir}" ]; then
        echo "[OK] Dir ${dir} exists"
        if message=$(cd ${dir}; git pull); then
            echo "[OK] Updated ${repo}: $message"
        else
            echo "[ERR] Can not update ${repo}: ${message}"
        fi
    else
        echo "[OK] Dir ${dir} does not exist"
        if message=$(git clone ${repo}); then
            echo "[OK] Cloned ${repo}: ${message}"
        else
            echo "[ERR] Can not clone ${repo}: ${message}"
        fi
    fi
}

# Link repo (not used)
repo_link() {
    if [ -e "${link}" ]; then
        echo "[OK] Link ${link} exists"
    else
        echo "[OK] Link ${link} does not exist"
        if message=$(ln -s ${dir} ${link}); then
            echo "[OK] Linked ${dir} to ${link}: ${message}"
        else
            echo "[ERR] Can not link ${dir} to ${link}: ${message}"
        fi
    fi
}

# Clone/update and link repos (not used)
repos_clone_update_link_not_used() {
    for repo in ${git_repos}; do
        dir=$(echo ${repo} | rev | cut -f 1 -d "/" | rev | cut -f 1 -d ".")
        link=$(echo ${dir} | cut -f 2 -d "-" )
        # echo "[DBG] repo: ${repo} dir: ${dir} link: ${link}"
        (cd ${root_dir} && repo_clone_update)
        (cd ${root_dir} && repo_link)
        (cd ${root_dir} && chown -R ${owner}:${owner_group} ${dir})
    done
}

# Link ansible-lint-rules (not used)
link_ansible_lint_rules() {
    if [ -e "ansible-lint-rules" ]; then
        echo "[OK] ansible-lint-rules exists"
    else
        if ln -s ${lint_dir} ansible-lint-rules; then
            echo "[OK] ansible-lint-rules created"
        else
            echo "[ERR] Can not create ansible-lint-rules"
        fi
    fi
}  # ---------------------------------------------------------------------------

# Clone/update and link repos from git
repos_clone_update_link() {
    if [ ! -e "${repos_dir}" ]; then
	mkdir -p ${repos_dir}
    fi
    ansible_params="my_git_user=${git_user} \
                    my_user=${owner} \
                    my_group=${owner_group} \
                    my_mode=${mode} \
                    my_repos_path=${repos_dir} \
                    my_repos_file=${misc_dir}/vars/repos.yml \
                    debug=${playbook_debug}"
    (cd ${misc_dir} && ansible-playbook -e "${ansible_params}" \
		       ${playbook_dryrun} install-repos-from-git.yml)
    chown -R ${owner}:${owner_group} ${repos_dir}
}

# Clone/update and link roles from github
roles_clone_update_link() {
    if [ ! -e "${roles_dir}" ]; then
	mkdir -p ${roles_dir}
    fi
    ansible_params="my_git_user=${git_user} \
                    my_user=${owner} \
                    my_group=${owner_group} \
                    my_mode=${mode} \
                    my_repos_path=${repos_dir} \
                    my_repos_file=${misc_dir}/vars/roles.yml \
                    debug=${playbook_debug}"
    (cd ${misc_dir} && ansible-playbook -e "${ansible_params}" \
                       ${playbook_dryrun} install-repos-from-git.yml)
    chown -R ${owner}:${owner_group} ${roles_dir}
}

# Clone/update and link projects from git
projects_clone_update_link() {
    if [ ! -e "${projects_dir}" ]; then
	mkdir -p ${projects_dir}
    fi
    ansible_params="my_git_user=${git_user} \
                    my_user=${owner} \
                    my_group=${owner_group} \
                    my_mode=${mode} \
                    my_repos_path=${roles_dir} \
                    my_repos_file=${misc_dir}/vars/projects.yml \
                    debug=${playbook_debug}"
    (cd ${misc_dir} && ansible-playbook -e "${ansible_params}" \
	               ${playbook_dryrun} install-repos-from-git.yml)
    chown -R ${owner}:${owner_group} ${projects_dir}
}

# Create links
create_links() {
    ansible_params="my_base_path=${base_dir} \
                    my_mode=${mode} \
                    debug=${playbook_debug}"
    (cd ${misc_dir} && ansible-playbook -e "${ansible_params}" \
                       ${playbook_dryrun} create-links.yml)
}

# Create ansible-runner private data
runner_create_private() {
    printf "runner_dir: ${runner_dir}\n"
    if [ ! -e "${runner_dir}" ]; then
	mkdir -p ${runner_dir}
    fi
    ansible_params="my_repos_file=${misc_dir}/vars/runner.yml \
                    my_repos_path=${runner_dir} \
                    my_git_user=${git_user} \
                    my_mode=${mode} \
                    debug=${playbook_debug}"
    (cd ${misc_dir} && ansible-playbook -e "${ansible_params}" \
                       ${playbook_dryrun} create-runner-private.yml)
    chown -R ${owner}:${owner_group} ${runner_dir}
}

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
        -d|--debug)
            playbook_debug="true"
            printf "git_user: ${git_user}\n"
            printf "owner: ${owner}\n"
            printf "owner_group: ${owner_group}\n"
            printf "mode: ${mode}\n"
            printf "base_dir: ${base_dir}\n"
            printf "repos_dir: ${repos_dir}\n"
            printf "roles_dir: ${roles_dir}\n"
            printf "projects_dir: ${projects_dir}\n"
            printf "runner_dir: ${runner_dir}\n"
            printf "misc_dir: ${misc_dir}\n"
            ;;
        -n|--dry-run)
            playbook_dryrun="--check"
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
        none)
            exit 0
            ;;
        all)
            repos_clone_update_link
            roles_clone_update_link
            projects_clone_update_link
            create_links
	    runner_create_private
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

# EOF
