# 🛡️ ACS Pipeline Lab — Ship Governed Agents (Build 2026)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/heisenberg-alt/acs-pipeline-lab?quickstart=1)
[![ACS gate](https://github.com/heisenberg-alt/acs-pipeline-lab/actions/workflows/acs-gate.yml/badge.svg)](https://github.com/heisenberg-alt/acs-pipeline-lab/actions/workflows/acs-gate.yml)

A hands-on, zero-setup lab for the post-Build 2026 agent governance stack:

| Build 2026 feature | What you'll do |
|---|---|
| **Agent Control Specification (ACS)** | Inspect + validate the agent's permission manifest |
| **ACS Gate** (GitHub Actions) | See policy enforced as a required PR check |
| **Sandboxes** | Run agent actions in per-action isolation, no network |
| **GitHub Copilot coding agent** | Put a governed agent to work on an issue |
| **Chronicle Memory** | Durable, governed agent memory with right-to-forget |

## 🚀 Get started (~45 min)

1. Click **Open in GitHub Codespaces** above (or **Use this template** for your own copy).
2. The lab guide opens automatically — or open [lab/README.md](lab/README.md).
3. Work through Modules 0–5.

## 👩‍🏫 Running this as a workshop?

See [lab/INSTRUCTOR-GUIDE.md](lab/INSTRUCTOR-GUIDE.md) for provisioning, sharing links, prebuilds, costs, and a 60-minute agenda.

## 📂 What's inside

| Path | Purpose |
|---|---|
| `lab/README.md` | Student guide — 5 modules |
| `lab/INSTRUCTOR-GUIDE.md` | Workshop provisioning & sharing |
| `.github/agent-control.yml` | ACS manifest (capabilities, sandbox, Chronicle Memory) |
| `.github/workflows/acs-gate.yml` | PR check enforcing the manifest |
| `lab/scripts/` | Local validator, sandbox demo, Chronicle Memory demo |
| `lab/sample-app/` | The agent's playground (only writable path) |
| `.devcontainer/` | Codespaces environment (Node 22, Python, gh CLI, Copilot) |

> ⚠️ **Honest caveat:** ACS, Sandboxes-as-spec, and Chronicle Memory are Build 2026 announcement narratives. The *patterns* here (manifest-driven policy, path gates, isolated execution, governed memory) work today with plain GitHub + Linux primitives — which is exactly what this lab uses.
