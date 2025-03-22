# 🐛 Ansible Template Module Bug Reproduction

This repo attempts to reproduce a potential bug in the Ansible `template` module (Ansible `core 2.18.3`), where templates are not copied or updated on the remote host — even when `force: true` is set — and no error is raised.

## 💥 The Bug (As Reported)

### Expected behavior
- If `/etc/apt/sources.list` doesn’t exist, it should be created from the template.
- If it **does** exist, it should be **overwritten** with the rendered template because `force: true` is set.

### Actual behavior (Reported)
- The file is **not** created or updated.
- Ansible reports `"changed": true`, but nothing changes.
- No error is thrown and no diff is shown.

## ✅ My Result

When running the playbook in this repo, the file **is** created or updated as expected — the bug is **not** reproduced (on my machine™).

You can use this repo to test if the issue occurs in your environment and help narrow it down.

---

## 🧪 How to Reproduce

### 1. Prerequisites

Install the required versions:

- Python `3.13.2`
- Ansible `core 2.18.3`
- Jinja2 `3.1.6`
- `libyaml = True` (enabled automatically when Ansible is installed via `pipx`)

```bash
ansible --version
python3 --version
```

If needed, install Ansible using `pipx` (recommended):

```bash
pipx install ansible
```

Or with a virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install ansible==7.4.0
```

### 2. Start the Debian Test Host

This project includes a prebuilt Debian Bookworm container with SSH enabled.

Start it using Docker Compose:

```bash
docker-compose up -d
```

This will start a container on port `2222` with password login enabled for root.

### 3. Run the Playbook

Run the following command to apply the template to the container:

```bash
ansible-playbook -i inventory playbook.yml
```

It will connect to the container over SSH and apply the template using the `template` module.

### 4. Check the Target File

Once the playbook has run, you can verify the file directly on the container:

```bash
ssh root@localhost -p 2222
cat /etc/apt/sources.list
```

You should see the rendered version of `sources.list.j2`.

---

## 🗂️ Project Structure

```
ansible-template-bug-repro/
├── ansible.cfg                 # Ansible configuration
├── docker-compose.yml          # Spawns a Debian host for testing
├── Dockerfile                  # Builds the Debian container
├── inventory                   # Inventory with connection details
├── playbook.yml                # Playbook that applies the template
├── roles/
│   └── debian/
│       ├── tasks/
│       │   └── main.yml        # Calls the template module
│       └── templates/
│           └── sources.list.j2 # Template to render
└── README.md                   # This file
```

---

## 📣 Notes

If you’re still experiencing the issue, try using this repo as a base and customize it to match your environment. Feel free to fork it and submit more insights.

---

## 🙋 Why This Exists

This repo was created in response to a bug report on the Ansible project. It aims to provide a reproducible environment to help investigate the issue.

If you can reproduce the bug using this setup, please let us know — it would help in pinpointing the root cause.

---
