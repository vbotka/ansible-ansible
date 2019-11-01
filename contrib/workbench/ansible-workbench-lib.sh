# All rights reserved (c) 2019, Vladimir Botka <vbotka@gmail.com>
# Simplified BSD License, https://opensource.org/licenses/BSD-2-Clause

version_lib="0.2.1-CURRENT"

my_ansible_role_dir="${roles_dir}/vbotka.ansible"
my_workbench_dir="${workbench_dir}"

my_ansible_workbench_cfg="${HOME}/.ansible-workbench.cfg"
my_ansible_cfg="${workbench_dir}/ansible.cfg"
my_ansible_hosts="${workbench_dir}/hosts"

my_dirs="${base_dir}
${repos_dir}
${roles_dir}
${projects_dir}
${runner_dir}"

my_objects="repos
roles
projects
links
runner"

my_paths="${base_dir}
${repos_dir}
${roles_dir}
${projects_dir}
${runner_dir}
${workbench_dir}
${roles_dir}/vbotka.ansible
${HOME}/.ansible-workbench.cfg
${workbench_dir}/ansible.cfg
${workbench_dir}/hosts
${workbench_dir}/vars/links.yml
${workbench_dir}/vars/projects.yml
${workbench_dir}/vars/repos.yml
${workbench_dir}/vars/roles.yml
${workbench_dir}/vars/runner.yml"

repo_clone_update() {
    if [ -e "${dir}" ]; then
        echo "[OK]  ${dir} exists"
        if message=$(cd ${dir}; git pull); then
            echo "[OK]  ${dir} updated: $message"
        else
            echo "[ERR] Can not update ${dir}: ${message}"
        fi
    else
        echo "[OK]  ${dir} does not exist"
        if message=$(git clone ${repo} ${dir}); then
            echo "[OK]  ${dir} clonned: ${message}"
        else
            echo "[ERR] Can not clone ${dir}: ${message}"
        fi
    fi
}

repo_link() {
    if [ -e "${link}" ]; then
        echo "[OK]  Link ${link} exists"
    else
        echo "[OK]  Link ${link} does not exist"
        if message=$(ln -s ${dir} ${link}); then
            echo "[OK]  Linked ${dir} to ${link}: ${message}"
        else
            echo "[ERR] Can not link ${dir} to ${link}: ${message}"
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

# TODO
link_ansible_lint_rules() {
    if [ -e "ansible-lint-rules" ]; then
        echo "[OK]  ansible-lint-rules exists"
    else
        if ln -s ${lint_dir} ansible-lint-rules; then
            echo "[OK]  ansible-lint-rules created"
        else
            echo "[ERR] Can not create ansible-lint-rules"
        fi
    fi
}

# ansible: Clone role vbotka.ansible and copy contrib/workbench -----------
ansible_role() {
    dir=${roles_dir}/vbotka.ansible
    repo="https://github.com/vbotka/ansible-ansible"
    repo_clone_update
    if [ -e "${workbench_dir}" ]; then
        echo "[OK]  ${workbench_dir} exists"
    else
        if cp -r ${roles_dir}/vbotka.ansible/contrib/workbench ${workbench_dir}; then
            echo "[OK]  ${workbench_dir} created"
        else
            echo "[ERR] Can not create ${workbench_dir}"
        fi
    fi
    if [ -e "${base_dir}/workbench" ]; then
        echo "[OK]  ${base_dir}/workbench exists"
    else
        if cd ${base_dir} && ln -s ${workbench_dir} workbench; then
            echo "[OK]  link ${base_dir}/workbench created"
        else
            echo "[ERR] Can not create link ${base_dir}/workbench"
        fi
    fi
}

# config: Copy sample configuration files if not exist --------------------
config_files() {
    create_ansible_cfg
    create_ansible_workbench_cfg
    create_hosts
}

create_ansible_workbench_cfg() {
    if [ -e "${my_ansible_workbench_cfg}" ]; then
        printf "[OK]  ${my_ansible_workbench_cfg} exists\n"
    else
	if cp ${workbench_dir}/ansible-workbench.cfg.sample ${my_ansible_workbench_cfg}; then
	    printf "[OK]  ${my_ansible_workbench_cfg} created\n"
	else
	    printf "[ERR] ${my_ansible_workbench_cfg} can not create rc:${?}"
	fi
    fi
}

create_ansible_cfg() {
    if [ -e "${my_ansible_cfg}" ]; then
        printf "[OK]  ${my_ansible_cfg} exists\n"
    else
	if cp ${workbench_dir}/ansible.cfg.sample ${my_ansible_cfg}/; then
	    printf "[OK]  ${my_ansible_cfg} created\n"
	else
	    printf "[ERR] ${my_ansible_cfg} can not create rc:${?}"
	fi
    fi
}

create_hosts() {
    if [ -e "${my_ansible_hosts}" ]; then
        printf "[OK]  ${my_ansible_hosts} exists\n"
    else
	printf "[ERR] ${my_ansible_hosts} does not exist."
    fi
} # TODO: automagic detection?

# dirs: Create directories if not exist -----------------------------------
create_dirs() {
    for dir in ${my_dirs}; do
	if [ -e "${dir}" ]; then
            printf "[OK]  ${dir} exists\n"
	else
	    if mkdir ${dir}; then
		printf "[OK]  ${dir} created\n"
	    else
		printf "[ERR]  ${dir} can not create rc:${?}"
	    fi
	fi
    done
}

# repos: Clone repositories if exist update -------------------------------
repos_clone_update_link() {
    if [ ! -e "${repos_dir}" ]; then
	mkdir -p ${repos_dir}
    fi
    ansible_params="git_module=${git_module} \
                    my_git_user=${git_user} \
                    my_user=${owner} \
                    my_group=${owner_group} \
                    my_mode=${mode} \
                    my_repos_path=${repos_dir} \
                    my_repos_file=${workbench_dir}/vars/repos.yml \
                    debug=${playbook_debug}"
    (cd ${workbench_dir} && \
	 ansible-playbook -e "${ansible_params}" ${playbook_dryrun} \
			  pb-install-repos-from-git.yml)
    chown -R ${owner}:${owner_group} ${repos_dir}
}

# roles: Clone roles if exist update --------------------------------------
roles_clone_update_link() {
    if [ ! -e "${roles_dir}" ]; then
	mkdir -p ${roles_dir}
    fi
    ansible_params="git_module=${git_module} \
                    my_git_user=${git_user} \
                    my_user=${owner} \
                    my_group=${owner_group} \
                    my_mode=${mode} \
                    my_repos_path=${roles_dir} \
                    my_repos_file=${workbench_dir}/vars/roles.yml \
                    debug=${playbook_debug}"
    (cd ${workbench_dir} && \
	 ansible-playbook -e "${ansible_params}" ${playbook_dryrun} \
			  pb-install-repos-from-git.yml)
    chown -R ${owner}:${owner_group} ${roles_dir}
}

# projects: Clone projects if exist update --------------------------------
projects_clone_update_link() {
    if [ ! -e "${projects_dir}" ]; then
	mkdir -p ${projects_dir}
    fi
    ansible_params="git_module=${git_module} \
                    my_git_user=${git_user} \
                    my_user=${owner} \
                    my_group=${owner_group} \
                    my_mode=${mode} \
                    my_repos_path=${projects_dir} \
                    my_repos_file=${workbench_dir}/vars/projects.yml \
                    debug=${playbook_debug}"
    (cd ${workbench_dir} && \
	 ansible-playbook -e "${ansible_params}" ${playbook_dryrun} \
			  pb-install-repos-from-git.yml)
    chown -R ${owner}:${owner_group} ${projects_dir}
}

# links: Create links -----------------------------------------------------
create_links() {
    ansible_params="my_base_path=${base_dir} \
                    my_mode=${mode} \
                    debug=${playbook_debug}"
    (cd ${workbench_dir} && \
	 ansible-playbook -e "${ansible_params}" ${playbook_dryrun} \
			  pb-create-links.yml)
}

# runner: Create ansible-runner projects ----------------------------------
runner_create_private() {
    printf "runner_dir: ${runner_dir}\n"
    if [ ! -e "${runner_dir}" ]; then
	mkdir -p ${runner_dir}
    fi
    ansible_params="my_repos_file=${workbench_dir}/vars/runner.yml \
                    my_repos_path=${runner_dir} \
                    my_git_user=${git_user} \
                    my_mode=${mode} \
                    debug=${playbook_debug}"
    (cd ${workbench_dir} &&
	 ansible-playbook -e "${ansible_params}" ${playbook_dryrun} \
			  pb-create-runner-private.yml)
    chown -R ${owner}:${owner_group} ${runner_dir}
}

# test: Test all ----------------------------------------------------------
install_test() {
    install_paths_test
    install_objects_test
    }

install_objects_test() {
    for object in ${my_objects}; do
	install_object_test
    done
}
    
install_object_test() {
    printf "[PB]  ${object}.\n"
    (cd ${workbench_dir}; ./ansible-workbench.sh -n ${object})
    }

install_paths_test() {
    for my_path in ${my_paths}; do
	install_path_test
    done
}
    
install_path_test() {
    if [ -e "${my_path}" ]; then
	printf "[OK]  ${my_path} exists.\n"
    else
	printf "[ERR] ${my_path} does not exist.\n"
    fi
}

# debug -------------------------------------------------------------------
print_debug() {
    printf "version: ${version}\n"
    printf "version_lib: ${version_lib}\n"
    printf "configuration file: ${my_config_file}\n"
    printf "git_module: ${git_module}\n"
    printf "git_user: ${git_user}\n"
    printf "owner: ${owner}\n"
    printf "owner_group: ${owner_group}\n"
    printf "mode: ${mode}\n"
    printf "base_dir: ${base_dir}\n"
    printf "repos_dir: ${repos_dir}\n"
    printf "roles_dir: ${roles_dir}\n"
    printf "projects_dir: ${projects_dir}\n"
    printf "runner_dir: ${runner_dir}\n"
    printf "workbench_dir: ${workbench_dir}\n"
    printf "dryrun: ${dryrun}\n"
    printf "playbook_dryrun: ${playbook_dryrun}\n"
    printf "playbook_debug: ${playbook_debug}\n"
}

# EOF
