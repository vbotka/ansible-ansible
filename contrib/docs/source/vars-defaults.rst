Default variables
=================

The common variables for all distributions are in the file
``defaults/main.yml``. These variables can be customized in the file
``vars/main.yml``. The file ``vars/main.yml`` will be preserved by the
update of the role.

.. warning::
   * Don't make any changes to the file *defaults/main.yml*. The
     changes will be overwritten by the update of the role. Customize
     the default values in the file *vars/main.yml*.

   * Default value of *XY_passwords_debug_classified* and
     *XY_task1_debug_classified* is *False*. Passwords will be
     displayed if these variables are enabled.

.. seealso::
   * The examples of the customization ``vars/main.yml.sample``

[`defaults/main.yml <https://github.com/__GITHUB_USERNAME__/ansible-__PROJECT__/blob/master/defaults/main.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../defaults/main.yml
    :language: yaml
    :emphasize-lines: 2
    :linenos:
