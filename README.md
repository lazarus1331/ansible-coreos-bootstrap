# coreos-bootstrap

In order to effectively run ansible, the target machine needs to have a python interpreter. Coreos machines are minimal and do not ship with any version of python. To get around this limitation we can install [pypy](http://pypy.org/), a lightweight python interpreter. The coreos-bootstrap role will install pypy for us and we will update our inventory file to use the installed python interpreter.

# install
Clone the repo into your roles directory for ansible.

```
git clone https://github.com/lazarus1331/ansible-coreos-bootstrap.git roles/ansible-coreos-bootstrap
```

# Configure your project

Unlike a typical role, you need to configure Ansible to use an alternative python interpreter for coreos hosts. This can be done by adding a `coreos` group to your inventory file and setting the group's vars to use the new python interpreter. This way, you can use ansible to manage CoreOS and non-CoreOS hosts. Simply put every host that has CoreOS into the `coreos` inventory group and it will automatically use the specified python interpreter.
```
[coreos]
host-01
host-02

[coreos:vars]
ansible_ssh_user=core
ansible_python_interpreter="/home/core/bin/python"
```

This will configure ansible to use the python interpreter at `/home/core/bin/python` which will be created by the coreos-bootstrap role.

## Bootstrap Playbook

Now you can simply add the following to your playbook file and include it in your `site.yml` so that it runs on all hosts in the coreos group.

```yaml
- hosts: coreos
  gather_facts: False
  roles:
    - ansible-coreos-bootstrap
```

Make sure that `gather_facts` is set to false, otherwise ansible will try to first gather system facts using python which is not yet installed!

## Example Playbook

After bootstrap, you can use ansible docker module to manage containers.

```yaml
- name: Nginx Example
  hosts: web
  tasks:
    - name: launch nginx container
      docker:
        image: "nginx:1.7.1"
        name: "nginx"
        ports:
        - "8080:80"
        state: started
```

# License
MIT

# Credits
Based upon this repo: https://github.com/defunctzombie/ansible-coreos-bootstrap
