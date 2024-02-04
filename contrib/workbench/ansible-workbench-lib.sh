# All rights reserved (c) 2019-2024, Vladimir Botka <vbotka@gmail.com>
# Simplified BSD License, https://opensource.org/licenses/BSD-2-Clause

# version_lib="0.2.6-CURRENT"
version_lib="0.2.5"

my_ansible_role_dir="${roles_dir}/vbotka.ansible"
my_workbench_dir="${workbench_dir}"

my_ansible_workbench_cfg="${HOME}/.ansible-workbench.cfg"
my_ansible_cfg="${workbench_dir}/ansible.cfg"
my_ansible_hosts="${workbench_dir}/hosts"

my_dirs="${base_dir}
${repos_dir}
${roles_dir}
${collections_dir}
${projects_dir}
${runner_dir}"

my_objects="repos
roles
collections
projects
links
runner"

my_paths="${base_dir}
${repos_dir}
${roles_dir}
${collections_dir}
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

# Git clone repo if not exist else udpate repo - - - - - - - - - - - - - - - - -
repo_clone_update() {
    if [ -e "${dir}" ]; then
        printf "[OK]  ${dir} exists\n"
        if message=$(cd ${dir}; git pull); then
            printf "[OK]  ${dir} updated: $message\n"
        else
            printf "[ERR] Can not update ${dir}: ${message} rc:${?}\n"
        fi
    else
        printf "[OK]  ${dir} does not exist\n"
        if message=$(git clone ${repo} ${dir}); then
            printf "[OK]  ${dir} clonned: ${message}\n"
        else
            printf "[ERR] Can not clone ${dir}: ${message} rc:${?}\n"
        fi
    fi
}

# Create link - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
repo_link() {
    if [ -e "${link}" ]; then
        printf "[OK]  Link ${link} exists\n"
    else
        printf "[OK]  Link ${link} does not exist\n"
        if message=$(ln -s ${dir} ${link}); then
            printf "[OK]  Linked ${dir} to ${link}: ${message}\n"
        else
            printf "[ERR] Can not link ${dir} to ${link}: ${message} rc:${?}\n"
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
        printf "[OK]  ansible-lint-rules exists\n"
    else
        if ln -s ${lint_dir} ansible-lint-rules; then
            printf "[OK]  ansible-lint-rules created\n"
        else
            printf "[ERR] Can not create ansible-lint-rules rc:${?}\n"
        fi
    fi
}

# ansible: Clone role vbotka.ansible and copy contrib/workbench - - - - - - - -
ansible_role() {
    dir=${roles_dir}/vbotka.ansible
    repo="https://github.com/vbotka/ansible-ansible"
    repo_clone_update
    if [ -e "${workbench_dir}" ]; then
        printf "[OK]  ${workbench_dir} exists\n"
    else
        if cp -r ${roles_dir}/vbotka.ansible/contrib/workbench \
	      ${workbench_dir}; then
            printf "[OK]  ${workbench_dir} created\n"
        else
            printf "[ERR] Can not create ${workbench_dir} rc:${?}\n"
        fi
    fi
    if [ -e "${base_dir}/workbench" ]; then
        printf "[OK]  ${base_dir}/workbench exists\n"
    else
        if cd ${base_dir} && ln -s ${workbench_dir} workbench; then
            printf "[OK]  link ${base_dir}/workbench created\n"
        else
            printf "[ERR] Can not create link ${base_dir}/workbench rc:${?}\n"
        fi
    fi
}

# update: Update ansible-workbench from contrib/workbench - - - - - - - - - - -
ansible_update_workbench() {
    if [ "${dryrun}" = "true" ]; then
	if rsync -avrnc ${roles_dir}/vbotka.ansible/contrib/workbench/ \
		 ${workbench_dir}; then
            printf "[OK]  rsync dryrun \
${roles_dir}/vbotka.ansible/contrib/workbench/ to ${workbench_dir}\n"
	else
            printf "[ERR] Can not rsync dryrun \
${roles_dir}/vbotka.ansible/contrib/workbench/ to ${workbench_dir} rc:${?}\n"
	fi
    else
	if rsync -avr ${roles_dir}/vbotka.ansible/contrib/workbench/ \
		 ${workbench_dir}; then
            printf "[OK]  rsync \
${roles_dir}/vbotka.ansible/contrib/workbench/ to ${workbench_dir}\n"
	else
            printf "[ERR] Can not rsync \
${roles_dir}/vbotka.ansible/contrib/workbench/ to ${workbench_dir} rc:${?}\n"
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
    if [ -e "${my_ansible_workbench_cfg}" ]; then
        printf "[OK]  ${my_ansible_workbench_cfg} exists\n"
    else
	if cp ${workbench_dir}/ansible-workbench.cfg.sample \
	      ${my_ansible_workbench_cfg}; then
	    printf "[OK]  ${my_ansible_workbench_cfg} created from sample\n"
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
	    printf "[OK]  ${my_ansible_cfg} created from sample\n"
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
} # TODO: automagic OS detection?

# dirs: Create directories if not exist - - - - - - - - - - - - - - - - - - - -
create_dirs() {
    for dir in ${my_dirs}; do
	if [ -e "${dir}" ]; then
            printf "[OK]  ${dir} exists\n"
	else
	    if mkdir ${dir}; then
		printf "[OK]  ${dir} created\n"
	    else
		printf "[ERR] ${dir} can not create rc:${?}"
	    fi
	fi
    done
}

# repos: Clone repositories if exist update - - - - - - - - - - - - - - - - - -
repos_clone_update_link() {
    printf "[OK]  repos_clone_update_link: started\n"
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
    if (cd ${workbench_dir} && \
	    ansible-playbook -e "${ansible_params}" ${playbook_dryrun} \
			     pb_install_repos_from_git.yml); then
        printf "[OK]  pb_install_repos_from_git.yml: repos passed\n"
    else
        printf "[ERR] pb_install_repos_from_git.yml: repos rc:${?}\n"
    fi
    chown -R ${owner}:${owner_group} ${repos_dir}
}

# roles: Clone roles if exist update - - - - - - - - - - - - - - - - - - - - - -
roles_clone_update_link() {
    printf "[OK]  roles_clone_update_link: started\n"
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
    if (cd ${workbench_dir} && \
	    ansible-playbook -e "${ansible_params}" ${playbook_dryrun} \
			     pb_install_repos_from_git.yml); then
        printf "[OK]  pb_install_repos_from_git.yml: roles passed\n"
    else
        printf "[ERR] pb_install_repos_from_git.yml: roles rc:${?}\n"
    fi
    chown -R ${owner}:${owner_group} ${roles_dir}
}

# collections: Clone collections if exist update - - - - - - - - - - - - - - - - - - - - - -
collections_clone_update_link() {
    printf "[OK]  collections_clone_update_link: started\n"
    if [ ! -e "${collections_dir}" ]; then
	mkdir -p ${collections_dir}
    fi
    ansible_params="git_module=${git_module} \
                    my_git_user=${git_user} \
                    my_user=${owner} \
                    my_group=${owner_group} \
                    my_mode=${mode} \
                    my_repos_path=${collections_dir} \
                    my_repos_file=${workbench_dir}/vars/collections.yml \
                    debug=${playbook_debug}"
    if (cd ${workbench_dir} && \
	    ansible-playbook -e "${ansible_params}" ${playbook_dryrun} \
			     pb_install_repos_from_git.yml); then
        printf "[OK]  pb_install_repos_from_git.yml: collections passed\n"
    else
        printf "[ERR] pb_install_repos_from_git.yml: collections rc:${?}\n"
    fi
    chown -R ${owner}:${owner_group} ${collections_dir}
}

# projects: Clone projects if exist update - - - - - - - - - - - - - - - - - - -
projects_clone_update_link() {
    printf "[OK]  projects_clone_update_link: started\n"
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
    if (cd ${workbench_dir} && \
	    ansible-playbook -e "${ansible_params}" ${playbook_dryrun} \
			     pb_install_repos_from_git.yml); then
        printf "[OK]  pb_install_repos_from_git.yml: projects passed\n"
    else
        printf "[ERR] pb_install_repos_from_git.yml: projects rc:${?}\n"
    fi
    chown -R ${owner}:${owner_group} ${projects_dir}
}

# links: Create links - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
create_links() {
    printf "[OK]  create_links: started\n"
    ansible_params="my_base_path=${base_dir} \
                    my_mode=${mode} \
                    debug=${playbook_debug}"
    if (cd ${workbench_dir} && \
	    ansible-playbook -e "${ansible_params}" ${playbook_dryrun} \
			     pb_create_links.yml); then
        printf "[OK]  pb_create_links.yml: passed\n"
    else
        printf "[ERR] pb_create_links.yml: rc:${?}\n"
    fi
}

# runner: Create ansible-runner projects - - - - - - - - - - - - - - - - - - - -
runner_create_private() {
    printf "[OK]  runner_create_private: started\n"
    if [ ! -e "${runner_dir}" ]; then
	mkdir -p ${runner_dir}
    fi
    ansible_params="my_repos_file=${workbench_dir}/vars/runner.yml \
                    my_repos_path=${runner_dir} \
                    my_git_user=${git_user} \
                    my_mode=${mode} \
                    debug=${playbook_debug}"
    if (cd ${workbench_dir} &&
	    ansible-playbook -e "${ansible_params}" ${playbook_dryrun} \
			     pb_create_runner_private.yml); then
        printf "[OK]  pb_create_runner_private.yml: passed\n"
    else
        printf "[ERR] pb_create_runner_private.yml: rc:${?}\n"
    fi
    chown -R ${owner}:${owner_group} ${runner_dir}
}

# test: Test all - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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

devel_diff() {
    while read l; do
	echo $l
	diff $l $HOME/.ansible/roles/vbotka.ansible/contrib/workbench/$l
    done < FILES
}

# debug - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
