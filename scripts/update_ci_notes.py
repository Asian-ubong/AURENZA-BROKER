from pathlib import Path
from datetime import datetime, timezone
import os

path = Path("docs/module-progress.md")
text = path.read_text(encoding="utf-8")

status = os.getenv("CI_STATUS", "unknown")
sha = os.getenv("GITHUB_SHA", "unknown")[:12]
run = os.getenv("GITHUB_RUN_NUMBER", "unknown")
now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")

quality = "passed" if status == "success" else status
new_status = f"""- Last CI update: {now}\n- Last commit checked: `{sha}`\n- Workflow run: `{run}`\n- Quality checks: {quality}\n- Tests: {quality}\n- Web build: {quality}\n"""

start = "<!-- CI_STATUS_START -->"
end = "<!-- CI_STATUS_END -->"
if start in text and end in text:
    before, remainder = text.split(start, 1)
    _, after = remainder.split(end, 1)
    text = before + start + "\n" + new_status + end + after

log_start = "<!-- CHANGELOG_START -->"
log_end = "<!-- CHANGELOG_END -->"
entry = f"- {now} — CI {status} — commit `{sha}` — workflow run `{run}`"
if log_start in text and log_end in text:
    before, remainder = text.split(log_start, 1)
    existing, after = remainder.split(log_end, 1)
    existing = existing.strip()
    if existing.startswith("CI will append"):
        existing = ""
    text = before + log_start + "\n" + entry + ("\n" + existing if existing else "") + "\n" + log_end + after

path.write_text(text, encoding="utf-8")
