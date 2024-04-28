#!/bin/sh

SOURCE=${HOME}/.ansible/roles/ansible-ansible/contrib/docs

USAGE="
$(basename "$0") role_path [force] [GITHUB_USERNAME] [PROJECT] [GALAXY_PROJECT] [BRANCH]

Copy docs framework from ${SOURCE} to role_path/docs. Optionally, override (force) existing \
files and replace default globals.

Example:
shell>  ./init.sh /home/admin/.ansible/roles/ansible-ansible force vbotka ansible none master
Force the framework to this docs and replace all except the Galaxy project."

EXPECTED_ARGS=1
if [ $# -lt ${EXPECTED_ARGS} ]; then
    echo "${USAGE}"
    exit
fi

DEST="${1}"
FORCE="${2:-noforce}"
GITHUB_USERNAME="${3:-none}"
PROJECT="${4:-none}"
GALAXY_PROJECT="${5:-none}"
BRANCH="${6:-none}"

DOC_DIRS="docs \
docs/annotation \
docs/annotation/vars \
docs/templates"

DOC_FILES="batch1.sh \
playbook.yml"

DOC_ANNOTATION_FILES="README \
annotation-handlers.rst.j2 \
annotation-handlers.yml.j2 \
annotation-tasks.rst.j2 \
annotation-tasks.yml.j2 \
annotation-templates.rst.j2 \
annotation-templates.yml.j2 \
pb-annotations.yml"

create_dir () {
    if [ ! -e $1 ]; then
	if (mkdir $1); then
	    printf "[OK]  dir $1 created\n"
	else
	    printf "[ERR] can not create dir $1\n"
	fi
    else
	printf "[OK]  dir $1 exists\n"
    fi
}

copy_file () {
    if [ ! -e $2 ]; then
	if (cp $1 $2); then
	    printf "[OK]  file $2 created\n"
	else
	    printf "[ERR] can not create $2\n"
	fi
    else
	printf "[OK]  file $2 exists\n"
    fi
}

force_file () {
    if (cp $1 $2); then
	printf "[OK]  file $2 forced\n"
    else
	printf "[ERR] can not force $2\n"
    fi
}

# Create dirs - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
for d in ${DOC_DIRS}; do
    create_dir ${DEST}/${d}
done

# Copy docs files
for f in ${DOC_FILES}; do
    if [ "${FORCE}" = "force" ]; then
	force_file ${SOURCE}/${f} ${DEST}/docs/${f}
    else
	copy_file ${SOURCE}/${f} ${DEST}/docs/${f}
    fi
done

# Copy annotation files - - - - - - - - - - - - - - - - - - - - - - - - - - - -
for f in ${DOC_ANNOTATION_FILES}; do
    if [ "${FORCE}" = "force" ]; then
	force_file ${SOURCE}/annotation/${f} ${DEST}/docs/annotation/${f}
    else
        copy_file ${SOURCE}/annotation/${f} ${DEST}/docs/annotation/${f}
    fi
done

# Replace globals - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "${GITHUB_USERNAME}" != "none" ]; then
    for f in ${DOC_ANNOTATION_FILES}; do
	sed -i "s/__GITHUB_USERNAME__/${GITHUB_USERNAME}/g" ${DEST}/docs/annotation/${f}
    done
fi
if [ "${PROJECT}" != "none" ]; then
    for f in ${DOC_ANNOTATION_FILES}; do
	sed -i "s/__PROJECT__/${PROJECT}/g" ${DEST}/docs/annotation/${f}
    done
fi
if [ "${GALAXY_PROJECT}" != "none" ]; then
    for f in ${DOC_ANNOTATION_FILES}; do
	sed -i "s/__GALAXY_PROJECT__/${GALAXY_PROJECT}/g" ${DEST}/docs/annotation/${f}
    done
fi
if [ "${BRANCH}" != "none" ]; then
    for f in ${DOC_ANNOTATION_FILES}; do
	sed -i "s/__BRANCH__/${BRANCH}/g" ${DEST}/docs/annotation/${f}
    done
fi

# EOF
