#!/usr/bin/bash

# All rights reserved (c) 2019-2024, Vladimir Botka <vbotka@gmail.com>
# Simplified BSD License, https://opensource.org/licenses/BSD-2-Clause

# version_lib="1.0.2-CURRENT"
version_lib="1.0.1"

# Git clone repo if not exist else udpate repo - - - - - - - - - - - - - - - - -
repo_clone_update() {
    if [ -e "${dir}" ]; then
        printf '%b\n' "[OK]  ${dir} exists."
        if message=$(cd "${dir}" && git pull); then
            printf '%b\n' "[OK]  ${dir} updated: $message"
        else
            printf '%b\n' "[ERR] Can not update ${dir}: ${message} rc:${?}"
        fi
    else
        printf '%b\n' "[OK]  ${dir} does not exist."
        if message=$(git clone "${repo}" "${dir}"); then
            printf '%b\n' "[OK]  ${dir} clonned: ${message}"
        else
            printf '%b\n' "[ERR] Can not clone ${dir}: ${message} rc:${?}"
        fi
    fi
}

# Create link - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
repo_link() {
    if [ -e "${link:?}" ]; then
        printf '%b\n' "[OK]  Link ${link} exists."
    else
        printf '%b\n' "[OK]  Link ${link} does not exist."
        if message=$(ln -s "${dir}" "${link}"); then
            printf '%b\n' "[OK]  Linked ${dir} to ${link}: ${message}"
        else
            printf '%b\n' "[ERR] Can not link ${dir} to ${link}: ${message} rc:${?}"
        fi
    fi
}

# repos_clone_update_link() {
#     for repo in ${git_repos}; do
#         dir=$(echo ${repo} | rev | cut -f 1 -d "/" | rev | cut -f 1 -d ".")
#         link=$(echo ${dir} | cut -f 2 -d "-" )
#         # echo "[DBG] repo: ${repo} dir: ${dir} link: ${link}"
#         (cd ${root_dir} && repo_clone_update)
#         (cd ${root_dir} && repo_link)
#         (cd ${root_dir} && chown -R ${owner}:${owner_group} ${dir})
#     done
# }

# TODO: configure lint?
link_ansible_lint_rules() {
    if [ -e "ansible-lint-rules" ]; then
        printf '%b\n' "[OK]  ansible-lint-rules exists."
    else
        if ln -s "${lint_dir:?}" ansible-lint-rules; then
            printf '%b\n' "[OK]  ansible-lint-rules created."
        else
            printf '%b\n' "[ERR] Can not create ansible-lint-rules rc:${?}"
        fi
    fi
}

# ansible: Clone role vbotka.ansible and copy contrib/workbench - - - - - - - -
ansible_role() {
    dir=${roles_dir:?}/vbotka.ansible
    repo="https://github.com/vbotka/ansible-ansible"
    repo_clone_update
    if [ -e "${workbench_dir:?}" ]; then
        printf '%b\n' "[OK]  ${workbench_dir} exists."
    else
        if cp -r "${roles_dir}/vbotka.ansible/contrib/workbench" "${workbench_dir}"; then
            printf '%b\n' "[OK]  ${workbench_dir} created."
        else
            printf '%b\n' "[ERR] Can not create ${workbench_dir} rc:${?}"
        fi
    fi
    if [ -e "${base_dir:?}/workbench" ]; then
        printf '%b\n' "[OK]  ${base_dir}/workbench exists."
    else
        if (cd "${base_dir}" && ln -s "${workbench_dir}" workbench); then
            printf '%b\n' "[OK]  link ${base_dir}/workbench created."
        else
            printf '%b\n' "[ERR] Can not create link ${base_dir}/workbench rc:${?}"
        fi
    fi
}

# update: Update ansible-workbench from contrib/workbench - - - - - - - - - - -
ansible_update_workbench() {
    if [ "${dryrun:?}" = "true" ]; then
	if rsync -avrnc "${roles_dir}/vbotka.ansible/contrib/workbench/" "${workbench_dir}"; then
            printf '%b\n' "[OK]  rsync dryrun ${roles_dir}/vbotka.ansible/contrib/workbench/ to ${workbench_dir}"
	else
            printf '%b\n' "[ERR] Can not rsync dryrun ${roles_dir}/vbotka.ansible/contrib/workbench/ to ${workbench_dir} rc:${?}"
	fi
    else
	if rsync -avr "${roles_dir}/vbotka.ansible/contrib/workbench/" "${workbench_dir}"; then
            printf '%b\n' "[OK]  rsync ${roles_dir}/vbotka.ansible/contrib/workbench/ to ${workbench_dir}"
	else
            printf '%b\n' "[ERR] Can not rsync ${roles_dir}/vbotka.ansible/contrib/workbench/ to ${workbench_dir} rc:${?}"
        fi
    fi
}

# config: Copy sample configuration files if not exist - - - - - - - - - - - - -
config_files() {
    create_ansible_cfg
    create_ansible_workbench_cfg
    create_hosts
}

create_ansible_workbench_cfg() {
    if [ -e "${my_ansible_workbench_cfg:?}" ]; then
        printf '%b\n' "[OK]  ${my_ansible_workbench_cfg} exists."
    else
	if cp "${workbench_dir}/ansible-workbench.cfg.sample" "${my_ansible_workbench_cfg}"; then
	    printf '%b\n' "[OK]  ${my_ansible_workbench_cfg} created from sample."
	else
	    printf '%b\n' "[ERR] ${my_ansible_workbench_cfg} can not create rc:${?}"
	fi
    fi
}

create_ansible_cfg() {
    if [ -e "${my_ansible_cfg:?}" ]; then
        printf '%b\n' "[OK]  ${my_ansible_cfg} exists."
    else
	if cp "${workbench_dir}/ansible.cfg.sample" "${my_ansible_cfg}/"; then
	    printf '%b\n' "[OK]  ${my_ansible_cfg} created from sample."
	else
	    printf '%b\n' "[ERR] ${my_ansible_cfg} can not create rc:${?}"
	fi
    fi
}

create_hosts() {
    if [ -e "${my_ansible_hosts:?}" ]; then
        printf '%b\n' "[OK]  ${my_ansible_hosts} exists."
    else
	printf '%b\n' "[ERR] ${my_ansible_hosts} does not exist."
    fi
} # TODO: automagic OS detection?

# dirs: Create directories if not exist - - - - - - - - - - - - - - - - - - - -
create_dirs() {
    for dir in ${my_dirs:?}; do
	if [ -e "${dir}" ]; then
            printf '%b\n' "[OK]  ${dir} exists."
	else
	    if mkdir "${dir}"; then
		printf '%b\n' "[OK]  ${dir} created."
	    else
		printf '%b\n' "[ERR] ${dir} can not create rc:${?}"
	    fi
	fi
    done
}

# repos: Clone repositories if exist update - - - - - - - - - - - - - - - - - -
repos_clone_update_link() {
    printf '%b\n' "[OK]  repos_clone_update_link: started."
    if [ ! -e "${repos_dir:?}" ]; then
	mkdir -p "${repos_dir}"
    fi
    ansible_params=(
	"-e git_module=${git_module}"
        "-e my_git_user=${git_user}"
        "-e my_user=${owner}"
        "-e my_group=${owner_group}"
        "-e my_mode=${mode}"
        "-e my_repos_path=${repos_dir}"
        "-e my_repos_file=${workbench_dir}/vars/repos.yml"
        "-e debug=${playbook_debug}"
	)
    if [ "${playbook_dryrun:?}" != "false" ]; then
	ansible_params+=("$playbook_dryrun")
    fi
    if [ "${playbook_debug}" = "true" ]; then
	printf 'ansible_params: %b\n' "${ansible_params[@]}"
    fi
    if (cd "${workbench_dir}" && ansible-playbook "${ansible_params[@]}" pb_install_repos_from_git.yml); then
        printf '%b\n' "[OK]  pb_install_repos_from_git.yml: repos passed."
    else
        printf '%b\n' "[ERR] pb_install_repos_from_git.yml: repos rc:${?}"
    fi
    chown -R "${owner}:${owner_group}" "${repos_dir}"
}

# roles: Clone roles if exist update - - - - - - - - - - - - - - - - - - - - - -
roles_clone_update_link() {
    printf '%b\n' "[OK]  roles_clone_update_link: started."
    if [ ! -e "${roles_dir}" ]; then
	mkdir -p "${roles_dir}"
    fi
    ansible_params=(
	"-e git_module=${git_module}"
        "-e my_git_user=${git_user}"
        "-e my_user=${owner}"
        "-e my_group=${owner_group}"
        "-e my_mode=${mode}"
        "-e my_repos_path=${roles_dir}"
        "-e my_repos_file=${workbench_dir}/vars/roles.yml"
        "-e debug=${playbook_debug}"
	)
    if [ "${playbook_dryrun}" != "false" ]; then
	ansible_params+=("$playbook_dryrun")
    fi
    if [ "${playbook_debug}" = "true" ]; then
	printf 'ansible_params: %b\n' "${ansible_params[@]}"
    fi
    if (cd "${workbench_dir}" && ansible-playbook "${ansible_params[@]}" pb_install_repos_from_git.yml); then
        printf '%b\n' "[OK]  pb_install_repos_from_git.yml: roles passed."
    else
        printf '%b\n' "[ERR] pb_install_repos_from_git.yml: roles rc:${?}"
    fi
    chown -R "${owner}":"${owner_group}" "${roles_dir}"
}

# collections: Clone collections if exist update - - - - - - - - - - - - - - - - - - - - - -
collections_clone_update_link() {
    printf '%b\n' "[OK]  collections_clone_update_link: started."
    if [ ! -e "${collections_dir:?}" ]; then
	mkdir -p "${collections_dir}"
    fi
    ansible_params=(
	"-e git_module=$git_module"
        "-e my_git_user=$git_user"
        "-e my_user=$owner"
        "-e my_group=$owner_group"
        "-e my_mode=$mode"
        "-e my_repos_path=$collections_dir"
        "-e my_repos_file=${workbench_dir}/vars/collections.yml"
        "-e debug=$playbook_debug"
    )
    if [ "${playbook_dryrun}" != "false" ]; then
	ansible_params+=("$playbook_dryrun")
    fi
    if [ "${playbook_debug}" = "true" ]; then
	printf 'ansible_params: %b\n' "${ansible_params[@]}"
    fi
    if (cd "$workbench_dir" && ansible-playbook "${ansible_params[@]}" pb_install_repos_from_git.yml); then
        printf '%b\n' "[OK]  pb_install_repos_from_git.yml: collections passed."
    else
        printf '%b\n' "[ERR] pb_install_repos_from_git.yml: collections rc:${?}"
    fi
    chown -R "${owner}:${owner_group}" "${collections_dir}"
}

# projects: Clone projects if exist update - - - - - - - - - - - - - - - - - - -
projects_clone_update_link() {
    printf '%b\n' "[OK]  projects_clone_update_link: started."
    if [ ! -e "${projects_dir:?}" ]; then
	mkdir -p "${projects_dir}"
    fi
    ansible_params=(
	"-e git_module=${git_module}"
        "-e my_git_user=${git_user}"
        "-e my_user=${owner}"
        "-e my_group=${owner_group}"
        "-e my_mode=${mode}"
        "-e my_repos_path=${projects_dir}"
        "-e my_repos_file=${workbench_dir}/vars/projects.yml"
        "-e debug=${playbook_debug}"
	)
    if [ "${playbook_dryrun}" != "false" ]; then
	ansible_params+=("$playbook_dryrun")
    fi
    if [ "${playbook_debug}" = "true" ]; then
	printf 'ansible_params: %b\n' "${ansible_params[@]}"
    fi
    if (cd "${workbench_dir}" && ansible-playbook "${ansible_params[@]}" pb_install_repos_from_git.yml); then
        printf '%b\n' "[OK]  pb_install_repos_from_git.yml: projects passed."
    else
        printf '%b\n' "[ERR] pb_install_repos_from_git.yml: projects rc:${?}"
    fi
    chown -R "${owner}:${owner_group}" "${projects_dir}"
}

# links: Create links - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
create_links() {
    printf '%b\n' "[OK]  create_links: started."
    ansible_params=(
	"-e my_base_path=${base_dir}"
        "-e my_mode=${mode}"
        "-e debug=${playbook_debug}"
	)
    if [ "${playbook_dryrun}" != "false" ]; then
	ansible_params+=("$playbook_dryrun")
    fi
    if [ "${playbook_debug}" = "true" ]; then
	printf 'ansible_params: %b\n' "${ansible_params[@]}"
    fi
    if (cd "${workbench_dir}" && ansible-playbook "${ansible_params[@]}" pb_create_links.yml); then
        printf '%b\n' "[OK]  pb_create_links.yml: passed"
    else
        printf '%b\n' "[ERR] pb_create_links.yml: rc:${?}"
    fi
}

# runner: Create ansible-runner projects - - - - - - - - - - - - - - - - - - - -
runner_create_private() {
    printf '%b\n' "[OK]  runner_create_private: started."
    if [ ! -e "${runner_dir:?}" ]; then
	mkdir -p "${runner_dir}"
    fi
    ansible_params=(
	"-e my_repos_file=${workbench_dir}/vars/runner.yml"
        "-e my_repos_path=${runner_dir}"
        "-e my_git_user=${git_user}"
        "-e my_mode=${mode}"
        "-e debug=${playbook_debug}"
	)
    if [ "${playbook_dryrun}" != "false" ]; then
	ansible_params+=("$playbook_dryrun")
    fi
    if [ "${playbook_debug}" = "true" ]; then
	printf 'ansible_params: %b\n' "${ansible_params[@]}"
    fi
    if (cd "${workbench_dir}" && ansible-playbook "${ansible_params[@]}" pb_create_runner_private.yml); then
        printf '%b\n' "[OK]  pb_create_runner_private.yml: passed."
    else
        printf '%b\n' "[ERR] pb_create_runner_private.yml: rc:${?}"
    fi
    chown -R "${owner}:${owner_group}" "${runner_dir}"
}

# test: Test all - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
install_test() {
    install_paths_test
    install_objects_test
    }

install_objects_test() {
    for object in ${my_objects:?}; do
	install_object_test
    done
}
    
install_object_test() {
    printf '%b\n' "[PB]  ${object}."
    cd "${workbench_dir}" && ./ansible-workbench.sh -n "${object}"
    }

install_paths_test() {
    for my_path in ${my_paths:?}; do
	install_path_test
    done
}
    
install_path_test() {
    if [ -e "${my_path}" ]; then
	printf '%b\n' "[OK]  ${my_path} exists."
    else
	printf '%b\n' "[ERR] ${my_path} does not exist."
    fi
}

devel_diff() {
    while read line; do
	printf '%b\n' "${line}"
	diff "${line}" "${HOME}/.ansible/roles/vbotka.ansible/contrib/workbench/${line}"
    done < FILES
}

# debug - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_debug() {
    printf '%b\n' "version: ${version:?}"
    printf '%b\n' "version_lib: ${version_lib}"
    printf '%b\n' "configuration file: ${my_config_file:?}"
    printf '%b\n' "git_module: ${git_module}"
    printf '%b\n' "git_user: ${git_user}"
    printf '%b\n' "owner: ${owner}"
    printf '%b\n' "owner_group: ${owner_group}"
    printf '%b\n' "mode: ${mode}"
    printf '%b\n' "base_dir: ${base_dir}"
    printf '%b\n' "repos_dir: ${repos_dir}"
    printf '%b\n' "roles_dir: ${roles_dir}"
    printf '%b\n' "projects_dir: ${projects_dir}"
    printf '%b\n' "runner_dir: ${runner_dir}"
    printf '%b\n' "workbench_dir: ${workbench_dir}"
    printf '%b\n' "dryrun: ${dryrun}"
    printf '%b\n' "playbook_dryrun: ${playbook_dryrun}"
    printf '%b\n' "playbook_debug: ${playbook_debug}"
}

# EOF
