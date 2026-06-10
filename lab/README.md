# 🛡️ ACS Pipeline Lab — Ship Governed Agents (Build 2026)

Welcome! In ~45 minutes you'll wire up the post-Build 2026 agent governance stack in a real GitHub repo:

| Module | Build 2026 feature | What you'll do |
|---|---|---|
| 1 | **Agent Control Specification (ACS)** | Inspect + validate the agent's permission manifest |
| 2 | **ACS Gate** (GitHub Actions) | See policy enforced as a required PR check |
| 3 | **Sandboxes** | Run agent actions in per-action isolation, no network |
| 4 | **GitHub Copilot coding agent** | Put a governed agent to work on an issue |
| 5 | **Chronicle Memory** | Durable, governed agent memory with right-to-forget |

> **You're in a Codespace** — everything is pre-installed. No local setup needed.

---

## ✅ Module 0 — Verify your environment (2 min)

Open a terminal (`` Ctrl+` ``) and run:

```bash
node --version          # v22.x
gh --version            # GitHub CLI
bash lab/scripts/validate-acs.sh
```

You should see `✅ Manifest valid`. If so, you're ready.

---

## 📜 Module 1 — The ACS manifest (10 min)

The **Agent Control Specification** is the contract that governs what an agent may do. Open [.github/agent-control.yml](../.github/agent-control.yml) and find:

1. **Capabilities** — `write` allows only `lab/sample-app/**`; `deny` blocks `infra/`, workflows, and the devcontainer.
2. **Approvals** — dependency changes and secret access always escalate to a human.
3. **Sandbox** — every action runs in per-action isolation with network denied (Module 3).
4. **Memory** — Chronicle scopes with retention and right-to-forget (Module 5).

**Try it:** break the manifest (e.g., delete the `deny:` list), re-run the validator, watch it fail, then restore it:

```bash
bash lab/scripts/validate-acs.sh
git checkout .github/agent-control.yml
```

> 💡 **Key idea:** the manifest lives *in the repo*, versioned and reviewed like code — the way `dependabot.yml` declares dependency policy.

---

## ✅ Module 2 — The ACS gate in CI (10 min)

Open [.github/workflows/acs-gate.yml](../.github/workflows/acs-gate.yml). On every PR it checks:

- the manifest exists and parses,
- the PR **doesn't touch denied paths**,
- sandbox + memory governance are declared.

**Try it — negative test:**

```bash
git checkout -b test/acs-violation
echo "# tampering" >> infra/main.bicep
git add infra/main.bicep && git commit -m "test: touch a denied path"
git push -u origin test/acs-violation
gh pr create --fill
```

Watch the **ACS gate** check fail on the PR 🎉 — then clean up:

```bash
gh pr close --delete-branch test/acs-violation
git checkout main
```

---

## 📦 Module 3 — Sandboxes (8 min)

Build 2026 made **per-action sandboxed execution** the default for agent runtimes (OpenClaw on the desktop, Foundry in the cloud). Each tool call runs isolated: restricted filesystem, **no network**, hard timeout.

**Try it:**

```bash
# Allowed: runs inside the sandbox, writable path = lab/sample-app
bash lab/scripts/sandbox-run.sh "npm test"

# Blocked: network egress is denied inside the sandbox
bash lab/scripts/sandbox-run.sh "curl -s https://example.com"
```

The second command fails — exactly what `sandbox.network: deny` in the manifest promises. Check the audit trail:

```bash
bash lab/scripts/chronicle.sh audit
```

> 💡 **Key idea:** sandbox policy is *declared in ACS* and *enforced by the runtime*. The agent never gets more than the manifest grants.

---

## 🤖 Module 4 — Put a governed agent to work (10 min)

1. Create an issue in your fork:
   ```bash
   gh issue create --title "Add input validation to the contact form" \
     --body "Reject missing/invalid name, email, and message in lab/sample-app/server.js. Add a test."
   ```
2. Assign it to **Copilot** (Issues → assignee → Copilot) — the coding agent opens a PR.
3. Watch the PR: **Copilot code review** + the **ACS gate** run automatically.
4. The agent's changes stay inside `lab/sample-app/**` — the only path the manifest allows.

No Copilot coding agent on your plan? Do it manually with Copilot Chat in the Codespace — the gate works the same.

Run the app to verify:

```bash
cd lab/sample-app && npm start
# Codespaces forwards port 3000 — click the toast to open it
```

---

## 🧠 Module 5 — Chronicle Memory (8 min)

Agents that forget everything between runs repeat their mistakes. **Chronicle Memory** (Build 2026) gives agents durable, *governed* memory — with retention scopes, PII redaction, audit, and user-initiated purge.

**Try it:**

```bash
# The agent records what it learned, per scope
bash lab/scripts/chronicle.sh write repo    "npm test runs the smoke test; app entry is server.js"
bash lab/scripts/chronicle.sh write session "working issue #1: input validation for /contact"
bash lab/scripts/chronicle.sh write user    "prefers conventional commits"

# Next session, the agent recalls instead of rediscovering
bash lab/scripts/chronicle.sh read repo

# Governance in action: right-to-forget purges user scope
bash lab/scripts/chronicle.sh forget
bash lab/scripts/chronicle.sh read user      # (empty)

# Every read/write/purge is audited
bash lab/scripts/chronicle.sh audit
```

Now map what you did back to the manifest — `memory:` in [.github/agent-control.yml](../.github/agent-control.yml) declares the scopes (`session: 7d`, `repo: 90d`, `user: 30d + pii: redact`), `right_to_forget`, and `audit`. In production the store is Cosmos DB's agent-memory primitives or HorizonDB, not a local folder — the governance contract is identical.

> 💡 **Key idea:** memory is a *governed resource* like any other capability. Retention, redaction, and forgetting are policy — not afterthoughts.

---

## 🏁 You're done when…

- [ ] `validate-acs.sh` passes
- [ ] Your denied-path PR **failed** the ACS gate
- [ ] The sandbox blocked network egress
- [ ] The agent's PR touched only `lab/sample-app/**`
- [ ] You wrote, read, and purged Chronicle memory — and saw it in the audit log

## 📚 Go deeper

- The Build 2026 announcements deck: [heisenberg-alt/build-2026](https://github.com/heisenberg-alt/build-2026)

> ⚠️ **Honest caveat:** ACS, Sandboxes-as-spec, and Chronicle Memory are Build 2026 announcement narratives. The *patterns* in this lab (manifest-driven policy, path gates, isolated execution, governed memory) work today with plain GitHub + Linux primitives — which is exactly what this lab uses.
