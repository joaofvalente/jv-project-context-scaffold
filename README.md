# Project Context Scaffold

Give your AI assistant a memory that actually works across conversations.

## The Problem

Every time you start a new conversation with Claude (or any AI coding assistant), it starts from scratch. It doesn't remember what your project is about, what you've been working on, what decisions you've made, or what you tried that didn't work. You end up repeating yourself — explaining the same things over and over.

Claude Code does have a built-in memory, but it's limited. It stores small notes about your preferences and habits, not the rich project knowledge that helps the AI do great work — things like your architecture, past decisions, lessons learned, and where you left off yesterday.

This scaffold solves that. It creates a set of files inside your project that act as the AI's **project notebook** — always up to date, always available, maintained automatically.

## What This Does

When you install this scaffold, it creates a small folder of text files inside your project. These files give the AI:

- **A project overview** — what this project is, what technologies it uses, what the goals are
- **A current status note** — what's being worked on right now, what's blocked, what's next
- **A knowledge base** — important decisions that were made, patterns to follow, things that didn't work, technical shortcuts to fix later
- **An activity log** — a structured record of everything significant that happened, which you can use to generate reports

The AI reads the relevant files at the start of every session, so it always knows where things stand. And after doing meaningful work, it updates the files on its own — no action needed from you.

Think of it as giving the AI a shared notebook that persists between conversations. Every new conversation picks up where the last one left off.

## Getting Started

### Step 1: Open a Terminal

A terminal is the text-based interface on your computer where you can type commands. Here's how to open one:

- **Mac**: Open the app called "Terminal" (search for it in Spotlight with Cmd + Space)
- **Windows**: Open "PowerShell" or "Command Prompt" from the Start menu
- **VS Code / Cursor**: Press `` Ctrl+` `` (backtick) to open the built-in terminal at the bottom of the editor

### Step 2: Go to Your Project Folder

In the terminal, you need to navigate to the folder where your project lives. Type this command, replacing the path with your actual project location:

```
cd /path/to/your/project
```

For example, if your project is on your Desktop in a folder called "my-app":

```
cd ~/Desktop/my-app
```

> **Tip:** If you're using VS Code or Cursor, and you already have your project open, the terminal starts in the right folder automatically. You can skip this step.

### Step 3: Run the Setup

Copy and paste this command into your terminal and press Enter:

```
curl -sL https://raw.githubusercontent.com/joaofvalente/jv-project-context-scaffold/main/init.sh | bash
```

You'll see a list of files being created. That's it — the scaffold is installed.

> **Safe to run again**: If you run it a second time, it won't overwrite anything. It'll just skip the files that already exist.

### Step 4: Describe Your Project

Open the file `.context/project.md` in any text editor. You'll see placeholder sections — fill in what your project is, what technologies it uses, and what you're trying to build.

> **Easier option:** Start a Claude session in your project and say: *"Read the codebase and fill in .context/project.md for me."* Claude will look at your code and fill in the project overview automatically.

That's all the setup you need. The rest happens automatically.

### Options

The setup command supports a few options for different situations:

```bash
# Standard setup (works with Claude Code and most AI tools)
curl -sL https://raw.githubusercontent.com/joaofvalente/jv-project-context-scaffold/main/init.sh | bash

# Also add support for the Cursor editor
curl -sL https://raw.githubusercontent.com/joaofvalente/jv-project-context-scaffold/main/init.sh | bash -s -- --with-cursor

# Set up everything (Claude Code, Cursor, and universal compatibility)
curl -sL https://raw.githubusercontent.com/joaofvalente/jv-project-context-scaffold/main/init.sh | bash -s -- --all

# Minimal setup, only for Claude Code
curl -sL https://raw.githubusercontent.com/joaofvalente/jv-project-context-scaffold/main/init.sh | bash -s -- --claude-only
```

If you're not sure, the first command (no options) is fine for most people.

## How to Use It

### Starting a New Session

When you open a new Claude session in your project, the AI automatically reads the project overview and current status. You don't need to say "look at the context files" or give any special instructions — it just knows.

Try it: after setup, start a new session and ask *"What do you know about this project?"* or *"Where did we leave off?"* — the AI should have a good answer.

### Working Normally

You don't need to change how you work. Just use Claude as you normally would. The context system runs in the background.

After meaningful work — a significant decision, a completed milestone, a failed experiment — the AI updates the relevant files on its own. You'll see it editing files in the `.context/` folder, but you don't need to do anything about it.

Not every change triggers an update. The system is designed to capture things that matter, not create noise from routine edits.

### Picking Up Where You Left Off

This is the main benefit. When you come back tomorrow, or next week, or switch to a different task and come back later — the AI already knows:

- What the project is about
- What was being worked on
- What's blocked
- What's been decided
- What to do next

No more *"As I mentioned in our previous conversation..."* — the AI just knows.

### Running Multiple Tasks in Parallel

You can have several Claude sessions going at the same time, each working on different parts of the project. They all read from and write to the same context files, so they stay aware of each other's work.

For example, one session might be building a new feature while another is fixing bugs. Each one knows what the other is doing, and they won't step on each other's toes.

### Getting Reports

Every significant event gets recorded in a structured activity log. You can ask the AI to turn this into a report anytime:

- *"Give me a progress report for the last two weeks"*
- *"What decisions did we make this month?"*
- *"Summarize what happened since the last release"*
- *"Create an update I can send to the client"*
- *"What have we tried that didn't work?"*

The AI reads the log and generates whatever format you need.

### The AI Handles the Housekeeping

You don't need to manage the context files. The AI:

- Updates the current status after each work session
- Records important decisions, patterns, and lessons automatically
- Moves old entries to an archive when files get long, keeping the active files focused
- Keeps a timeline of everything significant that happened

If you're curious about what's in the files, you can always open them — they're just text files. But you never *have* to.

## Going Further

These are optional — you don't need any of this to get value from the scaffold. But once you're comfortable, they're there.

### Adding New Knowledge Topics

The scaffold starts with five knowledge categories: decisions, conventions, lessons learned, architecture, and technical debt. If your project needs more, just ask the AI:

*"Create a new knowledge file for our deployment process"*

It will create the file in the right place and add it to the index so future sessions can find it.

### Customizing the Update Rules

The rules that control when and how the AI updates context live in a file called `.context/write-policy.md`. You can edit this to match your preferences:

- Want fewer updates? Tell the AI to only record major milestones.
- Want more detail? Have it record smaller changes too.
- Want custom categories in the activity log? Add them.

Changes take effect in your next session.

### Using with Other AI Tools

This scaffold is designed for **Claude Code** first, but it works with other tools too:

- **Cursor** — Run the setup with `--with-cursor` to generate Cursor-compatible configuration files
- **GitHub Copilot, Windsurf, and 20+ other tools** — The setup creates a universal file called `AGENTS.md` that these tools understand. It points them to the same context files Claude uses.
- **Switching between tools** — All your context lives in plain text files. Any tool can read them. You won't lose anything if you switch.

---

## Under the Hood

*This section is for the curious. You don't need to read it to use the scaffold.*

### File Structure

The scaffold creates this structure inside your project:

```
your-project/
├── CLAUDE.md                              # Instructions for Claude Code
├── AGENTS.md                              # Universal instructions for other AI tools
├── .context/
│   ├── project.md                         # Project overview (always read by AI)
│   ├── state.md                           # Current status (always read by AI)
│   ├── write-policy.md                    # Rules for how the AI updates context
│   ├── knowledge/                         # Project knowledge (read when relevant)
���   │   ├── INDEX.md                       # List of available knowledge files
│   │   ├── decisions.md                   # Technical decisions and rationale
│   │   ├── conventions.md                 # Code patterns and standards
│   ��   ├── lessons.md                     # Failed approaches and why
│   │   ├── architecture.md               # System structure and data flow
│   │   └── tech-debt.md                  # Shortcuts that need fixing
│   ├── log.jsonl                          # Structured activity log (for reports)
│   └── archive/                           # Older entries (kept for history)
├── .cursor/rules/                         # Cursor configuration (optional)
└── .docs/                                 # Plans, audits, guides (on demand)
```

### Three-Tier Loading

Not all context is loaded every time — that would waste the AI's attention. Instead, files are organized into three tiers:

| Tier | What | When | Why |
|------|------|------|-----|
| **Always** | Project overview + current status | Every session | The AI always needs to know what this project is and where things stand |
| **When relevant** | Knowledge files (decisions, conventions, etc.) | When the task calls for it | No need to load architecture notes when fixing a typo |
| **On request only** | Activity log + archives | When you ask for a report | Historical data doesn't need to be in every conversation |

### Quality-Gated Writes

The AI doesn't update context after every small change. It only writes when something significant happens — a decision, a milestone, a failure, a new pattern. This keeps the context files focused and useful instead of cluttered with noise.

### Research

This architecture was informed by:
- The Codified Context paper (arXiv:2602.20478) on three-tier memory for AI-assisted development
- Claude Code's own internal memory architecture (MEMORY.md as an index pointing to topic files)
- Cursor's rule activation system (always-on, conditional, and manual modes)
- The AGENTS.md standard (Linux Foundation, adopted by 60,000+ projects and 24+ AI tools)
- Community best practices around keeping instruction files short and modular
