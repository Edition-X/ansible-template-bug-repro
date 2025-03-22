# 🐛 Ansible Template Module Bug Reproduction

This repo demonstrates a bug in the `template` module in Ansible `core 2.18.3`, where templates are not copied to the remote host — even with `force: true` — and no error is raised.

## 💥 The Bug

### Expected behavior:
- If `/etc/apt/sources.list` doesn’t exist, it should be created from the Jinja template.
- If it does exist, it should be **replaced** with the rendered template (because `force: true` is set).

### Actual behavior:
- The file is not created or updated, but Ansible still reports `"changed": true`.
- No errors are thrown.
- Diff is empty.

## 🧪 Reproducing

### 1. Prerequisites

Install Ansible (version `2.18.3`) and Python (tested with `3.13.2`):

```bash
python3 --version
ansible --version
```

If not already installed:

```bash
pipx install ansible
```

Or using a virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install ansible==7.4.0  # or your target version
```

### 2. Inventory

This repo expects SSH access to a Debian (Bookworm) host as `root`.  
Edit the `inventory/inventory` file to point to your target host(s).

Example:

```ini
[node]
192.168.1.10 ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa
```

### 3. Run the playbook

```bash
ansible-playbook -i inventory/inventory playbook.yml
```

> ⚠️ Make sure your SSH user has write access to `/etc/apt/sources.list`.

## 📁 Repo Structure

```
.
├── inventory/
│   └── inventory                # Your Ansible inventory file
├── roles/
│   └── sources/
│       └── templates/
│           └── sources.list.j2  # The buggy template
├── playbook.yml                 # The entry point for the test
├── ansible.cfg                  # Custom Ansible configuration
└── README.md                    # This file
```
