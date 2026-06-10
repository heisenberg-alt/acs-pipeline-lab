# 👩‍🏫 Instructor Guide — Provisioning & Sharing the ACS Pipeline Lab

How to host this lab on **GitHub Codespaces** and share it with any number of users.

---

## 1. One-time setup (you, the instructor)

### a. Push the lab to GitHub

Already done if you're reading this on GitHub — this repo *is* the lab.

### b. Make the repo a template (recommended)

Repo **Settings → General → check "Template repository"**.
Users click **Use this template → Open in a codespace** and get their own isolated copy — they can create issues, PRs, and break things without touching your repo.

### c. Enable branch protection (for the full PR-gate experience)

**Settings → Branches → Add rule** for `main`:
- ✅ Require status checks to pass → add **ACS gate / validate**
- ✅ Require a pull request before merging

> Template copies don't inherit branch protection — mention this in your kickoff, or have users run Module 2 without protection (the check still runs and fails visibly on the PR).

### d. (Optional) Pre-build for instant startup

**Settings → Codespaces → Set up prebuild** on `main`. Codespaces then launch in seconds instead of minutes. Prebuilds consume Actions storage — fine for a workshop window, disable after.

---

## 2. Share with users

Give attendees ONE link. Pick the flow that matches your audience:

| Audience | Link to share |
|---|---|
| Each user gets their own copy (recommended) | `https://github.com/new?template_name=acs-pipeline-lab&template_owner=heisenberg-alt` |
| Quick demo in *your* repo | `https://codespaces.new/heisenberg-alt/acs-pipeline-lab?quickstart=1` |
| README badge | see snippet below |

**README badge snippet:**

```markdown
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/heisenberg-alt/acs-pipeline-lab?quickstart=1)
```

When the Codespace opens, [lab/README.md](lab/README.md) auto-opens (configured in [devcontainer.json](.devcontainer/devcontainer.json)) and the terminal shows a quick-reference banner.

---

## 3. What's provisioned in each Codespace

| Item | Source |
|---|---|
| Node 22 + Python 3.12 + GitHub CLI | [devcontainer.json](.devcontainer/devcontainer.json) features |
| Copilot, Copilot Chat, Actions, YAML, Mermaid extensions | `customizations.vscode.extensions` |
| Sample app deps installed + terminal banner | [post-create.sh](.devcontainer/post-create.sh) |
| Port 3000 forwarded for the sample app | `forwardPorts` |
| 2-core / 4 GB machine (cheapest tier) | `hostRequirements` |

## 4. Lab inventory

| Path | Purpose |
|---|---|
| [lab/README.md](lab/README.md) | Student guide — 5 modules, ~45 min |
| [.github/agent-control.yml](.github/agent-control.yml) | ACS manifest (capabilities, sandbox, Chronicle Memory) |
| [.github/workflows/acs-gate.yml](.github/workflows/acs-gate.yml) | Required PR check enforcing the manifest |
| [lab/scripts/validate-acs.sh](lab/scripts/validate-acs.sh) | Local manifest validator (mirrors CI) |
| [lab/scripts/sandbox-run.sh](lab/scripts/sandbox-run.sh) | Sandboxes demo — per-action isolation, network deny |
| [lab/scripts/chronicle.sh](lab/scripts/chronicle.sh) | Chronicle Memory demo — scopes, forget, audit |
| [lab/sample-app/](lab/sample-app/server.js) | The agent's playground (only writable path) |

## 5. Costs & quotas

- Codespaces is billed per core-hour to the **user's** account (or your org, if org-owned). The 2-core machine on personal accounts falls within the free monthly quota for most users.
- Workshop tip: tell users to **stop or delete** their Codespace when done (auto-stop default: 30 min idle).
- Org-owned repos: set a **spending limit** and machine-type policy under Org Settings → Codespaces.

## 6. Troubleshooting

| Symptom | Fix |
|---|---|
| `validate-acs.sh: command not found` | Run from repo root: `bash lab/scripts/validate-acs.sh` |
| PyYAML missing | `pip install pyyaml` (post-create installs it, rebuild container if needed) |
| ACS gate not appearing on PR | The workflow triggers on `pull_request` — confirm the PR targets `main` of the *same* repo (forks need Actions enabled) |
| `bwrap` not found in sandbox demo | Expected on default images — the script falls back to a restricted-env demo automatically |
| Copilot coding agent unavailable | Plan-dependent; Module 4 has a manual Copilot Chat path |
| Port 3000 toast didn't appear | Ports panel → forward 3000 manually |

## 7. Suggested workshop agenda (60 min)

| Time | Segment |
|---|---|
| 0–10 | Context: Build 2026 governance stack (use the LinkedIn diagram in [linkedin-acs-pipeline-lab.md](linkedin-acs-pipeline-lab.md)) |
| 10–15 | Everyone opens the Codespace, Module 0 |
| 15–45 | Modules 1–5 self-paced; float and help |
| 45–55 | Group debrief: who broke the gate? what did Chronicle remember? |
| 55–60 | Close: "Does it publish an ACS manifest?" as the one question to take home |
